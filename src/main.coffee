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
    chrome.windows.getAll populate:true, (windows)-> 
      _.each windows, (w)->
        _.each w.tabs, (t)-> 
          li = $("<li>" + t.url + "</li>")
          list.append $(li)
        
      

window.Router = Backbone.Router.extend 
  routes:
    "" : "default"

  default:->
    @homeView ?= new HomeView(el:'home')
    @homeView.render()

