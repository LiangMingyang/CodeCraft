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
  Contest = global.db.models.contest
  User = global.db.models.user
  Problem = global.db.models.problem
  currentContest = undefined
  myUtils.findContest(req, req.params.contestID)
  .then (contest)->
    throw new myUtils.Error.UnknownContest() if not contest
    currentContest = contest
    currentContest.getProblems()
  .then (problems)->
    res.render 'contest/detail', {
      user : req.session.user
      contest : currentContest
      problems : problems
    }

  .catch myUtils.Error.UnknownContest, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getSubmission = (req, res)->
  Group = global.db.models.group
  Contest = global.db.models.contest
  User = global.db.models.user
  currentContest = undefined
  myUtils.findContest(req, req.params.contestID)
  .then (contest)->
    throw new myUtils.Error.UnknownContest() if not contest
    currentContest = contest
    currentContest.getSubmissions()
  .then (submissions)->
    res.render 'contest/submission', {
      user : req.session.user
      contest : currentContest
      submissions : submissions
    }


  .catch myUtils.Error.UnknownContest, (err)->
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

