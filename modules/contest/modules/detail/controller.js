// Generated by CoffeeScript 1.9.3
(function() {
  var CONTEST_PAGE, HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, myUtils, passwordHash;

  passwordHash = require('password-hash');

  myUtils = require('./utils');

  HOME_PAGE = '/';

  CONTEST_PAGE = '..';

  INDEX_PAGE = 'index';

  LOGIN_PAGE = '/user/login';

  exports.getIndex = function(req, res) {
    var User;
    User = global.db.models.user;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      return myUtils.findContest(user, req.params.contestID, [
        {
          model: User,
          as: 'creator'
        }
      ]);
    }).then(function(contest) {
      if (!contest) {
        throw new myUtils.Error.UnknownContest();
      }
      return res.render('contest/detail', {
        user: req.session.user,
        contest: contest
      });
    })["catch"](myUtils.Error.UnknownContest, myUtils.Error.InvalidAccess, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };

  exports.getProblem = function(req, res) {
    var Problem, User, currentContest, currentProblems, currentUser;
    currentContest = void 0;
    currentUser = void 0;
    currentProblems = void 0;
    User = global.db.models.user;
    Problem = global.db.models.problem;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return myUtils.findContest(user, req.params.contestID, [
        {
          model: User,
          as: 'creator'
        }, {
          model: Problem
        }
      ]);
    }).then(function(contest) {
      if (!contest) {
        throw new myUtils.Error.UnknownContest();
      }
      if (contest.start_time > (new Date())) {
        throw new myUtils.Error.UnknownContest();
      }
      contest.problems.sort(function(a, b) {
        return a.contest_problem_list.order - b.contest_problem_list.order;
      });
      currentContest = contest;
      currentProblems = contest.problems;
      return myUtils.getResultPeopleCount(currentProblems, 'AC', currentContest);
    }).then(function(counts) {
      var i, j, len, len1, p, tmp;
      tmp = {};
      for (i = 0, len = counts.length; i < len; i++) {
        p = counts[i];
        tmp[p.problem_id] = p.count;
      }
      for (j = 0, len1 = currentProblems.length; j < len1; j++) {
        p = currentProblems[j];
        p.acceptedPeopleCount = 0;
        if (tmp[p.id]) {
          p.acceptedPeopleCount = tmp[p.id];
        }
      }
      return myUtils.getResultPeopleCount(currentProblems, void 0, currentContest);
    }).then(function(counts) {
      var i, j, len, len1, p, tmp;
      tmp = {};
      for (i = 0, len = counts.length; i < len; i++) {
        p = counts[i];
        tmp[p.problem_id] = p.count;
      }
      for (j = 0, len1 = currentProblems.length; j < len1; j++) {
        p = currentProblems[j];
        p.triedPeopleCount = 0;
        if (tmp[p.id]) {
          p.triedPeopleCount = tmp[p.id];
        }
      }
      return myUtils.hasResult(currentUser, currentProblems, 'AC', currentContest);
    }).then(function(counts) {
      var i, j, len, len1, p, tmp;
      tmp = {};
      for (i = 0, len = counts.length; i < len; i++) {
        p = counts[i];
        tmp[p.problem_id] = p.count;
      }
      for (j = 0, len1 = currentProblems.length; j < len1; j++) {
        p = currentProblems[j];
        p.accepted = 0;
        if (tmp[p.id]) {
          p.accepted = tmp[p.id];
        }
      }
      return myUtils.hasResult(currentUser, currentProblems, void 0, currentContest);
    }).then(function(counts) {
      var i, j, len, len1, p, tmp;
      tmp = {};
      for (i = 0, len = counts.length; i < len; i++) {
        p = counts[i];
        tmp[p.problem_id] = p.count;
      }
      for (j = 0, len1 = currentProblems.length; j < len1; j++) {
        p = currentProblems[j];
        p.tried = 0;
        if (tmp[p.id]) {
          p.tried = tmp[p.id];
        }
      }
      return currentProblems;
    }).then(function(problems) {
      var i, len, problem;
      for (i = 0, len = problems.length; i < len; i++) {
        problem = problems[i];
        problem.contest_problem_list.order = myUtils.numberToLetters(problem.contest_problem_list.order);
      }
      return res.render('contest/problem', {
        user: req.session.user,
        contest: currentContest,
        problems: problems
      });
    })["catch"](myUtils.Error.UnknownContest, myUtils.Error.InvalidAccess, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };

  exports.getSubmission = function(req, res) {
    var User, currentContest, currentUser;
    currentContest = void 0;
    currentUser = void 0;
    User = global.db.models.user;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return myUtils.findContest(user, req.params.contestID, [
        {
          model: User,
          as: 'creator'
        }
      ]);
    }).then(function(contest) {
      if (!contest) {
        throw new myUtils.Error.UnknownContest();
      }
      if (contest.start_time > (new Date())) {
        throw new myUtils.Error.UnknownContest();
      }
      currentContest = contest;
      return currentContest.getSubmissions({
        include: [
          {
            model: User,
            as: 'creator',
            where: {
              id: (currentUser ? currentUser.id : null)
            }
          }
        ],
        order: [['created_at', 'DESC']]
      });
    }).then(function(submissions) {
      var dicProblemIDtoOrder, i, j, len, len1, problem, ref, submission;
      dicProblemIDtoOrder = {};
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        problem = ref[i];
        dicProblemIDtoOrder[problem.id] = problem.contest_problem_list.order;
      }
      for (j = 0, len1 = submissions.length; j < len1; j++) {
        submission = submissions[j];
        submission.problem_order = dicProblemIDtoOrder[submission.problem_id];
      }
      return res.render('contest/submission', {
        user: req.session.user,
        contest: currentContest,
        submissions: submissions
      });
    })["catch"](myUtils.Error.UnknownContest, myUtils.Error.InvalidAccess, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };

  exports.getClarification = function(req, res) {
    return res.render('contest/detail', {
      title: 'Clarification'
    });
  };

  exports.getQuestion = function(req, res) {
    return res.render('contest/detail', {
      title: 'Question'
    });
  };

  exports.getRank = function(req, res) {
    var Problem, User, currentContest;
    User = global.db.models.user;
    Problem = global.db.models.problem;
    currentContest = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      return myUtils.findContest(user, req.params.contestID, [
        {
          model: User,
          as: 'creator'
        }, {
          model: Problem
        }
      ]);
    }).then(function(contest) {
      if (!contest) {
        throw new myUtils.Error.UnknownContest();
      }
      if (contest.start_time > (new Date())) {
        throw new myUtils.Error.UnknownContest();
      }
      currentContest = contest;
      contest.problems.sort(function(a, b) {
        return a.contest_problem_list.order - b.contest_problem_list.order;
      });
      return myUtils.getRank(currentContest);
    }).then(function(rank) {
      var i, len, problem, ref;
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        problem = ref[i];
        problem.contest_problem_list.order = myUtils.numberToLetters(problem.contest_problem_list.order);
      }
      return res.render('contest/rank', {
        user: req.session.user,
        contest: currentContest,
        rank: rank
      });
    })["catch"](myUtils.Error.UnknownContest, myUtils.Error.InvalidAccess, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
