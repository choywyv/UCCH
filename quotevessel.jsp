<%@include file="/dbhelper.jsp" %>

<%!

  int i, col;
  String [] colnames;
  String s;
  QuoteVessel quotevessel;

  private class QuoteVessel {

    Map <String, String> quotevessel;

    public QuoteVessel (String quoteNum) throws Exception {      
      quotevessel = new HashMap <String, String> ();
      quotevessel.put ("QuoteNum", quoteNum);
    }

    public QuoteVessel (String quoteNum, String shipNum) throws Exception {      
      quotevessel = getRecords ("select * from QuoteVessel where QuoteNum = '" + quoteNum + "' and ShipNum = '" + shipNum + "'").get (0);
    }

    public String get (String fieldValue) throws Exception {
      return (quotevessel.get (fieldValue) == null) ? "" : quotevessel.get (fieldValue);  
    }

    String create (Map<String, String[]> map) throws Exception {
      return createRecord ("QuoteVessel", map, new String [] {}); 
    }

    String update (Map<String, String[]> map, String[] additional) throws Exception {
      return updateRecord (getSQLUpdateStmt ("QuoteVessel", map, additional));
    }

    void delete (String shipNum) throws Exception {
      updateRecord ("delete from QuoteVessel where QuoteNum = '" + quotevessel.get ("QuoteNum") + "' and ShipNum = '" + shipNum + "'");
    }  

  }  

%>

<%

  quotevessel = new QuoteVessel (request.getParameter ("QuoteNum"));
  colnames = getColumns ("QuoteVessel");

  if ((request.getParameter ("create") != null) && (request.getParameter ("create").equals ("true"))) 
    quotevessel.create (request.getParameterMap());

  if ((request.getParameter ("delete") != null) && (request.getParameter ("delete").equals ("true"))) {
    quotevessel.delete (request.getParameter ("ShipNum"));
  }

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
        ajax ("<%= request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/")+1) %>", f, "content");
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

    <button type="button" onclick="ajax ('quote.jsp?edit=true&QuoteNum=<%= quotevessel.get ("QuoteNum") %>', '', 'content');">Back to Quote</button>
    <div class="aa" style="display: flex;">

      <div class="mainbody">

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;"></span><br>
        
        <form id="form1">

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("QuoteVessel", "QuoteNum") %></label>
          <input type="text" name="<%= colnames [1] %>" id="<%= colnames [1] %>" value="<%= quotevessel.get ("QuoteNum") %>" readonly>
          <br>

          <%

            for (i = 2; i < colnames.length; i++) {

          %>

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("QuoteVessel", colnames [i]) %></label>  
          <input type="text" name="<%= colnames [i] %>" id="<%= colnames [i] %>" placeholder="<%= getColumnDescription ("QuoteVessel", colnames [i]) %> *" onfocus="getDetails (this, 'infodiv');" oninput="getDetails (this, 'infodiv');" onchange=""> 
          <%= (colnames [i].equals ("ShipNum")) ? "<button type=\"button\" onclick=\"ajaxPopup ('searchpopup.jsp', document.getElementById ('form3'), 'searchpopup');\"  style=\"width:auto; font-size: 80%;\">Search Ship</button>" : "" %>          
          <span id="span1"></span>
          <br>

          <%

            }

          %>
 
          <input type="hidden" name="<%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? "update" : "create" %>" id="<%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? "update" : "create" %>" value="true">
          <button type="button" onclick="formSubmit (this.form);">Submit</button>  
        </form>

        <jsp:include page="listing.jsp" >
          <jsp:param name="report" value="quotevessellisting" />
          <jsp:param name="source" value="quotevessel" />
          <jsp:param name="QuoteNum" value="<%= quotevessel.get (\"QuoteNum\") %>" />
        </jsp:include>

      </div>

      <div id="infodiv" style="border-style: dotted; left: 74%; width: 15%; position: fixed; "><%= s %></div>

    </div>

    <form name="form3" id="form3">
      <input type="hidden" name="elementId" value="id01" />
      <input type="hidden" name="source" value="quote" />
      <input type="hidden" name="report" value="shiplisting" />
      <input type="hidden" name="callerElement" value="ShipNum" />
      <input type="hidden" name="title" value="Ship" />
    </form>
  
    <div id="searchpopup"></div>

  </body>
</html>