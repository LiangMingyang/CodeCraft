module.exports = (sequelize, DataTypes) ->
  sequelize.define 'issue_reply', {
    content:
      type: DataTypes.TEXT('long')
      allowNull: false
      validate:
        notEmpty: true
  }, {
    underscored: true
  }