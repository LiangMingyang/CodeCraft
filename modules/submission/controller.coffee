#global.myUtils = require('./utils')

INDEX_PAGE = 'index'

LOGIN_PAGE = 'user/login'
HOME_PAGE = '/'

exports.getIndex = (req, res) ->
  User = global.db.models.user
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    opt = {
      contest_id : null
      offset : req.query.offset
    }
    global.myUtils.findSubmissions(user, opt, [
      model : User
      as : 'creator'
    ])
  .then (submissions)->
    res.render 'submission/index', {
      user : req.session.user
      submissions : submissions
      offset : req.query.offset
      pageLimit : global.config.pageLimit.submission
    }
  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch (err)->
    console.error err
    err.message = "未知错误"
    res.render 'error', error: err

exports.postIndex = (req, res) ->
  User = global.db.models.user
  opt = {}
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    opt.offset = req.query.offset
    opt.nickname = req.body.nickname if req.body.nickname isnt ''
    opt.problem_id = req.body.problem_id if req.body.problem_id isnt ''
    #opt.contest_id = req.body.contest_id if req.body.contest_id isnt ''
    opt.contest_id = null #在表站只能看到非比赛中的提交记录
    opt.language = req.body.language if req.body.language isnt ''
    opt.result = req.body.result if req.body.result isnt ''
    global.myUtils.findSubmissions(user, opt, [
      model : User
      as : 'creator'
    ])
  .then (submissions)->
    res.render 'submission/index', {
      user : req.session.user
      submissions : submissions
      offset : opt.offset
      pageLimit : global.config.pageLimit.submission
      query : req.body
    }
  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch (err)->
    console.error err
    err.message = "未知错误"
    res.render 'error', error: err

exports.getSubmission = (req, res)->
  User = global.db.models.user
  SubmissionCode = global.db.models.submission_code
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    global.myUtils.findSubmission(user, req.params.submissionID, [
      model : SubmissionCode
    ])
  .then (submission)->
    throw new global.myErrors.UnknownSubmission() if not submission
    res.render 'submission/code', {
      user : req.session.user
      submission : submission
    }
  .catch global.myErrors.UnknownSubmission, (err)->
    req.flash 'info', err.message
    res.redirect INDEX_PAGE
  .catch global.myErrors.UnknownUser, (err)->
    console.error err
    req.flash 'info', "Please Login First!"
    res.redirect LOGIN_PAGE
  .catch (err)->
    console.error err
    err.message = "未知错误"
    res.render 'error', error: err

exports.postSubmissionApi = (req, res) ->
  User = global.db.models.user
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findSubmissionsInIDs(req.session.user, JSON.parse(req.body.submission_id), [
      model : User
      as : 'creator'
      attributes : [
        'id'
      ,
        'nickname'
      ]
    ])
  .then (submissions)->
    res.json(submissions)
  .catch (err)->
    console.error err
    err.message = "未知错误"
    res.render 'error', error: err

checkSolutionAccess = (submission, currentUser)->
  throw new global.myErrors.UnknownSubmission() if not submission   #非法提交ID
  return if submission.creator.id is currentUser?.id
  throw new global.myErrors.UnknownSubmission() if not submission.solution #没有解题报告还不是本人，这什么鬼
  throw new global.myErrors.UnknownSubmission() if submission.solution.access_level is 'private'
  throw new global.myErrors.UnknownSubmission() if submission.solution.access_level is 'protect' and (new Date())< submission.solution.secret_limit

exports.getSolution = (req, res)->
  DB = global.db
  Utils = global.myUtils
  User = DB.models.user
  Submission = DB.models.submission
  Solution = DB.models.solution
  SubmissionCode = DB.models.submission_code
  Problem = DB.models.problem
  Tag = DB.models.tag
  Contest = DB.models.Contest
  Evaluation = DB.models.evaluation
  currentEvaluation = undefined
  currentSubmission = undefined
  currentUser = undefined
  global.db.Promise.resolve()
    .then ->
      User.find req.session.user.id if req.session.user
    .then (user)->
      currentUser = user
      Submission.find(
        where:
          id : req.params.submissionID
        include: [
          model : SubmissionCode
        ,
          model : User
          as : 'creator'
        ,
          model : Problem
        ,
          model : Solution
        ]
      )
    .then (submission)->
      checkSolutionAccess(submission, currentUser)
      currentSubmission = submission
      if currentSubmission.solution
        currentSubmission.solution.getEvaluations(
          where:
            creator_id: currentUser.id
        )
      else
        return []
    .then (evaluation)->
      currentEvaluation = evaluation
      Tag.findAll()
    .then (tags) ->
      #console.log(JSON.stringify(tags))
      res.render('submission/solution', {
        submission: currentSubmission
        user : currentUser
        editable : currentSubmission.creator.id is currentUser?.id
        evaluation : currentEvaluation[0]
        tags : tags
      })
    .catch global.myErrors.UnknownSubmission,(err)->
