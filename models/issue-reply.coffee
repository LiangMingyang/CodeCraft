module.exports = (sequelize, DataTypes) ->
  sequelize.define 'issue_reply', {
    content:
      type: DataTypes.STRING
      allowNull: false
      validate:
        notEmpty: true
  }, {
    underscored: true
  }