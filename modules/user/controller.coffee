passwordHash = require('password-hash')

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
  res.render 'login', {
    title: 'login'
  }

###
    @postLogin {Function} 根据提交的login表单，创建session，并更新last_login
###

exports.postLogin = (req, res) ->
  form = {
    username : req.body.username
    password : req.body.password
  }

  #precheckForLogin(form)

  global.db.models.user.find {
    where:
      username:form.username
  }
  .then (user)->
    if not user #没有找到该用户
      req.flash 'info', 'not find this user'
      res.redirect('/user/login')
      return
    if passwordHash.verify(form.password, user.password) #判断密码是否正确
      req.session.userID = user.id
      req.session.nickname = user.nickname
      req.flash 'info', 'login successfully'
      res.redirect('/')
    else
      req.flash 'info', 'wrong password'
      res.redirect('/user/login')
  .catch (err)->
    req.flash 'info', err.message
    res.redirect('/user/login')

#register

exports.getRegister = (req, res) ->
  res.render 'register', {
    title: 'register'
  }
###
  @postRegister {Function} 根据提交的register表单，在数据库中创建相应的实例
  @req.body {Object} 提交的表单
    @username {String} 用户名 必要 只有字母组成 邮箱 长度1-30
    @password {String} 密码 必要 组成随意 长度6-30
    @nickname {String} 昵称 必要 组成随意 长度1-30　　
###
exports.postRegister = (req, res) ->
  #get data from submit data
  user = {
    username : req.body.username
    password : req.body.password
    nickname : req.body.nickname
  }
  #precheckForRegister(data) 我们暂时不做检查
  #对密码进行加密
  user.password = passwordHash.generate(user.password)
  #存入数据库
  global.db.models.user
    .create user
    .then (user)->
      req.session.userID = user.id
      req.session.nickname = user.nickname
      req.flash 'info','You have registered.'
      res.redirect '/'
    .catch (err)->
      req.flash 'info',err.message
      res.redirect '/user/register'