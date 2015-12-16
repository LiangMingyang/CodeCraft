check = (userId)->
  up = {
    2:true
    11:true
    16:true
    19:true
    21:true
    22:true
    24:true
    29:true
    31:true
    33:true
    39:true
    41:true
    42:true
    44:true
    46:true
    51:true
    57:true
    59:true
    70:true
    72:true
    73:true
    74:true
    76:true
    77:true
    83:true
    87:true
    89:true
    91:true
    96:true
    106:true
    111:true
    114:true
    119:true
    136:true
    144:true
    145:true
    163:true
    171:true
    179:true
    183:true
    201:true
    203:true
    211:true
    229:true
    255:true
    264:true
    276:true
    280:true
    285:true
    294:true
    299:true
    310:true
    369:true
    421:true
    486:true
    488:true
    493:true
    494:true
    495:true
    496:true
    500:true
    501:true
    504:true
    507:true
    511:true
    512:true
    514:true
    517:true
    520:true
    527:true
    537:true
    540:true
    559:true
    569:true
    575:true
    583:true
    586:true
    593:true
    598:true
    605:true
    634:true
    639:true
    691:true
    718:true
  }
  return !!up[userId]

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
        where:
          id : [2,11,16,19,21,22,24,29,31,33,39,41,42,44,46,57,59,70,72,73,74,76,77,83,87,89,91,96,106,111,114,119,136,144,145,163,171,14,179,183,201,203,211,229,255,264,276,280,285,294,299,310,369,421,486,488,493,494,495,496,500,501,504,507,511,512,514,51,517,520,527,537,540,559,569,575,583,586,593,598,605,634,639,691,718]
#        through:
#          where:
#            access_level : ['member'] #仅显示成员
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
