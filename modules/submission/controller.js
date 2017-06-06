// Generated by CoffeeScript 1.10.0
(function() {
  var HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, checkSolutionAccess;

  INDEX_PAGE = 'index';

  LOGIN_PAGE = 'user/login';

  HOME_PAGE = '/';

  exports.getIndex = function(req, res) {
    var User;
    User = global.db.models.user;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      var opt;
      opt = {
        contest_id: null,
        offset: req.query.offset
      };
      return global.myUtils.findSubmissions(user, opt, [
        {
          model: User,
          as: 'creator'
        }
      ]);
    }).then(function(submissions) {
      return res.render('submission/index', {
        user: req.session.user,
        submissions: submissions,
        offset: req.query.offset,
        pageLimit: global.config.pageLimit.submission
      });
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.postIndex = function(req, res) {
    var User, opt;
    User = global.db.models.user;
    opt = {};
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      opt.offset = req.query.offset;
      if (req.body.nickname !== '') {
        opt.nickname = req.body.nickname;
      }
      if (req.body.problem_id !== '') {
        opt.problem_id = req.body.problem_id;
      }
      opt.contest_id = null;
      if (req.body.language !== '') {
        opt.language = req.body.language;
      }
      if (req.body.result !== '') {
        opt.result = req.body.result;
      }
      return global.myUtils.findSubmissions(user, opt, [
        {
          model: User,
          as: 'creator'
        }
      ]);
    }).then(function(submissions) {
      return res.render('submission/index', {
        user: req.session.user,
        submissions: submissions,
        offset: opt.offset,
        pageLimit: global.config.pageLimit.submission,
        query: req.body
      });
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.getSubmission = function(req, res) {
    var SubmissionCode, User;
    User = global.db.models.user;
    SubmissionCode = global.db.models.submission_code;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      return global.myUtils.findSubmission(user, req.params.submissionID, [
        {
          model: SubmissionCode
        }
      ]);
    }).then(function(submission) {
      if (!submission) {
        throw new global.myErrors.UnknownSubmission();
      }
      return res.render('submission/code', {
        user: req.session.user,
        submission: submission
      });
    })["catch"](global.myErrors.UnknownSubmission, function(err) {
      req.flash('info', err.message);
      return res.redirect(INDEX_PAGE);
    })["catch"](global.myErrors.UnknownUser, function(err) {
      console.error(err);
      req.flash('info', "Please Login First!");
      return res.redirect(LOGIN_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.postSubmissionApi = function(req, res) {
    var User;
    User = global.db.models.user;
    return global.db.Promise.resolve().then(function() {
      return global.myUtils.findSubmissionsInIDs(req.session.user, JSON.parse(req.body.submission_id), [
        {
          model: User,
          as: 'creator',
          attributes: ['id', 'nickname']
        }
      ]);
    }).then(function(submissions) {
      return res.json(submissions);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  checkSolutionAccess = function(submission, currentUser) {
    if (!submission) {
      throw new global.myErrors.UnknownSubmission();
    }
    if (submission.creator.id === (currentUser != null ? currentUser.id : void 0)) {
      return;
    }
    if (!submission.solution) {
      throw new global.myErrors.UnknownSubmission();
    }
    if (submission.solution.access_level === 'private') {
      throw new global.myErrors.UnknownSubmission();
    }
    if (submission.solution.access_level === 'protect' && (new Date()) < submission.solution.secret_limit) {
      throw new global.myErrors.UnknownSubmission();
    }
  };

  exports.getSolution = function(req, res) {
    var Contest, DB, Problem, Solution, Submission, SubmissionCode, User, Utils, currentUser;
    DB = global.db;
    Utils = global.myUtils;
    User = DB.models.user;
    Submission = DB.models.submission;
    Solution = DB.models.solution;
    SubmissionCode = DB.models.submission_code;
    Problem = DB.models.problem;
    Contest = DB.models.Contest;
    currentUser = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return Submission.find({
        where: {
          id: req.params.submissionID
        },
        include: [
          {
            model: SubmissionCode
          }, {
            model: User,
            as: 'creator'
          }, {
            model: Problem
          }, {
            model: Solution
          }
        ]
      });
    }).then(function(submission) {
      checkSolutionAccess(submission, currentUser);
      return res.render('submission/solution', {
        submission: submission,
        user: currentUser,
        editable: submission.creator.id === (currentUser != null ? currentUser.id : void 0)
      });
    })["catch"](global.myErrors.UnknownSubmission, function(err) {
      return res.render('error', {
        error: err
      });
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.postSolution = function(req, res) {
    var DB, Solution, User, Utils, currentSubmission, currentUser, form;
    DB = global.db;
    Utils = global.myUtils;
    User = DB.models.user;
    Solution = DB.models.solution;
    currentUser = void 0;
    currentSubmission = void 0;
    form = {};
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return Utils.findSubmission(user, req.params.submissionID, [
        {
          model: Solution
        }
      ]);
    }).then(function(submission) {
      if (!submission) {
        throw new global.myErrors.UnknownSubmission();
      }
      currentSubmission = submission;
      form = {
        source: req.body["editor-markdown-doc"],
        content: req.body["editor-html-code"],
        title: req.body["title"] || ("Solution-" + currentUser.nickname + "-" + currentUser.student_id + "-" + currentSubmission.id),
        access_level: req.body["access_level"] || "protect",
        secret_limit: req.body["secret_limit"] === '' ? new Date(new Date().getTime() + 7 * 24 * 60 * 60 * 1000) : new Date(req.body["secret_limit"]),
        category: req.body["category"],
        user_tag: req.body["user_tag"],
        practice_time: req.body["practice_time"],
        score: req.body["score"],
        influence: req.body["influence"]
      };
      currentSubmission = submission;
      if (submission.solution) {
        submission.solution.source = form.source;
        submission.solution.content = form.content;
        submission.solution.title = form.title;
        submission.solution.access_level = form.access_level;
        submission.solution.secret_limit = form.secret_limit;
        submission.solution.user_tag = form.user_tag;
        submission.solution.practice_time = form.practice_time;
        submission.solution.score = form.score;
        submission.solution.category = form.category;
        submission.solution.influence = form.influence;
        return submission.solution.save();
      } else {
        return Solution.create(form).then(function(solution) {
          return currentSubmission.setSolution(solution);
        });
      }
    }).then(function(solution) {
      req.flash('info', "保存成功");
      return res.redirect("../" + currentSubmission.id + "/solution");
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
