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
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups({
      attributes : ['id']
    })
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
    user.getGroups({
      attributes : ['id']
    })
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

exports.findUser = (group, userID) ->
  global.db.Promise.resolve()
  .then ->
    group.getUsers({
      where :
        id : userID
    })
  .then (users)->
    return undefined if users.length is 0
    return undefined if users[0].membership.access_level is 'verifying'
    return undefined if users[0].membership.access_level is 'member' and group.access_level is 'private' #一般认为小组如果是private的那么小组成员不再对其有任何权限
    return users[0]