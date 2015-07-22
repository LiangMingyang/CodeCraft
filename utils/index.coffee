#user
path = require('path')
exports.login = (req, res, user) ->
  req.session.user = {
    id: user.id
    nickname: user.nickname
    username: user.username
  }

exports.logout = (req) ->
  delete req.session.user

#group
#找到该用户对应的所有的组
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
#找到对应id的group
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
#找到一组group的人数
exports.getGroupPeopleCount = (groups)->
  groups = [groups] if not groups instanceof Array
  Membership = global.db.models.membership
  options = {
    where:
      group_id : (group.id for group in groups)
    group : 'group_id'
    distinct : true
    attributes : ['group_id']
    plain : false
  }
  Membership.aggregate('user_id', 'count', options)
#可以把getGroupPeopleCount的结果和groups对应起来
exports.addGroupsCountKey = (counts, currentGroups, key)->
  tmp = {}
  for p in counts
    tmp[p.group_id] = p.count
  for p in currentGroups
    p[key] = 0
    p[key] = tmp[p.id] if tmp[p.id]


#problem
#得到对应user的problems,include可以接受group信息
exports.findProblems = (user, offset, include) ->
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups()
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    Problem.findAll({
      where :
        $or:[
          access_level : 'public'    #public的题目谁都可以看
        ,
          access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
          group_id : normalGroups
        ]
      include : include
      offset : offset
      limit : global.config.pageLimit.problem
    })
#找到对应user的problems的信息并且进行计数,include可以接受group等参数
exports.findAndCountProblems = (user, offset, include) ->
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups()
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    Problem.findAndCountAll({
      where :
        $or:[
          access_level : 'public'    #public的题目谁都可以看
        ,
          access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
          group_id : normalGroups
        ]
      include : include
      offset : offset
      limit : global.config.pageLimit.problem
    })
#找到对应id的problem
exports.findProblem = (user, problemID,include)->
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups()
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    Problem.find({
      where :
        $and:
          id : problemID
          $or:[                        #该网站仅能看到public和protect的题目
            access_level : 'public'    #public的题目谁都可以看
          ,
            access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
            group_id : normalGroups
          ]
      include : include
    })
#得到一个题目数组中的某一个状态的计数(people)
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
#得到对于一个题来说这个人过没过
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

#给每个problem添加键
exports.addProblemsCountKey = (counts, currentProblems, key)->
  tmp = {}
  for p in counts
    tmp[p.problem_id] = p.count
  for p in currentProblems
    p[key] = 0
    p[key] = tmp[p.id] if tmp[p.id]
#得到所有的problem的status
exports.getProblemsStatus = (currentProblems,currentUser,currentContest)->
  myUtils = this
  global.db.Promise.all [
    myUtils.getResultPeopleCount(currentProblems, 'AC',currentContest).then (counts)->myUtils.addProblemsCountKey(counts, currentProblems, 'acceptedPeopleCount')
  ,
    myUtils.getResultPeopleCount(currentProblems,undefined,currentContest).then (counts)->myUtils.addProblemsCountKey(counts, currentProblems, 'triedPeopleCount')
  ,
    myUtils.hasResult(currentUser,currentProblems,'AC',currentContest).then (counts)->myUtils.addProblemsCountKey(counts, currentProblems, 'accepted')
  ,
    myUtils.hasResult(currentUser,currentProblems,undefined,currentContest).then (counts)->myUtils.addProblemsCountKey(counts, currentProblems, 'tried')
  ]
#得到题目文件的路径
exports.getStaticProblem = (problemId) ->
  dirname = global.config.problem_resource_path
  path.join dirname, problemId.toString()

#Const

#找到该用户可以看到的所有Contest
exports.findContests = (user, offset, include) ->
  Contest = global.db.models.contest
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(
      attributes : ['id']
    )
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    Contest.findAll({
      where :
        $or:[
          access_level : 'public'    #public的赛事谁都可以看到
        ,
          access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
          group_id : normalGroups
        ]
      include : include
      order : [
        ['start_time','DESC']
      ,
        ['id','DESC']
      ]
      offset : offset
      limit : global.config.pageLimit.contest
    })
