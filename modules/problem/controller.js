// Generated by CoffeeScript 1.10.0
(function() {
  var HOME_PAGE, INDEX_PAGE, passwordHash;

  passwordHash = require('password-hash');

  HOME_PAGE = '/';

  INDEX_PAGE = '.';

  exports.getIndex = function(req, res) {
    var Contest, Group, User, currentProblems, problemCount;
    Group = global.db.models.group;
    User = global.db.models.user;
    Contest = global.db.models.contest;
    currentProblems = void 0;
    problemCount = void 0;
    return global.db.Promise.resolve().then(function() {
      var base, offset;
      if ((base = req.query).page == null) {
        base.page = 1;
      }
      offset = (req.query.page - 1) * global.config.pageLimit.problem;
      return global.myUtils.findAndCountProblems(req.session.user, {
        offset: offset
      }, [
        {
          model: Group,
          attributes: ['id', 'name']
        }, {
          model: User,
          attributes: ['id', 'nickname'],
          as: 'creator'
        }, {
          model: Contest,
          attributes: ['id', 'title']
        }
      ]);
    }).then(function(result) {
      problemCount = result.count;
      currentProblems = result.rows;
      return global.myUtils.getProblemsStatus(currentProblems, req.session.user);
    }).then(function() {
      return res.render('problem/index', {
        user: req.session.user,
        problems: currentProblems,
        problemCount: problemCount,
        page: req.query.page,
        pageLimit: global.config.pageLimit.problem
      });
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.postIndex = function(req, res) {
    var Contest, Group, User, currentProblems, problemCount;
    Group = global.db.models.group;
    User = global.db.models.user;
    Contest = global.db.models.contest;
    currentProblems = void 0;
    problemCount = void 0;
    return global.db.Promise.resolve().then(function() {
      var base, key, offset, opt;
      if ((base = req.query).page == null) {
        base.page = 1;
      }
      offset = (req.query.page - 1) * global.config.pageLimit.problem;
      opt = req.body;
      opt.offset = offset;
      for (key in opt) {
        if (opt[key] === '') {
          delete opt[key];
        }
      }
      return global.myUtils.findAndCountProblems(req.session.user, opt, [
        {
          model: Group,
          attributes: ['id', 'name']
        }, {
          model: User,
          attributes: ['id', 'nickname'],
          as: 'creator'
        }, {
          model: Contest,
          attributes: ['id', 'title']
        }
      ]);
    }).then(function(result) {
      problemCount = result.count;
      currentProblems = result.rows;
      return global.myUtils.getProblemsStatus(currentProblems, req.session.user);
    }).then(function() {
      return res.render('problem/index', {
        user: req.session.user,
        problems: currentProblems,
        problemCount: problemCount,
        page: req.query.page,
        pageLimit: global.config.pageLimit.problem,
        query: req.body
      });
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.getAccepted = function(req, res) {
    var Contest, Group, Solution, Submission, User, currentProblems, problemCount;
    Group = global.db.models.group;
    User = global.db.models.user;
    Contest = global.db.models.contest;
    Submission = global.db.models.submission;
    Solution = global.db.models.solution;
    currentProblems = void 0;
    problemCount = void 0;
    return global.db.Promise.resolve().then(function() {
      var base, opt, ref, ref1;
      if ((base = req.query).page == null) {
        base.page = 1;
      }
      opt = {};
      opt.offset = (req.query.page - 1) * global.config.pageLimit.problem;
      opt.distinct = true;
      return global.myUtils.findAndCountProblems(req.session.user, opt, [
        {
          model: Group,
          attributes: ['id', 'name']
        }, {
          model: User,
          attributes: ['id', 'nickname'],
          as: 'creator'
        }, {
          model: Contest,
          attributes: ['id', 'title']
        }, {
          model: Submission,
          where: {
            creator_id: (ref = req.session) != null ? (ref1 = ref.user) != null ? ref1.id : void 0 : void 0,
            result: 'AC'
          },
          include: [
            {
              model: Solution
            }
          ]
        }
      ]);
    }).then(function(result) {
      problemCount = result.count;
      currentProblems = result.rows;
      return global.myUtils.getProblemsStatus(currentProblems, req.session.user);
    }).then(function() {
      var i, j, k, l, len, len1, problem, ref, submission;
      for (i = k = 0, len = currentProblems.length; k < len; i = ++k) {
        problem = currentProblems[i];
        ref = problem.submissions;
        for (j = l = 0, len1 = ref.length; l < len1; j = ++l) {
          submission = ref[j];
          if (submission.solution) {
            problem.solution = submission.solution;
            break;
          }
        }
      }
      return res.render('problem/accepted', {
        user: req.session.user,
        problems: currentProblems,
        problemCount: problemCount,
        page: req.query.page,
        pageLimit: global.config.pageLimit.problem
      });
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.postAccepted = function(req, res) {
    var Contest, Group, Solution, Submission, User, currentProblems, problemCount;
    Group = global.db.models.group;
    User = global.db.models.user;
    Contest = global.db.models.contest;
    Solution = global.db.models.solution;
    currentProblems = void 0;
    problemCount = void 0;
    Submission = global.db.models.submission;
    return global.db.Promise.resolve().then(function() {
      var base, key, offset, opt, ref, ref1;
      if ((base = req.query).page == null) {
        base.page = 1;
      }
      offset = (req.query.page - 1) * global.config.pageLimit.problem;
      opt = req.body;
      opt.offset = offset;
      for (key in opt) {
        if (opt[key] === '') {
          delete opt[key];
        }
      }
      opt.distinct = true;
      return global.myUtils.findAndCountProblems(req.session.user, opt, [
        {
          model: Group,
          attributes: ['id', 'name']
        }, {
          model: User,
          attributes: ['id', 'nickname'],
          as: 'creator'
        }, {
          model: Contest,
          attributes: ['id', 'title']
        }, {
          model: Submission,
          where: {
            creator_id: (ref = req.session) != null ? (ref1 = ref.user) != null ? ref1.id : void 0 : void 0,
            result: 'AC'
          },
          include: [
            {
              model: Solution
            }
          ]
        }
      ]);
    }).then(function(result) {
      problemCount = result.count;
      currentProblems = result.rows;
      return global.myUtils.getProblemsStatus(currentProblems, req.session.user);
    }).then(function() {
      var i, j, k, l, len, len1, problem, ref, submission;
      for (i = k = 0, len = currentProblems.length; k < len; i = ++k) {
        problem = currentProblems[i];
        ref = problem.submissions;
        for (j = l = 0, len1 = ref.length; l < len1; j = ++l) {
          submission = ref[j];
          if (submission.solution) {
            problem.solution = submission.solution;
            break;
          }
        }
      }
      return res.render('problem/accepted', {
        user: req.session.user,
        problems: currentProblems,
        problemCount: problemCount,
        page: req.query.page,
        pageLimit: global.config.pageLimit.problem,
        query: req.body
      });
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
