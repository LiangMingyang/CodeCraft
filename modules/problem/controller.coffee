passwordHash = require('password-hash')
#global.myUtils = require('./utils')

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
INDEX_PAGE = '.'

exports.getIndex = (req, res) ->
  Group = global.db.models.group
  User = global.db.models.user
  currentProblems = undefined
  problemCount = undefined
  global.db.Promise.resolve()
  .then ->
    req.query.page ?= 1
    offset = (req.query.page-1) * global.config.pageLimit.problem
    global.myUtils.findAndCountProblems(req.session.user, offset:offset, [
      model : Group
      attributes: [
        'id'
      ,
        'name'
      ]
    ,
      model : User
      attributes: [
        'id'
      ,
        'nickname'
      ]
      as : 'creator'
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
    err.message = "未知错误"
    res.render 'error', error: err

exports.postIndex = (req, res) ->
  Group = global.db.models.group
  User = global.db.models.user
  currentProblems = undefined
  problemCount = undefined
  global.db.Promise.resolve()
  .then ->
    req.query.page ?= 1
    offset = (req.query.page-1) * global.config.pageLimit.problem
    opt = req.body
    opt.offset = offset
    for key of opt
      if opt[key] is ''
        delete opt[key]

    global.myUtils.findAndCountProblems(req.session.user, opt, [
      model : Group
      attributes: [
        'id'
      ,
        'name'
      ]
    ,
      model : User
      attributes: [
        'id'
      ,
        'nickname'
      ]
      as : 'creator'
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
      query: req.body
    })

  .catch (err)->
    console.log err
    err.message = "未知错误"
    res.render 'error', error: err
