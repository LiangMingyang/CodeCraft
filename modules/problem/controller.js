// Generated by CoffeeScript 1.9.2
(function() {
  var HOME_PAGE, INDEX_PAGE, myUtils, passwordHash;

  passwordHash = require('password-hash');

  myUtils = require('./utils');

  HOME_PAGE = '/';

  INDEX_PAGE = '.';

  exports.getIndex = function(req, res) {
    return res.render('problem/index', {
      title: 'Problem List Page',
      headline: 'Problem index(SHEN ME DOU MEI YOU!)'
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map