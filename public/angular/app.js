'use strict';

// Declare app level module which depends on views, and components
angular.module('myApp', [
  'ngRoute',
  'ngResource',
  'emguo.poller',
  'contest-list',
  'contest-detail'
]).
config(['$routeProvider', function($routeProvider) {
  $routeProvider
  .when('/contest/:contestId', {
    templateUrl: 'detail/contest-detail.html',
    controller: 'contest-detail'
  })
  .otherwise({
    redirectTo: '/contest/1'
  });
}]);