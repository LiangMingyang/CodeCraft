myUtils = require('./utils')
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

  Problem.find req.param.problemID
  .then (problem) ->
    throw new myUtils.Error.UnknownProblem() if not problem
    res.render('problem/detail', {
      title: 'Problem List Page',
      problem: {
        problem_id: problem.id
        title: problem.title,
        description: '在计算机（软件）技术中，通配符可用于代替字符。\n通常地，星号“*”匹配0个或以上的字符。\n问题来了，输入两个字符串，判断第二个字符串中有没有能够满足第一个字符串的子串。',
        test_setting: {
          input: 'hai mei you zuo',
          output: 'hai mei you zuo',
          time_limit: '2000 ms',
          memory_limit: '64M'
        }
      }
    })
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
    Problem.find req.param.problemID
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
    req.flash 'info', err.message
    res.redirect HOME_PAGE

exports.getSubmissions = (req, res) ->

  form = {
    problem_id: req.param.problemID
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


