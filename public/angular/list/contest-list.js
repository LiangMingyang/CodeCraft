// Generated by CoffeeScript 1.9.3
(function() {
  angular.module('contest-list', []).controller('contest-list', [
    '$scope', '$http', function($scope, $http) {
      $scope.contests = [
        {
          id: 1,
          title: "The first contest"
        }
      ];
      return $http.get('/api/contests').success(function(data) {
        return $scope.contests = data;
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=contest-list.js.map