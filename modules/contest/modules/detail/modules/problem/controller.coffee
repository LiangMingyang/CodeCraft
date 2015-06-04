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
CONTEST_PAGE = '/contest'

exports.getIndex = (req, res) ->
  Problem = global.db.models.problem
  User = global.db.models.user
  Group = global.db.models.group
  currentProblem = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    myUtils.findProblem(user, req.body.problemID, [
      model : User
      as : 'creator'
    ,
      model : Group
    ])
  .then (problem) ->
    throw new myUtils.Error.UnknownProblem() if not problem
    currentProblem = problem
    fs.readFilePromised path.join(myUtils.getStaticProblem(problem.id), 'manifest.json')
  .then (manifest_str) ->
    manifest = JSON.parse manifest_str
    currentProblem.test_setting = manifest.test_setting
    fs.readFilePromised path.join(myUtils.getStaticProblem(currentProblem.id), manifest.description)
  .then (description)->
    currentProblem.description = markdown.toHTML(description.toString())
    res.render 'problem/detail', {
      title: 'Problem List Page',
      user: req.session.user,
      problem: currentProblem
      contest : req.body.contest
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

  form = {
    lang: req.body.lang
  }

  form_code = {
    content: req.body.code
  }

  Submission = global.db.models.submission
  Submission_Code = global.db.models.submission_code
  User = global.db.models.user
  current_user = undefined
  current_submission = undefined
  current_problem = undefined


  global.db.Promise.resolve()
  .then ->
    throw new myUtils.Error.UnknownContest() if req.body.contest and (new Date())>req.body.contest.end_time
    User.find req.session.user.id if req.session.user
  .then (user)->
    throw new myUtils.Error.UnknownUser() if not user
    current_user = user
    myUtils.findProblem(user, req.body.problemID)
  .then (problem) ->
    throw new myUtils.Error.UnknownProblem() if not problem
    current_problem = problem
    Submission.create(form)
  .then (submission) ->
    current_user.addSubmission(submission)
    current_problem.addSubmission(submission)
    current_submission = submission
    req.body.contest.addSubmission(submission) if req.body.contest
    Submission_Code.create(form_code)
  .then (code) ->
    current_submission.setSubmission_code(code)
  .then ->
    req.flash 'info', 'submit code successfully'
    res.redirect SUBMISSION_PAGE

  .catch myUtils.Error.UnknownContest, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
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
  Contest = global.db.models.contest
  currentProblem = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    myUtils.findProblem(user, req.body.problemID)
  .then (problem)->
    throw new myUtils.Error.UnknownProblem() if not problem
    currentProblem = problem
    include = [
      model: User
      as : 'creator'
    ]
    if req.body.contest
      include.push {
        model: Contest
        where:
          id : req.body.contest.id
      }
    problem.getSubmissions({
      include: include
      order : [
        ['id', 'DESC']
      ]
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

exports.getCode = (req, res) ->
  Submission_Code = global.db.models.submission_code
  Submission_Code.find req.params.submissionID
  .then (code) ->
    res.json({
      code: code.content,
      user: req.session.user
    })



