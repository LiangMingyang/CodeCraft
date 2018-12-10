module.exports = (sequelize, DataTypes) ->
  sequelize.define 'exam_user', {
    username:
      type: DataTypes.STRING
      allowNull: false
      unique: true
      validate:
        isEmail: true  #必须是邮箱
    password:
      type: DataTypes.STRING
      allowNull: false
    user_id:
      type: DataTypes.INTEGER
      allowNull: true
  }, {
    underscored: true
  }