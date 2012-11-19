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

match = (string, abbrev, offset)->
  score = 0.0
  count = 0
  index = 0
  offset ||= 0
  match_indexes = []
  next_match = undefined

  for i in [0..string.length-1]
    if index < abbrev.length
      for j in [index..abbrev.length-1]
        if string.charAt(i) == abbrev.charAt(j)
          # Last match in s
          index = i+1

          # Remember matches in the s
          match_indexes.push i + offset 

          # Lower the score as far the last match is
          score += (string.length - count)/string.length

          count = 0

          # We found a match, we iterate to the next char in the string
          break
        else
          count++ if j > 0

    # If we find another possible match, compute its score
    if j != 0 && string.charAt(i) == abbrev.charAt(0) && !next_match
      next_match = match(string[i..string.length], abbrev, offset + i)


  if next_match? && next_match.score > score
    next_match
  else
    {score:score, indexes:match_indexes}

exports.sortByMatchingScore = sortByMatchingScore
exports.match = match

