
upper = []
upperSupply = []
setChart = (chart, options) ->
  #max = chart.series.length
  i = 0

  #alert upper.length

  if upper.length is 1
    chart.series[0].remove false
    chart.addSeries upper.pop()
    #chart.options.subtitle.text = 'Click for Demand Chart'
    chart.setTitle text: "Energy Demand - "+(chart.series[0].total).toFixed(0)+' TWh/yr'
    chart.setTitle null, text: "Click on underlined sector for a sub-sector drilldown"
    return true

  if upper.length is 0 and options.name == "false"
    return false


  upper.push(chart.series[0].options)


  chart.series[0].remove()

  chart.addSeries   
    name: options.name
    data: options.data
    type: options.type
    
    false
  
  chart.setTitle text: options.name+" - "+(chart.series[0].total).toFixed(0)+' TWh/yr'
  chart.setTitle null, text: "Click anywhere on chart to go back "

  chart.redraw()
  return

setChartSupply = (chart, options) ->
  #max = chart.series.length
  i = 0

  #alert upper.length

  if upperSupply.length is 1
    chart.series[0].remove false
    chart.addSeries upperSupply.pop()
    chart.setTitle text: "Energy Supply - "+(chart.series[0].total).toFixed(0)+' TWh/yr'
    chart.setTitle null, text: "Click on underlined sector for a sub-sector drilldown"
    return true

  if upperSupply.length is 0 and options.name == "false"
    return false

  #chart.xAxis[0].setCategories options.categories, false
  upperSupply.push(chart.series[0].options)
  #alert upperSupply.length

  chart.series[0].remove()
  chart.addSeries   
    name: options.name
    data: options.data
    type: options.type
    false

  chart.setTitle text: options.name+" - "+(chart.series[0].total).toFixed(0)+' TWh/yr'
  chart.setTitle null, text: "Click anywhere on chart to go back "
  

  chart.redraw()
  return

