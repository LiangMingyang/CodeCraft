'use script';
@angular.module('contest-detail', [])

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

.controller('contest-detail', ['$scope', '$routeParams', '$http', "$timeout", ($scope, $routeParams, $http, $timeout)->
    #data

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
    $scope.contest = {
      title: "Waiting for data..."
      description: "Waiting for data..."
    }
    $scope.idToOrder = {}

    contestPoller = ()->
      $http.get("/api/contest/#{$routeParams.contestId}")
      .then(
        (res)->
          contest = res.data
          contest.problems.sort (a,b)->
            a.contest_problem_list.order-b.contest_problem_list.order
          for p,i in contest.problems
            p.test_setting = JSON.parse(p.test_setting)
            $scope.idToOrder[p.id] = i
          $scope.contest = contest  #轮询
          #$timeout(contestPoller,Math.random()*60000) #比赛不需要实时更新
      ,
        ()->
          $timeout(contestPoller,Math.random()*10000)
      )
    contestPoller()



    $scope.rank = []

    rankPoller = ()->
      $http.get("/api/contest/#{$routeParams.contestId}/rank")
      .then(
        (res)->
          $scope.rank = JSON.parse(res.data) #轮询
          $scope.rankStatistics = rankStatistics($scope.rank)
          $timeout(rankPoller,5000+Math.random()*5000)
      ,
        ()->
          $timeout(rankPoller,Math.random()*10000)
      )
    rankPoller()

    $scope.submissions = []

    subPoller = ()->
      $http.get("/api/contest/#{$routeParams.contestId}/submissions")
      .then(
        (res)->
          $scope.submissions = res.data #轮询
#          $scope.submissions.sort (a,b)->
#            a.id-b.id
          $timeout(subPoller, 1000 + Math.random()*1000)
      ,
        ()->
          $timeout(subPoller,Math.random()*5000)
      )
    subPoller()


    #init
    $scope.page = "description"
    $scope.order = 0
    $scope.form = {lang:'c++'}

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
      if not $scope.form.code or $scope.form.code.length < 20
        alert("Code is too short.")
        return
      $http.post("/api/contest/#{$routeParams.contestId}/submissions",$scope.form)
      .then(
          ()->
            $scope.form.code = ""
        ,
          (res)->
            alert(res.data.error)
      )

    $scope.accepted = (order)->
      res = (sub for sub in $scope.submissions when $scope.idToOrder[sub.problem_id] is order and sub.result is 'AC')
      return res.length isnt 0

    $scope.tried = (order)->
      res = (sub for sub in $scope.submissions when $scope.idToOrder[sub.problem_id] is order)
      return res.length isnt 0
  ])
