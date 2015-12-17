express = require('express')
router = express.Router(mergeParams: true)
controller = require('./controller')


router
.get '/server_time', controller.getTime

.get '/:contestId', controller.getContest

.get '/:contestId/rank', controller.getRank

.get '/:contestId/submissions', controller.getSubmissions

.post '/:contestId/submissions', controller.postSubmissions

.get '/:contestId/issues', controller.getIssues

.post '/:contestId/issues', controller.postIssues

module.exports = router