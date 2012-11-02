$ ->
  chrome.storage.sync.get "config", (items)->
    if items.config?
      console.log items.config
      $('#tabswitcher-settings-hotkey-char').text(String.fromCharCode(items.config.keyCode))
      $('#tabswitcher-settings-hotkey-modifier').text(extractModifierFromEvent(items.config))
    else
      console.log "not found"


  $('input#tabswitcher-settings-hotkey-input').keydown (event)->
    modifier = extractModifierFromEvent(event)
    config = extractConfigFromEvent(event)

    chrome.storage.sync.set config:config, ->
      console.log "success"

    $('#tabswitcher-settings-hotkey-modifier').text(modifier)
    $('#tabswitcher-settings-hotkey-char').text(String.fromCharCode(event.keyCode))

    false

extractConfigFromEvent = (event)->
  keyCode: event.keyCode
  ctrlKey: event.ctrlKey
  altKey:  event.altKey
  metaKey: event.metaKey
  shiftKey: event.shiftKey

extractModifierFromEvent = (event)->
  modifier = ""

  if event.ctrlKey
    modifier += 'Ctrl '

  if event.altKey
    modifier += 'Alt '

  if event.metaKey
    modifier += 'Cmd '

  if event.shiftKey
    modifier += 'Shift '

  modifier

