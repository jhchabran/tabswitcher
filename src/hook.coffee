OVERLAY_HTML= """
  <div id='tabswitcher-overlay' style="display:none">
    <div id="box">
      <input type="text"></input>
      <div id="results">
        <ul></ul>
      </div>
    </div>
  </div>
"""

# fuzzy algorithm
# TODO : weight differently occurences depending if they
#        are in domain, path or even GET parameters
fuzzy = (tabs, hint)->
  results = []
  return tabs if hint == ''

  for tab in tabs
    urlMatches = []
    titleMatches = []

    # Set offset to the first letter of the domain, ignoring procotol
    offset = tab.url.indexOf '/'

    for i in [0..hint.length-1]
      for j in [offset..tab.url.length-1]
        if hint.charAt(i).toLowerCase() == tab.url.charAt(j).toLowerCase()
          offset = j
          urlMatches.push offset
          break
      break if j == tab.url.length - 1 and j != offset

    offset = 0
    for i in [0..hint.length-1]
      for j in [offset..tab.title.length-1]
        if hint.charAt(i).toLowerCase() == tab.title.charAt(j).toLowerCase()
          offset = j
          titleMatches.push offset
          break
      break if j == tab.title.length - 1 and j != offset

    result = {tab:tab}
    result.urlMatches   = urlMatches
    result.titleMatches = titleMatches

    results.push result if (urlMatches.length == hint.length || titleMatches.length == hint.length)

  results

class TabView
  constructor: (tab, urlMatches, titleMatches)->
    @tab = tab
    @urlMatches = urlMatches
    @titleMatches = titleMatches

  render: ->
    matchIndex = 0

    html = '<li>'
    html += "<img class='favicon' src='#{@tab.favIconUrl}'></img>" if @tab.favIconUrl?

    html+= '<span class="title">'
    for i in [0..@tab.title.length]
      if @titleMatches? and @titleMatches[matchIndex] == i
        html += "<b>#{@tab.title.charAt(i)}</b>"
        matchIndex++
      else
        html += @tab.title.charAt(i)
    html+= '</span>'
    html+= '<span class="url">'
    matchIndex = 0
    for i in [0..@tab.url.length]
      if @urlMatches? and @urlMatches[matchIndex] == i
        html += "<b>#{@tab.url.charAt(i)}</b>"
        matchIndex++
      else
        html += @tab.url.charAt(i)
    html+= '</span><div class="both"></div>'
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
    @tabViews = for candidate in candidates then new TabView(candidate.tab or candidate, candidate.urlMatches,candidate.titleMatches)
    @render()

class Application
  constructor: (config)->
    @config_ = config
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

  isKeyboardEventMatching: (event)->
    console.log event
    console.log @config_

    event.ctrlKey    == @config_.ctrlKey  &&
      event.altKey   == @config_.altKey   &&
      event.shiftKey == @config_.shiftKey &&
      event.metaKey  == @config_.metaKey  &&
      event.keyCode  == @config_.keyCode

  hotKeyListener: (event)->
    if event.keyCode?
      if @isKeyboardEventMatching(event)
        chrome.extension.sendRequest message: "getTabs", (response)=>
          @tabs_ = response.tabs
          @show()

      else if event.keyCode == 27 # ESC
        @hide()

  injectView: ->
    $('body').append(OVERLAY_HTML)

chrome.extension.sendRequest message:"requestConfig", (response)->
  app = new Application(response.config)

  window.addEventListener("keyup", (e)->
    app.hotKeyListener(e)
  ,false)
