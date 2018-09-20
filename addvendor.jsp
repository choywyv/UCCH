<%@include file="/dbhelper.jsp" %>

<%!

  int i, col;
  List<Map<String, String>> list;  
  String [] colnames, flags;
  String s, vendNum;

%>

<%


  vendNum = (request.getParameter ("vendNum") == null) ? "" : request.getParameter ("vendNum");
  s = "";
  if ((request.getParameter ("create") != null) && (request.getParameter ("create").equals ("true"))) //out.println (
    vendNum = createRecord ("Vendor", request.getParameterMap(), new String [] {});    

  if ((request.getParameter ("update") != null) && (request.getParameter ("update").equals ("true"))) 
    s = updateRecord (getSQLUpdateStmt ("Vendor", request.getParameterMap(), new String [] {"vendNum='" + vendNum + "'"}));

  colnames = getColumns ("Vendor");  

%>

<!DOCTYPE html>
<html>

  <head>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link type="text/css" rel="stylesheet" href="style.css">

    <style> 
      <%= (! vendNum.equals ("")) ? "#form1 { pointer-events: none; }" : "" %>
    </style>

    <script id="sc1">

      getDetails = function (obj, resultDiv) {
        //document.getElementById (resultDiv).innerHTML = obj.id;
      }

    </script>

  </head>

  <body>   
    <%= (request.getParameter ("create") != null) ? "New Vendor " + vendNum + " created!<br>" : "" %>

    <div class="" style="display: flex;">

      <div class="mainbody">

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;"><%= (vendNum == null) ? "New " : "" %>Vendor details</span><br>
        <span style=" margin-left: 5%; font-size: 12px; ">* required</span><br>
        <%= (! vendNum.equals ("")) ? "<button type=\"button\" id=\"btn\" onclick=\"formeditable (document.getElementById ('form1'));\">edit</button>" : "" %>

        <form name="form1" id="form1">
          <%
  
            for (i = 1; i < colnames.length; i++) {
              if (isVisible ("Vendor", colnames [i])) {
                if (colnames [i].matches ("Country|OwnerType")) {  
          
          %>

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("Vendor", colnames [i]) %></label>  
          <select name="<%= colnames [i] %>" id="<%= colnames [i] %>">
            <%

              if (colnames [i].equals ("Country")) for (Map<String, String> map: getRecords ("select Flag from Countries")) {

            %>

              <option value="<%= map.get ("Flag") %>" 
                <%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) && (! map.get ("Flag").equals (getFieldValue ("Vendor", "Country", " where vendNum='" + vendNum + "'"  ))) ? " disabled" : "" %>
                <%= (map.get ("Flag").equals (getFieldValue ("Vendor", "Country", " where vendNum='" + vendNum + "'"  ))) ? " selected" : "" %>><%= map.get ("Flag") %>
              </option>

            <%

              }
              if (colnames [i].equals ("OwnerType")) {

            %>

              <option value="Company">Company</option>
              <option value="Individual">Individual</option>

            <%

               }
            %>
          </select>
          <br>

          <%

            }
            else {

          %>
          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("Vendor", colnames [i]) %></label>  
          <input <%= (colnames [i].matches ("Country")) ? "list=\"" + "Flaglist\"" : "type=\"text\"" %> name="<%= colnames [i] %>" id="<%= colnames [i] %>" placeholder="<%= getColumnDescription ("Vendor", colnames [i]) %> *" onfocus="getDetails (this, 'infodiv');" 
          <%= (! vendNum.equals ("")) ? "value=\"" + getFieldValue ("Vendor", colnames [i], " where vendNum='" + vendNum + "'") + "\"" : "" %>
          <%= (! vendNum.equals ("") && (i == 1)) ? " readonly" : "" %>>

          <br>

          <%

                }
              }
            }
 
          %>

          <br>
 
          <input type="hidden" name="<%= vendNum.equals ("") ? "create" : "update" %>" id="<%= vendNum.equals ("") ? "create" : "update" %>" value="true">
          <button type="button" style="background: #aaeeee; " onclick="ajax ('addvendor.jsp', this.form, 'content');"><%= vendNum.equals ("") ? "Create" : "Save" %></button>

        </form>
      
      </div>

      <div id="infodiv" style="border-style: dotted; left: 74%; width: 15%; position: fixed; ">
      </div>

    </div>
    <br>

    <form name="form2" >
      <input type="hidden" name="source" value="owner">
      <input type="hidden" name="report" value="shiplisting">
      <input type="hidden" name="vendNum" value="<%= vendNum %>">
    </form>

  </body>
</html>

