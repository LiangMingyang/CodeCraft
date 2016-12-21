#global.myUtils = require('./utils')

INDEX_PAGE = 'index'

LOGIN_PAGE = 'user/login'
HOME_PAGE = '/'
DB = global.db
Utils = global.myUtils

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
  Contest = DB.models.Contest
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
      res.render('solution/solution', {
        submission: submission
        user : currentUser
        editable : submission.creator.id is currentUser?.id
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
  currentUser = undefined
  currentSubmission  = undefined
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
        secret_limit : req.body["secret_limit"] || new Date()+24*60*601000
      }
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
    .then (solution)->
      res.redirect("#{currentSubmission.id}")
    .catch (err)->
      console.error err
      err.message = "未知错误"
      res.render 'error', error: err