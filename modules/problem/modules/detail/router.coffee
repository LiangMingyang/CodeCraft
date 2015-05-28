express = require('express');
router = express.Router();
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

module.exports = router