#      req.flash 'info', err.message
#      res.redirect LOGIN_PAGE
      res.render 'error', error: err
    .catch (err)->
      console.error err
      err.message = "未知错误"
      res.render 'error', error: err

exports.postSolution = (req, res) ->
  DB = global.db
  Utils = global.myUtils
  User = DB.models.user
  Solution = DB.models.solution
  Tag = DB.models.tag
  currentTag = undefined
  currentUser = undefined
  currentSubmission  = undefined
  currentFlag = true
  form = {}
  global.db.Promise.resolve()
    .then ->
      User.find req.session.user.id if req.session.user
    .then (user)->
      currentUser = user
      Utils.findSubmission(user, req.params.submissionID, [
        model : Solution
      ])
    .then (submission)->
      throw new global.myErrors.UnknownSubmission() if not submission
      currentSubmission = submission
      form = {
        source : req.body["editor-markdown-doc"]
        content : req.body["editor-html-code"]
        title : req.body["title"] || "Solution-#{currentUser.nickname}-#{currentUser.student_id}-#{currentSubmission.id}"
        access_level : req.body["access_level"] ||"protect"
        secret_limit :
                        if req.body["secret_limit"] is ''
                          new Date((new Date().getTime()+7*24*60*60*1000))
                        else
                          new Date(req.body["secret_limit"])
        category: req.body["category"]
        user_tag: req.body["user_tag"]
        practice_time: req.body["practice_time"]
        score: req.body["score"]
        influence: req.body["influence"]
        tag_1: req.body["user_tag_1"]
        tag_2: req.body["user_tag_2"]
        tag_3: req.body["user_tag_3"]

      }
      currentSubmission = submission
      if submission.solution
        submission.solution.source = form.source
        submission.solution.content = form.content
        submission.solution.title = form.title
        submission.solution.access_level = form.access_level
        submission.solution.secret_limit = form.secret_limit
        submission.solution.user_tag = form.user_tag
        submission.solution.practice_time = form.practice_time
        submission.solution.score = form.score
        submission.solution.category = form.category
        submission.solution.influence = form.influence
        submission.solution.tag_1 = form.tag_1
        submission.solution.tag_2 = form.tag_2
        submission.solution.tag_3 = form.tag_3
        submission.solution.save()
      else
        Solution.create form
          .then (solution)->
            currentSubmission.setSolution(solution)
        #solution.setSubmission(currentSubmission)
      #其实需要判断是否已存在该自定义标签
      Tag.findAll()
    .then (tags) ->
      currentTag = tags
      for Tag in tags
        if req.body.user_tag && Tag.content ==req.body.user_tag
          currentFlag = false
      if req.body.user_tag && currentFlag
        global.myUtils.createTag(req.body.user_tag)
    .then (solution)->
      req.flash 'info', "保存成功"
      res.redirect("../#{currentSubmission.id}/solution")
    .catch (err)->
      console.error err
      err.message = "未知错误"
      res.render 'error', error: err


exports.getPraise = (req, res)->
  DB = global.db
  Utils = global.myUtils
  User = DB.models.user
  Solution = DB.models.solution
  Submission = DB.models.submission
  Evaluation = DB.models.evaluation
  currentUser = undefined
  currentSubmission  = undefined
  currentEvaluation = undefined
  DB.Promise.resolve()
    .then ->
      User.find req.session.user.id if req.session.user
    .then (user)->
      currentUser = user
      Submission.find(
        where:
          id : req.params.submissionID
        include: [
          model : Solution
        ,
          model : User
          as : 'creator'
        ]
      )
    .then (submission)->
      checkSolutionAccess(submission, currentUser)
      currentSubmission = submission
      throw new global.myErrors.UnknownSolution() if not submission.solution
      Evaluation.find(
        include: [
          model: User
          as : 'creator'
          where:
            id : currentUser.id
        ,
          model: Solution
          where:
            id : currentSubmission.solution.id
        ]
      )
    .then (evaluation)->
      currentEvaluation = evaluation
      score = req.query.score
      score = 1 if score>0
      score = -1 if score<0
      if evaluation
        evaluation.score = score
        evaluation.save()
      else
        Evaluation.create(
          score: score
          creator_id: currentUser.id
          solution_id: currentSubmission.solution.id
        )
    .then (evaluation)->
      res.json(evaluation.get(plain:true))
    .catch global.myErrors.UnknownSubmission, global.myErrors.UnknownSolution, (err)->
      res.render 'error', error: err
    .catch (err)->
      console.error err
      err.message = "未知错误"
      res.render 'error', error: err

