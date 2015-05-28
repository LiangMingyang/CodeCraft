express = require('express')
router = express.Router(mergeParams: true)
middlewares = require('./middlewares')
controller = require('./controller')
#modules = require('./modules')


router.use(middlewares)

router
  .get '/updatePW', controller.getUpdatePW
  .post '/updatePW', controller.postUpdatePW

router
  .get '/edit', controller.getEdit
  .post '/edit', controller.postEdit

router
  .get '/', (req, res) ->
    res.redirect "#{req.params.userID}/index"
  .get '/index', controller.getIndex


module.exports = router
