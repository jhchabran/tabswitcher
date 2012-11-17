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

      result = f.sortByMatchingScore tabs, "http"

      expect(result[0].tab.url).toEqual(tabs[1].url)

    it "should sort tabs by their score", ->
      throw "fail"

