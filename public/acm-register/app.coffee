'use strict';

@angular.module('acm-register',[])

.controller('acm-register.ctrl',($scope,$http,$timeout)->
  $scope.confirmed = "waiting"
  $scope.list = []
  $http.get('/api/acm-register/status')
  .then(
    (res)->
      $scope.confirmed = res.data.confirmed || false
      $scope.user = res.data.user || false
      console.log res.data
  ,
    (res)->
      console.log res.data.error
  )
  $scope.form = {
    nickname : ""
    student_id : ""
    phone : ""
  }
  $scope.confirm = ()->
    if $scope.form.nickname is "" or $scope.form.student_id is "" or $scope.form.phone is ""
      alert("请认真一点")
      return
    $('#double_check').modal('show')
  $scope.double_confirm = ()->
    if $scope.form.nickname is "" or $scope.form.student_id is ""
      alert("请认真一点")
      $('#double_check').modal('hide')
      return
    $http.post('/api/acm-register/confirm', $scope.form)
    .then(
      (res)->
        $scope.confirmed = res.data.confirmed
    ,
      (res)->
        alert(res.data.error)
    )
    $('#double_check').modal('hide')
)
.controller('acm-register.list',($scope,$http)->
  $scope.list = []
  $http.get('/api/acm-register/list')
  .then(
    (res)->
      $scope.list = res.data.users
  ,
    (res)->
      alert(res.data.error)
  )
)
