express = require('express')
router = express.Router(mergeParams: true)
middlewares = require('./middlewares')
controller = require('./controller')
modules = require('./modules')


router.use(middlewares)

router
  .get '/', (req, res)->
    res.redirect 'group/index'
  #.post '/', controller.postIndex
router
  .get '/index', controller.getIndex

router
  .get '/create', controller.getCreate
  .post '/create', controller.postCreate

#router.param 'groupID', (req, res, next, id) ->
#  req.param.groupID = id;
#  next()

router
  .use '/:groupID([0-9]+)', modules.detail.router

module.exports = router
