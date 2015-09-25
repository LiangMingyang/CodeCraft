#global.myUtils = require('./utils')

INDEX_PAGE = 'index'

LOGIN_PAGE = '/user/login'
HOME_PAGE = '/'

exports.getIndex = (req, res) ->
  User = global.db.models.user
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    throw new global.myErrors.UnknownUser() if not user
    res.render('feedback', {
      user: user
    })
  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown Error.'
    res.redirect HOME_PAGE

exports.postIndex = (req, res)->
  User = global.db.models.user
  Feedback = global.db.models.feedback
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    throw new global.myErrors.UnknownUser() if not user
    form = {
      title : req.body.title
      content : req.body.content
    }
    Feedback.create(form)
  .then ->
    req.flash 'info' , 'Received.'
    res.redirect HOME_PAGE

  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown Error.'
    res.redirect HOME_PAGE


