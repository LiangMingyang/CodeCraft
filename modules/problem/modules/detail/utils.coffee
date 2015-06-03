path = require('path')

class UnknownProblem extends Error
  constructor: (@message = "Unknown problem") ->
    @name = 'UnknownProblem'
    Error.captureStackTrace(this, UnknownProblem)

class InvalidAccess extends Error
  constructor: (@message = "Invalid Access, please return") ->
    @name = 'InvalidAccess'
    Error.captureStackTrace(this, InvalidAccess)

class UnknownUser extends Error
  constructor: (@message = "Unknown user, please login first") ->
    @name = 'UnknownUser'
    Error.captureStackTrace(this, UnknownUser)

class InvalidFile extends Error
  constructor: (@message = "File not exist!") ->
    @name = 'InvalidFile'
    Error.captureStackTrace(this, InvalidFile)

exports.getStaticProblem = (problemId) ->
  dirname = path.resolve(__dirname,'../../resource')
  path.join dirname, problemId.toString()

exports.Error = {
  UnknownUser: UnknownUser,
  InvalidAccess: InvalidAccess,
  UnknownProblem: UnknownProblem,
  InvalidFile: InvalidFile
}

exports.findProblems = (req,include) ->
  User = global.db.models.user
  Problem = global.db.models.problem
  currentUser = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    return [] if not user
    currentUser = user
    currentUser.getGroups()
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    adminGroups = (group.id for group in groups when group.membership.access_level in ['owner','admin'])
    Problem.findAll({
      where :
        $or:[
          creator_id : currentUser.id  if currentUser #如果该用户是创建者可以看到的
        ,
          access_level : 'public'    #public的题目谁都可以看
        ,
          access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
          group_id : normalGroups
        ,
          access_level : 'private'  #如果这个赛事权限是private，那么如果该用户是小组管理员或拥有�?�就都可以看�?
          group_id : adminGroups
        ]
      include : include
    })

exports.findProblem = (user, problemID,include)->
  Problem = global.db.models.problem
  currentUser = undefined
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    currentUser = user
    currentUser.getGroups()
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    adminGroups = (group.id for group in groups when group.membership.access_level in ['owner','admin'])
    Problem.find({
      where :
        $and:
          id : problemID
          $or:[
            creator_id : currentUser.id  if currentUser #如果该用户是创建者可以看到的
          ,
            access_level : 'public'    #public的题目谁都可以看
          ,
            access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
            group_id : normalGroups
          ,
            access_level : 'private'  #如果这个赛事权限是private，那么如果该用户是小组管理员或拥有�?�就都可以看�?
            group_id : adminGroups
          ]
      include : include
    })
