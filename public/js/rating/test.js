// Generated by CoffeeScript 1.10.0
(function() {
  var build, contests, i, j, k, l, len, rank, ranks, ref, ref1, team, teamName;

  teamName = ["TheWaySoFar", "Damocles", "undetermined", "TDL", "LovelyDonuts", "NewBeer", "TheThreeMusketeers", "I-PPPei+", "Prometheus", "Nostalgia", "Time After Time", "TriMusketeers", "null", "Unknown"];

  contests = [[0, 2, 1, 4, 3, 5, 6, 12, 8, 11, 7, 9, 10, 13], [0, 5, 7, 6, 3, 1, 2, 8, 12, 9, 4, 11, 10, 13]];

  ranks = [];

  for (i = k = 0, ref = contests.length; 0 <= ref ? k < ref : k > ref; i = 0 <= ref ? ++k : --k) {
    rank = (function() {
      var l, len, results;
      results = [];
      for (l = 0, len = teamName.length; l < len; l++) {
        team = teamName[l];
        results.push(0);
      }
      return results;
    })();
    ref1 = contests[i];
    for (j = l = 0, len = ref1.length; l < len; j = ++l) {
      team = ref1[j];
      rank[team] = j + 1;
    }
    ranks.push(rank);
  }

  build = require('./main');

  console.log(build(ranks, teamName));

}).call(this);

//# sourceMappingURL=test.js.map