class PrimaryEnergyOverview

  constructor: () ->

  html = "
           <select id='year_demand' class='year_demand' name='year_demand'>
             <option value='2012'>2012</option>
             <option value='2017'>2017</option>
             <option value='2022'>2022</option>
             <option value='2027'>2027</option>
             <option value='2032'>2032</option>
             <option value='2037'>2037</option>
             <option value='2042'>2042</option>
             <option value='2047' selected >2047</option>
           </select>

         "

  html1 = "
           <select id='year_supply' class='year_supply	' name='year_supply'>
             <option value='2012'>2012</option>
             <option value='2017'>2017</option>
             <option value='2022'>2022</option>
             <option value='2027'>2027</option>
             <option value='2032'>2032</option>
             <option value='2037'>2037</option>
             <option value='2042'>2042</option>
             <option value='2047' selected >2047</option>
           </select>

         "

  setup: () ->

    target = $('#results')

    target.append("<div id='comparison_chart' class='chart'></div>")
    target.append("<div id='supply_chart' class='chart'></div>")
    document.getElementById("comparison_chart").style.width = "50%"
    document.getElementById("supply_chart").style.width = "50%"
    $('#results').append(html)
    $('#results').append(html1)
    document.getElementById("pathway_box").style.display = "block"
    document.getElementById("classic_controls").style.display = "block"
    document.getElementById("display_table").style.display = "block"
    document.getElementById("print_div").style.display = "none"
    document.getElementById("warning").style.display = "none"
    $('#warning').empty()
    $('#display').empty()

    $('#display').append("<h5>Explore</h5><ul class='subnav'><li><a href='#' id='energy-subnav-1' class='' onclick='twentyfifty.switchView(\"primary_energy_chart\")'>Energy Demand & Supply</a></li><li><a href='#' id='energy-subnav-2' class='selected' onclick='twentyfifty.switchView(\"primary_energy_overview_chart\")'>Sector-wise Drilldown</a></li><li><a href='#' id='energy-subnav-3' class='' onclick='twentyfifty.switchView(\"primary_energy_detail_chart\")'>Compare 2012 and 2047</a></li></ul>")


    window.DemandDrill = @energy_comparison_chart = new Highcharts.Chart({
      chart: { renderTo: 'comparison_chart', type: 'pie', width:500, height:250, marginTop: 50, marginBottom:25, marginLeft:0 },
      title: { text: 'Energy Demand in 2014 - ' },
      subtitle: { text: 'Click on underlined sector for a sub-sector drilldown',verticalAlign: 'bottom', y: 12 },

      xAxis:{ 
        categories: ["Telecom","Transport","Industry","Cooking","Lighting-Appliances","Agriculture"] },
      legend:{
        itemStyle: { fontSize: '7pt' }
      },
      tooltip: { 
        enabled: true,
        shared: true
        style:
          fontSize: "9px"
          padding: "8px"
        positioner: ->
          x: 10
          y: 150	

        useHTML: true,
        headerFormat: '{series.name}' + ' (TWh/yr)' + '<table>',
        pointFormat: '<tr><td style="color: {series.color}">{point.name}: </td>' + '<td style="text-align: right">{point.y:.0f}</td></tr>',
        footerFormat: '</table>'

      }
   
      drilldown: {
        drillUpButton: {
          position: {
            y: 100,
            x: 100
          }
        },
      }


      plotOptions:
        pie:
          size: "110%"

          allowPointSelect: true
          cursor: "pointer"
          point:
            y:200
            events:
              click: ->
                chart = @series.chart
                drilldown = @drilldown	
                if drilldown
                  
                  options =
                    name: drilldown.name
                    data: drilldown.data
                    type: "pie"
                  setChart chart, options 
                else
                  options =
                    name: "false"
                  setChart chart,options
                   
                  return

          dataLabels:
            distance: 10
            enabled: true
            color: "#000000"
            connectorColor: "#000000"
            style:{
              width: '150px'
            }

      series: []
    })


    window.SupplyDrill = @energy_supply_chart = new Highcharts.Chart({
      chart: { renderTo: 'supply_chart', type: 'pie', width:500, height:250, marginTop: 50, marginBottom:25, marginLeft:0 },
      title: { text: 'Energy Supply in 2014 - ' },
      subtitle: { text: 'Click on underlined sector for a sub-sector drilldown',verticalAlign: 'bottom', y: 12 },

      xAxis:{},
      legend:{
        itemStyle: { fontSize: '7pt' }
      },
      tooltip: { 
        enabled: true,
        shared: true
        style:
          fontSize: "9px"
          padding: "8px"
        positioner: ->
          x: 10
          y: 60	

        useHTML: true,
        headerFormat: '{series.name}' + ' (TWh/yr)' + '<table>',
        pointFormat: '<tr><td style="color: {series.color}">{point.name}: </td>' + '<td style="text-align: right">{point.y:.0f}</td></tr>',
        footerFormat: '</table>'

      }
   
      drilldown: {
        drillUpButton: {
          position: {
            y: 100,
            x: 100
          }
        },
      }


      plotOptions:
        pie:
          size: "110%"

          allowPointSelect: true
          cursor: "pointer"
          point:
            y:200
            events:
              click: ->
                chart = @series.chart
                drilldown = @drilldown	
                if drilldown
                  options =
                    name: drilldown.name
                    data: drilldown.data
                    type: "pie"
                  setChartSupply chart, options
                else
                  options =
                    name: "false"
                  setChartSupply chart,options
                  return

          dataLabels:
            distance: 12
            enabled: true
            color: "#000000"
            connectorColor: "#000000"
            style:{
              width: '170px'
            }

      series: []
    })

    $('#year_demand').on 'change', ->
      #alert @value
      window.twentyfifty.views.primary_energy_overview_chart.curYear = @value
      DDyear = window.twentyfifty.views.primary_energy_overview_chart.curYear
      $.ajax
        url: window.location.pathname.split("/").slice(0, 3).join("/") + "/data"
        dataType: "json"
        async: false
        success: (data) ->
          data_in=[] 
          i=0
          y_txt = data['demand_year'][DDyear][13][1]

          drillTransport = {name:"Transport", id:"Transport",data:[["Road transport",data['demand_year'][DDyear][6][1]],["Rail transport",data['demand_year'][DDyear][7][1]],["Domestic aviation",data['demand_year'][DDyear][8][1]]], type:'	'}

          drillBuildings = {name:"Buildings", id:"Buildings",data:[["Commercial Lighting & Appliances",data['demand_year'][DDyear][3][1]],["Domestic Lighting & appliances",data['demand_year'][DDyear][2][1]],["Commercial Heating and cooling",data['demand_year'][DDyear][1][1]],["Residential Heating and cooling",data['demand_year'][DDyear][0][1]]], type:'pie'}

          data_in = [{name:"Telecom",y:data['demand_year'][DDyear][11][1]}, {name:"Transport",dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}}, y:data['demand_year'][DDyear][9][1],drilldown: drillTransport},{name: "Industry", y:data['demand_year'][DDyear][5][1]},{name:"Cooking", y:data['demand_year'][DDyear][12][1]},{name:"Buildings",dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}},y:data['demand_year'][DDyear][4][1],drilldown: drillBuildings},{name:"Pumps & Tractors", y:data['demand_year'][DDyear][10][1]}]



          window.DemandDrill.series[i].setData(data_in,false)
          window.DemandDrill.setTitle text: "Energy Demand - "+(y_txt).toFixed(0)+" TWh/yr"
          window.DemandDrill.redraw()

          #alert drillTransport

          return
      return


    $('#year_supply').on 'change', ->
      #alert @value
      window.twentyfifty.views.primary_energy_overview_chart.SYear = @value
      Syear = window.twentyfifty.views.primary_energy_overview_chart.SYear
      $.ajax
        url: window.location.pathname.split("/").slice(0, 3).join("/") + "/data"
        dataType: "json"
        async: false
        success: (data) ->
          data_in=[] 
          i=0
          y_txt = data['supply_year'][Syear][24][1]

          drillBioenergy = {name:"Bioenergy", id:"Bioenergy",data:[["Agriculture",data['supply_year'][Syear][12][1]],["Biomass oversupply (imports)",data['supply_year'][Syear][13][1]],["Waste",data['supply_year'][Syear][11][1]]], type:'pie'}

          drillRenewables = {name:"Renewables and Clean Energy", id:"Renewables and Clean Energy",data:[["Nuclear",data['supply_year'][Syear][0][1]],["Solar",data['supply_year'][Syear][1][1]],["Wind",data['supply_year'][Syear][2][1]],["Hydro",data['supply_year'][Syear][6][1]]], type:'pie'}

          drillCoal = {name:"Coal", id:"Coal",data:[["Coal Imports",data['supply_year'][Syear][15][1]],["Coal Production",data['supply_year'][Syear][16][1]]], type:'pie'}

          drillOil = {name:"Oil", id:"Oil",data:[["Oil Production",data['supply_year'][Syear][18][1]],["Oil Imports",data['supply_year'][Syear][19][1]]], type:'pie'}

          drillGas = {name:"Natural gas", id:"Natural gas",data:[["Gas Imports",data['supply_year'][Syear][21][1]],["Gas Production",data['supply_year'][Syear][22][1]]], type:'pie'}

          data_in = [{name:"Bioenergy",dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}},y:data['supply_year'][Syear][14][1], drilldown: drillBioenergy}, {name: "Cross Border Electricity Trade", y:data['supply_year'][Syear][7][1]},{name:"Coal", dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}}, y:data['supply_year'][Syear][17][1], drilldown: drillCoal},{name:"Renewables and Clean Energy",dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}}, y:data['supply_year'][Syear][8][1], drilldown: drillRenewables},{name:"Oil",dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}},y:data['supply_year'][Syear][20][1], drilldown: drillOil},{name:"Natural gas", dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}}, y:data['supply_year'][Syear][23][1], drilldown: drillGas}]



          window.SupplyDrill.series[i].setData(data_in,false)
          window.SupplyDrill.setTitle text: "Energy Supply - "+(y_txt).toFixed(0)+" TWh/yr"
          window.SupplyDrill.redraw()

          #alert drillTransport

          return
      return


  teardown: () ->
    $('#results').empty()

    @energy_comparison_chart = null

  updateResults: (@pathway) ->
    
    @setup() unless @energy_comparison_chart? && @energy_supply_chart?
 
    console.log @energy_comparison_chart

    #drill = ["Transport","Cooking","Buildings","Pumps& Tractors"]

    drillTransport = {name:"Transport", id:"Transport",data:[["Road transport",@pathway['demand_year'][2047][6][1]],["Rail transport",@pathway['demand_year'][2047][7][1]],["Domestic aviation",@pathway['demand_year'][2047][8][1]]], type:'	'}

    drillBuildings = {name:"Buildings", id:"Buildings",data:[["Commercial Lighting & Appliances",@pathway['demand_year'][2047][3][1]],["Domestic Lighting & appliances",@pathway['demand_year'][2047][2][1]],["Commercial Heating and cooling",@pathway['demand_year'][2047][1][1]],["Residential Heating and cooling",@pathway['demand_year'][2047][0][1]]], type:'pie'}

    i = 0

    data = [{name:"Telecom",y:@pathway['demand_year'][2047][11][1]}, {name:"Transport",dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}}, y:@pathway['demand_year'][2047][9][1],drilldown: drillTransport},{name: "Industry", y:@pathway['demand_year'][2047][5][1]},{name:"Cooking", y:@pathway['demand_year'][2047][12][1]},{name:"Buildings",dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}},y:@pathway['demand_year'][2047][4][1],drilldown: drillBuildings},{name:"Pumps & Tractors", y:@pathway['demand_year'][2047][10][1]}]

    
    if @energy_comparison_chart.series[i]?
      @energy_comparison_chart.series[i].setData(data,false)
       
    else
      @energy_comparison_chart.addSeries({name:'Energy Demand',colorByPoint: true, data:data},false)
 
    @energy_comparison_chart.setTitle({text:'Energy Demand - '+(@pathway['demand_year'][2047][13][1]).toFixed(0)+' TWh/yr'},false)


