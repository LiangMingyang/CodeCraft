path = require('path')

class UnknownUser extends Error
  constructor: (@message = "Please Login") ->
    @name = 'UnknownUser'
    Error.captureStackTrace(this, UnknownUser)

exports.Error = {
  UnknownUser: UnknownUser
}