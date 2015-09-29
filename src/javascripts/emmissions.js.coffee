class Emissions

  titles_emissions = ['Hydrocarbon fuel power generation',
                      'Buildings',
                      'Industry',
                      'Transport'
                      'Agriculture',
                      'Telecom',
                      'Fossil fuel production',
                      'Bioenergy',

  ]

  titles_charts = ['Hydrocarbon power generation',
                      'Buildings',
                      'Industry',
                      'Transport'
                      'Agriculture',
                      'Telecom',
                      'Fossil fuel Production',
                      'Bioenergy',

  ]

  titles_percapita = [
      "Hydrocarbon fuel power generation",
      "Buildings",
      "Industry",
      "Transport",
      "Agriculture",
      "Telecom",
      "Fossil fuel production",
      "Bioenergy",
  ]

  titles = titles_percapita

  constructor: () ->

  setup: () ->
    document.getElementById("results").style.width = "75%"
    $('#energy_container').empty()
    $('#results').append("<div id='energy_container'></div>")
    target = $('#energy_container')
    target.append("<div id='total_emissions_chart' class='chart'></div>")
    target.append("<div id='total_percapita_emissions_chart' class='chart'></div>")
    #target.append("<div id='emissions_chart_gdp' class='chart'></div>")
    target.append("<div id='total_percapita_emissions_map' style='height:250px; background-image:url(../../assets/images/india4_trans.gif);background-size: 100% 100%; background-repeat: no-repeat;' class='chart'><p style='color: #fff;margin-left: -45px;margin-top: 100px;text-align: center;font-weight: bold;'></p></div>");
    #target.append("<div id='emissions_chart' class='chart'></div>")

    document.getElementById("pathway_box").style.display = "block"
    document.getElementById("classic_controls").style.display = "block"
    document.getElementById("display_table").style.display = "block"
    document.getElementById("print_div").style.display = "none"
    document.getElementById("warning").style.display = "none"
    $('#warning').empty()
    $('#display').empty()
 
    $('#display').append("<h5>Explore</h5><ul class='subnav'><li><a href='#' id='energy-subnav-1' class='selected' onclick=''>Total and Per Capita Emissions</a></li><li style='display:none'><a href='#' id='energy-subnav-2' class='' onclick=''>Emissions 2</a></li><li style='display:none'><a href='#' id='energy-subnav-3' class='' onclick=''>Emissions 3</a></li></ul>")

    @total_emissions_chart = new Highcharts.Chart({
      chart: { renderTo: 'total_emissions_chart', height: 250, width: 300 },
      title: { text: 'Total Emissions' },
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
          y: -10,
          text: "MtCO<sub>2</sub>e/yr"
        }, width: 225, min: -500, max: 15000  },
      xAxis:{ width: 240},

      plotOptions:
        area:
          lineWidth: 0.1

        series:
          states:
            hover:
              enabled: true
              lineWidth: 2
              lineColor: "#6c6c6c"

          events:
            mouseOver: ->
              twentyfifty.highlightLegend "custom-legend0", this.index, true
              Ddata = [
                Highcharts.numberFormat(@yData[0], 1, ".")
                Highcharts.numberFormat(@yData[3], 1, ".")
                Highcharts.numberFormat(@yData[5], 1, ".")
                Highcharts.numberFormat(@yData[7], 1, ".")
              ]
              $("#display-data0 #SeriesName").html this.name
              i = 0

              while i < 4
                $("#display-data0 #SeriesData" + i).html Ddata[i]
                i++
              return

            mouseOut: ->
              twentyfifty.highlightLegend "custom-legend0", this.index, false
              i = 0

              while i < 4
                $("#display-data0 #SeriesData" + i).empty()
                i++
              $("#display-data0 #SeriesName").empty()
              return

      series: [],

      tooltip:{
        enabled: true,
        formatter: () ->
          "<b>#{this.series.name}</b><br/><b>#{this.x}: #{Highcharts.numberFormat(this.y,1)} MtCO2e/yr </b>"
        style:
          fontSize: "9px"
          padding: "8px"
        positioner: ->
          x: 65
          y: 0
      }
    })

    @total_percapita_emissions_chart = new Highcharts.Chart({
      chart: { renderTo: 'total_percapita_emissions_chart', height: 250, width: 300 },
      title: { text: 'Per Capita Emissions' },
      yAxis:

        title: {
          style: {
            fontWeight: "bold",
            color: "#154c85",
            fontSize: "10px"
          },
          align: "high",
          rotation: 0,
          textAlign: "left",
          x: -8,
          y: -10,
          text: "tCO2e/person per yr"
        }, 
        min: -2.5,
        max: 18,
        width: 225, 
      xAxis:{ width: 240},

      plotOptions:
        area:
          lineWidth: 0.1

        series:
          states:
            hover:
              enabled: true
              lineWidth: 2
              lineColor: "#6c6c6c"

          events:
            mouseOver: ->
              twentyfifty.highlightLegend "custom-legend1", this.index, true
              Ddata = [
                Highcharts.numberFormat(@yData[0], 1, ".")
                Highcharts.numberFormat(@yData[3], 1, ".")
                Highcharts.numberFormat(@yData[5], 1, ".")
                Highcharts.numberFormat(@yData[7], 1, ".")
              ]
              i = 0

              while i < 4
                $("#display-data1 #SeriesData" + i).html Ddata[i]
                i++
              return

            mouseOut: ->
              twentyfifty.highlightLegend "custom-legend1", this.index, false
              i = 0

              while i < 4
                $("#display-data1 #SeriesData" + i).empty()
                i++
              return

      series: [],
      legend: { enabled: false },
      tooltip:{
        enabled: true,
        formatter: () ->
          "<b>#{this.series.name}</b><br/><b>#{this.x}: #{Highcharts.numberFormat(this.y,1)} tCO2e/person per yr </b>"
        style:
          fontSize: "9px"
          padding: "8px"
        positioner: ->
          x: 65
          y: 0
      }
    })



  teardown: () ->
    $('#results').empty()

    #@emissions_chart = null
    @total_emissions_chart = null
    #@emissions_chart_gdp = null
    @total_percapita_emissions_chart = null

  updateResults: (@pathway) ->

    @setup() unless @emissions_chart_gdp? && @total_emissions_chart? && @total_percapita_emissions_chart?

    your_pathway = []
    do_nothing = []
    #for title in titles_emissions
    #  if(@pathway['emissions_do_nothing'][title][0]<0)
    #    your_pathway.push(-(@pathway['emissions_do_nothing'][title][2]/@pathway['emissions_do_nothing'][title][0]))
    #    do_nothing.push(-(@pathway['emissions_do_nothing'][title][1]/@pathway['emissions_do_nothing'][title][0]))
    #  else
    #    your_pathway.push((@pathway['emissions_do_nothing'][title][2]/@pathway['emissions_do_nothing'][title][0]))
    #    do_nothing.push((@pathway['emissions_do_nothing'][title][1]/@pathway['emissions_do_nothing'][title][0]))

    i = 0

    data = @pathway['emissions_absolute']['Total Emissions in MT CO2']
    if @total_emissions_chart.series[i]?
      @total_emissions_chart.series[i].setData(data,false)
    else
      @total_emissions_chart.addSeries({type: 'line', name: 'Total',data:data, lineColor: '#000', color: '#000',lineWidth:2,dashStyle:'Dot', shadow: false},false)
      i++

    for name in titles
      data = @pathway['emissions_absolute'][name]
      if @total_emissions_chart.series[i]?
        @total_emissions_chart.series[i].setData(data,false)
      else
        @total_emissions_chart.addSeries({name:titles_charts[i-1],data:data},false)
      i++

    data_2047 = @pathway["emissions_percapita"]["Total per capita Emissions in MT CO2"][7]
    $("#total_percapita_emissions_map p").html Highcharts.numberFormat(data_2047, 1, ".") + " tCO2e/capita<br>(2047)"
    $("#total_percapita_emissions_map").css backgroundColor: "#ccc"
    $("#total_percapita_emissions_map").css backgroundColor: "#bbb"  if data_2047 > 3.5 and data_2047 <= 4
    $("#total_percapita_emissions_map").css backgroundColor: "#aaa"  if data_2047 > 4 and data_2047 <= 4.5
    $("#total_percapita_emissions_map").css backgroundColor: "#999"  if data_2047 > 4.5 and data_2047 <= 5
    $("#total_percapita_emissions_map").css backgroundColor: "#888"  if data_2047 > 5 and data_2047 <= 5.5
    $("#total_percapita_emissions_map").css backgroundColor: "#777"  if data_2047 > 5.5 and data_2047 <= 6
    $("#total_percapita_emissions_map").css backgroundColor: "#666"  if data_2047 > 6 and data_2047 <= 6.5
    $("#total_percapita_emissions_map").css backgroundColor: "#555"  if data_2047 > 6.5 and data_2047 <= 7
    $("#total_percapita_emissions_map").css backgroundColor: "#444"  if data_2047 > 7 and data_2047 <= 7.5
    $("#total_percapita_emissions_map").css backgroundColor: "#333"  if data_2047 > 7.5 and data_2047 <= 8
    $("#total_percapita_emissions_map").css backgroundColor: "#222"  if data_2047 > 8 and data_2047 <= 8.5

    i = 0

    data = @pathway['emissions_percapita']['Total per capita Emissions in MT CO2']
    if @total_percapita_emissions_chart.series[i]?
      @total_percapita_emissions_chart.series[i].setData(data,false)
    else
      @total_percapita_emissions_chart.addSeries({type: 'line', name: 'Total',data:data, lineColor: '#000', color: '#000',lineWidth:2,dashStyle:'Dot', shadow: false},false)
      i++

    for name in titles_percapita
      data = @pathway['emissions_percapita'][name]
      if @total_percapita_emissions_chart.series[i]?
        @total_percapita_emissions_chart.series[i].setData(data,false)
      else
        @total_percapita_emissions_chart.addSeries({name:titles_charts[i-1],data:data},false)
      i++


      #@total_percapita_emissions_chart.addSeries({type: 'scatter', name: "China 2010 emissions", data: [6.194], color: '#ff0000'})
      #@total_percapita_emissions_chart.addSeries({type: 'scatter', name: "US 2010 emissions", data: [17.564], color: 'Green'})
      #@total_percapita_emissions_chart.addSeries({type: 'scatter', name: "UK 2010 emissions", data: [7.925], color: 'Blue'})


    # **************** Start Custom Legand *****************     
    ChartArr = [
      @total_emissions_chart.series
      @total_percapita_emissions_chart.series
    ]

    optionsArr = [
      @total_emissions_chart.options.legend
      @total_percapita_emissions_chart.options.legend
    ]

    chartIdArr = [
      "#total_emissions_chart"
      "#total_percapita_emissions_chart"
    ]

    # calling common layout of legand

    twentyfifty.callCommon chartIdArr

    # Creating legand
    # Display data of corresponding series on mouse over on legand item
    # On mouse over respective series will highlight and other will fade out
    # Data will display on mouse over on series area 

    L = 0
    K = 0
    charts_id = []
    while L < 2
      chartSeries = []
      chartSeries = ChartArr[L]
      options = optionsArr[L]

      twentyfifty.callLegand options, chartSeries, L, null

      parentElement = $(chartIdArr[L])[0]
      charts_id.push parentElement.children[0].id

      L++

####### .view is a class of 'View All' item in legand list. #######
    i = 0
    $('.view0').click ->

      twentyfifty.ViewAllSeries ChartArr[0], "view0", "viewAll"

      return

    $('.view1').click ->

      twentyfifty.ViewAllSeries ChartArr[1], "view1", "viewAll"

      return


######### End View  All click function ######################


    $("#"+charts_id[0]).mouseover ->
      $("#custom-legend0").css visibility: "visible"
      $("#custom-legend0").css opacity: "0.9"
    $("#"+charts_id[0]).mouseout ->
      $("#custom-legend0").css visibility: "hidden"
      $("#custom-legend0").css opacity: 0

    $("#"+charts_id[1]).mouseover ->
      $("#custom-legend1").css visibility: "visible"
      $("#custom-legend1").css opacity: "0.9"
    $("#"+charts_id[1]).mouseout ->
      $("#custom-legend1").css visibility: "hidden"
      $("#custom-legend1").css opacity: 0

    # **************** End Custom Legand ***************** 


    @total_emissions_chart.redraw()
    @total_percapita_emissions_chart.redraw()

window.twentyfifty.views['emissions'] = new Emissions
