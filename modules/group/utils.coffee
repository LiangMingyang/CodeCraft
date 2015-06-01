class UnknownUser extends Error
  constructor: (@message = "Unknown user, please login first") ->
    @name = 'UnknownUser'
    Error.captureStackTrace(this, UnknownUser)


exports.Error = {
  UnknownUser : UnknownUser
}

exports.findGroups = (req)->
  User = global.db.models.user
  Group = global.db.models.group
  if not req.session.user
    return Group.findAll(
      where:
        access_level : ['public','protect']
      include : [
        model : User
        as : 'creator'
      ]
    )
  User.find req.session.user.id
  .then (user)->
    throw new UnknownUser() if not user
    user.getGroups()
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    Group.findAll(
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
    )
