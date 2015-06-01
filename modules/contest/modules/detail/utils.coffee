class UnknownUser extends Error
  constructor: (@message = "Unknown user.") ->
    @name = 'UnknownUser'
    Error.captureStackTrace(this, UnknownUser)

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

class UnknownContest extends Error
  constructor: (@message = "Unknown contest.") ->
    @name = 'UnknownContest'
    Error.captureStackTrace(this, UnknownContest)


exports.Error = {
  UnknownUser : UnknownUser
  LoginError  : LoginError
  RegisterError : RegisterError
  InvalidAccess : InvalidAccess
  UpdateError : UpdateError
  UnknownContest : UnknownContest
}

exports.authContest = (req,contest)->
  Contest = global.db.models.contest
  User = global.db.models.user
  currentUser = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    return [] if not user
    currentUser = user
    currentUser.getGroups()
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    adminGroups = (group.id for group in groups when group.membership.access_level in ['owner','admin'])
    return true if contest.access_level is 'public'
    return true if currentUser and contest.creator_id is currentUser.id
    return true if contest.access_level is 'protect' and contest.group_id in normalGroups
    return true if contest.access_level is 'private' and contest.group_id in adminGroups
    return false