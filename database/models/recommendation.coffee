module.exports = (sequelize, DataTypes) ->
  sequelize.define 'recommendation', {
    score:
      type: DataTypes.FLOAT
      allowNull: false
      validate:
        min: -100
      defaultValue: 0
    user_id:
      type: DataTypes.INTEGER
      unique: 'user_recommendation_problem'
    problem_id:
      type: DataTypes.INTEGER
      unique: 'user_recommendation_problem'
#problem
  }, {
    timestamps: true
    underscored: true
  }