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
  compute = (s, a, index)->
    console.log "-> #{s} vs #{a}, #{index}"
    score = 0.0
    count = 0
    offset = 0
    indexes = []
    next_match = undefined

    for i in [0..s.length-1]
      for j in [offset..a.length-1]
        if s.charAt(i) == a.charAt(j)
          # Last match in s
          offset = i+1

          # Remember matches in the s
          indexes.push i + index

          # Lower the score as far the last match is
          score += (s.length - count)/s.length

          count = 0

          # We found a match, we iterate to the next char in the string
          break
        else
          count++ if j > 0

      # If we find another possible match, compute its score
      if j != 0 && s.charAt(i) == a.charAt(0) && !next_match
        next_match = compute(s[i..s.length], a, i)

    if next_match? && next_match.score > score
      next_match
    else
      {score:score, indexes:indexes}
    
  compute(string,abbrev,0)


exports.sortByMatchingScore = sortByMatchingScore
exports.match = match

