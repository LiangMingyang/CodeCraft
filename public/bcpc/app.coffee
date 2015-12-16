'use strict';

@angular.module('bcpc',[])

.controller('bcpc.ctrl',($scope,$http,$timeout)->
  $scope.passed = "waiting"
  $scope.confirmed = "waiting"
  $scope.list = []
  $http.get('/api/bcpc/status')
  .then(
    (res)->
      $scope.passed = res.data.passed || false
      $scope.confirmed = res.data.confirmed || false
      $scope.user = res.data.user || false
  ,
    (res)->
      console.log res.data.error
  )
  $scope.form = {
    nickname : ""
    student_id : ""
  }
  $scope.confirm = ()->
    if $scope.form.nickname is "" or $scope.form.student_id is ""
      alert("请认真一点")
      return
    $('#double_check').modal('show')
  $scope.double_confirm = ()->
    if $scope.form.nickname is "" or $scope.form.student_id is ""
      alert("请认真一点")
      $('#double_check').modal('hide')
      return
    $http.post('/api/bcpc/confirm', $scope.form)
    .then(
      (res)->
        $scope.confirmed = res.data.confirmed
    ,
      (res)->
        alert(res.data.error)
    )
    $('#double_check').modal('hide')
)
.controller('bcpc.list',($scope,$http)->
  $scope.list = []
  $http.get('/api/bcpc/list')
  .then(
    (res)->
      $scope.list = res.data.users
  ,
    (res)->
      alert(res.data.error)
  )
)
