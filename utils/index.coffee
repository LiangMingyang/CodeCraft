#user
path = require('path')
crypto = require('crypto')
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

exports.findGroupsAdmin = (user, include)->
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(
      through:
        where:
          access_level : ['admin', 'owner', 'member']
      include: include
    )

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

exports.findGroupAdmin = (user, groupID, include)->
  currentUser = undefined
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    currentUser = user
    user.getGroups({
      where:
        id : groupID
      through:
        where:
          access_level : ['admin', 'owner'] #仅显示以上权限的成员
      include : include
    })
  .then (groups)->
    return groups[0]
#找到一组group的人数
exports.getGroupPeopleCount = (groups)->
  groups = [groups] if not (groups instanceof Array)
  Membership = global.db.models.membership
  options = {
    where:
      group_id : (group.id for group in groups)
      access_level: ['member', 'admin', 'owner']
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
exports.findProblems = (user, include) ->
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(attributes : ['id'])
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
    })
exports.findProblemsAdmin = (user, include) ->
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(attributes : ['id'])
  .then (groups)->
    return [] if not user
    adminGroups = (group.id for group in groups when group.membership.access_level in ['admin','owner'])
    Problem.findAll({
      where :
        $or:[
          creator_id : user.id    #为题目创建者
        ,
          group_id : adminGroups  #为该小组管理员
        ]
      include : include
    })
#找到对应user的problems的信息并且进行计数,include可以接受group等参数
exports.findAndCountProblems = (user, offset, include) ->
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(attributes : ['id'])
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

exports.findAndCountProblemsAdmin = (user, offset, include) ->
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(attributes : ['id'])
  .then (groups)->
    return {
    count: 0
    rows : []
    } if not user
    adminGroups = (group.id for group in groups when group.membership.access_level in ['admin','owner'])
    Problem.findAndCountAll({
      where :
        $or:[
          creator_id : user.id    #为题目创建者
        ,
          group_id : adminGroups  #为该小组管理员
        ]
      include : include
      offset : offset
      limit : global.config.pageLimit.problem
    })
#找到对应id的problem
exports.findProblemAdmin = (user, problemID,include)->
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(attributes : ['id'])
  .then (groups)->
    return undefined if not user
    adminGroups = (group.id for group in groups when group.membership.access_level in ['admin','owner'])
    Problem.find({
      where :
        $and:[
          id : problemID
        ,
          $or:[
            creator_id : user.id    #为题目创建者
          ,
            group_id : adminGroups  #为该小组管理员
          ]
        ]
      include : include
    })

exports.findProblem = (user, problemID,include)->
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(attributes : ['id'])
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    Problem.find({
      where :
        $and:[
          id : problemID
        ,
          $or:[                        #该网站仅能看到public和protect的题目
            access_level : 'public'    #public的题目谁都可以看
          ,
            access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
            group_id : normalGroups
          ]
        ]
      include : include
    })
#得到一个题目数组中的某一个状态的计数(people)
exports.getResultPeopleCount = (problems, results, contest)->
  problems = [problems] if not (problems instanceof Array)
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
    problems = [problems] if not (problems instanceof Array)
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
exports.findContests = (user, include) ->
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
    })

exports.findContestsAdmin = (user, include) ->
  Contest = global.db.models.contest
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(
      attributes : ['id']
    )
  .then (groups)->
    return [] if not user
    adminGroups = (group.id for group in groups when group.membership.access_level in ['owner','admin'])
    Contest.findAll(
      where :
        $or: [
          group_id : adminGroups
        ,
          creator_id : user.id
        ]
      include : include
      order : [
        ['start_time','DESC']
      ,
        ['id','DESC']
      ]
    )
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
          access_level : 'public'    #public的赛事谁都可以看
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

