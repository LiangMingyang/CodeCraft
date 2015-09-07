module.exports = (sequelize, DataTypes) ->
  sequelize.define 'problem', {
    title:
      type: DataTypes.STRING
      allowNull: false
      unique: true
      validate:
        notEmpty: true
    access_level:
      type: DataTypes.ENUM('private', 'protect', 'public')
      defaultValue: 'private'
    description:
      type: DataTypes.TEXT('long')
      allowNull: false
    test_setting:
      type: DataTypes.TEXT('long')
      allowNull: false
  #creator foreign key
  #group   foreign key
  }, {
    underscored: true
  }
