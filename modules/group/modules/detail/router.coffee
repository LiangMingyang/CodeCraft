express = require('express');
router = express.Router();
middlewares = require('./middlewares')
controller = require('./controller')
#modules = require('./modules')


router.use(middlewares)

router
  .get '/member', controller.getMember

router
  .get '/', controller.getIndex

module.exports = router
