'use script';
@angular.module('contest-detail', ['ngRoute'])

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


.controller('contest-detail', ($scope, $routeParams, $http, $timeout)->
    #data

    $scope.contest ?= {
      title: "Waiting for data..."
      description: "Waiting for data..."
    }
    $scope.idToOrder ?= {}
    $scope.page ?= "description"
    $scope.order ?= 0
    $scope.form ?= {lang:'c++'}

    $scope.user ?= {
      nickname: "游客"
    }

    $scope.server_time ?= new Date()

    $http.get("/api/contests/server_time")
    .then(
      (res)->
        $scope.server_time = new Date(res.data.server_time)
        countDown()
    )
    countDown = ()->
      $scope.server_time = new Date($scope.server_time.getTime() + 1000)
      $timeout(countDown,1000)


    userPoller = ()->
      $http.get("/api/users/me")
      .then(
        (res)->
          $scope.user = res.data
          $timeout(userPoller,10000+Math.random()*1000)
      ,
        (res)->
          $.notify(res.data.error,
            animate: {
              enter: 'animated fadeInRight',
              exit: 'animated fadeOutRight'
            }
            type: 'danger'
          )
          $timeout(userPoller,Math.random()*10000)
      )
    userPoller()

    contestPoller = ()->
      $http.get("/api/contests/#{$routeParams.contestId}")
      .then(
        (res)->
          contest = res.data
          contest.problems.sort (a,b)->
            a.contest_problem_list.order-b.contest_problem_list.order
          for p,i in contest.problems
            p.test_setting = JSON.parse(p.test_setting)
            $scope.idToOrder[p.id] = i
          contest.start_time = new Date(contest.start_time)
          contest.end_time = new Date(contest.end_time)
          $scope.contest = contest  #轮询
          #$timeout(contestPoller,Math.random()*60000) #比赛不需要实时更新
      ,
        (res)->
          #alert(res.data.error)
          res.data.error = "该比赛需要登录才可以查看" if not $scope.user.id
          $.notify(res.data.error,
            animate: {
              enter: 'animated fadeInRight',
              exit: 'animated fadeOutRight'
            }
            type: 'danger'
          )
          $timeout(contestPoller,Math.random()*10000)
      )
    contestPoller()



    $scope.rank = []

    rankPoller = ()->
      $http.get("/api/contests/#{$routeParams.contestId}/rank")
      .then(
        (res)->
          $scope.rank = JSON.parse(res.data) #轮询
          $scope.rankStatistics = rankStatistics($scope.rank)
          $timeout(rankPoller,5000+Math.random()*5000)
      ,
        (res)->
          #alert(res.data.error)
#          res.data.error = "该比赛需要登录才可以查看" if not $scope.user.id
##          $.notify(res.data.error,
##            animate: {
##              enter: 'animated fadeInRight',
##              exit: 'animated fadeOutRight'
##            }
##            type: 'danger'
##          )
          $timeout(rankPoller,Math.random()*10000)
      )
    rankPoller()

    $scope.submissions = []

    subPoller = ()->
      $http.get("/api/contests/#{$routeParams.contestId}/submissions")
      .then(
        (res)->
          $scope.submissions = res.data #轮询
          $timeout(subPoller, 1000 + Math.random()*1000)
      ,
        ()->
          $timeout(subPoller,Math.random()*5000)
      )
    subPoller()

    #Function

    $scope.setPage = (page)->
      $scope.page = page

    $scope.isPage = (page)->
      page is $scope.page

    $scope.setProblem = (order)->
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

    $scope.submit = (order)->
      $scope.form.order = order
      if not $scope.form.code or $scope.form.code.length < 10
        alert("代码太短了，拒绝提交")
        return
      $http.post("/api/contests/#{$routeParams.contestId}/submissions",$scope.form)
      .then(
          ()->
            $scope.form.code = ""
            $.notify("提交成功",
              animate: {
                enter: 'animated fadeInRight',
                exit: 'animated fadeOutRight'
              }
              type: 'success'
            )
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

    $scope.accepted = (order)->
      res = (sub for sub in $scope.submissions when $scope.idToOrder[sub.problem_id] is order and sub.result is 'AC')
      return res.length isnt 0

    $scope.tried = (order)->
      res = (sub for sub in $scope.submissions when $scope.idToOrder[sub.problem_id] is order)
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
      return "green-td" if result == "WT" or result == "JG"
      return "blue-td" if result == "AC"
      return "red-td"

    #return if the result is running or judging
    $scope.check_submission_is_running = (result)->
      return true if result == "WT" or result == "JG"
      return false

    #private functions
    rankStatistics = (rank)->
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
)
