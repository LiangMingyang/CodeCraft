'use strict'

# Declare app level module which depends on views, and components

angular.module('contest', [
  'ngRoute'
]).
config( ($routeProvider)->
  $routeProvider
  .when('/:contestId', {
      templateUrl: 'detail/contest-detail.html',
      controller: 'contest.ctrl'
    })
  .when('/:contestId/problems', {
      templateUrl: 'detail/detail-problem.html',
      controller: 'contest.ctrl'
    })
  .when('/:contestId/rank', {
      templateUrl: 'detail/detail-rank.html',
      controller: 'contest.ctrl'
    })
  .when('/:contestId/submissions', {
      templateUrl: 'detail/detail-submission.html',
      controller: 'contest.ctrl'
    })
  .when('/:contestId/issues', {
      templateUrl: 'detail/detail-issues.html',
      controller: 'contest.ctrl'
    })
  .otherwise({
      redirectTo: '/10'
    })
)
.filter('marked', ['$sce', ($sce)->
  (text)->
    text = "" if not text
    $sce.trustAsHtml(markdown.toHTML(text))
])

.filter('penalty', [()->
  (date)->
    return "" if not date
    penalty = new Date(date)
    peanlty = penalty.getTime()
    seconds = (peanlty - peanlty%1000)/1000
    minutes = (seconds - seconds%60)/60
    hours = (minutes - minutes%60)/60
    minutes %= 60
    minutes = '0'+minutes if minutes < 10
    seconds %= 60
    seconds = '0'+seconds if seconds < 10
    return "#{hours}:#{minutes}:#{seconds}"
])

.filter('wrongCount', [()->
  (wrong_count)->
    return "" if not wrong_count or wrong_count is 0
    return "(+#{wrong_count})"
])

.filter('result', [()->
  (result)->
    dic = {
      AC : "Accepted",
      WA : "Wrong Answer",
      CE : "Compile Error",
      RE : "Runtime Error",
      REG : "Runtime Error (SIGSEGV)",
      REP : "Runtime Error (SIGFPE)",
      WT : "Waiting",
      JG : "Running",
      TLE : "Time Limit Exceed",
      MLE : "Memory Limit Exceed",
      PE : "Presentation Error",
      ERR : "Judge Error",
      IFNR : "Input File Not Ready",
      OFNR : "Output File Not Ready",
      EFNR : "Error File Not Ready",
      OE : "Other Error"
    }
    return dic[result] || "Other Error"
])

