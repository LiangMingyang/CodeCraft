module.exports = (sequelize, DataTypes) ->
  sequelize.define 'message', {
    content:
      type: DataTypes.STRING
      allowNull: false
  }, {
    underscored: true
  }