express = require('express')
router = express.Router(mergeParams: true)
controller = require('./controller')


router
.get '/status', controller.getStatus

.get '/register', controller.getRegister

.get '/list', controller.getList

module.exports = router