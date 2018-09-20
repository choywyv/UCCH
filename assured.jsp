<%@include file="/dbhelper.jsp" %>

<%!

  int i, col;
  List<Map<String, String>> list;  
  String [] colnames, flags;
  String s;
  Assured assured;

  private class Assured {

    Map <String, String> assured;

    public Assured (String assuredNum) throws Exception {      
      assured = assuredNum.equals ("") ? new HashMap <String, String> () : getRecords ("select * from Assured where AssuredNum = '" + assuredNum + "'").get (0);
    }

    public String get (String fieldValue) throws Exception {
      return (assured.get (fieldValue) == null) ? "" : assured.get (fieldValue);  
    }

    String create (Map<String, String[]> map) throws Exception {
      return createRecord ("Assured", map, new String [] {"AssuredNum"});
    }

    String update (Map<String, String[]> map, String[] additional) throws Exception {
      return updateRecord (getSQLUpdateStmt ("Assured", map, additional));
    }
      
  }  

%>

<%

  assured = new Assured ((request.getParameter ("AssuredNum") == null) ? "" : request.getParameter ("AssuredNum"));

  s = "";
  if ((request.getParameter ("create") != null) && (request.getParameter ("create").equals ("true"))) { //out.println (
    s = "Assured " + assured.create (request.getParameterMap()) + " created!";      
  }

  if ((request.getParameter ("update") != null) && (request.getParameter ("update").equals ("true"))) {
    assured.update (request.getParameterMap (), new String [] {"AssuredNum='" + assured.get ("AssuredNum") + "'"});
    s = "Assured " + assured.get ("AssuredNum") + " updated!";
  }

  colnames = getColumns ("Assured");  

%>

<!DOCTYPE html>
<html>

  <head>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link type="text/css" rel="stylesheet" href="style.css">

    <style> 

      <%= (! assured.get ("AssuredNum").equals ("")) ? "#form1 { pointer-events: none; }" : "" %>

    </style>

    <script id="sc1">

      getDetails = function (obj, resultDiv) {
        //document.getElementById (resultDiv).innerHTML = obj.id;
      }

    </script>

  </head>

  <body>   
    <%= (request.getParameter ("create") != null) ? "New Assured " + assured.get ("AssuredNum") + " created!<br>" : "" %>

    <div class="" style="display: flex;">

      <div class="mainbody">

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;"><%= (assured.get ("AssuredNum") == null) ? "New " : "" %>Assured details</span><br>
        <span style=" margin-left: 5%; font-size: 12px; ">* required</span><br>
        <%= (! assured.get ("AssuredNum").equals ("")) ? "<button type=\"button\" id=\"btn\" onclick=\"formeditable (document.getElementById ('form1'));\">edit</button>" : "" %>

        <form name="form1" id="form1">
          <%
  
            for (i = 1; i < colnames.length; i++) {
              if (isVisible ("Assured", colnames [i])) {
                if (colnames [i].matches ("Country|AssuredType")) {  
          
          %>

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("Assured", colnames [i]) %></label>  
          <select name="<%= colnames [i] %>" id="<%= colnames [i] %>">
            <%

              if (colnames [i].equals ("Country")) for (Map<String, String> map: getRecords ("select Flag from Countries")) {

            %>

              <option value="<%= map.get ("Flag") %>" 
                <%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) && (! map.get ("Flag").equals (getFieldValue ("Assured", "Country", " where AssuredNum='" + assured.get ("AssuredNum") + "'"  ))) ? " disabled" : "" %>
                <%= (map.get ("Flag").equals (getFieldValue ("Assured", "Country", " where AssuredNum='" + assured.get ("AssuredNum") + "'"  ))) ? " selected" : "" %>><%= map.get ("Flag") %>
              </option>

            <%

              }
              if (colnames [i].equals ("AssuredType")) {

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
          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("Assured", colnames [i]) %></label>  
          <input <%= (colnames [i].matches ("Country")) ? "list=\"" + "Flaglist\"" : "type=\"text\"" %> name="<%= colnames [i] %>" id="<%= colnames [i] %>" placeholder="<%= getColumnDescription ("Assured", colnames [i]) %> *" onfocus="getDetails (this, 'infodiv');" 
          <%= (! assured.get ("AssuredNum").equals ("")) ? "value=\"" + getFieldValue ("Assured", colnames [i], " where AssuredNum='" + assured.get ("AssuredNum") + "'") + "\"" : "" %>
          <%= (! assured.get ("AssuredNum").equals ("") && (i == 1)) ? " readonly" : "" %>>

          <br>

          <%

                }
              }
            }
 
          %>

          <br>
 
          <input type="hidden" name="<%= assured.get ("AssuredNum").equals ("") ? "create" : "update" %>" id="<%= assured.get ("AssuredNum").equals ("") ? "create" : "update" %>" value="true">
          <button type="button" style="background: #aaeeee; " onclick="ajax ('assured.jsp', this.form, 'content');"><%= assured.get ("AssuredNum").equals ("") ? "Create" : "Save" %></button>

        </form>
      
      </div>

      <div id="infodiv" style="border-style: dotted; left: 74%; width: 15%; position: fixed; ">
        <%

          if (! assured.get ("AssuredNum").equals ("")) {

        %>  
        <button type="button" style="width:auto;" onclick="ajax ('listing.jsp', form2, 'divid01'); document.getElementById ('id01').style.display='block';">Ships (<%= getRecords ("select count (*) as total from Ships where AssuredNum = '" + assured.get ("AssuredNum") + "'").get (0).get ("total") %>)</button>
        <button type="button" style="width:auto;" onclick="ajax ('listing.jsp', form3, 'divid01'); document.getElementById ('id01').style.display='block';">Quotes (<%= getRecords ("select count (*) as total from QuoteHeader where AssuredNum = '" + assured.get ("AssuredNum") + "'").get (0).get ("total") %>)</button>
        <button type="button" style="width:auto;" onclick="ajax ('listing.jsp', form4, 'divid01'); document.getElementById ('id01').style.display='block';">Policies (<%= getRecords ("select count (*) as total from PolicyHeader INNER JOIN QuoteHeader ON QuoteHeader.QuoteNum = PolicyHeader.QuoteNum where AssuredNum = '" + assured.get ("AssuredNum") + "'").get (0).get ("total") %>)</button>
        <%

          }

        %>
      </div>

    </div>
    <br>

    <form name="form2" >
      <input type="hidden" name="source" value="assured">
      <input type="hidden" name="report" value="shiplisting">
      <input type="hidden" name="AssuredNum" value="<%= assured.get ("AssuredNum") %>">
    </form>

    <form name="form3" >
      <input type="hidden" name="source" value="assured">
      <input type="hidden" name="report" value="quotelisting">
      <input type="hidden" name="AssuredNum" value="<%= assured.get ("AssuredNum") %>">
    </form>

    <form name="form4" >
      <input type="hidden" name="source" value="assured">
      <input type="hidden" name="report" value="policylisting">
      <input type="hidden" name="AssuredNum" value="<%= assured.get ("AssuredNum") %>">
    </form>

    <jsp:include page="popup.jsp" >
      <jsp:param name="elementId" value="id01" />
    </jsp:include>
 
  </body>
</html>

