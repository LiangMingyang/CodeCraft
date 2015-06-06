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
    var User, currentContest, currentProblems, currentUser;
    currentContest = void 0;
    currentUser = void 0;
    currentProblems = void 0;
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
      currentContest = contest;
      if (contest.start_time > (new Date())) {
        return [];
      }
      return currentContest.getProblems();
    }).then(function(problems) {
      currentProblems = problems;
      return myUtils.getResultCount(currentUser, currentProblems, 'AC', currentContest);
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
      return myUtils.getResultCount(currentUser, currentProblems, void 0, currentContest);
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
    var User, currentContest;
    currentContest = void 0;
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
      if (contest.start_time > (new Date())) {
        return [];
      }
      currentContest = contest;
      return currentContest.getSubmissions({
        include: [
          {
            model: User,
            as: 'creator'
          }
        ]
      });
    }).then(function(submissions) {
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
    return res.render('contest/detail', {
      title: 'Rank'
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
