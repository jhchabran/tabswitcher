#Backbone.Sync = Backbone.localSync

window.Tab = Backbone.Model.extend
  initialize: ->
    @set url:""

window.Session = Backbone.Model.extend 
  initialize: ->
    @set name:""
  

window.HomeView = Backbone.View.extend 
  initialize: ->
    list = @$("ul")
    chrome.windows.getAll populate:true, (windows)-> 
      window.tmp = windows
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