########### supply pie chart ########################

    drillBioenergy = {name:"Bioenergy", id:"Bioenergy",data:[["Agriculture",@pathway['supply_year'][2047][12][1]],["Biomass oversupply (imports)",@pathway['supply_year'][2047][13][1]],["Waste",@pathway['supply_year'][2047][11][1]]], type:'pie'}

    drillRenewables = {name:"Renewables and Clean Energy", id:"Renewables and Clean Energy",data:[["Nuclear",@pathway['supply_year'][2047][0][1]],["Solar",@pathway['supply_year'][2047][1][1]],["Wind",@pathway['supply_year'][2047][2][1]],["Hydro",@pathway['supply_year'][2047][6][1]]], type:'pie'}

    drillCoal = {name:"Coal", id:"Coal",data:[["Coal Imports",@pathway['supply_year'][2047][15][1]],["Coal Production",@pathway['supply_year'][2047][16][1]]], type:'pie'}

    drillOil = {name:"Oil", id:"Oil",data:[["Oil Production",@pathway['supply_year'][2047][18][1]],["Oil Imports",@pathway['supply_year'][2047][19][1]]], type:'pie'}

    drillGas = {name:"Natural gas", id:"Natural gas",data:[["Gas Imports",@pathway['supply_year'][2047][21][1]],["Gas Production",@pathway['supply_year'][2047][22][1]]], type:'pie'}


    i = 0

    data = [{name:"Bioenergy",dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}},y:@pathway['supply_year'][2047][14][1], drilldown: drillBioenergy}, {name: "Cross Border Electricity Trade", y:@pathway['supply_year'][2047][7][1]},{name:"Coal", dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}}, y:@pathway['supply_year'][2047][17][1], drilldown: drillCoal},{name:"Renewables and Clean Energy",dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}}, y:@pathway['supply_year'][2047][8][1], drilldown: drillRenewables},{name:"Oil",dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}},y:@pathway['supply_year'][2047][20][1], drilldown: drillOil},{name:"Natural gas", dataLabels: {style:{fontWeight: 'bold',textDecoration: 'underline'}}, y:@pathway['supply_year'][2047][23][1], drilldown: drillGas}]

    
    if @energy_supply_chart.series[i]?
      @energy_supply_chart.series[i].setData(data,false)
       
    else
      @energy_supply_chart.addSeries({name:'Energy Supply',colorByPoint: true, data:data},false)

    @energy_supply_chart.setTitle({text:'Energy Supply - '+(@pathway['primary_energy_supply']["Total Primary Supply"][7]).toFixed(0)+' TWh/yr'},false)
    

    @energy_comparison_chart.redraw()
    @energy_supply_chart.redraw()
    
window.twentyfifty.views['primary_energy_overview_chart'] = new PrimaryEnergyOverview
