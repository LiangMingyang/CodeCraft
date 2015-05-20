// Generated by CoffeeScript 1.9.2
(function() {
  var CREATE_PAGE, HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, myUtils, passwordHash;

  passwordHash = require('password-hash');

  myUtils = require('./utils');

  HOME_PAGE = '/';

  CREATE_PAGE = 'create';

  INDEX_PAGE = '.';

  LOGIN_PAGE = '/user/login';

  exports.getIndex = function(req, res) {
    var Group, User;
    Group = global.db.models.group;
    User = global.db.models.user;
    return Group.findAll({
      where: {
        access_level: ["protect", "public"]
      },
      include: [
        {
          model: User,
          as: 'creator'
        }
      ]
    }).then(function(groups) {
      return res.render('group/index', {
        title: 'You have got group index here',
        user: req.session.user,
        groups: groups
      });
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(INDEX_PAGE);
    });
  };

  exports.getCreate = function(req, res) {
    return res.render('group/create', {
      title: 'create group',
      user: req.session.user
    });
  };

  exports.postCreate = function(req, res) {
    var Group, User, creator, form;
    form = {
      name: req.body.name,
      description: req.body.description
    };
    User = global.db.models.user;
    Group = global.db.models.group;
    creator = void 0;
    return global.db.Promise.resolve().then(function() {
      if (!req.session.user) {
        throw new myUtils.Error.UnknownUser();
      }
      return User.find(req.session.user.id);
    }).then(function(user) {
      if (!user) {
        throw new myUtils.Error.UnknownUser();
      }
      creator = user;
      return Group.create(form);
    }).then(function(group) {
      return group.setCreator(creator);
    }).then(function(group) {
      return group.addUser(creator, {
        access_level: 'owner'
      });
    }).then(function() {
      req.flash('info', 'create group successfully');
      return res.redirect(HOME_PAGE);
    })["catch"](myUtils.Error.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](global.db.ValidationError, function(err) {
      req.flash('info', err.errors[0].path + " : " + err.errors[0].message);
      return res.redirect(CREATE_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(INDEX_PAGE);
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
