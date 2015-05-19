module.exports = (sequelize, DataTypes) ->
  sequelize.define 'submission', {
  #submit_code
    lang:
      type: DataTypes.ENUM('c++', 'c', 'python', 'java')
      allowNull: false
      defaultValue: 'c++'
    result:
      type: DataTypes.ENUM('WT', 'JG', 'AC', 'WA', 'TLE', 'MLE', 'RE', 'CE') #TODO:参考李子星大神的论文
      allowNull: false
      defaultValue: 'WT'
    time_cost:
      type: DataTypes.INTEGER
    memory_cost:
      type: DataTypes.INTEGER
    detail:
      type: DataTypes.TEXT
  }, {
    underscored: true
  }