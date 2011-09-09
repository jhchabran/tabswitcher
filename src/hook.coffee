class TabSwitcher 
  constructor: ->
    $('body').append("<div id='tabswitcher-overlay' style='display:none'></div>")
    $('#tabswitcher-overlay')
      .css
        position:'fixed',
        width:'100%',
        height:'100%',
        top:0,
        left:0,
        background: 'rgba(0,0,0,0.8)'
      .append("<div id='box'> <input type='text'></input></div>")
      .append("<div id='results'></div>")

  show: ->
    @overlayElement().show()
    @overlayElement().find('input').focus()

  overlayElement: ->
    $('#tabswitcher-overlay')

  updateTabs: (tabs)->
    @tabs = tabs

    @overlayElement().find('ul').remove()
    @overlayElement().find('#results').append '<ul></ul>'

    ul = $('#tabswitcher-overlay #results ul')

    for tab in tabs 
      ul.append("<li>#{tab.url}</li>")

  switchTab: (tab)->  
    chrome.extension.sendRequest(message:"switchTab", target:tab)

  keyListener: (e)->
    if e.ctrlKey && e.keyCode 
      if e.keyCode == 220
        chrome.extension.sendRequest {message: "getTabs"}, 
          (response)=>
            @updateTabs(response.tabs)
            @show()

tabSwitcher = new TabSwitcher()

window.addEventListener("keyup", (e)->
  tabSwitcher.keyListener(e)
,false)