.factory('Submission', ($routeParams, $http, $timeout)->
  Sub = {}
  Sub.setContestId = (newContestId)->
    if newContestId isnt Sub.contestId
      Sub.contestId = newContestId
      Sub.data = []
      $http.get("/api/contests/#{Sub.contestId}/submissions")
      .then(
        (res)->
          Sub.data = res.data #轮询
      )
  Sub.setContestId($routeParams.contestId || 1)

  Poller = ()->
    queue = (sub for sub in Sub.data when sub.result is "WT" or sub.result is "JG")
    if queue.length > 0
      $http.get("/api/contests/#{Sub.contestId}/submissions")
      .then(
        (res)->
          Sub.data = res.data #轮询
          $timeout(Poller, 1000 + Math.random()*1000)
      ,
        ()->
          $timeout(Poller,Math.random()*5000)
      )
    else
      $timeout(Poller,Math.random()*1000)
  Poller()

  Sub.submit = (form)->
    $http.post("/api/contests/#{Sub.contestId}/submissions", form)
    .then(
      (res)->
        form.code = "" #clear
        $.notify("提交成功",
          animate: {
            enter: 'animated fadeInRight',
            exit: 'animated fadeOutRight'
          }
          type: 'success'
        )
        Sub.data.unshift(res.data)
    ,
      (res)->
        $.notify(res.data.error,
          animate: {
            enter: 'animated fadeInRight',
            exit: 'animated fadeOutRight'
          }
          type: 'danger'
        )
    )

  return Sub
)
.factory('Contest', ($routeParams, $http, $timeout)->
  Contest = {}
  Contest.id = $routeParams.contestId || 1
  Contest.order = 0
  Contest.idToOrder = {}
  Contest.pollLife = 3
  Contest.data = {
    title: "Waiting for data..."
    description: "Waiting for data..."
  }
  Contest.setContestId = (newContestId)->
    if newContestId isnt Contest.id
      Contest.id = newContestId
      Contest.data = {
        title: "Waiting for data..."
        description: "Waiting for data..."
      }
      Contest.order = 0
      Poller()
  Contest.active = ()->
    Contest.pollLife = 3
  Poller = ()->
    if Contest.pollLife > 0 or not Contest.data.problems or Contest.data.problems.length is 0
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
          contest.start_time = new Date(contest.start_time)
          contest.end_time = new Date(contest.end_time)
          Contest.data  = contest  #轮询
          $timeout(Poller,Math.random()*100000)
      ,
        (res)->
          $.notify(res.data.error,
            animate: {
              enter: 'animated fadeInRight',
              exit: 'animated fadeOutRight'
            }
            type: 'danger'
          )
          $timeout(Poller,Math.random()*10000)
      )
    else
      $timeout(Poller,1000+Math.random()*1000)
  Poller()
  return Contest
)
.factory('Me', ($http, $timeout)->
  Me = {}
  Me.data = {}
  Poller = ()->
    $http.get("/api/users/me")
    .then(
      (res)->
        Me.data = res.data
        #$timeout(Poller,10000+Math.random()*1000)
    ,
      (res)->
        $.notify(res.data.error,
          animate: {
            enter: 'animated fadeInRight',
            exit: 'animated fadeOutRight'
          }
          type: 'danger'
        )
        $timeout(Poller,Math.random()*10000)
    )
  Poller()
  return Me
)
.factory('Issue', ($routeParams, $http, $timeout)->
  Issue = {}
  Issue.data = []
  Issue.ori = ""
  Issue.contestId = $routeParams.contestId || 1
  Issue.version = undefined
  Issue.pollLife = 5000

  Issue.setContestId = (newContestId)->
    if newContestId isnt Issue.contestId
      Issue.data = []
      Issue.ori = ""
      Issue.contestId = newContestId
      Issue.version = undefined
      Issue.pollLife = 5000
  Issue.active = ()->
    Issue.pollLife = 5000
  Poller = ()->
    if Issue.pollLife > 0
      --Issue.pollLife
      $http.get("/api/contests/#{Issue.contestId}/issues")
      .then(
        (res)->
          if Issue.ori isnt JSON.stringify(res.data)
            Issue.data = res.data #轮询
            if Issue.ori isnt ""
              $.notify("有新的通知请查阅",
                animate: {
                  enter: 'animated fadeInRight',
                  exit: 'animated fadeOutRight'
                }
                type: 'success'
                delay: -1
              )
            Issue.ori = JSON.stringify(res.data)
          Issue.version = new Date()
          $timeout(Poller,5000+Math.random()*5000)
      ,
        ()->
          $timeout(Poller,Math.random()*5000)
      )
    else
      $timeout(Poller,1000+Math.random()*1000)
  Poller()

  Issue.create = (form)->
    $http.post("/api/contests/#{Issue.contestId}/issues", form)
    .then(
      (res)->
        form.title = "" # clear
        form.content = "" #clear
        $.notify("提问成功",
          animate: {
            enter: 'animated fadeInRight',
            exit: 'animated fadeOutRight'
          }
          type: 'success'
        )
        Issue.data.unshift(res.data)
        Issue.ori = ""
    ,
      (res)->
        $.notify(res.data.error,
          animate: {
            enter: 'animated fadeInRight',
            exit: 'animated fadeOutRight'
          }
          type: 'danger'
        )
    )

  return Issue
)
.factory('Rank', ($routeParams, $http, $timeout, Me)->
  Rank = {}
  Rank.data = []
  Rank.ori = ""
  Rank.statistics = {}
  Rank.contestId = $routeParams.contestId || 1
  Rank.version = undefined
  Rank.pollLife = 3

  Rank.setContestId = (newContestId)->
    if newContestId isnt Rank.contestId
      Rank.contestId = newContestId
      Rank.data = []
      Rank.statistics = {}
      Rank.version = undefined
      Rank.pollLife = 3

  Rank.active = ()->
    Rank.pollLife = 3

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
    if Rank.pollLife > 0
      --Rank.pollLife
      $http.get("/api/contests/#{Rank.contestId}/rank")
      .then(
        (res)->
          if Rank.ori isnt res.data
            Rank.data = JSON.parse(res.data) #轮询
            Rank.statistics = doRankStatistics(Rank.data)
            Rank.ori = res.data
          Rank.version = new Date()
          $timeout(Poller,5000+Math.random()*5000)
      ,
        ()->
          $timeout(Poller,Math.random()*5000)
      )
    else
      $timeout(Poller,1000+Math.random()*1000)
  Poller()

  return Rank
)
.factory('ServerTime', ($http,$timeout)->
  ST = {}
  ST.data = new Date()
  countDown = ()->
    ST.data = new Date(ST.data.getTime() + 1000)
    $timeout(countDown,1000)
  $http.get("/api/contests/server_time")
  .then(
    (res)->
      ST.data = new Date(res.data.server_time)
      countDown()
  )
  return ST
)


