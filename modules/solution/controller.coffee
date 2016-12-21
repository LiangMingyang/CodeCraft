#global.myUtils = require('./utils')

INDEX_PAGE = 'index'

LOGIN_PAGE = 'user/login'
HOME_PAGE = '/'
DB = global.db
Utils = global.myUtils

exports.getSolutionEditor = (req, res) ->
  DB = global.db
  Utils = global.myUtils
  User = DB.models.user
  Problem = DB.models.problem
  Contest = DB.models.contest
  SubmissionCode = DB.models.submission_code
  currentUser = undefined
  global.db.Promise.resolve()
    .then ->
      User.find req.session.user.id if req.session.user
    .then (user)->
      currentUser = user
      Utils.findSubmission(user, req.params.submissionID, [
        model : SubmissionCode
      ,
        model : User
        as : 'creator'
      ,
        model : Problem
      ,
        model : Contest
      ])
    .then (submission)->
      throw new global.myErrors.UnknownSubmission() if not submission
      res.render('solution/solution-editor-md', {
        submission: submission
        user : currentUser
      })
    .catch (err)->
      console.error err
      err.message = "未知错误"
      res.render 'error', error: err
exports.postSolutionEditor = (req, res) ->
  DB = global.db
  Utils = global.myUtils
  User = DB.models.user
  Solution = DB.models.solution
  currentUser = undefined
  currentSubmission  = undefined
  form = {
    source : req.body["editor-markdown-doc"]
    content : req.body["editor-html-code"]
    title : req.body["title"] || "Title"
  }
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
      if submission.solution
        submission.solution.source = form.source
        submission.solution.content = form.content
        submission.solution.title = form.title
        submission.solution.save()
      else
        Solution.create form
    .then (solution)->
      currentSubmission.setSolution(solution)
      #solution.setSubmission(currentSubmission)
    .then (submission)->
      res.render('solution/solution', {
        submission: submission
        user : currentUser
      })
    .catch (err)->
      console.error err
      err.message = "未知错误"
      res.render 'error', error: err