class CostsNew

  constructor: () ->

  setup: () ->
    document.getElementById("results").style.width = "65%"
    document.getElementById("warning").style.width = "22%"
    target = $('#results')
    target.append("<div id = 'increamental' class='chart'></div><div id='pathway' class='pathway_text'>This cost is <b>0%</b> of the cumulative GDP till the year 2047</div>")



    document.getElementById("increamental").style.width = "75%"


    document.getElementById("pathway_box").style.display = "block"
    document.getElementById("classic_controls").style.display = "block"
    document.getElementById("results").style.overflow = "inherit"
    document.getElementById("display_table").style.display = "block"
    document.getElementById("print_div").style.display = "none" 
    document.getElementById("warning").style.display = "block"
    $('#display').empty()
    $('#warning').empty()
    $('#display').append("<h5>Explore</h5><ul class='subnav'><li><a href='#' id='energy-subnav-1' class='' onclick='twentyfifty.switchView(\"total_cost\")'>Total Energy Cost</a></li><li><a href='#' id='energy-subnav-2' class='selected' onclick='twentyfifty.switchView(\"costs\")'>Cost Overview</a></li><li style='display:none'><a href='#' id='energy-subnav-3' class='' onclick='twentyfifty.switchView(\"costsYear\")'>Differential Cost Year-wise</a></li></ul>")
 

    @increamental_chart = new Highcharts.Chart({
      chart: {
        renderTo: 'increamental',
        type: 'bar',
        color: '#fff'
        height: 250,
        marginRight: 30,
        marginLeft: 70
      },
      title: { text: 'Cumulative Costs in INR Trillion' },
      subtitle: { text: ""},
      yAxis: { 
        labels: formatter: ->
          return Math.round(this.value/1)      
        title: null },

      xAxis: {
        categories: [ 
                     'Fossil Fuels',
                     'Bioenergy',
                     'Electricity',
                     'Buildings',
                     'Transport', 'Industry', 'Others', 'Finance','Total'],
        labels: 
          style:{
            color:'#000',
            width: '100px'
          },
          x:-3,

          formatter: ->
            @value

      },

      legend: {
        enabled: false
      },

      tooltip: { 
        enabled: true
        #crosshairs: true
        #shared: true
        style:
          fontSize: "9px"
          padding: "8px"
          color: "#000"
	
        useHTML: true,
        headerFormat: '{point.key}' + '' + '<table>',
        pointFormat: '<tr><td style="color: {series.color}">{series.name}: </td>' + '<td style="text-align: right">{point.y:.0f}</td></tr>',
        footerFormat: '</table>'
      },

      plotOptions: {
        bar: {
          dataLabels: {
            enabled: true,
            color: '#000',
            formatter: () ->
              Highcharts.numberFormat(this.y,0)
          }
        }
      }  

      series: []

    })


    #@pathway_chart = new Highcharts.Chart({
    #  chart: {
    #    renderTo: 'pathway',
    #    type: 'bar',
    #    color: '#fff',
    #
    #    height: 200,

    #    margin: [45, 25, 70, 140],
    # },
    #  title: { 
    #    text: 'Pathway costs as % of GDP(2012-47)' ,
    #    align:'center',
    #    x: 35
    #  },
    #  subtitle: { text: ""},

    #  xAxis: {
    #    categories: ['Your Pathway' ],
    #    labels: 
    #      style:{
    #        color:'#000',
    #        height: '1px'
    #      },

    #      formatter: ->
    #        @value

    #  },

    #  legend: {
    #    enabled: false
    #  },

    #  tooltip: {
    #    enabled: false
    #  },

    #  plotOptions: {
    #    bar: {
    #      dataLabels: {
    #        enabled: true,
    #        color: '#000',
    #        formatter: () ->
    #          Highcharts.numberFormat(this.y,2)
    #      }
    #    }
    #    series: {
    #      pointWidth: 40,
    #      marker: {
    #        enabled: false
    #      }
    #    }
    #  }  

    #  series: []

    #})  


  teardown: () ->
    #Return the results box to original position
 
    $('#results').empty()

    @increamental_chart = null
    #@pathway_chart = null
     

  updateResults: (@pathway) ->
    
    @setup() unless @increamental_chart? 
    
    data = [@pathway['increamental_costs']["Fossil Fuels"],@pathway['increamental_costs']["Bioenergy"],@pathway['increamental_costs']["Electricity"],@pathway['increamental_costs']["Buildings"],@pathway['increamental_costs']["Transport"],@pathway['increamental_costs']["Industry"],@pathway['increamental_costs']["Others"],@pathway['increamental_costs']["Finance"],@pathway['increamental_costs']["Total"]]

    if @increamental_chart.series[0]?
      @increamental_chart.series[0].setData(data,false)
    else
      @increamental_chart.addSeries({name: 'Cumulative Costs', data:data, color: 'rgb(247, 111, 111)', negativeColor:'rgb(136, 219, 5)'}, false)

    data_percent = []
    data_path = [@pathway['increamental_costs']["Your Pathway"]]
    console.log(data_path)
    data_percent[0] = Math.round((data_path[0]*100)* 100) / 100
 
    $("#pathway b").html(data_percent[0]+'%')  

    #alert(data_percent[0])
    #if @pathway_chart.series[0]?
    #  @pathway_chart.series[0].setData(data_path,false)
    #else
    #  @pathway_chart.addSeries({name: 'Pathway Cost', data:data_path, color: '#0000FF'},false)

    

    @increamental_chart.redraw()
    #@pathway_chart.redraw()

    document.getElementById("warning").innerHTML="<p>Observe the incremental costs of your pathway over and above the cost of the Determined Effort pathway.</br></br>Witness it as a percentage of the cumulative GDP for ease of comparison.</br></br><i>The vertical line represents the costs levelized at the Determined Effort Pathway costs.</i></p>"


window.twentyfifty.views['costs'] = new CostsNew
