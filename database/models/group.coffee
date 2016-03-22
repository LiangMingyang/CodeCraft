module.exports = (sequelize, DataTypes) ->
  sequelize.define 'group', {
    name:
      type: DataTypes.STRING
      allowNull: false
      unique: true
      validate:
        notEmpty: true
    description:
      type: DataTypes.TEXT('long')
    #creator_id
    access_level:
      type: DataTypes.ENUM('verifying', 'private', 'protect', 'public')
      defaultValue: 'verifying'
      allowNull: false
  }, {
    underscored: true
  }