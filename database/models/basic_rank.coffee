module.exports = (sequelize, DataTypes) ->
  sequelize.define 'basic_rank', {
    id:
      type: DataTypes.INTEGER
      allowNull: false
      primaryKey: true
      unique: true
    COUNT:
      type: DataTypes.INTEGER
      allowNUll: false
  }, {
    underscored: true,
    freezeTableName: false,
    timestamps: false
  }