
<%@include file="/dbhelper.jsp" %>

<%!

  int i;
  List<Map<String, String>> list;  
  
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
      quote = getRecords ("select QuoteType, QuoteNum, CONVERT(varchar, QuoteDate, 23) AS 'Quotedate', CONVERT(varchar, ApplicationDate, 23) AS ApplicationDate, AssuredNum, AssuredAddress, CONVERT(varchar, EffectiveDate, 23) AS 'EffectiveDate', CONVERT(varchar, ExpiryDate, 23) AS 'ExpiryDate', Currency, Premium, PaymentTerms, Underwriter, Status, TradingArea, Conditions, LimitLiability, ExpressWarranties, SanctionClause, ApplicableClause, SurveyWarranty, DefectWarranty, Comments, VAT from QuoteHeader where QuoteNum = '" + s + "'").get (0);
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
      quote = getRecords ("select QuoteType, QuoteNum, CONVERT(varchar, QuoteDate, 23) AS 'QuoteDate', CONVERT(varchar, ApplicationDate, 23) AS ApplicationDate, AssuredNum, AssuredAddress, CONVERT(varchar, EffectiveDate, 23) AS 'EffectiveDate', CONVERT(varchar, ExpiryDate, 23) AS 'ExpiryDate', Currency, Premium, PaymentTerms, Underwriter, Status, TradingArea, Conditions, LimitLiability, ExpressWarranties, SanctionClause, ApplicableClause, SurveyWarranty, DefectWarranty, Comments, VAT from QuoteHeader where QuoteNum = '" + s + "'").get (0);

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

    void addAssured (Map<String, String[]> map) throws Exception {

//      return recordExists ("select top 1 * from QuoteAssured where QuoteNum = '" + map.get ("QuoteNum")[0] + "' and Type = '" + map.get ("Type")[0] + "'") ? map.get ("Type")[0] + " already exist!" : createRecord ("QuoteAssured", map, new String [] {}); 
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

  quote = (request.getParameter ("QuoteType") == null) && (request.getParameter ("QuoteNum") == null) ? new Quote () : 
          (request.getParameter ("QuoteType") != null) ? new Quote (request.getParameter ("QuoteType")) : 
          new Quote (request.getParameter ("QuoteType"), request.getParameter ("QuoteNum")); 
 
  s = "";

  if ((request.getParameter ("update") != null) && (request.getParameter ("update").equals ("true"))) 
    s = quote.update (request.getParameterMap (), new String [] {"QuoteNum='" + quote.get ("QuoteNum") + "'"});

  colnames = getColumns ("QuoteHeader");
  assuredcolnames = getColumns ("QuoteAssured");

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
      ajaxPopulateData = function (url, populateData) {
        var xhttp = new XMLHttpRequest ();
        xhttp.onreadystatechange = function () {
          if ((this.readyState == 4 && this.status == 200) || (this.status == 404) || (this.status == 500)) { 
            populateData (JSON.parse(xhttp.responseText));
          }
        };
        xhttp.open ("POST", url, true); 
        xhttp.setRequestHeader ("Content-type", "application/x-www-form-urlencoded"); 
        xhttp.send ();
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
        btn.setAttribute("form", "form1")
        //if (document.getElementById ("ShipNum").value == "") document.getElementById ("ShipNum").value = "CL";
        ajax (btn.form.action, btn.form, 'content');
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
 
              for (i = 3; i < colnames.length; i++) {
              
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

            <%= (colnames [i].equals ("AssuredNum")) ? "<button type=\"button\" onclick=\"ajaxPopup ('searchpopup.jsp', document.getElementById ('" + (colnames [i].equals ("AssuredNum") ? "form2" : "form3") + "'), 'searchpopup'); \" style=\"width:auto; font-size: 80%;\" disabled>Select Bill-to</button>" : "" %>
            <br>
 
            <%= colnames [i].equals ("AssuredNum") ? getDatalist ("Assured", "AssuredNum") : 
                colnames [i].equals ("ShipNum") ? getDatalist ("Ships", "ShipNum") :
                colnames [i].equals ("Currency") ? getDatalist ("Countries", "Currency", true) : "" %>
 
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

          <form id="form5">

            <%

              for (i = 2; i < assuredcolnames.length; i++) {

            %>

            <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("QuoteAssured", assuredcolnames [i]) %></label>  
            <input type="text" <%= (assuredcolnames[i].equals ("Class")) ? "list=\"" + assuredcolnames [i] + "list\"" : "" %> name="<%= assuredcolnames [i] %>" id="q<%= assuredcolnames [i] %>" placeholder="<%= getColumnDescription ("QuoteAssured", assuredcolnames [i]) %> *" onfocus="setHelp ('Double click on the empty field for list of options');" oninput="getDetails (this, 'infodiv');" onchange="" onblur="validateDatalist ('Classlist', this.id, 'Invalid option specified for Class!');"> 
            <%= (assuredcolnames [i].equals ("AssuredNum")) ? "<button type=\"button\" onclick=\"ajaxPopup ('searchpopup.jsp', document.getElementById ('form5'), 'searchpopup');\"  style=\"width:auto; font-size: 80%;\">Search Assured</button>" : "" %>          
            <span id="span1"></span>
            <br>

            <%
 
              }
 
            %>
 
            <input type="hidden" name="<%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? "update" : "create" %>" id="<%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? "update" : "create" %>" value="true">
              <input type="hidden" name="elementId" value="id01" />
              <input type="hidden" name="source" value="quotesearch" />
              <input type="hidden" name="report" value="assuredlisting" />
              <input type="hidden" name="callerElement" value="AssuredNum" />
              <input type="hidden" name="callerElementId" value="qAssuredNum" />
              <input type="hidden" name="title" value="Assured" />
            <button type="button" onclick="ajax ('quote.jsp', this.form, 'content');">Add Assured</button>  

          </form>

          <%= getDatalist ("AssuredClass", "Class") %>

        </div>

        <div class="divisibility" id="divvessel" style="display: none;">

          <jsp:include page="listing.jsp" >
            <jsp:param name="report" value="quotevessellisting" />
            <jsp:param name="source" value="quote" />
            <jsp:param name="QuoteNum" value="<%= quote.get (\"QuoteNum\") %>" />
          </jsp:include>

          <button type="button" onclick="ajax ('quotevessel.jsp', document.getElementById ('form4'), 'content')">Add Vessel</button>
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

    <form name="form2" id="form2">
      <input type="hidden" name="elementId" value="id01" />
      <input type="hidden" name="source" value="quotesearch" />
      <input type="hidden" name="report" value="assuredlisting" />
      <input type="hidden" name="callerElement" value="AssuredNum" />
      <input type="hidden" name="callerElementId" value="AssuredNum" />
      <input type="hidden" name="title" value="Assured" />
    </form>

    <form name="form3" id="form3">
      <input type="hidden" name="elementId" value="id01" />
      <input type="hidden" name="source" value="quote" />
      <input type="hidden" name="report" value="shiplisting" />
      <input type="hidden" name="callerElement" value="ShipNum" />
      <input type="hidden" name="callerElementId" value="ShipNum" />
      <input type="hidden" name="title" value="Ship" />
    </form>

   <form name="form4" id="form4">
      <input type="hidden" name="QuoteNum" value="<%= quote.get ("QuoteNum") %>" />
      <input type="hidden" name="source" value="quote" />
    </form>



    <div id="searchpopup"></div>

    <br><br>

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