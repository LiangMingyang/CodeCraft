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
    opt = {
      contest_id : null
      offset : req.query.offset
    }
    global.myUtils.findSubmissions(user, opt, [
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

exports.postIndex = (req, res) ->
  User = global.db.models.user
  opt = {}
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    opt.offset = req.query.offset
    opt.nickname = req.body.nickname if req.body.nickname isnt ''
    opt.problem_id = req.body.problem_id if req.body.problem_id isnt ''
    #opt.contest_id = req.body.contest_id if req.body.contest_id isnt ''
    opt.contest_id = null #在表站只能看到非比赛中的提交记录
    opt.language = req.body.language if req.body.language isnt ''
    opt.result = req.body.result if req.body.result isnt ''
    global.myUtils.findSubmissions(user, opt, [
      model : User
      as : 'creator'
    ])
  .then (submissions)->
    res.render 'submission/index', {
      user : req.session.user
      submissions : submissions
      offset : opt.offset
      pageLimit : global.config.pageLimit.submission
      query : req.body
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
