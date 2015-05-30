passwordHash = require('password-hash')
myUtils = require('./utils')
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
CREATE_PAGE = 'create'
INDEX_PAGE = 'index'

#Foreign url
LOGIN_PAGE = '/user/login'

#index

exports.getIndex = (req, res) ->
  Contest = global.db.models.contest
  Contest.find req.params.contest_id
  .then (contest)->
    throw new myUtils.Error.UnknownContest() if not contest
    res.render 'contest/detail', {
      user : req.session.user
      contest : contest
    }
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

