f = require '../src/fuzzy'

mock_tabs = (urls)->
  tabs = []
  for url in urls
    tabs.push url:url

  tabs

describe "Fuzzy tab matcher", ->
  describe "#sortByMatchingScore", ->
    it "should not match against url's protocol", ->
      tabs = mock_tabs ["http://foo","http://h_t_t_p.com","http://github.com"]
      results = f.sortByMatchingScore tabs, "http"

      expect(results[0].tab.url).toEqual(tabs[1].url)

    it "should sort tabs by their score", ->
      tabs = mock_tabs ["axxbxxcxx", "axxbxcx", "axbxcx", "abc"]
      results = f.sortByMatchingScore tabs, "abc"

      scores = []
      for result in results
        scores.push result.score

      expect(scores).toEqual(scores.sort (a,b)-> b-a)

  describe "#match", -> 
    data = [
      {url:"abc"   , hint:"a"   , score:1.0  , indexes:[0]} ,
      {url:"abc"   , hint:"abc" , score:3.0  , indexes:[0   , 1 , 2]} ,
      {url:"a_bc"  , hint:"abc" , score:2.75 , indexes:[0   , 2 , 3]} ,
      {url:"ab_c"  , hint:"abc" , score:2.75 , indexes:[0   , 1 , 3]} ,
      {url:"ab_c"  , hint:"abc" , score:2.75 , indexes:[0   , 1 , 3]} ,
      {url:"a_b_c" , hint:"abc" , score:2.6  , indexes:[0   , 2 , 4]} ,
      {url:"a__b_c" , hint:"abc" , score:2.5  , indexes:[0  , 3 , 5]} ,
    ]

    # Jasmine seems to have an issue with nesting it blocks inside for loops
    # the iterator doesn't change, until then here it is, unrolled.

    hack = (i)->
      r = f.match(data[i].url, data[i].hint)

      expect(r.score).toEqual(data[i].score)
      expect(r.indexes).toEqual(data[i].indexes)

    it "scores #{data[0].score} when matching '#{data[0].url}' with '#{data[0].hint}', indexes being [#{data[0].indexes}]", ->
      hack(0)
    it "scores #{data[1].score} when matching '#{data[1].url}' with '#{data[1].hint}', indexes being [#{data[1].indexes}]", ->
      hack(1)
    it "scores #{data[2].score} when matching '#{data[2].url}' with '#{data[2].hint}', indexes being [#{data[2].indexes}]", ->
      hack(2)
    it "scores #{data[3].score} when matching '#{data[3].url}' with '#{data[3].hint}', indexes being [#{data[3].indexes}]", ->
      hack(3)
    it "scores #{data[4].score} when matching '#{data[4].url}' with '#{data[4].hint}', indexes being [#{data[4].indexes}]", ->
      hack(4)
    it "scores #{data[5].score} when matching '#{data[5].url}' with '#{data[5].hint}', indexes being [#{data[5].indexes}]", ->
      hack(5)
    it "scores #{data[6].score} when matching '#{data[6].url}' with '#{data[6].hint}', indexes being [#{data[6].indexes}]", ->
      hack(6)
