// Generated by CoffeeScript 1.10.0
(function() {
  var HOME_PAGE, INDEX_PAGE, LOGIN_PAGE;

  INDEX_PAGE = 'index';

  LOGIN_PAGE = '/user/login';

  HOME_PAGE = '/';

  exports.getIndex = function(req, res) {
    var User;
    User = global.db.models.user;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      if (!user) {
        throw new global.myErrors.UnknownUser();
      }
      return res.render('feedback', {
        user: user
      });
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

  exports.postIndex = function(req, res) {
    var Feedback, User, currentUser;
    User = global.db.models.user;
    Feedback = global.db.models.feedback;
    currentUser = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      var form;
      if (!user) {
        throw new global.myErrors.UnknownUser();
      }
      currentUser = user;
      form = {
        title: req.body.title,
        content: req.body.content
      };
      return Feedback.create(form);
    }).then(function(fb) {
      return fb.setCreator(currentUser);
    }).then(function() {
      req.flash('info', 'Received.');
      return res.render('error', {
        error: err
      });
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
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
