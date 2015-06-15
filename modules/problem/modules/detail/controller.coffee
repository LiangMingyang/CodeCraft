myUtils = require('./utils')
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
    myUtils.findProblem(user, req.params.problemID, [
      model : User
      as : 'creator'
    ,
      model : Group
    ])
  .then (problem) ->
    throw new myUtils.Error.UnknownProblem() if not problem
    currentProblem = problem
    currentProblems = [currentProblem]
    myUtils.getProblemsStatus(currentProblems,currentUser)
  .then ->
    fs.readFilePromised path.join(myUtils.getStaticProblem(currentProblem.id), 'manifest.json')
  .then (manifest_str) ->
    manifest = JSON.parse manifest_str
    currentProblem.test_setting = manifest.test_setting
    fs.readFilePromised path.join(myUtils.getStaticProblem(currentProblem.id), manifest.description)
  .then (description)->
    currentProblem.description = markdown.toHTML(description.toString())
    res.render 'problem/detail', {
      user: req.session.user
      problem: currentProblem
    }

  .catch myUtils.Error.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch myUtils.Error.UnknownProblem, (err)->
    req.flash 'info', err.message
    res.redirect PROBLEM_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown error!'
    res.redirect HOME_PAGE

exports.postSubmission = (req, res) ->
  Submission = global.db.models.submission
  Submission_Code = global.db.models.submission_code
  User = global.db.models.user
  current_user = undefined
  current_submission = undefined
  current_problem = undefined

  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    throw new myUtils.Error.UnknownUser() if not user
    current_user = user
    myUtils.findProblem(user, req.params.problemID)
  .then (problem) ->
    throw new myUtils.Error.UnknownProblem() if not problem
    current_problem = problem
    form = {
      lang : req.body.lang
      code_length : req.body.code.length
    }
    Submission.create(form)
  .then (submission) ->
    current_user.addSubmission(submission)
    current_problem.addSubmission(submission)
    current_submission = submission
    form_code = {
      content: req.body.code
    }
    Submission_Code.create(form_code)
  .then (code) ->
    current_submission.setSubmission_code(code)
  .then ->
    req.flash 'info', 'submit code successfully'
    res.redirect SUBMISSION_PAGE

  .catch myUtils.Error.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch myUtils.Error.UnknownProblem, (err)->
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
    myUtils.findProblem(user, req.params.problemID)
  .then (problem)->
    throw new myUtils.Error.UnknownProblem() if not problem
    currentProblem = problem
    currentProblems = [problem]
    myUtils.getProblemsStatus(currentProblems,currentUser)
  .then ->
    fs.readFilePromised path.join(myUtils.getStaticProblem(currentProblem.id), 'manifest.json')
  .then (manifest_str) ->
    manifest = JSON.parse manifest_str
    currentProblem.test_setting = manifest.test_setting
    currentProblem.getSubmissions({
      include: [
        model: User
        as : 'creator'
      ]
      order : [
        ['created_at', 'DESC']
      ,
        ['id','DESC']
      ]
      where :
        contest_id : null
    })
  .then (submissions) ->
    res.render('problem/submission', {
      submissions: submissions
      problem : currentProblem
      user: req.session.user
    })

  .catch myUtils.Error.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch myUtils.Error.UnknownProblem, (err)->
    req.flash 'info', err.message
    res.redirect PROBLEM_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown error!'
    res.redirect HOME_PAGE


