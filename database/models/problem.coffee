module.exports = (sequelize, DataTypes) ->
  sequelize.define 'problem', {
    title:
      type: DataTypes.STRING
      allowNull: false
      unique: true
      validate:
        notEmpty: true
    description:
      type: DataTypes.TEXT
    test_setting: #just a path
      type: DataTypes.STRING
      defaultValue: 'path/to/default/test_setting'
    test_file: #just a path
      type: DataTypes.STRING
    access_level:
      type: DataTypes.ENUM('private', 'protected', 'public')
      defaultValue: 'private'
  #creator foreign key
  #group   foreign key
  }, {
    underscored: true
  }