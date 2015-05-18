
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
UPDATE_PWD_PAGE = 'updatepw'
EDIT_PAGE = 'edit'
INDEX_PAGE = '.'
LOGIN_PAGE = './login'

exports.getIndex = (req, res) ->
  User = global.db.models.user
  User.find req.param.userID
  .then (user) ->
    if user
      res.render 'user', {
        title: 'Your userID=' + req.param.userID,
        user: {
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
      res.render 'user_edit', {
        title: 'You are at EDIT page',
        user: {
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

exports.postEdit = (req, res)->
  User = global.db.models.user
  User.find req.param.userID
  .then (user) ->
    if user
      if req.param.nickname then user.nickname = req.param.nickname
      if req.param.school then user.school = req.param.school
      if req.param.college then user.college = req.param.college
      if req.param.description then user.description = req.param.description
      user.save().then ->
        req.flash 'info', 'You have updated your info'
        res.redirect '.'
    else
      req.flash 'info', 'unknown user'
      res.redirect INDEX_PAGE
  .catch (err) ->
    req.flash 'info', err.message
    res.redirect INDEX_PAGE

exports.postPassword = (req, res)->
  User = global.db.models.user
  User.find req.param.userID
  .then (user) ->
    if req.param.oldPwd && req.param.oldPwd == req.param.newPwd
      user.password = req.param.newPwd
      user.save().then ->
        delete req.session.userID
        delete req.session.nickname
        req.flash 'info', 'You have updated your password, please login again'
        res.redirect LOGIN_PAGE
    else
      req.flash 'info', 'Wrong password'
      res.redirect UPDATE_PWD_PAGE
  .catch (err) ->
    req.flash 'info', err.message
    res.redirect INDEX_PAGE