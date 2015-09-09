// Generated by CoffeeScript 1.9.3
(function() {
  module.exports = function(sequelize, DataTypes) {
    return sequelize.define('group', {
      name: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        validate: {
          notEmpty: true
        }
      },
      description: {
        type: DataTypes.TEXT('long')
      },
      access_level: {
        type: DataTypes.ENUM('verifying', 'private', 'protect', 'public'),
        defaultValue: 'verifying',
        allowNull: false
      }
    }, {
      timestamps: false,
      underscored: true
    });
  };

}).call(this);

//# sourceMappingURL=group.js.map
