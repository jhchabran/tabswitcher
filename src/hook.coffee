# fuzzy algorithm
# TODO : add callbacks to highlight matches
# TODO : weight differently occurences depending if they 
#        are in domain, path or even GET parameters
fuzzy = (tabs, hint)-> 
  results = [] 
  return tabs if hint == ''
  
  for tab in tabs 
    matches = []
    offset = 0
    for i in [0..hint.length-1]
      for j in [offset..tab.url.length-1] 
        if hint.charAt(i) == tab.url.charAt(j)
          offset = j
          matches.push offset
          break
      break if j == tab.url.length - 1 and j != offset
    results.push tab if matches.length == hint.length

  results 

class TabView
  constructor: (tab)->
    @tab = tab

  render: ->
    "<li>#{@tab.url}</li>"

class TabListView
  constructor: (element) -> 
    @element_ = element

  element: ->
    @element_

  render: ->
    @element().empty()
    for tabView in @tabViews then @element().append tabView.render()

  update: (tabs)->
    @tabViews = for tab in tabs then new TabView(tab)
    @render()

class Application
  constructor: ->
    @injectView()

    @element().find('input').keyup (event)=>
      @onInput(event)

    @tabListView = new TabListView @element().find('ul')

  element: ->
    @element_ ||= $('#tabswitcher-overlay')

  tabs: -> 
    @tabs_

  onInput: (event)->
    candidates = fuzzy(@tabs(), event.target.value)

    @tabListView.update candidates

    if event.keyCode == 13
      @switchTab candidates[0] if candidates?

  hide: ->
    @element().hide()

  show: ->
    @tabListView.update @tabs()

    @element().show()
    @element().find('input').focus()

  switchTab: (tab)->  
    @hide()
    chrome.extension.sendRequest(message:"switchTab", target:tab)

  hotKeyListener: (event)->
    if event.keyCode
      if event.ctrlKey && event.keyCode == 220 # Ctrl + \
        chrome.extension.sendRequest {message: "getTabs"}, 
          (response)=>
            @tabs_ = response.tabs
            @show()

      else if event.keyCode == 27 # ESC
        @hide()

  injectView: ->
    $('body').append("<div id='tabswitcher-overlay' style='display:none'></div>")
    @element() 
      .append("<div id='box'><input type='text'></input><div id='results'><ul></ul></div></div>")
    

    

app = new Application()

window.addEventListener("keyup", (e)->
  app.hotKeyListener(e)
,false)
