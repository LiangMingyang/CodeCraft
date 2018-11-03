express = require('express');
router = express.Router(mergeParams: true);
middlewares = require('./middlewares')
controller = require('./controller')
modules = require('./modules')

router.use(middlewares)

router
.get '/', (req, res) ->
    res.redirect 'problem/index'

.get '/index', controller.getIndex

.post '/index', controller.postIndex

.get '/accepted', controller.getAccepted

.get '/statistics', controller.getStatistics

.get '/tencentStatistics', controller.getTencentStatistics

#.get '/solutionStatistics', controller.getSolutionStatistics

.get '/xiniuStatistics', controller.getXiniuStatistics

.get '/DEVStatistics', controller.getDEVStatistics

.get '/CBStatistics', controller.getCBStatistics


.post '/accepted', controller.postAccepted
#router.param 'problemID', (req, res, next, id) ->
#  req.param.problemID = id;
#  next()

router
.use '/:problemID([0-9]+)', modules.detail.router

module.exports = router
