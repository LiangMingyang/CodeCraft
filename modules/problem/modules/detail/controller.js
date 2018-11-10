// Generated by CoffeeScript 1.12.6
(function() {
  var HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, PROBLEM_PAGE, SUBMISSION_PAGE, SUBMIT_PAGE, fs, markdown, path, postSubmissions, sequelize;

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

  exports.getCreateSolution = function(req, res) {
    var Problem, Solution, Submission, User, currentProblem, currentProblems, currentSubmissions, currentUser, opt;
    User = global.db.models.user;
    Solution = global.db.models.solution;
    Submission = global.db.models.submission;
    Problem = global.db.models.problem;
    currentProblem = void 0;
    currentUser = void 0;
    currentProblems = void 0;
    currentSubmissions = void 0;
    opt = {};
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return Problem.find({
        where: {
          id: req.params.problemID
        }
      });
    }).then(function(problem) {
      if (!problem) {
        throw new global.myErrors.UnknownProblem();
      }
      currentProblem = problem;
      currentProblems = [problem];
      return global.myUtils.getProblemsStatus(currentProblems, currentUser);
    }).then(function() {
      opt.creator_id = currentUser != null ? currentUser.id : void 0;
      opt.problem_id = currentProblem.id;
      opt.result = 'AC';
      return Submission.findAll({
        where: opt,
        include: [
          {
            model: User,
            as: 'creator'
          }, {
            model: Solution
          }
        ]
      });
    }).then(function(submissions) {
      currentSubmissions = submissions;
      return Solution.findAll({
        where: {
          $or: [
            {
              access_level: 'public'
            }, {
              access_level: 'protect',
              secret_limit: {
                $lt: new Date()
              }
            }
          ]
        },
        include: [
          {
            model: Submission,
            where: {
              problem_id: currentProblem.id,
              creator_id: {
                $not: currentUser.id
              }
            },
            include: [
              {
                model: User,
                as: 'creator'
              }
            ]
          }
        ]
      });
    }).then(function(references) {
      currentProblem.test_setting = JSON.parse(currentProblem.test_setting);
      return res.render('problem/createSolution', {
        submissions: currentSubmissions,
        problem: currentProblem,
        user: req.session.user,
        offset: req.query.offset,
        pageLimit: global.config.pageLimit.submission,
        query: req.body,
        moment: require("moment"),
        references: references
      });
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](global.myErrors.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.getIndex = function(req, res) {
    var Contest, Group, User, currentProblem, currentUser, recommendation, ulang;
    User = global.db.models.user;
    Group = global.db.models.group;
    Contest = global.db.models.contest;
    currentProblem = void 0;
    currentUser = void 0;
    recommendation = void 0;
    ulang = void 0;
    if (req.session.sublang) {
      ulang = req.session.sublang.lang;
    }
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return global.myUtils.findProblem(user, req.params.problemID, [
        {
          model: User,
          as: 'creator'
        }, {
          model: Contest,
          attributes: ['id', 'title'],
          limit: 1
        }
      ]);
    }).then(function(problem) {
      if (!problem) {
        throw new global.myErrors.UnknownProblem();
      }
      currentProblem = problem.get({
        plain: true
      });
      currentProblem.test_setting = JSON.parse(problem.test_setting);
      currentProblem.description = markdown.toHTML(problem.description);
      if (!currentUser) {
        return [];
      }
      return currentUser.getRecommendation();
    }).then(function(recommendation_problems) {
      var problem;
      recommendation = (function() {
        var i, len, results;
        results = [];
        for (i = 0, len = recommendation_problems.length; i < len; i++) {
          problem = recommendation_problems[i];
          results.push(problem.get({
            plain: true
          }));
        }
        return results;
      })();
      recommendation.sort(function(a, b) {
        return b.recommendation.score - a.recommendation.score;
      });
      return global.myUtils.getProblemsStatus([currentProblem].concat(recommendation), currentUser);
    }).then(function() {
      return res.render('problem/detail', {
        user: req.session.user,
        problem: currentProblem,
        recommendation: recommendation,
        Ulang: ulang
      });
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](global.myErrors.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.postSubmission = function(req, res) {
    var User, current_problem, current_user;
    User = global.db.models.user;
    current_user = void 0;
    current_problem = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      if (!user) {
        throw new global.myErrors.UnknownUser();
      }
      current_user = user;
      return global.myUtils.findProblem(user, req.params.problemID);
    }).then(function(problem) {
      var form, form_code;
      if (!problem) {
        throw new global.myErrors.UnknownProblem();
      }
      current_problem = problem;
      form = {
        lang: req.body.lang,
        code_length: req.body.code.length
      };
      form_code = {
        content: req.body.code
      };
      req.session.sublang = form;
      return global.myUtils.createSubmissionTransaction(form, form_code, current_problem, current_user);
    }).then(function() {
      req.flash('info', 'submit code successfully');
      return res.redirect(SUBMISSION_PAGE);
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](global.myErrors.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.getSubmissions = function(req, res) {
    var Solution, Submission, User, click_count, currentProblem, currentSolution, currentUser, currentUserAC, currentUserWC, solutionclick_statistics, submissionsCP;
    User = global.db.models.user;
    currentProblem = void 0;
    currentUser = void 0;
    Submission = global.db.models.submission;
    Solution = global.db.models.solution;
    currentUserWC = 0;
    currentUserAC = 0;
    currentSolution = void 0;
    click_count = void 0;
    solutionclick_statistics = global.db.models.click_statistics;
    submissionsCP = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.query.offset > 1000) {
        throw new global.myErrors.UnknownSubmission();
      }
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return global.myUtils.findProblem(user, req.params.problemID);
    }).then(function(problem) {
      if (!problem) {
        throw new global.myErrors.UnknownProblem();
      }
      currentProblem = problem;
      if (!currentUser) {
        return;
      }
      return Submission.findAll({
        attributes: [[global.db.fn('count', global.db.literal('distinct id')), 'WCOUNT']],
        where: {
          creator_id: currentUser.id,
          problem_id: currentProblem.id,
          result: {
            $notIn: ['CE', 'WT', 'JG']
          }
        }
      }).then(function(res) {
        currentUserWC = res[0].get({
          plain: true
        }).WCOUNT;
        return Submission.findAll({
          attributes: [[global.db.fn('count', global.db.literal('distinct id')), 'ACOUNT']],
          where: {
            creator_id: currentUser.id,
            problem_id: currentProblem.id,
            result: 'AC'
          }
        });
      }).then(function(res) {
        currentUserAC = res[0].get({
          plain: true
        }).ACOUNT;
        if (currentUserWC + currentUserAC === 0) {
          return;
        }
        return Submission.find({
          attributes: ['created_at'],
          where: {
            creator_id: currentUser.id,
            problem_id: currentProblem.id,
            result: {
              $notIn: ['CE', 'WT', 'JG']
            }
          }
        });
      }).then(function(first_sub) {
        var NOW;
        NOW = new Date();
        if (!first_sub || currentUserAC !== 0 || currentUserWC < 5 || (NOW - first_sub.created_at) / 1000 / 60 < 20) {
          return;
        }
        return Solution.find({
          attributes: ['submission_id', 'access_level'],
          include: [
            {
              model: Submission,
              where: {
                problem_id: currentProblem.id
              }
            }
          ],
          order: [global.db.fn('RAND')]
        });
      });
    }).then(function(solution) {
      var opt;
      if (solution) {
        currentSolution = solution;
      }
      opt = {
        offset: req.query.offset,
        problem_id: currentProblem.id
      };
      return global.myUtils.findSubmissions(currentUser, opt, [
        {
          model: User,
          as: 'creator'
        }, {
          model: Solution
        }
      ]);
    }).then(function(submissions) {
      currentProblem.test_setting = JSON.parse(currentProblem.test_setting);
      submissionsCP = submissions;
      return solutionclick_statistics.find({
        where: {
          clickType: "solution"
        }
      }).then(function(clicks) {
        if (clicks) {
          return click_count = clicks.appearCount;
        } else {
          return click_count = 0;
        }
      });
    }).then(function() {
      return res.render('problem/submission', {
        submissions: submissionsCP,
        problem: currentProblem,
        user: req.session.user,
        offset: req.query.offset,
        pageLimit: global.config.pageLimit.submission,
        solution: currentSolution,
        exit_clickSolution: click_count
      });
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](global.myErrors.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.postSubmissions = postSubmissions = function(req, res) {
    var Solution, User, click_count, currentProblem, currentProblems, currentUser, opt, solutionclick_statistics;
    User = global.db.models.user;
    currentProblem = void 0;
    currentUser = void 0;
    currentProblems = void 0;
    Solution = global.db.models.solution;
    click_count = void 0;
    solutionclick_statistics = global.db.click_statistics;
    opt = {};
    return global.db.Promise.resolve().then(function() {
      if (req.query.offset > 1000) {
        throw new global.myErrors.UnknownSubmission();
      }
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return global.myUtils.findProblem(user, req.params.problemID);
    }).then(function(problem) {
      if (!problem) {
        throw new global.myErrors.UnknownProblem();
      }
      currentProblem = problem;
      currentProblems = [problem];
      return global.myUtils.getProblemsStatus(currentProblems, currentUser);
    }).then(function() {
      opt.offset = req.query.offset;
      if (req.body.nickname !== '') {
        opt.nickname = req.body.nickname;
      }
      opt.problem_id = currentProblem.id;
      if (req.body.contest_id !== '') {
        opt.contest_id = req.body.contest_id;
      }
      if (req.body.language !== '') {
        opt.language = req.body.language;
      }
      if (req.body.result !== '') {
        opt.result = req.body.result;
      }
      return global.myUtils.findSubmissions(currentUser, opt, [
        {
          model: User,
          as: 'creator'
        }, {
          model: Solution
        }
      ]);
    }).then(function(submissions) {
      return currentProblem.test_setting = JSON.parse(currentProblem.test_setting);
    }).then(function() {
      return res.render('problem/submission', {
        submissions: submissions,
        problem: currentProblem,
        user: req.session.user,
        offset: req.query.offset,
        pageLimit: global.config.pageLimit.submission,
        query: req.body
      });
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](global.myErrors.UnknownProblem, function(err) {
      req.flash('info', err.message);
      return res.redirect(PROBLEM_PAGE);
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