.controller('contest.ctrl', ($scope, $routeParams, $http, $timeout, Submission, Contest, Me, Rank, ServerTime,Issue)->
    #data

    $scope.order = Contest.order
    $scope.form ?= {lang:'c++'}

    $scope.Me = Me

    $scope.ServerTime = ServerTime
    $scope.contestId = $routeParams.contestId

    Contest.setContestId($routeParams.contestId)
    $scope.Contest = Contest

    Submission.setContestId($routeParams.contestId)
    $scope.Submission = Submission

    Rank.setContestId($routeParams.contestId)
    $scope.Rank = Rank

    Issue.setContestId($routeParams.contestId)
    $scope.Issue = Issue


    #Function

    $scope.setProblem = (order)->
      Contest.order = order
      $scope.order = order
      $timeout(->
        MathJax.Hub.Queue(["Typeset",MathJax.Hub])
      ,500)
      #MathJax.Hub.Typeset()

    $scope.isProblem = (order)->
      $scope.order is order

    $scope.numberToLetters = (num)->
      return 'A' if num is 0
      res = ""
      while(num>0)
        res = String.fromCharCode(num%26 + 65) + res
        num = parseInt(num/26)
      return res

    $scope.submit = ()->
      $scope.form.order = $scope.order
      if not $scope.form.code or $scope.form.code.length < 10
        alert("代码太短了，拒绝提交")
        return
      Submission.submit($scope.form)

    $scope.accepted = (order)->
      res = (sub for sub in Submission.data when $scope.Contest.idToOrder[sub.problem_id] is order and sub.result is 'AC')
      return res.length isnt 0

    $scope.tried = (order)->
      res = (sub for sub in Submission.data when $scope.Contest.idToOrder[sub.problem_id] is order)
      return res.length isnt 0

    #change submission color by ZP
    $scope.change_submission_color = (submission, index)->
      color = undefined
      number = undefined
      if submission == "WT" or submission == "JG"
        color = "green"
      else if submission == "AC"
        color = "blue"
      else
        color = "red"
      if index % 2 == 0
        number = "even"
      else
        number = "odd"
      return color + "-" + number + "-" + "tr"

    #change submission result color by ZP
    $scope.change_submission_result_color = (result)->
      switch result
        when "WT","JG" then "green-td"
        when "AC" then "blue-td"
        else "red-td"

    #return if the result is running or judging
    $scope.check_submission_is_running = (result)->
      return result == "WT" or result == "JG"

    $scope.active = ()->
      $scope.Rank.active()
      $scope.Contest.active()
      $scope.Issue.active()

    #private functions

    #by ZP
    $scope.question_form = {}
    $scope.submit_question_form = (order)->
      $scope.question_form.order = $scope.order
      Issue.create($scope.question_form)
    $scope.is_question = 0
    $scope.question_title = "提问"
    $scope.show_question_area = ()->
      if($scope.is_question == 0)
        $scope.question_title = "收起"
        $scope.is_question = 1
      else
        $scope.is_question = 0
        $scope.question_title = "提问"
    #end
)
