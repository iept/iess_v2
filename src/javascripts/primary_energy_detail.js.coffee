

class PrimaryEnergyDetail

  constructor: () ->

  setup: () ->

    $('#results').append("<div id='energy_container'></div>")
    target = $('#energy_container')

    document.getElementById("display_table").style.display = "block"
    document.getElementById("print_div").style.display = "none"
    document.getElementById("pathway_box").style.display = "block"
    document.getElementById("classic_controls").style.display = "block"
    target.append("<div id='demand_chart' class='chart'></div>")
    target.append("<div id='supply_chart' class='chart'></div>")
    target.append("<div id='comparison_chart' class='chart'></div>")
    document.getElementById("warning").style.display = "none"
    $('#warning').empty()
    $('#display').empty()

    $('#display').append("<h5>Explore</h5><ul class='subnav'><li><a href='#' id='energy-subnav-1' class='' onclick='twentyfifty.switchView(\"primary_energy_chart\")'>Energy Demand & Supply</a></li><li><a href='#' id='energy-subnav-2' class='' onclick='twentyfifty.switchView(\"primary_energy_overview_chart\")'>Sector-wise Drilldown</a></li><li><a href='#' id='energy-subnav-3' class='selected' onclick='twentyfifty.switchView(\"primary_energy_detail_chart\")'>Compare 2012 and 2047</a></li></ul>")
    
    #$('#warning').append("<h5>Warning</h5>")
    @energy_demand_chart = new Highcharts.Chart({
      chart: { renderTo: 'demand_chart', height: 250, width: 300, type: 'column' },
      title: { text: 'Energy Demand' },
      yAxis: {
        labels: formatter: ->
          return Math.round(this.value/1000) + 'k'

        title: {
          style: {
            fontWeight: "bold",
            color: "#154c85",
            fontSize: "10px"
          },
          align: "high",
          rotation: 0,
          textAlign: "left",
          x: 0,
          y: -15,
          text: "TWh/yr"
        }, 
        min: 0, 
        max: 24000, 
        width: 225 
      },
      xAxis:{ 
        width: 240,
        categories: [2012, 2047] },
      legend:{
        itemStyle: { fontSize: '7pt' }
      },
      tooltip: { 
        enabled: true
        #crosshairs: true
        shared: true
        style:
          fontSize: "9px"
          padding: "8px"
        positioner: ->
          x: 5
          y: 30
	
        useHTML: true,
        headerFormat: '{point.key}' + ' (TWh/yr)' + '<table>',
        pointFormat: '<tr><td style="color: {series.color}">{series.name}: </td>' + '<td style="text-align: right">{point.y:.0f}</td></tr>',
        footerFormat: '</table>'
      }
      plotOptions:
        column:
          stacking: 'normal'
          dataLabels: {
            enabled: false
          }


      series: []
    })


    @energy_supply_chart = new Highcharts.Chart({
      chart: { renderTo: 'supply_chart', height: 250, width: 300, type: 'column' },
      title: { text: 'Energy Supply' },
      yAxis: {
        labels: formatter: ->
          return Math.round(this.value/1000) + 'k'

        title: {
          style: {
            fontWeight: "bold",
            color: "#154c85",
            fontSize: "10px"
          },
          align: "high",
          rotation: 0,
          textAlign: "left",
          x: 0,
          y: -15,
          text: "TWh/yr"
        }, 
        min: 0, 
        max: 24000, 
        width: 225 
      },
      xAxis:{ 
        width: 240,
        categories: [2012, 2047] },
      legend:{
        itemStyle: { fontSize: '7pt' }
      },
      tooltip: { 
        enabled: true
        #crosshairs: true
        shared: true
        style:
          fontSize: "9px"
          padding: "8px"
        positioner: ->
          x: 5
          y: 30
	
        useHTML: true,
        headerFormat: '{point.key}' + ' (TWh/yr)' + '<table>',
        pointFormat: '<tr><td style="color: {series.color}">{series.name}: </td>' + '<td style="text-align: right">{point.y:.0f}</td></tr>',
        footerFormat: '</table>'
      }
      plotOptions:
        column:
          stacking: 'normal'
          dataLabels: {
            enabled: false
          }


      series: []
    })

    @energy_comparison_chart = new Highcharts.Chart({
      chart: { renderTo: 'comparison_chart', type: 'pie', width:300, height:250 },
      title: { text: 'Energy Scenario in 2047'},
   
      tooltip: { 
        enabled: true       
        pointFormat: '{point.name}: <b>{point.y:.0f}</b>',
      }
      plotOptions: {
        pie: {
          size: '100%',
          y:200,
          dataLabels: {

            enabled: true,
            format: '{point.name}: <br><b>{point.y:.0f} TWh/yr</b>',
            distance: -0.9,
            x:0,
            y:-70,
            style: {
              color: '#000',
            }
          },
          startAngle: -90,
          endAngle: 90,
          center: ['50%', '110%']
        }
      },


      series: []
    })

  teardown: () ->
    $('#results').empty()
    $('#energy_container').empty()

    @energy_demand_chart = null
    @energy_supply_chart = null
    @energy_comparison_chart = null

  updateResults: (@pathway) ->
    
    @setup() unless @energy_demand_chart? && @energy_supply_chart? && @energy_comparison_chart

    titles = ["Telecom","Transport","Industry","Cooking","Buildings","Pumps& Tractors",
    ]
    i = 0
    for name in titles

      data = [@pathway['final_energy_demand'][name][0], @pathway['final_energy_demand'][name][7]]
      #console.log data
      if @energy_demand_chart.series[i]?
        @energy_demand_chart.series[i].setData(data,false)
      else
        @energy_demand_chart.addSeries({name:name,data:data},false)
      i++

    titles =["Bioenergy","Renewables and Clean Energy","Electricity oversupply (imports)","Coal","Oil and petroleum products","Natural gas"]
    titles_tool =["Bioenergy","Renewables and Clean Energy","Cross Border Electricity Trade","Coal","Oil","Natural gas"]
    i = 0
    for name in titles
      data = [@pathway['primary_energy_supply'][name][0], @pathway['primary_energy_supply'][name][7]]
      if @energy_supply_chart.series[i]?
        @energy_supply_chart.series[i].setData(data,false)
      else
        @energy_supply_chart.addSeries({name:titles_tool[i],data:data},false)
      i++

    titles =["Demand","Supply"]
    i = 0
    for name in titles
      data = [['Energy Demand',@pathway['final_energy_demand']["Scenario Demand"][7]], ['Primary Energy Supply',@pathway['primary_energy_supply']["Total Primary Supply"][7]]]
      if @energy_comparison_chart.series[i]?
        @energy_comparison_chart.series[i].setData(data,false)
      else
        @energy_comparison_chart.addSeries({type: 'pie', name: name, innerSize: '50%' , data:data},false)
      i++

    @energy_demand_chart.redraw()
    @energy_supply_chart.redraw()
    @energy_comparison_chart.redraw()
    
window.twentyfifty.views['primary_energy_detail_chart'] = new PrimaryEnergyDetail
