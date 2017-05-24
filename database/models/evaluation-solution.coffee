module.exports = (sequelize, DataTypes) ->
  sequelize.define 'solution', {
    score:            #用户对题解质量的评价
      type: DataTypes.INTEGER
#creator foreign key
#group   foreign key
  }, {
    underscored: true
  }
