module.exports = (sequelize, DataTypes) ->
  sequelize.define 'user', {
    username:
      type: DataTypes.STRING
      allowNull: false
      unique: true
      validate:
        isEmail: true  #必须是邮箱
    password:
      type: DataTypes.STRING
      allowNull: false
    description:
      type: DataTypes.TEXT('long')
    school:
      type: DataTypes.STRING
      defaultValue: '-----'
    college:
      type: DataTypes.STRING
      defaultValue: '-----'
    student_id:
      type: DataTypes.STRING
      unique: "nickname"
    phone:
      type: DataTypes.STRING
    nickname:
      type: DataTypes.STRING
      allowNull: false
      unique: "nickname"
      validate:
        notEmpty: true
    rating:
      type: DataTypes.INTEGER
      allowNull: false
      defaultValue : 1000
    is_super_admin:
      type: DataTypes.BOOLEAN
      defaultValue: false
    last_login:
      type: DataTypes.DATE
  }, {
    underscored: true
  }