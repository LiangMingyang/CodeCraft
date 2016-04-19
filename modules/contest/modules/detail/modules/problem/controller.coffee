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
  Problem = global.db.models.problem
  Group = global.db.models.group
  currentProblem = undefined
  currentContest = undefined
  currentProblems = undefined
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findContest(req.session.user,req.params.contestID,[
      model : Problem
    ,
      model : Group
      attributes : [
        'id'
      ,
        'name'
      ]
    ])
  .then (contest)->
    throw new global.myErrors.UnknownContest() if not contest
    throw new global.myErrors.UnknownContest() if contest.start_time > (new Date())
    currentContest = contest
    contest.problems.sort (a,b)->
      a.contest_problem_list.order-b.contest_problem_list.order
    currentProblems = contest.problems
    global.myUtils.getProblemsStatus(currentProblems,req.session.user,currentContest)
  .then ->
    order = global.myUtils.lettersToNumber(req.params.problemID)
    for problem in currentProblems
      if problem.contest_problem_list.order is order
        return problem
  .then (problem) ->
    throw new global.myErrors.UnknownProblem() if not problem
    currentProblem = problem
    #TODO: 在这里进行了转码
    problem.test_setting = JSON.parse problem.test_setting
    problem.description = markdown.toHTML(problem.description)
    currentProblems = [currentProblem]
    for p in currentContest.problems
      p.contest_problem_list.order = global.myUtils.numberToLetters(p.contest_problem_list.order)
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
    err.message = "未知错误"
    res.render 'error', error: err

exports.postSubmission = (req, res) ->

  User = global.db.models.user
  Problem = global.db.models.problem
  currentUser = undefined
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
    global.myUtils.createSubmissionTransaction(form, form_code, currentProblem, currentUser)
  .then (submission) ->
    currentContest.addSubmission(submission)
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
    err.message = "未知错误"
    res.render 'error', error: err

exports.getSubmissions = (req, res) ->
  User = global.db.models.user
  Problem = global.db.models.problem
  Group = global.db.models.group
  currentProblem = undefined
  currentProblems = undefined
  currentContest = undefined
  currentSubmissions = undefined
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findContest(req.session.user ,req.params.contestID, [
      model : Problem
      attributes : [
        'id'
      ,
        'title'
      ,
        'test_setting'
      ]
    ,
      model : Group
    ])
  .then (contest)->
    throw new global.myErrors.UnknownContest() if not contest
    throw new global.myErrors.UnknownContest() if contest.start_time > (new Date())
    currentContest = contest
    contest.problems.sort (a,b)->
      a.contest_problem_list.order-b.contest_problem_list.order
    currentProblems = contest.problems
    global.myUtils.getProblemsStatus(currentProblems, req.session.user, currentContest)
  .then ->
    order = global.myUtils.lettersToNumber(req.params.problemID)
    for problem in currentProblems
      if problem.contest_problem_list.order is order
        return problem
  .then (problem)->
    throw new global.myErrors.UnknownProblem() if not problem
    currentProblem = problem
    currentProblem.test_setting = JSON.parse currentProblem.test_setting
    opt = {
      offset: req.query.offset
      contest_id: currentContest.id
      problem_id: problem.id
    }
    global.myUtils.findSubmissions(req.session.user, opt, [
      model : User
      as : 'creator'
    ])
  .then (submissions) ->
    currentSubmissions = submissions
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
    err.message = "未知错误"
    res.render 'error', error: err

exports.postSubmissions = (req, res)->
  User = global.db.models.user
  Problem = global.db.models.problem
  Group = global.db.models.group
  currentProblem = undefined
  currentProblems = undefined
  currentContest = undefined
  currentUser = undefined
  currentSubmissions = undefined
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findContest(req.session.user,req.params.contestID,[
      model : Problem
      attributes : [
        'id'
      ,
        'title'
      ,
        'test_setting'
      ]
    ,
      model : Group
      attributes : [
        'id'
      ,
        'name'
      ]
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
    currentProblem.test_setting = JSON.parse currentProblem.test_setting
    opt ={}
    opt.offset = req.query.offset
    opt.nickname = req.body.nickname if req.body.nickname isnt ''
    opt.problem_id = currentProblem.id
    opt.contest_id = currentContest.id
    opt.language = req.body.language if req.body.language isnt ''
    opt.result = req.body.result if req.body.result isnt ''
    global.myUtils.findSubmissions(req.session.user, opt, [
      model : User
      as : 'creator'
    ])
  .then (submissions) ->
    currentSubmissions = submissions
    for problem in currentContest.problems
      problem.contest_problem_list.order = global.myUtils.numberToLetters(problem.contest_problem_list.order)
    res.render('problem/submission', {
      submissions: currentSubmissions
      problem : currentProblem
      contest : currentContest
      user: req.session.user
      offset : req.query.offset
      pageLimit : global.config.pageLimit.submission
      query: req.body
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
    err.message = "未知错误"
    res.render 'error', error: err

