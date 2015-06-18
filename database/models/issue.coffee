module.exports = (sequelize, DataTypes) ->
  sequelize.define 'issue', {
    content:
      type: DataTypes.STRING
      allowNull: false
      validate:
        notEmpty: true
    access_level:
      type: DataTypes.ENUM('private', 'protect', 'public')
      defaultValue: 'private'
  }, {
    underscored: true
  }