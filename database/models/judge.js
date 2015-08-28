// Generated by CoffeeScript 1.9.3
(function() {
  module.exports = function(sequelize, DataTypes) {
    return sequelize.define('judge', {
      name: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        validate: {
          notEmpty: true
        }
      },
      secret_key: {
        type: DataTypes.TEXT
      },
      address: {
        type: DataTypes.STRING,
        validate: {
          isIP: true
        }
      }
    }, {
      underscored: true
    });
  };

}).call(this);

//# sourceMappingURL=judge.js.map
