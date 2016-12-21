express = require('express');
router = express.Router(mergeParams: true);
middlewares = require('./middlewares')
controller = require('./controller')
# modules = require('./modules')

router.use(middlewares)

router
#.get '/', (req, res) ->
#  res.redirect 'solution/index'
#
#.get '/index', controller.getIndex
#.post '/index', controller.postIndex

.get '/:submissionID([0-9]+)', controller.getSolution

.post '/:submissionID([0-9]+)', controller.postSolution

#.get '/create/:submissionID([0-9]+)', controller.getCreateSolution

module.exports = router
