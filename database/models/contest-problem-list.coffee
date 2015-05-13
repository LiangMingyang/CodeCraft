module.exports = (sequelize, DataTypes) ->
  sequelize.define 'contest_problem_list', {
    score:
      type: DataTypes.INTEGER
      allowNull: false
      validate:
        min:0
      defaultValue: 1
    #contest
    #problem
  }, {
    underscored: true
  }