module.exports = (sequelize, DataTypes) ->
  sequelize.define 'contest_problem_list', {
    score:
      type: DataTypes.INTEGER
      allowNull: false
      validate:
        min:0
      defaultValue: 1
    order:
      type: DataTypes.INTEGER
      allowNull: false
      validate:
        min:0
      defaultValue: 0
    #contest
    #problem
  }, {
    underscored: true
  }