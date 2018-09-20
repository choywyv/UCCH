<%@ page import="java.io.*,java.sql.*, java.util.*, java.text.*" %>

<%

  String lastlogin, jsess;
  Cookie[] cookielist;
  Calendar cal;
  boolean cookiefound;

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

    </style>

    <script src="script/script.js"></script>
    <script>

    </script>
  </head>

  <body>
    <div style="width: 80%; margin-left: auto; margin-right: auto; ">

      <div style="position: sticky; top: 0;">
        <ul id="mainul" class="mainnav">
          <li><a href="javascript:void(0);" class="icon" id="menuicon" onclick="mobileNav ();">&#9776;</a></li>
          <li><a class="active" href="#" id="home" onclick="setMenuActive ('mainul', this);">Home</a></li>
          <li><a class="inactive" href="#" id="assured" onclick="menuClicked (this, 'assured.jsp');">Assured</a></li>
          <li><a class="inactive" href="#" id="ship" onclick="menuClicked (this, 'ship.jsp');">Vessel</a></li>

          <li class="hassubs">
            <a class="inactive" href="#" id="quote" onclick="menuClicked (this, 'quote.jsp');">Quote</a>
            <ul class="dropdown">
              <li class="subs"><a class="inactive" href="#" id="CL" onclick="menuClicked (this, 'quote.jsp?QuoteType=CL');">Charterers' Lability</a></li>
              <li class="subs"><a class="inactive" href="#" id="SO" onclick="menuClicked (this, 'quote.jsp?QuoteType=SO');">Shipowners' P&I</a></li>
              <li class="subs"><a class="inactive" href="#" id="IL" onclick="menuClicked (this, 'quote.jsp?QuoteType=IL');">Inland Craft P&I</a></li>
              <li class="subs"><a class="inactive" href="#" id="MM" onclick="menuClicked (this, 'quote.jsp?QuoteType=MM');">MultiModal</a></li>

            </ul>
          </li>


          <li><a class="inactive" href="#" id="claim" onclick="menuClicked (this, 'claim.jsp');">Claims</a></li>

          <li class="hassubs">
            <a class="inactive" href="#" id="report" onclick="menuClicked (this, 'report.jsp');">Reports</a>
            <ul class="dropdown">
              <li class="subs hassubs"><a class="inactive" href="#" id="reportship" onclick="menuClicked (this, 'listing.jsp?ref=report&source=report&report=shiplisting');">All Ships</a>
                <ul class="dropdown">
                  <li class="subs"><a href="#">DeepTest1</a></li>
                </ul>
              </li>
              <li class="subs"><a class="inactive" href="#" id="reportassured" onclick="menuClicked (this, 'listing.jsp?ref=report&source=report&report=assuredlisting');">All Assured</a></li>
              <li class="subs"><a class="inactive" href="#" id="reportquote" onclick="menuClicked (this, 'listing.jsp?ref=report&source=report&report=quotelisting');">All Quotes</a></li>
              <li class="subs"><a class="inactive" href="#" id="reportpolicy" onclick="menuClicked (this, 'listing.jsp?ref=report&source=report&report=policylisting');">All Policies</a></li>
              <li class="subs"><a class="inactive" href="#" id="reportclaim" onclick="menuClicked (this, 'listing.jsp?ref=report&source=report&report=claimlisting');">All Claims</a></li>
              <li class="subs"><a class="inactive" href="#" id="reportvendor" onclick="menuClicked (this, 'listingvendor.jsp?ref=report&source=report&report=vendorlisting');">All Vendors</a></li>
              <li class="subs"><a class="inactive" href="#" id="reportbroker" onclick="menuClicked (this, 'listing.jsp?ref=report&source=report&report=brokerlisting');">All Brokers</a></li>
            </ul>
          </li>

          <li><a class="inactive" href="#" id="searchpage" onclick="menuClicked (this, 'search.jsp');">Search</a></li>


          <% if (request.isUserInRole("tomcat")) { %>
            <li class="hassubs">
              <a class="inactive" href="#" id="admin" onclick="menuClicked (this, 'admin.jsp');">Admin</a>
              <ul class="dropdown">
                <li class="subs"><a class="inactive" href="#" id="adduser" onclick="menuClicked (this, 'adduser.jsp?ref=');">Add User</a></li>
                <li class="subs"><a class="inactive" href="#" id="addvendor" onclick="menuClicked (this, 'addvendor.jsp?ref=');">Add Vendor</a></li>
                <li class="subs"><a class="inactive" href="#" id="addbroker" onclick="menuClicked (this, 'addbroker.jsp?ref=');">Add Broker</a></li>
                <li class="subs"><a class="inactive" href="#" id="adddeduct" onclick="menuClicked (this, 'adddeductible.jsp?ref=');">Add Deductible</a></li>
              </ul>
            </li>
          <% } %>


          <li class="hassubs" style="float: right; margin-top: -0px;"><a href="#" style="display: block;"><%= request.getUserPrincipal ().getName () %></a>
            <ul class="dropdown">
              <li class="subs"><a class="inactive" href="logout.jsp" id="logout">Logout</a></li>
            </ul>
          </li>

          <li style="float: right; padding-top: 10px;">
            <div class="self">
              <form >
                <input type="search" style="all: unset; background-color: white; width: 200px;" placeholder="Search IMO or Ship name" id="globalsearch" results="0">
                <button type="button" style="all: unset; background-color: lightgrey;" onclick="ajax ('shiplisting.jsp?source=global&search=' + document.getElementById ('globalsearch').value, '', 'content')">Search</button>
              </form>
            </div>
          </li>
        </ul>      
      </div>
      <br>
      <div id="content" style="overflow: auto;">

        Welcome <%= request.getUserPrincipal ().getName () %>. Your last login <%= lastlogin %><br>
        
      </div>
    </div>

  </body>
</html>