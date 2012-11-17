f = require '../src/fuzzy'

describe "Fuzzy tab matcher", ->
  describe "#sortByMatchingScore", ->
    it "should not match against url's protocol", ->
      tabs = [
        {url:"http://foo"},
        {url:"http://h_t_t_p.com"}
        {url:"http://github.com"}
      ]

      result = f.sortByMatchingScore tabs, "http"

      expect(result[0]).toEqual(tabs[1])

    it "should sort tabs by their score", ->
      throw "fail"

  describe "#match", ->
    it "should be case insensitive", ->
      throw "fail"

    it "should return matching characters indexes", ->
      throw "fail"

    it "should return a score", ->
      throw "fail"
      
