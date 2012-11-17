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
  length = string.length

  compute = (string, abbrev)->
    console.log "going for #{string} with #{abbrev}"
    score = 0.0
    count = 0
    offset = 0
    indexes = []

    for i in [0..length-1]
      for j in [offset..abbrev.length-1]
        if string.charAt(i) == abbrev.charAt(j)
          # Last match in hint
          offset = j

          # Remember matches in the string
          indexes.push i

          # Lower the score as far the last match is
          score += (length - count)/length

          count = 0

          break
        else
          count++ if j > 0

    return {
      score:score
      indexes:indexes
    }

  compute(string, abbrev)

exports.sortByMatchingScore = sortByMatchingScore
exports.match = match

