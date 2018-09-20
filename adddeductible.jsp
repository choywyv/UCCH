<%@include file="/dbhelper.jsp" %>

<%!

  int i, col;
  List<Map<String, String>> list;  
  String [] colnames, flags;
  String s, deductNum;

%>

<%

  s = "";
  deductNum = (request.getParameter ("DeductNum") == null) ? "" : request.getParameter ("DeductNum");
  if ((request.getParameter ("create") != null) && (request.getParameter ("create").equals ("true"))) 
    deductNum = createRecord ("Deductibles", request.getParameterMap(), new String [] {});    

  colnames = getColumns ("Deductibles");  

%>

<!DOCTYPE html>
<html>

  <head>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link type="text/css" rel="stylesheet" href="style.css">

    <style> 

    </style>

    <script id="sc1">

      getDetails = function (obj, resultDiv) {
        //document.getElementById (resultDiv).innerHTML = obj.id;
      }

    </script>

  </head>

  <body>   
    <%= (request.getParameter ("create") != null) ? "New Dedctible " + deductNum + " created!<br>" : "" %>

    <div class="" style="display: flex;">

      <div class="mainbody">

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;">New Deductible details</span><br>
        <span style=" margin-left: 5%; font-size: 12px; ">* required</span><br>

        <form name="form1" id="form1">
          <%
  
            for (i = 1; i < colnames.length; i++) {
              if (isVisible ("Deductible", colnames [i])) {
          
          %>

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("Deductibles", colnames [i]) %></label>  
          <input type="text" name="<%= colnames [i] %>" id="<%= colnames [i] %>" placeholder="<%= getColumnDescription ("Deductible", colnames [i]) %> *" onfocus="getDetails (this, 'infodiv');" >
          <br>

          <%

              }
            }
 
          %>

          <br>
 
          <input type="hidden" name="<%= deductNum.equals ("") ? "create" : "" %>" id="<%= deductNum.equals ("") ? "create" : "" %>" value="true">
          <button type="button" style="background: #aaeeee; " onclick="ajax ('adddeductible.jsp', this.form, 'content');">Create</button>

        </form>
      </div>

      <div id="infodiv" style="border-style: dotted; left: 74%; width: 15%; position: fixed; ">      </div>

    </div>
    <br>

  </body>
</html>

