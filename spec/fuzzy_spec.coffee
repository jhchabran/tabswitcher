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

    tabs = mock_tabs ["axxbxxcxx", "axxbxcx", "axbxcx", "abc"]

    it "should sort tabs by their score", ->
      results = f.sortByMatchingScore tabs, "abc"

      scores = []
      for result in results
        scores.push result.score

      expect(scores).toEqual(scores.sort (a,b)-> b-a)
