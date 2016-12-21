module.exports = (sequelize, DataTypes) ->
  sequelize.define 'solution', {
    title:
      type: DataTypes.STRING
      allowNull: false
      validate:
        notEmpty: true
    access_level:
      type: DataTypes.STRING
      defaultValue: 'private'
    content:
      type: DataTypes.TEXT('long')
      allowNull: false
    source:
      type: DataTypes.TEXT('long')
      allowNull: false
#creator foreign key
#group   foreign key
  }, {
    underscored: true
  }
