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
  currentContest = undefined
  myUtils.findContest(req, req.params.contestID)
  .then (contest)->
    throw new myUtils.Error.UnknownContest() if not contest
    currentContest = contest
    return [] if contest.start_time > (new Date())
    currentContest.getProblems()
  .then (problems)->
    res.render 'contest/detail', {
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
  myUtils.findContest(req, req.params.contestID)
  .then (contest)->
    throw new myUtils.Error.UnknownContest() if not contest
    throw new myUtils.Error.InvalidAccess('This contest has not began.') if contest.start_time > (new Date())
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

