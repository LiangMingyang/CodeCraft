// Generated by CoffeeScript 1.9.2
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
  }).get('/index', controller.getIndex);

  router.use('/:problemID([0-9]+)', modules.detail.router);

  module.exports = router;

}).call(this);

//# sourceMappingURL=router.js.map
