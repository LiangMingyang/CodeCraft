// Generated by CoffeeScript 1.10.0
(function() {
  var notify;

  notify = function(message, type, delay) {
    if (delay == null) {
      delay = -1;
    }
    return $.notify(message, {
      animate: {
        enter: 'animated fadeInRight',
        exit: 'animated fadeOutRight'
      },
      type: type,
      delay: delay
    });
  };

  angular.module('contest-factory', []).factory('Submission', function($http, $timeout) {
    var Poller, SLEEP_TIME, Sub, UP_TIME;
    Sub = {};
    Sub.data = [];
    SLEEP_TIME = 1000;
    UP_TIME = 500;
    Sub.setContestId = function(newContestId) {
      if (newContestId !== Sub.contestId) {
        Sub.contestId = newContestId;
        Sub.first_time = true;
        return Sub.data = [];
      }
    };
    Poller = function() {
      var queue, sub;
      queue = (function() {
        var j, len, ref, results;
        ref = Sub.data;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          sub = ref[j];
          if (sub.result === "WT" || sub.result === "JG") {
            results.push(sub);
          }
        }
        return results;
      })();
      if (Sub.contestId && (queue.length > 0 || Sub.first_time)) {
        Sub.first_time = false;
        return $http.get("/api/contests/" + Sub.contestId + "/submissions").then(function(res) {
          Sub.data = res.data;
          return $timeout(Poller, SLEEP_TIME + Math.random() * SLEEP_TIME);
        }, function(res) {
          notify(res.data.error, 'danger');
          return $timeout(Poller, Math.random() * SLEEP_TIME);
        });
      } else {
        return $timeout(Poller, UP_TIME);
      }
    };
    $timeout(Poller, Math.random() * UP_TIME);
    Sub.submit = function(form) {
      return $http.post("/api/contests/" + Sub.contestId + "/submissions", form).then(function(res) {
        form.code = "";
        notify("提交成功", 'success', 3);
        return Sub.data.unshift(res.data);
      }, function(res) {
        return notify(res.data.error, 'danger');
      });
    };
    return Sub;
  }).factory('Contest', function($http, $timeout) {
    var Contest, POLL_LIFE, Poller, SLEEP_TIME, UP_TIME, numberToLetters;
    Contest = {};
    POLL_LIFE = 1;
    SLEEP_TIME = 100000;
    UP_TIME = 500;
    Contest.setContestId = function(newContestId) {
      if (newContestId !== Contest.id) {
        Contest.id = newContestId;
        Contest.data = {
          title: "Waiting for data...",
          description: "Waiting for data..."
        };
        Contest.order = 0;
        Contest.idToOrder = {};
        return Contest.active();
      }
    };
    Contest.active = function() {
      return Contest.pollLife = POLL_LIFE;
    };
    numberToLetters = function(num) {
      var res;
      if (num === 0) {
        return 'A';
      }
      res = "";
      while (num > 0) {
        res = String.fromCharCode(num % 26 + 65) + res;
        num = parseInt(num / 26);
      }
      return res;
    };
    Poller = function() {
      var ref;
      if (Contest.pollLife > 0 && Contest.id && ((ref = Contest.data.problems) != null ? ref.length : void 0) === 0) {
        --Contest.pollLife;
        return $http.get("/api/contests/" + Contest.id).then(function(res) {
          var contest, i, j, len, p, ref1;
          contest = res.data;
          contest.problems.sort(function(a, b) {
            return a.contest_problem_list.order - b.contest_problem_list.order;
          });
          ref1 = contest.problems;
          for (i = j = 0, len = ref1.length; j < len; i = ++j) {
            p = ref1[i];
            p.test_setting = JSON.parse(p.test_setting);
            Contest.idToOrder[p.id] = i;
            p.order = numberToLetters(i);
          }
          contest.start_time = new Date(contest.start_time);
          contest.end_time = new Date(contest.end_time);
          Contest.data = contest;
          return $timeout(Poller, Math.random() * SLEEP_TIME);
        }, function(res) {
          notify(res.data.error, 'danger');
          return $timeout(Poller, Math.random() * SLEEP_TIME);
        });
      } else {
        return $timeout(Poller, UP_TIME);
      }
    };
    $timeout(Poller, Math.random() * UP_TIME);
    return Contest;
  }).factory('Me', function($http) {
    var Me, Poller;
    Me = {};
    Me.data = {};
    Poller = function() {
      return $http.get("/api/users/me").then(function(res) {
        return Me.data = res.data;
      }, function(res) {
        return notify(res.data.error, 'danger');
      });
    };
    Poller();
    return Me;
  }).factory('Issue', function($http, $timeout, Contest) {
    var Issue, POLL_LIFE, Poller, SLEEP_TIME, UP_TIME, checkUpdate, numberToLetters;
    Issue = {};
    POLL_LIFE = 20;
    SLEEP_TIME = 2000;
    UP_TIME = 500;
    Issue.setContestId = function(newContestId) {
      if (newContestId !== Issue.contestId) {
        Issue.data = [];
        Issue.contestId = newContestId;
        Issue.pollLife = POLL_LIFE;
        Issue.replyDic = void 0;
        return Issue.active();
      }
    };
    Issue.active = function() {
      return Issue.pollLife = POLL_LIFE;
    };
    checkUpdate = function(data) {
      var i, j, k, len, len1, res;
      if (Issue.replyDic === void 0) {
        Issue.replyDic = {};
        for (j = 0, len = data.length; j < len; j++) {
          i = data[j];
          Issue.replyDic[i.id] = i.issue_replies.length;
        }
        return true;
      }
      res = false;
      for (k = 0, len1 = data.length; k < len1; k++) {
        i = data[k];
        if (Issue.replyDic[i.id] === void 0) {
          if (i.access_level === 'public') {
            notify("新的公告[" + i.id + "]:" + i.title + ":" + i.content, 'info');
          }
          Issue.replyDic[i.id] = i.issue_replies.length;
          res = true;
        }
        while (i.issue_replies.length > Issue.replyDic[i.id]) {
          notify("ID为" + i.id + "的对" + (numberToLetters(Contest.idToOrder[i.problem_id])) + "的提问有新的回复:" + i.issue_replies[Issue.replyDic[i.id]].content, 'info');
          ++Issue.replyDic[i.id];
          res = true;
        }
        if (Issue.replyDic[i.id] !== i.issue_replies.length) {
          Issue.replyDic[i.id] = i.issue_replies.length;
          res = true;
        }
      }
      return res;
    };
    numberToLetters = function(num) {
      var res;
      if (num === 0) {
        return 'A';
      }
      res = "";
      while (num > 0) {
        res = String.fromCharCode(num % 26 + 65) + res;
        num = parseInt(num / 26);
      }
      return res;
    };
    Poller = function() {
      if (Issue.pollLife > 0 && Issue.contestId) {
        --Issue.pollLife;
        return $http.get("/api/contests/" + Issue.contestId + "/issues").then(function(res) {
          if (checkUpdate(res.data)) {
            Issue.data = res.data;
          }
          return $timeout(Poller, SLEEP_TIME + Math.random() * SLEEP_TIME);
        }, function() {
          return $timeout(Poller, Math.random() * SLEEP_TIME);
        });
      } else {
        return $timeout(Poller, UP_TIME);
      }
    };
    $timeout(Poller, Math.random() * UP_TIME);
    Issue.create = function(form) {
      return $http.post("/api/contests/" + Issue.contestId + "/issues", form).then(function(res) {
        form.title = "";
        form.content = "";
        notify("提问成功", 'success', 3);
        return Issue.data.unshift(res.data);
      }, function(res) {
        return $.notify(res.data.error, 'danger');
      });
    };
    return Issue;
  }).factory('Rank', function($http, $timeout, Me) {
    var POLL_LIFE, Poller, Rank, SLEEP_TIME, UP_TIME, doRankStatistics;
    Rank = {};
    POLL_LIFE = 1;
    SLEEP_TIME = 5000;
    UP_TIME = 500;
    Rank.setContestId = function(newContestId) {
      if (newContestId !== Rank.contestId) {
        Rank.contestId = newContestId;
        Rank.data = [];
        Rank.statistics = {};
        Rank.version = "Waiting...";
        Rank.pollLife = POLL_LIFE;
        Rank.ori = "";
        return Rank.active();
      }
    };
    Rank.active = function() {
      return Rank.pollLife = POLL_LIFE;
    };
    doRankStatistics = function(rank) {
      var acceptedPeopleCount, i, j, len, myRank, p, r, triedPeopleCount, triedSubCount;
      triedPeopleCount = {};
      acceptedPeopleCount = {};
      triedSubCount = {};
      myRank = void 0;
      for (i = j = 0, len = rank.length; j < len; i = ++j) {
        r = rank[i];
        if (r.user.id === Me.data.id) {
          myRank = i + 1;
        }
        for (p in r.detail) {
          if (acceptedPeopleCount[p] == null) {
            acceptedPeopleCount[p] = 0;
          }
          if (r.detail[p].result === 'AC') {
            ++acceptedPeopleCount[p];
          }
          if (triedPeopleCount[p] == null) {
            triedPeopleCount[p] = 0;
          }
          ++triedPeopleCount[p];
          if (triedSubCount[p] == null) {
            triedSubCount[p] = 0;
          }
          triedSubCount[p] += r.detail[p].wrong_count + 1;
        }
      }
      return {
        triedPeopleCount: triedPeopleCount,
        acceptedPeopleCount: acceptedPeopleCount,
        triedSubCount: triedSubCount,
        myRank: myRank
      };
    };
    Poller = function() {
      if (Rank.contestId && Rank.pollLife > 0) {
        --Rank.pollLife;
        return $http.get("/api/contests/" + Rank.contestId + "/rank").then(function(res) {
          if (Rank.ori !== res.data) {
            Rank.data = JSON.parse(res.data);
            Rank.statistics = doRankStatistics(Rank.data);
            Rank.ori = res.data;
          }
          Rank.version = new Date();
          return $timeout(Poller, Math.random() * SLEEP_TIME + SLEEP_TIME);
        }, function(res) {
          notify(res.data.error, 'danger');
          return $timeout(Poller, Math.random() * SLEEP_TIME);
        });
      } else {
        return $timeout(Poller, UP_TIME);
      }
    };
    $timeout(Poller, Math.random() * UP_TIME);
    return Rank;
  }).factory('ServerTime', function($http, $timeout) {
    var ST, countDown;
    ST = {};
    ST.data = new Date();
    ST.delta = 0;
    countDown = function() {
      var now;
      now = new Date();
      ST.data = new Date(now.getTime() + ST.delta);
      return $timeout(countDown, 1000);
    };
    $http.get("/api/contests/server_time").then(function(res) {
      var now, server_time;
      now = new Date();
      server_time = new Date(res.data.server_time);
      ST.delta = server_time - now;
      return countDown();
    }, function(res) {
      notify(res.data.error, 'danger');
      return countDown();
    });
    return ST;
  });

}).call(this);

//# sourceMappingURL=factory.js.map
