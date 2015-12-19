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
        type: DataTypes.ENUM('北京航空航天大学', '北航集训队', '北京邮电大学', '-----', '中国地质大学', '北京林业大学', '北京理工大学-软件学院', '北京科技大学', '北京理工大学-计算机学院', '北京师范大学', '北京交通大学', '清华大学'),
        defaultValue: '-----'
      },
      college: {
        type: DataTypes.ENUM('软件学院', '计算机学院', '北京学院', '-----'),
        defaultValue: '-----'
      },
      student_id: {
        type: DataTypes.STRING,
        unique: "nickname"
      },
      phone: {
        type: DataTypes.STRING
      },
      nickname: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: "nickname",
        validate: {
          notEmpty: true
        }
      },
      rating: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 1000
      },
      is_super_admin: {
        type: DataTypes.BOOLEAN,
        defaultValue: false
      },
      last_login: {
        type: DataTypes.DATE
      }
    }, {
      timestamps: false,
      underscored: true
    });
  };

}).call(this);

//# sourceMappingURL=user.js.map
