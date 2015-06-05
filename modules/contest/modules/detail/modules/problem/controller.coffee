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
  currentContest = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    myUtils.findContest(user,req.params.contestID)
  .then (contest)->
    throw new myUtils.Error.UnknownContest() if not contest
    currentContest = contest
    order = myUtils.lettersToNumber(req.params.problemID)
    myUtils.findProblemWithContest(contest, order, [
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
      contest : currentContest
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
  Group = global.db.models.group
  currentUser = undefined
  currentSubmission = undefined
  currentProblem = undefined
  currentContest = undefined


  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    myUtils.findContest(user,req.params.contestID)
  .then (contest)->
    throw new myUtils.Error.UnknownContest() if not contest
    currentContest = contest
    order = myUtils.lettersToNumber(req.params.problemID)
    myUtils.findProblemWithContest(contest,order, [
      model : User
      as : 'creator'
    ,
      model : Group
    ])
  .then (problem) ->
    throw new myUtils.Error.UnknownProblem() if not problem
    currentProblem = problem
    Submission.create(form)
  .then (submission) ->
    currentUser.addSubmission(submission)
    currentProblem.addSubmission(submission)
    currentContest.addSubmission(submission)
    currentSubmission = submission
    Submission_Code.create(form_code)
  .then (code) ->
    currentSubmission.setSubmission_code(code)
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
  Group = global.db.models.group
  Contest = global.db.models.contest
  currentProblem = undefined
  currentContest = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    myUtils.findContest(user,req.params.contestID)
  .then (contest)->
    throw new myUtils.Error.UnknownContest() if not contest
    currentContest = contest
    order = myUtils.lettersToNumber(req.params.problemID)
    myUtils.findProblemWithContest(contest,order, [
      model : User
      as : 'creator'
    ,
      model : Group
    ])
  .then (problem)->
    throw new myUtils.Error.UnknownProblem() if not problem
    currentProblem = problem
    problem.getSubmissions({
      include: [
        model: User
        as : 'creator'
      ,
        model: Contest
        where:
          id : currentContest.id
      ]
      order : [
        ['created_at', 'DESC']
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



