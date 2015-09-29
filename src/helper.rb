# encoding: utf-8
module Helper

  def structure
    ModelStructure.instance
  end

  def stylesheet
    "<link href='/assets/#{assets['application.css'] || 'application.css'}' media='screen' rel='stylesheet' type='text/css' />"
  end

  def javascript
    "<script src='/assets/#{assets['application.js'] || 'application.js'}' type='text/javascript'></script>"
  end

  def assets
    @assets ||= {}
  end

  def assets=(h)
    @assets = h
  end
  
  def classic_table_row_for_heading(choice_heading, code_id, choiceArr, fraction)
  
    groupChoiceArray ||=Array.new
    choiceArr.each do |choice|
      groupChoiceArray.push(structure.choices[choice].number)
    end

    row ="<td class='name1'><a href='javascript:void(0);' onclick='switchOpenCloseIcon(#{code_id}); return false' data-toggle='collapse' data-target='#collapseme#{code_id}' onmouseover='twentyfifty.startGroupDemo(#{groupChoiceArray}); return true;' onmouseout='twentyfifty.stopGroupDemo(#{groupChoiceArray});return true;' >#{choice_heading}</a></td>"
    if choice_heading == 'Agriculture' or choice_heading == 'Industry' or choice_heading == 'Transport'
      row << "<td width='25px' align='center' id='info-#{code_id}'><a href='/assets/onepage/Overall/#{choice_heading}.pdf' target='_new' onmouseover='twentyfifty.startGroupDemo(#{groupChoiceArray}); return true;' onmouseout='twentyfifty.stopGroupDemo(#{groupChoiceArray});return true;'><img height='13px' width='13px'  src='/assets/images/get_info.png'></a></td>"
    end
    row_data = ""
    ary ||= Array.new
    for i in 0..3
      l=choiceArr.count()
      for j in 1..(6-l)/2
	 row_data << "<tr height='1'><td></td></tr><tr height='1'><td></td></tr>"
      end
      choiceArr.each do |choice|       
        row_data << "<tr height='1'><td></td></tr><tr height='1'><td id='#{structure.choices[choice].number}-#{i+1}'></td></tr>" 
        if i == 0
	  ary.push(structure.choices[choice].number)
        end
	
      end
      row << "<td class='choice1'><a href='javascript:void(0);' onclick='twentyfifty.groupclick(#{fraction},#{ary},#{i+1});return true;'>
             <table border-collapse:collapse;>#{row_data}</table></td>" 
      row_data=''
      
    end
    "<table style='margin-bottom:5px;'><tr class='incremental' id='#{code_id}'>#{row}<td width='25px' id='dd-#{code_id}' align='center'><a href='javascript:void(0);'  onclick='switchOpenCloseIcon(#{code_id}); return false' data-toggle='collapse' data-target='#collapseme#{code_id}'><img id='m-#{code_id}' width='15px' src='/assets/images/open.png'></td></tr></table>"
  end

  def classic_table_row_for_choice(choice)
    #row = ["<td class='name'><a href='planningcommission.gov.in/energy2047/demand/' target='_new' onmouseover='twentyfifty.startDemo(#{choice.number}); return true;' onmouseout='twentyfifty.stopDemo(#{choice.number});return true;'>#{choice.name}</a></td>"]
    if choice.number != 54
      row = ["<td class='name' cellpadding='10'><a href='/assets/onepage/#{choice.doc}' target='_new' title='#{choice.descriptions[5]}' onmouseover='twentyfifty.startDemo(#{choice.number}); return true;' onmouseout='twentyfifty.stopDemo(#{choice.number});return true;'>#{choice.name}</a></td>"]

      row << "<td width='20px'><a href='/assets/onepage/#{choice.doc}' target='_new' onmouseover='twentyfifty.startDemo(#{choice.number}); return true;' onmouseout='twentyfifty.stopDemo(#{choice.number});return true;'><img height='13px' width='13px'  src='/assets/images/get_info.png'></a></td>"
    else
      row = ["<td class='name' cellpadding='10'><a title='#{choice.descriptions[5]}' onmouseover='twentyfifty.startDemo(#{choice.number}); return true;' onmouseout='twentyfifty.stopDemo(#{choice.number});return true;'>#{choice.name}</a></td>"]

      row << "<td width='20px'></td>"
    end
    choice.levels.each.with_index do |level,i|
      if choice.number == 27 or choice.number == 42 or choice.number == 43 or choice.number == 47 or choice.number == 5
        if level == 1
          row << "<td class='choice'><a href='#' data-choicenumber='#{choice.number}' data-choicelevel='#{i+1}' id='c#{choice.number}l#{i+1}' title='#{choice.descriptions[i]}' class='choiceLink' >A</a></td>"
        end
        if level == 2
          row << "<td class='choice'><a href='#' data-choicenumber='#{choice.number}' data-choicelevel='#{i+1}' id='c#{choice.number}l#{i+1}' title='#{choice.descriptions[i]}' class='choiceLink' >B</a></td>"
        end
        if level == 3
          row << "<td class='choice'><a href='#' data-choicenumber='#{choice.number}' data-choicelevel='#{i+1}' id='c#{choice.number}l#{i+1}' title='#{choice.descriptions[i]}' class='choiceLink' >C</a></td>"
        end
        if level == 4
          row << "<td class='choice'><a href='#' data-choicenumber='#{choice.number}' data-choicelevel='#{i+1}' id='c#{choice.number}l#{i+1}' title='#{choice.descriptions[i]}' class='choiceLink' >D</a></td>"
        end
        if level == 5
          row << "<td class='choice'><a href='#' data-choicenumber='#{choice.number}' data-choicelevel='#{i+1}' id='c#{choice.number}l#{i+1}' title='#{choice.descriptions[i]}' class='choiceLink' >E</a></td>"
        end
      else
        row << "<td class='choice'><a href='#' data-choicenumber='#{choice.number}' data-choicelevel='#{i+1}' id='c#{choice.number}l#{i+1}' title='#{choice.descriptions[i]}' class='choiceLink' >#{level}</a></td>"
      end
    end
    "<tr class='#{choice.incremental_or_alternative}' id='r#{choice.number}'>#{row.join('')}<td class='choice' id='d#{choice.number}'></td></tr>"
  end

  def view_names
    { 
      "primary_energy_chart"=>"All Energy",
      "electricity"=>"Electricity",
      "energy_security" => "Energy Security",
      "emissions"=> "Energy Emissions",
      "sankey"=>"Energy Flows",
      "map"=>"Land Requirement",
      "grid_balancing_summer"=>"Grid Balancing",
      "total_cost"=>"Energy Costs",
      "my_story"=>"My Story",
      "assumptions"=>"Assumptions",
      #"air_quality" => "Air quality",
      #"costs_in_context"=>"Costs in context",
      #"costs_compared_overview"=>"Costs compared",
      #"costs_sensitivity" => "Cost sensitivity"
    }
  end

  def help_pages
    { 
      "primary_energy_chart"=>"83", 
      "electricity"=>"84",
      "energy_security" => "85",
      "sankey"=>"86", 
      "map"=>"87", 
      "costs_in_context"=>"88",
      "costs_compared_overview"=>"89",
      "costs_sensitivity" => "90",
      #"story"=>"91",
      "air_quality" => "TBD"
    }
  end

  def example_pathways
    @example_pathways ||= ModelStructure.instance.example_pathways
  end 

  def pathway_names
    Hash[*example_pathways.map { |e| [e[:code],e[:name]] }.flatten]
  end

  def pathway_wiki_pages
    Hash[*example_pathways.map { |e| [e[:code],e[:wiki]] }.flatten]
  end

  def cost_comparator_pathways
    example_pathways.find_all do |e|
      e[:cost_comparator]
    end.sort_by do |e|
      e[:cost_comparator]
    end.map do |e|
      e[:code]
    end
  end

  def default_cost_comparator_pathway
    example_pathways.first[:code]
  end

  def pathway_descriptions
    Hash[*example_pathways.map { |e| [e[:code],e[:description]] }.flatten]
  end

  def saved_pathways 
    Hash[*example_pathways.map { |e| [e[:name],e[:code]] }.flatten]
  end

  def choice_sizes
    sizes = {}
    ModelStructure.instance.choices.each do |choice|
      sizes[choice.number] = choice.levels.to_a.size
    end
    sizes
  end

end
