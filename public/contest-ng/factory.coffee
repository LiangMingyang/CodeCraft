notify = (message, type, delay=-1)->
  $.notify(message,
    animate: {
      enter: 'animated fadeInRight',
      exit: 'animated fadeOutRight'
    }
    type: type
    delay : delay
  )

angular.module('contest-factory', [
])

.factory('Submission', ($http, $timeout)->
  Sub = {}
  Sub.data = []
  #POLL_LIFE = 1000*1000
  SLEEP_TIME = 1000
  UP_TIME = 500
  Sub.setContestId = (newContestId)->
    if newContestId isnt Sub.contestId
      Sub.contestId = newContestId
      Sub.first_time = true
      Sub.data = []

  Poller = ()->
    queue = (sub for sub in Sub.data when sub.result is "WT" or sub.result is "JG")
    if Sub.contestId and (queue.length > 0 or Sub.first_time)
      Sub.first_time = false
      $http.get("/api/contests/#{Sub.contestId}/submissions")
      .then(
        (res)->
          Sub.data = res.data #轮询
          $timeout(Poller, Math.random()*SLEEP_TIME)
      ,
        (res)->
          notify(res.data.error, 'danger')
          $timeout(Poller,Math.random()*SLEEP_TIME)
      )
    else
      $timeout(Poller, UP_TIME)

  $timeout(Poller, Math.random()*UP_TIME)

  Sub.submit = (form)->
    $http.post("/api/contests/#{Sub.contestId}/submissions", form)
    .then(
      (res)->
        form.code = "" #clear
        notify("提交成功", 'success', 3)
        Sub.data.unshift(res.data)
    ,
      (res)->
        notify(res.data.error, 'danger')
    )

  return Sub
)
.factory('Contest', ($http, $timeout)->
  Contest = {}
  POLL_LIFE = 1
  SLEEP_TIME = 100000
  UP_TIME = 500
  Contest.setContestId = (newContestId)->
    if newContestId isnt Contest.id
      Contest.id = newContestId
      Contest.data = {
        title: "Waiting for data..."
        description: "Waiting for data..."
      }
      Contest.order = 0
      Contest.idToOrder = {}
      Contest.active()

  Contest.active = ()->
    Contest.pollLife = POLL_LIFE

  numberToLetters = (num)->
    return 'A' if num is 0
    res = ""
    while(num>0)
      res = String.fromCharCode(num%26 + 65) + res
      num = parseInt(num/26)
    return res

  Poller = ()->
    if Contest.pollLife > 0 and Contest.id
      --Contest.pollLife
      $http.get("/api/contests/#{Contest.id}")
      .then(
        (res)->
          contest = res.data
          contest.problems.sort (a,b)->
            a.contest_problem_list.order-b.contest_problem_list.order
          for p,i in contest.problems
            p.test_setting = JSON.parse(p.test_setting)
            Contest.idToOrder[p.id] = i
            p.order = numberToLetters(i)
          contest.start_time = new Date(contest.start_time)
          contest.end_time = new Date(contest.end_time)
          Contest.data  = contest  #轮询
          $timeout(Poller,Math.random()*SLEEP_TIME)
      ,
        (res)->
          notify(res.data.error, 'danger')
          $timeout(Poller,Math.random()*SLEEP_TIME)
      )
    else
      $timeout(Poller, UP_TIME)

  $timeout(Poller, Math.random()*UP_TIME)

  return Contest
)
.factory('Me', ($http)->
  Me = {}
  Me.data = {}
  Poller = ()->
    $http.get("/api/users/me")
    .then(
      (res)->
        Me.data = res.data
    ,
      (res)->
        notify(res.data.error, 'danger')
    )
  Poller() #instant
  return Me
)
.factory('Issue', ($http, $timeout, Contest)->
  Issue = {}
  POLL_LIFE = 20
  SLEEP_TIME = 2000
  UP_TIME = 500
  Issue.setContestId = (newContestId)->
    if newContestId isnt Issue.contestId
      Issue.data = []
      Issue.contestId = newContestId
      Issue.pollLife = POLL_LIFE
      Issue.replyDic = undefined
      Issue.active()

  Issue.active = ()->
    Issue.pollLife = POLL_LIFE

  checkUpdate = (data)->
    if Issue.replyDic is undefined
      Issue.replyDic = {}
      for i in data
        Issue.replyDic[i.id] = i.issue_replies.length
      return true
    res = false
    for i in data
      if Issue.replyDic[i.id] is undefined
        if i.access_level is 'public'
          #公告
          notify("新的公告[#{i.id}]:#{i.title}:#{i.content}", 'info')
        Issue.replyDic[i.id] = i.issue_replies.length
        res = true
      while i.issue_replies.length > Issue.replyDic[i.id]
        notify("ID为#{i.id}的对#{numberToLetters(Contest.idToOrder[i.problem_id])}的提问有新的回复:#{i.issue_replies[Issue.replyDic[i.id]].content}", 'info')
        ++Issue.replyDic[i.id]
        res = true
      if Issue.replyDic[i.id] isnt i.issue_replies.length
        Issue.replyDic[i.id] = i.issue_replies.length
        res = true
    return res

  numberToLetters = (num)->
    return 'A' if num is 0
    res = ""
    while(num>0)
      res = String.fromCharCode(num%26 + 65) + res
      num = parseInt(num/26)
    return res
  Poller = ()->
    if Issue.pollLife > 0 and Issue.contestId
      --Issue.pollLife
      $http.get("/api/contests/#{Issue.contestId}/issues")
      .then(
        (res)->
          Issue.data = res.data if checkUpdate(res.data) #轮询
          $timeout(Poller, SLEEP_TIME+Math.random()*SLEEP_TIME)
      ,
        ()->
          $timeout(Poller, Math.random()*SLEEP_TIME)
      )
    else
      $timeout(Poller, UP_TIME)
  $timeout(Poller, Math.random()*UP_TIME)

  Issue.create = (form)->
    $http.post("/api/contests/#{Issue.contestId}/issues", form)
    .then(
      (res)->
        form.title = "" # clear
        form.content = "" #clear
        notify("提问成功", 'success', 3)
        Issue.data.unshift(res.data)
    ,
      (res)->
        $.notify(res.data.error, 'danger')
    )

  return Issue
)
.factory('Rank', ($http, $timeout, Me)->
  Rank = {}
  POLL_LIFE = 1
  SLEEP_TIME = 5000
  UP_TIME = 500

  Rank.setContestId = (newContestId)->
    if newContestId isnt Rank.contestId
      Rank.contestId = newContestId
      Rank.data = []
      Rank.statistics = {}
      Rank.version = "Waiting..."
      Rank.pollLife = POLL_LIFE
      Rank.ori = ""
      Rank.active()

  Rank.active = ()->
    Rank.pollLife = POLL_LIFE

  doRankStatistics = (rank)->
    triedPeopleCount = {}
    acceptedPeopleCount = {}
    triedSubCount = {}
    myRank = undefined
    for r,i in rank
      myRank = i+1 if r.user.id is Me.data.id
      for p of r.detail
        acceptedPeopleCount[p] ?= 0
        ++acceptedPeopleCount[p] if r.detail[p].result is 'AC'
        triedPeopleCount[p] ?= 0
        ++triedPeopleCount[p]
        triedSubCount[p] ?= 0
        triedSubCount[p] += r.detail[p].wrong_count + 1
    return {
    triedPeopleCount : triedPeopleCount
    acceptedPeopleCount : acceptedPeopleCount
    triedSubCount : triedSubCount
    myRank : myRank
    }

  Poller = ()->
    if Rank.contestId and Rank.pollLife>0
      --Rank.pollLife
      $http.get("/api/contests/#{Rank.contestId}/rank")
      .then(
        (res)->
          if Rank.ori isnt res.data
            Rank.data = JSON.parse(res.data) #轮询
            Rank.statistics = doRankStatistics(Rank.data)
            Rank.ori = res.data
          Rank.version = new Date()
          $timeout(Poller,Math.random()*SLEEP_TIME+SLEEP_TIME)
      ,
        (res)->
          notify(res.data.error, 'danger')
          $timeout(Poller, Math.random()*SLEEP_TIME)
      )
    else
      $timeout(Poller, UP_TIME)

  $timeout(Poller, Math.random()*UP_TIME)

  return Rank
)
.factory('ServerTime', ($http, $timeout)->
  ST = {}
  ST.data = new Date()
  ST.delta = 0
  countDown = ()->
    now = new Date()
    ST.data = new Date(now.getTime() + ST.delta)
    $timeout(countDown, 1000)

  $http.get("/api/contests/server_time")
  .then(
    (res)->
      now = new Date()
      server_time = new Date(res.data.server_time)
      ST.delta = server_time - now
      countDown()
  ,
    (res)->
      notify(res.data.error, 'danger')
      countDown()
  )
  return ST
)
