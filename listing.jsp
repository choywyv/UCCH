<%
/*

SELECT AssuredNum, (
  CASE 
    WHEN (select count(*) from Ships where AssuredNum = Assured.AssuredNum) > 1 THEN 'Multiple'
    ELSE (select ShipNum from Ships where AssuredNum = Assured.AssuredNum) 
  END
)
FROM    Assured
where AssuredNum = 'RC'

*/
%>

<%@ page import = "java.util.*" %>
<%@include file="/dbhelper.jsp" %>

<%!

  int i;
  String s, source, orderby, sortdir, sql, report, elementId, callerElement, callerElementId;
  List<Map<String, String>> list;  

%>

<%

  orderby = (request.getParameter ("orderby") == null) ? "" : request.getParameter ("orderby");
  sortdir = (request.getParameter ("sortdir") == null) ? "" : request.getParameter ("sortdir");
  source = (request.getParameter ("source") == null) ? "" : request.getParameter ("source");
  report = (request.getParameter ("report") == null) ? "" : request.getParameter ("report");
  sql = "";
  callerElement = (request.getParameter ("callerElement") == null) ? "" : request.getParameter ("callerElement");
  callerElementId = request.getParameter ("callerElementId");

  if (report.equals ("shiplisting")) {
    sql = source.equals ("") ? "select * from Ships " :
       source.equals ("report") ? "select ShipNum, ShipName AS 'Ship Name', Flag, IMO, Callsign, GrossTon, NetTon, Width, Length, Height, YEAR(KeelYear) AS 'Keel Year', YEAR(BuildYear) AS 'Build Year' from Ships "  + (orderby.equals ("") ? "" : "order by '" + orderby + "' ")  + sortdir :
       source.equals ("global") ? request.getParameter ("search").equals ("") ? "select  ShipName, IMO, Flag, GrossTon, ShipType, AssuredNum, BuildYear from Ships" : "select ShipName, IMO, Flag, GrossTon, ShipType, AssuredNum, BuildYear from Ships where ShipName like '%" + request.getParameter ("search") + "%' or IMO = case when isnumeric ('" + request.getParameter ("search") + "') = 1 then CONVERT(int,'" + request.getParameter ("search") + "') end" :
       source.matches ("quote|policy") ? "select ShipNum, IMO, ShipName, Flag from Ships where ShipName like '%" + request.getParameter ("search") + "%' or IMO = case when isnumeric ('" + request.getParameter ("search") + "') = 1 then CONVERT(int,'" + request.getParameter ("search") + "') end" : 
       source.equals ("claim") ? "SELECT PolicyHeader.PolicyNum, Ships.ShipName, IMO, CONVERT(varchar, EffectiveDate, 23) AS 'Effective Date', CONVERT(varchar, ExpiryDate, 23) AS 'Expiry Date', PolicyHeader.Status FROM PolicyHeader inner join Ships on Ships.ShipNum = PolicyHeader.ShipNum where ShipName like '%" + request.getParameter ("search") + "%' or IMO = case when isnumeric ('" + request.getParameter ("search") + "') = 1 then CONVERT(int,'" + request.getParameter ("search") + "') end;" : 
       source.equals ("assured") ? "select ShipNum, ShipName from Ships where AssuredNum = '" + request.getParameter ("AssuredNum") + "'" :"select * from Ships ";
  }

  if (report.equals ("assuredlisting")) sql = source.equals ("") ? "select * from Assured " :
       source.equals ("report") ? "select AssuredNum, AssuredType, FirstName, LastName, Address, Address2, Country, PostCode, Phone, Email from Assured " + (orderby.equals ("") ? "" : "order by '" + orderby + "' ")  + sortdir :
       source.matches ("ship|quotesearch") ? "select AssuredNum, FirstName, LastName from Assured where FirstName like '%" + request.getParameter ("search") + "%' or LastName like '%" + request.getParameter ("search") + "%'" : "select * from Assured ";

  if (report.equals ("quotelisting")) {
    sql = source.equals ("") ? "select QuoteNum, QuoteHeader.AssuredNum, QuoteHeader.ShipNum, Ships.IMO, Ships.ShipName, Ships.Flag, EffectiveDate, ExpiryDate, Currency, Premium, Status from QuoteHeader inner join Ships on Ships.ShipNum = QuoteHeader.ShipNum " :
       source.equals ("report") ? //"select QuoteNum, CONVERT(varchar, EffectiveDate, 23) AS 'Effective Date', CONVERT(varchar, ExpiryDate, 23) AS 'Expiry Date', Currency, Premium, Status from QuoteHeader " + 
       "select QuoteNum, AssuredNum = LEFT(o1.list, LEN(o1.list)-1), ShipNum = LEFT(o2.list, LEN(o2.list)-1), CONVERT(varchar, EffectiveDate, 23) AS 'Effective Date', CONVERT(varchar, ExpiryDate, 23) AS 'Expiry Date', Currency, Premium, Status, BrokerNum " +
       "from QuoteHeader cross apply ( SELECT CONVERT(nVARCHAR(max), AssuredNum) + ', ' AS [text()] FROM QuoteAssured where QuoteAssured.QuoteNum = QuoteHeader.QuoteNum FOR XML PATH('') ) o1 (list) " + 
       "cross apply ( SELECT CONVERT(nVARCHAR(max), ShipNum) + ', ' AS [text()] FROM QuoteVessel where QuoteVessel.QuoteNum = QuoteHeader.QuoteNum FOR XML PATH('') ) o2 (list) " +
       (orderby.equals ("") ? "" : "order by '" + orderby + "' ")  + sortdir :

       source.equals ("assured") ? "select QuoteNum, CONVERT(varchar, QuoteDate, 23) AS 'Quote Date' from QuoteHeader where AssuredNum = '" + request.getParameter ("AssuredNum") + "'" : 
       source.matches ("quote|claim") ? "select ShipNum, IMO, ShipName, Flag from Ships where ShipName = '" + request.getParameter ("search") + "' or IMO = case when isnumeric ('" + request.getParameter ("search") + "') = 1 then CONVERT(int,'" + request.getParameter ("search") + "') end" : "select QuoteNum, QuoteHeader.AssuredNum, QuoteHeader.ShipNum, Ships.IMO, Ships.ShipName, Ships.Flag, EffectiveDate, ExpiryDate, Currency, Premium, Status from QuoteHeader inner join Ships on Ships.ShipNum = QuoteHeader.ShipNum ";
  }

  if (report.equals ("claimlisting")) {
    sql = source.equals ("") ? "select * from Claim " :
    source.equals ("report") ? "SELECT ClaimNum, ShipNum, PolicyNum, CONVERT(varchar, Claim.ClaimDate, 23) AS 'Claim Date', Status, Description, Location, PaidAmt, OutstandingAmt, Claim.TotalIncurredAmt, Remarks, VendNum FROM Claim " + (orderby.equals ("") ? "" : "order by '" + orderby + "' ")  + sortdir :
    source.matches ("quote|claim") ? "select ShipNum, IMO, ShipName, Flag from Ships where ShipName = '" + request.getParameter ("search") + "' or IMO = case when isnumeric ('" + request.getParameter ("search") + "') = 1 then CONVERT(int,'" + request.getParameter ("search") + "') end" : "select * from Claim ";
  }

  if (report.equals ("claimsublisting")) sql = "select * from ClaimSub where ClaimNum = '" + request.getParameter ("ClaimNum") + "'";

  if (report.equals ("estimatelisting")) sql = "select * from Estimate where ClaimNum = '" + request.getParameter ("ClaimNum") + "'";

  if (report.equals ("timesheet")) sql = "select * from Timesheet where ClaimNum = '" + request.getParameter ("ClaimNum") + "'";

  if (report.equals ("deductiblelisting")) sql = source.equals ("") ? "select QuoteDeductible.QuoteNum, QuoteDeductible.DeductNum, Deductibles.Description, QuoteDeductible.Amt from QuoteDeductible inner join Deductibles on Deductibles.DeductNum = QuoteDeductible.DeductNum where QuoteNum = '" + request.getParameter ("QuoteNum") + "'" : 
       source.equals ("policy") ? "select * from PolicyLine where PolicyNum = '" + request.getParameter ("PolicyNum") + "'" :
       source.equals ("claim") ? "select ClaimNum, Claim.PolicyNum, PolicyLine.DeductNum, Deductibles.Description, Amt from PolicyHeader, PolicyLine, Claim, Deductibles where PolicyHeader.PolicyNum = PolicyLine.PolicyNum and Claim.PolicyNum = PolicyHeader.PolicyNum and PolicyLine.DeductNum = Deductibles.DeductNum and ClaimNum = '" + request.getParameter ("ClaimNum") + "' " : "";

  if (report.equals ("policylisting")) {
    sql = source.equals ("") ? "select * from PolicyHeader " :
          source.equals ("assured") ? "select PolicyNum, CONVERT(varchar, PolicyHeader.EffectiveDate, 23) AS 'Effective Date', CONVERT(varchar, PolicyHeader.ExpiryDate, 23) AS 'Expiry Date' from PolicyHeader inner join QuoteHeader on PolicyHeader.QuoteNum = QuoteHeader.QuoteNum where AssuredNum = '" + request.getParameter ("AssuredNum") + "'" :
          source.matches ("report|quote|claim") ? //"select PolicyNum, QuoteNum, CONVERT(varchar, EffectiveDate, 23) AS 'Effective Date', CONVERT(varchar, ExpiryDate, 23) AS 'Expiry Date', Status, Premium, Currency from PolicyHeader " + (orderby.equals ("") ? "" : "order by '" + orderby + "' ")  + sortdir 
          "SELECT PolicyNum, QuoteNum, AssuredNum = LEFT(o1.list, LEN(o1.list)-1), ShipNum = LEFT(o2.list, LEN(o2.list)-1), CONVERT(varchar, EffectiveDate, 23) AS 'Effective Date', CONVERT(varchar, ExpiryDate, 23) AS 'Expiry Date', Status, Premium, Currency from PolicyHeader " + 
          "cross apply ( SELECT CONVERT(nVARCHAR(max), AssuredNum) + ', ' AS [text()] FROM PolicyAssured where PolicyAssured.PolicyNum = PolicyHeader.PolicyNum FOR XML PATH('') ) o1 (list) " +
          "cross apply ( SELECT CONVERT(nVARCHAR(max), ShipNum) + ', ' AS [text()] FROM PolicyVessel where PolicyVessel.PolicyNum = PolicyHeader.PolicyNum FOR XML PATH('') ) o2 (list) " + 
           (orderby.equals ("") ? "" : "order by '" + orderby + "' ")  + sortdir : "select * from PolicyHeader ";

  }

  if (report.equals ("vendorlisting")) sql = source.equals ("report") ? "select * from Vendor" :
    source.equals ("vendor") ? "select top (20) VendNum, VendType, Name, Name2 from Vendor where Name like '%" + request.getParameter ("search") + "%'" : "";

  if (report.equals ("brokerlisting")) sql = source.equals ("report") ? "select * from Broker" :
    source.equals ("quotesearch") ? "select * from Broker where Name like '%" + request.getParameter ("search") + "%'" : "";

  if (report.equals ("quotedeclarationlisting")) sql = source.equals ("quote") ? "select QuoteNum, QuoteDeclareNum, ShipNum, CONVERT(varchar, QuoteDeclaration.EffectiveDate, 23) AS 'Effective Date', CONVERT(varchar, QuoteDeclaration.ExpiryDate, 23) AS 'Expiry Date', Amt, Comments from QuoteDeclaration where QuoteNum='" + request.getParameter ("QuoteNum") + "'" : "";

  if (report.equals ("declarationlisting")) sql = source.equals ("policy") ? "select PolicyNum, DeclareNum, ShipNum, CONVERT(varchar, Declaration.EffectiveDate, 23) AS 'Effective Date', CONVERT(varchar, Declaration.ExpiryDate, 23) AS 'Expiry Date', Amt, Comments from Declaration where PolicyNum = '" + request.getParameter ("PolicyNum") + "'" : "";

  if (report.equals ("speciallisting")) {
    sql = "select ShipName, Claim.ClaimNum, CONVERT(varchar, Claim.ClaimDate, 23) AS 'Claim Date', Claim.Status, Description into #mytable from Claim inner join PolicyHeader on Claim.PolicyNum = PolicyHeader.PolicyNum inner join Ships on Policyheader.Shipnum = Ships.ShipNum where ShipName like '%" + request.getParameter ("search") + "%'";
  }

  if (report.equals ("quoteassuredlisting")) {
    sql = "select * from QuoteAssured where QuoteNum = '" + request.getParameter ("QuoteNum") + "'";
  }

  if (report.equals ("quotevessellisting")) {
    sql = "select ShipNum, (select IMO from Ships where Ships.ShipNum = QuoteVessel.ShipNum) AS 'IMO', (select ShipName from Ships where Ships.ShipNum = QuoteVessel.ShipNum) AS 'Ship Name', Type from QuoteVessel where QuoteNum = '" + request.getParameter ("QuoteNum") + "'";
  }

  list = getRecords (sql);
  //for (Map.Entry <String, String> entry : coltype.entrySet ()) out.println (entry.getKey () + ":" + entry.getValue () + "<br>");

