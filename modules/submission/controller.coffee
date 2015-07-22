#global.myUtils = require('./utils')

INDEX_PAGE = 'index'

LOGIN_PAGE = 'user/login'
HOME_PAGE = '/'

exports.getIndex = (req, res) ->
  User = global.db.models.user
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    global.myUtils.findSubmissions(user,req.query.offset,[
      model : User
      as : 'creator'
    ])
  .then (submissions)->
    res.render 'submission/index', {
      user : req.session.user
      submissions : submissions
      offset : req.query.offset
      pageLimit : global.config.pageLimit.submission
    }
  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getSubmission = (req, res)->
  User = global.db.models.user
  SubmissionCode = global.db.models.submission_code
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    global.myUtils.findSubmission(user, req.params.submissionID, [
      model : SubmissionCode
    ])
  .then (submission)->
    throw new global.myErrors.UnknownSubmission() if not submission
    res.render 'submission/code', {
      user : req.session.user
      submission : submission
    }
  .catch global.myErrors.UnknownSubmission, (err)->
    req.flash 'info', err.message
    res.redirect INDEX_PAGE
  .catch global.myErrors.UnknownUser, (err)->
    console.log err
    req.flash 'info', "Please Login First!"
    res.redirect LOGIN_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE
