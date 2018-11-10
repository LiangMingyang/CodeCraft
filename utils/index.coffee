#user
path = require('path')
crypto = require('crypto')
exports.login = (req, res, user) ->
  req.session.user = {
    id: user.id
    nickname: user.nickname
    username: user.username
  }

exports.tmp = (req, id) ->
  req.session.tmpid = id
  req.session.save()

exports.logout = (req) ->
  delete req.session.user

exports.thirdLogin = (thirdUsername) ->
  User = global.db.models.user
  User.find(
    where:
      username: thirdUsername
  )
  .then (users) ->
    return users

#findIP

exports.getIP = (req) ->
  ip = req.headers['x-real-ip'] or req.headers['x-forwarded-for'] or req.socket.remoteAddress or ''
  if ip.split(',').length > 0
    ip = ip.split(',')[0]
  return ip

#group
#找到该用户对应的所有的组ID
exports.findGroupsID = (user)->
  Membership = global.db.models.membership
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    Membership.findAll(
      where:
        user_id : user.id
        access_level : ['member', 'admin', 'owner']
      attributes: [
        'group_id'
      ]
    )
  .then (memberships)->
    return (membership.group_id for membership in memberships)
#找到该用户对应的所有的组
exports.findGroups = (user, include)->
  Group = global.db.models.group
  myUtils = this
  myUtils.findGroupsID(user)
  .then (normalGroups)->
    Group.findAll
      where:
        $or : [
          $and: [
            access_level : ['protect']
          ,
            id : normalGroups
          ]
        ,
          access_level : ['public']
        ]
      include : include


#找到对应id的group
exports.findGroup = (user, groupID, include)->
  Group = global.db.models.group
  myUtils = this
  myUtils.findGroupsID(user)
  .then (normalGroups)->
    Group.find
      where:
        $and: [
          id : groupID
        ,
          $or : [
            $and: [
              access_level : ['protect']
            ,
              id : normalGroups
            ]
          ,
            access_level : ['public']
          ]
        ]
      include : include


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
exports.findProblemsID = (normalGroups=[])->
  Problem = global.db.models.problem
  Problem.findAll(
    where:
      $or:[
        access_level : 'public'    #public的题目谁都可以看
      ,
        access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
        group_id : normalGroups
      ]
    attributes : [
      'id'
    ]
  ).then (problems)->
    return (problem.id for problem in problems)
#得到对应user的problems,include可以接受group信息
exports.findProblems = (user, include) ->
  Problem = global.db.models.problem
  myUtils = this
  myUtils.findGroupsID(user)
  .then (normalGroups)->
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

#找到对应user的problems的信息并且进行计数,include可以接受group等参数
exports.findAndCountProblems = (user, opt, include) ->
  Problem = global.db.models.problem
  myUtils = this
  myUtils.findGroupsID(user)
  .then (normalGroups)->

    where = {
      $and: [
        $or:[
          access_level : 'public'    #public的题目谁都可以看
        ,
          access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
          group_id : normalGroups
        ]
      ]
    }

    where.$and.push id:opt.problem_id if opt.problem_id
    where.$and.push {
      title:
        like: "%#{opt.problem_title}%"
    } if opt.problem_title
    ((include)->
      include ?= {}
      for model in include
        if model.as is 'creator'
          model.where ?= {}
          model.where.nickname = like: "%#{opt.problem_creator}%"
          return
      include.push {
        model : User
        as : 'creator'
        where :
          nickname :
            like: "%#{opt.problem_creator}%"
      }
    )(include) if opt.problem_creator

    Problem.findAndCountAll({
      where : where
      include : include
      offset : opt.offset
      limit : global.config.pageLimit.problem
      distinct : opt.distinct
    })


#找到对应id的problem
exports.findProblem = (user, problemID,include)->
  Problem = global.db.models.problem
  Membership = global.db.models.membership
  currentProblem = undefined
  global.db.Promise.resolve()
  .then ->
    Problem.find(
      where:
        id : problemID
      include : include
    )
  .then (problem)->
    currentProblem = problem
    return true if not problem
    return true if problem.access_level is 'public'
    return false if not user
    privilege = ['admin', 'owner']
    if problem.access_level is 'protect'
      privilege.push 'member'
    Membership.find(
      where:
        group_id: currentProblem.group_id
        user_id: user.id
        access_level : privilege
    )
  .then (flag)->
    return currentProblem if flag
#得到一个题目数组中的某一个状态的计数(people)
exports.getResultPeopleCount = (problems_id, results, contest)->
  Submission = global.db.models.submission
  options = {
    where:
      problem_id : problems_id
    group : 'problem_id'
    distinct : true
    attributes : ['problem_id']
    plain : false
  }
  options.where.result = results if results
  options.where.contest_id = contest.id if contest
  Submission.aggregate('creator_id', 'count', options)

exports.getResultCount = (problems_id, results, contest)->
  Submission = global.db.models.submission
  options = {
    where:
      problem_id : problems_id
    group : 'problem_id'
    distinct : true
    attributes : ['problem_id']
    plain : false
  }
  options.where.result = results if results
  options.where.contest_id = contest.id if contest
  Submission.aggregate('id', 'count', options)


#得到每个人的过题数并取前十
exports.getRankCount = ()->
  myUtils = this
  myUtils.buildRankCount()
  global.redis.get "rank_G"
  .then (cache) ->
    rank = "[]"
    rank = cache if cache isnt null
    return rank

CACHE_TIMEG = global.config.judge.cache
exports.buildRankCount = ()->
  User = global.db.models.user
  Submission = global.db.models.submission
  getLock = undefined

  global.redis.set("rank_lock_G", new Date(), "NX", "PX", CACHE_TIMEG)
  .then (lock)->
    getLock = lock isnt null
    return [] if not getLock
    Submission.findAll(
      attributes : ['creator_id',[global.db.fn('count', global.db.literal('distinct submission.problem_id')),'COUNT']]
      include: [
        model: User
        attributes:[[global.db.fn('substring', global.db.literal('student_id'),global.db.literal('1'),global.db.literal('4')),'student_id'],'nickname']
        as:'creator'
        where: {
          student_id: {
            $ne: ''
          }
        }
      ]
      where:
        result:'AC'
      group: ['creator_id']
      order: [
        [global.db.fn('count', global.db.literal('distinct submission.problem_id')), 'DESC']
      ]
      limit:10
    )
  .then (results)->
    return if not getLock
    global.redis.set("rank_G", JSON.stringify(results))


#得到每个人的交题解数并取前十
exports.getSolutionCount = ()->
  myUtils = this
  myUtils.buildSolutionCount()
  global.redis.get "rank_S"
  .then (cache) ->
    rank = "[]"
    rank = cache if cache isnt null
    return rank


CACHE_TIMES = global.config.judge.cache
exports.buildSolutionCount = ()->
  User = global.db.models.user
  Submission = global.db.models.submission
  Solution = global.db.models.solution
  getLock = undefined

  global.redis.set("rank_lock_S", new Date(), "NX", "PX", CACHE_TIMES)
  .then (lock)->
    getLock = lock isnt null
    return [] if not getLock
    Submission.findAll(
      attributes: ['creator_id', [global.db.fn('count', global.db.col('solution.id')),'COUNT']]
      include: [{
        model: Solution
        attributes: []
      },
        {
          model: User
          attributes:[[global.db.fn('substring', global.db.literal('student_id'),global.db.literal('1'),global.db.literal('4')),'student_id'],'nickname']
          as:'creator'
          where: {
            student_id:
              global.db.literal('student_id REGEXP "[0-9]{8}|[A-Z]{2}[0-9]{7}"')

            $and:
              global.db.literal('nickname REGEXP "[u0391-uFFE5]" is not true')
          }
        }
      ]
      group: ['creator_id']
      limit: 10
      order: [
        [global.db.fn('count', global.db.col('solution.id')), 'DESC']
      ]
    )
  .then (resultsS)->
    return if not getLock
    global.redis.set("rank_S", JSON.stringify(resultsS))


#得到每个人最近一个月的过题数并取前十
exports.getRankCountR = ()->
  myUtils = this
  myUtils.buildRankCountR()
  global.redis.get "rank_R"
  .then (cache) ->
    rank = "[]"
    rank = cache if cache isnt null
    return rank

CACHE_TIMER = global.config.judge.cache
exports.buildRankCountR = ()->
  User = global.db.models.user
  Submission = global.db.models.submission
  getLock = undefined

  global.redis.set("rank_lock_R", new Date(), "NX", "PX", CACHE_TIMER)
  .then (lock)->
    getLock = lock isnt null
    return [] if not getLock
    Submission.findAll(
      attributes : ['creator_id',[global.db.fn('count', global.db.literal('distinct submission.problem_id')),'COUNT']]
      include: [
        model: User
        attributes:[[global.db.fn('substring', global.db.literal('student_id'),global.db.literal('1'),global.db.literal('4')),'student_id'],'nickname']
        as:'creator'
        where: {
          student_id: {
            $ne: ''
          }
        }
      ]
      where:
        result:'AC',
        updated_at:{
          $gte:global.db.fn('DATE_SUB',global.db.literal('NOW()'),global.db.literal('INTERVAL 1 MONTH'))
        }
      group: ['creator_id']
      order: [
        [global.db.fn('count', global.db.literal('distinct submission.problem_id')), 'DESC']
      ]
      limit:10
    )
  .then (resultsR)->
    return if not getLock
    global.redis.set("rank_R", JSON.stringify(resultsR))


#得到每个人最近一个月的题解数并取前十
exports.getSolutionCountR = ()->
  myUtils = this
  myUtils.buildSolutionCountR()
  global.redis.get "rank_SR"
  .then (cache) ->
    rank = "[]"
    rank = cache if cache isnt null
    return rank

CACHE_TIMESR = global.config.judge.cache
exports.buildSolutionCountR = ()->
  User = global.db.models.user
  Submission = global.db.models.submission
  Solution = global.db.models.solution
  getLock = undefined

  global.redis.set("rank_lock_SR", new Date(), "NX", "PX", CACHE_TIMESR)
  .then (lock)->
    getLock = lock isnt null
    return [] if not getLock
    Submission.findAll(
      attributes: ['creator_id', [global.db.fn('count', global.db.col('solution.id')),'COUNT']]
      include: [{
        model: Solution
        attributes: []
      },
        {
          model: User
          attributes:[[global.db.fn('substring', global.db.literal('student_id'),global.db.literal('1'),global.db.literal('4')),'student_id'],'nickname']
          as:'creator'
          where: {
            student_id:
              global.db.literal('student_id REGEXP "[0-9]{8}|[A-Z]{2}[0-9]{7}"')

            $and:
              global.db.literal('nickname REGEXP "[u0391-uFFE5]" is not true')

          }
        }
      ]
      where:
        created_at:{
          $gte:global.db.fn('DATE_SUB',global.db.literal('NOW()'),global.db.literal('INTERVAL 1 MONTH'))
        }
      group: ['creator_id']
      limit: 10
      order: [
        [global.db.fn('count', global.db.col('solution.id')), 'DESC']
      ]
    )
  .then (resultsSR)->
    return if not getLock
    global.redis.set("rank_SR", JSON.stringify(resultsSR))

#更新排行榜榜單
exports.ChampionRank =() ->
  Submission = global.db.models.submission
  User = global.db.models.user
  Submission.findAll(
    attributes : ['creator_id',[global.db.fn('count', global.db.literal('distinct submission.problem_id')),'COUNT']]
    include: [
      model: User
      attributes:['student_id','nickname']
      as:'creator'
      where: {
        student_id:
          global.db.literal('student_id REGEXP "[0-9]{8}|[A-Z]{2}[0-9]{7}"')

        $and:
          global.db.literal('nickname REGEXP "[u0391-uFFE5]" is not true')
      }
    ]
    where:
      updated_at: {
        $between: ['2018-10-01 00:00:00', '2018-11-01 00:00:00']
      }

    group: [global.db.literal('creator_id')],
    order: [
      [global.db.fn('count', global.db.literal('distinct submission.problem_id')), 'DESC']
    ]
    limit:3
  )
#得到每个人的过题数并取前十

exports.ShishiRankCount = ()->
  User = global.db.models.user
  Submission = global.db.models.submission
  Submission.findAll(
    attributes : ['creator_id',[global.db.fn('count', global.db.literal('distinct submission.problem_id')),'COUNT']]
    include: [
      model: User
      attributes:['student_id','nickname']
      as:'creator'
      where: {
        student_id: {
          $ne: ''
        }
      }
    ]
    where:{
      result:'AC',
      #$and:
       # created_at:{
        #  $lte: '2017-12-18 00:00:00'
        #}
    }
    group: ['creator_id']
    order: [
      [global.db.fn('count', global.db.literal('distinct submission.problem_id')), 'DESC']
    ]
    limit:10
  )


exports.ShishiSolutionCount = ()->
  User = global.db.models.user
  Submission = global.db.models.submission
  Solution = global.db.models.solution

  Submission.findAll(
    attributes: ['creator_id', [global.db.fn('count', global.db.col('solution.id')),'COUNT']]
    include: [{
      model: Solution
      attributes: []
    },
      {
        model: User
        attributes:['student_id','nickname']
        as:'creator'
        where: {
          student_id:
            global.db.literal('student_id REGEXP "[0-9]{8}|[A-Z]{2}[0-9]{7}"')

          $and:
            global.db.literal('nickname REGEXP "[u0391-uFFE5]" is not true')
        }
      }
    ]

    where:
      created_at:{
        $lte: '2017-12-18 00:00:00'
      }
    group: ['creator_id']
    limit: 10
    order: [
      [global.db.fn('count', global.db.col('solution.id')), 'DESC']
    ]
  )





#查询系统中共多少有student_id的用户
exports.AllPeople =()->
  User = global.db.models.user
  User.findAll(
    attributes : [[global.db.fn('count', global.db.literal('distinct user.id')),'PCOUNT']]
    where:{
      student_id:{
        $ne: ''
      }
    }
  )

#查询一个已经user.id的用户所有过题数
exports.UserAccpectedProblem = (userid)->
  myUtils = this
  myUtils.buildUserAccpectedProblem(userid)
  global.redis.get "rank_T#{userid}"
  .then (cache) ->
    rank = "[]"
    rank = cache if cache isnt null
    return rank

CACHE_TIMET = global.config.judge.cache
exports.buildUserAccpectedProblem = (userid)->
  Problem = global.db.models.problem
  Submission = global.db.models.submission
  Solution = global.db.models.solution
  getLock = undefined

  global.redis.set("rank_lock_T#{userid}", new Date(), "NX", "PX", CACHE_TIMET)
  .then (lock)->
    getLock = lock isnt null
    return [] if not getLock
    Problem.findAll(
      attributes :['id','title']
      include: [{
        model: Submission
        attributes:['id']
        where: {
          result: 'AC',
          creator_id: userid,
        }
        include:[{
          model: Solution
        }]
      }]
      order:[['id','DESC']]
      limit:7

    )
  .then (results)->
    return if not getLock
    global.redis.set("rank_T#{userid}", JSON.stringify(results))

#得到对于一个题来说这个人过没过
exports.hasResult = (user, problems_id, results, contest)->
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    Submission = global.db.models.submission
    options = {
      where:
        problem_id : problems_id
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
  currentProblems = [currentProblems] if not (currentProblems instanceof Array)
  problems_id = (problem.id for problem in currentProblems)
  global.db.Promise.all [
    myUtils.getResultPeopleCount(problems_id, 'AC',currentContest).then (counts)->myUtils.addProblemsCountKey(counts, currentProblems, 'acceptedPeopleCount')
  ,
    myUtils.getResultPeopleCount(problems_id,undefined,currentContest).then (counts)->myUtils.addProblemsCountKey(counts, currentProblems, 'triedPeopleCount')
  ,
    myUtils.hasResult(currentUser,problems_id,'AC',currentContest).then (counts)->myUtils.addProblemsCountKey(counts, currentProblems, 'accepted')
  ,
    myUtils.hasResult(currentUser,problems_id,undefined,currentContest).then (counts)->myUtils.addProblemsCountKey(counts, currentProblems, 'tried')
  ,
    myUtils.getResultCount(problems_id,undefined,currentContest).then (counts)->myUtils.addProblemsCountKey(counts, currentProblems, 'submissionCount')
  ]
#得到题目文件的路径
exports.getStaticProblem = (problemId) ->
  dirname = global.config.problem_resource_path
  path.join dirname, problemId.toString()

#Const

exports.findContestsID = (normalGroups=[])->
  Contest = global.db.models.contest
  Contest.findAll(
    where :
      $or:[
        access_level : 'public'    #public的赛事谁都可以看到
      ,
        access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
        group_id : normalGroups
      ]
    attributes : [
      'id'
    ]
  ).then (contests)->
    return (contest.id for contest in contests)

#找到该用户可以看到的所有Contest
exports.findContests = (user, include) ->
  Contest = global.db.models.contest
  myUtils = this
  myUtils.findGroupsID(user)
  .then (normalGroups)->
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

#找到所有的contest并计数
exports.findAndCountContests = (user, offset, include) ->
  Contest = global.db.models.contest
  myUtils = this
  myUtils.findGroupsID(user)
  .then (normalGroups)->
    Contest.findAndCountAll({
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


#找到对应id的contest
exports.findContest = (user, contestID, include)->
  Contest = global.db.models.contest
  Membership = global.db.models.membership
  currentContest = undefined
  global.db.Promise.resolve()
  .then ->
    Contest.find(
      where:
        id : contestID
      include : include
    )
  .then (contest)->
    currentContest = contest
    return true if not contest
    return true if contest.access_level is 'public'
    return false if not user
    Membership.find(
      where:
        group_id: contest.group_id
        user_id: user.id
        access_level : ['member', 'admin', 'owner']
    )
  .then (flag)->
    return currentContest if flag

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
  for p,i in contest.problems
    dicProblemIDToOrder[p.id] = myUtils.numberToLetters(i)
    dicProblemOrderToScore[dicProblemIDToOrder[p.id]] = p.contest_problem_list.score
  myUtils.buildRank(contest,dicProblemIDToOrder,dicProblemOrderToScore)
  global.redis.get "rank_#{contest.id}"
  .then (cache)->
    rank = "[]"
    rank = cache if cache isnt null
    return rank

PER_PENALTY = global.config.judge.penalty
CACHE_TIME = global.config.judge.cache
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
        attributes : [
          'id'
        ,
          'nickname'
        ,
          'student_id'
        ,
          'school'
        ]
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
    firstB = {}
    for sub in submissions
      tmp[sub.creator.id] ?= {}
      tmp[sub.creator.id].user ?= sub.creator
      tmp[sub.creator.id].detail ?= {}
      problemOrderLetter = dicProblemIDToOrder[sub.problem_id]
      continue if problemOrderLetter is undefined
      detail = tmp[sub.creator.id].detail
      detail[problemOrderLetter] ?= {}
      detail[problemOrderLetter].score ?= 0
      #detail[problemOrderLetter].accepted_time ?= new Date()
      detail[problemOrderLetter].wrong_count ?= 0

      if sub.result is 'AC'
        firstB[problemOrderLetter] ?= sub.created_at-contest.start_time
        firstB[problemOrderLetter] = sub.created_at-contest.start_time if sub.created_at-contest.start_time < firstB[problemOrderLetter]

      if sub.score > detail[problemOrderLetter].score #应当选出得分最高，时间最早的
        detail[problemOrderLetter].score = sub.score
        detail[problemOrderLetter].result = sub.result if detail[problemOrderLetter].result isnt 'AC'
        detail[problemOrderLetter].accepted_time = sub.created_at-contest.start_time
      if detail[problemOrderLetter].result isnt 'AC' and sub.result isnt 'CE' #因为保证created_at是正序的，所以这是在按照时间顺序检索，当已经AC过后就不再增加wrong_count
        ++detail[problemOrderLetter].wrong_count

    for user of tmp
      tmp[user].score ?= 0
      tmp[user].penalty ?= 0
      for p of tmp[user].detail
        problem = tmp[user].detail[p]
        problem.score *= dicProblemOrderToScore[p]
        tmp[user].score += problem.score
        if problem.result is 'AC' and problem.accepted_time is firstB[p]
          problem.first_blood = true
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
  throw new global.myErrors.UnknownProblem("Your code is too long.") if form_code.content.length > global.config.judge.max_code_length
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
  normalGroups = undefined
  normalProblems = undefined
  myUtils = this
  global.db.Promise.resolve()
  .then ->
    myUtils.findGroupsID(user)
  .then (groups)->
    normalGroups = groups
    myUtils.findProblemsID(normalGroups)
  .then (problems)->
    normalProblems = problems
    myUtils.findContestsID(normalGroups)
  .then (normalContests)->
    where = $and:[
      $or : [
        problem_id : normalProblems
      ,
        contest_id : normalContests
      ]
    ]

    if opt.problem_id isnt undefined
      where.$and.push problem_id:opt.problem_id
    if opt.contest_id isnt undefined
      where.$and.push contest_id:opt.contest_id
      if opt.contest_id isnt null
        if user
          where.$and.push creator_id: user.id
        else
          where.$and.push creator_id: null
    if opt.language isnt undefined
      where.$and.push lang:opt.language
    if opt.result isnt undefined
      where.$and.push result:opt.result
    if opt.creator_id isnt undefined
      where.$and.push creator_id: opt.creator_id

    if opt.nickname isnt undefined
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

exports.findSubmissionsInIDs = (user, submission_id, include)-> #所有有管理能力的提交记录
  Submission = global.db.models.submission
  normalGroups = undefined
  normalProblems = undefined
  myUtils = this
  global.db.Promise.resolve()
  .then ->
    myUtils.findGroupsID(user)
  .then (groups)->
    normalGroups = groups
    myUtils.findProblemsID(normalGroups)
  .then (problems)->
    normalProblems = problems
    myUtils.findContestsID(normalGroups)
  .then (normalContests)->
    Submission.findAll(
      where:
        id : submission_id
        $or : [
          problem_id : normalProblems
        ,
          contest_id : normalContests
        ]
      include: include
    )
  .then (submissions)->
    return (sub.get({plain:true}) for sub in submissions)

#Issue

exports.findIssues = (user, contestID, include)->
  Issue = global.db.models.issue
  global.db.Promise.resolve()
  .then ->
    Issue.findAll(
      where:
        contest_id : contestID
        $or: [
          access_level: 'public'
        ,
          $and: [
            access_level: 'protect'
            creator_id : (if user
                          user.id
                       else
                          null
                      )
          ]
        ]
      order : [
        ['created_at','DESC']
      ,
        ['id','DESC']
      ]
      include: include
    )

exports.findRecommendations = (user)->
  User = global.db.models.user
  global.db.Promise.resolve()
  .then ->
    User.find(user.id) if user
  .then (user)->
    user.getProblems()
  .then (problems)->


#get
#获得某一题目下所有的标签及其权重
exports.findAllProblem_tag = (problems_id)->
  Problem_tag = global.db.models.problem_tag
  Tag = global.db.models.tag
  #console.log problems_id
  Problem = global.db.models.problem
  Problem.find(
    where :
      id : problems_id
    include:[
      model:Tag
    ]
  )
  .then (problem)->
    return problem.tags

#post
#查找tag中是否存在某一标签
exports.findTag = (contents)->
  Tag = global.db.models.tag
  #console.log contents
  Tag.find(
    where:{
      content : contents
    }
  )

#查找problem_tag中是否某一题目已经含有已知标签
exports.findProblem_tag = (problems_id, contents)->
  Problem_tag = global.db.models.problem_tag
  Tag = global.db.models.tag
  Problem = global.db.models.problem
  #console.log contents
  Problem.find(
    where:
      id : problems_id
    include:[
      model:Tag,
      where:
        content : contents
    ]
  )

#在tag中创建新的标签
exports.createTag = (contents) ->
  Tag = global.db.models.tag
  current_tags = undefined
  global.db.transaction (t) ->
    Tag.create(
        content : contents, transaction: t
    )
    .then (tags) ->
      current_tags = tags
  .then ->
    return current_tags

#在problem_tag中添加给某一题目添加某标签及权重
exports.createProblem_tag = (contents,problems_id,weights) ->
  Problem_tag = global.db.models.problem_tag
  current_problems_tag = undefined
  global.db.transaction (t)->
    global.myUtils.findTag(contents)
    .then (tags) ->
      Problem_tag.create(
        tag_id : tags.id
        problem_id : problems_id
        weight : weights, transaction: t
      )
      .then (problems_tag) ->
        current_problems_tag = problems_tag
  .then ->
    return current_problems_tag


exports.createProblem_tagS =(content,problem_id,weight) ->
  Problem_tag = global.db.models.problem_tag
  current_problems_tag = undefined
  global.db.transaction (t)->
    global.myUtils.findProblem_tag(problem_id,content)
    .then (ifExit) ->
      if !ifExit
        global.myUtils.findTag(content)
        .then (iftags) ->
          if !iftags
            global.myUtils.createTag(content)
            global.myUtils.findTag(content)
            .then (tags) ->
              Problem_tag.create(
                tag_id : tags.id
                problem_id : problem_id
                weight : weight, transaction: t
              )
              .then (problems_tag) ->
                current_problems_tag = problems_tag

          else
            global.myUtils.findTag(content)
            .then (tags) ->
              Problem_tag.create(
                tag_id : tags.id
                problem_id : problem_id
                weight : weight, transaction: t
              )
              .then (problems_tag) ->
                current_problems_tag = problems_tag
      else
        global.myUtils.findTag(content)
        .then (tags) ->
          Problem_tag.find(
            where:
              tag_id : tags.id
              problem_id : problem_id
          )
          .then (problems_tag) ->
            problems_tag.weight = weight
            problems_tag.save()
          .then (problems_tag) ->
            current_problems_tag = problems_tag
  .then ->
    return current_problems_tag








#题解Solution
#在solution_tag中添加给某一题解添加某标签及权重
exports.createSolution_tag =(content,solution_id,weight) ->
  Solution_tag = global.db.models.solution_tag
  current_solutions_tag = undefined
  global.db.transaction (t)->
    global.myUtils.findSolution_tag(solution_id,content)
    .then (ifExit) ->
      if !ifExit
        global.myUtils.findTag(content)
        .then (tags) ->
          Solution_tag.create(
            tag_id : tags.id
            solution_id : solution_id
            weight : weight, transaction: t
          )
          .then (solutions_tag) ->
            current_solutions_tag = solutions_tag
      else
        global.myUtils.findTag(content)
        .then (tags) ->
          Solution_tag.find(
            where:
              tag_id : tags.id
              solution_id : solution_id
          )
          .then (solutions_tag) ->
            solutions_tag.weight = weight
            solutions_tag.save()
          .then (solutions_tag) ->
            current_solutions_tag = solutions_tag
  .then ->
    return current_solutions_tag

#查找solution_tag中某一题解是否已经含有已知标签
exports.findSolution_tag = (solution_id, content)->
  Solution_tag = global.db.models.solution_tag
  Tag = global.db.models.tag
  Solution = global.db.models.solution
  #console.log contents
  Solution.find(
    where:
      id : solution_id
    include:[
      model:Tag,
      where:
        content : content
    ]
  )

#获得某一题解下所有的标签及其权重
exports.findAllSolution_tag = (solution_id)->
  Solution_tag = global.db.models.solution_tag
  Tag = global.db.models.tag
  #console.log problems_id
  Solution = global.db.models.solution
  Solution.find(
    where :
      id : solution_id
    include:[
      model:Tag
    ]
  )
  .then (solution)->
    return solution.tags

#获得某题的所有题解打的tag
exports.findProblem_SolutionTags = (problem_id)->
  Problem = global.db.models.problem
  Submission = global.db.models.submission
  Solution = global.db.models.solution
  SolutionTag = global.db.models.solution_tag
  Tag = global.db.models.tag

  Tag.find(
    attributes: ['id'],
    include:[{
      model: Solution
      include:[{
        model: Submission
        where:
          id: global.db.literal('Solution.submission_id')
          problem_id: problem_id
      }]
    }]
    group: ['id']
  )
  .then (tag)->
    return tag


exports.createSolution_tagS =(content,solution_id,weight) ->
  Solution_tag = global.db.models.solution_tag
  current_solutions_tag = undefined
  global.db.transaction (t)->
    global.myUtils.findSolution_tag(solution_id,content)
    .then (ifExit) ->
      if !ifExit
        global.myUtils.findTag(content)
        .then (iftags) ->
          if !iftags
            global.myUtils.createTag(content)
            global.myUtils.findTag(content)
            .then (tags) ->
              Solution_tag.create(
                tag_id : tags.id
                solution_id : solution_id
                weight : weight, transaction: t
              )
              .then (solutions_tag) ->
                current_solutions_tag = solutions_tag

          else
            global.myUtils.findTag(content)
            .then (tags) ->
              Solution_tag.create(
                tag_id : tags.id
                solution_id : solution_id
                weight : weight, transaction: t
              )
              .then (solutions_tag) ->
                current_solutions_tag = solutions_tag
      else
        global.myUtils.findTag(content)
        .then (tags) ->
          Solution_tag.find(
            where:
              tag_id : tags.id
              solution_id : solution_id
          )
          .then (solutions_tag) ->
            solutions_tag.weight = weight
            solutions_tag.save()
          .then (solutions_tag) ->
            current_solutions_tag = solutions_tag
  .then ->
    return current_solutions_tag

  
