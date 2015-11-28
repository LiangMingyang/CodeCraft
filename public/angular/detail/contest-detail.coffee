'use script';
@angular.module('contest-detail', [])


.controller('contest-detail', ['$scope', '$routeParams', '$http', ($scope, $routeParams, $http)->
    #data
    $scope.contest = {}
    $http.get("/api/contest/#{$routeParams.contestId}")
    .success (contest, status, headers, config)->
      contest.problems.sort (a,b)->
        a.contest_problem_list.order-b.contest_problem_list.order
      $scope.contest = contest  #轮询

    $scope.rank = []
    $http.get("/api/contest/#{$routeParams.contestId}/rank")
    .success (rank, status, headers, config)->
      $scope.rank = rank #轮询

    $scope.submissions = []
    $http.get("/api/contest/#{$routeParams.contestId}/submission")
    .success (submissions, status, headers, config)->
      $scope.submissions = submissions #轮询


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
  ])
