module.exports = (sequelize, DataTypes) ->
  sequelize.define 'submission_code', {
    content:
      type: DataTypes.STRING
      allowNull: false
  }, {
    underscored: true
  }