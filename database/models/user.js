// Generated by CoffeeScript 1.9.3
(function() {
  module.exports = function(sequelize, DataTypes) {
    return sequelize.define('user', {
      username: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        validate: {
          isEmail: true
        }
      },
      password: {
        type: DataTypes.STRING,
        allowNull: false
      },
      description: {
        type: DataTypes.TEXT('long')
      },
      school: {
        type: DataTypes.ENUM('北京航空航天大学', '北京邮电大学', '-----'),
        defaultValue: '-----'
      },
      college: {
        type: DataTypes.ENUM('软件学院', '计算机学院', '-----'),
        defaultValue: '-----'
      },
      student_id: {
        type: DataTypes.STRING
      },
      nickname: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        validate: {
          notEmpty: true
        }
      },
      is_super_admin: {
        type: DataTypes.BOOLEAN,
        defaultValue: false
      },
      last_login: {
        type: DataTypes.DATE
      }
    }, {
      underscored: true
    });
  };

}).call(this);

//# sourceMappingURL=user.js.map
