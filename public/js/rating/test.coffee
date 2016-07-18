teamName = [
  "TheWaySoFar"
, "Damocles"
, "undetermined"
, "TDL"
, "LovelyDonuts"
, "NewBeer"
, "TheThreeMusketeers"
, "I-PPPei+"
, "Prometheus"
, "Nostalgia"
, "Time After Time"
, "TriMusketeers"
, "null"
, "Unknown"
]
contests = [
  [0, 2, 1, 4, 3, 5, 6, 12, 8, 11, 7, 9, 10, 13]
,
  [0, 5, 7, 6, 3, 1, 2, 8, 12, 9, 4, 11, 10, 13]
]

ranks = []
for i in [0...contests.length]
  rank = (0 for team in teamName)
  for team,j in contests[i]
    rank[team] = j+1
  ranks.push rank
build = require('./main')
console.log build(ranks,teamName)