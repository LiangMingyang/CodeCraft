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
  .otherwise({
      redirectTo: '/1'
    })
)
.filter('marked', ['$sce', ($sce)->
  (text)->
    text = "" if not text
    $sce.trustAsHtml(marked(text))
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
  Poller = ()->
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
        $timeout(Poller,10000+Math.random()*1000)
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
.factory('Rank', ($routeParams, $http, $timeout)->
  Rank = {}
  Rank.data = []
  Rank.statistics = {}
  Rank.contestId = $routeParams.contestId || 1

  Rank.setContestId = (newContestId)->
    if newContestId isnt Rank.contestId
      Rank.contestId = newContestId
      Rank.data = []
      Rank.statistics = {}

  doRankStatistics = (rank)->
    triedPeopleCount = {}
    acceptedPeopleCount = {}
    triedSubCount = {}
    for r in rank
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
    }
  Poller = ()->
    $http.get("/api/contests/#{Rank.contestId}/rank")
    .then(
      (res)->
        Rank.data = JSON.parse(res.data) #轮询
        Rank.statistics = doRankStatistics(Rank.data)
        $timeout(Poller,5000+Math.random()*5000)
    ,
      ()->
        $timeout(Poller,Math.random()*5000)
    )
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


.controller('contest.ctrl', ($scope, $routeParams, $http, $timeout, Submission, Contest, Me, Rank, ServerTime)->
    #data

    $scope.page ?= "description"
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

    #private functions

)
