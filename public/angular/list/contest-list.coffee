angular.module('contest-list', [ ])
.controller('contest-list', ['$scope', '$http', ($scope, $http)->
  $scope.contests = [
    id: 1
    title: "The first contest"
  ]
  $http.get('/api/contests').success (data)->
    $scope.contests = data
])