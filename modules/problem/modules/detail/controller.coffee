#global.myUtils = require('./utils')
sequelize = require('sequelize')
fs = sequelize.Promise.promisifyAll(require('fs'), suffix:'Promised')
path = require('path')
markdown = require('markdown').markdown
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
SUBMISSION_PAGE = 'submission'
SUBMIT_PAGE = 'submit'
PROBLEM_PAGE = '..'

INDEX_PAGE = 'index'

#Foreign url
LOGIN_PAGE = '/user/login'

exports.getIndex = (req, res) ->
  User = global.db.models.user
  Group = global.db.models.group
  currentProblem = undefined
  currentUser = undefined
  currentProblems = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    global.myUtils.findProblem(user, req.params.problemID, [
      model : User
      as : 'creator'
    ,
      model : Group
    ])
  .then (problem) ->
    throw new global.myErrors.UnknownProblem() if not problem
    currentProblem = problem
    #TODO: 在这里进行了转码
    problem.test_setting = JSON.parse problem.test_setting
    problem.description = markdown.toHTML(problem.description)
    currentProblems = [currentProblem]
    global.myUtils.getProblemsStatus(currentProblems,currentUser)
  .then ->
    res.render 'problem/detail', {
      user: req.session.user
      problem: currentProblem
    }

  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch global.myErrors.UnknownProblem, (err)->
    req.flash 'info', err.message
    res.redirect PROBLEM_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown error!'
    res.redirect HOME_PAGE

exports.postSubmission = (req, res) ->
  User = global.db.models.user
  current_user = undefined
  current_problem = undefined

  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    throw new global.myErrors.UnknownUser() if not user
    current_user = user
    global.myUtils.findProblem(user, req.params.problemID)
  .then (problem) ->
    throw new global.myErrors.UnknownProblem() if not problem
    current_problem = problem
    form = {
      lang : req.body.lang
      code_length : req.body.code.length
    }
    form_code = {
      content: req.body.code
    }
    global.myUtils.createSubmissionTransaction(form, form_code, current_problem, current_user)
  .then ->
    req.flash 'info', 'submit code successfully'
    res.redirect SUBMISSION_PAGE

  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch global.myErrors.UnknownProblem, (err)->
    req.flash 'info', err.message
    res.redirect PROBLEM_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown Error!'
    res.redirect HOME_PAGE

exports.getSubmissions = (req, res) ->
  User = global.db.models.user
  currentProblem = undefined
  currentUser = undefined
  currentProblems = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    global.myUtils.findProblem(user, req.params.problemID)
  .then (problem)->
    throw new global.myErrors.UnknownProblem() if not problem
    currentProblem = problem
    currentProblems = [problem]
    global.myUtils.getProblemsStatus(currentProblems,currentUser)
  .then ->
    opt = {
      offset: req.query.offset
      problem_id: currentProblem.id
    }
    global.myUtils.findSubmissions(currentUser, opt, [
      model : User
      as : 'creator'
    ])
  .then (submissions) ->
    currentProblem.test_setting = JSON.parse(currentProblem.test_setting)
    res.render('problem/submission', {
      submissions: submissions
      problem : currentProblem
      user: req.session.user
      offset : req.query.offset
      pageLimit : global.config.pageLimit.submission
    })

  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch global.myErrors.UnknownProblem, (err)->
    req.flash 'info', err.message
    res.redirect PROBLEM_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown error!'
    res.redirect HOME_PAGE


exports.postSubmissions = (req, res) ->
  User = global.db.models.user
  currentProblem = undefined
  currentUser = undefined
  currentProblems = undefined
  opt = {}
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    global.myUtils.findProblem(user, req.params.problemID)
  .then (problem)->
    throw new global.myErrors.UnknownProblem() if not problem
    currentProblem = problem
    currentProblems = [problem]
    global.myUtils.getProblemsStatus(currentProblems,currentUser)
  .then ->
    opt.offset = req.query.offset
    opt.nickname = req.body.nickname if req.body.nickname isnt ''
    opt.problem_id = currentProblem.id
    opt.contest_id = req.body.contest_id if req.body.contest_id isnt ''
    opt.language = req.body.language if req.body.language isnt ''
    opt.result = req.body.result if req.body.result isnt ''
    global.myUtils.findSubmissions(currentUser, opt, [
      model : User
      as : 'creator'
    ])
  .then (submissions) ->
    currentProblem.test_setting = JSON.parse(currentProblem.test_setting)
    res.render('problem/submission', {
      submissions: submissions
      problem : currentProblem
      user: req.session.user
      offset : req.query.offset
      pageLimit : global.config.pageLimit.submission
      query : req.body
    })

  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch global.myErrors.UnknownProblem, (err)->
    req.flash 'info', err.message
    res.redirect PROBLEM_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown error!'
    res.redirect HOME_PAGE