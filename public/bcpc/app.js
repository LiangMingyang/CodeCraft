// Generated by CoffeeScript 1.9.3
(function() {
  'use strict';
  this.angular.module('bcpc', []).controller('bcpc.ctrl', function($scope, $http, $timeout) {
    $scope.passed = "waiting";
    $scope.confirmed = "waiting";
    $scope.list = [];
    $http.get('/api/bcpc/status').then(function(res) {
      $scope.passed = res.data.passed || false;
      $scope.confirmed = res.data.confirmed || false;
      return $scope.user = res.data.user || false;
    }, function(res) {
      return console.log(res.data.error);
    });
    $scope.form = {
      nickname: "",
      student_id: ""
    };
    return $scope.confirm = function() {
      if ($scope.form.nickname === "" || $scope.form.student_id === "") {
        alert("请认真一点");
        return;
      }
      return $http.post('/api/bcpc/confirm', $scope.form).then(function(res) {
        return $scope.confirmed = res.data.confirmed;
      }, function(res) {
        return alert(res.data.error);
      });
    };
  }).controller('bcpc.list', function($scope, $http) {
    $scope.list = [];
    return $http.get('/api/bcpc/list').then(function(res) {
      return $scope.list = res.data.users;
    }, function(res) {
      return alert(res.data.error);
    });
  });

}).call(this);

//# sourceMappingURL=app.js.map
