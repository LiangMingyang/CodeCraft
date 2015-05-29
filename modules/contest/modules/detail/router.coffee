express = require('express')
router = express.Router(mergeParams: true)
middlewares = require('./middlewares')
controller = require('./controller')


router.use(middlewares)


module.exports = router
