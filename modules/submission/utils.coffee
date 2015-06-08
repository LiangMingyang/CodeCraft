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

exports.findSubmissions = (user,include)->
  Submission = global.db.models.submission
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    Submission.findAll(   #只能找到自己的非比赛提交
      where :
        contest_id : null
        creator_id : user.id
      include : include
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