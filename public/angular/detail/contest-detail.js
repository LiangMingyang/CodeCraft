// Generated by CoffeeScript 1.9.3
(function() {
  'use script';
  this.angular.module('contest-detail', ['ngRoute']).filter('marked', [
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
  ]).controller('contest-detail', function($scope, $routeParams, $http, $timeout) {
    var contestPoller, countDown, rankPoller, rankStatistics, subPoller, userPoller;
    if ($scope.contest == null) {
      $scope.contest = {
        title: "Waiting for data...",
        description: "Waiting for data..."
      };
    }
    if ($scope.idToOrder == null) {
      $scope.idToOrder = {};
    }
    if ($scope.page == null) {
      $scope.page = "description";
    }
    if ($scope.order == null) {
      $scope.order = 0;
    }
    if ($scope.form == null) {
      $scope.form = {
        lang: 'c++'
      };
    }
    if ($scope.user == null) {
      $scope.user = {
        nickname: "游客"
      };
    }
    if ($scope.server_time == null) {
      $scope.server_time = new Date();
    }
    $http.get("/api/contests/server_time").then(function(res) {
      $scope.server_time = new Date(res.data.server_time);
      return countDown();
    });
    countDown = function() {
      $scope.server_time = new Date($scope.server_time.getTime() + 1000);
      return $timeout(countDown, 1000);
    };
    userPoller = function() {
      return $http.get("/api/users/me").then(function(res) {
        $scope.user = res.data;
        return $timeout(userPoller, 10000 + Math.random() * 1000);
      }, function(res) {
        $.notify(res.data.error, {
          animate: {
            enter: 'animated fadeInRight',
            exit: 'animated fadeOutRight'
          },
          type: 'danger'
        });
        return $timeout(userPoller, Math.random() * 10000);
      });
    };
    userPoller();
    contestPoller = function() {
      return $http.get("/api/contests/" + $routeParams.contestId).then(function(res) {
        var contest, i, j, len, p, ref;
        contest = res.data;
        contest.problems.sort(function(a, b) {
          return a.contest_problem_list.order - b.contest_problem_list.order;
        });
        ref = contest.problems;
        for (i = j = 0, len = ref.length; j < len; i = ++j) {
          p = ref[i];
          p.test_setting = JSON.parse(p.test_setting);
          $scope.idToOrder[p.id] = i;
        }
        contest.start_time = new Date(contest.start_time);
        contest.end_time = new Date(contest.end_time);
        return $scope.contest = contest;
      }, function(res) {
        if (!$scope.user.id) {
          res.data.error = "该比赛需要登录才可以查看";
        }
        $.notify(res.data.error, {
          animate: {
            enter: 'animated fadeInRight',
            exit: 'animated fadeOutRight'
          },
          type: 'danger'
        });
        return $timeout(contestPoller, Math.random() * 10000);
      });
    };
    contestPoller();
    $scope.rank = [];
    rankPoller = function() {
      return $http.get("/api/contests/" + $routeParams.contestId + "/rank").then(function(res) {
        $scope.rank = JSON.parse(res.data);
        $scope.rankStatistics = rankStatistics($scope.rank);
        return $timeout(rankPoller, 5000 + Math.random() * 5000);
      }, function(res) {
        return $timeout(rankPoller, Math.random() * 10000);
      });
    };
    rankPoller();
    $scope.submissions = [];
    subPoller = function() {
      return $http.get("/api/contests/" + $routeParams.contestId + "/submissions").then(function(res) {
        $scope.submissions = res.data;
        return $timeout(subPoller, 1000 + Math.random() * 1000);
      }, function() {
        return $timeout(subPoller, Math.random() * 5000);
      });
    };
    subPoller();
    $scope.setPage = function(page) {
      return $scope.page = page;
    };
    $scope.isPage = function(page) {
      return page === $scope.page;
    };
    $scope.setProblem = function(order) {
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
    $scope.submit = function(order) {
      $scope.form.order = order;
      if (!$scope.form.code || $scope.form.code.length < 10) {
        alert("代码太短了，拒绝提交");
        return;
      }
      return $http.post("/api/contests/" + $routeParams.contestId + "/submissions", $scope.form).then(function() {
        $scope.form.code = "";
        return $.notify("提交成功", {
          animate: {
            enter: 'animated fadeInRight',
            exit: 'animated fadeOutRight'
          },
          type: 'success'
        });
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
    $scope.accepted = function(order) {
      var res, sub;
      res = (function() {
        var j, len, ref, results;
        ref = $scope.submissions;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          sub = ref[j];
          if ($scope.idToOrder[sub.problem_id] === order && sub.result === 'AC') {
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
        ref = $scope.submissions;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          sub = ref[j];
          if ($scope.idToOrder[sub.problem_id] === order) {
            results.push(sub);
          }
        }
        return results;
      })();
      return res.length !== 0;
    };
    $scope.change_submission_color = function(submission, index) {
      if (submission === "WT" || submission === "JG") {
        return "green-tr";
      }
      if (submission === "AC") {
        return "blue-tr";
      }
      return "red-tr";
    };
    return rankStatistics = function(rank) {
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
  });

}).call(this);

//# sourceMappingURL=contest-detail.js.map
