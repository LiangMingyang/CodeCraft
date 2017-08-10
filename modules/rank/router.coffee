express = require('express');
router = express.Router(mergeParams: true);
middlewares = require('./middlewares')
controller = require('./controller')
#modules = require('./modules')

router.use(middlewares)

router
.get '/', (req, res) ->
    res.redirect 'rank/index'

.get '/index', controller.getIndex

module.exports = router
