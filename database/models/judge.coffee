module.exports = (sequelize, DataTypes) ->
  sequelize.define 'judge', {
    name:
      type: DataTypes.STRING
      allowNull: false
      unique: true
      validate:
        notEmpty: true
    secret_key:
      type: DataTypes.TEXT
    address:
      type: DataTypes.STRING
      validate:
        isIP: true
  }, {
    timestamps: false
    underscored: true
  }