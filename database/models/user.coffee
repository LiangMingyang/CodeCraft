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
      type: DataTypes.ENUM('北京航空航天大学', '北京邮电大学', '-----')
      defaultValue: '-----'
    college:
      type: DataTypes.ENUM('软件学院', '计算机学院', '北京学院', '-----')
      defaultValue: '-----'
    student_id:
      type: DataTypes.STRING
    phone:
      type: DataTypes.STRING
    nickname:
      type: DataTypes.STRING
      allowNull: false
      unique: true
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
    timestamps: false
    underscored: true
  }