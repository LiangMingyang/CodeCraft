BCPC_Final = 24
BCPC_GROUP = 23

check = (userId)->
  up = {
    1:true,
    14357:true,
    16528:true,
    14442:true,
    16201:true,
    14407:true,
    15680:true,
    16003:true,
    500:true,
    13278:true,
    14611:true,
    16475:true,
    14570:true,
    16010:true,
    14199:true,
    14404:true,
    12753:true,
    16060:true,
    12908:true,
    16122:true,
    955:true,
    12689:true,
    15170:true,
    13422:true,
    15159:true,
    12770:true,
    12700:true,
    14539:true,
    12844:true,
    14327:true,
    16443:true,
    16459:true,
    12828:true,
    16510:true,
    16494:true,
    15186:true,
    12834:true,
    16537:true,
    16397:true,
    16435:true,
    15149:true,
    764:true,
    12671:true,
    12685:true,
    12833:true,
    16049:true,
    14402:true,
    16199:true,
    12774:true,
    16444:true,
    14129:true,
    16523:true,
    12629:true,
    15485:true,
    16121:true,
    16338:true,
    12897:true,
    2:true,
    16527:true,
    12827:true,
    12842:true,
    12719:true,
    16319:true,
    15337:true,
    14137:true,
    12808:true,
    16567:true,
    12858:true,
    15958:true,
    14144:true,
    13283:true,
    12870:true,
    12705:true,
    12877:true,
    16536:true,
    12713:true,
    14666:true,
    14371:true,
    12807:true,
    12642:true,
    12617:true,
    16614:true,
  }
  return !!up[userId]

exports.getStatus = (req, res)->
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

#exports.getStatus = (req, res)->
#  BCPC_2017 = 23
#  global.db.Promise.resolve()
#  .then ->
#    global.myUtils.findGroupsID(req.session.user)
#  .then (groupIDs)->
#    for id in groupIDs
#      if id is BCPC_2017
#        return true
#    return false
#  .then (registered)->
#    res.json(
#      user : req.session.user
#      registered    : registered
#    )
#  .catch (err)->
#    res.status(err.status || 400)
#    res.json(error:err.message)

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
        id : BCPC_GROUP
      include : [
        model: User
        where:
          id : [14357,16528,14442,16201,14407,15680,16003,500,13278,14611,16475,14570,16010,14199,14404,12753,16060,12908,16122,955,12689,15170,13422,15159,12770,12700,14539,12844,14327,16443,16459,12828,16510,16494,15186,12834,16537,16397,16435,15149,764,12671,12685,12833,16049,14402,16199,12774,16444,14129,16523,12629,15485,16121 ,16338,12897,2,16527,12827,12842,12719,16319,15337,14137,12808,16567,12858,15958,14144,13283,12870,12705,12877,16536,12713,14666,14371,12807,12642,12617,16614]
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