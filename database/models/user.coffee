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
      type: DataTypes.TEXT
    school:
      type: DataTypes.ENUM('北京航空航天大学', '北京邮电大学', '-----')
      defaultValue: '-----'
    college:
      type: DataTypes.ENUM('软件学院', '计算机学院', '-----')
      defaultValue: '-----'
    student_id:
      type: DataTypes.STRING
    nickname:
      type: DataTypes.STRING
      allowNull: false
      unique: true
      validate:
        notEmpty: true
    is_super_admin:
      type: DataTypes.BOOLEAN
      defaultValue: false
    last_login:
      type: DataTypes.DATE
  }, {
    underscored: true
  }