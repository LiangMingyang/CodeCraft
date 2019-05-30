// Generated by CoffeeScript 1.12.6
(function() {
  var HOME_PAGE, INDEX_PAGE, Promise, passwordHash;

  passwordHash = require('password-hash');

  Promise = require('sequelize').Promise;

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
      // if ((base = req.query).page == null||Math.floor(base.page) !== base.page || base.page<=1) {
      //   base.page = 1;
      // }
      base= req.query;
      base.page = global.myUtils.checkisNumber(base.page);
      if (base.page<=1) {
        base.page = 1;
      }
      
      offset = (base.page - 1) * global.config.pageLimit.problem;
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

  exports.getStatistics = function(req, res) {
    var count_tag, count_title;
    count_title = void 0;
    count_tag = void 0;
    global.redis.set("title_recommendation_count", 0, "NX");
    global.redis.set("tag_recommendation_count", 0, "NX");
    if (req.session.user.id % 2 === 0) {
      global.redis.incr("title_recommendation_count");
    } else {
      global.redis.incr("tag_recommendation_count");
    }
    global.redis.get("title_recommendation_count").then(function(result) {
      return count_title = result;
    });
    return global.redis.get("tag_recommendation_count").then(function(result) {
      return count_tag = result;
    }).then(function() {
      if (req.session.user.id === 1) {
        return res.redirect(req.query.problem_id + '/index?' + 'count_title=' + count_title + '&count_tag=' + count_tag);
      } else {
        return res.redirect(req.query.problem_id + '/index');
      }
    });
  };

  exports.getTencentStatistics = function(req, res) {
    var advertisementStatistics, count_advertise, url;
    count_advertise = void 0;
    advertisementStatistics = global.db.models.click_statistics;
    url = "https://cloud.tencent.com/act/campus?utm_source=beihang&utm_medium=txt&utm_campaign=campus";
    return advertisementStatistics.find({
      where: {
        clickUrl: url
      }
    }).then(function(clicks) {
      if (clicks) {
        count_advertise = clicks.clickCount;
      } else {
        count_advertise = 0;
      }
      count_advertise = count_advertise + 1;
      return advertisementStatistics.find({
        where: {
          clickUrl: url
        }
      });
    }).then(function(clicks) {
      if (clicks) {
        clicks.clickCount = count_advertise;
        return clicks.save();
      } else {
        return advertisementStatistics.create({
          clickType: "Guanggao",
          clickContent: "tengxun",
          clickUrl: "https://cloud.tencent.com/act/campus?utm_source=beihang&utm_medium=txt&utm_campaign=campus",
          clickCount: count_advertise,
          appearCount: 0
        });
      }
    }).then(function() {
      return res.redirect("https://cloud.tencent.com/act/campus?utm_source=beihang&utm_medium=txt&utm_campaign=campus");
    });
  };

  exports.getXiniuStatistics = function(req, res) {
    var advertisementStatistics, count_advertise, url;
    count_advertise = void 0;
    advertisementStatistics = global.db.models.click_statistics;
    url = "http://ur.tencent.com/register/8";
    return advertisementStatistics.find({
      where: {
        clickUrl: url
      }
    }).then(function(clicks) {
      if (clicks) {
        count_advertise = clicks.clickCount;
      } else {
        count_advertise = 0;
      }
      count_advertise = count_advertise + 1;
      return advertisementStatistics.find({
        where: {
          clickUrl: url
        }
      });
    }).then(function(clicks) {
      if (clicks) {
        clicks.clickCount = count_advertise;
        return clicks.save();
      } else {
        return advertisementStatistics.create({
          clickType: "Guanggao",
          clickContent: "xiniuniao",
          clickUrl: url,
          clickCount: count_advertise,
          appearCount: 0
        });
      }
    }).then(function() {
      return res.redirect(url);
    });
  };

  exports.getDEVStatistics = function(req, res) {
    var count_material, materialStatistics, url;
    count_material = void 0;
    materialStatistics = global.db.models.click_statistics;
    url = "http://image.buaacoding.cn/DEV%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.pdf";
    return materialStatistics.find({
      where: {
        clickUrl: url
      }
    }).then(function(clicks) {
      if (clicks) {
        count_material = clicks.clickCount;
      } else {
        count_material = 0;
      }
      count_material = count_material + 1;
      return materialStatistics.find({
        where: {
          clickUrl: url
        }
      });
    }).then(function(clicks) {
      if (clicks) {
        clicks.clickCount = count_material;
        return clicks.save();
      } else {
        return materialStatistics.create({
          clickType: "material",
          clickContent: "DEV",
          clickUrl: url,
          clickCount: count_material,
          appearCount: 0
        });
      }
    }).then(function() {
      return res.redirect(url);
    });
  };

  exports.getCBStatistics = function(req, res) {
    var count_material, materialStatistics, url;
    count_material = void 0;
    materialStatistics = global.db.models.click_statistics;
    url = "http://image.buaacoding.cn/CB%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.pdf";
    return materialStatistics.find({
      where: {
        clickUrl: url
      }
    }).then(function(clicks) {
      if (clicks) {
        count_material = clicks.clickCount;
      } else {
        count_material = 0;
      }
      count_material = count_material + 1;
      return materialStatistics.find({
        where: {
          clickUrl: url
        }
      });
    }).then(function(clicks) {
      if (clicks) {
        clicks.clickCount = count_material;
        return clicks.save();
      } else {
        return materialStatistics.create({
          clickType: "material",
          clickContent: "CB",
          clickUrl: url,
          clickCount: count_material,
          appearCount: 0
        });
      }
    }).then(function() {
      return res.redirect(url);
    });
  };

  exports.postSolutionStatistics = function(req, res) {
    var addappearSolution, count_solution, id, solutionStatistics;
    solutionStatistics = global.db.models.click_statistics;
    count_solution = void 0;
    addappearSolution = void 0;
    id = void 0;
    id = req.body.id;
    global.myUtils.tmp(req, id);
    addappearSolution = req.body.content;
    return solutionStatistics.find({
      where: {
        clickType: "solution"
      }
    }).then(function(clicks) {
      if (clicks) {
        clicks.appearCount = addappearSolution;
        return clicks.save();
      } else {
        return solutionStatistics.create({
          clickType: "solution",
          clickContent: "experiment",
          clickUrl: "submission/id/solution",
          clickCount: 0,
          appearCount: 0
        });
      }
    }).then(function() {});
  };

  exports.getSolutionStatistics = function(req, res) {
    var count_solution, solutionStatistics, url;
    solutionStatistics = global.db.models.click_statistics;
    count_solution = void 0;
    url = void 0;
    if (req.session.tmpid) {
      url = "https://buaacoding.cn/submission/" + req.session.tmpid + "/solution";
    } else {
      url = "https://buaacoding.cn/index";
    }
    return solutionStatistics.find({
      where: {
        clickType: "solution"
      }
    }).then(function(clicks) {
      if (clicks) {
        count_solution = clicks.clickCount;
        clicks.clickCount = count_solution + 1;
        return clicks.save();
      } else {
        return solutionStatistics.create({
          clickType: "solution",
          clickContent: "experiment",
          clickUrl: "submission/id/solution",
          clickCount: 0,
          appearCount: 0
        });
      }
    }).then(function() {
      return res.redirect(url);
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
