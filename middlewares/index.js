// Generated by CoffeeScript 1.9.2
(function() {
  module.exports = [
    function(req, res, next) {
      if (req.session.userID) {
        req.flash('userID', req.session.userID);
      }
      return next();
    }, function(req, res, next) {
      return next();
    }
  ];

}).call(this);

//# sourceMappingURL=index.js.map
