// Generated by CoffeeScript 1.9.3
(function() {
  exports.getMe = function(req, res) {
    return global.db.Promise.resolve().then(function() {
      return res.json(req.session.user);
    })["catch"](function(err) {
      res.status(err.status || 400);
      return res.json({
        error: err.message
      });
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
