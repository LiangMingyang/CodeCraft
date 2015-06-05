// Generated by CoffeeScript 1.9.2
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
    var Group, Problem, User, currentProblem;
    Problem = global.db.models.problem;
    User = global.db.models.user;
    Group = global.db.models.group;
    currentProblem = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      return myUtils.findContest(user, req.params.contestID);
    }).then(function(contest) {
      var order;
      if (!contest) {
        throw new myUtils.Error.UnknownContest();
      }
      order = myUtils.lettersToNumber(req.params.problemID);
      return myUtils.findProblemWithContest(contest, order, [
        {
          model: User,
          as: 'creator'
        }, {
          model: Group
        }
      ]);
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
      currentProblem.description = markdown.toHTML(description.toString());
      return res.render('problem/detail', {
        title: 'Problem List Page',
        user: req.session.user,
        problem: currentProblem,
        contest: req.body.contest
      });
    })["catch"](myUtils.Error.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](myUtils.Error.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', 'Unknown error!');
      return res.redirect(HOME_PAGE);
    });
  };

  exports.postSubmission = function(req, res) {
    var Group, Submission, Submission_Code, User, current_problem, current_submission, current_user, form, form_code;
    form = {
      lang: req.body.lang
    };
    form_code = {
      content: req.body.code
    };
    Submission = global.db.models.submission;
    Submission_Code = global.db.models.submission_code;
    User = global.db.models.user;
    Group = global.db.models.group;
    current_user = void 0;
    current_submission = void 0;
    current_problem = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      return myUtils.findContest(user, req.params.contestID);
    }).then(function(contest) {
      var order;
      if (!contest) {
        throw new myUtils.Error.UnknownContest();
      }
      order = myUtils.lettersToNumber(req.params.problemID);
      return myUtils.findProblemWithContest(contest, order, [
        {
          model: User,
          as: 'creator'
        }, {
          model: Group
        }
      ]);
    }).then(function(problem) {
      if (!problem) {
        throw new myUtils.Error.UnknownProblem();
      }
      current_problem = problem;
      return Submission.create(form);
    }).then(function(submission) {
      current_user.addSubmission(submission);
      current_problem.addSubmission(submission);
      current_submission = submission;
      if (req.body.contest) {
        req.body.contest.addSubmission(submission);
      }
      return Submission_Code.create(form_code);
    }).then(function(code) {
      return current_submission.setSubmission_code(code);
    }).then(function() {
      req.flash('info', 'submit code successfully');
      return res.redirect(SUBMISSION_PAGE);
    })["catch"](myUtils.Error.UnknownContest, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](myUtils.Error.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](myUtils.Error.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', 'Unknown Error!');
      return res.redirect(HOME_PAGE);
    });
  };

  exports.getSubmissions = function(req, res) {
    var Contest, Group, User, currentProblem;
    User = global.db.models.user;
    Group = global.db.models.group;
    Contest = global.db.models.contest;
    currentProblem = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      return myUtils.findContest(user, req.params.contestID);
    }).then(function(contest) {
      var order;
      if (!contest) {
        throw new myUtils.Error.UnknownContest();
      }
      order = myUtils.lettersToNumber(req.params.problemID);
      return myUtils.findProblemWithContest(contest, order, [
        {
          model: User,
          as: 'creator'
        }, {
          model: Group
        }
      ]);
    }).then(function(problem) {
      var include;
      if (!problem) {
        throw new myUtils.Error.UnknownProblem();
      }
      currentProblem = problem;
      include = [
        {
          model: User,
          as: 'creator'
        }
      ];
      if (req.body.contest) {
        include.push({
          model: Contest,
          where: {
            id: req.body.contest.id
          }
        });
      }
      return problem.getSubmissions({
        include: include,
        order: [['created_at', 'DESC']]
      });
    }).then(function(submissions) {
      return res.render('problem/submission', {
        submissions: submissions,
        problem: currentProblem,
        user: req.session.user
      });
    })["catch"](myUtils.Error.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](myUtils.Error.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
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