passwordHash = require('password-hash')
myUtils = require('../../utils')
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
UPDATE_PWD_PAGE = 'updatepw'
EDIT_PAGE = 'edit'
INDEX_PAGE = '.'
LOGIN_PAGE = HOME_PAGE + 'user/login'

exports.getIndex = (req, res) ->
  User = global.db.models.user
  User.find req.param.userID
  .then (user) ->
    if user
      res.render 'user/detail', {
        title: 'Your userID=' + req.param.userID,
        user: {
          id: user.id
          email: user.username,
          nickname: user.nickname,
          school: user.school,
          college: user.college,
          description: user.description,
          student_id: user.student_id
        }
      }
    else
      req.flash 'info', 'unknown user'
      req.redirect HOME_PAGE
  .catch (err) ->
    req.flash 'info', err.message
    res.redirect HOME_PAGE


exports.getEdit = (req, res)->
  User = global.db.models.user
  User.find req.param.userID
  .then (user) ->
    if user
      res.render 'user/user_edit', {
        title: 'You are at EDIT page',
        user: {
          id: user.id
          email: user.username,
          nickname: user.nickname,
          school: user.school,
          college: user.college,
          description: user.description,
          student_id: user.student_id
        }
      }
    else
      req.flash 'info', 'unknown user'
      req.redirect INDEX_PAGE
  .catch (err) ->
    req.flash 'info', err.message
    res.redirect INDEX_PAGE

exports.getUpdatePw = (req, res) ->
  res.render 'user/user_updatepw', {
    title: 'You are at Update Password Page'
  }

exports.postEdit = (req, res)->
  User = global.db.models.user
  User.find req.param.userID
  .then (user) ->
    if user
      if req.body.nickname then user.nickname = req.body.nickname
      if req.body.school then user.school = req.body.school
      if req.body.college then user.college = req.body.college
      if req.body.description then user.description = req.body.description
      user.save().then ->
        req.flash 'info', 'You have updated your info'
        res.redirect '.'
    else
      req.flash 'info', 'unknown user'
      res.redirect INDEX_PAGE
  .catch (err) ->
    req.flash 'info', err.message
    res.redirect HOME_PAGE

exports.postPassword = (req, res)->
  form = {
    oldPwd: req.body.oldPwd,
    newPwd: req.body.newPwd,
    confirmNewPwd: req.body.confirmNewPwd
  }

  User = global.db.models.user
  User.find req.param.userID
  .then (user) ->
    if passwordHash.verify(form.oldPwd, user.password)
      if form.newPwd == form.confirmNewPwd
        user.password = passwordHash.generate(form.newPwd)
        user.save().then ->
          myUtils.logout(req, res)
          req.flash 'info', 'You have updated your password, please login again'
          res.redirect LOGIN_PAGE
      else
        req.flash 'info', 'Inconsistent Password'
        res.redirect UPDATE_PWD_PAGE
    else
      req.flash 'info', 'Wrong password'
      res.redirect UPDATE_PWD_PAGE
  .catch (err) ->
    req.flash 'info', err.message
    res.redirect HOME_PAGE