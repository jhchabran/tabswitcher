removeProtocol = (url)->
  offset = url.indexOf '//'
  url[offset+2..url.length-1]

sortByMatchingScore = (tabs, abbrev)->
  results = []
  
  if abbrev == ""
    for tab in tabs
      results.push tab:tab, score:0, match_indexes:[]
  else
    for tab in tabs
      info = match(removeProtocol(tab.url), abbrev)

      if info?
        info.tab = tab
        results.push info if info.score > 0

        results.sort (a,b)->
          b.score - a.score

  results



match = (string, abbrev, offset)->
  score = 0.0
  count = 0
  j = 0
  offset ||= 0
  match_indexes = []
  next_match = undefined

  for i in [0..string.length-1]
    # If we find another possible match, compute its score
    if j != 0 && string.charAt(i) == abbrev.charAt(0) && !next_match
      next_match = match(string[i..string.length], abbrev, offset + i)

    if j < abbrev.length
      if string.charAt(i) == abbrev.charAt(j) 
        # Remember matches in the s
        match_indexes.push i + offset 

        # Lower the score as far the last match is
        score += (string.length + offset - count)/(string.length+offset)

        count = 0

        # We found a match, we iterate 
        j++
      else
        count++ if j > 0

  # We did not find the whole pattern
  if j < abbrev.length
    score = 0.0
    match_indexes = []

  if next_match? && next_match.score > score
    next_match
  else
    {score:score, indexes:match_indexes}

isCommonJS = typeof(window) == "undefined"

if isCommonJS
  exports.match = match
  exports.sortByMatchingScore = sortByMatchingScore
else 
  window.sortByMatchingScore = sortByMatchingScore
  window.removeProtocol = removeProtocol
