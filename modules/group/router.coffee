express = require('express');
router = express.Router();
middlewares = require('./middlewares')
controller = require('./controller')
modules = require('./modules')


router.use(middlewares)

router
  .get '/', controller.getIndex
  #.post '/', controller.postIndex

router
  .get '/create', controller.getCreate
  .post '/create', controller.postCreate

router.param 'groupID', (req, res, next, id) ->
  req.param.groupID = id;
  next()

router
  .use '/:groupID', modules.detail.router

module.exports = router
