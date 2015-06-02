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

exports.findGroups = (req)->
  User = global.db.models.user
  Group = global.db.models.group
  global.db.Promise.resolve()
  .then ->
    return [] if not req.session.user
    User.find req.session.user.id
    .then (user)->
      throw new UnknownUser() if not user
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
      include : [
        model : User
        as : 'creator'
      ]

exports.findGroup = (req, groupID)->
  User = global.db.models.user
  Group = global.db.models.group
  global.db.Promise.resolve()
  .then ->
    return [] if not req.session.user
    User.find req.session.user.id
    .then (user)->
      throw new UnknownUser() if not user
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
      include : [
        model : User
        as : 'creator'
      ]