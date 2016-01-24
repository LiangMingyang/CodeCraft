angular.module('west-router', [
  'ngRoute',
])
.config( ($routeProvider)->
  $routeProvider
  .when('/index',
    templateUrl: 'tpls/index.tpl.html',
  )
  .when('/about',
    templateUrl: 'tpls/about.tpl.html',
  )
  .when('/news',
    templateUrl: 'tpls/news.tpl.html'
  )
  .when('/expert',
    templateUrl: 'tpls/expert.tpl.html'
  )
  .otherwise(
    redirectTo: '/index'
  )
)