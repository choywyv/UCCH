<%@include file="/dbhelper.jsp" %>

<%!

  int i, col;
  String [] colnames;
  String s, quoteNum, quoteDeclareNum;

%>

<%

  colnames = getColumns ("QuoteDeclaration");
  quoteNum = (request.getParameter ("QuoteNum") == null) ? "" : request.getParameter ("QuoteNum");
  quoteDeclareNum = (request.getParameter ("QuoteDeclareNum") == null) ? "" : request.getParameter ("QuoteDeclareNum");

  if ((request.getParameter ("create") != null) && (request.getParameter ("create").equals ("true"))) 
    createRecord ("QuoteDeclaration", request.getParameterMap(), new String [] {"QuoteDeclareNum"});  

  if ((request.getParameter ("update") != null) && (request.getParameter ("update").equals ("true"))) 
    s = updateRecord (getSQLUpdateStmt ("QuoteDeclaration", request.getParameterMap(), new String [] {"QuoteNum='" + quoteNum + "'", "QuoteDeclareNum='" + quoteDeclareNum + "'"}));

  
%>

<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
    
    </style>

    <script id="sc5">
      getDetails = function (obj, resultDiv) {
        document.getElementById (resultDiv).innerHTML = ajax ("minidetails.jsp?table=Declaration&" + obj.id + "=" + obj.value, '', resultDiv);
      }

      formSubmit = function (f) {
        ajax ("quotedeclaration.jsp", f, "content");
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
    <button type="button" onclick="ajax ('quote.jsp?edit=true&QuoteNum=<%= quoteNum %>', '', 'content');">Back to Quote</button>
    <div class="aa" style="display: flex;">

      <div class="mainbody">

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;"><%= (quoteNum.equals ("")) ? "New " : "" %>Quote Declaration</span><br>
        
        <form id="form1">

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("QuoteDeclaration", colnames [1]) %></label>
          <input type="text" name="<%= colnames [1] %>" id="<%= colnames [2] %>" value="<%= quoteNum %>" onfocus="getDetails (this, 'infodiv');" oninput="getDetails (this, 'infodiv');" readonly>
          <br>

          <%

            if (! quoteDeclareNum.equals ("")) {

          %>
          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("QuoteDeclaration", colnames [2]) %></label>
          <input type="text" name="<%= colnames [2] %>" id="<%= colnames [2] %>" value="<%= quoteDeclareNum %>" readonly>
          <br>
          <%

            }

            for (i = 3; i < colnames.length; i++) {

          %>

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("QuoteDeclaration", colnames [i]) %></label>  
          <input type="<%= (getColTypeName ("QuoteDeclaration", colnames [i]).equals ("datetime2")) ? "date"  : "text" %>" <%= (colnames [i].matches ("Currency")) ? "list=\"" + colnames [i] + "list\"" : "" %> name="<%= colnames [i] %>" id="<%= colnames [i] %>" placeholder="<%= getColumnDescription ("QuoteDeclaration", colnames [i]) %> *" onfocus="getDetails (this, 'infodiv');" oninput="getDetails (this, 'infodiv');" 
          <%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? 
                  "value=\"" + ((getColTypeName ("QuoteDeclaration", colnames [i]).equals ("datetime2")) ? 
                    getFieldValue ("QuoteDeclaration", colnames [i], " where quoteNum = '" + quoteNum + "'").split (" ") [0] : getFieldValue ("QuoteDeclaration", colnames [i], " where quoteNum = '" + quoteNum + "'") ) + "\"" : "" %>
          <%= (i == 1) ? " readonly" : "" %>> 

          <%= (colnames [i].equals ("ShipNum")) ? "<button type=\"button\" onclick=\"document.getElementById ('id02').style.display='block';\" style=\"width:auto; font-size: 80%;\">Search Ship</button>" : "" %>          
          <span id="span1"></span>
          <br>

          <%= colnames [i].equals ("Currency") ? getDatalist ("Countries", "Currency", true) : "" %>

          <%

            }

          %>
 
          <input type="hidden" name="<%= quoteDeclareNum.equals ("") ? "create" : "update" %>" id="<%= quoteDeclareNum.equals ("") ? "create" : "update" %>" value="true">
          <button type="button" onclick="formSubmit (this.form);"><%= quoteDeclareNum.equals ("") ? "Submit" : "Save" %></button>  
        </form>

      </div>

      <div id="infodiv" style="border-style: dotted; left: 74%; width: 15%; position: fixed; "></div>

    </div>

          <jsp:include page="listing.jsp" >
            <jsp:param name="report" value="declarationlisting" />
            <jsp:param name="source" value="quote" />
            <jsp:param name="QuoteNum" value="<%= quoteNum %>" />
          </jsp:include>


    <jsp:include page="searchpopup.jsp" >
      <jsp:param name="elementId" value="id02" />
      <jsp:param name="source" value="quote" />
      <jsp:param name="report" value="shiplisting" />
      <jsp:param name="callerElement" value="ShipNum" />
      <jsp:param name="title" value="Ship" />
    </jsp:include>

  </body>
</html>