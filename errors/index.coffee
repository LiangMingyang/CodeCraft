class UnknownUser extends Error
  constructor: (@message = "Unknown user.") ->
    @name = 'UnknownUser'
    Error.captureStackTrace(this, UnknownUser)

class UnknownGroup extends Error
  constructor: (@message = "Unknown Group") ->
    @name = 'UnknownGroup'
    Error.captureStackTrace(this, UnknownGroup)

class LoginError extends Error
  constructor: (@message = "Wrong password or username.") ->
    @name = 'LoginError'
    Error.captureStackTrace(this, LoginError)

class RegisterError extends Error
  constructor: (@message = "Unvalidated register message.") ->
    @name = 'LoginError'
    Error.captureStackTrace(this, LoginError)

class InvalidAccess extends Error
  constructor: (@message = "Invalid Access, please return") ->
    @name = 'InvalidAccess'
    Error.captureStackTrace(this, InvalidAccess)

class UpdateError extends Error
  constructor: (@message = "Unvalidated update message.") ->
    @name = 'UpdateError'
    Error.captureStackTrace(this, UpdateError)

class UnknownSubmission extends Error
  constructor: (@message = "Unknown submission.") ->
    @name = 'UnknownSubmission'
    Error.captureStackTrace(this, UnknownSubmission)

class UnknownProblem extends Error
  constructor: (@message = "Unknown problem") ->
    @name = 'UnknownProblem'
    Error.captureStackTrace(this, UnknownProblem)

class InvalidFile extends Error
  constructor: (@message = "File not exist!") ->
    @name = 'InvalidFile'
    Error.captureStackTrace(this, InvalidFile)

class UnknownJudge extends Error
  constructor: (@message = "Unknown judge.") ->
    @name = 'UnknownJudge'
    Error.captureStackTrace(this, UnknownJudge)

class UnknownContest extends Error
  constructor: (@message = "Unknown contest.") ->
    @name = 'UnknownContest'
    Error.captureStackTrace(this, UnknownContest)

module.exports = {
  UnknownUser : UnknownUser
  UnknownGroup : UnknownGroup
  UnknownContest : UnknownContest
  UnknownSubmission : UnknownSubmission
  UnknownProblem : UnknownProblem
  UnknownJudge : UnknownJudge
  LoginError  : LoginError
  RegisterError : RegisterError
  InvalidAccess : InvalidAccess
  UpdateError : UpdateError
  InvalidFile : InvalidFile
}