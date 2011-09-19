chrome.extension.onRequest.addListener (request, sender, sendResponse)->
  switch request.message
    when "getTabs"
      chrome.windows.getCurrent (window)->
        # We use getAllInWindow as a workaround since 
        # getCurrent do not export its tabs.
        #
        # I have absolutely no idea why ^^'
        chrome.tabs.getAllInWindow window.id, (tabs)->
          sendResponse(tabs:tabs)
      break
    when "switchTab"
      chrome.tabs.update(request.target.id, selected:true)
      sendResponse({})
      break
    else
      sendResponse({})

