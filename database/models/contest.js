// Generated by CoffeeScript 1.10.0
(function() {
  module.exports = function(sequelize, DataTypes) {
    return sequelize.define('contest', {
      title: {
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
      start_time: {
        type: DataTypes.DATE,
        allowNull: false
      },
      end_time: {
        type: DataTypes.DATE,
        allowNull: false
      },
      access_level: {
        type: DataTypes.ENUM('private', 'protect', 'public'),
        defaultValue: 'private'
      }
    }, {
      underscored: true,
      validate: {
        startBeforeEnd: function() {
          if (this.start_time >= this.end_time) {
            throw new Error('Start time should be before the end of time');
          }
        }
      }
    });
  };

}).call(this);

//# sourceMappingURL=contest.js.map
