passwordHash = require('password-hash')
#global.myUtils = require('./utils')

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
INDEX_PAGE = '.'

exports.getIndex = (req, res) ->
  Group = global.db.models.group
  User = global.db.models.user
  Contest = global.db.models.contest
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
    ,
      model : Contest
      attributes: [
        'id'
      ,
        'title'
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
    console.error err
    err.message = "未知错误"
    res.render 'error', error: err

exports.postIndex = (req, res) ->
  Group = global.db.models.group
  User = global.db.models.user
  Contest = global.db.models.contest
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
    ,
      model : Contest
      attributes: [
        'id'
      ,
        'title'
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
      query: req.body
    })

  .catch (err)->
    console.error err
    err.message = "未知错误"
    res.render 'error', error: err

exports.getAccepted = (req, res)->
  Group = global.db.models.group
  User = global.db.models.user
  Contest = global.db.models.contest
  Submission = global.db.models.submission
  Solution = global.db.models.solution
  currentProblems = undefined
  problemCount = undefined
  global.db.Promise.resolve()
    .then ->
      req.query.page ?= 1
      opt = {}
      opt.offset = (req.query.page-1) * global.config.pageLimit.problem
      opt.distinct = true
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
      ,
        model : Contest
        attributes: [
          'id'
        ,
          'title'
        ]
      ,
        model : Submission
        where :
          creator_id : req.session?.user?.id
          result : 'AC'
        #limit : 1
        include: [
          model : Solution
        ]
      ])
    .then (result)->
      problemCount = result.count
      currentProblems = result.rows
      global.myUtils.getProblemsStatus(currentProblems, req.session.user)
    .then ->
      for problem,i in currentProblems
        for submission,j in problem.submissions
          if submission.solution
            problem.solution = submission.solution
            break
      res.render('problem/accepted', {
        user: req.session.user
        problems : currentProblems
        problemCount : problemCount
        page : req.query.page
        pageLimit : global.config.pageLimit.problem
      })

    .catch (err)->
      console.error err
      err.message = "未知错误"
      res.render 'error', error: err

exports.postAccepted = (req, res) ->
  Group = global.db.models.group
  User = global.db.models.user
  Contest = global.db.models.contest
  Solution = global.db.models.solution
  currentProblems = undefined
  problemCount = undefined
  Submission = global.db.models.submission
  global.db.Promise.resolve()
    .then ->
      req.query.page ?= 1
      offset = (req.query.page-1) * global.config.pageLimit.problem
      opt = req.body
      opt.offset = offset
      for key of opt
        if opt[key] is ''
          delete opt[key]
      opt.distinct = true
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
      ,
        model : Contest
        attributes: [
          'id'
        ,
          'title'
        ]
      ,
        model : Submission
        where :
          creator_id : req.session?.user?.id
          result : 'AC'
          #limit : 1
        include: [
          model : Solution
        ]
      ])
    .then (result)->
      problemCount = result.count
      currentProblems = result.rows
      global.myUtils.getProblemsStatus(currentProblems, req.session.user)
    .then ->
      for problem,i in currentProblems
        for submission,j in problem.submissions
          if submission.solution
            problem.solution = submission.solution
            break
      res.render('problem/accepted', {
        user: req.session.user
        problems : currentProblems
        problemCount : problemCount
        page : req.query.page
        pageLimit : global.config.pageLimit.problem
        query: req.body
      })

    .catch (err)->
      console.error err
      err.message = "未知错误"
      res.render 'error', error: err

#点击统计
exports.getStatistics = (req, res) ->
  count_common = undefined
  count_graph = undefined
  global.redis.set("common_recommendation_count", 0, "NX")
  global.redis.set("graph_recommendation_count", 0, "NX")
  if req.session.user.id % 2 is 0
    global.redis.incr("common_recommendation_count")
  else
    global.redis.incr("graph_recommendation_count")
  global.redis.get("common_recommendation_count")
    .then (result)->
      #console.log "普通协同过滤推荐点击次数："
      #console.log result
      count_common = result
  global.redis.get("graph_recommendation_count")
    .then (result)->
      #console.log "改进的图推荐算法点击次数："
      #console.log result
      count_graph = result
    .then ()->
      if req.session.user.id is 1
        res.redirect(req.query.problem_id + '/index?' + 'count_common=' + count_common + '&count_graph=' + count_graph)
      else
        res.redirect(req.query.problem_id + '/index')