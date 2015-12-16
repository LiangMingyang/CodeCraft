// Generated by CoffeeScript 1.9.3
(function() {
  var check;

  check = function(userId) {
    var up;
    up = {
      2: true,
      11: true,
      16: true,
      19: true,
      21: true,
      22: true,
      24: true,
      29: true,
      31: true,
      33: true,
      39: true,
      41: true,
      42: true,
      44: true,
      46: true,
      51: true,
      57: true,
      59: true,
      70: true,
      72: true,
      73: true,
      74: true,
      76: true,
      77: true,
      83: true,
      87: true,
      89: true,
      91: true,
      96: true,
      106: true,
      111: true,
      114: true,
      119: true,
      136: true,
      144: true,
      145: true,
      163: true,
      171: true,
      179: true,
      183: true,
      201: true,
      203: true,
      211: true,
      229: true,
      255: true,
      264: true,
      276: true,
      280: true,
      285: true,
      294: true,
      299: true,
      310: true,
      369: true,
      421: true,
      486: true,
      488: true,
      493: true,
      494: true,
      495: true,
      496: true,
      500: true,
      501: true,
      504: true,
      507: true,
      511: true,
      512: true,
      514: true,
      517: true,
      520: true,
      527: true,
      537: true,
      540: true,
      559: true,
      569: true,
      575: true,
      583: true,
      586: true,
      593: true,
      598: true,
      605: true,
      634: true,
      639: true,
      691: true,
      718: true
    };
    return !!up[userId];
  };

  exports.getStatus = function(req, res) {
    var BCPC_Final;
    BCPC_Final = 7;
    return global.db.Promise.resolve().then(function() {
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
      var passed;
      passed = req.session.user && check(req.session.user.id);
      return res.json({
        user: req.session.user,
        passed: passed,
        confirmed: confirmed
      });
    })["catch"](function(err) {
      res.status(err.status || 400);
      return res.json({
        error: err.message
      });
    });
  };

  exports.getRegister = function(req, res) {
    var BCPC_GROUP, Group, User, currentGroup, joiner;
    User = global.db.models.user;
    Group = global.db.models.group;
    joiner = void 0;
    currentGroup = void 0;
    BCPC_GROUP = 6;
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
        registed: true
      });
    })["catch"](function(err) {
      res.status(err.status || 400);
      return res.json({
        error: err.message
      });
    });
  };

  exports.getList = function(req, res) {
    var BCPC_GROUP, Group, User, currentGroup, joiner;
    User = global.db.models.user;
    Group = global.db.models.group;
    joiner = void 0;
    currentGroup = void 0;
    BCPC_GROUP = 6;
    return global.db.Promise.resolve().then(function() {
      return Group.find({
        where: {
          id: BCPC_GROUP
        },
        include: [
          {
            model: User,
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
    var BCPC_Final, Group, User, joiner;
    BCPC_Final = 7;
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
