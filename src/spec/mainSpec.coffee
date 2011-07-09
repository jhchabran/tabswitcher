describe "WorkUnits", ->
  it "should be working", -> 
    expect(true).toEqual(true)

  describe "Session", ->
    beforeEach ->
      @session = new Session()
      @session.setName("opensource")

    it "should have a name", ->
      expect(@session.getName()).toEqual('opensource')

    it "should set a name", ->
      @session.setName("private")
      expect(@session.getName()).toEqual('private')
