passwordHash = require('password-hash')
Promise = require('sequelize').Promise
rp = require('request-promise')
#global.myUtils = require('./utils')
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
PREVIOUS_PAGE = 'back'
LOGIN_PAGE = 'login'
REGISTER_PAGE = 'register'
LOGOUT_PAGE = 'logout'
INDEX_PAGE = 'index'

#index

exports.getIndex = (req, res) ->
  res.render 'index', {
    title: 'You have got user index here'
  }

#login

###
  @getLogin {Function} 显示login页面
###
exports.getLogin = (req, res) ->
  if req.session.user
    res.render 'error', error: new Error("=.=")
    return
  res.render 'user/login', {
    title: 'login'
    returnUrl: req?.headers?.referer
  }

###
  @postLogin {Function} 根据提交的login表单，创建session，并更新last_login
  @form {Object} 表单数据
    @username {String} 用户名 必要 只有字母组成 邮箱 长度1-30
    @password {String} 密码 必要 组成随意 长度6-30
###

exports.postLogin = (req, res) ->
  form = {
    username: req.body.username
    password: req.body.password
  }

  #precheckForLogin(form)
  User = global.db.models.user

  User.find {
    where:
      username: form.username
  }
  .then (user)->
#过滤
    throw new global.myErrors.LoginError() if not user #没有找到该用户
    throw new global.myErrors.LoginError() if not passwordHash.verify(form.password, user.password) #判断密码是否正确
    global.myUtils.login(req, res, user)
    user.last_login = new Date()
    user.save()
  .then ->
    req.flash 'info', 'login successfully'
    NEXT_PAGE = undefined
    console.log req.body.returnUrl
    if req.body.returnUrl is 'undefined'
      NEXT_PAGE = HOME_PAGE
    else
      NEXT_PAGE = req.body.returnUrl
    res.redirect NEXT_PAGE


  .catch global.myErrors.LoginError, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch (err)->
    console.error err
    err.message = "未知错误"
    res.render 'error', error: err

#register

###
  @getRegister {Function} 提供注册页面
###

exports.getRegister = (req, res) ->
  res.render 'user/register', {
    title: 'register'
  }

###
  @postRegister {Function} 根据提交的register表单，在数据库中创建相应的实例
  @form {Object} 提交的表单
    @username {String} 用户名 必要 只有字母组成 邮箱 长度1-30
    @password {String} 密码 必要 组成随意 长度6-30
    @nickname {String} 昵称 必要 组成随意 长度1-30　　
###

exports.postRegister = (req, res) ->
#get data from submit data
  form = {
    username: req.body.username
    password: req.body.password
    nickname: req.body.nickname
    school  : req.body.school
    college : req.body.college
  }
  #precheckForRegister(form)
  User = global.db.models.user
  global.db.Promise.resolve()
  .then ->
    throw new global.myErrors.RegisterError("Please confirm your password.") if form.password isnt req.body.password2
    form.password = passwordHash.generate(form.password) #对密码进行加密
    User.create form #存入数据库
  .then (user)->
    global.myUtils.login(req, res, user)
    req.flash 'info', 'You have registered.'
    res.render 'error', error: err


  .catch global.db.ValidationError, (err)->
    req.flash 'info', "#{err.errors[0].path} : #{err.errors[0].message}"
    res.redirect REGISTER_PAGE
  .catch global.myErrors.RegisterError, (err)->
    req.flash 'info', err.message
    res.redirect REGISTER_PAGE
  .catch (err)->
    console.error err
    err.message = "未知错误"
    res.render 'error', error: err

#logout

###
  @getLogout {Function} 取消登录
###

exports.getLogout = (req, res) ->
  global.myUtils.logout(req)
  res.redirect LOGIN_PAGE


#exports.getBinding = (req, res)->
#  User = global.db.models.user
#  currentUser = undefined
#  global.db.Promise.resolve()
#  .then ->
#    User.find req.session.user.id if req.session.user
#  .then (user)->
#    throw new global.myErrors.UnknownUser() if not user
#    currentUser = user
#    rp("http://ecampus.buaa.edu.cn/cas/serviceValidate?ticket=#{req.query.ticket}&service=http://127.0.0.1:4000/user/binding") #TODO: 这里是写死的网址
#  .then (xml)->
#    xml2js.parseStringPromised xml
#  .then (xjson)->
#    throw new global.myErrors.InvalidAccess() if not xjson['cas:serviceResponse']['cas:authenticationSuccess']
#    currentUser.student_id = xjson['cas:serviceResponse']['cas:authenticationSuccess'][0]['cas:user'][0]
#    currentUser.save()
#  .then ->
#    req.flash('info','Binding successfully.')
#    res.redirect "./#{currentUser.id}"
#  .catch global.myErrors.UnknownUser, (err)->
#    req.flash('info', err.message)
#    res.redirect LOGIN_PAGE
#  .catch global.myErrors.InvalidAccess, (err)->
#    req.flash('info', err.message)
#    res.render 'error', error: err
#  .catch (err)->
#    console.error err
#    req.flash('info', "Unknown Error.")
#    res.render 'error', error: err
