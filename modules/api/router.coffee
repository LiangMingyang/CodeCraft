express = require('express')
router = express.Router(mergeParams: true)

modules = require('./modules')

router
.use '/contests', modules.contest.router

.use '/users', modules.user.router

module.exports = router