class ModelChoice
  
  attr_accessor :number, :name, :type, :descriptions, :long_descriptions
  
  def initialize(number,name,type,descriptions,long_descriptions)
    @number, @name, @type, @descriptions, @long_descriptions = number, name, type, descriptions, long_descriptions
  end
  
  def incremental_or_alternative
    'incremental'
  end
  
  def levels
    1.upto(type.to_i)
  end

  NUMBER_TO_DOC_MAP = {
    0 => 'Gas Power Stations',
    1 => 'Coal Power Stations',
    2 => 'Efficiency-Coal Power Stations',
    3 => 'coal_power_stationspdf',
    4 => 'CCS',
    5 => 'CCS',
    6 => 'Nuclear Power',
    7 => 'Large Hydro electic power stations',
    8 => 'Solar PV',
    9 => 'Solar CSP',
    10 => 'Onshore Wind',
    11 => 'Offshore Wind',
    12 => 'Small Hydro',
    13 => 'Distributed Solar PV',
    14 => 'Solar Water Heaters',
    15 => 'Cross border electricity trade import',
    16 => 'Bioenergy 1 pager  - Biomass Residue Production and End-Usage JANFINAL2',
    17 => 'Bioenergy-Biomass residue production and end usage',
    18 => 'Bioenergy-Biomass residue production and end usage',
    19 => 'First and Second Generation Biofuels',
    20 => 'Advanced Biofuels',
    21 => 'Municipal Solid Waste',
    22 => 'Hydrogen One Pager',
    23 => 'Domestic Gas Production',
    24 => 'Coal Production',
    25 => 'Domestic Oil Production',
    26 => 24,#Not used
    27 => 'GDP Scenarios',
    28 => 'Domestic Passenger Transport Modepdf',
    29 => 'Domestic Passenger Transport Demand', #No pdf
    30 => 'Domestic Passenger Transport Mode', #No pdf
    31 => 'Domestic Passenger Transport Mode',
    32 => 'Domestic Passenger Transport Mode',
    33 => 'Domestic Freight Transport Modepdf',
    34 => 'Domestic Freight Transport demand',
    35 => 'Domestic Freight transport mode',
    36 => 'Building Envelope Optimization',
    37 => 'Building Envelope Optimization',
    38 => 'Residential lightings and Appliances',
    39 => 'Building Envelope Optimization',
    40 => 'Efficiency of Commercial lightings and appliances',
    41 => 'Industry One Pager',
    42 => 'Tech Options in Cement Sector',
    43 => 'Tech Options for Iron & Steel',
    44 => 'Cooking',
    45 => "Choice of fuel for irrigationpdf",
    46 => 'Agriculture_webtool',
    47 => 'Choice of fuel for irrigation',
    48 => 'Telecom_One-pager',
    50 => 'T&D losses',
    51 => 'Electrical Energy Storage',
    52 => 'Reliability of the Grid'
  }

  def doc
    #"#{NUMBER_TO_DOC_MAP[number] || number}.html"
    "#{NUMBER_TO_DOC_MAP[number] || number}.pdf"
  end
end
