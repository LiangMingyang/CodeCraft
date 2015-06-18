// Generated by CoffeeScript 1.9.3
(function() {
  var CONTEST_PAGE, HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, QUESTION_PAGE, myUtils, passwordHash;

  passwordHash = require('password-hash');

  myUtils = require('./utils');

  HOME_PAGE = '/';

  CONTEST_PAGE = '..';

  INDEX_PAGE = 'index';

  QUESTION_PAGE = 'question';

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
      return myUtils.getProblemsStatus(currentProblems, currentUser, currentContest);
    }).then(function() {
      var i, len, problem;
      for (i = 0, len = currentProblems.length; i < len; i++) {
        problem = currentProblems[i];
        problem.contest_problem_list.order = myUtils.numberToLetters(problem.contest_problem_list.order);
      }
      return res.render('contest/problem', {
        user: req.session.user,
        contest: currentContest,
        problems: currentProblems
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
    var Problem, User, currentContest, currentUser;
    currentContest = void 0;
    currentUser = void 0;
    Problem = global.db.models.problem;
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
        order: [['created_at', 'DESC'], ['id', 'DESC']],
        offset: req.query.offset,
        limit: global.config.pageLimit.submission
      });
    }).then(function(submissions) {
      var dicProblemIDtoOrder, i, j, len, len1, problem, ref, submission;
      dicProblemIDtoOrder = {};
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        problem = ref[i];
        dicProblemIDtoOrder[problem.id] = myUtils.numberToLetters(problem.contest_problem_list.order);
      }
      for (j = 0, len1 = submissions.length; j < len1; j++) {
        submission = submissions[j];
        submission.problem_order = dicProblemIDtoOrder[submission.problem_id];
      }
      return res.render('contest/submission', {
        user: req.session.user,
        contest: currentContest,
        submissions: submissions,
        offset: req.query.offset,
        pageLimit: global.config.pageLimit.submission
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
    var Problem, User, currentContest, currentUser;
    currentContest = void 0;
    currentUser = void 0;
    Problem = global.db.models.problem;
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
        }, {
          model: Problem
        }
      ]);
    }).then(function(contest) {
      var i, len, problem, ref;
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
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        problem = ref[i];
        problem.contest_problem_list.order = myUtils.numberToLetters(problem.contest_problem_list.order);
      }
      return res.render('contest/question', {
        user: req.session.user,
        contest: currentContest
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

  exports.postQuestion = function(req, res) {
    var Issue, Problem, User, currentContest, currentProblem, currentUser;
    currentContest = void 0;
    currentUser = void 0;
    currentProblem = void 0;
    Problem = global.db.models.problem;
    User = global.db.models.user;
    Issue = global.db.models.issue;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      if (!user) {
        throw new myUtils.Error.UnknownUser();
      }
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
      var i, len, order, problem, ref;
      if (!contest) {
        throw new myUtils.Error.UnknownContest();
      }
      if (contest.start_time > (new Date())) {
        throw new myUtils.Error.UnknownContest();
      }
      currentContest = contest;
      order = myUtils.lettersToNumber(req.body.order);
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        problem = ref[i];
        if (problem.contest_problem_list.order === order) {
          return problem;
        }
      }
    }).then(function(problem) {
      if (!problem) {
        throw new myUtils.Error.UnknownProblem();
      }
      currentProblem = problem;
      return Issue.create({
        content: req.body.content,
        access_level: 'private'
      });
    }).then(function(issue) {
      return global.db.Promise.all([issue.setProblem(currentProblem), issue.setContest(currentContest), issue.setCreator(currentUser)]);
    }).then(function() {
      console.log("what");
      req.flash('info', 'Questioned');
      return res.redirect(QUESTION_PAGE);
    })["catch"](myUtils.Error.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](myUtils.Error.UnknownContest, myUtils.Error.InvalidAccess, myUtils.Error.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
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
