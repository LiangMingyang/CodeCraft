express = require('express');
router = express.Router(mergeParams: true);
middlewares = require('./middlewares')
controller = require('./controller')
#modules = require('./modules')


router.use(middlewares)

router.get '/', (req, res) ->
  res.redirect "#{req.params.problemID}/index"

router
.get '/submission', controller.getSubmissions

router
.get '/index', controller.getIndex

router
.post '/submit', controller.postSubmission

router
.get '/submission/:submissionID([0-9]+)', controller.getCode

module.exports = router
