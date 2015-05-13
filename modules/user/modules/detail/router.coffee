express = require('express');
router = express.Router();
middlewares = require('./middlewares')
controller = require('./controller')
#modules = require('./modules')


router.use(middlewares)

router
  .get '/edit', controller.getEdit

router
  .get '/', controller.getIndex

module.exports = router
