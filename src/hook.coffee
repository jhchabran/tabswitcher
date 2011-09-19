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

    @overlayElement().find('input').keyup (event)=>
      if event.keyCode == 13
        @switchTab @tabs[0]
      else
        @displayTabs @fuzzy(event.target.value)

  show: ->
    @overlayElement().show()
    @overlayElement().find('input').focus()

  overlayElement: ->
    $('#tabswitcher-overlay')

  displayTabs: (tabs)->
    @overlayElement().find('ul').remove()
    @overlayElement().find('#results').append '<ul></ul>'

    ul = $('#tabswitcher-overlay #results ul')

    for tab in tabs 
      ul.append("<li>#{tab.url}</li>")

  # This algorithm is the most naive implementation you can find !
  # 
  # It doesn't care of the spaces between matches from the hint 
  # which means he isn't very accurate compared to what you're used to.
  #
  # TODO : WRITE A DECENT FUZZY MATCHER FFS !
  fuzzy: (hint)->
    results = [] 
    scores = {}

    console.log "-#{hint}-"

    compute_score = (text,hint)->
      index = 0
      score = 0
      found = false

      for i in [0..hint.length-1]
        for j in [index..text.length-1] 
          if hint.charAt(i) == text.charAt(j)
            score++
            index = j
            console.log "found #{hint.charAt(i)} in #{text} at #{j}"
            found = true
            break
        if found 
          found = false
        else 
          console.log "can't find #{hint.charAt(i)} in #{text}"
          break 

      score

    for tab in @tabs 
      scores[tab.id] = compute_score tab.url[6..-1], hint

    @tabs.sort (a,b)->
      scores[b.id] - scores[a.id]

  switchTab: (tab)->  
    chrome.extension.sendRequest(message:"switchTab", target:tab)
    @overlayElement().hide()

  keyListener: (e)->
    if e.ctrlKey && e.keyCode 
      if e.keyCode == 220
        chrome.extension.sendRequest {message: "getTabs"}, 
          (response)=>
            @tabs = response.tabs
            @displayTabs(@tabs)
            @show()

tabSwitcher = new TabSwitcher()

window.addEventListener("keyup", (e)->
  tabSwitcher.keyListener(e)
,false)
