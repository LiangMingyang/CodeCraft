module.exports = (sequelize, DataTypes) ->
  sequelize.define 'message', {
    content:
      type: DataTypes.TEXT('long')
      allowNull: false
      validate:
        notEmpty: true
  }, {
    underscored: true
  }