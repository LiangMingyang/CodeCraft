passwordHash = require('password-hash')
myUtils = require('./utils')
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
CONTEST_PAGE = '../..'
INDEX_PAGE = 'index'

#Foreign url
LOGIN_PAGE = '/user/login'

#index

exports.getIndex = (req, res) ->
  Contest = global.db.models.contest
  User = global.db.models.user
  currentContest = undefined
  Contest.find req.params.contestID, {
    include:[
      model : User
      as : 'creator'
    ]
  }
  .then (contest)->
    throw new myUtils.Error.UnknownContest() if not contest
    currentContest = contest
    myUtils.authContest(req, contest)
  .then (auth)->
    throw new myUtils.Error.UnknownContest() if not auth
    res.render 'contest/detail', {
      user : req.session.user
      contest : currentContest
    }

  .catch myUtils.Error.UnknownContest, (err)->
    req.flash 'info', err.message
    res.redirect CONTEST_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getProblem = (req, res)->
  res.render 'contest/index', {
    title: 'Problem'
  }

exports.getSubmission = (req, res)->
  res.render 'contest/detail', {
    title: 'Submission'
  }

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

