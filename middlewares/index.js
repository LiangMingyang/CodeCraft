// Generated by CoffeeScript 1.9.3
(function() {
  module.exports = [
    function(req, res, next) {
      if (req.url !== '/' && '/' === req.url[req.url.length - 1]) {
        return res.redirect(req.url.slice(0, -1));
      } else {
        return next();
      }
    }
  ];

}).call(this);

//# sourceMappingURL=index.js.map
