myUtils = require('./utils')
sequelize = require('sequelize')
fs = sequelize.Promise.promisifyAll(require('fs'), suffix:'Promised')
FS = require('fs')
path = require('path')
INDEX_PAGE = 'index'

LOGIN_PAGE = 'user/login'
HOME_PAGE = '/'

exports.postTask = (req, res)->
  Submission = global.db.models.submission
  SubmissionCode = global.db.models.submission_code
  currentSubmission = undefined
  myUtils.checkJudge(req.body.judge)
  .then ->
    Submission.find(
      where:
        result : 'WT'
      include : [
        model : SubmissionCode
      ]
    )
  .then (submission)->
    throw new myUtils.Error.UnknownSubmission() if not submission
    currentSubmission = submission
    fs.readFilePromised path.join(myUtils.getStaticProblem(submission.problem_id), 'manifest.json')
  .then (manifest_str) ->
    currentSubmission.dataValues.manifest = JSON.parse manifest_str #应当读取special_judge的，但是现在是忽略了的
    res.json(currentSubmission)

  .catch myUtils.Error.UnknownSubmission, ->
    res.end();
  .catch (err)->
    console.log err
    res.end();


exports.postFile = (req, res)->
  myUtils.checkJudge(req.body.judge)
  .then ->
    problemID = req.body.problem_id
    filename = req.body.filename
    download = sequelize.Promise.promisify(res.download, res)
    download path.join(myUtils.getStaticProblem(problemID), filename), filename
  .catch (err)->
    console.log err
    res.end();

exports.postReport = (req, res)->
  Submission = global.db.models.submission
  myUtils.checkJudge(req.body.judge)
  .then ->
    Submission.update(
      result : req.body.result
      score : req.body.score
      detail : req.body.detail
      judge_id : req.body.judge_id
      time_cost : req.body.time_cost
      memory_cost : req.body.memory_cost
    ,
      where :
        id : req.body.submission_id
    )
  .then ()->
    res.end()

  .catch (err)->
    console.log err
    res.end();
