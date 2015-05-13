module.exports = (sequelize, DataTypes) ->
  sequelize.define 'contest', {
    title:
      type: DataTypes.STRING
      allowNull: false
      unique: true
      validate:
        notEmpty: true
    description:
      type: DataTypes.TEXT
    start_time:
      type: DataTypes.DATE
    end_time:
      type: DataTypes.DATE
    access_level:
      type: DataTypes.ENUM('private','protected','public')
      defaultValue: 'private'
#creator foreign key
#group   foreign key
  }, {
    underscored: true
    validate: {
      startBeforeEnd: ->
        if @start_time>=@end_time
          throw new Error('Start time should be before the end of time')
    }
  }