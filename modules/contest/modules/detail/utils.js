// Generated by CoffeeScript 1.9.3
(function() {
  var InvalidAccess, LoginError, RegisterError, UnknownContest, UnknownUser, UpdateError,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  UnknownUser = (function(superClass) {
    extend(UnknownUser, superClass);

    function UnknownUser(message) {
      this.message = message != null ? message : "Unknown user.";
      this.name = 'UnknownUser';
      Error.captureStackTrace(this, UnknownUser);
    }

    return UnknownUser;

  })(Error);

  LoginError = (function(superClass) {
    extend(LoginError, superClass);

    function LoginError(message) {
      this.message = message != null ? message : "Wrong password or username.";
      this.name = 'LoginError';
      Error.captureStackTrace(this, LoginError);
    }

    return LoginError;

  })(Error);

  RegisterError = (function(superClass) {
    extend(RegisterError, superClass);

    function RegisterError(message) {
      this.message = message != null ? message : "Unvalidated register message.";
      this.name = 'LoginError';
      Error.captureStackTrace(this, LoginError);
    }

    return RegisterError;

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

  UpdateError = (function(superClass) {
    extend(UpdateError, superClass);

    function UpdateError(message) {
      this.message = message != null ? message : "Unvalidated update message.";
      this.name = 'UpdateError';
      Error.captureStackTrace(this, UpdateError);
    }

    return UpdateError;

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

  exports.Error = {
    UnknownUser: UnknownUser,
    LoginError: LoginError,
    RegisterError: RegisterError,
    InvalidAccess: InvalidAccess,
    UpdateError: UpdateError,
    UnknownContest: UnknownContest
  };

  exports.findContest = function(user, contestID, include) {
    var Contest;
    Contest = global.db.models.contest;
    return global.db.Promise.resolve().then(function() {
      if (!user) {
        return [];
      }
      return user.getGroups({
        attributes: ['id']
      });
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
              user ? {
                creator_id: user.id
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
        include: include
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

  exports.numberToLetters = function(num) {
    var res;
    if (num === 0) {
      return 'A';
    }
    res = void 0;
    while (num > 0) {
      res = String.fromCharCode(num % 26 + 65) + res;
      num = parseInt(num / 26);
    }
    return res;
  };

}).call(this);

//# sourceMappingURL=utils.js.map
