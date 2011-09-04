switchTab = (tab)->
  chrome.extension.sendRequest(message:"switchTab", target:tab)

fuzzy = (tabs, input, callback)->
  callback(tabs[0])

showInput = ->
  installOverlay() unless $('#tabswitcher-overlay')[0]
  $('#tabswitcher-overlay input').focus()
  
displayTabs = (tabs)->
  ul = $('#tabswitcher-overlay #results ul')
  for tab in tabs 
    console.log tab
    ul.append("<li>#{tab.url}</li>")
  
installOverlay = ->
  $('body').append("<div id='tabswitcher-overlay'></div>")
  $('#tabswitcher-overlay')
    .css
      position:'fixed',
      width:'100%',
      height:'100%',
      top:0,
      left:0,
      background: 'rgba(0,0,0,0.8)'
    .append("<div id='box'> <input type='text'></input></div>")
    .append("<div id='results'><ul></ul></div>")

keyListener = (e)->
  if (e.ctrlKey && e.keyCode) 
    if (e.keyCode == 84 )
      chrome.extension.sendRequest({message: "getTabs"}, 
        (response)->
          showInput()
          displayTabs(response.tabs)
          #fuzzy(response.tabs,prompt("url ?", response.tabs[0].url), switchTab)
      )

window.addEventListener("keyup", keyListener, false)

