// Generated by CoffeeScript 1.10.0
(function() {
  var controller, express, middlewares, modules, router;

  express = require('express');

  router = express.Router({
    mergeParams: true
  });

  middlewares = require('./middlewares');

  controller = require('./controller');

  modules = require('./modules');

  router.use(middlewares);

  router.get('/', function(req, res) {
    return res.redirect('problem/index');
  }).get('/index', controller.getIndex).post('/index', controller.postIndex).get('/accepted', controller.getAccepted).get('/statistics', controller.getStatistics).post('/accepted', controller.postAccepted);

  router.use('/:problemID([0-9]+)', modules.detail.router);

  module.exports = router;

}).call(this);

//# sourceMappingURL=router.js.map
