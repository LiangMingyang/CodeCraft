module.exports = (sequelize,DataTypes) ->
  sequelize.define 'solution_tag', {
    tag_id:
      type: DataTypes.INTEGER
      unique:'tag_solution'
      allowNull: false
    solution_id:
      type: DataTypes.INTEGER
      unique:'tag_solution'
      allowNull: false
    weight:
      type: DataTypes.FLOAT
      allowNull: true
  }, {
    underscored: true
  }