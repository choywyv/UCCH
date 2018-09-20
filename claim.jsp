<%@ page import = "java.util.*" %>

<%@include file="/dbhelper.jsp" %>

<%!

  int i, col;
  String s;
  String [] colnames;
  Claim claim;

  private class Claim {

    Map <String, String> claim;

    public Claim (String claimNum) throws Exception {      
      claim = claimNum.equals ("") ? new HashMap <String, String> () : getRecords ("select ClaimNum, PolicyNum, CONVERT(varchar, ClaimDate, 23) AS ClaimDate, NotificationDate, Status, Description, Location, PaidAmt, OutstandingAmt, TotalIncurredAmt, Remarks, VendNum from Claim where ClaimNum = '" + claimNum + "'").get (0);
    }

    public String get (String fieldValue) throws Exception {
      return (claim.get (fieldValue) == null) ? "" : claim.get (fieldValue);  
    }

    String create (Map<String, String[]> map) throws Exception {
      return createRecord ("Claim", map, new String [] {"ClaimNum"}); 
    }

    String update (Map<String, String[]> map, String[] additional) throws Exception {
      return updateRecord (getSQLUpdateStmt ("Claim", map, additional));
    }

  }  

%>

<%

  claim = new Claim ((request.getParameter ("ClaimNum") == null) ? "" : request.getParameter ("ClaimNum"));

  s = "";

  if ((request.getParameter ("create") != null) && (request.getParameter ("create").equals ("true"))) {
//    s = getSQLInsertStmt ("Claim", request.getParameterMap());
    s = claim.create (request.getParameterMap());    
  }

  if ((request.getParameter ("update") != null) && (request.getParameter ("update").equals ("true"))) 
    s = claim.update (request.getParameterMap(), new String [] {"ClaimNum='" + claim.get ("ClaimNum") + "'"});

  colnames = getColumns ("Claim");


%>

