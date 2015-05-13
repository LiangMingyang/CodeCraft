module.exports = (sequelize, DataTypes) ->
  sequelize.define 'group', {
    name:
      type: DataTypes.STRING
      allowNull: false
      validate:
        notEmpty: true
    description:
      type: DataTypes.TEXT
    #creator get user_id from membership
  }, {
    underscored: true
  }