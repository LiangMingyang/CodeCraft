class UnknownProblem extends Error
  constructor: (@message = "Unknown user, please login first") ->
    @name = 'UnknownProblem'
    Error.captureStackTrace(this, UnknownProblem)

class InvalidAccess extends Error
  constructor: (@message = "Invalid Access, please return") ->
    @name = 'InvalidAccess'
    Error.captureStackTrace(this, InvalidAccess)

class UnknownUser extends Error
  constructor: (@message = "Unknown user, please login first") ->
    @name = 'UnknownUser'
    Error.captureStackTrace(this, UnknownUser)

exports.Error = {

}

exports.Error = {
  UnkwownUser: UnknownUser,
  InvalidAccess: InvalidAccess,
  UnknownProblem: UnknownProblem
}