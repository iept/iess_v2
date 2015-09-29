class GridBalancingSummer

  constructor: () ->
    @ready = false
  
  setup: () ->
    document.getElementById("results").style.width = "75%"
    document.getElementById("warning").style.width = "13%"
    $('#energy_container').empty()
    $('#results').append("<div id='energy_container'></div>")
    target = $('#energy_container')
    target.append("<div id='summer_chart' class=''></div>")

    document.getElementById("pathway_box").style.display = "block"
    document.getElementById("summer_chart").style.display = "block"
    document.getElementById("display_table").style.display = "block"
    document.getElementById("print_div").style.display = "none"
    document.getElementById("warning").style.display = "block"
    $('#warning').empty()
    $('#display').empty()
 
    $('#display').append("<h5>Explore</h5><ul class='subnav'><li><a href='#' id='energy-subnav-1' class='selected' onclick='twentyfifty.switchView(\"grid_balancing_summer\")'>Typical Summer Day</a></li><li><a href='#' id='energy-subnav-2' class='' onclick='twentyfifty.switchView(\"grid_balancing_monsoon\")'>Typical Monsoon Day</a></li><li><a href='#' id='energy-subnav-3' class='' onclick='twentyfifty.switchView(\"grid_balancing_winter\")'>Typical Winter Day</a></li></ul>")
    
    #$('#warning').append("<h5>Warning</h5>")

    @summer_chart = new Highcharts.Chart({
      chart: { renderTo: 'summer_chart', height: 250},
      title: { text: 'Grid dispatch pattern for your chosen pathway', y:10 },
      subtitle: { text: 'Typical Summer Day (in hrs)' },
      yAxis: {


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
          text: "TWh"
        }
      },
      xAxis:{
        categories: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],
        labels: {
          align: 'center',
          formatter: ->
            @value
        },

      },
      legend:{
        itemStyle: { fontSize: '7pt' }
      },
      tooltip:{
        enabled: true,
        formatter: () ->
          "<b>#{this.series.name}</b><br/><b>#{this.x}: #{Highcharts.numberFormat(this.y,0)} TWh </b>"
        style:
          fontSize: "9px"
          padding: "8px"
        positioner: ->
          x: 65
          y: 0
      },
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
                Highcharts.numberFormat(@yData[0], 0, ",")
                Highcharts.numberFormat(@yData[3], 0, ",")
                Highcharts.numberFormat(@yData[5], 0, ",")
                Highcharts.numberFormat(@yData[7], 0, ",")
              ]
              $("#display-data0 #SeriesName").html this.name
              
            mouseOut: ->
              twentyfifty.highlightLegend "custom-legend0", this.index, false
              $("#display-data0 #SeriesName").empty()

      series: []
    })
  
  teardown: () ->
    $('#results').empty()
    $('#energy_container').empty()
    $('#warning').empty()
    @summer_chart = null
  
  updateResults: (@pathway) ->
 
    @setup() unless @summer_chart

    titles = ["Coal", "Gas", "Nuclear", "Hydro", "Other Renewable Energy", "Wind","Solar", "Electricity Imports", "Additional Grid Balancing", "RE Curtailment"]
    color = ["#2f7ed8", "#CC6699", "#0d233a", "#FF9900", "#0f6b62", "#be9d4f","rgb(145,0,0)", "#709d40", "rgb(73, 41, 112)", "rgb(242, 143, 67)"]
    i = 0

    for name in titles
      data = @pathway['grid_balancing_summer'][name]
      if @summer_chart.series[i]?
        @summer_chart.series[i].setData(data,false)
      else
        @summer_chart.addSeries({name:name,data:data,color:color[i]},false)
      i++


    ########## **************** Start Custom Legand ***************** ##########     

##### Created an array ChartArr, optionsArr, chartIdArr to get the data of series , legand and chart id to create custom legand

    ChartArr = [
      @summer_chart.series
    ]

    optionsArr = [
      @summer_chart.options.legend
    ]
    chartIdArr = [
      "#summer_chart"
    ]

##### calling common layout of legand

    twentyfifty.callCommon chartIdArr

##### Creating legand
##### Display data of corresponding series on mouse over on legand item
##### On mouse over respective series will highlight and other will fade out
##### Data will display on mouse over on series area 

    L = 0
    K = 0
    charts_id = []
    while L < 1
      chartSeries = []
      chartSeries = ChartArr[L]
      options = optionsArr[L]

      twentyfifty.callLegand options, chartSeries, L, "Grid"

      parentElement = $(chartIdArr[L])[0]
      charts_id.push parentElement.children[0].id

      L++


####### .view is a class of 'View All' item in legand list. #######
    i = 0
    $('.view0').click ->

      twentyfifty.ViewAllSeries ChartArr[0], "view0", "viewAll"

      return

######### End View  All click function ######################

########### This is for legand list visibilite on mouse over and mouse out ##################

    $("#"+charts_id[0]).mouseover ->
      $("#custom-legend0").css visibility: "visible"
      $("#custom-legend0").css opacity: "0.9"
    $("#"+charts_id[0]).mouseout ->
      $("#custom-legend0").css visibility: "hidden"
      $("#custom-legend0").css opacity: 0

######### End mouse over and nouse out code ######################


    ########## **************** End Custom Legand ***************** #############   


    @summer_chart.redraw()   
  
    document.getElementById("warning").innerHTML="<p>"+@pathway['grid_msg1']+"<br><br>"+@pathway['grid_msg2']+"</p>"

window.twentyfifty.views['grid_balancing_summer'] = new GridBalancingSummer
