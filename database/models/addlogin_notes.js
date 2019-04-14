// Generated by CoffeeScript 1.12.6
(function() {
  module.exports = function(sequelize, DataTypes) {
    return sequelize.define('add_login_note', {
      user_id: {
        type: DataTypes.INTEGER,
        unique: 'user_note',
        allowNull: false
      },
      ip_id: {
        type: DataTypes.STRING,
        unique: 'user_note',
        allowNull: true
      },
      ip: {
        type: DataTypes.STRING,
        unique: 'user_note',
        allowNull: true
      }
    }, {
      underscored: true
    });
  };

}).call(this);

//# sourceMappingURL=addlogin_notes.js.map