<%@ page import="java.sql.*" %>

<%!

  Connection conn;
  PreparedStatement pstmt;
  ResultSet rs;
  ResultSetMetaData rsmd;
  int i;
  String field, table;

%>



<%

  table = request.getParameter ("table");    

  if (! table.equals ("")) {
    field = table.equals ("Ships") ? "ShipNum" : 
            table.equals ("Assured") ? "AssuredNum" :
            table.equals ("QuoteHeader") ? "QuoteNum" :
            table.equals ("Incidents") ? "IncidentNum" : 
            table.equals ("PolicyHeader") ? "PolicyNum" : 
            table.equals ("Claims") ? "ClaimNum" :
            table.equals ("Broker") ? "BrokerNum" : 
            table.equals ("Estimate") ? "EstimateNum" : "";

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");

    pstmt = conn.prepareStatement ("select * from " + table + " where " + field + " = '" + request.getParameter (field) + "'");
    rs = pstmt.executeQuery ();
    rsmd = rs.getMetaData ();

    for (; rs.next ();) for (i = 1; i <= rsmd.getColumnCount (); i++) {

%>

  <input type="text" style="all: unset; margin-left: 2%; font-size: 10px; border: solid 1px; width: 30%; overflow: hidden;" value="<%= rsmd.getColumnName (i) %>" readonly>
  <input type="text" style="all: unset; font-size: 10px; border: solid 1px; width: 60%; overflow: hidden;" value="<%= rs.getString (i) %>" readonly>  
  <br>

<%

    }
  conn.close ();
  }

%>
