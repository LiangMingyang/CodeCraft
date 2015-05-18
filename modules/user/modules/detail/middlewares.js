// Generated by CoffeeScript 1.9.2
(function() {
  module.exports = [
    function(req, res, next) {
      if (req.session && req.session.userID && req.session.userID === req.param.userID) {
        return next();
      } else if (req.url === '/') {
        return next();
      } else {
        throw new Error('undefined');
      }
    }
  ];

}).call(this);

//# sourceMappingURL=middlewares.js.map
