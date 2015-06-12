class UnknownUser extends Error
  constructor: (@message = "Unknown user.") ->
    @name = 'UnknownUser'
    Error.captureStackTrace(this, UnknownUser)

class LoginError extends Error
  constructor: (@message = "Wrong password or username.") ->
    @name = 'LoginError'
    Error.captureStackTrace(this, LoginError)

class RegisterError extends Error
  constructor: (@message = "Unvalidated register message.") ->
    @name = 'LoginError'
    Error.captureStackTrace(this, LoginError)

class InvalidAccess extends Error
  constructor: (@message = "Invalid Access, please return") ->
    @name = 'InvalidAccess'
    Error.captureStackTrace(this, InvalidAccess)

class UpdateError extends Error
  constructor: (@message = "Unvalidated update message.") ->
    @name = 'UpdateError'
    Error.captureStackTrace(this, UpdateError)

class UnknownContest extends Error
  constructor: (@message = "Unknown contest.") ->
    @name = 'UnknownContest'
    Error.captureStackTrace(this, UnknownContest)


exports.Error = {
  UnknownUser : UnknownUser
  LoginError  : LoginError
  RegisterError : RegisterError
  InvalidAccess : InvalidAccess
  UpdateError : UpdateError
  UnknownContest : UnknownContest
}

#Const
AC_SCORE = 1
PER_PENALTY = 20 * 60 * 1000

exports.findContest = (user, contestID, include)->
  Contest = global.db.models.contest
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(
      attributes : ['id']
    )
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    adminGroups = (group.id for group in groups when group.membership.access_level in ['owner','admin'])
    Contest.find({
      where :
        $and:
          id : contestID
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

exports.lettersToNumber = (word)->
  res = 0
  for i in word
    res = res * 26 + (i.charCodeAt(0) - 65)
  return res

exports.numberToLetters = (num)->
  return 'A' if num is 0
  res = ""
  while(num>0)
    res = String.fromCharCode(num%26 + 65) + res
    num = parseInt(num/26)
  return res

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

exports.getRank = (contest)->
  myUtils = this
  User = global.db.models.user
  contest.getSubmissions(
    include : [
      model : User
      as : 'creator'
    ]
    order : [
      ['created_at','ASC']
    ]
  )
  .then (submissions)->
    dicProblemIDToOrder = {} #把题目ID变为字母序号
    dicProblemOrderToScore = {} #最后计算得分的时候需要计算这个比赛中这个题目的分数
    for p in contest.problems
      dicProblemIDToOrder[p.id] = myUtils.numberToLetters(p.contest_problem_list.order)
      dicProblemOrderToScore[dicProblemIDToOrder[p.id]] = p.contest_problem_list.score
    tmp = {}
    for sub in submissions
      tmp[sub.creator.id] ?= {}
      tmp[sub.creator.id].user ?= sub.creator
      tmp[sub.creator.id].detail ?= {}
      problemOrderLetter = dicProblemIDToOrder[sub.problem_id]
      detail = tmp[sub.creator.id].detail
      detail[problemOrderLetter] ?= {}
      detail[problemOrderLetter].score ?= 0
      detail[problemOrderLetter].accepted_time ?= new Date()
      detail[problemOrderLetter].wrong_count ?= 0
      if sub.score >= detail[problemOrderLetter].score #应当选出得分最高，时间最早的
        detail[problemOrderLetter].score = sub.score
        detail[problemOrderLetter].result = sub.result
        detail[problemOrderLetter].accepted_time = sub.created_at if sub.created_at < detail[problemOrderLetter].accepted_time
      if detail[problemOrderLetter].score < AC_SCORE #因为保证created_at是正序的，所以这是在按照时间顺序检索，当已经AC过后就不再增加wrong_count
        ++detail[problemOrderLetter].wrong_count
    for user of tmp
      tmp[user].score ?= 0
      tmp[user].penalty ?= 0
      for p of tmp[user].detail
        problem = tmp[user].detail[p]
        problem.score *= dicProblemOrderToScore[p]
        tmp[user].score += problem.score
        if problem.score > 0
          tmp[user].penalty += (problem.accepted_time-contest.start_time) + problem.wrong_count * PER_PENALTY

    res = (tmp[user] for user of tmp)
    res.sort(
      (a,b)->
        if a.score < b.score
          return 1
        if a.score is b.score and a.penalty < b.penalty
          return 1
        if a.score is b.score and a.penalty is b.penalty and a.user.id < b.user.id
          return 1
        return -1
    )

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
