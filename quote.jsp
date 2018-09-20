
<%@include file="/dbhelper.jsp" %>

<%!

  int i;
  List<Map<String, String>> list;  
  ArrayList<String> templist;
  
  String [] colnames, assuredcolnames;
  String s;
  Quote quote; 
  Product product;


  private class Product {

    List<Map<String, String>> product;
  
    public Product () throws Exception {
      product = getRecords ("select * from Product");
    }

    int size () {
      return product.size ();
    }

    String getKey (int row, int index) throws Exception {
      return String.valueOf (product.get (row).keySet ().toArray()[index]);

    }

    String getValue (int row, int index) throws Exception {
      return String.valueOf (product.get (row).get (   product.get (row).keySet ().toArray()[index]   ));
    }


  } // class


  private class Quote {

    Map <String, String> quote;

    public Quote () {
      quote = new HashMap <String, String>();      
    }
 
    public Quote (String quoteType) throws Exception {      
      Map <String, String []> map;
      String s;

      map = new HashMap <String, String []> ();
      s = getLastNum ("QuoteHeader", "QuoteNum", " where QuoteType = '" + quoteType + "'");
      map.put ("Status", new String [] {"New"});       
      map.put ("QuoteType", new String [] {quoteType});       
      map.put ("QuoteNum", new String [] {s});    
      createRecord ("QuoteHeader", map, new String [0]);
      quote = getRecords ("select QuoteType, QuoteNum, CONVERT(varchar, QuoteDate, 23) AS 'Quotedate', CONVERT(varchar, ApplicationDate, 23) AS ApplicationDate, AssuredNum, AssuredAddress, CONVERT(varchar, EffectiveDate, 23) AS 'EffectiveDate', CONVERT(varchar, ExpiryDate, 23) AS 'ExpiryDate', Currency, Premium, PaymentTerms, Underwriter, Status, TradingArea, Conditions, LimitLiability, ExpressWarranties, SanctionClause, ApplicableClause, SurveyWarranty, DefectWarranty, Comments, VAT, BrokerNum from QuoteHeader where QuoteNum = '" + s + "'").get (0);
    }

    public Quote (String quoteType, String quoteNum) throws Exception {      

      Map <String, String []> map;
      String s;

      map = new HashMap <String, String []> ();
      if (quoteNum.equals ("")) {

        s = getLastNum ("QuoteHeader", "QuoteNum", " where QuoteType = '" + "SO" + "'");
        map.put ("Status", new String [] {"New"});       
        map.put ("QuoteType", new String [] {"SO"});       
        map.put ("QuoteNum", new String [] {s});    
        createRecord ("QuoteHeader", map, new String [0]);

      }
      else s = quoteNum;
      quote = getRecords ("select QuoteType, QuoteNum, CONVERT(varchar, QuoteDate, 23) AS 'QuoteDate', CONVERT(varchar, ApplicationDate, 23) AS ApplicationDate, AssuredNum, AssuredAddress, CONVERT(varchar, EffectiveDate, 23) AS 'EffectiveDate', CONVERT(varchar, ExpiryDate, 23) AS 'ExpiryDate', Currency, Premium, PaymentTerms, Underwriter, Status, TradingArea, Conditions, LimitLiability, ExpressWarranties, SanctionClause, ApplicableClause, SurveyWarranty, DefectWarranty, Comments, VAT, BrokerNum from QuoteHeader where QuoteNum = '" + s + "'").get (0);

    }

    public String get (String fieldValue) throws Exception {
      return (quote.get (fieldValue) == null) ? "" : quote.get (fieldValue);  
    }

    String update (Map<String, String[]> map, String[] additional) throws Exception {
      Map<String, String []> map1;  
      map1 = new HashMap<String, String[]> (map);
      if (map1.get ("Status")[0].equals ("New")) map1.put ("Status",  new String [] {"Open"}); 
      return updateRecord (getSQLUpdateStmt ("QuoteHeader", map1, additional));
    }

    String addAssured (Map<String, String[]> map) throws Exception {
      return recordExists ("select top 1 * from QuoteAssured where QuoteNum = '" + map.get ("QuoteNum")[0] + "' and AssuredNum = '" + map.get ("AssuredNum")[0] + "'") ? "Adding Assured failed!<br>" + map.get ("AssuredNum")[0] + " already exist!" : createRecord ("QuoteAssured", map, new String [] {}); 
    }


    String addVessel (Map<String, String[]> map) throws Exception {
      return recordExists ("select top 1 * from QuoteVessel where QuoteNum = '" + map.get ("QuoteNum")[0] + "' and ShipNum = '" + map.get ("ShipNum")[0] + "'") ? "Adding Vessel failed!<br>" + map.get ("ShipNum")[0] + " already exist!" : createRecord ("QuoteVessel", map, new String [] {}); 
    }

    String previous () throws Exception {
      return getPreviousRecord ("QuoteHeader", "QuoteNum", quote.get ("QuoteNum"));
    } 

    String next () throws Exception {
      return getNextRecord ("QuoteHeader", "QuoteNum", quote.get ("QuoteNum"));
    } 

  }  

