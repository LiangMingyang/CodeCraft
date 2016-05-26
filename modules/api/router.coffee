express = require('express')
router = express.Router(mergeParams: true)

modules = require('./modules')

router
.use '/contests', modules.contest.router

.use '/users', modules.user.router

.use '/bcpc', modules.bcpc.router

.use '/acm-register', modules.acm_register.router

module.exports = router