module.exports = (sequelize, DataTypes) ->
  sequelize.define 'submission', {
  #submit_code
    lang:
      type: DataTypes.ENUM('c++', 'c', 'python', 'java')
      allowNull: false
      defaultValue: 'c++'
    result:
      type: DataTypes.ENUM('WT', 'JG', "AC", "WA", "CE", "REG", "MLE", "REP", "PE", "MLE", "TLE", "IFNR", "OFNR", "EFNR", "OE")
      allowNull: false
      defaultValue: 'WT'
    score:
      type: DataTypes.FLOAT
    time_cost:
      type: DataTypes.INTEGER
    memory_cost:
      type: DataTypes.INTEGER
    code_length:
      type: DataTypes.INTEGER
    detail:
      type: DataTypes.TEXT
  }, {
    underscored: true
  }