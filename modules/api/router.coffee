express = require('express')
router = express.Router(mergeParams: true)

modules = require('./modules')

router
.use '/contest', modules.contest.router

module.exports = router