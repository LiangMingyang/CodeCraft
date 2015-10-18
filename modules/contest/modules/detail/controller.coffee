passwordHash = require('password-hash')
#global.myUtils = require('./utils')
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
CONTEST_PAGE = '..'
INDEX_PAGE = 'index'
QUESTION_PAGE = 'question'

#Foreign url
LOGIN_PAGE = '/user/login'

#index

exports.getIndex = (req, res)->
  Group = global.db.models.group
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findContest(req.session.user, req.params.contestID, [
      model : Group
      attributes: [
        'id'
      ,
        'name'
      ]
    ])
  .then (contest)->
    throw new global.myErrors.UnknownContest() if not contest
    res.render 'contest/detail', {
      user : req.session.user
      contest : contest
    }

  .catch global.myErrors.UnknownContest, global.myErrors.InvalidAccess, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getProblem = (req, res)->
  currentContest = undefined
  currentProblems = undefined
  Problem = global.db.models.problem
  Group = global.db.models.group
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findContest(req.session.user, req.params.contestID, [
      model : Problem
      attributes: [
        'id'
      ,
        'title'
      ]
    ,
      model : Group
      attributes: [
        'id'
      ,
        'name'
      ]
    ])
  .then (contest)->
    throw new global.myErrors.UnknownContest() if not contest
    throw new global.myErrors.UnknownContest() if contest.start_time > (new Date())
    contest.problems.sort (a,b)->
      a.contest_problem_list.order-b.contest_problem_list.order
    currentContest = contest
    currentProblems = contest.problems
    global.myUtils.getProblemsStatus(currentProblems,req.session.user,currentContest)
  .then ->
    for problem in currentProblems
      problem.contest_problem_list.order = global.myUtils.numberToLetters(problem.contest_problem_list.order)
    res.render 'contest/problem', {
      user : req.session.user
      contest : currentContest
      problems : currentProblems
    }

  .catch global.myErrors.UnknownContest, global.myErrors.InvalidAccess, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getSubmission = (req, res)->
  currentContest = undefined
  Problem = global.db.models.problem
  User = global.db.models.user
  Group = global.db.models.group
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findContest(req.session.user, req.params.contestID, [
      model : User
      as : 'creator'
    ,
      model : Problem
      attributes : [
        'id'
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
    opt = {
      offset: req.query.offset
      contest_id: currentContest.id
    }
    global.myUtils.findSubmissions(req.session.user, opt, [
      model : User
      as : 'creator'
    ])
  .then (submissions)->
    dicProblemIDtoOrder = {}
    for problem in currentContest.problems
      dicProblemIDtoOrder[problem.id] = global.myUtils.numberToLetters(problem.contest_problem_list.order)
    for submission in submissions
      submission.problem_order = dicProblemIDtoOrder[submission.problem_id]
    res.render 'contest/submission', {
      user : req.session.user
      contest : currentContest
      submissions : submissions
      offset : req.query.offset
      pageLimit : global.config.pageLimit.submission
    }


  .catch global.myErrors.UnknownContest, global.myErrors.InvalidAccess, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.postSubmissions = (req, res)->
  currentContest = undefined
  currentUser = undefined
  Problem = global.db.models.problem
  User = global.db.models.user
  Group = global.db.models.group
  dicProblemIDtoOrder = {}
  dicOrdertoProblemID = {}
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    global.myUtils.findContest(user, req.params.contestID, [
      model : User
      as : 'creator'
    ,
      model : Problem
    ,
      model : Group
    ])
  .then (contest)->
    throw new global.myErrors.UnknownContest() if not contest
    throw new global.myErrors.UnknownContest() if contest.start_time > (new Date())
    currentContest = contest
    for problem in currentContest.problems
      dicProblemIDtoOrder[problem.id] = global.myUtils.numberToLetters(problem.contest_problem_list.order)
      dicOrdertoProblemID[dicProblemIDtoOrder[problem.id]] = problem.id
    opt ={}
    opt.offset = req.query.offset
    opt.nickname = req.body.nickname if req.body.nickname isnt ''
    opt.problem_id = dicOrdertoProblemID[req.body.problem_order] if req.body.problem_order isnt ''
    opt.contest_id = currentContest.id
    opt.language = req.body.language if req.body.language isnt ''
    opt.result = req.body.result if req.body.result isnt ''
    global.myUtils.findSubmissions(currentUser, opt, [
      model : User
      as : 'creator'
    ])
  .then (submissions)->
    for submission in submissions
      submission.problem_order = dicProblemIDtoOrder[submission.problem_id]
    res.render 'contest/submission', {
      user : req.session.user
      contest : currentContest
      submissions : submissions
      offset : req.query.offset
      pageLimit : global.config.pageLimit.submission
      query: req.body
    }

exports.getClarification = (req, res)->
  res.render 'contest/detail', {
    title: 'Clarification'
  }

exports.getQuestion = (req, res)->
  currentContest = undefined
  currentUser = undefined
  Problem = global.db.models.problem
  User = global.db.models.user
  Issue = global.db.models.issue
  Group = global.db.models.group
  dic = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    global.myUtils.findContest(user, req.params.contestID, [
      model : User
      as : 'creator'
    ,
      model : Problem
    ,
      model : Issue
      include : [
        model : User
        as : 'creator'
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
    dic = {}
    for problem in currentContest.problems
      problem.contest_problem_list.order = global.myUtils.numberToLetters(problem.contest_problem_list.order)
      dic[problem.id] = problem.contest_problem_list.order
    for issue in currentContest.issues
      issue.problem_id = dic[issue.problem_id]
    res.render 'contest/question', {
      user : req.session.user
      contest : currentContest
      issues : currentContest.issues
    }

  .catch global.myErrors.UnknownContest, global.myErrors.InvalidAccess, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.postQuestion = (req, res)->
  currentContest = undefined
  currentUser = undefined
  currentProblem = undefined
  Problem = global.db.models.problem
  User = global.db.models.user
  Issue = global.db.models.issue
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    throw new global.myErrors.UnknownUser() if not user
    currentUser = user
    global.myUtils.findContest(user, req.params.contestID, [
      model : User
      as : 'creator'
    ,
      model : Problem
    ])
  .then (contest)->
    throw new global.myErrors.UnknownContest() if not contest
    throw new global.myErrors.UnknownContest() if contest.start_time > (new Date())
    currentContest = contest
    order = global.myUtils.lettersToNumber(req.body.order)
    for problem in currentContest.problems
      return problem if problem.contest_problem_list.order is order
  .then (problem)->
    throw new global.myErrors.UnknownProblem() if not problem
    currentProblem = problem
    Issue.create (
      content : req.body.content
      access_level : 'private'
    )
  .then (issue)->
    global.db.Promise.all [
      issue.setProblem(currentProblem)
    ,
      issue.setContest(currentContest)
    ,
      issue.setCreator(currentUser)
    ]
  .then ->
    console.log "what"
    req.flash 'info', 'Questioned'
    res.redirect QUESTION_PAGE

  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch global.myErrors.UnknownContest, global.myErrors.InvalidAccess, global.myErrors.UnknownProblem, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getRank = (req, res)->
  User = global.db.models.user
  Problem = global.db.models.problem
  Group = global.db.models.group
  currentContest = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    global.myUtils.findContest(user, req.params.contestID, [
      model : User
      as : 'creator'
    ,
      model : Problem
    ,
      model : Group
    ])
  .then (contest)->
    throw new global.myErrors.UnknownContest() if not contest
    throw new global.myErrors.UnknownContest() if contest.start_time > (new Date())
    currentContest = contest
    contest.problems.sort (a,b)->
      a.contest_problem_list.order-b.contest_problem_list.order
    global.myUtils.getRank(currentContest)
  .then (rank)->
    for problem in currentContest.problems
      problem.contest_problem_list.order = global.myUtils.numberToLetters(problem.contest_problem_list.order)
    res.render 'contest/rank', {
      user : req.session.user
      contest : currentContest
      rank : rank
    }

  .catch global.myErrors.UnknownContest, global.myErrors.InvalidAccess, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE
