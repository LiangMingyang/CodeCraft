// Generated by CoffeeScript 1.9.3
(function() {
  var HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, LOGOUT_PAGE, PREVIOUS_PAGE, Promise, REGISTER_PAGE, passwordHash, rp, xml2js;

  passwordHash = require('password-hash');

  Promise = require('sequelize').Promise;

  rp = require('request-promise');

  xml2js = Promise.promisifyAll(require('xml2js'), {
    suffix: 'Promised'
  });

  HOME_PAGE = '/';

  PREVIOUS_PAGE = 'back';

  LOGIN_PAGE = 'login';

  REGISTER_PAGE = 'register';

  LOGOUT_PAGE = 'logout';

  INDEX_PAGE = 'index';

  exports.getIndex = function(req, res) {
    return res.render('index', {
      title: 'You have got user index here'
    });
  };


  /*
    @getLogin {Function} 显示login页面
   */

  exports.getLogin = function(req, res) {
    if (req.session.user) {
      res.redirect(HOME_PAGE);
      return;
    }
    return res.render('user/login', {
      title: 'login',
      returnUrl: req.get('Referer')
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
        throw new global.myErrors.LoginError();
      }
      if (!passwordHash.verify(form.password, user.password)) {
        throw new global.myErrors.LoginError();
      }
      global.myUtils.login(req, res, user);
      user.last_login = new Date();
      return user.save();
    }).then(function() {
      var NEXT_PAGE;
      req.flash('info', 'login successfully');
      NEXT_PAGE = void 0;
      if (req.body.returnUrl === 'undefined') {
        NEXT_PAGE = HOME_PAGE;
      } else {
        NEXT_PAGE = req.body.returnUrl;
      }
      return res.redirect(NEXT_PAGE);
    })["catch"](global.myErrors.LoginError, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
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
        throw new global.myErrors.RegisterError("Please confirm your password.");
      }
      form.password = passwordHash.generate(form.password);
      return User.create(form);
    }).then(function(user) {
      global.myUtils.login(req, res, user);
      req.flash('info', 'You have registered.');
      return res.redirect(HOME_PAGE);
    })["catch"](global.db.ValidationError, function(err) {
      req.flash('info', err.errors[0].path + " : " + err.errors[0].message);
      return res.redirect(REGISTER_PAGE);
    })["catch"](global.myErrors.RegisterError, function(err) {
      req.flash('info', err.message);
      return res.redirect(REGISTER_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };


  /*
    @getLogout {Function} 取消登录
   */

  exports.getLogout = function(req, res) {
    global.myUtils.logout(req);
    return res.redirect(LOGIN_PAGE);
  };

  exports.getBinding = function(req, res) {
    var User, currentUser;
    User = global.db.models.user;
    currentUser = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      if (!user) {
        throw new global.myErrors.UnknownUser();
      }
      currentUser = user;
      return rp("http://ecampus.buaa.edu.cn/cas/serviceValidate?ticket=" + req.params.ticket + "&service=http://127.0.0.1:4000/user/binding");
    }).then(function(xml) {
      return xml2js.parseStringPromised(xml);
    }).then(function(xjson) {
      currentUser.student_id = xjson['cas:serviceResponse']['cas:authenticationSuccess'][0]['cas:user'][0];
      return currentUser.save();
    }).then(function() {
      req.flash('info', 'Binding successfully.');
      return res.redirect("./" + currentUser.id);
    })["catch"](global.myErrors.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error.");
      return res.redirect(HOME_PAGE);
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
