passwordHash = require('password-hash')
myUtils = require('./utils')
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
CONTEST_PAGE = '..'
INDEX_PAGE = 'index'

#Foreign url
LOGIN_PAGE = '/user/login'

#index

exports.getIndex = (req, res)->
  User = global.db.models.user
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    myUtils.findContest(user, req.params.contestID, [
      model : User
      as : 'creator'
    ])
  .then (contest)->
    throw new myUtils.Error.UnknownContest() if not contest
    res.render 'contest/detail', {
      user : req.session.user
      contest : contest
    }

  .catch myUtils.Error.UnknownContest, myUtils.Error.InvalidAccess, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getProblem = (req, res)->
  currentContest = undefined
  currentUser = undefined
  currentProblems = undefined
  User = global.db.models.user
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    myUtils.findContest(user, req.params.contestID, [
      model : User
      as : 'creator'
    ,
      model : Problem
    ])
  .then (contest)->
    throw new myUtils.Error.UnknownContest() if not contest
    throw new myUtils.Error.UnknownContest() if contest.start_time > (new Date())
    contest.problems.sort (a,b)->
      a.contest_problem_list.order-b.contest_problem_list.order
    currentContest = contest
    currentProblems = contest.problems
    myUtils.getResultPeopleCount(currentProblems, 'AC',currentContest)
  .then (counts)-> #AC people counts
    tmp = {}
    for p in counts
      tmp[p.problem_id] = p.count
    for p in currentProblems
      p.acceptedPeopleCount = 0
      p.acceptedPeopleCount = tmp[p.id] if tmp[p.id]
    myUtils.getResultPeopleCount(currentProblems,undefined,currentContest)
  .then (counts)-> #Tried people counts
    tmp = {}
    for p in counts
      tmp[p.problem_id] = p.count
    for p in currentProblems
      p.triedPeopleCount = 0
      p.triedPeopleCount = tmp[p.id] if tmp[p.id]
    myUtils.hasResult(currentUser,currentProblems,'AC',currentContest)
  .then (counts)-> #this user accepted problems
    tmp = {}
    for p in counts
      tmp[p.problem_id] = p.count
    for p in currentProblems
      p.accepted = 0
      p.accepted = tmp[p.id] if tmp[p.id]
    myUtils.hasResult(currentUser,currentProblems,undefined,currentContest)
  .then (counts)-> #this user tried problems
    tmp = {}
    for p in counts
      tmp[p.problem_id] = p.count
    for p in currentProblems
      p.tried = 0
      p.tried = tmp[p.id] if tmp[p.id]
    return currentProblems
  .then (problems)->
    for problem in problems
      problem.contest_problem_list.order = myUtils.numberToLetters(problem.contest_problem_list.order)
    res.render 'contest/problem', {
      user : req.session.user
      contest : currentContest
      problems : problems
    }

  .catch myUtils.Error.UnknownContest, myUtils.Error.InvalidAccess, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getSubmission = (req, res)->
  currentContest = undefined
  currentUser = undefined
  User = global.db.models.user
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    myUtils.findContest(user, req.params.contestID, [
      model : User
      as : 'creator'
    ])
  .then (contest)->
    throw new myUtils.Error.UnknownContest() if not contest
    throw new myUtils.Error.UnknownContest() if contest.start_time > (new Date())
    currentContest = contest
    currentContest.getSubmissions(
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
      ]
      order : [
        ['created_at','DESC']
      ]
    )
  .then (submissions)->
    dicProblemIDtoOrder = {}
    for problem in currentContest.problems
      dicProblemIDtoOrder[problem.id] = problem.contest_problem_list.order
    for submission in submissions
      submission.problem_order = dicProblemIDtoOrder[submission.problem_id]
    res.render 'contest/submission', {
      user : req.session.user
      contest : currentContest
      submissions : submissions
    }


  .catch myUtils.Error.UnknownContest, myUtils.Error.InvalidAccess, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getClarification = (req, res)->
  res.render 'contest/detail', {
    title: 'Clarification'
  }

exports.getQuestion = (req, res)->
  res.render 'contest/detail', {
    title: 'Question'
  }

exports.getRank = (req, res)->
  User = global.db.models.user
  Problem = global.db.models.problem
  currentContest = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    myUtils.findContest(user, req.params.contestID, [
      model : User
      as : 'creator'
    ,
      model : Problem
    ])
  .then (contest)->
    throw new myUtils.Error.UnknownContest() if not contest
    throw new myUtils.Error.UnknownContest() if contest.start_time > (new Date())
    currentContest = contest
    contest.problems.sort (a,b)->
      a.contest_problem_list.order-b.contest_problem_list.order
    myUtils.getRank(currentContest)
  .then (rank)->
    for problem in currentContest.problems
      problem.contest_problem_list.order = myUtils.numberToLetters(problem.contest_problem_list.order)
    res.render 'contest/rank', {
      user : req.session.user
      contest : currentContest
      rank : rank
    }

  .catch myUtils.Error.UnknownContest, myUtils.Error.InvalidAccess, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE
