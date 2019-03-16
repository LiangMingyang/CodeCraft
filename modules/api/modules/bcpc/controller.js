// Generated by CoffeeScript 1.12.6
(function() {
  var BCPC_Final, BCPC_GROUP, check;

  BCPC_Final = 99;

  BCPC_GROUP = 41;

  check = function(userId) {
    var up;
    up = {
      1: true
    };
    return !!up[userId];
  };

  exports.getStatus = function(req, res) {
    return global.db.Promise.resolve().then(function() {
      return global.myUtils.findGroupsID(req.session.user);
    }).then(function(groupIDs) {
      var i, id, len;
      for (i = 0, len = groupIDs.length; i < len; i++) {
        id = groupIDs[i];
        if (id === BCPC_GROUP) {
          return true;
        }
      }
      return false;
    }).then(function(registered) {
      return res.json({
        user: req.session.user,
        registered: registered
      });
    })["catch"](function(err) {
      res.status(err.status || 400);
      return res.json({
        error: err.message
      });
    });
  };

  exports.getRegister = function(req, res) {
    var Group, User, currentGroup, joiner;
    User = global.db.models.user;
    Group = global.db.models.group;
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
      return Group.find(BCPC_GROUP);
    }).then(function(group) {
      if (!group) {
        throw new global.myErrors.UnknownGroup();
      }
      currentGroup = group;
      return group.hasUser(joiner);
    }).then(function(res) {
      if (res) {
        throw new global.myErrors.UnknownGroup("你已经注册过了");
      }
      return currentGroup.addUser(joiner, {
        access_level: 'member'
      });
    }).then(function() {
      return res.json({
        registered: true
      });
    })["catch"](function(err) {
      res.status(err.status || 400);
      return res.json({
        error: err.message
      });
    });
  };

  exports.getList = function(req, res) {
    var Group, User, currentGroup, joiner;
    User = global.db.models.user;
    Group = global.db.models.group;
    joiner = void 0;
    currentGroup = void 0;
    return global.db.Promise.resolve().then(function() {
      return Group.find({
        where: {
          id: BCPC_Final
        },
        include: [
          {
            model: User,
            where: {
              id: [1]
            },
            through: {
              where: {
                access_level: ['member']
              }
            }
          }
        ]
      });
    }).then(function(group) {
      if (!group) {
        throw new global.myErrors.UnknownGroup();
      }
      return res.json(group.get({
        plain: true
      }));
    })["catch"](function(err) {
      res.status(err.status || 400);
      return res.json({
        error: err.message
      });
    });
  };

  exports.postConfirm = function(req, res) {
    var Group, User, joiner;
    Group = global.db.models.group;
    User = global.db.models.user;
    joiner = void 0;
    return global.db.Promise.resolve().then(function() {
      var passed;
      passed = req.session.user && check(req.session.user.id);
      if (!passed) {
        throw new global.myErrors.InvalidAccess('做不到');
      }
      return global.myUtils.findGroupsID(req.session.user);
    }).then(function(groupIDs) {
      var i, id, len;
      for (i = 0, len = groupIDs.length; i < len; i++) {
        id = groupIDs[i];
        if (id === BCPC_Final) {
          return true;
        }
      }
      return false;
    }).then(function(confirmed) {
      if (confirmed) {
        throw new global.myErrors.InvalidAccess('你已经确认过了');
      }
      return User.find(req.session.user.id);
    }).then(function(user) {
      if (!user) {
        throw new global.myErrors.UnknownUser();
      }
      joiner = user;
      user.nickname = req.body.nickname;
      user.student_id = req.body.student_id;
      user.phone = req.body.phone;
      return user.save();
    }).then(function() {
      return Group.find(BCPC_Final);
    }).then(function(group) {
      return group.addUser(joiner, {
        access_level: 'member'
      });
    }).then(function() {
      return res.json({
        confirmed: true
      });
    })["catch"](function(err) {
      res.status(err.status || 400);
      return res.json({
        error: err.message
      });
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
