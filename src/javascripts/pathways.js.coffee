views = {}

controller = null
choices = null
action = null
sector = null
comparator = null

current_view = null
old_choices = []

cache = {}
callbacks = {}

documentReady = () ->
  setVariablesFromURL()
  current_view = views[action]
  setHelpUrl()
  $('#cost_caveats').show() unless $.jStorage.get('CostCaveatShown') == true
  loadMainPathway()
  setUpControls()
  checkResolution()

$(document).ready(documentReady)

setUpControls = () ->
  $("a[title]").tooltip({delay: 0, position: 'top right', offset:[0,0],tip:'#tooltip'})
  $("a.choiceLink").click( (event) ->
    event.preventDefault()
    $("ul.menu_0 span").html('Your Chosen Pathway');
    $("#pathway_box select").val(0)
    t = $(event.target)
    c = t.data().choicenumber
    l = t.data().choicelevel
    go(c, l)
  )



setVariablesFromURL = () ->
  url_elements = window.location.pathname.split( '/' )
  controller = url_elements[1] || "pathways"
  choices = choicesForCode(url_elements[2] || twentyfifty.default_pathway)
  action = url_elements[3] || "primary_energy_chart"
  if action == 'costs_compared_within_sector'
    sector = url_elements[4]
  if url_elements[4] == 'comparator'
    comparator = url_elements[5]

float_to_letter_map = { "":"0", 1.0:"1", 1.1:"b", 1.2:"c", 1.3:"d", 1.4:"e", 1.5:"f", 1.6:"g", 1.7:"h", 1.8:"i", 1.9:"j", 2.0:"2", 2.1:"l", 2.2:"m", 2.3:"n", 2.4:"o", 2.5:"p", 2.6:"q", 2.7:"r", 2.8:"s", 2.9:"t", 3.0:"3", 3.1:"v", 3.2:"w", 3.3:"x", 3.4:"y", 3.5:"z", 3.6:"A", 3.7:"B", 3.8:"C", 3.9:"D", 0.0:"0", 4.0:"4", 5.0:"5"}

codeForChoices = (c = choices) ->
  cd = for choice in c
    float_to_letter_map[choice]
  cd.join('')

letter_to_float_map = {"1":1.0, "b":1.1, "c":1.2, "d":1.3, "e":1.4, "f":1.5, "g":1.6, "h":1.7, "i":1.8, "j":1.9, "2":2.0, "l":2.1, "m":2.2, "n":2.3, "o":2.4, "p":2.5, "q":2.6, "r":2.7, "s":2.8, "t":2.9, "3":3.0, "v":3.1, "w":3.2, "x":3.3, "y":3.4, "z":3.5, "A":3.6, "B":3.7, "C":3.8, "D":3.9, "0":0.0, "4":4.0, "5":5.0}

choicesForCode = (newCode) ->
  for choice in newCode.split('')
    letter_to_float_map[choice]

getChoices = () ->
  choices

getSector = () ->
  parseInt(sector)
    
switchSector = (new_sector) ->
  sector = new_sector
  history.pushState(choices, codeForChoices(), url()) if history['pushState']?
  switchView('costs_compared_within_sector')
  current_view.teardown()
  current_view.updateResults(cache[codeForChoices()])

getComparator = () ->
  comparator

switchComparator = (new_comparator) ->
  comparator = new_comparator
  history.pushState(choices, codeForChoices(), url()) if history['pushState']?
  current_view.switchComparator(comparator) if current_view.switchComparator?

url = (options = {}) ->
  s = jQuery.extend({controller:controller, code: codeForChoices(), action:action, sector:sector, comparator: getComparator()},options)
  if s.action == 'costs_compared_within_sector' && s.sector?
    "/#{s.controller}/#{s.code}/#{s.action}/#{s.sector}"
  else if s.comparator?
    "/#{s.controller}/#{s.code}/#{s.action}/comparator/#{s.comparator}"
  else
    "/#{s.controller}/#{s.code}/#{s.action}"

go = (index,level) ->
  old_choices = choices.slice(0)
  if index <= 15 && index !=3 && level > 1 && Math.ceil(choices[index]) == level
    choices[index] = Math.round((choices[index] - 0.1)*10)/10
  else
    choices[index] = level
  loadMainPathway()

demoTimer = null
demoOriginalLevel = null

startDemo = (choice) ->
  demoLevel = 1
  demoOriginalLevel = choices[choice]
  demoMaximum = window.twentyfifty.choice_sizes[choice]
  demoTimer = setInterval( (() ->
    go(choice,demoLevel)
    demoLevel = demoLevel + 1
    demoLevel = 1 if demoLevel > demoMaximum
    false
  ),1000)

stopDemo = (choice) ->
  clearInterval(demoTimer) if demoTimer?
  go(choice,demoOriginalLevel) if demoOriginalLevel? && demoOriginalLevel != choices[choice]

