// Generated by CoffeeScript 1.9.2
(function() {
  var InvalidAccess, LoginError, RegisterError, UnknownUser, UpdateError,
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

  exports.Error = {
    UnknownUser: UnknownUser,
    LoginError: LoginError,
    RegisterError: RegisterError,
    InvalidAccess: InvalidAccess,
    UpdateError: UpdateError
  };

  exports.findContests = function(req) {
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
      return user.getGroups();
    }).then(function(groups) {
      var adminGroups, group, normalGroups;
      normalGroups = (function() {
        var i, len, results;
        results = [];
        for (i = 0, len = groups.length; i < len; i++) {
          group = groups[i];
          if (group.membership.access_level !== 'verifying') {
            results.push(group.id);
          }
        }
        return results;
      })();
      adminGroups = (function() {
        var i, len, ref, results;
        results = [];
        for (i = 0, len = groups.length; i < len; i++) {
          group = groups[i];
          if ((ref = group.membership.access_level) === 'owner' || ref === 'admin') {
            results.push(group.id);
          }
        }
        return results;
      })();
      return Contest.findAll({
        where: {
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
      });
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
      return user.getGroups();
    }).then(function(groups) {
      var adminGroups, group, normalGroups;
      normalGroups = (function() {
        var i, len, results;
        results = [];
        for (i = 0, len = groups.length; i < len; i++) {
          group = groups[i];
          if (group.membership.access_level !== 'verifying') {
            results.push(group.id);
          }
        }
        return results;
      })();
      adminGroups = (function() {
        var i, len, ref, results;
        results = [];
        for (i = 0, len = groups.length; i < len; i++) {
          group = groups[i];
          if ((ref = group.membership.access_level) === 'owner' || ref === 'admin') {
            results.push(group.id);
          }
        }
        return results;
      })();
      return Contest.findAll({
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

}).call(this);

//# sourceMappingURL=utils.js.map
