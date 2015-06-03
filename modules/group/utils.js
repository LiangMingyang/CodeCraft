// Generated by CoffeeScript 1.9.2
(function() {
  var UnknownUser,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  UnknownUser = (function(superClass) {
    extend(UnknownUser, superClass);

    function UnknownUser(message) {
      this.message = message != null ? message : "Unknown user, please login first";
      this.name = 'UnknownUser';
      Error.captureStackTrace(this, UnknownUser);
    }

    return UnknownUser;

  })(Error);

  exports.Error = {
    UnknownUser: UnknownUser
  };

  exports.findGroups = function(user, include) {
    var Group, currentUser;
    Group = global.db.models.group;
    currentUser = void 0;
    return global.db.Promise.resolve().then(function() {
      if (!user) {
        return [];
      }
      currentUser = user;
      return user.getGroups();
    }).then(function(groups) {
      var group, normalGroups;
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
      return Group.findAll({
        where: {
          $or: [
            {
              access_level: ['public', 'protect']
            }, {
              id: normalGroups
            }
          ]
        },
        include: include
      });
    });
  };

  exports.findGroup = function(user, groupID, include) {
    var Group, currentUser;
    Group = global.db.models.group;
    currentUser = void 0;
    return global.db.Promise.resolve().then(function() {
      if (!user) {
        return [];
      }
      currentUser = user;
      return user.getGroups();
    }).then(function(groups) {
      var group, normalGroups;
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
      return Group.find({
        where: {
          $and: [
            {
              id: groupID
            }, {
              $or: [
                {
                  access_level: ['public', 'protect']
                }, {
                  id: normalGroups
                }
              ]
            }
          ]
        },
        include: include
      });
    });
  };

}).call(this);

//# sourceMappingURL=utils.js.map
