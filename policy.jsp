<%@include file="/dbhelper.jsp" %>

<%!

  int i;
  String [] colnames;
  Policy policy;
  String s;

  private class Policy {

    Map <String, String> policy;

    public Policy (String policyNum) throws Exception {            
      policy = getRecords ("select PolicyNum, CONVERT(varchar, PolicyDate, 23) AS \"PolicyDate\", QuoteNum, Type, ShipNum, CONVERT(varchar, EffectiveDate, 23) AS \"EffectiveDate\", CONVERT(varchar, ExpiryDate, 23) AS \"ExpiryDate\", Status, Currency, Premium, Underwriter, TradingArea, Conditions, LimitLiability, ExpressWarranties, SanctionClause, ApplicableClause, SurveyWarranty, DefectWarranty, CancelDate, Comments, VAT from PolicyHeader where PolicyNum = '" + policyNum + "'").get (0);    
    }

    public String get (String fieldValue) throws Exception {
      return (policy.get (fieldValue) == null) ? "" : policy.get (fieldValue);  
    }

    String previous () throws Exception {
      return getPreviousRecord ("PolicyHeader", "PolicyNum", policy.get ("PolicyNum"));
    } 

    String next () throws Exception {
      return getNextRecord ("PolicyHeader", "PolicyNum", policy.get ("PolicyNum"));
    } 

    String [] getColumnNames () throws Exception {
      String [] arr, temp;
      int i;
      temp = policy.keySet().toArray(new String[policy.size()]);
      arr = new String[policy.size() + 1];
      for (i = 0; i < temp.length; i++) arr [i + 1] = temp [i];
      return arr;
    }

  }  

%>

<%  

  policy = new Policy (((request.getParameter ("convert") != null) && (request.getParameter ("QuoteNum") != null)) ? quoteToPolicy (request.getParameter ("QuoteNum")) :
                        (request.getParameter ("PolicyNum") != null) ? request.getParameter ("PolicyNum") : "");

  colnames = policy.getColumnNames ();

%>

<!DOCTYPE html>
<html>

  <head>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
      #backToTopBtn { display: none; position: fixed; bottom: 20px; right: 30px; z-index: 99; border: none; outline: none; background-color: #333; color: white; cursor: pointer; padding: 5px; width: auto; border-radius: 4px; }
      #backToTopBtn:hover { background-color: #4CAF50; }
    </style>

    <script id="sc1">
      getDetails = function (obj, resultDiv) {
        document.getElementById (resultDiv).innerHTML = obj.id;
      }

      topFunction = function () {
        document.body.scrollTop = 0;
        document.documentElement.scrollTop = 0;
      }
    </script>

  </head>

  <body>    

    <button onclick="topFunction();" id="backToTopBtn" title="Go to top">Top</button>

    <div class="aa" style="display: flex;">

      <div class="mainbody">

        <div>
          <ul id="sub">
            <li><a class="active" href="#" id="policy" onclick="setMenuActive ('sub', this); setDivActive ('divisibility', 'divform1');">Policy</a></li>
            <li><a class="inactive" href="#" id="deductibles" onclick="setMenuActive ('sub', this); setDivActive ('divisibility', 'divdeduct');">Deductibles</a></li>
            <li><a class="inactive" href="#" id="declaration" onclick="setMenuActive ('sub', this); setDivActive ('divisibility', 'divdeclare');">Declaration</a></li>
          </ul>      
        </div>

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;">Policy details</span><br>

        <div class="divisibility" id="divform1">

          <form name="form1" id="form1">

            <%

              for (i = 1; i < colnames.length; i++) {

            %>

            <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("PolicyHeader", colnames [i]) %></label>     
            <%= getColTypeSize ("PolicyHeader", colnames [i]).equals ("1073741823") ? "<textarea name=\"" + colnames [i] + "\" readonly>" + policy.get (colnames [i]) + "</textarea>" :
                "<input type=\"" + (getColTypeName ("PolicyHeader", colnames [i]).equals ("datetime2") ? "date" : "text") + "\" name=\"" + colnames [i] + "\" id=\"" + colnames [i] + "\" value=\"" + policy.get (colnames [i]) + "\" readonly>"
            %>
            <br>
            <%

              }

            %>

          </form>

          <button type="submit" form="printform" formtarget="_blank" formaction="printcertificate.jsp">Print Certificate</button>
          <button type="submit" form="printform" formtarget="_blank" formaction="printwordcertificate.jsp">Print Certificate (Word)</button>

        </div> 

        <div class="divisibility" id="divdeduct" style="display: none;">
          <jsp:include page="listing.jsp">
            <jsp:param name="report" value="deductiblelisting" />
            <jsp:param name="source" value="policy" />
            <jsp:param name="PolicyNum" value="<%= policy.get (\"policyNum\") %>" />
          </jsp:include>
        </div>

        <div class="divisibility" id="divdeclare" style="display: none;">
          <jsp:include page="listing.jsp">
            <jsp:param name="report" value="declarationlisting" />
            <jsp:param name="source" value="policy" />
            <jsp:param name="PolicyNum" value="<%= policy.get (\"policyNum\") %>" />
          </jsp:include>
          <button type="button" style="margin-left: 1%; width:auto; font-size: 80%;" onclick="ajax ('declaration.jsp?PolicyNum=<%= policy.get ("policyNum") %>', '', 'content'); ">Declaration</button>
        </div>

        <form id="printform" method="post">
          <input type="hidden" name="PolicyNum" value="<%= policy.get ("policyNum") %>">
        </form>
      </div> 

      <div id="infodiv" style="border-style: dotted; left: 74%; width: 15%; position: fixed; ">
        <%= request.getParameter ("OwnerNum") != null ? "Owner details" : 
            (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? "List Ships Owned" : "Field Details"%>
      </div>

    </div>
    <br>   

    <script id="btnscript">
      window.onscroll = function() {
        document.getElementById("backToTopBtn").style.display = (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) ? "block" : "none";
      }

      for (var elems of document.querySelectorAll ("textarea")) {
        elems.style.height = 'auto';
        elems.style.overflowY = 'hidden';
        elems.style.height = elems.scrollHeight + 20 + 'px';
      }
    </script>

  </body>
</html>
