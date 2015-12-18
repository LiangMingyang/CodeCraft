// Generated by CoffeeScript 1.9.3
(function() {
  'use strict';
  angular.module('contest', ['ngRoute']).config(function($routeProvider) {
    return $routeProvider.when('/:contestId', {
      templateUrl: 'detail/contest-detail.html',
      controller: 'contest.ctrl'
    }).when('/:contestId/problems', {
      templateUrl: 'detail/detail-problem.html',
      controller: 'contest.ctrl'
    }).when('/:contestId/rank', {
      templateUrl: 'detail/detail-rank.html',
      controller: 'contest.ctrl'
    }).when('/:contestId/submissions', {
      templateUrl: 'detail/detail-submission.html',
      controller: 'contest.ctrl'
    }).when('/:contestId/issues', {
      templateUrl: 'detail/detail-issues.html',
      controller: 'contest.ctrl'
    }).otherwise({
      redirectTo: '/10'
    });
  }).filter('marked', [
    '$sce', function($sce) {
      return function(text) {
        if (!text) {
          text = "";
        }
        return $sce.trustAsHtml(markdown.toHTML(text));
      };
    }
  ]).filter('penalty', [
    function() {
      return function(date) {
        var hours, minutes, peanlty, penalty, seconds;
        if (!date) {
          return "";
        }
        penalty = new Date(date);
        peanlty = penalty.getTime();
        seconds = (peanlty - peanlty % 1000) / 1000;
        minutes = (seconds - seconds % 60) / 60;
        hours = (minutes - minutes % 60) / 60;
        minutes %= 60;
        if (minutes < 10) {
          minutes = '0' + minutes;
        }
        seconds %= 60;
        if (seconds < 10) {
          seconds = '0' + seconds;
        }
        return hours + ":" + minutes + ":" + seconds;
      };
    }
  ]).filter('wrongCount', [
    function() {
      return function(wrong_count) {
        if (!wrong_count || wrong_count === 0) {
          return "";
        }
        return "(+" + wrong_count + ")";
      };
    }
  ]).filter('result', [
    function() {
      return function(result) {
        var dic;
        dic = {
          AC: "Accepted",
          WA: "Wrong Answer",
          CE: "Compile Error",
          RE: "Runtime Error",
          REG: "Runtime Error (SIGSEGV)",
          REP: "Runtime Error (SIGFPE)",
          WT: "Waiting",
          JG: "Running",
          TLE: "Time Limit Exceed",
          MLE: "Memory Limit Exceed",
          PE: "Presentation Error",
          ERR: "Judge Error",
          IFNR: "Input File Not Ready",
          OFNR: "Output File Not Ready",
          EFNR: "Error File Not Ready",
          OE: "Other Error"
        };
        return dic[result] || "Other Error";
      };
    }
  ]).factory('Submission', function($routeParams, $http, $timeout) {
    var Poller, Sub;
    Sub = {};
    Sub.setContestId = function(newContestId) {
      if (newContestId !== Sub.contestId) {
        Sub.contestId = newContestId;
        Sub.data = [];
        return $http.get("/api/contests/" + Sub.contestId + "/submissions").then(function(res) {
          return Sub.data = res.data;
        });
      }
    };
    Sub.setContestId($routeParams.contestId || 1);
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
      if (queue.length > 0) {
        return $http.get("/api/contests/" + Sub.contestId + "/submissions").then(function(res) {
          Sub.data = res.data;
          return $timeout(Poller, 1000 + Math.random() * 1000);
        }, function() {
          return $timeout(Poller, Math.random() * 5000);
        });
      } else {
        return $timeout(Poller, Math.random() * 1000);
      }
    };
    Poller();
    Sub.submit = function(form) {
      return $http.post("/api/contests/" + Sub.contestId + "/submissions", form).then(function(res) {
        form.code = "";
        $.notify("提交成功", {
          animate: {
            enter: 'animated fadeInRight',
            exit: 'animated fadeOutRight'
          },
          type: 'success'
        });
        return Sub.data.unshift(res.data);
      }, function(res) {
        return $.notify(res.data.error, {
          animate: {
            enter: 'animated fadeInRight',
            exit: 'animated fadeOutRight'
          },
          type: 'danger'
        });
      });
    };
    return Sub;
  }).factory('Contest', function($routeParams, $http, $timeout) {
    var Contest, Poller, numberToLetters;
    Contest = {};
    Contest.setContestId = function(newContestId) {
      if (newContestId !== Contest.id) {
        Contest.id = newContestId;
        Contest.data = {
          title: "Waiting for data...",
          description: "Waiting for data..."
        };
        Contest.order = 0;
        Contest.idToOrder = {};
        return Contest.pollLife = 3;
      }
    };
    Contest.setContestId($routeParams.contestId || 1);
    Contest.active = function() {
      return Contest.pollLife = 3;
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
      if (Contest.pollLife > 0 || !Contest.data.problems || Contest.data.problems.length === 0) {
        --Contest.pollLife;
        return $http.get("/api/contests/" + Contest.id).then(function(res) {
          var contest, i, j, len, p, ref;
          contest = res.data;
          contest.problems.sort(function(a, b) {
            return a.contest_problem_list.order - b.contest_problem_list.order;
          });
          ref = contest.problems;
          for (i = j = 0, len = ref.length; j < len; i = ++j) {
            p = ref[i];
            p.test_setting = JSON.parse(p.test_setting);
            Contest.idToOrder[p.id] = i;
            p.order = numberToLetters(i);
          }
          contest.start_time = new Date(contest.start_time);
          contest.end_time = new Date(contest.end_time);
          Contest.data = contest;
          return $timeout(Poller, Math.random() * 100000);
        }, function(res) {
          $.notify(res.data.error, {
            animate: {
              enter: 'animated fadeInRight',
              exit: 'animated fadeOutRight'
            },
            type: 'danger'
          });
          return $timeout(Poller, Math.random() * 10000);
        });
      } else {
        return $timeout(Poller, 1000 + Math.random() * 1000);
      }
    };
    Poller();
    return Contest;
  }).factory('Me', function($http, $timeout) {
    var Me, Poller;
    Me = {};
    Me.data = {};
    Poller = function() {
      return $http.get("/api/users/me").then(function(res) {
        return Me.data = res.data;
      }, function(res) {
        $.notify(res.data.error, {
          animate: {
            enter: 'animated fadeInRight',
            exit: 'animated fadeOutRight'
          },
          type: 'danger'
        });
        return $timeout(Poller, Math.random() * 10000);
      });
    };
    Poller();
    return Me;
  }).factory('Issue', function($routeParams, $http, $timeout, Contest) {
    var Issue, Poller, checkUpdate, numberToLetters;
    Issue = {};
    Issue.contestId = $routeParams.contestId || 1;
    Issue.pollLife = 50;
    Issue.replyDic = void 0;
    Issue.setContestId = function(newContestId) {
      if (newContestId !== Issue.contestId) {
        Issue.data = [];
        Issue.contestId = newContestId;
        Issue.pollLife = 50;
        return Issue.replyDic = void 0;
      }
    };
    Issue.active = function() {
      return Issue.pollLife = 50;
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
            $.notify({
              title: "新的公告[" + i.id + "]:" + i.title,
              message: i.content
            }, {
              animate: {
                enter: 'animated fadeInRight',
                exit: 'animated fadeOutRight'
              },
              type: 'info',
              delay: -1
            });
          }
          Issue.replyDic[i.id] = i.issue_replies.length;
          res = true;
        }
        while (i.issue_replies.length > Issue.replyDic[i.id]) {
          $.notify({
            title: "ID为" + i.id + "的对" + (numberToLetters(Contest.idToOrder[i.problem_id])) + "的提问有新的回复:",
            message: "" + i.issue_replies[Issue.replyDic[i.id]].content
          }, {
            animate: {
              enter: 'animated fadeInRight',
              exit: 'animated fadeOutRight'
            },
            type: 'info',
            delay: -1
          });
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
      if (Issue.pollLife > 0) {
        --Issue.pollLife;
        return $http.get("/api/contests/" + Issue.contestId + "/issues").then(function(res) {
          if (checkUpdate(res.data)) {
            Issue.data = res.data;
          }
          return $timeout(Poller, 5000 + Math.random() * 5000);
        }, function() {
          return $timeout(Poller, Math.random() * 5000);
        });
      } else {
        return $timeout(Poller, 1000 + Math.random() * 1000);
      }
    };
    Poller();
    Issue.create = function(form) {
      return $http.post("/api/contests/" + Issue.contestId + "/issues", form).then(function(res) {
        form.title = "";
        form.content = "";
        $.notify("提问成功", {
          animate: {
            enter: 'animated fadeInRight',
            exit: 'animated fadeOutRight'
          },
          type: 'success'
        });
        return Issue.data.unshift(res.data);
      }, function(res) {
        return $.notify(res.data.error, {
          animate: {
            enter: 'animated fadeInRight',
            exit: 'animated fadeOutRight'
          },
          type: 'danger'
        });
      });
    };
    return Issue;
  }).factory('Rank', function($routeParams, $http, $timeout, Me) {
    var Poller, Rank, doRankStatistics;
    Rank = {};
    Rank.data = [];
    Rank.ori = "";
    Rank.statistics = {};
    Rank.contestId = $routeParams.contestId || 1;
    Rank.version = "Waiting...";
    Rank.pollLife = 3;
    Rank.setContestId = function(newContestId) {
      if (newContestId !== Rank.contestId) {
        Rank.contestId = newContestId;
        Rank.data = [];
        Rank.statistics = {};
        Rank.version = "Waiting...";
        return Rank.pollLife = 3;
      }
    };
    Rank.active = function() {
      return Rank.pollLife = 3;
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
      if (Rank.pollLife > 0) {
        --Rank.pollLife;
        return $http.get("/api/contests/" + Rank.contestId + "/rank").then(function(res) {
          if (Rank.ori !== res.data) {
            Rank.data = JSON.parse(res.data);
            Rank.statistics = doRankStatistics(Rank.data);
            Rank.ori = res.data;
          }
          Rank.version = new Date();
          return $timeout(Poller, 5000 + Math.random() * 5000);
        }, function() {
          return $timeout(Poller, Math.random() * 5000);
        });
      } else {
        return $timeout(Poller, 1000 + Math.random() * 1000);
      }
    };
    Poller();
    return Rank;
  }).factory('ServerTime', function($http, $timeout) {
    var ST, countDown;
    ST = {};
    ST.data = new Date();
    countDown = function() {
      ST.data = new Date(ST.data.getTime() + 1000);
      return $timeout(countDown, 1000);
    };
    $http.get("/api/contests/server_time").then(function(res) {
      ST.data = new Date(res.data.server_time);
      return countDown();
    });
    return ST;
  }).controller('contest.ctrl', function($scope, $routeParams, $http, $timeout, Submission, Contest, Me, Rank, ServerTime, Issue) {
    var question_list;
    $scope.order = Contest.order;
    if ($scope.form == null) {
      $scope.form = {
        lang: 'c++'
      };
    }
    $scope.Me = Me;
    $scope.ServerTime = ServerTime;
    $scope.contestId = $routeParams.contestId;
    Contest.setContestId($routeParams.contestId);
    $scope.Contest = Contest;
    Submission.setContestId($routeParams.contestId);
    $scope.Submission = Submission;
    Rank.setContestId($routeParams.contestId);
    $scope.Rank = Rank;
    Issue.setContestId($routeParams.contestId);
    $scope.Issue = Issue;
    $scope.setProblem = function(order) {
      Contest.order = order;
      $scope.order = order;
      return $timeout(function() {
        return MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
      }, 500);
    };
    $scope.isProblem = function(order) {
      return $scope.order === order;
    };
    $scope.numberToLetters = function(num) {
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
    $scope.submit = function() {
      $scope.form.order = $scope.order;
      if (!$scope.form.code || $scope.form.code.length < 10) {
        alert("代码太短了，拒绝提交");
        return;
      }
      return Submission.submit($scope.form);
    };
    $scope.accepted = function(order) {
      var res, sub;
      res = (function() {
        var j, len, ref, results;
        ref = Submission.data;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          sub = ref[j];
          if ($scope.Contest.idToOrder[sub.problem_id] === order && sub.result === 'AC') {
            results.push(sub);
          }
        }
        return results;
      })();
      return res.length !== 0;
    };
    $scope.tried = function(order) {
      var res, sub;
      res = (function() {
        var j, len, ref, results;
        ref = Submission.data;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          sub = ref[j];
          if ($scope.Contest.idToOrder[sub.problem_id] === order) {
            results.push(sub);
          }
        }
        return results;
      })();
      return res.length !== 0;
    };
    $scope.change_submission_color = function(submission, index) {
      var color, number;
      color = void 0;
      number = void 0;
      if (submission === "WT" || submission === "JG") {
        color = "green";
      } else if (submission === "AC") {
        color = "blue";
      } else {
        color = "red";
      }
      if (index % 2 === 0) {
        number = "even";
      } else {
        number = "odd";
      }
      return color + "-" + number + "-" + "tr";
    };
    $scope.change_submission_result_color = function(result) {
      switch (result) {
        case "WT":
        case "JG":
          return "green-td";
        case "AC":
          return "blue-td";
        default:
          return "red-td";
      }
    };
    $scope.check_submission_is_running = function(result) {
      return result === "WT" || result === "JG";
    };
    $scope.active = function() {
      $scope.Rank.active();
      $scope.Contest.active();
      return $scope.Issue.active();
    };
    $scope.question_form = {};
    question_list = {};
    $scope.submit_question_form = function(order) {
      $scope.question_form.order = $scope.order;
      return Issue.create($scope.question_form);
    };
    $scope.is_question = 0;
    $scope.question_title = "提问";
    $scope.show_question_area = function() {
      if ($scope.is_question === 0) {
        $scope.question_title = "收起";
        return $scope.is_question = 1;
      } else {
        $scope.is_question = 0;
        return $scope.question_title = "提问";
      }
    };
    $scope.change_question_list = function(index) {
      return question_list[index] = !!!question_list[index];
    };
    $scope.query_question_list = function(index) {
      return !!question_list[index];
    };
    $scope.table_tr_title = {
      title: "提问标题",
      nickname: "提问者",
      time: "提问时间",
      problem: "提问题目"
    };
    $scope.change_table_tr_title_to_issue = function() {
      $scope.table_tr_title.title = "公告标题";
      $scope.table_tr_title.nickname = "发布者";
      $scope.table_tr_title.time = "发布公告时间";
      return $scope.table_tr_title.problem = "公告对应题目";
    };
    $scope.change_table_tr_title_to_question = function() {
      $scope.table_tr_title.title = "提问标题";
      $scope.table_tr_title.nickname = "提问者";
      $scope.table_tr_title.time = "提问时间";
      return $scope.table_tr_title.problem = "提问题目";
    };
    return $scope.set_question_page = function(question_page) {
      $scope.question_page = question_page;
      if (question_page === 2) {
        $scope.change_table_tr_title_to_issue();
      }
      if (question_page === 0 || question_page === 1) {
        return $scope.change_table_tr_title_to_question();
      }
    };
  });

}).call(this);

//# sourceMappingURL=contest.js.map
