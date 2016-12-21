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

#.get '/:solutionID([0-9]+)', controller.getSolution

.post '/editor/:submissionID([0-9]+)', controller.postSolutionEditor

.get '/editor/:submissionID([0-9]+)', controller.getSolutionEditor

module.exports = router
