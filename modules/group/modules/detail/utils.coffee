class UnknownGroup extends Error
  constructor: (@message = "Unknown Group") ->
    @name = 'UnknownGroup'
    Error.captureStackTrace(this, UnknownGroup)


exports.Error = {
  UnknownGroup : UnknownGroup
}