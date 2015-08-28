// Generated by CoffeeScript 1.9.3
(function() {
  var BACK_PAGE, EDIT_PAGE, HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, UPDATE_PWD_PAGE, USER_PAGE, passwordHash;

  passwordHash = require('password-hash');

  UPDATE_PWD_PAGE = 'updatepw';

  EDIT_PAGE = 'edit';

  INDEX_PAGE = 'index';

  BACK_PAGE = 'back';

  LOGIN_PAGE = '/user/login';

  USER_PAGE = '/user';

  HOME_PAGE = '/';

  exports.getIndex = function(req, res) {
    var User;
    User = global.db.models.user;
    return User.find(req.params.userID).then(function(user) {
      if (!user) {
        throw new global.myErrors.UnknownUser();
      }
      return res.render('user/detail', {
        user: req.session.user,
        target: user
      });
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(USER_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };

  exports.getEdit = function(req, res) {
    var User;
    User = global.db.models.user;
    return User.find(req.params.userID).then(function(user) {
      if (!req.session.user) {
        throw new global.myErrors.UnknownUser();
      }
      if (!user) {
        throw new global.myErrors.InvalidAccess();
      }
      if (user.id !== req.session.user.id) {
        throw new global.myErrors.InvalidAccess();
      }
      return res.render('user/user_edit', {
        user: req.session.user,
        target: user
      });
    })["catch"](global.myErrors.InvalidAccess, function(err) {
      req.flash('info', err.message);
      return res.redirect(INDEX_PAGE);
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };

  exports.postEdit = function(req, res) {
    var User;
    User = global.db.models.user;
    return User.find(req.params.userID).then(function(user) {
      var i;
      if (!req.session.user) {
        throw new global.myErrors.UnknownUser();
      }
      if (!user) {
        throw new global.myErrors.InvalidAccess();
      }
      if (user.id !== req.session.user.id) {
        throw new global.myErrors.InvalidAccess();
      }
      for (i in req.body) {
        user[i] = req.body[i];
      }
      return user.save();
    }).then(function(user) {
      global.myUtils.login(req, res, user);
      req.flash('info', 'You have updated');
      return res.redirect('index');
    })["catch"](global.myErrors.InvalidAccess, function(err) {
      req.flash('info', err.message);
      return res.redirect(INDEX_PAGE);
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](global.db.ValidationError, function(err) {
      req.flash('info', err.errors[0].path + " : " + err.errors[0].message);
      return res.redirect(EDIT_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };

  exports.getUpdatePW = function(req, res) {
    return global.db.Promise.resolve().then(function() {
      if (!req.session.user) {
        throw new global.myErrors.UnknownUser();
      }
      return res.render('user/user_updatepw', {
        user: req.session.user
      });
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };

  exports.postUpdatePW = function(req, res) {
    var User, form;
    form = {
      oldPwd: req.body.oldPwd,
      newPwd: req.body.newPwd,
      confirmNewPwd: req.body.confirmNewPwd
    };
    User = global.db.models.user;
    return User.find(req.params.userID).then(function(user) {
      if (!req.session.user) {
        throw new global.myErrors.UnknownUser();
      }
      if (!user) {
        throw new global.myErrors.InvalidAccess();
      }
      if (user.id !== req.session.user.id) {
        throw new global.myErrors.InvalidAccess();
      }
      if (!passwordHash.verify(form.oldPwd, user.password)) {
        throw new global.myErrors.UpdateError("Wrong password");
      }
      if (form.newPwd !== form.confirmNewPwd) {
        throw new global.myErrors.UpdateError("Please confirm your password");
      }
      user.password = passwordHash.generate(form.newPwd);
      return user.save();
    }).then(function() {
      global.myUtils.logout(req, res);
      req.flash('info', 'You have updated your password, please login again');
      return res.redirect(LOGIN_PAGE);
    })["catch"](global.myErrors.UpdateError, function(err) {
      req.flash('info', err.message);
      return res.redirect(UPDATE_PWD_PAGE);
    })["catch"](global.myErrors.InvalidAccess, function(err) {
      req.flash('info', err.message);
      return res.redirect(INDEX_PAGE);
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
