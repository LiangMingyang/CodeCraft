'use script';
@angular.module('contest-detail', [])

.filter('marked', ['$sce', ($sce)->
  (text)->
    text = "" if not text
    $sce.trustAsHtml(marked(text))
])

.controller('contest-detail', ['$scope', '$routeParams', '$http', "$timeout", ($scope, $routeParams, $http, $timeout)->
    #data
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
          $timeout(rankPoller,5000+Math.random()*5000)
      ,
        ()->
          $timeout(rankPoller,Math.random()*10000)
      )
    rankPoller()

    $scope.submissions = []

    subPoller = ()->
      $http.get("/api/contest/#{$routeParams.contestId}/submission")
      .then(
        (res)->
          $scope.submissions = res.data #轮询
          $timeout(subPoller, 1000 + Math.random()*1000)
      ,
        ()->
          $timeout(subPoller,Math.random()*5000)
      )
    subPoller()



    $scope.page = "description"
    $scope.order = 0

    #Function

    $scope.setPage = (page)->
      $scope.page = page

    $scope.isPage = (page)->
      page is $scope.page

    $scope.setProblem = (order)->
      $scope.order = order

    $scope.isProblem = (order)->
      $scope.order is order

    $scope.numberToLetters = (num)->
      return 'A' if num is 0
      res = ""
      while(num>0)
        res = String.fromCharCode(num%26 + 65) + res
        num = parseInt(num/26)
      return res
  ])
