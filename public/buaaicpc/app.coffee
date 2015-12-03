'use strict';

@angular.module('bcpc',[])

.controller('bcpc.ctrl',($scope,$http,$timeout)->
  $scope.registed = false
  $http.get('/api/bcpc/status')
  .then(
    (res)->
      $scope.registed = res.data.registed
  ,
    (res)->
      console.log res.data.error
  )
  $scope.register = ()->
    $http.get('/api/bcpc/register')
    .then(
      (res)->
        $scope.registed = res.data.registed
    ,
      (res)->
        if res.status is 401
          window.location = "/user/login"
          return
        alert(res.data.error)
    )
)
