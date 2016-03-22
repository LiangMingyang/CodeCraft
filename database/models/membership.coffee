module.exports = (sequelize, DataTypes) ->
  sequelize.define 'membership', {
    access_level:
      type: DataTypes.ENUM('verifying', 'member', 'admin', 'owner')
      defaultValue: 'verifying'
      allowNull: false
    user_id:
      type: DataTypes.INTEGER
      unique: 'user_group'
    group_id:
      type: DataTypes.INTEGER
      unique: 'user_group'
  }, {
    underscored: true
  }