chrome.extension.onRequest.addListener (request, sender, sendResponse)->
  switch request.message
    when "getTabs"
      chrome.windows.getCurrent (window)->
        chrome.tabs.query windowId:window.id, (tabs)->
          sendResponse(tabs:tabs)
      break
    when "switchTab"
      chrome.tabs.update(request.target.id, selected:true)
      sendResponse({})
      break
    when "requestConfig"
      chrome.storage.sync.get "config", (items)->
        sendResponse(config:items.config)
      break
    else
      sendResponse({})

