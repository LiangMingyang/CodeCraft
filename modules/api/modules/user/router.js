// Generated by CoffeeScript 1.9.3
(function() {
  var controller, express, router;

  express = require('express');

  router = express.Router({
    mergeParams: true
  });

  controller = require('./controller');

  router.get('/me', controller.getMe);

  module.exports = router;

}).call(this);

//# sourceMappingURL=router.js.map
