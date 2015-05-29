express = require('express')
router = express.Router(mergeParams: true)
middlewares = require('./middlewares')
controller = require('./controller')
modules = require('./modules')


router.use(middlewares)

router
  .get '/', (req, res)->
    res.redirect 'contest/index'
  #.post '/', controller.postIndex
router
  .get '/index', controller.getIndex

router
  .use '/:contestID([0-9]+)', modules.detail.router

module.exports = router
