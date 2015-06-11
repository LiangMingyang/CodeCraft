// Generated by CoffeeScript 1.9.3
(function() {
  var controller, express, middlewares, router;

  express = require('express');

  router = express.Router({
    mergeParams: true
  });

  middlewares = require('./middlewares');

  controller = require('./controller');

  router.use(middlewares);

  router.post('/task', controller.postTask);

  router.post('/file', controller.postFile);

  router.post('/report', controller.postReport);

  module.exports = router;

}).call(this);

//# sourceMappingURL=router.js.map
