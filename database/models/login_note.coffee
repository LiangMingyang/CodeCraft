module.exports = (sequelize, DataTypes) ->
  sequelize.define 'login_note', {
    user_id:
      type: DataTypes.INTEGER
      unique: 'user_note'
      allowNull: false
    ip_id:
      type: DataTypes.STRING
      unique: 'user_note'
      allowNull: false
  }, {
    underscored: true
  }