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

    for d in data
      it "scores #{d.score} when matching '#{d.url}' with '#{d.hint}', indexes being [#{d.indexes}]", ->
        r = f.match(d.url, d.hint)

        expect(r.score).toEqual(d.score)
        expect(r.indexes).toEqual(d.indexes)
