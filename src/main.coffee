#Backbone.Sync = Backbone.localSync

window.Session = Backbone.Model.extend 
  initialize: ->
    @set name:""

  getName: ->
    @get 'name'

  setName: (name)->
    @set name:name

window.HomeView = Backbone.View.extend 
  initialize: ->
    list = @$("ul")
    list.append $("<li>LOL</li>")

window.Router = Backbone.Router.extend 
  routes:
    "" : "default"

  default:->
    console.log("Booyah")
    @homeView ?= new HomeView(el:'home')
    @homeView.render()

