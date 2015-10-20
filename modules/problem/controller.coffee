passwordHash = require('password-hash')
#global.myUtils = require('./utils')

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
INDEX_PAGE = '.'

exports.getIndex = (req, res) ->
  Group = global.db.models.group
  currentProblems = undefined
  problemCount = undefined
  global.db.Promise.resolve()
  .then ->
    req.query.page ?= 1
    offset = (req.query.page-1) * global.config.pageLimit.problem
    global.myUtils.findAndCountProblems(req.session.user, offset, [
      model : Group
      attributes: [
        'id'
      ,
        'name'
      ]
    ])
  .then (result)->
    problemCount = result.count
    currentProblems = result.rows
    global.myUtils.getProblemsStatus(currentProblems, req.session.user)
  .then ->
    res.render('problem/index', {
      user: req.session.user
      problems : currentProblems
      problemCount : problemCount
      page : req.query.page
      pageLimit : global.config.pageLimit.problem
    })

  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown error!'
    res.redirect HOME_PAGE
