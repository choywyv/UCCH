<%@ page import = "java.util.*" %>

<%@include file="/dbhelper.jsp" %>

<%!

  int i, col;
  String [] colnames;
  String quoteNum, s;
  Map<String,String []> map1, newmap;

%>

<%

  s = "";  
  quoteNum = (request.getParameter ("QuoteNum") == null) ? "" : request.getParameter ("QuoteNum");
  newmap = new HashMap<String, String []> ();
  map1 = new HashMap<String, String[]> (request.getParameterMap());

  for (Map<String, String> map: getRecords ("select DeductNum from Deductibles"))
    for (String ss : map.keySet ()) 
      for (String key : map1.keySet ())
        if (key.equals (map.get (ss)) && (!map1.get (key)[0].equals (""))) {  //out.println (ss + "<>" + map.get (ss) + "---" + key + " " + String.valueOf (key.equals (map.get (ss))) + "::::::::::::" + map1.get (key)[0] + "<br>"); 
          newmap.put ("QuoteNum", new String [] {quoteNum});
          newmap.put (ss, new String [] {key});
          newmap.put ("Amt", map1.get (key));


          if ((request.getParameter ("create") != null) && request.getParameter ("create").equals ("true")) {
            if (recordExists ("select * from QuoteDeductible where QuoteNum = '" + quoteNum + "' and DeductNum = '" + key + "'")) 
              updateRecord (getSQLUpdateStmt ("QuoteDeductible", newmap, new String [] {"QuoteNum='" + quoteNum + "'", "DeductNum='" + key + "'"}));             
            else out.println ( createRecord ("QuoteDeductible", newmap, new String [] {}));
          }  


        }
            
  colnames = getColumns ("Deductibles");

%>

<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
    
    </style>

    <script id="sc5">
      getDetails = function (obj, resultDiv) {
        document.getElementById (resultDiv).innerHTML = ajax ("minidetails.jsp?table=Deductibles&" + obj.id + "=" + obj.value, '', resultDiv);
      }

      formSubmit = function (f) {
        ajax ("deductible.jsp", f, "content");
      }

      
    </script>
  </head>

  <body>
  <%= s %>



    <button type="button" onclick="ajax ('quote.jsp?edit=true&QuoteNum=<%= quoteNum %>', '', 'content');">Back to Quote</button>
    <div class="aa" style="display: flex;">

      <div class="mainbody">

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;"><%= (quoteNum.equals ("")) ? "New " : "" %>Deductible</span><br>
        
        <form id="form1">

          <label style="display: inline-block; width: 120px; ">QuoteNum</label>
          <input type="text" name="QuoteNum" id="QuoteNum" value="<%= quoteNum %>" onfocus="getDetails (this, 'infodiv');" oninput="getDetails (this, 'infodiv');" readonly>
          <br>


          <table id="myTable" border="1">
            <tr>

              <%

                for (i = 2; i < colnames.length; i++) {

              %>     
          
              <th><%= colnames [i] %></th>

              <%

                }

              %>
              <th>Amount</th>
            </tr>

            <%  for (Map<String, String> map2: getRecords ("select * from Deductibles")) {  %>
   
            <tr>

     
              <%

                for (i = 2; i < colnames.length; i++) {

              %>     
          
              <td><%= map2.get (colnames [i]) %></td>

              <%

                }

              %>

              <td><input type="number" name="<%= map2.get ("DeductNum") %>" id="<%= map2.get (colnames [1]) %>" min="0" step="0.01" pattern="^\d+(?:\.\d{1,2})?$" value="<%= getFieldValue ("QuoteDeductible", "Amt", " where QuoteNum = '" + quoteNum + "' and DeductNum = '" + map2.get ("DeductNum") + "'") %>"></td>

            </tr>

            <%}%>

          </table>
 
          <input type="hidden" name="<%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? "update" : "create" %>" id="<%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? "update" : "create" %>" value="true">
          <button type="button" onclick="formSubmit (this.form);">Submit</button>  
        </form>

      </div>

      <div id="infodiv" style="border-style: dotted; left: 74%; width: 15%; position: fixed; "></div>

    </div>

  </body>
</html>