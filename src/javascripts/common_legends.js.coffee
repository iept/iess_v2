highlightLegend = (box_id, item, hide) ->
  legend_text = "legend-item"+item
  if hide
    #alert "#"+box_id+ " ."+legend_text
    $("#"+box_id+ " div."+legend_text).addClass('legend-show');
  else
    $("#"+box_id+ " div."+legend_text).removeClass('legend-show');
  return

highlight = (series, index, hide) ->
  $(series).each (i, serie) ->
    unless i is index
      
      #serie.area.attr({ "fill": (hide ? "#D4D4D4": serie.color) });
      serie.area.attr opacity: ((if hide then 0.25 else 0.75))  if serie.type is "area"
      
      #/serie.area.attr({ "opacity": 0.75 });
      if serie.type is "column"
        $.each serie.data, (k, data) ->
          data.graphic.attr opacity: ((if hide then 0.25 else 1))  if data.series
          return

      if serie.type is "line"
        $.each serie.data, (k, data) ->
          data.series.graph and data.series.graph.attr("stroke", ((if hide then "#D4D4D4" else serie.color)))  if data.series
          return

    else
      if serie.type is "area"
        serie.area.attr fill: serie.color
        serie.area.attr opacity: 1
      if serie.type is "column"
        $.each serie.data, (k, data) ->
          data.graphic.attr opacity: 1  if data.series
          return

      if serie.type is "line"
        $.each serie.data, (k, data) ->
          data.series.graph and data.series.graph.attr("stroke", serie.color)  if data.series
          return

    return

  return
highData = (n, series, hide, name) ->
  if hide

    $("#display-data" + n + " #SeriesName").html series.name
    if name != 'Grid'
      Ddata = [
        Highcharts.numberFormat(series.yData[0], 0, ",")
        Highcharts.numberFormat(series.yData[3], 0, ",")
        Highcharts.numberFormat(series.yData[5], 0, ",")
        Highcharts.numberFormat(series.yData[7], 0, ",")
      ]

      i = 0

      while i < 4
        $("#display-data" + n + " #SeriesData" + i).html Ddata[i]
        i++
  else
    i = 0

    while i < 4
      $("#display-data" + n + " #SeriesData" + i).empty()
      i++
    $("#display-data" + n + " #SeriesName").empty()
  return
clickItem = (chartSeries, series, $legendItem, options, vCls) ->
  #console.log($legendItem)
  #alert(va)
  #alert(options)

  chartSeries.forEach (seri) ->

    seri.setVisible(false)
    if seri.name is series.name
      seri.setVisible()

    else
      return

    return
  $('.'+vCls).css display: "block" 

  #$legendItem.css options[(if series.visible then "itemHiddenStyle" else "itemStyle")]
  #$legendItem.css color: series.color  if series.visible
  return

ViewAllSeries = (chartSeries, vCls, va = null) ->
  console.log(chartSeries)
  $.each chartSeries, (i, seri) ->
    #alert(seri.name)
    seri.setVisible(true)  
    return 
  $('.'+vCls).css display: "none" 
  return


callCommon = (chartIdArr) ->
  i = 0

  while i < chartIdArr.length
    parentElement = $(chartIdArr[i])[0]
    
    #alert(parentElement.children[0].id);
    finalEnergyId[i] = parentElement.children[0].id  if parentElement.children[0]
    $("#custom-legend" + i).remove()
    $("#display-data" + i).remove()
    
    # 5 Nov , Intern's code
    # display data of series in container
    $xData = $("<div id=\"display-data" + i + "\">").css(
      width: "91%"
      marginLeft: 40
      marginTop: 5
      bottom: 0
      height: 38
    ).appendTo(chartIdArr[i])
    z = 0

    while z < 4
      $("<p id=\"SeriesData" + z + "\">").css(
        width: 43
        paddingRight: 5
        paddingLeft: 5
        color: "#000"
        margin: 0
        float: "left"
        fontWeight: "bold"
        fontSize: 10
      ).appendTo $xData
      z++

     $("<p id='SeriesName'></p>").css(
       width: "100%"
       float:"left"
       fontWeight: "bold"
       textAlign: "center"
       lineHeight: "15px"
      ).appendTo $xData
    
    # Create the legend box
    $legend[i] = $("<div id=\"custom-legend" + i + "\" class=\"custom-legends\"><div class=\"view view"+i+"\">View All</div>").css(
      minWidth: "120px"
      borderRadius: "5px"
      boxShadow: "0 0 0 1px #ddd"
      maxHeight: "250px !important"
      overflow: "auto "
      float: "left"
      backgroundColor: "#fff"
      top: "45px"
      left: "65px"
      opacity: "0.9"
      padding: "5px 5px 3px"
      position: "absolute",
      visibility: "hidden",
      transition: "visibility 0s linear 0.5s,opacity 0.5s linear";
    ).appendTo($("#" + finalEnergyId[i]))
    i++
  return

# .appendTo('#'+finalEnergyId[i]);

callLegand = (options0, chartSeries, l_index, chart_name) ->
  #alert(chart_name)
  #chartSeries = chartSeries[l_index]
  #console.log(chartSeries)
  # create the legend item
  $.each chartSeries, (i, series) -> 
    if series.name is 'Total demand' or series.name is 'Total supply' or series.name is 'Total'         
      $legendItem = $("<div class=\"legend-item" + series.index + "\">").css(
        position: "relative"
        paddingTo: 5
        paddingBottom: 2
      ).css(options0[(if series.visible then "itemStyle" else "itemHiddenStyle")]).css(
        color: series.color
        font: "normal 7pt sans-serif"
      ).html(series.name+'<div class="lin"></div>').appendTo($legend[l_index])
    else
      $legendItem = $("<div class=\"legend-item" + series.index + "\">").css(
        position: "relative"
        paddingTo: 5
        paddingBottom: 2
      ).css(options0[(if series.visible then "itemStyle" else "itemHiddenStyle")]).css(
        color: series.color
        font: "normal 7pt sans-serif"
      ).html(series.name).appendTo($legend[l_index])

    #click handler 

    $legendItem.click ->
      vCls = 'view'+l_index
      clickItem chartSeries, series, $legendItem, options0,vCls
      return 

    # legend mouseOver event
    $legendItem.hover (->
      $(this).css "fontWeight", "bold"
      highlight chartSeries, series.index, true
      highData l_index, series, true, chart_name
      return
    ), ->
      $(this).css "fontWeight", "normal"
      highlight chartSeries, series.index, false
      highData l_index, series, false
      return
    return  


  return

finalEnergyId = []
$legend = []

# End legend mouseOver event  



window.twentyfifty.highlightLegend = highlightLegend
window.twentyfifty.highlight = highlight
window.twentyfifty.highData = highData
window.twentyfifty.clickItem = clickItem
window.twentyfifty.ViewAllSeries = ViewAllSeries
window.twentyfifty.callCommon = callCommon
window.twentyfifty.callLegand = callLegand



