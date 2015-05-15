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
      unique: 'contest_problem_order'
    contest_id:
      type: DataTypes.INTEGER
      unique: 'contest_problem_order'
    problem_id:
      type: DataTypes.INTEGER
      unique: 'contest_problem_order'
    #problem
  }, {
    underscored: true
  }