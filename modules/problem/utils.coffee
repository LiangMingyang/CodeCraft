class InvalidAccess extends Error
  constructor: (@message = "Invalid Access, please return") ->
    @name = 'InvalidAccess'
    Error.captureStackTrace(this, InvalidAccess)

class UnknownUser extends Error
  constructor: (@message = "Unknown user, please login first") ->
    @name = 'UnknownUser'
    Error.captureStackTrace(this, UnknownUser)

exports.Error = {
  UnknownUser: UnknownUser,
  InvalidAccess : InvalidAccess
}