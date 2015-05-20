// Generated by CoffeeScript 1.9.2
(function() {
  var HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, LOGOUT_PAGE, REGISTER_PAGE, myUtils, passwordHash;

  passwordHash = require('password-hash');

  myUtils = require('./utils');

  HOME_PAGE = '/';

  LOGIN_PAGE = 'login';

  REGISTER_PAGE = 'register';

  LOGOUT_PAGE = 'logout';

  INDEX_PAGE = '.';

  exports.getIndex = function(req, res) {
    return res.render('index', {
      title: 'You have got user index here'
    });
  };


  /*
    @getLogin {Function} 显示login页面
   */

  exports.getLogin = function(req, res) {
    return res.render('user/login', {
      title: 'login'
    });
  };


  /*
    @postLogin {Function} 根据提交的login表单，创建session，并更新last_login
    @form {Object} 表单数据
      @username {String} 用户名 必要 只有字母组成 邮箱 长度1-30
      @password {String} 密码 必要 组成随意 长度6-30
   */

  exports.postLogin = function(req, res) {
    var User, form;
    form = {
      username: req.body.username,
      password: req.body.password
    };
    User = global.db.models.user;
    return User.find({
      where: {
        username: form.username
      }
    }).then(function(user) {
      if (!user) {
        throw new myUtils.Error.LoginError();
      }
      if (!passwordHash.verify(form.password, user.password)) {
        throw new myUtils.Error.LoginError();
      }
      myUtils.login(req, res, user);
      user.last_login = new Date();
      return user.save();
    }).then(function() {
      req.flash('info', 'login successfully');
      return res.redirect(HOME_PAGE);
    })["catch"](myUtils.Error.LoginError, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(INDEX_PAGE);
    });
  };


  /*
    @getRegister {Function} 提供注册页面
   */

  exports.getRegister = function(req, res) {
    return res.render('user/register', {
      title: 'register'
    });
  };


  /*
    @postRegister {Function} 根据提交的register表单，在数据库中创建相应的实例
    @form {Object} 提交的表单
      @username {String} 用户名 必要 只有字母组成 邮箱 长度1-30
      @password {String} 密码 必要 组成随意 长度6-30
      @nickname {String} 昵称 必要 组成随意 长度1-30
   */

  exports.postRegister = function(req, res) {
    var User, form;
    form = {
      username: req.body.username,
      password: req.body.password,
      nickname: req.body.nickname,
      school: req.body.school
    };
    User = global.db.models.user;
    return global.db.Promise.resolve().then(function() {
      if (form.password !== req.body.password2) {
        throw new myUtils.Error.RegisterError("Please confirm your password.");
      }
      form.password = passwordHash.generate(form.password);
      return User.create(form);
    }).then(function(user) {
      myUtils.login(req, res, user);
      req.flash('info', 'You have registered.');
      return res.redirect(HOME_PAGE);
    })["catch"](global.db.ValidationError, function(err) {
      req.flash('info', err.errors[0].path + " : " + err.errors[0].message);
      return res.redirect(REGISTER_PAGE);
    })["catch"](myUtils.Error.RegisterError, function(err) {
      req.flash('info', err.message);
      return res.redirect(REGISTER_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(INDEX_PAGE);
    });
  };


  /*
    @getLogout {Function} 取消登录
   */

  exports.getLogout = function(req, res) {
    myUtils.logout(req);
    return res.redirect(HOME_PAGE);
  };

}).call(this);

//# sourceMappingURL=controller.js.map
