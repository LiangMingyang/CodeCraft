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

.controller('news', ($scope)->
  $scope.news_list = [
    title: '一篇新闻'
    content: 'blabla'
    created_at: '2016-01-03 23:33'
    updated_at: '2016-01-04 07:11'
  ,
    title: '学而时习之，不亦说乎'
    content: 'RT'
    created_at: '2016-01-02 23:33'
    updated_at: '2016-01-03 07:11'
  ,
    title: '千乘之国，敬事而信'
    content: 'RT'
    created_at: '2016-01-01 23:33'
    updated_at: '2016-01-02 07:11'
  ,
    title: '谨而信，泛爱众而亲仁'
    content: 'RT'
    created_at: '2015-12-30 23:33'
    updated_at: '2015-12-31 07:11'
  ,
    title: '温良恭俭让'
    content: 'RT'
    created_at: '2015-12-29 23:33'
    updated_at: '2015-12-30 07:11'
  ,
    title: '慎终追远，民德归厚'
    content: 'RT'
    created_at: '2015-12-28 23:33'
    updated_at: '2015-12-31 07:11'
  ]

  #update method
)

.controller('work', ($scope)->
  $scope.moments = [
    title: '贤贤易色'
    content: 'blabla'
    created_at: '2016-01-03 23:33'
    updated_at: '2016-01-04 07:11'
  ,
    title: '君子务本，本立而道生'
    content: 'RT'
    created_at: '2016-01-02 23:33'
    updated_at: '2016-01-03 07:11'
  ]
)