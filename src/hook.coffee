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
class TabView
  constructor: (tab, indexes)->
    @tab = tab
    @url = removeProtocol(@tab.url) 
    @indexes = indexes

  render: ->
    html = '<li>'
    html += "<img class='favicon' src='#{@tab.favIconUrl}'></img>" if @tab.favIconUrl?

    html+= '<span class="title">'
    html+= @tab.title
    html+= '</span>'

    html+= '<div class="url">'
    j = 0
    for i in [0..@url.length]
      if @indexes? && @indexes[j] == i
        html += "<b>#{@url.charAt(i)}</b>"
        j++
      else
        html += @url.charAt(i)

    html+= '</div></div>'
    html+= '</li>'

class TabListView
  constructor: (element) ->
    @element_ = element

  element: ->
    @element_

  render: ->
    @element().empty()
    for tabView in @tabViews then @element().append tabView.render()

  update: (candidates)->
    @tabViews = for candidate in candidates 
      new TabView(candidate.tab or candidate, candidate.indexes)

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
    candidates = sortByMatchingScore(@tabs(), event.target.value)

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
