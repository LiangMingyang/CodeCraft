module.exports = (sequelize, DataTypes) ->
  sequelize.define 'submission_code', {
    content:
      type: DataTypes.TEXT('long')
      allowNull: false
  }, {
    timestamps: false
    underscored: true
  }