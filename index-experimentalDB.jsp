<%@ page import="java.io.*, java.sql.*, java.util.*, java.text.*" %>

<%!

  String lastlogin, jsess;
  Cookie[] cookielist;
  Calendar cal;
  boolean cookiefound;


  boolean menuHasChild (Connection conn, String level, String position) throws Exception {

    return conn.prepareStatement ("select top (1)* from Navigation where ParentLevel = " + level + " and ParentPosition = " + position).executeQuery ().next ();

  }




  String generateMenu (String s, String level, String position) throws Exception {
    int i, colcount;
    ResultSet rs;
    Connection conn;
    String sql;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    sql = "select MenuLevel, ParentLevel, ParentPosition, OwnLevel, OwnPosition, Description, URL from Navigation where ParentLevel = " + level;
    if (!position.equals ("")) sql += " and ParentPosition = " + position; 
    rs = conn.prepareStatement (sql).executeQuery ();
    colcount = rs.getMetaData ().getColumnCount ();

    for (; rs.next (); ) {
      s += "<div class=\"dropdown\"><button class=\"dropbtn\" id=\"" + rs.getString ("Description") + "\" onclick=\"" + rs.getString ("URL") + "\">" + rs.getString ("Description") + "</button>";
      s += "<div class=\"dropdown-content\">\n";

      if (menuHasChild (conn, rs.getString ("OwnLevel"), rs.getString ("OwnPosition"))) s += generateMenu ("", rs.getString ("OwnLevel"), rs.getString ("OwnPosition")) ;
      s+= "</div></div>\n";

    }

/*
      rs2 = conn.prepareStatement ("select * from Navigation where ParentLevel = '" + rs1.getString ("OwnLevel") + "' and ParentPosition = '" + rs1.getString ("OwnPosition") + "'").executeQuery ();
      colcount = rs2.getMetaData ().getColumnCount ();
      for (; rs2.next ();) {
        for (j = 1; j <= colcount; j++)         out.println (rs2.getString (j) + "|");
*/

    conn.close ();
    return s;

  } 

%>

<%

  cookiefound = false;
  lastlogin = "never";
  jsess = "";
  cookielist = request.getCookies();
  cal = Calendar.getInstance();
  cal.setTimeInMillis (Calendar.getInstance().getTimeInMillis ());

  
  if (cookielist != null) for (Cookie cookie : cookielist) { 
    if (cookie.getName ().equals ("lastlogin")) {
      cal.setTimeInMillis (Long.parseLong (cookie.getValue ()));
      lastlogin = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format (cal.getTime());
      cookiefound = true;
    }
    if (cookie.getName ().equals ("JSESSIONID")) jsess = cookie.getValue ();   
  } 

  if ((!cookiefound) || (!session.getId().equals (jsess))) response.addCookie (new Cookie ("lastlogin", String.valueOf (Calendar.getInstance().getTimeInMillis ())));
  
  cookielist = request.getCookies ();
  if (cookielist != null) for (Cookie cookie : cookielist) {
    if (cookie.getName ().equals ("timeout")) {
      cookie.setValue ("0");
      cookie.setMaxAge (0);
      response.addCookie (cookie);
    }  
  }
  //request.getSession().setMaxInactiveInterval(600);

%>

<!DOCTYPE html>

