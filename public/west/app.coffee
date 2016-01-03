angular.module('west', ['ui.bootstrap'])
.controller('main', ($scope)->
)
.controller('top', ($scope, $timeout)->

  $scope.now = new Date()
  update = ()->
    $scope.now = new Date()
    $timeout(update, 1000)
  update()

)
.controller('carousel', ($scope)->
  $scope.slides = [
    image: "/west/index_files/41533c1509a7aa914d240e2323ec931d.jpg"
    text: "讲话"
  ,
    image: "/west/index_files/1295865472c035ed7c2b8cbea64c9fd7.jpg"
    text: "视察"
  ,
    image: "/west/index_files/429101300209f00ec774cc4cda0f84e9.jpg"
    text: "指导"
  ]

  #get method

)