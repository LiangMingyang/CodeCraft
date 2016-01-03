angular.module('west', [])
.controller('main', ($scope)->
)
.controller('top', ($scope, $timeout)->

  $scope.now = new Date()
  update = ()->
    $scope.now = new Date()
    $timeout(update, 1000)
  update()

)