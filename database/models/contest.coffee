module.exports = (sequelize, DataTypes) ->
  sequelize.define 'contest', {
    title:
      type: DataTypes.STRING
      allowNull: false
      unique: true
      validate:
        notEmpty: true
    description:
      type: DataTypes.TEXT('long')
    start_time:
      type: DataTypes.DATE
      allowNull: false
    end_time:
      type: DataTypes.DATE
      allowNull: false
    access_level:
      type: DataTypes.ENUM('private', 'protect', 'public')
      defaultValue: 'private'
#creator foreign key
#group   foreign key
  }, {
    timestamps: false
    underscored: true
    validate: {
      startBeforeEnd: ->
        if @start_time >= @end_time
          throw new Error('Start time should be before the end of time') #TODO: there is an undefined error
    }
  }