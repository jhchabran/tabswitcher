defaultKey = {
  keyCode: 75 # k
  ctrlKey: true
  altKey: false
  metaKey: false
  shiftKey: false
}

$ ->
  chrome.storage.sync.get "config", (items)->
    if items.config?
      $('input#tabswitcher-settings-hotkey-input').val(convertToReadableHotkey(items.config))
    else
      chrome.storage.sync.set config:defaultKey, -> 
        $('input#tabswitcher-settings-hotkey-input').val(convertToReadableHotkey(defaultKey))

  $('input#tabswitcher-settings-hotkey-input').keydown (event)->
    unless event.keyCode == 27 # esc
      chrome.storage.sync.set config:extractConfigFromEvent(event), -> null
    else
      window.close()
      return

    $('input#tabswitcher-settings-hotkey-input').val(convertToReadableHotkey(event))

    false

convertToReadableHotkey = (event)->
  "#{extractModifierFromEvent(event)}+ #{String.fromCharCode(event.keyCode)}"

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