# If you want to programatically change the view, use this method
#   new_action: the name of the new action. Choices include 'electricity' and 'primary_energy'
switchView = (new_action) ->
  # Close the menu
  #$('ul#view_choices').hide()
  return false if action == new_action
  
  # This removes the old information from the screen
  current_view.teardown()

  # This updates the url, on browsers that support this (i.e., not IE <9)
  action = new_action
  history.pushState(choices, codeForChoices(), url()) if history['pushState']?
  current_view = views[action]

  # This sets the help url
  setHelpUrl()
  # This actually redraws the screen
  current_view.updateResults(cache[codeForChoices()])

setHelpUrl = () ->
  $('#help a').attr('href', 'http://indiaenergy.gov.in/about_howto.php')
  #$('#help a').attr('href', "http://2050-calculator-tool-wiki.decc.gov.uk/pages/#{twentyfifty.helpPages[action]}")

switchPathway = (new_code) ->
  old_choices = choices.slice(0)
  choices = choicesForCode(new_code)
  loadMainPathway()

setChoices = (new_choices) ->
  old_choices = choices.slice(0)
  choices = new_choices
  loadMainPathway()

loadMainPathway = (pushState = true) ->
  # Check if we haven't really moved
  return false if choices.join('') == old_choices.join('')

  # Update the controls, if neccesarry
  updateControls(old_choices,choices)
  
  # Change the url if we can
  main_code = codeForChoices()
  history.pushState(choices,main_code,url()) if history['pushState']?
  
  # Check the cache
  if cache[main_code]?
    current_view.updateResults(cache[main_code])
    #$('#calculating').hide()
    $('#calculating').html("<br >")
    #setTimeout (->
    #$('#loadbody').hide()
    #), 2000
  else
    #$('#calculating').show()
    $('#calculating').html("Calculating")
    #$('#loadbody').show()
    
    fetch = () ->
      $.getJSON(url({code:main_code, action:'data', sector: null, comparator: null}), (data) ->
        if data?
          cache[data._id] = data
          if data._id == codeForChoices()
            current_view.updateResults(data)
            $('#calculating').html("<br >")
            #setTimeout (->
            #$('#loadbody').hide()
            #), 2000
      )
    
    fetch()

loadSecondaryPathway = (secondary_code,callback) ->
  if cache[secondary_code]?
    callback(cache[secondary_code])
  else
    fetch = () =>
      $.getJSON(url({code:secondary_code, action:'data', sector: null, comparator: null}), (data) =>
        if data?
          cache[data._id] = data
          callback(data)
      )
    fetch()
  
window.onpopstate = (event) ->
  return false unless event.state
  url_elements = window.location.pathname.split( '/' )
  setChoices(choicesForCode(url_elements[2]))
  switchView(url_elements[3])
  if action == 'costs_compared_within_sector'
    switchSector(url_elements[4])
  if url_elements[4] == 'comparator'
    switchComparator(url_elements[5])

updateControls = (old_choices,@choices) ->
  controls = $('#classic_controls')
  for choice, i in @choices
    old_choice = old_choices[i]
    unless choice == old_choices[i]

      old_choice_whole = Math.ceil(old_choice)
      old_choice_fraction = parseInt((old_choice % 1)*10)
      
      choice_whole = Math.ceil(choice)
      choice_fraction = parseInt((choice % 1)*10)
            
      row = controls.find("tr#r#{i}")
      
      # Revert the old
      row.find(".selected, .level#{old_choice_whole}, .level#{old_choice_whole}_#{old_choice_fraction}").removeClass("selected level#{old_choice_whole} level#{old_choice_whole}_#{old_choice_fraction}")
      unless old_choice_fraction == 0
        controls.find("#c#{i}l#{old_choice_whole}").text(old_choice_whole)
      
      # Setup the new
      row.find("#c#{i}l#{choice_whole}").addClass('selected')
      #controls.find("#c#{i}l#{choice_whole}").text(choice_whole)

      for c in [1..(choice_whole-1)]
        controls.find("#c#{i}l#{c}").addClass("level#{choice_whole}")
        #controls.find("#c#{i}l#{c}").text(c)
      #if i is 27 or i is 42 or i is 43
      #  if choice is 1
      #    controls.find("#d#{i}").text('A')
      #  if choice is 2
      #    controls.find("#d#{i}").text('B')
      #  if choice is 3
      #    controls.find("#d#{i}").text('C')
      #  if choice is 4
      #    controls.find("#d#{i}").text('D')
      #  if choice is 5
      #    controls.find("#d#{i}").text('E')
      #else
      #  controls.find("#d#{i}").text(choice)

      #####  SHOW CHANGS ON MASTER GROUP LEVER
      for x in [1..(choice_whole)] 
        elem = controls.find("#" + i + "-" + x)
        elem.removeClass "row_" + old_choice_fraction  if elem.hasClass("row_" + old_choice_fraction)
        elem.addClass "row"  unless elem.hasClass("row")

      x=choice_whole+1
      unless x == 5
        for x in [(choice_whole+1)..4]
          elem = controls.find("#" + i + "-" + x)
          elem.removeClass "row_" + old_choice_fraction  if elem.hasClass("row_" + old_choice_fraction)
          elem.removeClass "row"  if elem.hasClass("row")

      unless choice_fraction == 0
        elem = controls.find("#" + i + "-" + choice_whole)
        elem.removeClass("row").addClass "row_" + choice_fraction	
     
      #####  END SHOW CHANGS ON MASTER GROUP LEVER

      unless choice_fraction == 0
        controls.find("#c#{i}l#{choice_whole}").text(choice)
        controls.find("#c#{i}l#{choice_whole}").addClass("level#{choice_whole}_#{choice_fraction}")
      else
        controls.find("#c#{i}l#{choice_whole}").addClass("level#{choice_whole}")

     


