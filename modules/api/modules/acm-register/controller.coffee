
exports.getStatus = (req, res)->
  ACM_GROUP = 9
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findGroupsID(req.session.user)
  .then (groupIDs)->
    for id in groupIDs
      if id is ACM_GROUP
        return true
    return false
  .then (confirmed)->
    res.json(
      user : req.session.user
      confirmed : confirmed
    )
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)


exports.getList = (req, res)->
  User  = global.db.models.user
  Group = global.db.models.group
  joiner = undefined
  currentGroup = undefined
  BCPC_GROUP = 9
  global.db.Promise.resolve()
  .then ->
    Group.find
      where :
        id : BCPC_GROUP
      include : [
        model: User
        #where:
          #id : [2,11,16,19,21,22,24,29,31,33,39,41,42,44,46,57,59,70,72,73,74,76,77,83,87,89,91,96,106,111,114,119,136,144,145,163,171,14,179,183,201,203,211,229,255,264,276,280,285,294,299,310,369,421,486,488,493,494,495,496,500,501,504,507,511,512,514,51,515,517,520,527,537,540,559,569,575,583,586,593,598,605,634,639,686,691,718]
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
  ACM_GROUP = 9
  Group = global.db.models.group
  User = global.db.models.user
  joiner = undefined
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findGroupsID(req.session.user)
  .then (groupIDs)->
    for id in groupIDs
      if id is ACM_GROUP
        return true
    return false
  .then (confirmed)->
    throw new global.myErrors.InvalidAccess('你已经报名过了') if confirmed
    User.find req.session.user.id
  .then (user)->
    throw new global.myErrors.UnknownUser() if not user
    joiner = user
    user.nickname = req.body.nickname
    user.student_id = req.body.student_id
    user.phone = req.body.phone
    user.save()
  .then ->
    Group.find ACM_GROUP
  .then (group)->
    group.addUser(joiner, {access_level : 'member'})
  .then ->
    res.json(confirmed: true)
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)
