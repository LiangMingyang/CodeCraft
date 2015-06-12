path = require('path')
crypto = require('crypto')

class UnknownUser extends Error
  constructor: (@message = "Please Login") ->
    @name = 'UnknownUser'
    Error.captureStackTrace(this, UnknownUser)

class UnknownSubmission extends Error
  constructor: (@message = "Unknown submission.") ->
    @name = 'UnknownSubmission'
    Error.captureStackTrace(this, UnknownSubmission)

class UnknownJudge extends Error
  constructor: (@message = "Unknown judge.") ->
    @name = 'UnknownJudge'
    Error.captureStackTrace(this, UnknownJudge)

class UnknownSubmission extends Error
  constructor: (@message = "Unknown submission.") ->
    @name = 'UnknownSubmission'
    Error.captureStackTrace(this, UnknownSubmission)

exports.Error = {
  UnknownUser : UnknownUser
  UnknownSubmission : UnknownSubmission
  UnknownJudge : UnknownJudge
}

exports.getStaticProblem = (problemId) ->
  dirname = global.config.problem_resource_path
  path.join dirname, problemId.toString()

exports.checkJudge = (opt)->
  Judge = global.db.models.judge
  myUtils = this
  global.db.Promise.resolve()
  .then ->
    Judge.find opt.id
  .then (judge)->
    throw new myUtils.Error.UnknownJudge() if not judge
    throw new myUtils.Error.UnknownJudge() if opt.token isnt crypto.createHash('sha1').update(judge.secret_key + '$' + opt.post_time).digest('hex')
