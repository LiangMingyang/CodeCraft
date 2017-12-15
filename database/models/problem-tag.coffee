module.exports = (sequelize,DataTypes) ->
  sequelize.define 'problem_tag', {
    tag_id:
      type: DataTypes.INTEGER
      unique:'tag_problem'
      allowNull: false
    problem_id:
      type: DataTypes.INTEGER
      unique:'tag_problem'
      allowNull: false
    weight:
      type: DataTypes.INTEGER
      allowNull: true
  }, {
    underscored: true
  }