// Generated by CoffeeScript 1.9.3
(function() {
  module.exports = function(sequelize, DataTypes) {
    return sequelize.define('submission', {
      lang: {
        type: DataTypes.ENUM('c++', 'c', 'python', 'java'),
        allowNull: false,
        defaultValue: 'c++'
      },
      result: {
        type: DataTypes.ENUM('WT', 'JG', 'AC', 'WA', 'TLE', 'MLE', 'RE', 'CE', 'PE', 'ERR'),
        allowNull: false,
        defaultValue: 'WT'
      },
      score: {
        type: DataTypes.FLOAT
      },
      time_cost: {
        type: DataTypes.INTEGER
      },
      memory_cost: {
        type: DataTypes.INTEGER
      },
      code_length: {
        type: DataTypes.INTEGER
      },
      detail: {
        type: DataTypes.TEXT
      }
    }, {
      underscored: true
    });
  };

}).call(this);

//# sourceMappingURL=submission.js.map