%>

<%

  //if ((request.getUserPrincipal() == null) || (request.getParameter ("ref") == null)) response.sendRedirect("/test");
  s = "";

  quote = (request.getParameter ("QuoteType") == null) && (request.getParameter ("QuoteNum") == null) ? new Quote () : 
          (request.getParameter ("QuoteType") != null) && (request.getParameter ("QuoteNum") == null) ? new Quote (request.getParameter ("QuoteType")) : 
          new Quote (request.getParameter ("QuoteType"), request.getParameter ("QuoteNum")); 
 
  if ((request.getParameter ("addAssured") != null) && (request.getParameter ("addAssured").equals ("true"))) 
    s = quote.addAssured (request.getParameterMap ());

  if ((request.getParameter ("addVessel") != null) && (request.getParameter ("addVessel").equals ("true"))) 
    s = quote.addVessel (request.getParameterMap ());


  if ((request.getParameter ("update") != null) && (request.getParameter ("update").equals ("true"))) {
    s = quote.update (request.getParameterMap (), new String [] {"QuoteNum='" + quote.get ("QuoteNum") + "'"});
    quote = new Quote (request.getParameter ("QuoteType"), request.getParameter ("QuoteNum")); 
  }

  colnames = getColumns ("QuoteHeader");
  templist = new ArrayList <String> (Arrays.asList(colnames));
  templist.remove ("BrokerNum");
  colnames = templist.toArray(new String[0]);

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
      populateSearchPopupForm = function (val1, val2, val3, val4, val5, val6) {
        var formData = new FormData (document.getElementById ("searchpopupform"));
        formData.set ("elementId", val1);
        formData.set ("source", val2);
        formData.set ("report", val3);
        formData.set ("callerElement", val4);
        formData.set ("callerElementId", val5);
        formData.set ("title", val6);

        ajaxPopup ('searchpopup.jsp', formData, 'searchpopup');
      }


      populateData = function (obj) {
        var i;
        for (i = 0; i < Object.keys (obj).length; i++) document.getElementById (Object.keys (obj) [i]).innerHTML = obj [Object.keys (obj)[i]];
      } 


      getDetails = function (obj, resultDiv) {
       // document.getElementById (resultDiv).innerHTML = ajax ("minidetails.jsp?table=" + ((obj.id == "ShipNum") ? "Ships" : (obj.id == "AssuredNum") ? "Assured" : "") + "&" + obj.id + "=" + obj.value, '', resultDiv);
      }

      formatText = function () {
        document.getElementById ("Currency").value = document.getElementById ("Currency").value.toUpperCase();
      }

      formSubmit = function (btn) {
        btn.setAttribute("form", "form1");

        //if (document.getElementById ("ShipNum").value == "") document.getElementById ("ShipNum").value = "CL";
//        ajax (btn.form.action, btn.form, 'content');
        ajax ("quote.jsp", btn.form, 'content');
      }

      uploadFileList = function() {
        var i, input = document.getElementById('file');
        document.getElementById('fileList').innerHTML = "";
        if (input.files.length > 1) for (i = 0; i < input.files.length; i++) document.getElementById('fileList').innerHTML += input.files[i].name + '<br>';
      }

      checkUpload = function () { 
        if (document.getElementById('file').files.length == 0) {
          alert ("No files selected!"); 
          return false;
        }
        else document.getElementById ("uploadForm").submit ();
      }

      getFieldDefault = function (referenceField) {
        if (referenceField == "AssuredNum") {
          var xhttp = new XMLHttpRequest ();
          xhttp.onreadystatechange = function () {
            if ((this.readyState == 4 && this.status == 200) || (this.status == 404) || (this.status == 500)) { 
              document.getElementById ("AssuredAddress").value = this.responseText;
            }
            else document.getElementById ("AssuredAddress").value = "";    
          };
          xhttp.open ("POST", "getdetails.jsp", true); 
          xhttp.setRequestHeader ("Content-type", "application/x-www-form-urlencoded"); 
          xhttp.send ("&table=Assured&fieldToFind=Address&condition=" + referenceField + "&conditionValue=" + document.getElementById (referenceField).value);
        }
        else if (referenceField == "BrokerNum") {  
          var xhttp;
          xhttp = new XMLHttpRequest ();
          xhttp.onreadystatechange = function () {
            if ((this.readyState == 4 && this.status == 200) || (this.status == 404) || (this.status == 500)) {
              document.getElementById ("CommissionPercentage").value = this.responseText + "%";
              document.getElementById ("CommissionAmt").value = parseFloat (this.responseText) * document.getElementById ("Premium").value / 100;
            }
          };
          xhttp.open ("POST", "getdetails.jsp", true); 
          xhttp.setRequestHeader ("Content-type", "application/x-www-form-urlencoded"); 
          xhttp.send ("&table=Broker&fieldToFind=Commission&condition=" + referenceField + "&conditionValue=" + document.getElementById (referenceField).value);

          ajax ("minidetails.jsp?table=Broker&BrokerNum=" + document.getElementById (referenceField).value, '', 'infodiv');
        }
        else if (referenceField == "EffectiveDate") {
          var date = new Date(document.getElementById ("EffectiveDate").value);
          date.setYear(date.getFullYear()+1);
          date.setDate(date.getDate()-1);
          document.getElementById ("ExpiryDate").value = date.toISOString().slice (0,10);

        }
      }

      topFunction = function () {
        document.body.scrollTop = 0;
        document.documentElement.scrollTop = 0;
      }

      fieldError = function (field, errormsg) {
        alert (errormsg);
        window.setTimeout(function () { 
          document.getElementById("qClass").focus();
        }, 0);
      } // fieldError

      validateForm = function (loadpage, f, content) {  
        if (! valueInDatalist ("Classlist", "qClass")) fieldError ("qClass", "Invalid option specified for Class!");
        else if (! valueInDatalist ("CharterTypelist", "CharterType")) fieldError ("CharterType", "Invalid option specified for CharterType!");
        else if (! valueInDatalist ("CharterPartylist", "CharterParty")) fieldError ("CharterParty", "Invalid option specified for CharterParty!");
        else ajax (loadpage, f, content);
      } // validateForm

    </script>
  </head>

  <body>

    <button onclick="topFunction();" id="backToTopBtn" title="Go to top">Top</button>

      <form >
        <select name="QuoteType" id="QuoteType">

          <% 
            product = new Product ();
            for (i = 0; i < product.size (); i++) { 
          %>

            <option value="<%= product.getValue (i, 0) %>"><%= product.getValue (i, 1) %></option>

          <% } %>
        </select>
        <button type="button" style="width: auto;" onclick="ajax ('quote.jsp', this.form,'content');">New Quote</button>

      </form>
      <br>


      <% if (!quote.get ("QuoteNum").equals ("")) { %>
    <div class="" style="display: flex;" <%= quote.get ("QuoteNum").equals ("") ? "style=\"display: none;\"" : "" %>>

      <div class="mainbody">

        <div>
          <ul id="sub">
            <li><a class="active" href="#" id="quote" onclick="setDivActive ('divisibility', 'divform1'); setMenuActive ('sub', this);">Quotation</a></li>
            <li><a class="inactive" href="#" id="assured" onclick="setDivActive ('divisibility', 'divassured'); setMenuActive ('sub', this);">Assured</a></li>
            <li><a class="inactive" href="#" id="vessel" onclick="setDivActive ('divisibility', 'divvessel'); setMenuActive ('sub', this);">Vessel</a></li>
            <li><a class="inactive" href="#" id="broker" onclick="setDivActive ('divisibility', 'divbroker'); setMenuActive ('sub', this);">Broker</a></li>
            <li><a class="inactive" href="#" id="upload" onclick="setDivActive ('divisibility', 'divupload'); setMenuActive ('sub', this);">Upload</a></li>

            <%
           
              if (! quote.get ("QuoteNum").equals ("")) {

            %>
            <li><a class="inactive" href="#" id="declarediv" onclick="setMenuActive ('sub', this); setDivActive ('divisibility', 'divdeclare');">Declaration</a></li>            
            <li><a class="inactive" href="#" id="deductdiv" onclick="setMenuActive ('sub', this); setDivActive ('divisibility', 'divdeduct');">Deductible</a></li>

            <%

              }

            %>

          </ul>      
        </div>

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;"><%= (quote.get ("QuoteNum").equals ("")) ? "New " : "" %>Quote</span><br>
        <span style=" margin-left: 5%; font-size: 12px; ">* required</span><br>  

        <div id="quoteheader">
          <% 
            if (! quote.get ("QuoteNum").equals ("")) {
          %>

          <label><%= (!quote.previous ().equals ("")) ? "<a href=\"#\" title=\"Previous\" onclick=\"ajax ('quote.jsp?QuoteNum=" + quote.previous () +"', '', 'content');\">&lt;</a>" : "" %></label> 
          <label><%= (!quote.next ().equals ("")) ? "<a href=\"#\" title=\"Next\" onclick=\"ajax ('quote.jsp?QuoteNum=" + quote.next () +"', '', 'content');\">&gt;</a>" : "" %></label>
          <button type="button" id="btn" onclick="formeditable (document.getElementById ('form1')); document.getElementById ('divbutton').style.display='block'; ">edit</button> 
          <br>
          <%
            for (i = 1; i < 3; i++) {
          %>
            
            <label style="float: none; display: inline-block; width: 50px;"><%= getColumnDescription ("QuoteHeader", colnames [i]) %></label>  
            <input type="text" style="width: 120px; margin-right: 50px;" name="<%= getColumnDescription ("QuoteHeader", colnames [i]) %>" id="<%= getColumnDescription ("QuoteHeader", colnames [i]) %>" value="<%= quote.get (colnames [i]) %>" readonly> 
            
          <% } %>  

          <% } %>
        </div>

        <div class="divisibility" id="divform1">

          <form name="form1" id="form1" action="quote.jsp">
            <%
              for (i = 1; i < 3; i++) {
            %>
              <input type="hidden" name="<%= getColumnDescription ("QuoteHeader", colnames [i]) %>" id="<%= getColumnDescription ("QuoteHeader", colnames [i]) %>" value="<%= quote.get (colnames [i]) %>">
            <% } %>

            <%
              if (quote.get ("QuoteType").equals ("CL")) 
                for (i = 3; i < 5; i++) {
            %>

            <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("QuoteHeader", colnames [i]) %></label>  
            <input type="text" list="<%= colnames [i] + "list" %>" name="<%= colnames [i] %>" id="<%= colnames [i] %>" placeholder="<%= getColumnDescription ("QuoteHeader", colnames [i]) %> *">
            <br>

            <%
              }
            %>

 
            <%
 
              for (i = 5; i < colnames.length; i++) {
              
            %>

            <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("QuoteHeader", colnames [i]) %></label>  
            <%
              if (getColTypeSize ("QuoteHeader", colnames [i]).equals ("1073741823") ) {
            %>
            <textarea name="<%= colnames [i] %>" id="<%= colnames [i] %>" oninput='this.style.height = ""; this.style.height = this.scrollHeight + "px"' name="<%= colnames [i] %>" readonly><%= quote.get (colnames [i])  %></textarea>
            <%
              }
              else if (colnames [i].equals ("VAT")) {
            %>
            <select name="<%= colnames [i] %>" id="<%= colnames [i] %>" disabled>
              <option value="No" <%= quote.get (colnames [i]).equals ("No") ? "selected" : "" %>>No</option>
              <option value="Yes" <%= quote.get (colnames [i]).equals ("Yes") ? "selected" : "" %>>Yes</option>
            </select>
            <% 
              }
              else {
            %> 
            <input type="<%= (getColTypeName ("QuoteHeader", colnames [i]).equals ("datetime2")) ? "date" : "text" %>" <%= (colnames [i].matches ("AssuredNum|Currency")) ? "list=\"" + colnames [i] + "list\"" : "" %> name="<%= colnames [i] %>" id="<%= colnames [i] %>" placeholder="<%= getColumnDescription ("QuoteHeader", colnames [i]) %> *" onfocus="getDetails (this, 'infodiv');" oninput="getDetails (this, 'infodiv');" <%= (colnames [i].matches ("AssuredNum|EffectiveDate")) ? "onchange=\"getFieldDefault (this.id);\"" : "" %> 
            <%= (! quote.get ("QuoteNum").equals ("")) ? "value=\"" + quote.get (colnames [i]) + "\"" : "" %>
            <%= quote.get ("QuoteNum").equals ("") && colnames [i].equals ("QuoteDate") ? "value=\"" + String.valueOf (new java.sql.Date(Calendar.getInstance().getTime().getTime())).split (" ")[0] + "\"" : "" %>
            <%= (colnames [i].matches ("Currency")) ? " onblur=\"formatText ();\"" : "" %>
            readonly>
            <%
              }
            %>

            <%= (colnames [i].equals ("AssuredNum")) ? "<button type=\"button\" onclick=\"populateSearchPopupForm ('id01', 'quotesearch', 'assuredlisting', 'AssuredNum', 'AssuredNum', 'Assured');\" style=\"width:auto; font-size: 80%;\" disabled>Select Bill-to</button>" : "" %>
            <br>

            <%

              }

            %>
            <br>

            <input type="hidden" name="<%= (! quote.get ("QuoteNum").equals ("")) ? "update" : "create" %>" id="<%= (! quote.get ("QuoteNum").equals ("")) ? "update" : "create" %>" value="true">
            <input type="hidden" name="formName" id="formName" value="quoteheader">          

            <div id="divbutton" style="display: none;">
              <button type="button" id="btn1" form="" onclick="formatText (); formSubmit (this);">Save</button>
  
              <%= ((! quote.get ("QuoteNum").equals ("")) && (! quote.get ("Status").equals ("Converted to Policy"))) ?
                "<input type=\"hidden\" name=\"convert\" value=\"true\"><button type=\"button\" onclick=\"ajax ('policy.jsp', this.form, 'content');\" style=\"padding: 0px 0px;\">Convert to Certificate</button>" : "" %>  
            </div>

            <label style="display: inline-block; width: 120px; ">ContentEditable</label> 
            <button type="button" style="width: auto;" onclick="document.execCommand('bold',false,null); document.getElementById('div4').textContent=document.getElementById('div3').innerHTML;">Bold</button>
            <button type="button" style="width: auto;" onclick="document.execCommand('italic',false,null); document.getElementById('div4').textContent=document.getElementById('div3').innerHTML;">Italic</button>
            <div id="div3" contenteditable>123</div><textarea id="div4"></textarea>

          </form>
        </div>

        <div class="divisibility" id="divupload" style="display: none;">
          <form method="POST" action="fileupload.jsp" enctype="multipart/form-data" name="uploadForm" id="uploadForm">
            <label style="width: 100px;">Choose file</label>
            <input type="file" multiple name="file" id="file" style="" onchange="javascript:uploadFileList()"> <br><br>
          </form>

          <div id="fileList" style="padding: 5px;"></div>
          <br>
          <button form="uploadForm" type="button" name="upload" id="upload" onclick="checkUpload ();">Upload</button>
        </div>
        
        <%

          if (! quote.get ("QuoteNum").equals ("")) {

        %>

        <div class="divisibility" id="divassured" style="display: none;">

          <jsp:include page="listing.jsp" >
            <jsp:param name="report" value="quoteassuredlisting" />
            <jsp:param name="source" value="quote" />
            <jsp:param name="QuoteNum" value="<%= quote.get (\"QuoteNum\") %>" />
          </jsp:include>

          <form>

            <%

              colnames = getColumns ("QuoteAssured");
              for (i = 2; i < colnames.length; i++) {

            %>

            <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("QuoteAssured", colnames [i]) %></label>  
            <input type="text" <%= (colnames[i].equals ("Class")) ? "list=\"" + colnames [i] + "list\"" : "" %> name="<%= colnames [i] %>" id="q<%= colnames [i] %>" placeholder="<%= getColumnDescription ("QuoteAssured", colnames [i]) %> *" onfocus="setHelp ('Double click on the empty field for list of options');" oninput="getDetails (this, 'infodiv');" onchange="" onblur="validateDatalist ('Classlist', this.id, 'Invalid option specified for Class!');"> 
            <%= (colnames [i].equals ("AssuredNum")) ? "<button type=\"button\" onclick=\"populateSearchPopupForm ('id01', 'quotesearch', 'assuredlisting', 'AssuredNum', 'qAssuredNum', 'Assured');\"  style=\"width:auto; font-size: 80%;\">Search Assured</button>" : "" %>          
            <span id="span1"></span>
            <br>

            <%
 
              }
 
            %>

            <input type="hidden" name="QuoteType" id="QuoteType" value="<%= quote.get ("QuoteType") %>">
            <input type="hidden" name="QuoteNum" id="QuoteNum" value="<%= quote.get ("QuoteNum") %>">
            <input type="hidden" name="addAssured" id="addAssured" value="true">
            <button type="button" onclick="validateForm ('quote.jsp', this.form, 'content');">Add Assured</button> 

          </form>

        </div>

        <div class="divisibility" id="divvessel" style="display: none;">

          <jsp:include page="listing.jsp" >
            <jsp:param name="report" value="quotevessellisting" />
            <jsp:param name="source" value="quote" />
            <jsp:param name="QuoteNum" value="<%= quote.get (\"QuoteNum\") %>" />
          </jsp:include>

          <form>

            <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("QuoteAssured", "ShipNum") %></label>  
            <input type="text" name="ShipNum" id="ShipNum" placeholder="<%= getColumnDescription ("QuoteVessel", "ShipNum") %> *" oninput="getDetails (this, 'infodiv');" onchange="" onblur=""> 
            <button type="button" onclick="populateSearchPopupForm ('id01', 'quote', 'shiplisting', 'ShipNum', 'ShipNum', 'Vessel');" style="width:auto; font-size: 80%;">Search Vessel</button>
            <span id="span1"></span>
            <br>

            <input type="hidden" name="QuoteType" id="QuoteType" value="<%= quote.get ("QuoteType") %>">
            <input type="hidden" name="QuoteNum" id="QuoteNum" value="<%= quote.get ("QuoteNum") %>">
            <input type="hidden" name="addVessel" id="addVessel" value="true">
            <button type="button" onclick="ajax ('quote.jsp', this.form, 'content');">Add Vessel</button> 

          </form>

        </div>

        <div class="divisibility" id="divdeclare" style="display: none;">

          <jsp:include page="listing.jsp" >
            <jsp:param name="report" value="quotedeclarationlisting" />
            <jsp:param name="source" value="quote" />
            <jsp:param name="QuoteNum" value="<%= quote.get (\"QuoteNum\") %>" />
          </jsp:include>

          <button type="button" onclick="ajax ('quotedeclaration.jsp', document.getElementById ('form4'), 'content')">Declaration</button>
        </div>

        <div class="divisibility" id="divdeduct" style="display: none;">

          <jsp:include page="listing.jsp" >
            <jsp:param name="report" value="deductiblelisting" />
            <jsp:param name="QuoteNum" value="<%= quote.get (\"QuoteNum\") %>" />
          </jsp:include>

          <button type="button" onclick="ajax ('deductible.jsp', document.getElementById ('form4'), 'content')">Deductibles</button>
        </div>

        <div class="divisibility" id="divbroker" style="display: none;">
          <label style="display: inline-block; width: 120px; ">BrokerNum</label>
          <input type="text" form="form1" id="BrokerNum" name="BrokerNum" value="<%= quote.get ("BrokerNum") %>" onchange="getFieldDefault (this.id);">
          <button type="button" onclick="populateSearchPopupForm ('id01', 'quotesearch', 'brokerlisting', 'BrokerNum', 'BrokerNum', 'Broker');" style="width:auto; font-size: 80%;">Select Broker</button>
          <br><br>

          <label style="display: inline-block; width: 120px; ">Commission Percentage</label>
          <input type="text" id="CommissionPercentage" name="CommissionPercentage">
          <br><br>

          <label style="display: inline-block; width: 120px; ">Commission Amount</label>
          <input type="text" id="CommissionAmt" name="CommissionAmt">
        </div>

        <br>

        <form name="printform" id="printform" action="printquote.jsp" target="_blank">
          <input type="hidden" name="QuoteNum" value="<%= quote.get ("QuoteNum") %>">
          <label style="display: inline-block; width: 120px; ">Print As</label>
          <select name="docType" id="docType">
            <option value="Indication">Indication</option>
            <option value="Quotation">Quotation</option>
          </select>
          <button type="button" form="printform" onclick="this.form.submit ();">Print</button>
        </form>

        <%
          }
        %>

      </div>

      <div id="infodiv" style=" border-style: dotted; left: 74%; width: 15%; position: fixed; "><%= s %></div>

    </div>

   <form name="form4" id="form4">
      <input type="hidden" name="QuoteNum" value="<%= quote.get ("QuoteNum") %>" />
      <input type="hidden" name="source" value="quote" />
    </form>

    <form name="searchpopupform" id="searchpopupform">
      <input type="hidden" name="elementId" id="elementId">
      <input type="hidden" name="source" id="source">
      <input type="hidden" name="report" id="report">
      <input type="hidden" name="callerElement" id="callerElement">
      <input type="hidden" name="callerElementId" id="callerElementId">
      <input type="hidden" name="title" id="title">
    </form>


    <div id="searchpopup"></div>

    <br><br>

    <%= getDatalist ("Countries", "Currency", true) %>
    <%= getDatalist ("AssuredClass", "Class", "Classlist") %>
    <% 
      if (quote.get ("QuoteType").equals ("CL")) { 
    %>

      getDatalist ("CharterType", "Type", "CharterTypelist");
      getDatalist ("CharterParty", "Party", "CharterPartylist"); 

    <%
      } 
    %>

    <script id="btnscript">
      window.onscroll = function() {
        document.getElementById("backToTopBtn").style.display = (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) ? "block" : "none";
      }

      for (var elems of document.querySelectorAll ("textarea")) {
        elems.style.height = 'auto';
        elems.style.overflowY = 'hidden';
        elems.style.height = elems.scrollHeight + 20 + 'px';
      }

      <%= (quote.get ("Status").equals ("New")) ? "formeditable (document.getElementById ('form1')); document.getElementById ('divbutton').style.display='block'" : "" %>


      var inputlist = document.querySelectorAll('input[list]');
      for (var i = 0; i < inputlist.length; i++) {
        inputlist [i].setAttribute ("placeholder", "Double click for list of options");
      }
    </script>

      <% } %>

  </body>
</html>