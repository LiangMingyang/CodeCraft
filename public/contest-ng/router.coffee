angular.module('contest-router', [
  'ngRoute',
])
.config( ($routeProvider)->
  $routeProvider
  .when('/:contestId',
    templateUrl: 'detail/contest-detail.html',
    controller: 'contest.mainCtrl'
  )
  .when('/:contestId/problems',
    templateUrl: 'detail/detail-problem.html',
    controller: 'contest.mainCtrl'
  )
  .when('/:contestId/rank',
    templateUrl: 'detail/detail-rank.html',
    controller: 'contest.mainCtrl'
  )
  .when('/:contestId/submissions',
    templateUrl: 'detail/detail-submission.html',
    controller: 'contest.mainCtrl'
  )
  .when('/:contestId/issues',
    templateUrl: 'detail/detail-issues.html',
    controller: 'contest.mainCtrl'
  )
  .otherwise(
    redirectTo: '/404'
  )
)