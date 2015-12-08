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
    }).otherwise({
      redirectTo: '/1'
    });
  }).filter('marked', [
    '$sce', function($sce) {
      return function(text) {
        if (!text) {
          text = "";
        }
        return $sce.trustAsHtml(marked(text));
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
    var Contest, Poller;
    Contest = {};
    Contest.id = $routeParams.contestId || 1;
    Contest.order = 0;
    Contest.idToOrder = {};
    Contest.data = {
      title: "Waiting for data...",
      description: "Waiting for data..."
    };
    Contest.setContestId = function(newContestId) {
      if (newContestId !== Contest.id) {
        Contest.id = newContestId;
        Contest.data = {
          title: "Waiting for data...",
          description: "Waiting for data..."
        };
        Contest.order = 0;
        return Poller();
      }
    };
    Poller = function() {
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
        }
        contest.start_time = new Date(contest.start_time);
        contest.end_time = new Date(contest.end_time);
        return Contest.data = contest;
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
    return Contest;
  }).factory('Me', function($http, $timeout) {
    var Me, Poller;
    Me = {};
    Me.data = {};
    Poller = function() {
      return $http.get("/api/users/me").then(function(res) {
        Me.data = res.data;
        return $timeout(Poller, 10000 + Math.random() * 1000);
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
  }).factory('Rank', function($routeParams, $http, $timeout) {
    var Poller, Rank, doRankStatistics;
    Rank = {};
    Rank.data = [];
    Rank.ori = "";
    Rank.statistics = {};
    Rank.contestId = $routeParams.contestId || 1;
    Rank.setContestId = function(newContestId) {
      if (newContestId !== Rank.contestId) {
        Rank.contestId = newContestId;
        Rank.data = [];
        return Rank.statistics = {};
      }
    };
    doRankStatistics = function(rank) {
      var acceptedPeopleCount, j, len, p, r, triedPeopleCount, triedSubCount;
      triedPeopleCount = {};
      acceptedPeopleCount = {};
      triedSubCount = {};
      for (j = 0, len = rank.length; j < len; j++) {
        r = rank[j];
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
        triedSubCount: triedSubCount
      };
    };
    Poller = function() {
      return $http.get("/api/contests/" + Rank.contestId + "/rank").then(function(res) {
        if (Rank.ori !== res.data) {
          Rank.data = JSON.parse(res.data);
          Rank.statistics = doRankStatistics(Rank.data);
          Rank.ori = res.data;
        }
        return $timeout(Poller, 5000 + Math.random() * 5000);
      }, function() {
        return $timeout(Poller, Math.random() * 5000);
      });
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
  }).controller('contest.ctrl', function($scope, $routeParams, $http, $timeout, Submission, Contest, Me, Rank, ServerTime) {
    if ($scope.page == null) {
      $scope.page = "description";
    }
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
    return $scope.check_submission_is_running = function(result) {
      return result === "WT" || result === "JG";
    };
  });

}).call(this);

//# sourceMappingURL=contest.js.map
