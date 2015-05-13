module.exports = (sequelize, DataTypes) ->
  sequelize.define 'submission_code', {
    content:
      type: DataTypes.TEXT
  }, {
    underscored: true
  }