check = (userId)->
  cheat = {
    99:true,51:true,142:true,85:true,60:true,217:true,124:true,146:true,194:true,62:true,98:true,43:true,282:true,307:true,88:true,47:true,164:true,143:true,147:true,207:true,74:true,210:true,11:true
  }
  return false if cheat[userId]
  up = {
    421: true,517: true,496: true,500: true,136: true,718: true,501: true,41: true,31: true,21: true,586: true,493: true,495: true,515: true,369: true,537: true,276: true,540: true,520: true,504: true,203: true,639: true,527: true,87: true,76: true,575: true,634: true,70: true,24: true,2: true,605: true,29: true,11: true,111: true,16: true,559: true,22: true,507: true,73: true,255: true,91: true,569: true,119: true,19: true,74: true,114: true,106: true,486: true,514: true,511: true,77: true,686: true,43: true,62: true,89: true,163: true,83: true,59: true,217: true,39: true,285: true,72: true,47: true,174: true,264: true,691: true,488: true,583: true,146: true,33: true,144: true,46: true,145: true,57: true,310: true,183: true,211: true,598: true,171: true,42: true,593: true,44: true,494: true,99: true,96: true,207: true,147: true,512: true,51: true,299: true,280: true,294: true,60: true,85: true,142: true,124: true,194: true,282: true,229: true,201: true,179: true,98: true
  }
  return up[userId] isnt undefined

exports.getStatus = (req, res)->
  BCPC_Final = 7
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findGroupsID(req.session.user)
  .then (groupIDs)->
    for id in groupIDs
      if id is BCPC_Final
        return true
    return false
  .then (confirmed)->
    passed = req.session.user && check(req.session.user.id)
    res.json(
      user : req.session.user
      passed    : passed
      confirmed : confirmed
    )
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
    throw new global.myErrors.UnknownGroup("你已经注册过了") if res
    currentGroup.addUser(joiner, {access_level : 'member'})
  .then ->
    res.json(registed:true)
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)


exports.getList = (req, res)->
  User  = global.db.models.user
  Group = global.db.models.group
  joiner = undefined
  currentGroup = undefined
  BCPC_GROUP = 6
  global.db.Promise.resolve()
  .then ->
    Group.find
      where :
        id : BCPC_GROUP
      include : [
        model: User
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
  BCPC_Final = 7
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
