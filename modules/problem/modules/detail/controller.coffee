myUtils = require('./utils')
fs = require('fs')
path = require('path')
markdown = require('markdown').markdown
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
SUBMISSION_PAGE = 'submission'
SUBMIT_PAGE = 'submit'

INDEX_PAGE = '.'

#Foreign url
LOGIN_PAGE = '/user/login'
GROUP_PAGE = '/group/problem' #然而这个东西并不能用相对路径

exports.getIndex = (req, res) ->
  Problem = global.db.models.problem
  console.log req.params

  Problem.find req.params.problemID
  .then (problem) ->
    throw new myUtils.Error.UnknownProblem() if not problem
    fs.readFile path.join(myUtils.getStaticProblem(problem.id), 'manifest.json'), (err, manifest_str) ->
      throw new myUtils.Error.InvalidFile() if err
      manifest = JSON.parse manifest_str
      fs.readFile path.join(myUtils.getStaticProblem(problem.id), manifest.description), (err, description) ->
        throw new myUtils.Error.InvalidFile() if err
        res.render 'problem/detail', {
          title: 'Problem List Page',
          problem: {
            problem_id: problem.id
            title: problem.title,
            description: markdown.toHTML(description.toString()),
            test_setting: {
              language: manifest.test_setting.language.split(','),
              time_limit: manifest.test_setting.time_limit,
              memory_limit: manifest.test_setting.memory_limit,
              special_judge: manifest.test_setting.special_judge == null
            }
          }
        }
  .catch myUtils.Error.UnknownProblem, (err)->
    req.flash 'info', 'problem not exist'
    res.redirect HOME_PAGE
  .catch (err)->
    req.flash 'info', err.message
    res.redirect HOME_PAGE

exports.postSubmission = (req, res) ->

  form = {
    lang: req.body.lang
  }

  form_code = {
    content: req.body.code
  }

  Problem = global.db.models.problem;
  Submission = global.db.models.submission
  Submission_Code = global.db.models.submission_code
  User = global.db.models.user
  current_user = undefined
  current_submission = undefined
  current_problem = undefined

  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id
  .then (user) ->
    throw new myUtils.Error.UnknownUser() if not user
    current_user = user
    Problem.find req.params.problemID
  .then (problem) ->
    throw new myUtils.Error.UnknownProblem() if not problem
    current_problem = problem
    Submission.create(form)
  .then (submission) ->
    current_user.addSubmission(submission)
  .then (submission) ->
    current_problem.addSubmission(submission)
  .then (submission) ->
    current_submission = submission
    Submission_Code.create(form_code)
  .then (code) ->
    current_submission.setSubmission_code(code)
  .then (submission) ->
    req.flash 'info', 'submit code successfully'
    res.redirect SUBMISSION_PAGE

  .catch myUtils.Error.UnknownUser, (err)->
    req.flash 'info', 'Unknown User'
    res.redirect INDEX_PAGE
  .catch myUtils.Error.UnknownProblem, (err)->
    req.flash 'info', 'problem not exist'
    res.redirect HOME_PAGE
  .catch (err)->
    req.flash 'info', 'Unknown Error!'
    res.redirect HOME_PAGE

exports.getSubmissions = (req, res) ->

  form = {
    problem_id: req.params.problemID
  }
  Submission = global.db.models.submission
  User = global.db.models.user
  Submission
    .findAll({
      where: form,
      include: [
        model: User
      ]
    })
  .then (submissions) ->
    res.render('problem/submission', {
      title: 'Problem Submission List Page',
      headline: 'Problem index(SHEN ME DOU MEI YOU!)',
      submissions: submissions
    })
  .catch (err)->
    req.flash 'info', err.message
    res.redirect HOME_PAGE

exports.getCode = (req, res) ->
  Submission_Code = global.db.models.submission_code
  Submission_Code.find req.params.submissionID
  .then (code) ->
    res.json({
      code: code.content
    })



