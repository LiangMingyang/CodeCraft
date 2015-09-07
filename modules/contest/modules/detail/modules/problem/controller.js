// Generated by CoffeeScript 1.9.3
(function() {
  var CONTEST_PAGE, HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, PROBLEM_PAGE, SUBMISSION_PAGE, SUBMIT_PAGE, fs, markdown, path, sequelize;

  sequelize = require('sequelize');

  fs = sequelize.Promise.promisifyAll(require('fs'), {
    suffix: 'Promised'
  });

  path = require('path');

  markdown = require('markdown').markdown;

  HOME_PAGE = '/';

  SUBMISSION_PAGE = 'submission';

  SUBMIT_PAGE = 'submit';

  PROBLEM_PAGE = '..';

  INDEX_PAGE = 'index';

  LOGIN_PAGE = '/user/login';

  CONTEST_PAGE = '/contest';

  exports.getIndex = function(req, res) {
    var Problem, User, currentContest, currentProblem, currentProblems, currentUser;
    User = global.db.models.user;
    Problem = global.db.models.problem;
    currentProblem = void 0;
    currentContest = void 0;
    currentProblems = void 0;
    currentUser = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return global.myUtils.findContest(user, req.params.contestID, [
        {
          model: Problem
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
      currentProblems = contest.problems;
      return global.myUtils.getProblemsStatus(currentProblems, currentUser, currentContest);
    }).then(function() {
      var i, len, order, problem;
      order = global.myUtils.lettersToNumber(req.params.problemID);
      for (i = 0, len = currentProblems.length; i < len; i++) {
        problem = currentProblems[i];
        if (problem.contest_problem_list.order === order) {
          return problem;
        }
      }
    }).then(function(problem) {
      var i, len, p, ref;
      if (!problem) {
        throw new global.myErrors.UnknownProblem();
      }
      currentProblem = problem;
      problem.test_setting = JSON.parse(problem.test_setting);
      problem.description = markdown.toHTML(problem.description);
      currentProblems = [currentProblem];
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        p = ref[i];
        p.contest_problem_list.order = global.myUtils.numberToLetters(p.contest_problem_list.order);
      }
      return res.render('problem/detail', {
        user: req.session.user,
        problem: currentProblem,
        contest: currentContest
      });
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](global.myErrors.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
    })["catch"](global.myErrors.UnknownContest, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', 'Unknown error!');
      return res.redirect(HOME_PAGE);
    });
  };

  exports.postSubmission = function(req, res) {
    var Problem, User, currentContest, currentProblem, currentUser;
    User = global.db.models.user;
    Problem = global.db.models.problem;
    currentUser = void 0;
    currentProblem = void 0;
    currentContest = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return global.myUtils.findContest(user, req.params.contestID, [
        {
          model: Problem
        }
      ]);
    }).then(function(contest) {
      var i, len, order, p, ref;
      if (!contest) {
        throw new global.myErrors.UnknownContest();
      }
      if ((new Date()) < contest.start_time || contest.end_time < (new Date())) {
        throw new global.myErrors.InvalidAccess();
      }
      currentContest = contest;
      order = global.myUtils.lettersToNumber(req.params.problemID);
      ref = contest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        p = ref[i];
        if (p.contest_problem_list.order === order) {
          return p;
        }
      }
    }).then(function(problem) {
      var form, form_code;
      if (!problem) {
        throw new global.myErrors.UnknownProblem();
      }
      currentProblem = problem;
      form = {
        lang: req.body.lang,
        code_length: req.body.code.length
      };
      form_code = {
        content: req.body.code
      };
      return global.myUtils.createSubmissionTransaction(form, form_code, currentProblem, currentUser);
    }).then(function(submission) {
      return currentContest.addSubmission(submission);
    }).then(function() {
      req.flash('info', 'submit code successfully');
      return res.redirect(SUBMISSION_PAGE);
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](global.myErrors.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
    })["catch"](global.myErrors.UnknownContest, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](global.myErrors.InvalidAccess, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', 'Unknown error!');
      return res.redirect(HOME_PAGE);
    });
  };

  exports.getSubmissions = function(req, res) {
    var Contest, Problem, User, currentContest, currentProblem, currentProblems, currentSubmissions, currentUser;
    User = global.db.models.user;
    Problem = global.db.models.problem;
    Contest = global.db.models.contest;
    currentProblem = void 0;
    currentProblems = void 0;
    currentContest = void 0;
    currentUser = void 0;
    currentSubmissions = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return global.myUtils.findContest(user, req.params.contestID, [
        {
          model: Problem
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
      currentProblems = contest.problems;
      return global.myUtils.getProblemsStatus(currentProblems, currentUser, currentContest);
    }).then(function() {
      var i, len, order, problem;
      order = global.myUtils.lettersToNumber(req.params.problemID);
      for (i = 0, len = currentProblems.length; i < len; i++) {
        problem = currentProblems[i];
        if (problem.contest_problem_list.order === order) {
          return problem;
        }
      }
    }).then(function(problem) {
      if (!problem) {
        throw new global.myErrors.UnknownProblem();
      }
      currentProblem = problem;
      return global.db.Promise.all([
        fs.readFilePromised(path.join(global.myUtils.getStaticProblem(currentProblem.id), 'manifest.json')).then(function(manifest_str) {
          var manifest;
          manifest = JSON.parse(manifest_str);
          return currentProblem.test_setting = manifest.test_setting;
        }), currentProblem.getSubmissions({
          include: [
            {
              model: User,
              as: 'creator',
              where: {
                id: (currentUser ? currentUser.id : null)
              }
            }, {
              model: Contest,
              where: {
                id: currentContest.id
              }
            }
          ],
          order: [['created_at', 'DESC'], ['id', 'DESC']],
          offset: req.query.offset,
          limit: global.config.pageLimit.submission
        }).then(function(submissions) {
          return currentSubmissions = submissions;
        })
      ]);
    }).then(function() {
      var i, len, problem, ref;
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        problem = ref[i];
        problem.contest_problem_list.order = global.myUtils.numberToLetters(problem.contest_problem_list.order);
      }
      return res.render('problem/submission', {
        submissions: currentSubmissions,
        problem: currentProblem,
        contest: currentContest,
        user: req.session.user,
        offset: req.query.offset,
        pageLimit: global.config.pageLimit.submission
      });
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](global.myErrors.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
    })["catch"](global.myErrors.UnknownContest, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', 'Unknown error!');
      return res.redirect(HOME_PAGE);
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
