<%@include file="/dbhelper.jsp" %>

<%!

  int i, col;
  String [] colnames;
  String claimNum;

%>

<%

  colnames = getColumns ("ClaimSub");
  claimNum = (request.getParameter ("ClaimNum") == null) ? "" : request.getParameter ("ClaimNum");

  if ((request.getParameter ("create") != null) && (request.getParameter ("create").equals ("true"))) 
    createRecord ("ClaimSub", request.getParameterMap(), new String [] {"ClaimNum"});
    
  if ((request.getParameter ("update") != null) && (request.getParameter ("update").equals ("true"))) 
       updateClaim (claimNum, request.getParameter ("ClaimNum"), request.getParameter ("ClaimDate"), request.getParameter ("Type"),
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
        document.getElementById (resultDiv).innerHTML = ajax ("minidetails.jsp?table=Claims&" + obj.id + "=" + obj.value, '', resultDiv);
      }

      formSubmit = function (f) {
        ajax ("claim.jsp", f, "content");
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
<button type="button" onclick="fakedata ();">fakedata</button>
    <button type="button" onclick="ajax ('claim.jsp?edit=true&ClaimNum=<%= request.getParameter ("ClaimNum") %>', '', 'content');">Back to Claim</button>
    <div class="aa" style="display: flex;">

      <div class="mainbody">

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;"><%= (claimNum.equals ("")) ? "New " : "" %>Claim</span><br>
        
        <form id="form1">

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("ClaimSub", colnames [1]) %></label>
          <input type="text" name="<%= colnames [1] %>" id="<%= colnames [1] %>" value="<%= claimNum %>" onfocus="getDetails (this, 'infodiv');" oninput="getDetails (this, 'infodiv');" readonly>
          <br>


          <%

            for (i = 3; i < colnames.length; i++) {

          %>

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("ClaimSub", colnames [i]) %></label>  
          <input type="<%= (getColTypeName ("ClaimSub", colnames [i]).equals ("datetime2")) ? "date"  : "text" %>" <%= (colnames [i].matches ("Currency")) ? "list=\"" + colnames [i] + "list\"" : "" %> name="<%= colnames [i] %>" id="<%= colnames [i] %>" placeholder=<%= getColumnDescription ("ClaimSub", colnames [i]) %> *" onfocus="getDetails (this, 'infodiv');" oninput="getDetails (this, 'infodiv');" 
          <%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? 
                  "value=\"" + ((getColTypeName ("ClaimSub", colnames [i]).equals ("datetime2")) ? 
                    getFieldValue ("ClaimSub", colnames [i], " where ClaimNum = '" + claimNum + "'").split (" ") [0] : getFieldValue ("ClaimSub", colnames [i], " where ClaimNum = '" + claimNum + "'") ) + "\"" : "" %>
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