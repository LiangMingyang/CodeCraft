module.exports = (sequelize, DataTypes) ->
  sequelize.define 'issue', {
    content:
      type: DataTypes.STRING
      allowNull: false
      validate:
        notEmpty: true
  }, {
    underscored: true
  }