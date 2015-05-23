module.exports = (sequelize, DataTypes) ->
  sequelize.define 'problem', {
    title:
      type: DataTypes.STRING
      allowNull: false
      unique: true
      validate:
        notEmpty: true
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
