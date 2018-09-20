<% // http://asp-arka.blogspot.sg/2014/09/printing-page-size-in-a4-using-css-paged-media.html 
// http://www.jessicaschillinger.us/2017/blog/print-repeating-header-browser/ %>

<%@include file="/dbhelper.jsp" %>

<%!

  int i, linenum;
  Map<String, String> map; 
  String policyNum, footer;

%>

<%

  policyNum = (request.getParameter ("PolicyNum") == null) ? "" : request.getParameter ("PolicyNum");
  footer = "          <div style=\"margin-left: 10%; align-items: flex-end;\">" + 
           " CERTIFICATE NO: " + policyNum + "<br>" +
           " DATE: " + getFieldValue ("PolicyHeader", "PolicyDate", " where PolicyNum = '" + policyNum  + "'").split (" ")[0] + "<br>" +
           " Authorized Signatory for " +
           " British Steamship Management Ltd, the Manager of<br>" +
           " British Steamship Protection and Indemnity Association (Bermuda) Limited<br> " +
           " Clarendon House, 2 Church Street, Hamilton HM 11, Bermuda<br></div>"; 
  i = 1;
  linenum = 1;

  if (!policyNum.equals ("")) map = getRecords ("select PolicyHeader.ShipNum, ShipName, IMO, Flag, EffectiveDate, ExpiryDate from PolicyHeader inner join Ships on Ships.ShipNum = PolicyHeader.ShipNum where PolicyNum = '" + policyNum + "'").get (0);   

%>

<!DOCTYPE html>

<html>
  <head>
    <style>
      body { margin: 0; padding: 0; background: grey; }
      * { box-sizing: border-box; -moz-box-sizing: border-box; }
      .page { width: 21cm; min-height: 29.7cm; padding: 1cm; margin: 1cm auto; border: 1px  solid; background: white; box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); }
      .subpage { border: 1px black solid; height: 237mm; min-height: 24.7cm; }

      @page { size: A4; margin: 0; }
      @media print { .page { margin: 0; border: initial; border-radius: initial; width: initial; min-height: initial; box-shadow: initial; background: initial; page-break-after: always; } }

