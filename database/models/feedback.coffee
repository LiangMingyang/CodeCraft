module.exports = (sequelize, DataTypes)->
  sequelize.define 'feedback', {
    title:
      type: DataTypes.TEXT('long')
      allowNull: false
      validate:
        notEmpty: true
    content:
      type: DataTypes.TEXT('long')
      allowNull: false
  }, {
    underscored: true
  }