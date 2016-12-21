#global.myUtils = require('./utils')

INDEX_PAGE = 'index'

LOGIN_PAGE = 'user/login'
HOME_PAGE = '/'
DB = global.db
Utils = global.myUtils

exports.getSolution = (req, res)->
  DB = global.db
  Utils = global.myUtils
  User = DB.models.user
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
      Utils.findSubmission(user, req.params.submissionID, [
        model : SubmissionCode
      ,
        model : User
        as : 'creator'
      ,
        model : Problem
      ,
        model : Solution
      ])
    .then (submission)->
      throw new global.myErrors.UnknownSubmission() if not submission
      res.render('solution/solution', {
        submission: submission
        user : currentUser
        editable : submission.creator.id is currentUser.id
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
        console.log "solution_1"
        submission.solution.source = form.source
        submission.solution.content = form.content
        submission.solution.title = form.title
        submission.solution.save()
      else
        console.log "solution_2"
        Solution.create form
          .then (solution)->
            console.log solution
            currentSubmission.setSolution(solution)
      #solution.setSubmission(currentSubmission)
    .then (solution)->
      res.redirect("#{currentSubmission.id}")
    .catch (err)->
      console.error err
      err.message = "未知错误"
      res.render 'error', error: err