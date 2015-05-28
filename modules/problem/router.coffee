express = require('express');
router = express.Router();
middlewares = require('./middlewares')
controller = require('./controller')
modules = require('./modules')


router.use(middlewares)

router
.get '/', (req, res) ->
  res.redirect 'problem/index'

.get '/index', controller.getIndex

router.param 'problemID', (req, res, next, id) ->
  req.param.problemID = id;
  next()

router
.use '/:problemID([0-9]+)', modules.detail.router

module.exports = router
