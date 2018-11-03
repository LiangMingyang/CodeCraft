passwordHash = require('password-hash')
#global.myUtils = require('./utils')
Promise = require('sequelize').Promise
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
  count_title = undefined
  count_tag = undefined
  global.redis.set("title_recommendation_count", 0, "NX")
  global.redis.set("tag_recommendation_count", 0, "NX")
  if req.session.user.id % 2 is 0
    global.redis.incr("title_recommendation_count")
  else
    global.redis.incr("tag_recommendation_count")
  global.redis.get("title_recommendation_count")
    .then (result)->
      #console.log "普通协同过滤推荐点击次数："
      #console.log result
      count_title = result
  global.redis.get("tag_recommendation_count")
    .then (result)->
      #console.log "改进的图推荐算法点击次数："
      #console.log result
      count_tag = result
    .then ()->
      if req.session.user.id is 1
        res.redirect(req.query.problem_id + '/index?' + 'count_title=' + count_title + '&count_tag=' + count_tag)
      else
        res.redirect(req.query.problem_id + '/index')

#腾讯广告点击统计
exports.getTencentStatistics = (req, res) ->
  count_advertise = undefined
  advertisementStatistics = global.db.models.click_statistics
  url = "https://cloud.tencent.com/act/campus?utm_source=beihang&utm_medium=txt&utm_campaign=campus"
  advertisementStatistics.find(
    where:
      clickUrl: url
  )
  .then (clicks) ->
    if clicks
      count_advertise = clicks.clickCount
    else count_advertise = 0
    count_advertise = count_advertise + 1
    advertisementStatistics.find(
        where:
          clickUrl: url
    )
  .then (clicks) ->
      if clicks
        clicks.clickCount = count_advertise
        clicks.save()
      else
        advertisementStatistics.create(
          clickType: "Guanggao"
          clickContent: "tengxun"
          clickUrl: "https://cloud.tencent.com/act/campus?utm_source=beihang&utm_medium=txt&utm_campaign=campus"
          clickCount: count_advertise
        )
  .then ()->
      res.redirect("https://cloud.tencent.com/act/campus?utm_source=beihang&utm_medium=txt&utm_campaign=campus")

#犀牛鸟广告点击统计
exports.getXiniuStatistics = (req, res) ->
  count_advertise = undefined
  advertisementStatistics = global.db.models.click_statistics
  url = "http://ur.tencent.com/register/8"
  advertisementStatistics.find(
    where:
      clickUrl: url
  )
  .then (clicks) ->
    if clicks
      count_advertise = clicks.clickCount
    else count_advertise = 0
    count_advertise = count_advertise + 1
    advertisementStatistics.find(
      where:
        clickUrl: url
    )
  .then (clicks) ->
    if clicks
      clicks.clickCount = count_advertise
      clicks.save()
    else
      advertisementStatistics.create(
        clickType: "Guanggao"
        clickContent: "xiniuniao"
        clickUrl: url
        clickCount: count_advertise
      )
  .then ()->
    res.redirect(url)

#DEV点击统计
exports.getDEVStatistics = (req, res) ->
  count_material = undefined
  materialStatistics = global.db.models.click_statistics
  url = "http://image.buaacoding.cn/DEV%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.pdf"
  materialStatistics.find(
    where:
      clickUrl: url
  )
  .then (clicks) ->
    if clicks
      count_material = clicks.clickCount
    else count_material = 0
    count_material = count_material + 1
    materialStatistics.find(
      where:
        clickUrl: url
    )
  .then (clicks) ->
    if clicks
      clicks.clickCount = count_material
      clicks.save()
    else
      materialStatistics.create(
        clickType: "material"
        clickContent: "DEV"
        clickUrl: url
        clickCount: count_material
      )
  .then ()->
    res.redirect(url)

#CB点击统计
exports.getCBStatistics = (req, res) ->
  count_material = undefined
  materialStatistics = global.db.models.click_statistics
  url = "http://image.buaacoding.cn/CB%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.pdf"
  materialStatistics.find(
    where:
      clickUrl: url
  )
  .then (clicks) ->
    if clicks
      count_material = clicks.clickCount
    else count_material = 0
    count_material = count_material + 1
    materialStatistics.find(
      where:
        clickUrl: url
    )
  .then (clicks) ->
    if clicks
      clicks.clickCount = count_material
      clicks.save()
    else
      materialStatistics.create(
        clickType: "material"
        clickContent: "CB"
        clickUrl: url
        clickCount: count_material
      )
  .then ()->
    res.redirect(url)

#题解点击统计
#exports.getSolutionStatistics = (req, res) ->
#  count_solution = undefined
#  solutionStatistics = global.db.models.click_statistics
#  console.log("1111111")
#  console.log(addclickSolution)
#  url = "/submission/#{__solution}/solution"
#  global.redis.set("solution_count", 0, "NX")
#  global.redis.incr("solution_count")
#  global.redis.get("solution_count")
#  .then (result)->
#    count_solution = result
#    solutionStatistics.find(
#      where:
#        clickUrl: url
#    )
#  .then (clicks) ->
#    if clicks
#      clicks.clickCount = count_solution
#      clicks.clickContent = "appear" + addclickSolution
#      clicks.save()
#    else
#      solutionStatistics.create(
#        clickType: "solution"
#        clickContent: "appear"
#        clickUrl: "/submission/#{__solution}/solution"
#        clickCount: 0
#      )
#  .then ()->
#    console.log("2222222")
#    res.redirect("/submission/#{__solution}/solution")


