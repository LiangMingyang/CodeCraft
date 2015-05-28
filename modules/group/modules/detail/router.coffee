express = require('express')
router = express.Router(mergeParams: true)
middlewares = require('./middlewares')
controller = require('./controller')
#modules = require('./modules')


router.use(middlewares)

router
  .get '/', (req, res)->
    res.redirect "#{req.params.groupID}/index"

router
  .get '/index', controller.getIndex

router
  .get '/member', controller.getMember

router
  .get '/join', controller.getJoin

module.exports = router
