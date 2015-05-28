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
  #creator foreign key
  #group   foreign key
  }, {
    underscored: true
  }
