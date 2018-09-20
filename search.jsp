<%@ page import="java.sql.*" %>

<%!

  Connection conn;
  PreparedStatement pstmt;
  ResultSet rs;
  ResultSetMetaData rsmd;
  int i;
  String s;

%>

<%

  s = "select ShipNum, IMO, ShipName, Flag from Ships ";
  Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
  conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
  pstmt = conn.prepareStatement (s);
/*
  rs = pstmt.executeQuery ();
  rsmd = rs.getMetaData (); 
*/

%>

<!DOCTYPE html>

<html>

  <head>
    <style>
      .mainbody { width: 80%; border-style: dotted; border-radius: 5px;  background: #dddddd; }

      input, button { font-size: 20px; margin-bottom: 10px; border-radius: 5px; width: 200px; margin-left: 5%; }
      input:read-only { background-color: yellow; }
      input:-moz-read-only { background-color: yellow; }
      span { font-size: 20px; margin-bottom: 10px; } 
      label, select { font-size: 20px; margin-bottom: 10px; border-radius: 5px; margin-left: 5%; }
      

      @media print{
        body { background-color:#FFFFFF; background-image:none; color:#000000 }
        #ad { display:none;}
        #leftbar { display:none;}
        #contentarea { width:100%;}
      }

      
    </style>
  </head>

  <body>

    <div class="" style="display: flex;">

      <div class="mainbody">
        <form name="form1">
          <label for="">Search for</label>
          <select name="" id="" style="width: 250px;" onchange="document.getElementById ('search').placeholder='Search Ship Name'; document.form1.action=this.value; document.form1.source.value='search'; document.form1.report.value='speciallisting'">
            <option value="" selected>Select search type</option>
            <option value="listing.jsp">Claims by Ship Name</option>
            <option value="a">Ship Owner</option>
            <option value="b"></option>
          </select>
          <br>
          <input type="text" name="search" id="search" ><br>
          <input type="hidden" name="source" id="source">
          <input type="hidden" name="report" id="report">
          <button type="button" onclick="ajax (this.form.action, this.form, 'results');">Search</button>
        </form>
      </div>

    </div>
    <br>
    <div id="results" style="width: auto;"></div>

  </body>

</html>

<%

  pstmt.close ();
  conn.close ();

%>