<%@include file="/dbhelper.jsp" %>

<%!

  int i, col;
  String [] colnames;
  String policyNum;

%>

<%

  colnames = getColumns ("Declaration");
  policyNum = (request.getParameter ("PolicyNum") == null) ? "" : request.getParameter ("PolicyNum");

  if ((request.getParameter ("create") != null) && (request.getParameter ("create").equals ("true"))) 
    createRecord ("Declaration", request.getParameterMap(), new String [] {"DeclareNum"});
    
  if ((request.getParameter ("update") != null) && (request.getParameter ("update").equals ("true"))) 
       updateClaim (policyNum, request.getParameter ("DeclarationNum"), request.getParameter ("ClaimDate"), request.getParameter ("Type"),
        request.getParameter ("ClaimParty"), request.getParameter ("Currency"), request.getParameter ("DeclarationdAmt"),  
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
        document.getElementById (resultDiv).innerHTML = ajax ("minidetails.jsp?table=Ships&" + obj.id + "=" + obj.value, '', resultDiv);
      }

      formSubmit = function (f) {
        ajax ("declaration.jsp", f, "content");
      }

      fakedata = function () {
        document.getElementById ("EffectiveDate").value="2018-06-02";
        document.getElementById ("ExpiryDate").value="2018-06-02";
        document.getElementById ("Amt").value="10000";
        document.getElementById ("Comments").value="To insure this ship.";
      }
    </script>
  </head>

  <body>
<button type="button" onclick="fakedata ();">fakedata</button>
    <button type="button" onclick="ajax ('policy.jsp?edit=true&PolicyNum=<%= policyNum %>', '', 'content');">Back to Policy</button>
    <div class="aa" style="display: flex;">

      <div class="mainbody">

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;"><%= (policyNum.equals ("")) ? "New " : "" %>Declaration</span><br>
        
        <form id="form1">

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("Declaration", colnames [2]) %></label>
          <input type="text" name="<%= colnames [2] %>" id="<%= colnames [2] %>" value="<%= policyNum %>" onfocus="getDetails (this, 'infodiv');" oninput="getDetails (this, 'infodiv');" readonly>
          <br>

          <%

            for (i = 3; i < colnames.length; i++) {

          %>

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("Declaration", colnames [i]) %></label>  
          <input type="<%= (getColTypeName ("Declaration", colnames [i]).equals ("datetime2")) ? "date"  : "text" %>" <%= (colnames [i].matches ("Currency")) ? "list=\"" + colnames [i] + "list\"" : "" %> name="<%= colnames [i] %>" id="<%= colnames [i] %>" placeholder="<%= getColumnDescription ("Declaration", colnames [i]) %> *" onfocus="getDetails (this, 'infodiv');" oninput="getDetails (this, 'infodiv');" 
          <%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? 
                  "value=\"" + ((getColTypeName ("Declaration", colnames [i]).equals ("datetime2")) ? 
                    getFieldValue ("Declaration", colnames [i], " where policyNum = '" + policyNum + "'").split (" ") [0] : getFieldValue ("Declaration", colnames [i], " where policyNum = '" + policyNum + "'") ) + "\"" : "" %>
          <%= (i == 1) ? " readonly" : "" %>> 

          <%= (colnames [i].equals ("ShipNum")) ? "<button type=\"button\" onclick=\"document.getElementById ('id02').style.display='block';\" style=\"width:auto; font-size: 80%;\">Search Ship</button>" : "" %>          
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

    <jsp:include page="searchpopup.jsp" >
      <jsp:param name="elementId" value="id02" />
      <jsp:param name="source" value="policy" />
      <jsp:param name="report" value="shiplisting" />
      <jsp:param name="callerElement" value="ShipNum" />
      <jsp:param name="title" value="Ship" />
    </jsp:include>

  </body>
</html>