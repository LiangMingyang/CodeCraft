express = require('express');
router = express.Router();
middlewares = require('./middlewares')
controller = require('./controller')
#modules = require('./modules')


router.use(middlewares)

router
.post '/updatepw', controller.postPassword

router
.post '/edit', controller.postEdit

router
.get '/updatepw', controller.getUpdatePw

router
.get '/edit', controller.getEdit

router
.get '/', controller.getIndex

module.exports = router
