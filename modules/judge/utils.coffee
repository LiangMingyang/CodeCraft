path = require('path')

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

exports.checkJudge = (judge)->
  #TODO: should check it
  global.db.Promise.resolve()
