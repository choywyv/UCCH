<%@include file="/dbhelper.jsp" %>

<%!

  int i, pagenum, numpages, totalrows, nextrows;
  String s, source, orderby, sortdir, sql, report, elementId, vendtype;
  List<Map<String, String>> list;  
  Map<String, String> map;

%>

<%

  pagenum = (request.getParameter ("pagenum") == null) ? 1 : Integer.parseInt (request.getParameter ("pagenum"));
  nextrows = (request.getParameter ("nextrows") == null) ? 50 : Integer.parseInt (request.getParameter ("nextrows"));
  vendtype = ((request.getParameter ("vendtype") == null) || request.getParameter ("vendtype").equals ("")) ? "" :  request.getParameter ("vendtype") ;
  sql = "sELECT * FROM Vendor " + (vendtype.equals ("") ? "" : " where VendType='" + vendtype + "'") + " ORDER BY VendNum OFFSET " + (pagenum - 1) * nextrows + " ROWS FETCH NEXT " + nextrows + " ROWS ONLY";
  list = getRecords (sql);
  map = getRecords ("SELECT count(*) as Total FROM Vendor " + (vendtype.equals ("") ? "" : " where VendType='" + vendtype + "'")).get (0);
  totalrows = Integer.parseInt (map.get (map.keySet().toArray()[0]));
  numpages = (int) Math.ceil(totalrows * 1.0 / nextrows);

%>

<!DOCTYPE html>
<html>

  <head>

    <script id="sc2">


      updateForm = function (nextrows, vendtype, pagenum) { 
        document.getElementById ("nextrows").value = nextrows;
        document.getElementById ("vendtype").value = vendtype;
        document.getElementById ("pagenum").value = pagenum;
        ajax ("listingvendor.jsp", document.getElementById ("form1"), "content");
      }
    </script>

  </head>

  <body>

    <form name="form1" id="form1">
      Vendor Type
      <select name="vendtype" id="vendtype">
        <option value="">All</option>
        <option value="Correspondent" <%= (vendtype.equals ("Correspondent")) ? " selected" : "" %>>Correspondent</option>
        <option value="Lawyer" <%= (vendtype.equals ("Lawyer")) ? " selected" : "" %>>Lawyer</option>
        <option value="Surveyor" <%= (vendtype.equals ("Surveyor")) ? " selected" : "" %>>Surveyor</option>
      </select>

      <br><br>

      Show <input type="number" name="nextrows" value="<%= nextrows %>"> rows per page

      <input type="hidden" name="nextrows" id="nextrows" value="<%= nextrows %>">
      <input type="hidden" name="pagenum" id="pagenum" value="<%= pagenum %>">

      <button type="button" onclick="ajax ('listingvendor.jsp', form1, 'content');">Submit</button>

    </form>

    <br><br>

<%

  for (i = 1; i < pagenum; i++) {
%>

  <a href="#" onclick="updateForm ('<%= nextrows %>', '<%= vendtype %>', '<%= i %>');"><%= i %></a> | 

<%

  }

%>

<%= pagenum %> |

<%

  for (i = pagenum + 1; i <= numpages; i++) {

%>

  <a href="#1" onclick="updateForm ('<%= nextrows %>', '<%= vendtype %>', '<%= i %>');"><%= i %></a> |  

<%

  }

%>

  <br><br>  

  <table border="1">
  
<%

  for (Map <String, String> map1 : list) {

%>
  
    <tr>
 
<%

    for (Map.Entry entry : map1.entrySet ()) {

%>
      <td><%= entry.getValue () %></td>
   
<%

    }

%>

    </tr>

<%

  }

%>
    </table>

    <br><br>

  </body>

</html>