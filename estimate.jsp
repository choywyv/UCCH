<%@include file="/dbhelper.jsp" %>

<%!

  int i, col;
  String [] colnames;
  String incidentNum;

%>

<%

  colnames = getColumns ("Estimate");
  incidentNum = (request.getParameter ("IncidentNum") == null) ? "" : request.getParameter ("IncidentNum");

  if ((request.getParameter ("create") != null) && (request.getParameter ("create").equals ("true"))) 
    createRecord ("Estimate", request.getParameterMap(), new String [] {"EstimateNum"});
    
  if ((request.getParameter ("update") != null) && (request.getParameter ("update").equals ("true"))) 
       updateClaim (incidentNum, request.getParameter ("EstimateNum"), request.getParameter ("ClaimDate"), request.getParameter ("Type"),
        request.getParameter ("ClaimParty"), request.getParameter ("Currency"), request.getParameter ("EstimatedAmt"),  
        request.getParameter ("PaidAmt"), request.getParameter ("Remarks"),  request.getParameter ("Status")
      );

%>

<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
    
    </style>

    <script id="sc5">
      getDetails = function (obj, resultDiv) {
        document.getElementById (resultDiv).innerHTML = ajax ("minidetails.jsp?table=Estimate&" + obj.id + "=" + obj.value, '', resultDiv);
      }

      formSubmit = function (f) {
        ajax ("estimate.jsp", f, "content");
      }

      fakedata = function () {
        document.getElementById ("Handler").value = "myself";
        document.getElementById ("EstimateDate").value = "2018-06-02";
        document.getElementById ("CostsInternal").value="10000";
        document.getElementById ("CostsExternal").value="15000";
        document.getElementById ("CostsSettlement").value="18000";
        document.getElementById ("CostsRecovery").value="28000";
        document.getElementById ("Comments").value = "this is a comment";
      }
    </script>
  </head>

  <body>
<button type="button" onclick="fakedata ();">fakedata</button>
    <button type="button" onclick="ajax ('incident.jsp?edit=true&IncidentNum=<%= request.getParameter ("IncidentNum") %>', '', 'content');">Back to Incident</button>
    <div class="aa" style="display: flex;">

      <div class="mainbody">

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;"><%= (incidentNum.equals ("")) ? "New " : "" %>Estimate</span><br>
        
        <form id="form1">

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("Estimate", colnames [1]) %></label>
          <input type="text" name="<%= colnames [1] %>" id="<%= colnames [1] %>" value="<%= incidentNum %>" onfocus="getDetails (this, 'infodiv');" oninput="getDetails (this, 'infodiv');" readonly>
          <br>


          <%

            for (i = 3; i < colnames.length; i++) {

          %>

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("Estimate", colnames [i]) %></label>  
          <input type="<%= (getColTypeName ("Estimate", colnames [i]).equals ("datetime2")) ? "date"  : "text" %>" <%= (colnames [i].matches ("Currency")) ? "list=\"" + colnames [i] + "list\"" : "" %> name="<%= colnames [i] %>" id="<%= colnames [i] %>" placeholder="<%= getColumnDescription ("Estimate", colnames [i]) %> *" onfocus="getDetails (this, 'infodiv');" oninput="getDetails (this, 'infodiv');" 
          <%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? 
                  "value=\"" + ((getColTypeName ("Estimate", colnames [i]).equals ("datetime2")) ? 
                    getFieldValue ("Estimate", colnames [i], " where IncidentNum = '" + incidentNum + "'").split (" ") [0] : getFieldValue ("Estimate", colnames [i], " where IncidentNum = '" + incidentNum + "'") ) + "\"" : "" %>
          <%= (i == 1) ? " readonly" : "" %>> 
          
          <span id="span1"></span>
          <br>

          <%= colnames [i].equals ("Currency") ? getDatalist ("Countries", "Currency", true) : "" %>

          <%

            }

          %>
 
          <input type="hidden" name="<%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? "update" : "create" %>" id="<%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? "update" : "create" %>" value="true">
          <button type="button" onclick="formSubmit (this.form);">Submit</button>  
        </form>

      </div>

      <div id="infodiv" style="border-style: dotted; left: 74%; width: 15%; position: fixed; "></div>

    </div>

  </body>
</html>