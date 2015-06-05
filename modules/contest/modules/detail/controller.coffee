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
    currentContest = contest
    return [] if contest.start_time > (new Date())
    currentContest.getProblems()
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
    return [] if contest.start_time > (new Date())
    currentContest = contest
    currentContest.getSubmissions()
  .then (submissions)->
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
  res.render 'contest/detail', {
    title: 'Rank'
  }

