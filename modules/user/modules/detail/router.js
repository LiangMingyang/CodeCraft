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

  router.get('/updatePW', controller.getUpdatePW).post('/updatePW', controller.postUpdatePW);

  router.get('/edit', controller.getEdit).post('/edit', controller.postEdit);

  router.get('/', function(req, res) {
    return res.redirect(req.params.userID + "/index");
  }).get('/index', controller.getIndex);

  module.exports = router;

}).call(this);

//# sourceMappingURL=router.js.map
