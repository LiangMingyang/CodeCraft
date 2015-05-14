module.exports = (sequelize, DataTypes) ->
  sequelize.define 'membership', {
    access_level:
      type: DataTypes.ENUM('verifying','member','admin','owner')
      defaultValue: 'verifying'
      allowNull: false
  }, {
    underscored: true
  }