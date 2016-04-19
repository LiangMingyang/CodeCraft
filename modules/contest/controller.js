// Generated by CoffeeScript 1.10.0
(function() {
  var HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, passwordHash;

  passwordHash = require('password-hash');

  HOME_PAGE = '/';

  INDEX_PAGE = 'index';

  LOGIN_PAGE = '/user/login';

  exports.getIndex = function(req, res) {
    var Group;
    Group = global.db.models.group;
    return global.db.Promise.resolve().then(function() {
      var base, offset;
      if ((base = req.query).page == null) {
        base.page = 1;
      }
      offset = (req.query.page - 1) * global.config.pageLimit.contest;
      return global.myUtils.findAndCountContests(req.session.user, offset, {
        model: Group,
        attributes: ['id', 'name']
      });
    }).then(function(result) {
      var contests, count;
      contests = result.rows;
      count = result.count;
      return res.render('contest/index', {
        user: req.session.user,
        contests: contests,
        page: req.query.page,
        pageLimit: global.config.pageLimit.contest,
        contestCount: count
      });
    })["catch"](function(err) {
      console.error(err);
      err.message = "未知错误";
      return res.render('error', {
        error: err
      });
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
