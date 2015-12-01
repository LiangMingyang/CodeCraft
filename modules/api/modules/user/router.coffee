express = require('express')
router = express.Router(mergeParams: true)
controller = require('./controller')


router
.get '/me', controller.getMe


module.exports = router