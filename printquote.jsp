<% // http://asp-arka.blogspot.sg/2014/09/printing-page-size-in-a4-using-css-paged-media.html %>

<%@include file="/dbhelper.jsp" %>

<%!

  int i, linenum;
  Map<String, String> map; 
  String quoteNum, footer;

%>

<%

  quoteNum = (request.getParameter ("QuoteNum") == null) ? "" : request.getParameter ("QuoteNum");
  footer = "<div style=\"margin-left: 10%; align-items: flex-end;\">QUOTE NO: " + quoteNum + "<br>" +
           "            DATE: " + getFieldValue ("QuoteHeader", "QuoteDate", " where QuoteNum = '" + quoteNum  + "'").split (" ")[0] + "<br>" + 
           "            Authorized Signatory for" + 
           "            British Steamship Management Ltd, the Manager of<br>" + 
           "            British Steamship Protection and Indemnity Association (Bermuda) Limited<br>" +  
           "            Clarendon House, 2 Church Street, Hamilton HM 11, Bermuda<br></div>";
  i = 1;
  linenum = 1;

  if (! quoteNum.equals ("")) map = getRecords ("select EffectiveDate, ExpiryDate from QuoteHeader where QuoteNum = '" + quoteNum + "'").get (0);   

%>

<!DOCTYPE html>

<html>
  <head>
    <style>
      body { margin: 0; padding: 0; background: grey; }
      * { box-sizing: border-box; -moz-box-sizing: border-box; }
      .page { width: 21cm; min-height: 29.7cm; padding: 1cm; margin: 1cm auto; border: 1px  solid; background: white; box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); }
      .subpage { border: 1px black solid; height: 237mm; min-height: 24.7cm; }
.termscontainer { width: 90%; margin: auto; display: grid; grid-template-columns: 25% auto; }
      @page { size: A4; margin: 0; }
      @media print { .page { margin: 0; border: initial; border-radius: initial; width: initial; min-height: initial; box-shadow: initial; background: initial; page-break-after: always; } }

.breakhere { page-break-after: always; }
    </style>
  </head>

  <body>

    <div>

      <div class="page">
        <div class="subpage">
          <% //header %>
          <div>
            <div style="float: left">
              <img src="logo.jpg" height="50px;"/><br>
            </div>
            <div style="float: right; font-size: 10px; text-align: right;" >
              EF Marine<br>
              7 Suntec Tower One Singapore<br>
            </div>
          </div>

          <br><br><br><br><br><br>
          <div style="text-align: center; font-size: 20px;"><%= request.getParameter ("docType") %></div><br>
          <div style="font-size: 12px; text-align: justify;">
            of the vessel(s) set out herein for account of the Member named hereunder subject to the By-Laws and Rules of the Association from time to time in force and to any special terms and conditions endorsed hereon and/or as may from time to time be circularized. Unless indicated to the contrary herein, the cover evidenced by this Certificate of Entry commences at 12:00 noon GMT on the date specified below in Section “COVER TO COMMENCE” and continues until the moment immediately prior to 12:00 noon GMT on the date specified below in Section “COVER TO TERMINATE” or until cover ceases or is terminated in accordance with the said By-Laws and Rules.
          </div>
          <br>
          <div style="text-align: center;">Class I – Protection & Indemnity Insurance</div>
          <% // box %>
          <div style="width: 90%; margin: auto; display: grid; grid-template-columns: auto auto auto auto auto;">
            <div style="border: 1px solid; padding: 5px; ">
              VESSEL(S)<br>
              <%= map.get ("ShipName") %><br>
              IMO No.: <%= map.get ("IMO") %><br>
            </div>
            <div style="border: 1px solid; padding: 5px; ">
              FLAG<br>
              <%= map.get ("Flag") %><br>
              PORT OF REGISTRY<br>
              GUANG ZHOU<br>
            </div>
            <div style="border: 1px solid; padding: 5px; ">
              CLASS<br>
              CCS<br>
              <br>
            </div>
            <div style="border: 1px solid; padding: 5px; ">GROSS TONNAGE
              1595<br><br><br>
            </div>
            <div style="border: 1px solid; padding: 5px; ">
              COVER TO COMMENCE<br>
              <%= map.get ("EffectiveDate").split (" ") [0] %><br>
              COVER TO TERMINATE<br>
              <%= map.get ("ExpiryDate").split (" ") [0] %><br>
            </div>
          </div>

          <div style="border: 1px solid; width: 90%; margin-left: auto; margin-right: auto; padding: 5px; ">
            MEMBERS,
            Their full names and principal place of business 
            GUANGZHOU DONG FANG HUA CHEN SHIPPING CO., LTD as owner
            ROOM 2307, NO.1 EAST PAZHOU ROAD, HAIZHU DISTRICT, GUANGZHOU, CHINA
            GUANGZHOU POSEIDON SHIP MANAGEMENT CO., LIMITED as manager
            ROOM 2305, NO.1 EAST PAZHOU ROAD, HAIZHU DISTRICT, GUANGZHOU, CHINA
            CHINA SUNRISE (GROUP) CO., LIMITED as joint member
            RM 1001-2 10/F CHOW TAI FOOK CENTRE 580 A-F NATHAN ROAD KL
            Each for their respective rights and interests
          </div>

          <div style="border: 1px solid; width: 90%; margin-left: auto; margin-right: auto;">
            SPECIAL TERMS & CONDITIONS AS ATTACHED
          </div>


          <div style="margin-left: 10%; align-items: flex-end; width: 80%; font-size: 80%;">
            IMPORTANT<br>                                                                                                       
            This Certificate of Entry is evidence only of the contract of indemnity insurance between the above-named Member and the Association and shall not be construed as evidence of any undertaking, financial or otherwise, on the part of the Association to any other party.
