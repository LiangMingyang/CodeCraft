// Generated by CoffeeScript 1.9.3
(function() {
  angular.module('west', []).controller('main', function($scope) {}).controller('top', function($scope, $timeout) {
    var update;
    $scope.now = new Date();
    update = function() {
      $scope.now = new Date();
      return $timeout(update, 1000);
    };
    return update();
  });

}).call(this);

//# sourceMappingURL=app.js.map
