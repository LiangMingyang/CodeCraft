// Generated by CoffeeScript 1.10.0
(function() {
  var CONTEST_PAGE, GROUP_PAGE, HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, MEMBER_PAGE, PROBLEM_PAGE;

  HOME_PAGE = '/';

  MEMBER_PAGE = 'member';

  CONTEST_PAGE = 'contest';

  PROBLEM_PAGE = 'problem';

  INDEX_PAGE = 'index';

  GROUP_PAGE = '/group';

  LOGIN_PAGE = '/user/login';

  exports.getIndex = function(req, res) {
    var User, currentGroup, isMember;
    User = global.db.models.user;
    currentGroup = void 0;
    isMember = false;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      return global.myUtils.findGroup(user, req.params.groupID, [
        {
          model: User,
          as: 'creator'
        }
      ]);
    }).then(function(group) {
      if (!group) {
        throw new global.myErrors.UnknownGroup();
      }
      currentGroup = group;
      if (req.session.user) {
        return group.hasUser(req.session.user.id).then(function(joined) {
          return isMember = joined;
        });
      }
    }).then(function() {
      return res.render('group/detail', {
        user: req.session.user,
        group: currentGroup,
        isMember: isMember
      });
    })["catch"](global.myErrors.UnknownGroup, function(err) {
      req.flash('info', err.message);
      return res.redirect(GROUP_PAGE);
    })["catch"](function(err) {
      console.log(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.getMember = function(req, res) {
    var User;
    User = global.db.models.user;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      return global.myUtils.findGroup(user, req.params.groupID, [
        {
          model: User,
          as: 'creator'
        }, {
          model: User,
          through: {
            where: {
              access_level: ['member', 'admin', 'owner']
            }
          }
        }
      ]);
    }).then(function(group) {
      if (!group) {
        throw new global.myErrors.UnknownGroup();
      }
      return res.render('group/member', {
        user: req.session.user,
        group: group
      });
    })["catch"](global.myErrors.UnknownGroup, function(err) {
      req.flash('info', err.message);
      return res.redirect(GROUP_PAGE);
    })["catch"](function(err) {
      console.log(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.getJoin = function(req, res) {
    var User, currentGroup, joiner;
    User = global.db.models.user;
    joiner = void 0;
    currentGroup = void 0;
    return global.db.Promise.resolve().then(function() {
      if (!req.session.user) {
        throw new global.myErrors.UnknownUser();
      }
      return User.find(req.session.user.id);
    }).then(function(user) {
      if (!user) {
        throw new global.myErrors.UnknownUser();
      }
      joiner = user;
      return global.myUtils.findGroup(user, req.params.groupID);
    }).then(function(group) {
      if (!group) {
        throw new global.myErrors.UnknownGroup();
      }
      currentGroup = group;
      return group.hasUser(joiner);
    }).then(function(res) {
      if (res) {
        throw new global.myErrors.UnknownGroup();
      }
      return currentGroup.addUser(joiner, {
        access_level: 'verifying'
      });
    }).then(function() {
      req.flash('info', 'Please waiting for verifying');
      return res.redirect(INDEX_PAGE);
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](global.myErrors.UnknownGroup, function(err) {
      req.flash('info', err.message);
      return res.redirect(GROUP_PAGE);
    })["catch"](global.db.ValidationError, function(err) {
      req.flash('info', err.errors[0].path + " : " + err.errors[0].message);
      return res.redirect(INDEX_PAGE);
    })["catch"](function(err) {
      console.log(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.getProblem = function(req, res) {
    var Group, User, currentGroup, currentProblems, currentUser, problemCount;
    User = global.db.models.user;
    Group = global.db.models.group;
    currentGroup = void 0;
    currentUser = void 0;
    problemCount = void 0;
    currentProblems = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return global.myUtils.findGroup(user, req.params.groupID, [
        {
          model: User,
          as: 'creator'
        }
      ]);
    }).then(function(group) {
      var base, offset;
      if (!group) {
        throw new global.myErrors.UnknownGroup();
      }
      currentGroup = group;
      if ((base = req.query).page == null) {
        base.page = 1;
      }
      offset = (req.query.page - 1) * global.config.pageLimit.problem;
      return global.myUtils.findAndCountProblems(currentUser, offset, [
        {
          model: Group,
          where: {
            id: group.id
          }
        }
      ]);
    }).then(function(result) {
      problemCount = result.count;
      currentProblems = result.rows;
      return global.myUtils.getProblemsStatus(currentProblems, currentUser);
    }).then(function() {
      return res.render('group/problem', {
        user: req.session.user,
        group: currentGroup,
        problems: currentProblems,
        page: req.query.page,
        pageLimit: global.config.pageLimit.problem,
        problemCount: problemCount
      });
    })["catch"](global.myErrors.UnknownGroup, function(err) {
      req.flash('info', err.message);
      return res.redirect(GROUP_PAGE);
    })["catch"](function(err) {
      console.log(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.getContest = function(req, res) {
    var Group, User, contestCount, currentGroup, currentUser;
    User = global.db.models.user;
    Group = global.db.models.group;
    currentGroup = void 0;
    currentUser = void 0;
    contestCount = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return global.myUtils.findGroup(user, req.params.groupID);
    }).then(function(group) {
      var base, offset;
      if (!group) {
        throw new global.myErrors.UnknownGroup();
      }
      currentGroup = group;
      if ((base = req.query).page == null) {
        base.page = 1;
      }
      offset = (req.query.page - 1) * global.config.pageLimit.contest;
      return global.myUtils.findAndCountContests(currentUser, offset, [
        {
          model: Group,
          where: {
            id: group.id
          }
        }
      ]);
    }).then(function(result) {
      var contests;
      contests = result.rows;
      contestCount = result.count;
      return res.render('group/contest', {
        user: req.session.user,
        group: currentGroup,
        contests: contests,
        page: req.query.page,
        pageLimit: global.config.pageLimit.contest,
        contestCount: contestCount
      });
    })["catch"](global.myErrors.UnknownGroup, function(err) {
      req.flash('info', err.message);
      return res.redirect(GROUP_PAGE);
    })["catch"](function(err) {
      console.log(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
