<%@include file="/dbhelper.jsp" %>

<%!

  int i, col;
  String [] colnames;
  String s;
  Timesheet timesheet;

  private class Timesheet {

    Map <String, String> timesheet;

    public Timesheet (String entryNum, String claimNum) throws Exception {      
      if (entryNum.equals ("")) {
        timesheet = new HashMap <String, String> ();
        timesheet.put ("ClaimNum", claimNum);
      }
      else timesheet = getRecords ("select * from Timesheet where EntryNum ='" + entryNum + "'").get (0);
    }

    public String get (String fieldValue) throws Exception {
      return (timesheet.get (fieldValue) == null) ? "" : timesheet.get (fieldValue);  
    }

    String create (Map<String, String[]> map) throws Exception {
      return createRecord ("Timesheet", map, new String [] {"EntryNum"});
    }

    String update (Map<String, String[]> map, String[] additional) throws Exception {
      return updateRecord (getSQLUpdateStmt ("Timesheet", map, additional));
    }
  
  }  

%>

<%

//  s = getSQLInsertStmt ("Timesheet", request.getParameterMap(), new String [] {"EntryNum"});
  //if ((request.getUserPrincipal() == null) || (request.getParameter ("ref") == null)) response.sendRedirect("/test");

  timesheet = new Timesheet ((request.getParameter ("EntryNum") == null) ? "" : request.getParameter ("EntryNum"), request.getParameter ("ClaimNum"));
  if ((request.getParameter ("create") != null) && ( request.getParameter ("create").equals ("true"))) {//out.println ( 
    s = "Timesheet " + timesheet.create (request.getParameterMap()) + " created!";    
  }

//  if ((request.getParameter ("update") != null) && ( request.getParameter ("update").equals ("true"))) 
//    updateTimesheet (request.getParameter ("ClaimNum"), request.getParameter ("EntryDate"), request.getParameter ("Description"), request.getParameter ("Hours"));

  colnames = getColumns ("Timesheet");
 
%>

<!DOCTYPLE html>

<html>

  <head>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <script id="sc1">
      getDetails = function (obj, resultDiv) {
        document.getElementById (resultDiv).innerHTML = ajax ("minidetails.jsp?table=Incidents&" + obj.id + "=" + obj.value, '', resultDiv);
      }
    </script>

    <style>
      .mainbody { width: 80%; border-style: dotted; border-radius: 5px;  background: #dddddd; }

      input, button { font-size: 20px; margin-bottom: 10px; border-radius: 5px; width: 200px; margin-left: 5%; }
      input:read-only { background-color: yellow; }
      input:-moz-read-only { background-color: yellow; }
      span { font-size: 20px; margin-bottom: 10px; } 

      @media print{
        body { background-color:#FFFFFF; background-image:none; color:#000000 }
        #ad { display:none;}
        #leftbar { display:none;}
        #contentarea { width:100%;}
      }

    </style>

  </head>

  <body>

    <div id="summary">
      <jsp:include page="listing.jsp" >
        <jsp:param name="report" value="timesheet" />
        <jsp:param name="source" value="timesheet" /> 
        <jsp:param name="ClaimNum" value="<%= timesheet.get (\"ClaimNum\") %>" />
      </jsp:include>
    </div> 

    <button type="button" onclick="ajax ('claim.jsp?edit=true&ClaimNum=<%= timesheet.get ("ClaimNum") %>', '', 'content');">Back to Claim</button>
    <div class="aa" style="display: flex;">
      <div id="detail" class="mainbody">

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;">Timesheet</span><br>

        <form>
          <%
            for (i = 2; i < colnames.length; i++) {
              if (isVisible ("Timesheet", colnames [i])) {
          %>

          <label><%= colnames [i] %></label>
          <input type="<%= getColTypeName ("Timesheet", colnames [i]).equals ("datetime2") ? "date" : "text" %>" name="<%= colnames [i] %>" id="<%= colnames [i] %>" value="<%= timesheet.get (colnames [i]) %>" <%= (i == 2) ? "readonly" : "" %>>
          <br>

          <%
              }
            }
          %>

          <input type="hidden" name="<%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? "update" : "create" %>" id="<%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? "update" : "create" %>" value="true">
          <button type="button" onclick="ajax ('timesheet.jsp?ClaimNum=<%= timesheet.get ("ClaimNum") %>', this.form, 'content')">Submit</button>

        </form>
  
      </div>

      <div id="infodiv" style="border-style: dotted; left: 74%; width: 15%; position: fixed; ">
        
      </div>

    </div>

  </body>

</html>