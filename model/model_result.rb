require_relative 'model'

class ModelResult < ModelUtilities  
  attr_accessor :excel, :pathway
  
  def initialize
    @excel = Model.new
  end
  
  def self.calculate_pathway(code)
    new.calculate_pathway(code)
  end
  
  def calculate_pathway(code)
    Thread.exclusive do 
      reset
      @pathway = { _id: code, choices: set_choices(code) }
      sankey_table
      primary_energy_tables #DONE
      electricity_tables #DONE
      demand_year
      supply_year

      dependency
      emissions_do_nothing
      land_do_nothing
      land_table
      #energy_share
      emissions_absolute
      emissions_percapita
      import_costs
      increamental_costs
      year_increamental_costs
      increamental_table
      import_proportions
      #electricity_percapita
      get_costs
      grid_balancing
      #population
      my_story
      global_assumption


    end
    return pathway
  end
 
################## All Energy Charts Data ##################    

  def primary_energy_tables
    pathway[:final_energy_demand] = table 7, 20 #7, 18 #13, 18   Includes total
    pathway[:primary_energy_supply] = table 25, 49 #308, 321 #283, 296 India - > N.01 to Total Primary supply
    pathway[:Determined_effort_demand] = table 22, 22 # Demand do nothing scenario
    pathway[:Determined_effort_supply] = table 50, 50 # Demand do nothing scenario
    pathway[:conversion_losses] = table 52, 52 # Demand do nothing scenario
    pathway[:distribution_losses] = table 53, 53 # Demand do nothing scenario
  end
  
  def dependency
    dep = {}
    (62..65).each do |row|
      dep[label("charts", row)] = annual_data("charts", row)
    end
    pathway['dependency'] = dep
  end

  def demand_year
    demand = {} 
    j = 2012
    ('ba'..'bh').each do |num| 
    demand[j] = []
      (7..20).each do |row|
        demand[j] << [r("charts_d#{row}"),r("charts_#{num}#{row}")] #changed n to m (2052 to 2047)
      end
    j += 5
    end
    pathway[:demand_year] = demand
  end

  def supply_year
    supply = {} 
    j = 2012
    ('ba'..'bh').each do |num| 
    supply[j] = []
      (25..49).each do |row|
        supply[j] << [r("charts_d#{row}"),r("charts_#{num}#{row}")] #changed n to m (2052 to 2047)
      end
    j += 5
    end
    pathway[:supply_year] = supply
  end

################## Electricity Charts Data ##################    

  def electricity_tables
    e = {}
    e[:demand] = table 297, 307 #347, 353 #322, 326     includes total
    e[:supply] = table 102, 121 #107, 125 #96, 111
    e[:re_share_percent] = table 125, 125 #-> Percentage Share of Renewables
    e[:overgeneration] = table 122, 122 #-> electricity overgeneration
    pathway['electricity'] = e
  end

################## Energy Security Charts Data (get Dependency data from "All Energy"'s data) ##################    

  def import_proportions
    imp_pro = {}
    (311..314).each do |row| #includes total
      imp_pro[r("charts_c#{row}")] = annual_data("charts", row)
    end
    pathway['import_proportions'] = imp_pro

  end

  def import_costs
    imp_costs = {}
    (335..338).each do |row|                                     #includes total
      imp_costs[r("charts_c#{row}")] = annual_data("charts", row)
    end
    pathway['import_costs'] = imp_costs
  end

################## Emission Charts Data ##################    

  def emissions_absolute
    emissions_abs = {}
    (179..196).each do |row|        #includes total
      emissions_abs[r("charts_f#{row}")] = annual_data("charts", row)
    end
    pathway['emissions_absolute'] = emissions_abs
  end

  def emissions_percapita
    emissions_per = {}
    (203..220).each do |row|                   #includes total
      emissions_per[r("charts_f#{row}")] = annual_data("charts", row)
    end
    pathway['emissions_percapita'] = emissions_per
  end

  def emissions_do_nothing
    t = {}
    (155..165).each do |row|
      t[r("charts_e#{row}")] = [r("charts_f#{row}"),r("charts_ax#{row}"),r("charts_ay#{row}")]
    end
    pathway['emissions_do_nothing'] = t
  end

################## Sankey Charts Data ##################    

  def sankey_table
    s = {} 
    #(6..94).each do |row|
    j = 2012
    ('f'..'m').each do |num| 
    s[j] = []
      (6..84).each do |row|
        s[j] << [r("flows_c#{row}"),r("flows_#{num}#{row}"),r("flows_d#{row}")] #changed n to m (2052 to 2047)
      end
    j += 5
    end
    pathway[:sankey] = s
  end
  
################## Land Charts Data ##################    

  def land_do_nothing
    land = {}
    (37..42).each do |row|
      land[label("land_use", row)] = [r("land_use_j#{row}"),r("land_use_k#{row}")]
    end
    pathway['land_do_nothing'] = land
  end

  def land_table
    l = {} 
    j = 2012
    ('i'..'p').each do |num| 
    l[j] = []
      (6..23).each do |row|
        l[j] << [r("land_use_d#{row}"),r("land_use_#{num}#{row}")] #changed n to m (2052 to 2047)
      end
    j += 5
    end
    pathway[:land_table] = l
  end

