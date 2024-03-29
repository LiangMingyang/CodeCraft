// Generated by CoffeeScript 1.10.0
(function() {
  var controller, express, middlewares, router;

  express = require('express');

  router = express.Router({
    mergeParams: true
  });

  middlewares = require('./middlewares');

  controller = require('./controller');

  router.use(middlewares);

  router.get('/', function(req, res) {
    return res.redirect('rank/index');
  }).get('/index', controller.getIndex);

  module.exports = router;

}).call(this);

//# sourceMappingURL=router.js.map
