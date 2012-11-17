removeProtocol = (url)->
  offset = url.indexOf '//'
  url[offset+2..url.length-1]

sortByMatchingScore = (tabs, abbrev)->
  results = []

  for tab in tabs
    info = match(removeProtocol(tab.url), abbrev)

    if info?
      info.tab = tab
      results.push info

  results.sort (a,b)->
    b.score - a.score

  results

match = (string, abbrev)->
  score = 0.0
  count = 0
  offset = 0
  indexes = []

  for i in [0..abbrev.length-1]
    for j in [offset..string.length-1]
      if abbrev.charAt(i) == string.charAt(j)
        # Last match in string
        offset = j+1

        # Remember matches in the string
        indexes.push j

        # Lower the score as far the last match is
        score += (string.length - count)/string.length

        count = 0

        break
      else
        count++ if i > 0

  return {
    score:score
    indexes:indexes
  }


exports.sortByMatchingScore = sortByMatchingScore
exports.match = match

