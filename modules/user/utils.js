// Generated by CoffeeScript 1.9.2
(function() {
  exports.login = function(req, res, user) {
    return req.session.user = {
      id: user.id,
      nickname: user.nickname,
      username: user.username
    };
  };

  exports.logout = function(req, res) {
    return delete req.session.user;
  };

}).call(this);

//# sourceMappingURL=utils.js.map
