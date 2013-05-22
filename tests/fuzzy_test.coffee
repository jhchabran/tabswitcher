f = require '../src/fuzzy'
should = require 'should'

mock_tabs = (urls)->
  tabs = []
  for url in urls
    tabs.push url:url

  tabs

describe "Fuzzy", ->
  describe ".sortByMatchingScore", ->
    it "should not match against url's protocol", ->
      tabs = mock_tabs ["http://foo","http://h_t_t_p.com","http://github.com"]
      results = f.sortByMatchingScore tabs, "http"

      results[0].tab.url.should.eql(tabs[1].url)

    it "should sort tabs by their score", ->
      tabs = mock_tabs ["axxbxxcxx", "axxbxcx", "axbxcx", "abc"]
      results = f.sortByMatchingScore tabs, "abc"

      scores = []
      for result in results
        scores.push result.score

      scores.should.eql(scores.sort (a,b)-> b-a)

  describe ".match", -> 
    data = [
      # Basic
      {url:"abc"                     , hint:"a"   , score:1.0                   , indexes:[0]} ,
      {url:"abc"                     , hint:"abc" , score:3.0                   , indexes:[0   , 1  , 2]}  ,
      {url:"a_bc"                    , hint:"abc" , score:2.75                  , indexes:[0   , 2  , 3]}  ,
      {url:"ab_c"                    , hint:"abc" , score:2.75                  , indexes:[0   , 1  , 3]}  ,
      {url:"a_bc"                    , hint:"abc" , score:2.75                  , indexes:[0   , 2  , 3]}  ,
      {url:"a_b_c"                   , hint:"abc" , score:2.6                   , indexes:[0   , 2  , 4]}  ,
      {url:"a__b_c"                  , hint:"abc" , score:2.5                   , indexes:[0   , 3  , 5]}  ,
      {url:"__a__b__c__"             , hint:"abc" , score:1+(9/11*2)            , indexes:[2   , 5  , 8]}  ,

      # Non matching
      {url:"abc"                     , hint:"acb" , score:0                     , indexes:[]}  ,
      {url:"__a__b__c"               , hint:"acb" , score:0                     , indexes:[]}  ,
      {url:"a__b_c"                  , hint:"def" , score:0                     , indexes:[]}  ,

      # Pick the right match
      {url:"abc__a_b_c"              , hint:"abc" , score:3.0                   , indexes:[0   , 1  , 2]}  ,
      {url:"a__b__c__abc"            , hint:"abc" , score:3.0                   , indexes:[9   , 10 , 11]} ,
      {url:"abc__a_b_c_"             , hint:"abc" , score:3.0                   , indexes:[0   , 1  , 2]}  ,
      {url:"a__b__c__a_b_c_"         , hint:"abc" , score:(1.0+14/15.0+14/15.0) , indexes:[9   , 11 , 13]} ,
      {url:"a__b__c__a_b_c_abc"      , hint:"abc" , score:3.0                   , indexes:[15  , 16 , 17]} ,

      {url:"a__b__c__abc_a_b_c"      , hint:"abc" , score:3.0                   , indexes:[9   , 10 , 11]} ,
      {url:"a___b__c__a__b__c_a_b_c" , hint:"abc" , score:(1+22/23.0+22/23.0)   , indexes:[18  , 20 , 22]} ,
    ]

    for d in data
      r = f.match(d.url, d.hint)

      it "should score #{d.score} for #{d.hint} against #{d.url}", ->
        r.score.should.eql(d.score)
      it "should find indexes #{d.indexes} for #{d.hint} against #{d.url}", ->
        r.indexes.should.eql(d.indexes)
