express = require('express');
router = express.Router();
middlewares = require('./middlewares')
controller = require('./controller')
modules = require('./modules')
path = require('path')


router.use(middlewares)

router
  .get '/', (req, res)->
    res.redirect 'user/index'
  #.post '/', controller.postIndex

router
  .get '/index', controller.getIndex

router
  .get '/login', controller.getLogin
  .post '/login', controller.postLogin

router
  .get '/register', controller.getRegister
  .post '/register', controller.postRegister

router
  .get '/logout', controller.getLogout

router.param 'userID', (req, res, next, id) ->
  req.param.userID = id;
  next()

router
  .use '/:userID', modules.detail.router

module.exports = router
