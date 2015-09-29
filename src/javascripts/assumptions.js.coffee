shareHTML = """
  <div id='assumption'> 
    <h1>Assumptions</h1>
    <table style='width:100%' id='g_assump' cellpadding='8' border=1>
      <tr class='tr_cls'>
        <th>Year</th>
        <th>Units</th>
        <th>2012</th>
        <th>2017</th>
        <th>2022</th>
        <th>2027</th>
        <th>2032</th>
        <th>2037</th>
        <th>2042</th>
        <th>2047</th>
      </tr>
    </table>
  </div>
"""

class Assumptions

  constructor: () ->
    @assumption = false

  setup: () ->
    return false if @assumption
    @assumption = true
    document.getElementById("results").style.width = "100%"
    $('#results').append(shareHTML)

    document.getElementById("pathway_box").style.display = "none"
    document.getElementById("classic_controls").style.display = "none"
    document.getElementById("display_table").style.display = "none"
    document.getElementById("print_div").style.display = "none"
    document.getElementById("warning").style.display = "none"
    $('#warning').empty()

    $('#print_div').append("<a href='javascript:void(0);' OnClick='CallPrint();' style='float:left; margin-top: 15px;'><img src='../../assets/images/print.png' title='Print' alt='Print' /></a>")
  teardown: () ->
    $('#results').empty()
    $('#print_div').empty()

    @assumption = false
  
  updateResults: (@pathway) ->
    @setup() unless @assumption



    $('#g_assump').append('<tr class=""><td style="font-weight: bold;">'+@pathway['global_assumption'][0][0]+'</td><td>'+@pathway['global_assumption'][0][1]+'</td><td>'+(@pathway['global_assumption'][0][2]).toFixed(2)+'</td><td>'+(@pathway['global_assumption'][0][3]).toFixed(2)+'</td><td>'+(@pathway['global_assumption'][0][4]).toFixed(2)+'</td><td>'+(@pathway['global_assumption'][0][5]).toFixed(2)+'</td><td>'+(@pathway['global_assumption'][0][6]).toFixed(2)+'</td><td>'+(@pathway['global_assumption'][0][7]).toFixed(2)+'</td><td>'+(@pathway['global_assumption'][0][8]).toFixed(2)+'</td><td>'+(@pathway['global_assumption'][0][9]).toFixed(2)+'</td></tr>')

    j = 1
    while j < 10
      if(j%2 == 0)
        cls = ''
      else
        cls = 'tr_cls'

      $('#g_assump').append('<tr class='+cls+'><td style="font-weight: bold;">'+@pathway['global_assumption'][j][0]+'</td><td>'+@pathway['global_assumption'][j][1]+'</td><td>'+(@pathway['global_assumption'][j][2])+'</td><td>'+(@pathway['global_assumption'][j][3])+'</td><td>'+(@pathway['global_assumption'][j][4])+'</td><td>'+(@pathway['global_assumption'][j][5])+'</td><td>'+(@pathway['global_assumption'][j][6])+'</td><td>'+(@pathway['global_assumption'][j][7])+'</td><td>'+(@pathway['global_assumption'][j][8])+'</td><td>'+(@pathway['global_assumption'][j][9])+'</td></tr>')
      j++
    

      

window.twentyfifty.views['assumptions'] = new Assumptions
