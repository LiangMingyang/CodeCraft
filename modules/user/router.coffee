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
  .get '/login', controller.getLogin
  #.post '/login', controller.postLogin

router
  .get '/register', controller.getRegister
  #.post '/register', controller.postRegister

router.param 'userID', (req, res, next, id) ->
  console.log id
  req.param.userID = id;
  next()

router
  .use '/:userID', modules.detail.router

module.exports = router
