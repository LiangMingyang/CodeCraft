express = require('express');
router = express.Router(mergeParams: true);
middlewares = require('./middlewares')
controller = require('./controller')
# modules = require('./modules')

router.use(middlewares)


router
  .post '/task', controller.postTask
  #.post '/report', controller.postReport

module.exports = router
