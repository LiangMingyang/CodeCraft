'use strict';

// Declare app level module which depends on views, and components
angular.module('contest', [
  'ngRoute'
]).
config(['$routeProvider', function($routeProvider) {
  $routeProvider
  .when('/:contestId', {
    templateUrl: 'detail/contest-detail.html',
    controller: 'contest-detail'
  })
  .when('/:contestId/problems', {
    templateUrl: 'detail/detail-problem.html',
    controller: 'contest-detail'
  })
  .when('/:contestId/rank', {
    templateUrl: 'detail/detail-problem.html',
    controller: 'contest-detail'
  })
  .otherwise({
    redirectTo: '/1'
  });
}]);