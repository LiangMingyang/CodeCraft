express = require('express');
router = express.Router();
middlewares = require('./middlewares')
controller = require('./controller')
#modules = require('./modules')


router.use(middlewares)

router
.get '/submission', controller.getSubmissions

router
.get '/', controller.getIndex

router
.post '/submit', controller.postSubmission

module.exports = router
