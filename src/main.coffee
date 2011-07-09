#Backbone.Sync = Backbone.localSync

Session = Backbone.Model.extend 
  initialize: (name)->
    set name:name

  getName: ->
    get 'name'

  setName: (name)->
    set name:name

HomeView = Backbone.View.extend 
  initialize: ->
    list = @$("ul")
    list.append $("<li>LOL</li>")

Router = Backbone.Router.extend 
  routes:
    "" : "default"

  default:->
    console.log("Booyah")
    @homeView ?= new HomeView(el:'home')
    @homeView.render()

$ -> 
  router = new Router()
  Backbone.history.start()
