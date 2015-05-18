// Generated by CoffeeScript 1.9.2
(function() {
  var EDIT_PAGE, HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, UPDATE_PWD_PAGE, myUtils, passwordHash;

  passwordHash = require('password-hash');

  myUtils = require('../../utils');

  HOME_PAGE = '/';

  UPDATE_PWD_PAGE = 'updatepw';

  EDIT_PAGE = 'edit';

  INDEX_PAGE = '.';

  LOGIN_PAGE = HOME_PAGE + 'user/login';

  exports.getIndex = function(req, res) {
    var User;
    User = global.db.models.user;
    return User.find(req.param.userID).then(function(user) {
      if (user) {
        return res.render('user/detail', {
          title: 'Your userID=' + req.param.userID,
          user: {
            id: user.id,
            email: user.username,
            nickname: user.nickname,
            school: user.school,
            college: user.college,
            description: user.description,
            student_id: user.student_id
          }
        });
      } else {
        req.flash('info', 'unknown user');
        return req.redirect(HOME_PAGE);
      }
    })["catch"](function(err) {
      req.flash('info', err.message);
      return res.redirect(HOME_PAGE);
    });
  };

  exports.getEdit = function(req, res) {
    var User;
    User = global.db.models.user;
    return User.find(req.param.userID).then(function(user) {
      if (user) {
        return res.render('user/user_edit', {
          title: 'You are at EDIT page',
          user: {
            id: user.id,
            email: user.username,
            nickname: user.nickname,
            school: user.school,
            college: user.college,
            description: user.description,
            student_id: user.student_id
          }
        });
      } else {
        req.flash('info', 'unknown user');
        return req.redirect(INDEX_PAGE);
      }
    })["catch"](function(err) {
      req.flash('info', err.message);
      return res.redirect(INDEX_PAGE);
    });
  };

  exports.getUpdatePw = function(req, res) {
    return res.render('user/user_updatepw', {
      title: 'You are at Update Password Page'
    });
  };

  exports.postEdit = function(req, res) {
    var User;
    User = global.db.models.user;
    return User.find(req.param.userID).then(function(user) {
      if (user) {
        if (req.body.nickname) {
          user.nickname = req.body.nickname;
        }
        if (req.body.school) {
          user.school = req.body.school;
        }
        if (req.body.college) {
          user.college = req.body.college;
        }
        if (req.body.description) {
          user.description = req.body.description;
        }
        return user.save().then(function() {
          req.flash('info', 'You have updated your info');
          return res.redirect('.');
        });
      } else {
        req.flash('info', 'unknown user');
        return res.redirect(INDEX_PAGE);
      }
    })["catch"](function(err) {
      req.flash('info', err.message);
      return res.redirect(HOME_PAGE);
    });
  };

  exports.postPassword = function(req, res) {
    var User, form;
    form = {
      oldPwd: req.body.oldPwd,
      newPwd: passwordHash.generate(req.body.newPwd)
    };
    User = global.db.models.user;
    return User.find(req.param.userID).then(function(user) {
      if (passwordHash.verify(form.oldPwd, user.password)) {
        user.password = form.newPwd;
        return user.save().then(function() {
          myUtils.logout(req, res);
          req.flash('info', 'You have updated your password, please login again');
          return res.redirect(LOGIN_PAGE);
        });
      } else {
        req.flash('info', 'Wrong password');
        return res.redirect(UPDATE_PWD_PAGE);
      }
    })["catch"](function(err) {
      req.flash('info', err.message);
      return res.redirect(HOME_PAGE);
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