<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
      <%= (! claim.get ("ClaimNum").equals ("")) ? "#form1 { pointer-events: none; }" : "" %>    
    </style>

    <script id="sc1">
      getDetails = function (obj, resultDiv) {
        document.getElementById (resultDiv).innerHTML = ajax ("minidetails.jsp?table=PolicyHeader&" + obj.id + "=" + obj.value, '', resultDiv);
      }

      formSubmit = function (f) {
        ajax ("claim.jsp", f, "content");
      }

      fakedata = function () {
        document.getElementById ("ClaimDate").value="2018-04-01";
        document.getElementById ("Status").value="Open";
        document.getElementById ("Description").value="Hijack";
        document.getElementById ("Location").value="Australia";
        document.getElementById ("PaidAmt").value="0";
        document.getElementById ("OutstandingAmt").value="0";
        document.getElementById ("Remarks").value="remarks";
        document.getElementById ("Correspondent").value="correspondent";
        document.getElementById ("TotalIncurredAmt").value="0";
      }

    </script>
  </head>

  <body>
    <button type="button" onclick="fakedata ();">fakedata</button>   

    <div class="aa" style="display: flex;">

      <div class="mainbody">

        <div>
          <ul id="sub">
            <li><a class="active" href="#" id="claim" onclick="setMenuActive ('sub', this); document.getElementById ('divform1').style.display='block'; document.getElementById ('divclaimsub').style.display='none'; document.getElementById ('divestimate').style.display='none'; document.getElementById ('divdeduct').style.display='none'; document.getElementById ('divtimesheet').style.display='none';">Claim</a></li>
            <%
           
              if (! claim.get ("ClaimNum").equals ("")) {

            %>

            <li><a class="inactive" href="#" id="estimatesdiv" onclick="setMenuActive ('sub', this); setDivActive ('divisibility', 'divestimate');">Estimates</a></li>
            <li><a class="inactive" href="#" id="claimsubdiv" onclick="setMenuActive ('sub', this); setDivActive ('divisibility', 'divclaimsub'); ">SubClaims</a></li>
            <li><a class="inactive" href="#" id="deductiblesidv" onclick="setMenuActive ('sub', this); setDivActive ('divisibility', 'divdeduct');">Deductibles</a></li>
            <li><a class="inactive" href="#" id="timesheetdiv" onclick="setMenuActive ('sub', this); setDivActive ('divisibility', 'divtimesheet');">Timesheet</a></li>
            <%

              }

            %>

          </ul>      
        </div> 

        <div id="divform1" class="divisibility">
          <%= (! claim.get ("ClaimNum").equals ("")) ? "<button type=\"button\" id=\"btn\" onclick=\"formeditable (document.getElementById ('form1'));\">edit</button>" : "" %>

          <form id="form1">
            <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;"><%= (claim.get ("ClaimNum").equals ("")) ? "New " : "" %>Claim</span><br>
            <span style=" margin-left: 5%; font-size: 12px; ">* required</span><br>  

            <%
           
              if (! claim.get ("ClaimNum").equals ("")) {

            %>

            <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("Claim", colnames [1]) %></label>  
            <input type="text" name="<%= getColumnDescription ("Claim", colnames [1]) %>" id="<%= getColumnDescription ("Claim", colnames [1]) %>" value="<%= claim.get ("ClaimNum") %>" readonly>
          
            <br>

            <%

              }

              for (i = 2; i < colnames.length; i++) {

            %>

            <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("Claim", colnames [i]) %></label>  
            <input type="<%= (getColTypeName ("Claim", colnames [i]).equals ("datetime2")) ? "date"  : "text" %>" <%= (colnames [i].matches ("Currency")) ? "list=\"" + colnames [i] + "list\"" : "" %> name="<%= colnames [i] %>" id="<%= colnames [i] %>" placeholder="<%= getColumnDescription ("Claim", colnames [i]) %> *" onfocus="getDetails (this, 'infodiv');" oninput="getDetails (this, 'infodiv');"
            <%= (! claim.get ("ClaimNum").equals ("")) ? "value=\"" + claim.get (colnames [i]) + "\"" :
                (claim.get ("ClaimNum").equals ("") && getColTypeName ("Claim", colnames [i]).equals ("datetime2")) ? "value=\"" + String.valueOf (new java.sql.Date(Calendar.getInstance().getTime().getTime())).split (" ")[0] + "\"" : ""
            %>
            onchange="" > 
            <%= (colnames [i].matches ("ShipNum|PolicyNum|VendNum")) ? "<button type=\"button\" onclick=\"ajaxPopup ('searchpopup.jsp', document.getElementById ('" + (colnames [i].equals ("PolicyNum") ? "form2" : colnames [i].equals ("VendNum") ? "form3" : "form4") + "'), 'searchpopup'); \" style=\"width:auto; font-size: 80%;\">Select " + (colnames [i].equals ("ShipNum") ? "Vessel" : colnames [i].equals ("PolicyNum") ? "Policy" : "Vendor") + "</button>" : "" %>
            <span id="span1"></span>
            <br>

            <%= colnames [i].equals ("Currency") ? getDatalist ("Countries", "Currency", true) : "" %>

            <%

              }

            %>

            <input type="hidden" name="<%= (claim.get ("ClaimNum").equals ("")) ? "create" : "update" %>" id="<%= (claim.get ("ClaimNum").equals ("")) ? "create" : "update" %>" value="true">
            <button type="button" style="background: #aaeeee; " onclick="ajax ('claim.jsp', this.form, 'content');"><%= claim.get ("ClaimNum").equals ("") ? "Create" : "Save" %></button>
            <button type="button" onclick="formSubmit (this.form);">Submit</button>  
          </form>
        </div> <% // divform1 %>

        <% 

          if  (! claim.get ("ClaimNum").equals ("")) {

        %>

        <div class="divisibility" id="divclaimsub" style="display: none;">
          <jsp:include page="listing.jsp" >
            <jsp:param name="report" value="claimsublisting" />
            <jsp:param name="ClaimNum" value="<%= claim.get (\"ClaimNum\") %>" />
          </jsp:include>

          <button type="button" style="margin-left: 1%; width:auto; font-size: 80%;" onclick="ajax ('claimsub.jsp?ClaimNum=<%= claim.get ("ClaimNum") %>', '', 'content');">SubClaims</button>
        </div>

        <div class="divisibility" id="divestimate" style="display: none;">
          <jsp:include page="listing.jsp" >
            <jsp:param name="report" value="estimatelisting" />
            <jsp:param name="ClaimNum" value="<%= claim.get (\"ClaimNum\") %>" />
          </jsp:include>

          <button type="button" style="margin-left: 1%; width:auto; font-size: 80%;" onclick="ajax ('estimate.jsp?ClaimNum=<%= claim.get ("ClaimNum") %>', '', 'content');">Estimates</button>
        </div>

        <div class="divisibility" id="divtimesheet" style="display: none;">
          <jsp:include page="listing.jsp" >
            <jsp:param name="report" value="timesheet" />
            <jsp:param name="ClaimNum" value="<%= claim.get (\"ClaimNum\") %>" />
          </jsp:include>

          <button type="button" style="margin-left: 1%; width:auto; font-size: 80%;" onclick="ajax ('timesheet.jsp?ClaimNum=<%= claim.get ("ClaimNum") %>', '', 'content');">Timesheet</button>
        </div>

        <%

          }
  
        %>

        <div class="divisibility" id="divdeduct" style="display: none;">
          <jsp:include page="listing.jsp" >
            <jsp:param name="report" value="deductiblelisting" />
            <jsp:param name="source" value="claim" />
           <jsp:param name="ClaimNum" value="<%= claim.get (\"ClaimNum\") %>" />
          </jsp:include>
          <button type="button" style="margin-left: 1%; width:auto; font-size: 80%;" onclick="ajax ('collectdeduct.jsp?ClaimNum=<%= claim.get ("ClaimNum") %>', '', 'content');">Collect Deductibles</button>
        </div>

      </div>

      <div id="infodiv" style=" border-style: dotted; left: 74%; width: 15%; position: fixed; "><%= s %></div>

    </div>

    <form name="form2" id="form2">
      <input type="hidden" name="elementId" value="id01" />
      <input type="hidden" name="source" value="claim" />
      <input type="hidden" name="report" value="shiplisting" />
      <input type="hidden" name="callerElement" value="PolicyNum" />
      <input type="hidden" name="callerElementId" value="PolicyNum" />
      <input type="hidden" name="title" value="Policy" />
    </form>

    <form name="form3" id="form3">
      <input type="hidden" name="elementId" value="id01" />
      <input type="hidden" name="source" value="vendor" />
      <input type="hidden" name="report" value="vendorlisting" />
      <input type="hidden" name="callerElement" value="VendNum" />
      <input type="hidden" name="callerElementId" value="VendNum" />
      <input type="hidden" name="title" value="Vendor" />
    </form>

    <form name="form2" id="form4">
      <input type="hidden" name="elementId" value="id01" />
      <input type="hidden" name="source" value="quote" />
      <input type="hidden" name="report" value="shiplisting" />
      <input type="hidden" name="callerElement" value="ShipNum" />
      <input type="hidden" name="callerElementId" value="ShipNum" />
      <input type="hidden" name="title" value="Vessel" />
    </form>

    <div id="searchpopup"></div>

    <br>

  </body>
</html>