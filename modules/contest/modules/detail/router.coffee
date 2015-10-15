express = require('express')
router = express.Router(mergeParams: true)
middlewares = require('./middlewares')
controller = require('./controller')
modules = require('./modules')


router.use(middlewares)

router
  .get '/', (req, res)->
    res.redirect "#{req.params.contestID}/index"
  .get '/index', controller.getIndex


router
  .get '/problem', controller.getProblem

router
  .get '/submission', controller.getSubmission
  .post '/submission', controller.postSubmissions

router
  .get '/clarification', controller.getClarification

router
  .get '/question', controller.getQuestion
  .post '/question', controller.postQuestion

router
  .get '/rank', controller.getRank

router
  .use '/problem/:problemID([A-Z]+)', modules.problem.router


module.exports = router
