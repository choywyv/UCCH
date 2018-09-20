<%@include file="/dbhelper.jsp" %>

<%!

  int i, col;
  String s;
  String [] colnames;
  Ship ship;

  private class Ship {

    Map <String, String> ship;

    public Ship (String shipNum) throws Exception {      
      ship = shipNum.equals ("") ? new HashMap <String, String> () : getRecords ("select ShipNum, AssuredNum, ShipName, Flag, IMO, Callsign, GrossTon, NetTon, Width, Length, Height, KeelYear, BuildYear from Ships where ShipNum = '" + shipNum + "'").get (0);
    }

    public String get (String fieldValue) throws Exception {
      return (ship.get (fieldValue) == null) ? "" : ship.get (fieldValue);  
    }

    String create (Map<String, String[]> map) throws Exception {
      return createRecord ("Ships", map, new String [] {"ShipNum"});
    }

    String update (Map<String, String[]> map, String[] additional) throws Exception {
      return updateRecord (getSQLUpdateStmt ("Ships", map, additional));
    }
      
  }  

%>

<%

//  if ((request.getUserPrincipal() == null) || (request.getParameter ("ref") == null)) response.sendRedirect("/test");

  ship = new Ship ((request.getParameter ("ShipNum") == null) ? "" : request.getParameter ("ShipNum"));
  s = "";
  if ((request.getParameter ("create") != null) && ( request.getParameter ("create").equals ("true"))) {
    s = "Ship " + ship.create (request.getParameterMap()) + " created!";    
  }

  if ((request.getParameter ("update") != null) && ( request.getParameter ("update").equals ("true"))) {// out.println (
    ship.update (request.getParameterMap (), new String [] {"ShipNum='" + ship.get ("ShipNum") + "'"});
    s = "Ship " + ship.get ("ShipNum") + " updated!";
  }
  colnames = getColumns ("Ships");

%>

<!DOCTYPE html>
<html>

  <head>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link type="text/css" rel="stylesheet" href="./test/style.css">

    <style>
      <%= (! ship.get ("ShipNum").equals ("")) ? "#form1 { pointer-events: none; }" : "" %>
    </style>

    <script id="sc1">
      getDetails = function (obj, resultDiv) {
        if (obj.id == "AssuredNum") ajax ("minidetails.jsp?table=Assured&AssuredNum=" + obj.value, '', resultDiv);
        else document.getElementById (resultDiv).innerHTML = obj.id;
      }

      validateIMO = function (imo) {
        if (!(/^\d+$/.test(imo))) alert ("Please enter only numeric values for IMO."); 
        if (imo.length != 7) alert ("Please enter only 7 digits for IMO.");
        if (((parseInt (imo [0]) * 7 + parseInt (imo [1]) * 6 + parseInt (imo [2]) * 5 + parseInt (imo [3]) * 4 + parseInt (imo [4]) * 3 + parseInt (imo [5]) * 2) % 10) != parseInt (imo [6])) alert ("The IMO entered is invalid.");
      }   

      fakedata = function () {
        document.getElementById ('ShipName').value="Another Ship";
        document.getElementById ('Flag').value="Malaysia";
        document.getElementById ('IMO').value="12121212";
        document.getElementById ('Callsign').value="AMMMM";
        document.getElementById ('GrossTon').value="100.1";
        document.getElementById ('NetTon').value="99.9";
        document.getElementById ('Width').value="100.2";
        document.getElementById ('Length').value="100.3";
        document.getElementById ('Height').value="100.4";
        document.getElementById ('KeelYear').value="2018-01-01";
        document.getElementById ('BuildYear').value="2018-01-02";
      }

  
    </script>

  </head>

  <body>    
<button type="button" style="background: #aaeeee;" onclick="fakedata ();" >fakedata</button><br>


    <div class="" style="display: flex;">

      <div class="mainbody">

        <span style=" margin-left: 5%; font-weight: bold; font-size: 36px;"><%= ship.get ("ShipNum").equals ("") ? "New " : "" %>Ship details</span><br>
        <span style=" margin-left: 5%; font-size: 12px; ">* required</span><br>
        <%= (! ship.get ("ShipNum").equals ("")) ? "<button type=\"button\" id=\"btn\" onclick=\"formeditable (document.getElementById ('form1'));\">edit</button>" : "" %>

        <form name="form1" id="form1" target="ship.jsp">

          <%
  
            for (i = (request.getParameter ("edit") == null) ? 2 : 1; i < colnames.length; i++) {
              if (isVisible ("Ships", colnames [i])) {

          %>

          <label style="display: inline-block; width: 120px; "><%= getColumnDescription ("Ships", colnames [i]) %></label>   
          <input type="<%= (colnames [i].matches ("KeelYear|BuildYear")) ? "date" : "text" %>" <%= (colnames [i].matches ("Flag|AssuredNum")) ? "list=\"" + colnames [i] + "list\" onchange=\"getDetails (this, 'infodiv');\"" : "" %> name="<%= colnames [i] %>" id="<%= colnames [i] %>" placeholder="<%= getColumnDescription ("Ships", colnames [i]) %> *" onfocus="getDetails (this, 'infodiv');" 
          <%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("")) ? 
                  "value=\"" + (getColTypeName ("Ships", colnames [i]).equals ("datetime2") ? 
                    getFieldValue ("Ships", colnames [i], " where ShipNum = '" + ship.get ("ShipNum") + "'").split (" ") [0] : 
                    getFieldValue ("Ships", colnames [i], " where ShipNum = '" + ship.get ("ShipNum") + "'") ) + "\"" : "" %>
          <%= (request.getParameter ("edit") != null) && (! request.getParameter ("edit").equals ("") && (i == 1)) ? " readonly" : "" %> >                    
          <%= (colnames [i].equals ("AssuredNum")) ? "<button type=\"button\" onclick=\"ajaxPopup ('searchpopup.jsp', document.getElementById ('form2'), 'searchpopup'); \" style=\"width:auto; font-size: 80%;\">Select Assured</button>" : "" %>
          <br>

          <%= colnames [i].equals ("Flag") ? getDatalist ("Countries", colnames [i]) :
              colnames [i].equals ("AssuredNum") ? getDatalist ("Assured", colnames [i]) : "" %>
          <%
          
              }

            }
 
          %>

          <br>

          <input type="hidden" name="<%= ship.get ("ShipNum").equals ("") ? "create" : "update" %>" id="<%= ship.get ("ShipNum").equals ("") ? "create" : "update" %>" value="true">
          <button type="button" style="background: #aaeeee; " onclick="ajax ('ship.jsp', this.form, 'content');"><%= ship.get ("ShipNum").equals ("") ? "Create" : "Save" %></button>
          <button type="button" style="background: #aaeeee; " onclick="validateIMO (document.getElementById ('IMO').value);">checkimo</button>

        </form>
  
      </div>

      <div id="infodiv" style="border-style: dotted; left: 74%; width: 15%; position: fixed; ">
        <%= s %>
      </div>

    </div>
 
    <form name="form2" id="form2">
      <input type="hidden" name="elementId" value="id01" />
      <input type="hidden" name="source" value="ship" />
      <input type="hidden" name="report" value="assuredlisting" />
      <input type="hidden" name="callerElement" value="AssuredNum" />
      <input type="hidden" name="callerElementId" value="AssuredNum" />
      <input type="hidden" name="title" value="Assured" />
    </form>

    <div id="searchpopup"></div>

  </body>
</html>

