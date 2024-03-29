// Generated by CoffeeScript 1.10.0
(function() {
  var CONTEST_PAGE, HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, QUESTION_PAGE, passwordHash;

  passwordHash = require('password-hash');

  HOME_PAGE = '/';

  CONTEST_PAGE = '..';

  INDEX_PAGE = 'index';

  QUESTION_PAGE = 'question';

  LOGIN_PAGE = '/user/login';

  exports.getIndex = function(req, res) {
    var Group;
    Group = global.db.models.group;
    return global.db.Promise.resolve().then(function() {
      return global.myUtils.findContest(req.session.user, req.params.contestID, [
        {
          model: Group,
          attributes: ['id', 'name']
        }
      ]);
    }).then(function(contest) {
      if (!contest) {
        throw new global.myErrors.UnknownContest();
      }
      return res.render('contest/detail', {
        user: req.session.user,
        contest: contest
      });
    })["catch"](global.myErrors.UnknownContest, global.myErrors.InvalidAccess, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.getProblem = function(req, res) {
    var Group, Problem, currentContest, currentProblems;
    currentContest = void 0;
    currentProblems = void 0;
    Problem = global.db.models.problem;
    Group = global.db.models.group;
    return global.db.Promise.resolve().then(function() {
      return global.myUtils.findContest(req.session.user, req.params.contestID, [
        {
          model: Problem,
          attributes: ['id', 'title']
        }, {
          model: Group,
          attributes: ['id', 'name']
        }
      ]);
    }).then(function(contest) {
      if (!contest) {
        throw new global.myErrors.UnknownContest();
      }
      if (contest.start_time > (new Date())) {
        throw new global.myErrors.UnknownContest();
      }
      contest.problems.sort(function(a, b) {
        return a.contest_problem_list.order - b.contest_problem_list.order;
      });
      currentContest = contest;
      currentProblems = contest.problems;
      return global.myUtils.getProblemsStatus(currentProblems, req.session.user, currentContest);
    }).then(function() {
      var i, len, problem;
      for (i = 0, len = currentProblems.length; i < len; i++) {
        problem = currentProblems[i];
        problem.contest_problem_list.order = global.myUtils.numberToLetters(problem.contest_problem_list.order);
      }
      return res.render('contest/problem', {
        user: req.session.user,
        contest: currentContest,
        problems: currentProblems
      });
    })["catch"](global.myErrors.UnknownContest, global.myErrors.InvalidAccess, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.getSubmission = function(req, res) {
    var Group, Problem, User, currentContest;
    currentContest = void 0;
    Problem = global.db.models.problem;
    User = global.db.models.user;
    Group = global.db.models.group;
    return global.db.Promise.resolve().then(function() {
      return global.myUtils.findContest(req.session.user, req.params.contestID, [
        {
          model: User,
          as: 'creator'
        }, {
          model: Problem,
          attributes: ['id']
        }, {
          model: Group,
          attributes: ['id', 'name']
        }
      ]);
    }).then(function(contest) {
      var opt;
      if (!contest) {
        throw new global.myErrors.UnknownContest();
      }
      if (contest.start_time > (new Date())) {
        throw new global.myErrors.UnknownContest();
      }
      currentContest = contest;
      opt = {
        offset: req.query.offset,
        contest_id: currentContest.id
      };
      return global.myUtils.findSubmissions(req.session.user, opt, [
        {
          model: User,
          as: 'creator'
        }
      ]);
    }).then(function(submissions) {
      var dicProblemIDtoOrder, i, j, len, len1, problem, ref, submission;
      dicProblemIDtoOrder = {};
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        problem = ref[i];
        dicProblemIDtoOrder[problem.id] = global.myUtils.numberToLetters(problem.contest_problem_list.order);
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
    })["catch"](global.myErrors.UnknownContest, global.myErrors.InvalidAccess, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.postSubmissions = function(req, res) {
    var Group, Problem, User, currentContest, dicOrdertoProblemID, dicProblemIDtoOrder;
    currentContest = void 0;
    Problem = global.db.models.problem;
    User = global.db.models.user;
    Group = global.db.models.group;
    dicProblemIDtoOrder = {};
    dicOrdertoProblemID = {};
    return global.db.Promise.resolve().then(function() {
      return global.myUtils.findContest(req.session.user, req.params.contestID, [
        {
          model: Problem,
          attributes: ['id']
        }, {
          model: Group,
          attributes: ['id', 'name']
        }
      ]);
    }).then(function(contest) {
      var i, len, opt, problem, ref;
      if (!contest) {
        throw new global.myErrors.UnknownContest();
      }
      if (contest.start_time > (new Date())) {
        throw new global.myErrors.UnknownContest();
      }
      currentContest = contest;
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        problem = ref[i];
        dicProblemIDtoOrder[problem.id] = global.myUtils.numberToLetters(problem.contest_problem_list.order);
        dicOrdertoProblemID[dicProblemIDtoOrder[problem.id]] = problem.id;
      }
      opt = {};
      opt.offset = req.query.offset;
      if (req.body.nickname !== '') {
        opt.nickname = req.body.nickname;
      }
      if (req.body.problem_order !== '') {
        opt.problem_id = dicOrdertoProblemID[req.body.problem_order];
      }
      opt.contest_id = currentContest.id;
      if (req.body.language !== '') {
        opt.language = req.body.language;
      }
      if (req.body.result !== '') {
        opt.result = req.body.result;
      }
      return global.myUtils.findSubmissions(req.session.user, opt, [
        {
          model: User,
          as: 'creator'
        }
      ]);
    }).then(function(submissions) {
      var i, len, submission;
      for (i = 0, len = submissions.length; i < len; i++) {
        submission = submissions[i];
        submission.problem_order = dicProblemIDtoOrder[submission.problem_id];
      }
      return res.render('contest/submission', {
        user: req.session.user,
        contest: currentContest,
        submissions: submissions,
        offset: req.query.offset,
        pageLimit: global.config.pageLimit.submission,
        query: req.body
      });
    });
  };

  exports.getClarification = function(req, res) {
    return res.render('contest/detail', {
      title: 'Clarification'
    });
  };

  exports.getQuestion = function(req, res) {
    var Group, Issue, Problem, User, currentContest, currentUser, dic;
    currentContest = void 0;
    currentUser = void 0;
    Problem = global.db.models.problem;
    User = global.db.models.user;
    Issue = global.db.models.issue;
    Group = global.db.models.group;
    dic = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return global.myUtils.findContest(user, req.params.contestID, [
        {
          model: User,
          as: 'creator'
        }, {
          model: Problem
        }, {
          model: Issue,
          include: [
            {
              model: User,
              as: 'creator'
            }
          ]
        }, {
          model: Group
        }
      ]);
    }).then(function(contest) {
      var i, issue, j, len, len1, problem, ref, ref1;
      if (!contest) {
        throw new global.myErrors.UnknownContest();
      }
      if (contest.start_time > (new Date())) {
        throw new global.myErrors.UnknownContest();
      }
      currentContest = contest;
      contest.problems.sort(function(a, b) {
        return a.contest_problem_list.order - b.contest_problem_list.order;
      });
      dic = {};
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        problem = ref[i];
        problem.contest_problem_list.order = global.myUtils.numberToLetters(problem.contest_problem_list.order);
        dic[problem.id] = problem.contest_problem_list.order;
      }
      ref1 = currentContest.issues;
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        issue = ref1[j];
        issue.problem_id = dic[issue.problem_id];
      }
      return res.render('contest/question', {
        user: req.session.user,
        contest: currentContest,
        issues: currentContest.issues
      });
    })["catch"](global.myErrors.UnknownContest, global.myErrors.InvalidAccess, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
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
        throw new global.myErrors.UnknownUser();
      }
      currentUser = user;
      return global.myUtils.findContest(user, req.params.contestID, [
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
        throw new global.myErrors.UnknownContest();
      }
      if (contest.start_time > (new Date())) {
        throw new global.myErrors.UnknownContest();
      }
      currentContest = contest;
      order = global.myUtils.lettersToNumber(req.body.order);
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        problem = ref[i];
        if (problem.contest_problem_list.order === order) {
          return problem;
        }
      }
    }).then(function(problem) {
      if (!problem) {
        throw new global.myErrors.UnknownProblem();
      }
      currentProblem = problem;
      return Issue.create({
        content: req.body.content,
        access_level: 'private'
      });
    }).then(function(issue) {
      return global.db.Promise.all([issue.setProblem(currentProblem), issue.setContest(currentContest), issue.setCreator(currentUser)]);
    }).then(function() {
      req.flash('info', 'Questioned');
      return res.redirect(QUESTION_PAGE);
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](global.myErrors.UnknownContest, global.myErrors.InvalidAccess, global.myErrors.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.getRank = function(req, res) {
    var Group, Problem, currentContest;
    Problem = global.db.models.problem;
    Group = global.db.models.group;
    currentContest = void 0;
    return global.db.Promise.resolve().then(function() {
      return global.myUtils.findContest(req.session.user, req.params.contestID, [
        {
          model: Problem,
          attributes: ['id']
        }, {
          model: Group,
          attributes: ['id', 'name']
        }
      ]);
    }).then(function(contest) {
      if (!contest) {
        throw new global.myErrors.UnknownContest();
      }
      if (contest.start_time > (new Date())) {
        throw new global.myErrors.UnknownContest();
      }
      currentContest = contest;
      contest.problems.sort(function(a, b) {
        return a.contest_problem_list.order - b.contest_problem_list.order;
      });
      return global.myUtils.getRank(currentContest);
    }).then(function(rank) {
      var i, len, problem, ref;
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        problem = ref[i];
        problem.contest_problem_list.order = global.myUtils.numberToLetters(problem.contest_problem_list.order);
      }
      return res.render('contest/rank', {
        user: req.session.user,
        contest: currentContest,
        rank: rank
      });
    })["catch"](global.myErrors.UnknownContest, global.myErrors.InvalidAccess, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
