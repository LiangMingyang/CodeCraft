'use strict';

// Declare app level module which depends on views, and components
angular.module('myApp', [
  'ngRoute',
  'contest-list',
  'contest-detail'
]).
config(['$routeProvider', function($routeProvider) {
  $routeProvider
  .when('/contests', {
    templateUrl: 'list/contest-list.html',
    controller: 'contest-list'
  })
  .when('/contest/:contestId', {
    templateUrl: 'detail/contest-detail.html',
    controller: 'contest-detail'
  })
  .otherwise({
    redirectTo: '/contests'
  });
}]);