Unless otherwise stated in the attached Special Terms and Conditions, the cover evidenced by this Certificate of Entry includes the Association's liability to reimburse the Member for claims in respect of cargo, liability for pollution, liability for the removal of wreck and liability for damage to third-party property (dock damage) as defined in the By-Laws and Rules of the Association and any Special Terms and Conditions appended to this Certificate of Entry.
If a Member tenders this Certificate as evidence of insurance under any applicable law relating to financial responsibility, or otherwise shows or offers it to any other party as evidence of insurance, such use of this Certificate by the Member is not to be taken as any indication that the Association thereby consents to act as guarantor or to be sued directly in any jurisdiction whatsoever. The Association does not so consent.
Breach of premium warranty may lead to rejection of all claims whether arising before or after the breach.<br>

</div>

          <% // footer %>
          <div style="margin-left: 10%; align-items: flex-end;">
            CERTIFICATE NO: <%= quoteNum %><br>
            DATE: <%= getFieldValue ("QuoteHeader", "QuoteDate", " where QuoteNum = '" + quoteNum  + "'").split (" ")[0] %><br>
            Authorized Signatory for
            British Steamship Management Ltd, the Manager of<br>
            British Steamship Protection and Indemnity Association (Bermuda) Limited<br>  
            Clarendon House, 2 Church Street, Hamilton HM 11, Bermuda<br>
          </div> 

        </div>  
  
        <div style="float: right;">Page <%= i++ %></div>
      </div>




      <div class="page">
        <div class="subpage">
          <% //header %>
          <div>
            <div style="float: left">
              <img src="logo.jpg" height="50px;"/><br>
            </div>
            <div style="float: right; font-size: 10px; text-align: right;" >
              EF Marine<br>
              7 Suntec Tower One Singapore<br>
            </div>
          </div>
          <br><br><br><br>

          <div class="termscontainer">
            <div style="border: 1px solid; padding: 5px; ">TRADING AREA</div>
            <div style="border: 1px solid; padding: 5px; "><%= getFieldValue ("QuoteHeader", "TradingArea", " where QuoteNum = '" + quoteNum  + "'") %>
            </div>

            <div style="border: 1px solid; padding: 5px; ">DEDUCTIBLES(S)</div>
            <div style="border: 1px solid; padding: 5px; ">
            <%
              for (Map<String, String> map : getRecords ("select QuoteDeductible.QuoteNum, Amt, Deductibles.Description from QuoteDeductible inner join Deductibles on Deductibles.DeductNum = QuoteDeductible.DeductNum where QuoteNum = '" + quoteNum + "'")) {
            %>
            <%= map.get ("Amt") %>--<%= map.get ("Description") %><br>
            <%
              }
            %>
            </div>
          </div>

          <% // footer %>
          <div style="margin-left: 10%; align-items: flex-end;">
            QUOTE NO: <%= quoteNum %><br>
            DATE: <%= getFieldValue ("QuoteHeader", "QuoteDate", " where QuoteNum = '" + quoteNum  + "'").split (" ")[0] %><br>
            Authorized Signatory for
            British Steamship Management Ltd, the Manager of<br>
            British Steamship Protection and Indemnity Association (Bermuda) Limited<br>  
            Clarendon House, 2 Church Street, Hamilton HM 11, Bermuda<br>
          </div> 

        </div>
        <div style="float: right;">Page <%= i++ %></div>
      </div>

    </div>

  </body>
</html>