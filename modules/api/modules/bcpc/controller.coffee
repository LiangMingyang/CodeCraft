BCPC_Final = 99
BCPC_GROUP = 41

check = (userId)->
  up = { # users advanced into final
    1:true
  }
  return !!up[userId]

# exports.getStatus = (req, res)->
#   global.db.Promise.resolve()
#   .then ->
#     global.myUtils.findGroupsID(req.session.user)
#   .then (groupIDs)->
#     for id in groupIDs
#       if id is BCPC_Final
#         return true
#     return false
#   .then (confirmed)->
#     passed = req.session.user && check(req.session.user.id)
#     res.json(
#       user : req.session.user
#       passed    : passed
#       confirmed : confirmed
#     )
#   .catch (err)->
#     res.status(err.status || 400)
#     res.json(error:err.message)

exports.getStatus = (req, res)->
 global.db.Promise.resolve()
 .then ->
   global.myUtils.findGroupsID(req.session.user)
 .then (groupIDs)->
   for id in groupIDs
     if id is BCPC_GROUP
       return true
   return false
 .then (registered)->
   res.json(
     user : req.session.user
     registered    : registered
   )
 .catch (err)->
   res.status(err.status || 400)
   res.json(error:err.message)

exports.getRegister = (req, res)->
  User  = global.db.models.user
  Group = global.db.models.group
  joiner = undefined
  currentGroup = undefined
  global.db.Promise.resolve()
  .then ->
    throw new global.myErrors.UnknownUser() if not req.session.user
    User.find(req.session.user.id)
  .then (user)->
    throw new global.myErrors.UnknownUser() if not user
    joiner = user
    Group.find(BCPC_GROUP)
  .then (group)->
    throw new global.myErrors.UnknownGroup() if not group
    currentGroup = group
    group.hasUser(joiner)
  .then (res) ->
    throw new global.myErrors.UnknownGroup("你已经注册过了") if res
    currentGroup.addUser(joiner, {access_level : 'member'})
  .then ->
    res.json(registered:true)
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)


exports.getList = (req, res)->
  User  = global.db.models.user
  Group = global.db.models.group
  joiner = undefined
  currentGroup = undefined
  global.db.Promise.resolve()
  .then ->
    Group.find
      where :
        id : BCPC_Final
      include : [
        model: User
        where:
          id :[1] # users advanced into final
        through:
          where:
            access_level : ['member'] #仅显示成员
      ]
  .then (group)->
    throw new global.myErrors.UnknownGroup() if not group
    res.json(group.get(plain:true))
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)

exports.postConfirm = (req, res)->
  Group = global.db.models.group
  User = global.db.models.user
  joiner = undefined
  global.db.Promise.resolve()
  .then ->
    passed = req.session.user && check(req.session.user.id)
    throw new global.myErrors.InvalidAccess('做不到') if not passed
    global.myUtils.findGroupsID(req.session.user)
  .then (groupIDs)->
    for id in groupIDs
      if id is BCPC_Final
        return true
    return false
  .then (confirmed)->
    throw new global.myErrors.InvalidAccess('你已经确认过了') if confirmed
    User.find req.session.user.id
  .then (user)->
    throw new global.myErrors.UnknownUser() if not user
    joiner = user
    user.nickname = req.body.nickname
    user.student_id = req.body.student_id
    user.phone = req.body.phone
    user.save()
  .then ->
    Group.find BCPC_Final
  .then (group)->
    group.addUser(joiner, {access_level : 'member'})
  .then ->
    res.json(confirmed: true)
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)