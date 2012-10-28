$ ->
  $('input#tabswitcher-settings-hotkey-input').keypress (event)->
    modifier = ""

    if event.ctrlKey
      modifier += 'Ctrl '

    if event.altKey
      modifier += 'Alt '

    if event.metaKey
      modifier += 'Cmd '

    if event.shiftKey
      modifier += 'Shift '

    $('#tabswitcher-settings-hotkey-modifier').text(modifier)
    $('#tabswitcher-settings-hotkey-char').text(event.keyCode)

    false

