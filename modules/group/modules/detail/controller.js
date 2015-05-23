// Generated by CoffeeScript 1.9.2
(function() {
  var CONTEST_PAGE, GROUP_PAGE, HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, MEMBER_PAGE, PROBLEM_PAGE, myUtils;

  myUtils = require('./utils');

  HOME_PAGE = '/';

  MEMBER_PAGE = 'member';

  CONTEST_PAGE = 'contest';

  PROBLEM_PAGE = 'problem';

  INDEX_PAGE = '.';

  LOGIN_PAGE = '/user/login';

  GROUP_PAGE = '/group';

  exports.getIndex = function(req, res) {
    var Group, User;
    Group = global.db.models.group;
    User = global.db.models.user;
    return Group.find(req.params.groupID, {
      include: [
        {
          model: User,
          as: 'creator'
        }
      ]
    }).then(function(group) {
      var ref;
      if (!group) {
        throw new myUtils.Error.UnknownGroup();
      }
      if ((ref = group.access_level) !== 'protect' && ref !== 'public') {
        throw new myUtils.Error.UnknownGroup();
      }
      return res.render('group/detail', {
        user: req.session.user,
        group: group
      });
    })["catch"](myUtils.Error.UnknownGroup, function(err) {
      req.flash('info', err.message);
      return res.redirect(GROUP_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(GROUP_PAGE);
    });
  };

  exports.getMember = function(req, res) {
    var Group, User;
    Group = global.db.models.group;
    User = global.db.models.user;
    return Group.find(req.params.groupID, {
      include: [
        {
          model: User,
          through: {
            where: {
              access_level: ['member', 'admin', 'owner']
            }
          }
        }
      ]
    }).then(function(group) {
      var ref;
      if (!group) {
        throw new myUtils.Error.UnknownGroup();
      }
      if ((ref = group.access_level) !== 'protect' && ref !== 'public') {
        throw new myUtils.Error.UnknownGroup();
      }
      return res.render('group/member', {
        user: req.session.user,
        group: group
      });
    })["catch"](myUtils.Error.UnknownGroup, function(err) {
      req.flash('info', err.message);
      return res.redirect(GROUP_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(INDEX_PAGE);
    });
  };

  exports.getJoin = function(req, res) {
    var Group, User, joiner;
    Group = global.db.models.group;
    User = global.db.models.user;
    joiner = void 0;
    return global.db.Promise.resolve().then(function() {
      if (!req.session.user) {
        throw new myUtils.Error.UnknownUser();
      }
      return User.find(req.session.user.id);
    }).then(function(user) {
      if (!user) {
        throw new myUtils.Error.UnknownUser();
      }
      joiner = user;
      return Group.find(req.params.groupID);
    }).then(function(group) {
      var ref;
      if (!group) {
        throw new myUtils.Error.UnknownGroup();
      }
      if ((ref = group.access_level) !== 'protect' && ref !== 'public') {
        throw new myUtils.Error.UnknownGroup();
      }
      return group.addUser(joiner, {
        access_level: 'verifying'
      });
    }).then(function() {
      req.flash('info', 'Please waiting for verifying');
      return res.redirect(INDEX_PAGE);
    })["catch"](myUtils.Error.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](myUtils.Error.UnknownGroup, function(err) {
      req.flash('info', err.message);
      return res.redirect(GROUP_PAGE);
    })["catch"](global.db.ValidationError, function(err) {
      req.flash('info', err.errors[0].path + " : " + err.errors[0].message);
      return res.redirect(INDEX_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(INDEX_PAGE);
    });
  };

  exports.getProblem = function(req, res) {
    return res.render('index', {
      user: req.session.user,
      title: "Problems of " + req.params.groupID
    });
  };

  exports.getContest = function(req, res) {
    return res.render('index', {
      user: req.session.user,
      title: "Contests of " + req.params.groupID
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
