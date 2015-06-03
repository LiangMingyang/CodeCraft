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

exports.findGroups = (user, include)->
  Group = global.db.models.group
  currentUser = undefined
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    currentUser = user
    user.getGroups()
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    Group.findAll
      where:
        $or: [
          access_level : ['public','protect']
        ,
          id : normalGroups
        ]
      include : include

exports.findGroup = (user, groupID, include)->
  Group = global.db.models.group
  currentUser = undefined
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    currentUser = user
    user.getGroups()
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    Group.find
      where:
        $and: [
          id : groupID
        ,
          $or: [
            access_level : ['public','protect']
          ,
            id : normalGroups
          ]
        ]
      include : include