module.exports = (sequelize, DataTypes) ->
  sequelize.define 'issue', {
    title:
      type: DataTypes.STRING
      allowNull: false
      validate:
        notEmpty: true
    content:
      type: DataTypes.TEXT('long')
      allowNull: false
      #defaultValue: 'RT'
      validate:
        notEmpty: true
    access_level:
      type: DataTypes.ENUM('private', 'protect', 'public')
      defaultValue: 'private'
  }, {
    underscored: true
  }