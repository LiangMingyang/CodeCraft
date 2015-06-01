express = require('express');
router = express.Router(mergeParams: true);
middlewares = require('./middlewares')
controller = require('./controller')
#modules = require('./modules')


router.use(middlewares)

router.get '/', (req, res) ->
  res.redirect "#{req.params.problemID}/index"

router
.get '/index/submission', controller.getSubmissions

router
.get '/index', controller.getIndex

router
.post '/index/submit', controller.postSubmission

router
.get '/index/submission/:submissionID([0-9]+)', controller.getCode

module.exports = router
