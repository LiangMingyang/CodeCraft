express = require('express')
router = express.Router(mergeParams: true)
controller = require('./controller')


router
.get '/:problemID/tag', controller.getTags

.post '/:problemID/tag', controller.postTags

.post '/creatTags', controller.postcreateTags


module.exports = router