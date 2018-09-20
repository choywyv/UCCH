<%@ page import="java.sql.*" %>

<%!

  Connection conn;
  PreparedStatement pstmt;
  ParameterMetaData pmd;
  ResultSet rs;
  int i;

%>

<%

  Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
  conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
  pstmt = conn.prepareStatement ("select * from Ships where ShipNum = ?");
  pstmt.setString (1, "shp-1009");
  pmd = pstmt.getParameterMetaData();
  rs = pstmt.executeQuery ();
  
//  for (i = 0; i < pmd.getParameterCount(); i++) 
out.println (pstmt.toString ());
  conn.close ();

%>
