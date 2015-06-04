// Generated by CoffeeScript 1.9.2
(function() {
  var InvalidAccess, InvalidFile, UnknownContest, UnknownProblem, UnknownUser, path,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  path = require('path');

  UnknownProblem = (function(superClass) {
    extend(UnknownProblem, superClass);

    function UnknownProblem(message) {
      this.message = message != null ? message : "Unknown problem";
      this.name = 'UnknownProblem';
      Error.captureStackTrace(this, UnknownProblem);
    }

    return UnknownProblem;

  })(Error);

  UnknownContest = (function(superClass) {
    extend(UnknownContest, superClass);

    function UnknownContest(message) {
      this.message = message != null ? message : "Unknown contest.";
      this.name = 'UnknownContest';
      Error.captureStackTrace(this, UnknownContest);
    }

    return UnknownContest;

  })(Error);

  InvalidAccess = (function(superClass) {
    extend(InvalidAccess, superClass);

    function InvalidAccess(message) {
      this.message = message != null ? message : "Invalid Access, please return";
      this.name = 'InvalidAccess';
      Error.captureStackTrace(this, InvalidAccess);
    }

    return InvalidAccess;

  })(Error);

  UnknownUser = (function(superClass) {
    extend(UnknownUser, superClass);

    function UnknownUser(message) {
      this.message = message != null ? message : "Unknown user, please login first";
      this.name = 'UnknownUser';
      Error.captureStackTrace(this, UnknownUser);
    }

    return UnknownUser;

  })(Error);

  InvalidFile = (function(superClass) {
    extend(InvalidFile, superClass);

    function InvalidFile(message) {
      this.message = message != null ? message : "File not exist!";
      this.name = 'InvalidFile';
      Error.captureStackTrace(this, InvalidFile);
    }

    return InvalidFile;

  })(Error);

  exports.getStaticProblem = function(problemId) {
    var dirname;
    dirname = global.config.problem_resource_path;
    return path.join(dirname, problemId.toString());
  };

  exports.Error = {
    UnknownUser: UnknownUser,
    InvalidAccess: InvalidAccess,
    UnknownProblem: UnknownProblem,
    InvalidFile: InvalidFile,
    UnknownContest: UnknownContest
  };

  exports.findProblem = function(user, problemID, include) {
    var Problem;
    Problem = global.db.models.problem;
    return Problem.find({
      where: {
        id: problemID
      },
      include: include
    });
  };

  exports.findContest = function(req, contestID) {
    var Contest, User, currentUser;
    Contest = global.db.models.contest;
    User = global.db.models.user;
    currentUser = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      if (!user) {
        return [];
      }
      currentUser = user;
      return currentUser.getGroups();
    }).then(function(groups) {
      var adminGroups, group, normalGroups;
      normalGroups = (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = groups.length; j < len; j++) {
          group = groups[j];
          if (group.membership.access_level !== 'verifying') {
            results.push(group.id);
          }
        }
        return results;
      })();
      adminGroups = (function() {
        var j, len, ref, results;
        results = [];
        for (j = 0, len = groups.length; j < len; j++) {
          group = groups[j];
          if ((ref = group.membership.access_level) === 'owner' || ref === 'admin') {
            results.push(group.id);
          }
        }
        return results;
      })();
      return Contest.find({
        where: {
          $and: {
            id: contestID,
            $or: [
              currentUser ? {
                creator_id: currentUser.id
              } : void 0, {
                access_level: 'public'
              }, {
                access_level: 'protect',
                group_id: normalGroups
              }, {
                access_level: 'private',
                group_id: adminGroups
              }
            ]
          }
        },
        include: [
          {
            model: User,
            as: 'creator'
          }
        ]
      });
    });
  };

  exports.lettersToNumber = function(word) {
    var i, j, len, res;
    res = 0;
    for (j = 0, len = word.length; j < len; j++) {
      i = word[j];
      res = res * 26 + (i.charCodeAt(0) - 65);
    }
    return res;
  };

}).call(this);

//# sourceMappingURL=utils.js.map
