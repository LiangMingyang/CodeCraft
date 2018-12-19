module.exports = (sequelize, DataTypes) ->
  sequelize.define 'add_login_note', {
    user_id:
      type: DataTypes.INTEGER
      unique: 'user_note'
      allowNull: true
    ip_id:
      type: DataTypes.STRING
      unique: 'user_note'
      allowNull: true
    ip:
      type: DataTypes.STRING
      unique: 'user_note'
      allowNull: true
  }, {
    underscored: true
  }