module.exports = (sequelize, DataTypes) ->
  sequelize.define 'group', {
    name:
      type: DataTypes.STRING
      allowNull: false
      unique: true
      validate:
        notEmpty: true
    description:
      type: DataTypes.TEXT
    #creator get user_id from membership
    #access_level is public
  }, {
    underscored: true
  }