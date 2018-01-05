module.exports = (sequelize, DataTypes) ->
  sequelize.define 'solution', {
    title:
      type: DataTypes.STRING
      allowNull: false
      validate:
        notEmpty: true
    access_level:
      type: DataTypes.STRING
      defaultValue: 'private'
    content:
      type: DataTypes.TEXT('long')
      allowNull: false
    source:
      type: DataTypes.TEXT('long')
      allowNull: false
    secret_limit:
      type: DataTypes.DATE
    category:                   #用户对于题目的分类
      type: DataTypes.STRING
    user_tag:                   #用户的自定义标签
      type: DataTypes.STRING
    practice_time:             #用户的做题时间
      type: DataTypes.INTEGER
    score:            #用户对题目质量的评价
      type: DataTypes.INTEGER
    influence:            #用户自我评价题目对自己的影响
      type: DataTypes.INTEGER
    tag_1:                   #用户打的标签1
      type: DataTypes.STRING
    tag_2:                   #用户打的标签2
      type: DataTypes.STRING
    tag_3:                   #用户打的标签3
      type: DataTypes.STRING
    #creator foreign key
    #group   foreign key
  }, {
    underscored: true
  }
