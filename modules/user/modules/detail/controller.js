// Generated by CoffeeScript 1.9.2
(function() {
  exports.getIndex = function(req, res) {
    return res.render('index', {
      title: 'Your userID=' + req.param.userID
    });
  };

  exports.getEdit = function(req, res) {
    return res.render('index', {
      title: 'You are at EDIT page'
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
