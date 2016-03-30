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
  .when('/news/:index',
    templateUrl: 'tpls/news-detail.tpl.html'
  )
  .when('/expert',
    templateUrl: 'tpls/expert.tpl.html'
  )
  .when('/policy',
    templateUrl: 'tpls/policy.tpl.html'
  )
  .when('/policy/:index',
    templateUrl: 'tpls/policy-detail.tpl.html'
  )
  .when('/contact',
    templateUrl: 'tpls/contact.tpl.html'
  )
  .otherwise(
    redirectTo: '/index'
  )
)