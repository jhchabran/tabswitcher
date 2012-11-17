sortByMatchingScore = (tabs, abbrev)->
  results = []

  for tab in tabs
    [score, indexes] = match(tab.url, abbrev)
    results.push 
      tab:tab
      indexes:indexes
      score:score

  results.sort (a,b)->
    b.score - a.score


match = (string, abbrev)->
  length = string.length


exports.sortByMatchingScore = sortByMatchingScore
exports.match = match

