module.exports = (sequelize, DataTypes) ->
  sequelize.define 'problem_tag', {
  }, {
    timestamps: false
    underscored: true
  }