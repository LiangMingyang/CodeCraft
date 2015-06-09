module.exports = (sequelize, DataTypes) ->
  sequelize.define 'submission_code', {
    content:
      type: DataTypes.TEXT
      allowNull: false
  }, {
    underscored: true
  }