###### GroupClick

Array::allValuesSame = ->
  i = 1
  #alert "choices equal function"
  while i < @length
    return false  if choices[this[i]] isnt choices[this[0]]
    i++
  true

groupclick = (fraction, groupArr, grouplevel)->
  $("ul.menu_0 span").html('Your Chosen Pathway') 
  $("#pathway_box select").val(0)
  old_choices = choices.slice(0)
  if fraction
    equalChoice = groupArr.allValuesSame()
    if equalChoice
      for choice in groupArr 
        go choice, grouplevel
    else
      #alert "choices not equal"
      for choice in groupArr 
        choices[choice] = grouplevel
      loadMainPathway()

  else
    
    for choice in groupArr
      #alert ('groupclick') 
      if (choice == 36 || choice == 54) && grouplevel == 4   
        choices[choice]=3
      else
        choices[choice]=grouplevel
    loadMainPathway()
    return

###### GroupMouse hover effect
demoOriginalGroupLevel = []
demoGroupTimer = null

startGroupDemo = (groupChoiceArray)->
  
  demoLevel = 1
  for choice in groupChoiceArray 
    demoOriginalGroupLevel.push(choices[choice])
  #demoMaximum = window.twentyfifty.choice_sizes[choice]
  demoGroupTimer = setInterval( (() ->
    old_choices = choices.slice(0)
    for choice in groupChoiceArray 
       choices[choice] = demoLevel
    loadMainPathway()

    demoLevel = demoLevel + 1
    demoLevel = 1 if demoLevel > 4
    false
  ),1500)



stopGroupDemo = (groupChoiceArray) ->
  clearInterval(demoGroupTimer) if demoGroupTimer?
  i=0
  for choice in groupChoiceArray
    go(choice,demoOriginalGroupLevel[i]) if demoOriginalGroupLevel[i]? && demoOriginalGroupLevel[i] != choices[choice]
    i++
  demoOriginalGroupLevel = []


pathwayName = (pathway_code,default_name = null) ->
  window.twentyfifty.pathway_names_hash[pathway_code] || default_name

pathwayDescriptions = (pathway_code,default_description = null) ->
  window.twentyfifty.pathway_descriptions_hash[pathway_code] || default_description

#pathwayWikiPages = (pathway_code,default_page = null) ->
 # 'http://planningcommission.nic.in/sectors/index.php?sectors=energy'
  #"http://2050-calculator-tool-wiki.decc.gov.uk/pages/#{window.twentyfifty.pathway_wiki_pages_hash[pathway_code] || default_page}"

checkResolution = () ->
  if $(window).width() < 1400
    $("#menu").hide()
  else
    $("#menu2").hide()



window.twentyfifty.code = codeForChoices
window.twentyfifty.getChoices = getChoices
window.twentyfifty.setChoices = setChoices
window.twentyfifty.getSector = getSector
window.twentyfifty.switchSector = switchSector
window.twentyfifty.getComparator = getComparator
window.twentyfifty.switchComparator = switchComparator
window.twentyfifty.url = url
window.twentyfifty.go = go
window.twentyfifty.loadMainPathway = loadMainPathway
window.twentyfifty.loadSecondaryPathway = loadSecondaryPathway
window.twentyfifty.switchView = switchView
window.twentyfifty.switchPathway = switchPathway
window.twentyfifty.pathwayName = pathwayName
window.twentyfifty.pathwayDescriptions = pathwayDescriptions
#window.twentyfifty.pathwayWikiPages = pathwayWikiPages
window.twentyfifty.startDemo = startDemo
window.twentyfifty.stopDemo = stopDemo
window.twentyfifty.groupclick = groupclick
window.twentyfifty.startGroupDemo = startGroupDemo
window.twentyfifty.stopGroupDemo = stopGroupDemo

window.twentyfifty.views = views


