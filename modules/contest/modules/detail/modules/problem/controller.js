// Generated by CoffeeScript 1.9.3
(function() {
  var CONTEST_PAGE, HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, PROBLEM_PAGE, SUBMISSION_PAGE, SUBMIT_PAGE, fs, markdown, myUtils, path, sequelize;

  myUtils = require('./utils');

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
    var Problem, User, currentContest, currentProblem;
    User = global.db.models.user;
    Problem = global.db.models.problem;
    currentProblem = void 0;
    currentContest = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      return myUtils.findContest(user, req.params.contestID, [
        {
          model: Problem
        }
      ]);
    }).then(function(contest) {
      if (!contest) {
        throw new myUtils.Error.UnknownContest();
      }
      currentContest = contest;
      return contest.problems;
    }).then(function(problems) {
      var i, len, order, problem;
      order = myUtils.lettersToNumber(req.params.problemID);
      for (i = 0, len = problems.length; i < len; i++) {
        problem = problems[i];
        if (problem.contest_problem_list.order === order) {
          return problem;
        }
      }
    }).then(function(problem) {
      if (!problem) {
        throw new myUtils.Error.UnknownProblem();
      }
      currentProblem = problem;
      return fs.readFilePromised(path.join(myUtils.getStaticProblem(problem.id), 'manifest.json'));
    }).then(function(manifest_str) {
      var manifest;
      manifest = JSON.parse(manifest_str);
      currentProblem.test_setting = manifest.test_setting;
      return fs.readFilePromised(path.join(myUtils.getStaticProblem(currentProblem.id), manifest.description));
    }).then(function(description) {
      var i, len, problem, ref;
      currentProblem.description = markdown.toHTML(description.toString());
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        problem = ref[i];
        problem.contest_problem_list.order = myUtils.numberToLetters(problem.contest_problem_list.order);
      }
      return res.render('problem/detail', {
        user: req.session.user,
        problem: currentProblem,
        contest: currentContest
      });
    })["catch"](myUtils.Error.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](myUtils.Error.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
    })["catch"](myUtils.Error.UnknownContest, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', 'Unknown error!');
      return res.redirect(HOME_PAGE);
    });
  };

  exports.postSubmission = function(req, res) {
    var Problem, Submission, Submission_Code, User, currentContest, currentProblem, currentSubmission, currentUser, form, form_code;
    form = {
      lang: req.body.lang
    };
    form_code = {
      content: req.body.code
    };
    Submission = global.db.models.submission;
    Submission_Code = global.db.models.submission_code;
    User = global.db.models.user;
    Problem = global.db.models.problem;
    currentUser = void 0;
    currentSubmission = void 0;
    currentProblem = void 0;
    currentContest = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return myUtils.findContest(user, req.params.contestID, [
        {
          model: Problem
        }
      ]);
    }).then(function(contest) {
      var i, len, order, p, ref;
      if (!contest) {
        throw new myUtils.Error.UnknownContest();
      }
      currentContest = contest;
      order = myUtils.lettersToNumber(req.params.problemID);
      ref = contest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        p = ref[i];
        if (p.contest_problem_list.order === order) {
          return p;
        }
      }
    }).then(function(problem) {
      if (!problem) {
        throw new myUtils.Error.UnknownProblem();
      }
      currentProblem = problem;
      return Submission.create(form);
    }).then(function(submission) {
      currentUser.addSubmission(submission);
      currentProblem.addSubmission(submission);
      currentContest.addSubmission(submission);
      currentSubmission = submission;
      return Submission_Code.create(form_code);
    }).then(function(code) {
      return currentSubmission.setSubmission_code(code);
    }).then(function() {
      req.flash('info', 'submit code successfully');
      return res.redirect(SUBMISSION_PAGE);
    })["catch"](myUtils.Error.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](myUtils.Error.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
    })["catch"](myUtils.Error.UnknownContest, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', 'Unknown error!');
      return res.redirect(HOME_PAGE);
    });
  };

  exports.getSubmissions = function(req, res) {
    var Contest, Problem, User, currentContest, currentProblem, currentUser;
    User = global.db.models.user;
    Problem = global.db.models.problem;
    Contest = global.db.models.contest;
    currentProblem = void 0;
    currentContest = void 0;
    currentUser = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return myUtils.findContest(user, req.params.contestID, [
        {
          model: Problem
        }
      ]);
    }).then(function(contest) {
      if (!contest) {
        throw new myUtils.Error.UnknownContest();
      }
      currentContest = contest;
      return contest.problems;
    }).then(function(problems) {
      var i, len, order, problem;
      order = myUtils.lettersToNumber(req.params.problemID);
      for (i = 0, len = problems.length; i < len; i++) {
        problem = problems[i];
        if (problem.contest_problem_list.order === order) {
          return problem;
        }
      }
    }).then(function(problem) {
      if (!problem) {
        throw new myUtils.Error.UnknownProblem();
      }
      currentProblem = problem;
      return problem.getSubmissions({
        include: [
          {
            model: User,
            as: 'creator',
            where: {
              id: (currentUser ? currentUser.id : 0)
            }
          }, {
            model: Contest,
            where: {
              id: currentContest.id
            }
          }
        ],
        order: [['created_at', 'DESC']]
      });
    }).then(function(submissions) {
      var i, len, problem, ref;
      ref = currentContest.problems;
      for (i = 0, len = ref.length; i < len; i++) {
        problem = ref[i];
        problem.contest_problem_list.order = myUtils.numberToLetters(problem.contest_problem_list.order);
      }
      return res.render('problem/submission', {
        submissions: submissions,
        problem: currentProblem,
        contest: currentContest,
        user: req.session.user
      });
    })["catch"](myUtils.Error.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](myUtils.Error.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
    })["catch"](myUtils.Error.UnknownContest, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', 'Unknown error!');
      return res.redirect(HOME_PAGE);
    });
  };

  exports.getCode = function(req, res) {
    var Submission_Code;
    Submission_Code = global.db.models.submission_code;
    return Submission_Code.find(req.params.submissionID).then(function(code) {
      return res.json({
        code: code.content,
        user: req.session.user
      });
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
