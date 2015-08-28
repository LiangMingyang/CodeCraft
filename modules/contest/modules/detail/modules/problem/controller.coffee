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
CONTEST_PAGE = '/contest'

exports.getIndex = (req, res) ->
  User = global.db.models.user
  Problem = global.db.models.problem
  currentProblem = undefined
  currentContest = undefined
  currentProblems = undefined
  currentUser = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    global.myUtils.findContest(user,req.params.contestID,[
      model : Problem
    ])
  .then (contest)->
    throw new global.myErrors.UnknownContest() if not contest
    throw new global.myErrors.UnknownContest() if contest.start_time > (new Date())
    currentContest = contest
    contest.problems.sort (a,b)->
      a.contest_problem_list.order-b.contest_problem_list.order
    currentProblems = contest.problems
    global.myUtils.getProblemsStatus(currentProblems,currentUser,currentContest)
  .then ->
    order = global.myUtils.lettersToNumber(req.params.problemID)
    for problem in currentProblems
      if problem.contest_problem_list.order is order
        return problem
  .then (problem) ->
    throw new global.myErrors.UnknownProblem() if not problem
    currentProblem = problem
    fs.readFilePromised path.join(global.myUtils.getStaticProblem(problem.id), 'manifest.json')
  .then (manifest_str) ->
    manifest = JSON.parse manifest_str
    currentProblem.test_setting = manifest.test_setting
    fs.readFilePromised path.join(global.myUtils.getStaticProblem(currentProblem.id), manifest.description)
  .then (description)->
    currentProblem.description = markdown.toHTML(description.toString())
    for problem in currentContest.problems
      problem.contest_problem_list.order = global.myUtils.numberToLetters(problem.contest_problem_list.order)
    res.render 'problem/detail', {
      user: req.session.user,
      problem: currentProblem
      contest : currentContest
    }

  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch global.myErrors.UnknownProblem, (err)->
    req.flash 'info', err.message
    res.redirect PROBLEM_PAGE
  .catch global.myErrors.UnknownContest, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown error!'
    res.redirect HOME_PAGE

exports.postSubmission = (req, res) ->

  User = global.db.models.user
  Problem = global.db.models.problem
  currentUser = undefined
  currentSubmission = undefined
  currentProblem = undefined
  currentContest = undefined


  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    global.myUtils.findContest(user,req.params.contestID,[
      model : Problem
    ])
  .then (contest)->
    throw new global.myErrors.UnknownContest() if not contest
    throw new global.myErrors.InvalidAccess() if (new Date()) < contest.start_time or contest.end_time < (new Date())
    currentContest = contest
    order = global.myUtils.lettersToNumber(req.params.problemID)
    for p in contest.problems
      return p if p.contest_problem_list.order is order
  .then (problem) ->
    throw new global.myErrors.UnknownProblem() if not problem
    currentProblem = problem
    form = {
      lang : req.body.lang
      code_length : req.body.code.length
    }
    form_code = {
      content: req.body.code
    }
    global.myUtils.createSubmissionWithCode(form, form_code)
  .then (submission) ->
    currentSubmission = submission
    global.db.Promise.all [
      currentUser.addSubmission(submission)
    ,
      currentProblem.addSubmission(submission)
    ,
      currentContest.addSubmission(submission)
    ]
  .then ->
    req.flash 'info', 'submit code successfully'
    res.redirect SUBMISSION_PAGE

  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch global.myErrors.UnknownProblem, (err)->
    req.flash 'info', err.message
    res.redirect PROBLEM_PAGE
  .catch global.myErrors.UnknownContest, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch global.myErrors.InvalidAccess, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown error!'
    res.redirect HOME_PAGE

exports.getSubmissions = (req, res) ->
  User = global.db.models.user
  Problem = global.db.models.problem
  Contest = global.db.models.contest
  currentProblem = undefined
  currentProblems = undefined
  currentContest = undefined
  currentUser = undefined
  currentSubmissions = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    global.myUtils.findContest(user,req.params.contestID,[
      model : Problem
    ])
  .then (contest)->
    throw new global.myErrors.UnknownContest() if not contest
    throw new global.myErrors.UnknownContest() if contest.start_time > (new Date())
    currentContest = contest
    contest.problems.sort (a,b)->
      a.contest_problem_list.order-b.contest_problem_list.order
    currentProblems = contest.problems
    global.myUtils.getProblemsStatus(currentProblems,currentUser,currentContest)
  .then ->
    order = global.myUtils.lettersToNumber(req.params.problemID)
    for problem in currentProblems
      if problem.contest_problem_list.order is order
        return problem
  .then (problem)->
    throw new global.myErrors.UnknownProblem() if not problem
    currentProblem = problem
    global.db.Promise.all [
      fs.readFilePromised path.join(global.myUtils.getStaticProblem(currentProblem.id), 'manifest.json')
        .then (manifest_str) ->
          manifest = JSON.parse manifest_str
          currentProblem.test_setting = manifest.test_setting
    ,
      currentProblem.getSubmissions(
        include : [
          model : User
          as : 'creator'
          where :
            id : (
              if currentUser
                currentUser.id
              else
                null
            )
        ,
          model : Contest
          where :
            id : currentContest.id
        ]
        order : [
          ['created_at', 'DESC']
        ,
          ['id','DESC']
        ]
        offset : req.query.offset
        limit : global.config.pageLimit.submission
      )
        .then (submissions) ->
          currentSubmissions = submissions
    ]
  .then ->
    for problem in currentContest.problems
      problem.contest_problem_list.order = global.myUtils.numberToLetters(problem.contest_problem_list.order)
    res.render('problem/submission', {
      submissions: currentSubmissions
      problem : currentProblem
      contest : currentContest
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
  .catch global.myErrors.UnknownContest, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown error!'
    res.redirect HOME_PAGE


