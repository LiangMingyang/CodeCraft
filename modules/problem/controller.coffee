passwordHash = require('password-hash')
myUtils = require('./utils')

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
INDEX_PAGE = '.'

exports.getIndex = (req, res) ->
  Group = global.db.models.group
  User = global.db.models.user
  currentProblems = undefined
  currentUser = undefined
  problemCount = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    req.query.page ?= 1
    offset = (req.query.page-1) * global.config.pageLimit.problem
    myUtils.findAndCountProblems(user, offset, [
      model : Group
    ])
  .then (result)->
    problemCount = result.count
    currentProblems = result.rows
    myUtils.getProblemsStatus(currentProblems,currentUser)
  .then ->
    res.render('problem/index', {
      user: req.session.user
      problems : currentProblems
      problemCount : problemCount
      pageLimit : global.config.pageLimit.problem
    })

  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown error!'
    res.redirect HOME_PAGE