%>

<!DOCTYPE html>
<html>

  <head>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
      .div1 { width: 200px; height: 100px; display: none; border: 1px black solid; background: lightgrey; position: absolute; }
      table { width: 80%; margin-left: auto; margin-right: auto;  }

      tr:nth-child(even) { background-color: #f2f2f2; }
      td { padding: 5px; }

      @media print{
        body { background-color:#FFFFFF; background-image:none; color:#000000 }
        #ad { display:none;}
        #leftbar { display:none;}
        #contentarea { width:100%;}
      }
    </style>  

    <script id="allship">
      sorttable = function (params) {
        ajax ("listing.jsp?source=report&report=<%= report%>&" + params, '', 'content');
      }
    </script>

  </head>

  <body>

    <div class=""><%= orderby %>-<%= sortdir %>
      <table id="myTable" border="1">
        <tr>

          <%

           if (list.size () > 0)
            for (String header : list.get (0).keySet ()) {

          %>     
          
          <th onclick="sorttable (<%= "'orderby=" + header %><%= (! orderby.equals (header)) ? "" : (orderby.equals (header) && sortdir.equals ("")) ? "&sortdir=desc" : "" %>', 'content');"><%= header %></th>

          <%

            }

          %>

        </tr>

        <%
  
          for (Map<String, String> map: list) {
            i = 1;   

        %>

        <tr>

          <%
     
            for (Map.Entry entry: map.entrySet()) {

          %>

          <td>
            <%
              if (report.equals ("shiplisting")) {
            %>

            <%= (i == 1) ? "<a href=\"#\" onclick=\"ajax ('ship.jsp?edit=true&ref=shiplisting&ShipNum=" + entry.getValue () + "', '', 'content'); \">" + entry.getValue () + "</a>" : entry.getValue () %>             
            <%                
              }
              if (report.matches ("quotelisting") ) {
            %>

            <%= (i == 1) ? "<a href=\"#\" onclick=\"ajax ('quote.jsp?edit=true&ref=quotelisting&QuoteNum=" + entry.getValue () + "', '', 'content'); \">" + entry.getValue () + "</a>" : entry.getValue () %>       
            <%
              }            
              if (report.matches ("policylisting") ) {
            %>
              
            <%= (i == 1) ? "<a href=\"#\" " + "onclick=\"ajax ('policy.jsp?edit=true&ref=policylisting&PolicyNum=" + entry.getValue () + "', '', 'content'); \" " +
//"onmouseover=\" document.getElementById ('div1').style.top=event.clientY + 'px'; document.getElementById ('div1').style.left = event.clientX + 'px'; document.getElementById ('div1').style.display='block'; \" onmouseout=\"document.getElementById ('div1').style.display='none';\" " +
">" + entry.getValue () + "</a>" : entry.getValue ()  %>

            <%
              }
              if (report.matches ("assuredlisting")) {
            %>
            <%= (i == 1) ? "<a href=\"#\" onclick=\"ajax ('assured.jsp?edit=true&AssuredNum=" + entry.getValue () + "', '', 'content'); \">" + entry.getValue () + "</a>" : entry.getValue () %>
            <%
              }
              if (report.matches ("claimlisting")) {
            %>

            <%= (i == 1) ? "<a href=\"#\" onclick=\"ajax ('claim.jsp?edit=true&ClaimNum=" + entry.getValue () + "', '', 'content'); \">" +  entry.getValue () + "</a>" : entry.getValue () %>  
            
            <%
              }
              if (report.matches ("deductiblelisting")) {
            %>

            <%= entry.getValue () %>

            <%
              }
              if (report.matches ("quotedeclarationlisting")) {
            %>

            <%= (i == 2) ? "<a href=\"#\" onclick=\"ajax ('quotedeclaration.jsp?edit=true&QuoteNum=" + map.get ("QuoteNum") + "&QuoteDeclareNum=" + entry.getValue () + "', '', 'content'); \">" : "" %><%= entry.getValue () %><%= (i == 2) ? "</a>" : "" %>

            <%
              }
              if (report.matches ("declarationlisting")) {
            %>

            <%= (i == 2) ? "<a href=\"#\" onclick=\"ajax ('declaration.jsp?edit=true&PolicyNum=" + map.get ("PolicyNum") + "&DeclareNum=" + entry.getValue () + "', '', 'content'); \">" : "" %><%= entry.getValue () %><%= (i == 2) ? "</a>" : "" %>

            <%
              }





              if (report.matches ("claimsublisting|timesheet|estimatelisting|vendorlisting")) {
            %>
            <%= getColTypeName ((report.equals ("claimsublisting") ? "Claimsub" : 
                                 report.equals ("estimatelisting") ? "Estimate" : 
                                 report.equals ("timesheet") ? "Timesheet" :
                                 report.equals ("vendorlisting") ? "Vendor" : 
                                 ""),
                String.valueOf (entry.getKey ())).equals ("datetime2") ? String.valueOf (entry.getValue ()).split (" ") [0] : entry.getValue () %>
            <%
              }
              if (report.matches ("speciallisting|quoteassuredlisting|quotevessellisting|brokerlisting")) {
            %>
            <%= entry.getValue () %>
            <%
              }
            %>
          </td>

          <%

              i++; 
            }

          %>

          <%= (! callerElement.equals ("")) ? "<td><button type=\"button\" style=\"width:auto; font-size: 80%;\" onclick=\"document.getElementById ('" + callerElementId + "').value='" + map.get (callerElement) + "'; document.getElementById ('" + callerElementId + "').onchange(); document.getElementById('" + request.getParameter ("elementId") +"').style.display='none';\" >Select</button></td>" : "" %> 
          <%= (report.equals ("quotevessellisting") && source.equals ("quotevessel")) ? "<td><button type=\"button\" style=\"width:auto; font-size: 80%;\" onclick=\"ajax ('quotevessel.jsp?delete=true&QuoteNum=" + request.getParameter ("QuoteNum") + "&ShipNum=" + map.get ("ShipNum") + "', '', 'content')\">Delete</button></td>" : "" %> 
        </tr>

        <%
      
          }

        %>

      </table>
    </div>
    <br>

    <%= (report.equals ("claimlisting")) ? "<button type=\"button\" onclick=\"location.href='report-incident-excel.jsp?sql=" + sql + "'\">Export to Excel</button><br><br>" : "" %>

    <div id="div1" class="div1" ></div>
    

  </body>
</html>

<%
 
  dropTempTable ("#mytable");
 
%>