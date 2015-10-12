express = require('express')
router = express.Router(mergeParams: true)
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

router
  .use '/:userID([0-9]+)', modules.detail.router

module.exports = router
