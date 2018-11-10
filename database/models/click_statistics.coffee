module.exports = (sequelize, DataTypes) ->
  sequelize.define 'click_statistics', {
    clickType:
      type: DataTypes.STRING
      allowNull: false
    clickContent:
      type: DataTypes.STRING
      allowNUll: false
    clickUrl:
      type: DataTypes.STRING
      allowNull: false
      unique: true
    clickCount:
      type: DataTypes.INTEGER
      allowNull: true
    appearCount:
      type: DataTypes.INTEGER
      allowNull: true
  }, {
    underscored: true
  }