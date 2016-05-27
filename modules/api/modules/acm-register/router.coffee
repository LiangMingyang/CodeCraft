express = require('express')
router = express.Router(mergeParams: true)
controller = require('./controller')


router
.get '/status', controller.getStatus

.get '/list', controller.getList

.post '/confirm', controller.postConfirm

module.exports = router