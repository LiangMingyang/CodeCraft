BCPC_Final = 15
BCPC_GROUP = 14
check = (userId)->
  up = {
    1210: true,
    13273: true,
    501: true,
    13260: true,
    12689: true,
    12610: true,
    12622: true,
    13413: true,
    12967: true,
    12623: true,
    13032: true,
    12679: true,
    12657: true,
    13278: true,
    12588: true,
    31: true,
    12807: true,
    119: true,
    12537: true,
    70: true,
    285: true,
    393: true,
    12877: true,
    13330: true,
    540: true,
    91: true,
    745: true,
    718: true,
    24: true,
    12924: true,
    44: true,
    13295: true,
    35: true,
    87: true,
    12855: true,
    46: true,
    208: true,
    377: true,
    89: true,
    624: true,
    21: true,
    66: true,
    83: true,
    76: true,
    23: true,
    286: true,
    45: true,
    13649: true,
    12719: true,
    12692: true,
    12753: true,
    12600: true,
    13642: true,
    22: true,
    12593: true,
    59: true,
    12606: true,
    86: true,
    13398: true,
    12867: true,
    13: true,
    105: true,
    12728: true,
    12601: true,
    12671: true,
    12729: true,
    12596: true,
    12842: true,
    12641: true,
    1034: true,
    12705: true,
    639: true,
    476: true,
    12629: true,
    12626: true,
    12642: true,
    12717: true,
    12950: true,
    62: true,
    146: true,
    12897: true,
    43: true,
    55: true,
    109: true,
    96: true,
    12700: true,
    78: true,
    686: true,
    125: true,
    142: true,
    52: true,
    481: true,
    198: true,
    93: true,
    100: true,
    264: true,
    217: true,
    16: true,
    98: true,
    85: true,
    306: true,
    72: true,
    60: true,
    48: true,
    223: true,
  }
  return !!up[userId]

exports.getStatus = (req, res)->
  #BCPC_Final = 15
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
#  BCPC_2016 = 14
#  global.db.Promise.resolve()
#  .then ->
#    global.myUtils.findGroupsID(req.session.user)
#  .then (groupIDs)->
#    for id in groupIDs
#      if id is BCPC_2016
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
          id : [1210,13273,501,13260,12689,12610,12622,13413,12967,12623,13032,12679,12657,13278,12588,31,12807,119,12537,70,285,393,12877,13330,540,91,745,718,24,12924,44,13295,35,87,12855,46,208,377,89,624,21,66,83,76,23,286,45,13649,12719,12692,12753,12600,13642,22,12593,59,12606,86,13398,12867,13,105,12728,12601,12671,12729,12596,12842,12641,1034,12705,639,476,12629,12626,12642,12717,12950,62,146,12897,43,55,109,96,12700,78,686,125,142,52,481,198,93,100,264,217,16,98,85,306,72,60,48,223]
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
