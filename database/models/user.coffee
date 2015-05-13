module.exports = (sequelize, DataTypes) ->
  sequelize.define 'user', {
    username:
      type: DataTypes.STRING
      allowNull: false
      validate:
        isEmail: true  #必须是邮箱
        notEmpty: true #不能为空
    password:
      type: DataTypes.STRING
      allowNull: false
    description:
      type: DataTypes.TEXT
    school:
      type: DataTypes.ENUM('北京航空航天大学','北京邮电大学','-----')
      defaultValue: '-----'
    college:
      type: DataTypes.ENUM('软件工程','计算机科学','-----')
      defaultValue: '-----'
    student_id:
      type: DataTypes.STRING
    nickname:
      type: DataTypes.STRING
    is_super_admin:
      type: DataTypes.BOOLEAN
      defaultValue: false
    last_login:
      type: DataTypes.DATE
  }, {
    underscored: true
  }