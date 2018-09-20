<%@ page import = "java.util.*" %>

<%@include file="/dbhelper.jsp" %>

<%!

  int i, col;
  String [] colnames;
  String incidentNum, policyNum, s;
  Map<String,String []> map1, newmap;

%>

<%

  s = "";  
  incidentNum = (request.getParameter ("IncidentNum") == null) ? "" : request.getParameter ("IncidentNum");
  policyNum = getFieldValue ("Incidents", "PolicyNum", " where IncidentNum = '" + incidentNum + "'");
  newmap = new HashMap<String, String []> ();
  map1 = new HashMap<String, String[]> (request.getParameterMap());

  for (Map<String, String> map: getRecords ("select DeductNum from Deductibles"))
    for (String ss : map.keySet ()) 
      for (String key : map1.keySet ())
        if (key.equals (map.get (ss)) && (!map1.get (key)[0].equals (""))) {  //out.println (ss + "<>" + map.get (ss) + "---" + key + " " + String.valueOf (key.equals (map.get (ss))) + "::::::::::::" + map1.get (key)[0] + "<br>"); 
          newmap.put ("IncidentNum", new String [] {incidentNum});
          newmap.put (ss, new String [] {key});
          newmap.put ("Amt", map1.get (key));

          if ((request.getParameter ("create") != null) && (request.getParameter ("create").equals ("true"))) //out.println (
            s += getSQLInsertStmt ("QuoteLine", newmap);
        }

  colnames = getColumns ("PolicyLine");

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
        ajax ("collectdeduct.jsp", f, "content");
      }

      fakedata = function () {
        document.getElementById ("ClaimDate").value="2018-06-02";
        document.getElementById ("Type").value="Expense";
        document.getElementById ("ClaimParty").value="Lawers Inc LLP";
        document.getElementById ("Currency").value="USD";
        document.getElementById ("EstimatedAmt").value="10000";
        document.getElementById ("PaidAmt").value="0";
        document.getElementById ("Remarks").value="Lawyer fees";
        document.getElementById ("Status").value="Open";
      }
    </script>
  </head>

  <body>
  <%= s %>
<button type="button" onclick="fakedata ();">fakedata</button>

    <button type="button" onclick="ajax ('incident.jsp?edit=true&IncidentNum=<%= incidentNum %>', '', 'content');">Back to Incident</button>
    <div class="aa" style="display: flex;">

      <div class="mainbody">

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;">Deductible</span><br>
        
        <form id="form1">

          <label style="display: inline-block; width: 120px; ">IncidentNum</label>
          <input type="text" name="IncidentNum" id="IncidentNum" value="<%= incidentNum %>" onfocus="getDetails (this, 'infodiv');" oninput="getDetails (this, 'infodiv');" readonly>
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

            </tr>

            <%  for (Map<String, String> map: getRecords ("select * from PolicyLine where PolicyNum = '" + policyNum + "'")) {  %>
   
            <tr>

     
              <%

                for (i = 2; i < colnames.length; i++) {

              %>     
          
              <td>
                <%= colnames [i].equals ("Description") ? getFieldValue ("Deductibles", "Description", " where DeductNum='" + map.get (colnames [i - 1]) + "'") :
                    colnames [i].equals ("Amt") ? "<input type=\"text\" name=\"" + map.get ("DeductNum") + "\" id=\"" + map.get ("DeductNum") + "\" value=\"" + map.get (colnames [i]) + "\">" : map.get (colnames [i]) %>
              </td>

              <%

                }

              %>



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