.termscontainer { width: 90%; margin: auto; display: grid; grid-template-columns: 25% auto; }  
  .breakhere { page-break-after: always; }
  .content-block { page-break-inside: avoid; }

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
          <div style="text-align: center; font-size: 20px;">Certificate of Insurance</div><br>
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
          <%= footer %>

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

          <div style="text-align: center">SPECIAL TERMS & CONDITIONS</div><br>

          <% // box %>
          <div class="termscontainer">
            <div style="border: 1px solid; padding: 5px; ">TRADING AREA</div>
            <div style="border: 1px solid; padding: 5px; ">
              fdskjflksajf dsajfdslkjf dsakfjs;lkdajfklsdj<br>dslkjflkdsjafkjdsaf;lkjdsafkl;dsaj<br>fdksljf;lsjdf;lkjdsalkfja;lksjfsa
            </div>

            <div style="border: 1px solid; padding: 5px; ">CONDITIONS</div>
            <div style="border: 1px solid; padding: 5px; ">
              fdskjflksajf dsajfdslkjf dsakfjs;lkdajfklsdj<br>dslkjflkdsjafkjdsaf;lkjdsafkl;dsaj<br>fdksljf;lsjdf;lkjdsalkfja;lksjfsa
            </div>

            <div style="border: 1px solid; padding: 5px; ">EXPRESS<br>WARRANTIES</div>
            <div style="border: 1px solid; padding: 5px; ">
              Warranted IACS classed and IACS class maintained;<br>
              Warranted ISM Compliant and compliance maintained, if applicable;<br>
              Warranted ISPS Compliance, if applicable;<br>
              Warranted SOLAS, MARPOL LLC Compliance;<br>
              Satisfactory claims record;<br>
              Information and technical details of the vessel submitted by the Assured to be correct;<br>
              Register, ship’s, ISM documents to be provided to the Insurer;<br>
              Terms and provisions of the Crew contract of employment to be approved by the Insurer in written;<br>
              Warranted no logs or other timber cargoes shall be carried on deck;<br>
              Warranted no North Korean crew members on board and no trading to North Korean waters;<br>
              Warranted no voyages to/from Iran, Syria, Libya, Yemen, Sudan and Crimea;<br> 
              Excluding all liabilities arising from /in relation to vessel’s trading to/from USA waters its dependencies and/or territories.<br>
              Warranted vessel to be insured for Hull and Machinery, with a value of no less than her actual market Hull value within all P&I entry cover period;<br>
              Warranted no cover in respect of transport of crude oil or petroleum products originating or shipped from Syria.<br>

            </div>

          </div>
          <% // footer %>
          <%= footer %>

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

            <div style="border: 1px solid; padding: 5px; ">LIMIT OF COVER</div>
            <div style="border: 1px solid; padding: 5px; ">
              US$ 20,000,000.-- any one accident or occurrence and in aggregate for all accidents or occurrence.<br>
              US$ 80,000.-- per crew member in respect of Sections 1, 2, 3, 4, any one accident or occurrence;<br>
              - crew liability cover is provided subject to age of the crew member shall not exceed pensionable age (59 years).<br>
              US$ 30,000. -- per person in respect of Section 6, any one accident or occurrence<br>

            </div>

            <div style="border: 1px solid; padding: 5px; ">DEDUCTIBLES(S)</div>
            <div style="border: 1px solid; padding: 5px; ">
            <%
              for (Map<String, String> map : getRecords ("select PolicyLine.PolicyNum, Amt, Deductibles.Description from PolicyLine inner join Deductibles on Deductibles.DeductNum = PolicyLine.DeductNum where PolicyNum = '" + policyNum + "'")) {
            %>
            <%= map.get ("Amt") %>--<%= map.get ("Description") %><br>
            <%
              }
            %>
            </div>

            <div style="border: 1px solid; padding: 5px; ">SANCTIONS<BR>CLAUSE</div>
            <div style="border: 1px solid; padding: 5px; ">
              The Association shall not indemnify a Member against any liabilities, costs or expenses where the provision of cover, the payment of any claim or the provision of any benefit in respect of those liabilities, costs or expenses may expose the Association to any sanction, prohibition, restriction or adverse action by any competent authority or government.<br>
              The Member shall in no circumstances be entitled to recover from the Association that part of any liabilities, costs or expenses which is not recovered by the Association under any reinsurance(s) arranged by the Association because of a shortfall in recovery from such reinsurers by reason of any sanction, prohibition or adverse action against them by a competent authority or government or the risk thereof if payment were to be made by such reinsurers. For the purposes of this Section, “shortfall” includes, but is not limited to, any failure or delay in recovery by the Association by reason of the said reinsurers making payment into a designated account in compliance with the requirements of any competent authority or government.<br>
              The Association is entitled to cancel the policy from the date of inception or any other date at the Manager’s discretion, in case of Member’s breach of any sanction, prohibition or restriction under United Nations resolutions, and/or the trade or economic sanctions, laws or regulations of the European Union, United Kingdom or United States of America. 
            </div>

            <div style="border: 1px solid; padding: 5px; ">PREMIUM(S)</div>
            <div style="border: 1px solid; padding: 5px; ">
              As agreed, according to the Debit Note.
            </div>

          </div>
          <% // footer %>
          <%= footer %>

        </div>
        <div style="float: right;">Page <%= i++ %></div>
      </div>


      <div class="page">
        <div class="subpage">Page <%= i++ %></div>    
      </div>
      <div class="page">
        <div class="subpage">Page <%= i++ %></div>    
      </div>


    </div>

  </body>
</html>