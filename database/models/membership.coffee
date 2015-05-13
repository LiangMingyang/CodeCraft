module.exports = (sequelize, DataTypes) ->
  sequelize.define 'membership', {
    access_level:
      type: DataTypes.ENUM('member','admin','owner')
      defaultValue: 'member'
      allowNull: false
  }, {
    underscored: true
  }