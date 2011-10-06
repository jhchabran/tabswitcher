class TabSwitcher 
  constructor: ->
    $('body').append("<div id='tabswitcher-overlay' style='display:none'></div>")
    $('#tabswitcher-overlay')
      .append("<div id='box'><input type='text'></input><div id='results'></div></div>")

    @overlayElement().find('input').keyup (event)=>
      if event.keyCode == 13
        @switchTab @candidates[0] if @candidates?
      else
        @candidates = @fuzzy(event.target.value)
        @displayTabs @candidates

  show: ->
    @overlayElement().show()
    @overlayElement().find('input').focus()

  overlayElement: ->
    $('#tabswitcher-overlay')

  displayTabs: (tabs)->
    @overlayElement().find('ul').remove()
    @overlayElement().find('#results').append '<ul></ul>'

    ul = $('#tabswitcher-overlay #box #results ul')

    for tab in tabs 
      ul.append("<li>#{tab.url}</li>")

  fuzzy: (hint)->
    results = [] 
    return @tabs if hint == ''
    
    for tab in @tabs 
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
    
  switchTab: (tab)->  
    chrome.extension.sendRequest(message:"switchTab", target:tab)
    @hideOverlay()

  hideOverlay: ->
    @overlayElement().hide()

  keyListener: (e)->
    if e.keyCode 
      if e.ctrlKey && e.keyCode == 220
        chrome.extension.sendRequest {message: "getTabs"}, 
          (response)=>
            @tabs = response.tabs
            @displayTabs(@tabs)
            @show()
      else if e.keyCode == 27
        @hideOverlay()

tabSwitcher = new TabSwitcher()

window.addEventListener("keyup", (e)->
  tabSwitcher.keyListener(e)
,false)
