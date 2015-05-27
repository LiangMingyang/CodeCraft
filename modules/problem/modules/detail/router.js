// Generated by CoffeeScript 1.9.2
(function() {
  var controller, express, middlewares, router;

  express = require('express');

  router = express.Router();

  middlewares = require('./middlewares');

  controller = require('./controller');

  router.use(middlewares);

  router.get('/submission', controller.getSubmissions);

  router.get('/', controller.getIndex);

  router.post('/submit', controller.postSubmission);

  module.exports = router;

}).call(this);

//# sourceMappingURL=router.js.map