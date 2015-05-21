class UnknownGroup extends Error
  constructor: (@message = "Unknown Group") ->
    @name = 'UnknownGroup'
    Error.captureStackTrace(this, UnknownGroup)

class UnknownUser extends Error
  constructor: (@message = "Unknown user, please login first") ->
    @name = 'UnknownUser'
    Error.captureStackTrace(this, UnknownUser)


exports.Error = {
  UnknownGroup : UnknownGroup
  UnknownUser : UnknownUser
}