<html>

  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link type="text/css" rel="stylesheet" href="css/style.css">

    <style>
      html, body { font-family: 'Arial'; }
      table { border: 1px solid black; border-collapse: collapse; }

      .topnav { overflow: hidden; background-color: #333; }
      .topnav a { float: left; display: block; color: #f2f2f2; text-align: center; padding: 12px 12px; text-decoration: none; font-size: 14px; }
      .active { background-color: #4CAF50; color: white; }
      .activebtn { background-color: red; width: auto; font-size: 14px; border: none; outline: none; color: white; padding: 12px 12px; margin: 0; }
      .topnav .icon { display: none; }
      .dropdown { float: left; overflow: hidden; }
      .dropdown .dropbtn { width: auto; font-size: 14px; border: none; outline: none; color: white; padding: 12px 12px; background-color: inherit; font-family: inherit; margin: 0; }
      .dropdown-content { display: none; position: absolute; background-color: #f9f9f9; min-width: 160px; box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2); z-index: 1; }
      .dropdown-content a { float: none; color: black; padding: 12px 16px; text-decoration: none; display: block; text-align: left; }
      .topnav a:hover, .dropdown:hover .dropbtn {  background-color: grey; color: white; }
      .dropdown-content a:hover { background-color: #ddd; color: black; }
      .dropdown:hover .dropdown-content { display: block; }

      @media screen and (max-width: 600px) {
        .topnav a:not(:first-child), .dropdown .dropbtn { display: none; }
        .topnav a.icon { float: right; display: block; }
      }

      @media screen and (max-width: 600px) {
        .topnav.responsive {position: relative;}
        .topnav.responsive .icon { position: absolute; left: 0; top: 0; }
        .topnav.responsive a { float: none; display: block; text-align: left; }
        .topnav.responsive .dropdown {float: none;}
        .topnav.responsive .dropdown-content {position: relative;}
        .topnav.responsive .dropdown .dropbtn { display: block; width: 100%; text-align: left; }
      }

    </style>

    <script>

      setMenuActive = function (ulobj, obj) { 

        for (var i = 0; i < document.getElementById (ulobj).getElementsByTagName ("button").length; i++) {
          if (document.getElementById (ulobj).getElementsByTagName ("button")[i].id != "globalsearchbtn") 
            document.getElementById (ulobj).getElementsByTagName ("button")[i].className = 
              (document.getElementById (ulobj).getElementsByTagName ("button")[i].id == obj.id) ? "activebtn" : "dropbtn";  
        }

        if (window.matchMedia("(max-width: 600px)").matches) mobileNav ();
      } // setMenuActive


      setDivActive = function (tagclass, divid) {

        for (var i = 0; i < document.getElementsByClassName (tagclass).length; i++) 
          document.getElementById (document.getElementsByClassName (tagclass)[i].id).style.display = 
            (document.getElementsByClassName (tagclass)[i].id == divid) ? "block" : "none"; 
 
      } // setDivActive

 
      ajax = function (loadpage, f, target) {
        
        var xhttp = new XMLHttpRequest ();
        xhttp.onreadystatechange = function () {
          if ((this.readyState == 4 && this.status == 200) || (this.status == 404)) { 

            var elems = document.querySelectorAll ("script");
            for (var i = 0; i < elems.length; i++) eval (elems[i].innerHTML);

            document.getElementById (target).innerHTML = this.responseText;
          }
          else document.getElementById (target).innerHTML = "Loading...Please wait..."; 
        };
        xhttp.open ("POST", loadpage, true); 
        xhttp.setRequestHeader ("Content-type", "application/x-www-form-urlencoded"); 
        xhttp.send ((f != "") ? getParams (f) : "");
      } // ajax


      ajaxPopup = function (loadpage, f, target) {
        
        var xhttp = new XMLHttpRequest ();
        xhttp.onreadystatechange = function () {
          //if ((this.readyState == 4 && this.status == 200) || (this.status == 404)) { 

            var elems = document.querySelectorAll ("script");
            for (var i = 0; i < elems.length; i++) eval (elems[i].innerHTML);

            document.getElementById (target).innerHTML = this.responseText;
            document.getElementById ('id01').style.display = 'block';
          //}
        };
        xhttp.open ("POST", loadpage, true); 
        xhttp.setRequestHeader ("Content-type", "application/x-www-form-urlencoded"); 
        xhttp.send ((f != "") ? getParams (f) : "");
      } // ajax


      getParams = function (f) {
        var kvpairs = [], i;
 
        for (i = 0; i < f.elements.length; i++ ) kvpairs.push (encodeURIComponent (f.elements [i].name) + "=" + encodeURIComponent (f.elements [i].value));
       
        return kvpairs.join ("&");
      } // getParams

      mobileNav = function () {
        var elems = document.querySelectorAll("a");

        for (var i = 0; i < elems.length; i++) {
          if (elems[i].className == "icon")  elems[i].style.display = "block";
          else if (elems[i].className == "active") elems[i].style.display = "block";
          else elems[i].style.display = (elems[i].style.display == "block") ? "none" : "block";
          //if (elems[i].className == "active") elems[i].style.display == "block";
        }


//    if (document.getElementById("myTopnav").className === "topnav") document.getElementById("myTopnav").className += " responsive";
//    else document.getElementById("myTopnav").className = "topnav";
    
  
      }

      formeditable = function (f) {
        f.style.pointerEvents = ((f.style.pointerEvents == "") || (f.style.pointerEvents == "none")) ? "auto" : "none";
      } // formeditable
    </script>
  </head>

  <body>

    <div style="width: 80%; margin-left: auto; margin-right: auto; ">

      <div style="position: sticky; top: 0;">
 
        <div class="topnav" id="mainnav">

          <a href="javascript:void(0);" class="icon" id="menuicon" onclick="mobileNav ();">&#9776;</a>


          <%= generateMenu ("", "0", "") %>

 













<%

/*




          <div class="dropdown">
            <button class="activebtn" id="home" onclick="setMenuActive ('mainnav', this);">Home</button>
            <div class="dropdown-content">
            </div>
          </div>

          <div class="dropdown">
            <button class="dropbtn" id="owner" onclick="setMenuActive ('mainnav', this); ajax ('owner.jsp?ref=', '', 'content');">Owner</button>
            <div class="dropdown-content">
            </div>
          </div>

          <div class="dropdown">
            <button class="dropbtn" id="ship" onclick="setMenuActive ('mainnav', this); ajax ('ship.jsp?ref=', '', 'content');">Ship</button>
            <div class="dropdown-content">
            </div>
          </div>

          <div class="dropdown">
            <button class="dropbtn" id="quote" onclick="setMenuActive ('mainnav', this); ajax ('quote.jsp?ref=', '', 'content');">Quote</button>
            <div class="dropdown-content">
            </div>
          </div>

          <div class="dropdown">
            <button class="dropbtn" id="policy" onclick="setMenuActive ('mainnav', this); ajax ('policy.jsp?ref=', '', 'content');">Policy</button>
            <div class="dropdown-content">
            </div>
          </div>

          <div class="dropdown">
            <button class="dropbtn" id="claim" onclick="setMenuActive ('mainnav', this); ajax ('incident.jsp?ref=', '', 'content');">Incident</button>
            <div class="dropdown-content">
              <a href="#">Link 0</a>
            </div>
          </div>

          <div class="dropdown">
            <button class="dropbtn" id="report" onclick="setMenuActive ('mainnav', this); ajax ('report.jsp?ref=', '', 'content');">Reports</button>
            <div class="dropdown-content">
              <a href="#">Link 1</a>
              <a href="#">Link 2</a>
              <a href="#">Link 3</a>
            </div>
          </div>

          <div class="dropdown">
            <button class="dropbtn" id="searchpage" onclick="setMenuActive ('mainnav', this); ajax ('search.jsp?ref=', '', 'content');">Search</button>
            <div class="dropdown-content">
            </div>
          </div>
        
          <div class="dropdown">
            <button class="dropbtn" id="admin" onclick="setMenuActive ('mainnav', this); ajax ('admin.jsp?ref=', '', 'content');">Admin</button>
            <div class="dropdown-content">
            </div>
          </div>




*/
%>























        
          <div class="dropdown" style="float: right;">
            <button class="dropbtn" id="logout" ><%= request.getUserPrincipal ().getName () %></button>        
            <div class="dropdown-content">
              <a href="logout.jsp">Logout</a>
            </div>
          </div>

          <div class="dropdown" style="float: right; margin-top: 10px;">
            <form >
              <input type="search" style="all: unset; background-color: white; width: 200px;" placeholder="Search IMO or Ship name" id="globalsearch" results="0">
              <button type="button" id="globalsearchbtn" style="all: unset; background-color: lightgrey;" onclick="ajax ('shiplisting.jsp?source=global&search=' + document.getElementById ('globalsearch').value, '', 'content')">Search</button>
            </form>
          </div>

        </div>

      </div>

      <br>
      <div id="content" style="overflow: auto;">

        Welcome <%= request.getUserPrincipal ().getName () %>. Your last login <%= lastlogin %><br>
        
      </div>

    </div>
  </body>
</html>