################## Grid Balancing Charts Data ##################    

  def grid_balancing
    grid_summer = {}
    grid_monsoon = {}
    grid_winter = {}

    (307..316).each do |row|
      grid_summer[r("dispatch_ab#{row}")] = annual_data_gridS("dispatch", row)
      end
    pathway['grid_balancing_summer'] = grid_summer

    (307..316).each do |row|
      grid_monsoon[r("dispatch_bb#{row}")] = annual_data_gridM("dispatch", row)
      end
    pathway['grid_balancing_monsoon'] = grid_monsoon

    (307..316).each do |row|
      grid_winter[r("dispatch_cb#{row}")] = annual_data_gridW("dispatch", row)
      end
    pathway['grid_balancing_winter'] = grid_winter

    pathway['grid_msg1'] = r("dispatch_w319")
    pathway['grid_msg2'] = r("dispatch_v328")

  end

################## Cost Charts Data ##################    

  def increamental_costs
    inc_costs = {}
    (317..325).each do |row|                                     #includes total
      inc_costs[r("costabsolute_c#{row}")] = r("costabsolute_e#{row}")
    end
    inc_costs[r("costabsolute_c328").to_s] = r("costabsolute_g328")
    pathway['increamental_costs'] = inc_costs
  end

  def increamental_table
    inc = {} 
    j = 2017
    ('ak'..'aq').each do |num| 
    inc[j] = []
      (304..311).each do |row|
        inc[j] << [r("costabsolute_c#{row}"),r("costabsolute_#{num}#{row}")] #changed n to m (2052 to 2047)
      end
    j += 5
    end
    pathway[:increamental_table] = inc
  end

  def year_increamental_costs
    inc_year = {}
    (304..311).each do |row|                                     #includes total
      inc_year[r("costabsolute_c#{row}")] = annual_data_increament("costabsolute", row)
    end
    pathway['increamental_year'] = inc_year
  end

  def get_costs
    cost = {}
    cost[:counterfact_high] = table_cost 268,275
    cost[:counterfact_point] = table_cost 256, 263
    cost[:counterfact_low] = table_cost 280, 287
    cost[:user_point] = table_cost 229, 236
    pathway['costs'] = cost
  end

################## My Story Data ##################    

  def my_story

    story = {}
    i=0
    (3..107).each do |row|                                     #includes total
      story[i] = [r("my_story_a#{row}"),r("my_story_b#{row}"),r("my_story_c#{row}")]
      i += 1
    end

    pathway['my_story'] = story

  end

################## Global Assumptions Data ##################    

  def global_assumption

    global = {}
    i=0
    (344..352).each do |row|                                     #includes total
      global[i] = annual_data_global("charts", row)
        i += 1
    end
    pathway['global_assumption'] = global


  end

  
################## Helper Methods ##################   
  
  def table(start_row,end_row)
    t = {}
    (start_row..end_row).each do |row|
      t[label("charts", row)] = annual_data("charts",row)
    end
    t
  end

  def table_cost(start_row,end_row)
    t = {}
    (start_row..end_row).each do |row|
      t[label_cost("costabsolute", row, "c")] = annual_data_increament("costabsolute",row)
    end
    t
  end
  
  def label_cost(sheet, row, col)
    r("#{sheet}_#{col}#{row}").to_s
  end


  def label(sheet,row)
    r("#{sheet}_d#{row}").to_s
  end

  def annual_data_increament(sheet,row)
    ['ak','al','am','an','ao','ap','aq'
    ].map { |c| r("#{sheet}_#{c}#{row}") }
  end

  def annual_data_cost(sheet,row)
    ['bo','bp','bq','br','bs','bt','bu'
    ].map { |c| r("#{sheet}_#{c}#{row}") }
  end
  
  def annual_data(sheet,row)
    ['ba','bb','bc','bd','be','bf','bg','bh'
    ].map { |c| r("#{sheet}_#{c}#{row}") }
  end

  def annual_data_gridS(sheet, row)
    ['ac','ad','ae','af','ag','ah','ai','aj','ak','al','am','an','ao','ap','aq','ar','as','at','au','av','aw','ax','ay','az'
    ].map { |c| r("#{sheet}_#{c}#{row}") }
  end  

  def annual_data_gridM(sheet, row)
    ['bc','bd','be','bf','bg','bh','bi','bj','bk','bl','bm','bn','bo','bp','bq','br','bs','bt','bu','bv','bw','bx','by','bz'
    ].map { |c| r("#{sheet}_#{c}#{row}") }
  end

  def annual_data_gridW(sheet, row)
    ['cc','cd','ce','cf','cg','ch','ci','cj','ck','cl','cm','cn','co','cp','cq','cr','cs','ct','cu','cv','cw','cx','cy','cz'
    ].map { |c| r("#{sheet}_#{c}#{row}") }
  end

  def annual_data_global(sheet, row)
    ['b','c','d','e','f','g','h', 'i', 'j', 'k'
    ].map { |c| r("#{sheet}_#{c}#{row}") }
  end

  def sum(hash_a,hash_b)
    return nil unless hash_a && hash_b
    summed_hash = {}
    hash_a.each do |key,value|
      summed_hash[key] = value + hash_b[key]
    end
    return summed_hash
  end
  
end

if __FILE__ == $0
  g = ModelResult.new

  tests = 100
  t = Time.now
  a = []
  tests.times do
    a << g.calculate_pathway(ModelResult::CONTROL.map { rand(4)+1 }.join)
  end
  te = Time.now - t
  puts "#{te/tests} seconds per run"
  puts "#{tests/te} runs per second"
end
