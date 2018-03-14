express = require('express')
router = express.Router(mergeParams: true)
controller = require('./controller')


router
.get '/:solutionID/tag', controller.getTags

.post '/:solutionID/tag', controller.postTags

.post '/createTags', controller.postcreateTags


module.exports = router