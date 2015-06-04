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
    return res.redirect(req.params.contestID + "/index");
  }).get('/index', controller.getIndex);

  router.get('/submission', controller.getSubmission);

  router.get('/clarification', controller.getClarification);

  router.get('/question', controller.getQuestion);

  router.get('/rank', controller.getRank);

  router.use('/problem/:problemID([A-Z]+)', modules.problem.router);

  module.exports = router;

}).call(this);

//# sourceMappingURL=router.js.map
