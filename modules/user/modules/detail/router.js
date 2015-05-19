// Generated by CoffeeScript 1.9.2
(function() {
  var controller, express, middlewares, router;

  express = require('express');

  router = express.Router();

  middlewares = require('./middlewares');

  controller = require('./controller');

  router.use(middlewares);

  router.post('/updatepw', controller.postPassword);

  router.post('/edit', controller.postEdit);

  router.get('/updatepw', controller.getUpdatePw);

  router.get('/edit', controller.getEdit);

  router.get('/', controller.getIndex);

  module.exports = router;

}).call(this);

//# sourceMappingURL=router.js.map
