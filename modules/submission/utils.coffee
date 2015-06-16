path = require('path')

class UnknownUser extends Error
  constructor: (@message = "Please Login") ->
    @name = 'UnknownUser'
    Error.captureStackTrace(this, UnknownUser)

class UnknownSubmission extends Error
  constructor: (@message = "Unknown submission.") ->
    @name = 'UnknownSubmission'
    Error.captureStackTrace(this, UnknownSubmission)

exports.Error = {
  UnknownUser : UnknownUser
  UnknownSubmission : UnknownSubmission
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

exports.findSubmissions = (user,offset,include)->
  Submission = global.db.models.submission
  normalProblems = undefined
  myUtils = this
  global.db.Promise.resolve()
  .then ->
    myUtils.findProblems(user)
  .then (problems)->
    return [] if not problems
    normalProblems = (problem.id for problem in problems)
    Submission.findAll(
      where :
          problem_id : normalProblems
          contest_id : null
      include : include
      order : [
        ['created_at', 'DESC']
      ,
        ['id','DESC']
      ]
      offset : offset
      limit : global.config.pageLimit.submission
    )

exports.findSubmission = (user,submissionID,include)->
  Submission = global.db.models.submission
  Contest = global.db.models.contest
  Problem = global.db.models.problem
  adminContestIDs = undefined
  adminProblemIDs = undefined
  adminGroupIDs = undefined
  global.db.Promise.resolve()
  .then ->
    user.getGroups() if user
  .then (groups)->
    return [] if not groups
    adminGroupIDs = (group.id for group in groups when group.membership.access_level in ['owner','admin'])
    Contest.findAll(
      where:
        group_id : adminGroupIDs
    )
  .then (contests)->
    return [] if not contests
    adminContestIDs = (contest.id for contest in contests)
    Problem.findAll(
      where :
        group_id : adminGroupIDs
    )
  .then (problems)->
    return undefined if not problems
    adminProblemIDs = (problem.id for problem in problems)
    Submission.find(
      where :
        id : submissionID
        $or : [
          creator_id : (
            if user
              user.id
            else
              null
          )
        ,
          problem_id : adminProblemIDs
        ,
          contest_id : adminGroupIDs
        ]
      include : include
    )