#找到所有的contest并计数
exports.findAndCountContests = (user, offset, include) ->
  Contest = global.db.models.contest
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(
      attributes : ['id']
    )
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    Contest.findAndCountAll({
      where :
        $or:[
          access_level : 'public'    #public的题目谁都可以看
        ,
          access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
          group_id : normalGroups
        ]
      include : include
      order : [
        ['start_time','DESC']
      ,
        ['id','DESC']
      ]
      offset : offset
      limit : global.config.pageLimit.contest
    })
#找到对应id的contest
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
    Contest.find({
      where :
        $and:
          id : contestID
          $or:[
            access_level : 'public'    #public的题目谁都可以看
          ,
            access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
            group_id : normalGroups
          ]
      include : include
    })
#把字母转为对应的数字
exports.lettersToNumber = (word)->
  res = 0
  for i in word
    res = res * 26 + (i.charCodeAt(0) - 65)
  return res
#把数字转化为字母(26进制)
exports.numberToLetters = (num)->
  return 'A' if num is 0
  res = ""
  while(num>0)
    res = String.fromCharCode(num%26 + 65) + res
    num = parseInt(num/26)
  return res
#得到rank信息，并进行build
exports.getRank = (contest)->
  myUtils = this
  dicProblemIDToOrder = {} #把题目ID变为字母序号
  dicProblemOrderToScore = {} #最后计算得分的时候需要计算这个比赛中这个题目的分数
  for p in contest.problems
    dicProblemIDToOrder[p.id] = myUtils.numberToLetters(p.contest_problem_list.order)
    dicProblemOrderToScore[dicProblemIDToOrder[p.id]] = p.contest_problem_list.score
  myUtils.buildRank(contest,dicProblemIDToOrder,dicProblemOrderToScore)
  global.redis.get "rank_#{contest.id}"
  .then (cache)->
    rank = []
    rank = JSON.parse(cache) if cache isnt null
    return rank
AC_SCORE = 1
PER_PENALTY = 20 * 60 * 1000
CACHE_TIME = 1000 #间歇性封榜时间
#进行rank的计算，如果被缓存就不计算，通过lock进行间歇性封榜
exports.buildRank = (contest,dicProblemIDToOrder,dicProblemOrderToScore)->
  User = global.db.models.user
  getLock = undefined
  global.redis.set("rank_lock_#{contest.id}", new Date(), "NX", "PX", CACHE_TIME)
  .then (lock)->
    getLock = lock isnt null
    return [] if not getLock
    contest.getSubmissions(
      include : [
        model : User
        as : 'creator'
      ]
      order : [
        ['created_at','ASC']
      ,
        ['id','DESC']
      ]
    )
  .then (submissions)->
    return if not getLock
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
        detail[problemOrderLetter].accepted_time = sub.created_at-contest.start_time if sub.created_at < detail[problemOrderLetter].accepted_time
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
          tmp[user].penalty += problem.accepted_time + problem.wrong_count * PER_PENALTY

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
    global.redis.set("rank_#{contest.id}", JSON.stringify(res))

#Submission
#得到用户可见的所有的Submissions
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
#查找对应ID的submission
exports.findSubmission = (user,submissionID,include)-> #只有自己提交的代码自己才能看
  Submission = global.db.models.submission
#  Contest = global.db.models.contest
#  Problem = global.db.models.problem
#  adminContestIDs = undefined
#  adminProblemIDs = undefined
#  adminGroupIDs = undefined
#  global.db.Promise.resolve()
#  .then ->
#    user.getGroups() if user
#  .then (groups)->
#    return [] if not groups
#    adminGroupIDs = (group.id for group in groups when group.membership.access_level in ['owner','admin'])
#    Contest.findAll(
#      where:
#        group_id : adminGroupIDs
#    )
#  .then (contests)->
#    return [] if not contests
#    adminContestIDs = (contest.id for contest in contests)
#    Problem.findAll(
#      where :
#        group_id : adminGroupIDs
#    )
#  .then (problems)->
#    return undefined if not problems
#    adminProblemIDs = (problem.id for problem in problems)
  Submission.find(
    where :
      id : submissionID
      creator_id : (
        if user
          user.id
        else
          null
      )
    include : include
  )