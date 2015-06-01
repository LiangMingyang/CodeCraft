express = require('express')
router = express.Router(mergeParams: true)
middlewares = require('./middlewares')
controller = require('./controller')


router.use(middlewares)

router
  .get '/', (req, res)->
    res.redirect "#{req.params.contestID}/index"
  .get '/index', controller.getIndex


router
  .get '/submission', controller.getSubmission

router
  .get '/clarification', controller.getClarification

router
  .get '/question', controller.getQuestion

router
  .get '/rank', controller.getRank


module.exports = router
