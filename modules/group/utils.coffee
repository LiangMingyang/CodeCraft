class UnknownUser extends Error
  constructor: (@message = "Unknown user, please login first") ->
    @name = 'UnknownUser'
    Error.captureStackTrace(this, UnknownUser)


exports.Error = {
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

exports.getGroupPeopleCount = (groups)->
  groups = [groups] if not groups instanceof Array
  Membership = global.db.models.membership
  options = {
    where:
      group_id : (group.id for group in groups)
    group : 'group_id'
    distinct : true
    attributes : ['group_id']
    plain : false
  }
  Membership.aggregate('user_id', 'count', options)

exports.addGroupCountKey = (counts, currentGroups, key)->
  tmp = {}
  for p in counts
    tmp[p.group_id] = p.count
  for p in currentGroups
    p[key] = 0
    p[key] = tmp[p.id] if tmp[p.id]