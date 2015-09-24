module.exports = (sequelize, DataTypes) ->
  sequelize.define 'issue', {
    content:
      type: DataTypes.TEXT('long')
      allowNull: false
      validate:
        notEmpty: true
    access_level:
      type: DataTypes.ENUM('private', 'protect', 'public')
      defaultValue: 'private'
  }, {
    timestamps: false
    underscored: true
  }