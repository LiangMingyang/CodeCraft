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

exports.findGroups = (user, include)->
  Group = global.db.models.group
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups({
      attributes : ['id']
    })
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    Group.findAll
      where:
        $or: [
          access_level : ['public','protect']
        ,
          id : normalGroups
        ]
      include : include

exports.findGroup = (user, groupID, include)->
  Group = global.db.models.group
  currentUser = undefined
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    currentUser = user
    user.getGroups({
      attributes : ['id']
    })
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
      include : include

exports.findUser = (group, userID) ->
  global.db.Promise.resolve()
  .then ->
    group.getUsers({
      where :
        id : userID
    })
  .then (users)->
    return undefined if users.length is 0
    return undefined if users[0].membership.access_level is 'verifying'
    return undefined if users[0].membership.access_level is 'member' and group.access_level is 'private' #一般认为小组如果是private的那么小组成员不再对其有任何权限
    return users[0]

exports.findProblems = (user, include) ->
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups()
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    adminGroups = (group.id for group in groups when group.membership.access_level in ['owner','admin'])
    Problem.findAll({
      where :
        $or:[
          creator_id : user.id  if user #如果该用户是创建者可以看到的
        ,
          access_level : 'public'    #public的题目谁都可以看
        ,
          access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
          group_id : normalGroups
        ,
          access_level : 'private'  #如果这个赛事权限是private，那么如果该用户是小组管理员或拥有者就都可以看到
          group_id : adminGroups
        ]
      include : include
    })

exports.findProblem = (user, problemID,include)->
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups()
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    adminGroups = (group.id for group in groups when group.membership.access_level in ['owner','admin'])
    Problem.find({
      where :
        $and:
          id : problemID
          $or:[
            creator_id : user.id  if user #如果该用户是创建者可以看到的
          ,
            access_level : 'public'    #public的题目谁都可以看
          ,
            access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
            group_id : normalGroups
          ,
            access_level : 'private'  #如果这个赛事权限是private，那么如果该用户是小组管理员或拥有者就都可以看到
            group_id : adminGroups
          ]
      include : include
    })

exports.getResultPeopleCount = (problems, results)->
  problems = [problems] if not problems instanceof Array
  Submission = global.db.models.submission
  options = {
    where:
      problem_id : (problem.id for problem in problems)
    group : 'problem_id'
    distinct : true
    attributes : ['problem_id']
    plain : false
  }
  options.where.result = results if results
  Submission.aggregate('creator_id', 'count', options)

exports.getResultCount = (user, problems, results, contest)->
  return [] if not user
  problems = [problems] if not problems instanceof Array
  Submission = global.db.models.submission
  options = {
    where:
      problem_id : (problem.id for problem in problems)
    group : 'problem_id'
    distinct : true
    attributes : ['problem_id']
    plain : false
  }
  options.where.result = results if results
  options.where.contest_id = contest.id if contest
  Submission.aggregate('creator_id', 'count', options)