exports.findAndCountContestsAdmin = (user, offset, include) ->
  Contest = global.db.models.contest
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(
      attributes : ['id']
    )
  .then (groups)->
    return {
    count: 0
    rows : []
    } if not user
    adminGroups = (group.id for group in groups when group.membership.access_level in ['admin','owner'])
    Contest.findAndCountAll({
      where :
        $or:[
          group_id : adminGroups
        ,
          creator_id : user.id
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
        $and:[
          id : contestID
        ,
          $or:[
            access_level : 'public'    #public的题目谁都可以看
          ,
            access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
            group_id : normalGroups
          ]
        ]
      include : include
    })

exports.findContestAdmin = (user, contestID, include)->
  Contest = global.db.models.contest
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(
      attributes : ['id']
    )
  .then (groups)->
    return undefined if not user
    adminGroups = (group.id for group in groups when group.membership.access_level in ['admin', 'owner'])
    Contest.find({
      where :
        $and:[
          id : contestID
        ,
          $or:[
            group_id : adminGroups
          ,
            creator_id : user.id
          ]
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
      if sub.score > detail[problemOrderLetter].score #应当选出得分最高，时间最早的
        detail[problemOrderLetter].score = sub.score
        detail[problemOrderLetter].result = sub.result if detail[problemOrderLetter].result isnt 'AC'
        detail[problemOrderLetter].accepted_time = sub.created_at-contest.start_time
      if detail[problemOrderLetter].result isnt 'AC' #因为保证created_at是正序的，所以这是在按照时间顺序检索，当已经AC过后就不再增加wrong_count
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
        if a.score is b.score and a.penalty > b.penalty
          return 1
        if a.score is b.score and a.penalty is b.penalty and a.user.id > b.user.id
          return 1
        return -1
    )
    global.redis.set("rank_#{contest.id}", JSON.stringify(res))

#Submission
#创建Submission
exports.createSubmissionTransaction = (form, form_code, problem, user)->
  Submission = global.db.models.submission
  Submission_Code = global.db.models.submission_code
  current_submission = undefined
  global.db.transaction (t)->
    Submission.create(form, transaction: t)
    .then (submission)->
      current_submission = submission
      Submission_Code.create(form_code, transaction : t)
    .then (code)->
      global.db.Promise.all [
        current_submission.setSubmission_code(code, transaction : t)
      ,
        user.addSubmission(current_submission, transaction : t)
      ,
        problem.addSubmission(current_submission, transaction : t)
      ]
  .then ->
    return current_submission

#得到用户可见的所有的Submissions
exports.findSubmissions = (user, opt, include)->
  Submission = global.db.models.submission
  currentProblems = undefined
  currentContests = undefined
  normalProblems = undefined
  myUtils = this
  global.db.Promise.resolve()
  .then ->
    myUtils.findProblems(user)
  .then (problems)->
    currentProblems = problems
    #return [] if not problems
    myUtils.findContests(user)
  .then (contests)->
    currentContests = contests
    return [] if not currentProblems
    return [] if not currentContests

    normalProblems = (problem.id for problem in currentProblems)
    normalContests = (contest.id for contest in currentContests)

    where = $and:[
      $or : [
        problem_id : normalProblems
      ,
        contest_id : normalContests
      ]
    ]

    if opt.problem_id
      where.$and.push problem_id:opt.problem_id
    if opt.contest_id
      where.$and.push contest_id:opt.contest_id
      if user
        where.$and.push creator_id: user.id
      else
        where.$and.push creator_id: null
    if opt.language
      where.$and.push lang:opt.language
    if opt.result
      where.$and.push result:opt.result

    if opt.nickname
      ((include)->
        include ?= {}
        for model in include
          if model.as is 'creator'
            model.where ?= {}
            model.where.nickname = opt.nickname
            return
        include.push {
          model : User
          as : 'creator'
          where :
            nickname : opt.nickname
        }
      )(include)

    opt.offset ?= 0



    Submission.findAll(
      where : where
      include : include
      order : [
        ['created_at', 'DESC']
      ,
        ['id','DESC']
      ]
      offset : opt.offset
      limit : global.config.pageLimit.submission
    )

#查找对应ID的submission
exports.findSubmission = (user,submissionID,include)-> #只有自己提交的代码自己才能看
  Submission = global.db.models.submission
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
