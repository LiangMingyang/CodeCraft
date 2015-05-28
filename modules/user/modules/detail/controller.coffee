passwordHash = require('password-hash')
myUtils = require('./utils')
#page

#CURRENT_PAGE = "./#{ req.url }"
UPDATE_PWD_PAGE = 'updatepw'
EDIT_PAGE = 'edit'
INDEX_PAGE = 'index'
BACK_PAGE = 'back'

#FOREIGN_PAGE
LOGIN_PAGE = '/user/login'
USER_PAGE = '/user'
HOME_PAGE = '/'

exports.getIndex = (req, res) ->
  User = global.db.models.user
  User.find req.params.userID
  .then (user) ->
    throw new myUtils.Error.UnknownUser() if not user
    res.render 'user/detail', {
      user : req.session.user
      target : user
    }

  .catch myUtils.Error.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect USER_PAGE
  .catch (err) ->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE


exports.getEdit = (req, res)->
  User = global.db.models.user
  User.find req.params.userID
  .then (user) ->
    throw new myUtils.Error.UnknownUser() if not req.session.user
    throw new myUtils.Error.InvalidAccess() if not user
    throw new myUtils.Error.InvalidAccess() if user.id isnt req.session.user.id #这里设定为只有自己才能修改
    res.render 'user/user_edit', {
      user : req.session.user
      target: user
    }

  .catch myUtils.Error.InvalidAccess, (err)->
    req.flash 'info', err.message
    res.redirect INDEX_PAGE
  .catch myUtils.Error.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch (err) ->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.postEdit = (req, res)->
  User = global.db.models.user
  User.find req.params.userID
  .then (user) ->
    throw new myUtils.Error.UnknownUser() if not req.session.user
    throw new myUtils.Error.InvalidAccess() if not user
    throw new myUtils.Error.InvalidAccess() if user.id isnt req.session.user.id #这里设定为只有自己才能修改
    user[i] = req.body[i] for i of req.body
    user.save()
  .then (user)->
    myUtils.login(req,res,user)
    res.redirect 'index'

  .catch myUtils.Error.InvalidAccess, (err)->
    req.flash 'info', err.message
    res.redirect INDEX_PAGE
  .catch myUtils.Error.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch global.db.ValidationError, (err)->
    req.flash 'info', "#{err.errors[0].path} : #{err.errors[0].message}"
    res.redirect EDIT_PAGE
  .catch (err) ->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getUpdatePW = (req, res) ->
  global.db.Promise.resolve()
  .then ->
    throw new myUtils.Error.UnknownUser() if not req.session.user
    res.render 'user/user_updatepw', {
      user: req.session.user
    }

  .catch myUtils.Error.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch (err) ->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE




exports.postUpdatePW = (req, res)->
  form = {
    oldPwd: req.body.oldPwd,
    newPwd: req.body.newPwd,
    confirmNewPwd: req.body.confirmNewPwd
  }

  User = global.db.models.user
  User.find req.params.userID
  .then (user) ->
    throw new myUtils.Error.UnknownUser() if not req.session.user
    throw new myUtils.Error.InvalidAccess() if not user
    throw new myUtils.Error.InvalidAccess() if user.id isnt req.session.user.id #这里设定为只有自己才能修改
    throw new myUtils.Error.UpdateError("Wrong password") if not passwordHash.verify(form.oldPwd, user.password)
    throw new myUtils.Error.UpdateError("Please confirm your password")  if form.newPwd isnt form.confirmNewPwd
    user.password = passwordHash.generate(form.newPwd)
    user.save()
  .then ->
    myUtils.logout(req, res)
    req.flash 'info', 'You have updated your password, please login again'
    res.redirect LOGIN_PAGE

  .catch myUtils.Error.UpdateError, (err)->
    req.flash 'info', err.message
    res.redirect UPDATE_PWD_PAGE
  .catch myUtils.Error.InvalidAccess, (err)->
    req.flash 'info', err.message
    res.redirect INDEX_PAGE
  .catch myUtils.Error.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch (err) ->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE