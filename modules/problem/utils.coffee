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
  dirname = global.config.problem_resource_path
  path.join dirname, problemId.toString()

exports.Error = {
  UnknownUser: UnknownUser,
  InvalidAccess: InvalidAccess,
  UnknownProblem: UnknownProblem,
  InvalidFile: InvalidFile
}

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

exports.getResultPeopleCount = (problems, results, contest)->
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

exports.hasResult = (user, problems, results, contest)->
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    problems = [problems] if not problems instanceof Array
    Submission = global.db.models.submission
    options = {
      where:
        problem_id : (problem.id for problem in problems)
        creator_id : user.id
      group : 'problem_id'
      distinct : true
      attributes : ['problem_id']
      plain : false
    }
    options.where.result = results if results
    options.where.contest_id = contest.id if contest
    Submission.aggregate('creator_id', 'count', options)

exports.addCountKey = (counts, currentProblems, key)->
  tmp = {}
  for p in counts
    tmp[p.problem_id] = p.count
  for p in currentProblems
    p[key] = 0
    p[key] = tmp[p.id] if tmp[p.id]

exports.getProblemsStatus = (currentProblems,currentUser,currentContest)->
  myUtils = this
  global.db.Promise.all [
    myUtils.getResultPeopleCount(currentProblems, 'AC',currentContest).then (counts)->myUtils.addCountKey(counts, currentProblems, 'acceptedPeopleCount')
  ,
    myUtils.getResultPeopleCount(currentProblems,undefined,currentContest).then (counts)->myUtils.addCountKey(counts, currentProblems, 'triedPeopleCount')
  ,
    myUtils.hasResult(currentUser,currentProblems,'AC',currentContest).then (counts)->myUtils.addCountKey(counts, currentProblems, 'accepted')
  ,
    myUtils.hasResult(currentUser,currentProblems,undefined,currentContest).then (counts)->myUtils.addCountKey(counts, currentProblems, 'tried')
  ]