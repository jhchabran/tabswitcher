switchTab = (tab)->
  chrome.extension.sendRequest(message:"switchTab", target:tab)

fuzzy = (tabs, input, callback)->
  callback(tabs[0])

keyListener = (e)->
  if (e.ctrlKey && e.keyCode) 
    if (e.keyCode == 84 )
      chrome.extension.sendRequest({message: "getTabs"}, 
        (response)->
          console.log(response)
          fuzzy(response.tabs,prompt("url ?", response.tabs[0].url), switchTab)
      )

window.addEventListener("keyup", keyListener, false)


