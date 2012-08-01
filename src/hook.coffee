# fuzzy algorithm
# TODO : weight differently occurences depending if they 
#        are in domain, path or even GET parameters
fuzzy = (tabs, hint)-> 
  results = [] 
  return tabs if hint == ''
  
  for tab in tabs 
    matches = []
    
    # Set offset to the first letter of the domain, ignoring procotol 
    offset = tab.url.indexOf '/'

    for i in [0..hint.length-1]
      for j in [offset..tab.url.length-1] 
        if hint.charAt(i) == tab.url.charAt(j)
          offset = j
          matches.push offset
          break
      break if j == tab.url.length - 1 and j != offset
    results.push {tab:tab, matches:matches} if matches.length == hint.length

  results 

class TabView
  constructor: (tab, urlMatches, titleMatches)->
    @tab = tab
    @urlMatches = urlMatches

  render: ->
    matchIndex = 0

    html = '<li>'
    html += "<img class='favicon' src='#{@tab.favIconUrl}'></img>" if @tab.favIconUrl?

    for i in [0..@tab.url.length]
      if @urlMatches? and @urlMatches[matchIndex] == i
        html += "<b>#{@tab.url.charAt(i)}</b>"
        matchIndex++
      else
        html += @tab.url.charAt(i)

    html += '</li>'

class TabListView
  constructor: (element) -> 
    @element_ = element

  element: ->
    @element_

  render: ->
    @element().empty()
    for tabView in @tabViews then @element().append tabView.render()

  update: (candidates)->
    @tabViews = for candidate in candidates then new TabView(candidate.tab or candidate, candidate.matches)
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
      @switchTab candidates[0].tab if candidates?

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
