express = require('express')
router = express.Router(mergeParams: true)
controller = require('./controller')


router
.get '/:contestId', controller.getContest

.get '/:contestId/rank', controller.getRank

.get '/:contestId/submissions', controller.getSubmissions

.post '/:contestId/submissions', controller.postSubmissions

module.exports = router