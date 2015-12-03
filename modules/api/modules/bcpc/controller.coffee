exports.getStatus = (req, res)->


  Group = global.db.models.group
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findGroupsID(req.session.user)
  .then (groupIDs)->
    for id in groupIDs
      if id is 6
        return true
    return false
  .then (registed)->
    res.json(registed:registed)
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)


exports.getRegister = (req, res)->
  User  = global.db.models.user
  Group = global.db.models.group
  joiner = undefined
  currentGroup = undefined
  BCPC_GROUP = 6
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
    throw new global.myErrors.UnknownGroup() if res
    currentGroup.addUser(joiner, {access_level : 'member'})
  .then ->
    res.json(registed:true)
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)
