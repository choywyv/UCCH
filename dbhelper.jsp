<%@page import = "java.sql.*, java.util.*, java.text.*" %>

<%!

  boolean isVisible (String table, String field) throws Exception {

    return getFieldValue ("FieldManagement", "Visible", " where DBTable = '" + table + "' and DBField = '" + field + "'" ).equals ("") ? true :
      Boolean.valueOf (getFieldValue ("FieldManagement", "Visible", " where DBTable = '" + table + "' and DBField = '" + field + "'" ));

  } // isVisible

  boolean fieldExists (String table, String field) throws Exception {

    DatabaseMetaData md;
    ResultSet rs;
    boolean fieldexists;
    Connection conn;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    md = conn.getMetaData ();
    rs = md.getColumns (null, null, table, field);

    fieldexists = rs.next ();
    conn.close ();

    return fieldexists;

  } // fieldExists


  boolean recordExists (String sql) throws Exception {

    Connection conn;
    ResultSet rs;
    boolean exists;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    rs = conn.prepareStatement (sql).executeQuery ();
    exists = rs.next ();
    
    conn.close ();
    return exists;

  } // recordExists


  String getSQLInsertStmt (String table, Map<String, String []> map) throws Exception {

    Map<String, String []> map1;    
    String [] arr;
    String s1, s2;
    int i;
    boolean fElement;

    map1 = new HashMap<String, String[]>(map);
    arr = map1.keySet ().toArray (new String [0]);
    s1 = "insert into " + table + " (";
    s2 = ") values (";

    fElement = false;
    for (i = 0; i < arr.length; i++) {

      if (! map1.get (arr [i]) [0].equals ("") && fieldExists (table, arr [i])) {

        if ((i > 0) && fElement) {
          s1 += ", ";
          s2 += ", ";
        }

        s1 += arr [i];
        s2 += "'" + map1.get (arr [i]) [0].replaceAll ("'", "''") + "'";        // function to replace single quote to double-single quote (escape char)
        fElement = true; 
      }
     
    }

    return s1 + s2 + ")";

  } // getSQLInsertStmt


  String getSQLUpdateStmt (String table, Map<String, String []> map, String [] condition) throws Exception {

    Map<String, String []> map1;    
    String s1, s2;
    String [] arr;
    int i;
    boolean fElement;

    map1 = new HashMap<String, String[]> (map);
    arr = map1.keySet ().toArray (new String [0]);
    s1 = "update " + table + " set ";
    s2 = " where ";     
  
    for (i = 0; i < condition.length; i++) {
      if (i > 0) s2 += " and ";
      s2 += condition [i] ;
      map1.remove (condition [i].split ("=")[0]);        
    }

    arr = map1.keySet ().toArray (new String [0]);  

    fElement = false;
    for (i = 0; i < arr.length; i++) {
      if (! map1.get (arr [i]) [0].equals ("") && fieldExists (table, arr [i])) {
        if ((i > 0)  && fElement) s1 += ", ";
        s1 += arr [i] + " = '" + map1.get (arr [i]) [0].replaceAll ("'", "''") + "'" ;
        fElement = true; 
      }
    }    
    return s1 + s2;

  } // getSQLUpdateStmt


  Map<String, String[]> updateMap (String table, Map<String, String[]> map, String [] additional) throws Exception {

    Map<String, String[]> map1;
    int i;
 
    map1 = new HashMap<String, String[]> (map);
    for (i = 0; i < additional.length; i++) map1.put (additional [i], new String  [] {getLastNum (table, additional [i], "")});
    return map1;

  } // updateMap


  String createRecord (String table, Map<String, String[]> map, String [] additional) throws Exception {

    Connection conn;
    String sql;
    Map<String, String[]> map1;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");

    map1 = updateMap (table, map, additional);   
    sql = getSQLInsertStmt (table, map1);
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    conn.prepareStatement (sql).executeUpdate ();

    conn.close ();

    return (additional.length > 0) ? map1.get (additional [0]) [0] : "";

  } // createRecord


  String updateRecord (String sql) throws Exception {

    Connection conn;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");

    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    conn.prepareStatement (sql).executeUpdate ();

    conn.close ();

    return "";

  } // updateRecord


  String deleteRecord () throws Exception {
    return "";
  } // deleteRecord

  String getPreviousRecord (String table, String keyField, String value) throws Exception {

    Connection conn;
    ResultSet rs;
    String s;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");

    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    rs = conn.prepareStatement ("select top 1 " + keyField + " from " + table + " where " + keyField + " < '" + value + "' order by " + keyField + " desc").executeQuery ();
    s = rs.next () ? rs.getString (1) : "";
    conn.close ();

    return s;

  } // getPreviousRecord


  String getNextRecord (String table, String keyField, String value) throws Exception {

    Connection conn;
    ResultSet rs;
    String s;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");

    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    rs = conn.prepareStatement ("select top 1 " + keyField + " from " + table + " where " + keyField + " > '" + value + "' order by " + keyField).executeQuery ();
    s = rs.next () ? rs.getString (1) : "";
    conn.close ();

    return s;

  } // getNextRecord


  ArrayList <Map<String, String>> getRecords (String sql) throws Exception {

    Connection conn;
    PreparedStatement pstmt;
    ResultSet rs;
    ResultSetMetaData rsmd;
    int i;
    ArrayList<Map<String, String>> list;
    Map<String, String> map;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    rs = conn.prepareStatement (sql).executeQuery ();
    rsmd = rs.getMetaData ();    

    for (list = new ArrayList <Map<String, String>> (); rs.next (); ) {
      map = new LinkedHashMap<String, String> (); 
      for (i = 1; i <= rsmd.getColumnCount (); i++) map.put (rsmd.getColumnName (i), rs.getString (i));

      list.add (map);
    }
    
    conn.close ();

    return list;

  } // getRecords

  
  String getLastNum (String table, String field, String condition) throws Exception {

    String s; s = field;

    ResultSet rs;
    int i;
    Connection conn;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");

    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");

    rs = conn.prepareStatement ("select max (" + field + ") from " + table + " " + condition).executeQuery ();

    if (rs.next () && (rs.getString (1) != null)) {
      s = rs.getString (1).split ("-")[0] + "-";
      i = Integer.parseInt (rs.getString (1).split ("-")[1]) + 1;
      for (; s.length () < rs.getString (1).length () - String.valueOf (i).length (); ) s += "0";
      s += i;
    }   
    else {
      rs = conn.prepareStatement ("select DocNum from DocNumManagement where DocType = '" + field + "'").executeQuery ();
      s = rs.next () ? rs.getString (1) : "";
    }

    conn.close ();

//    i = Integer.parseInt (s.substring (4, s.length ())) + 1;
//    return s.substring(0, 4) + ((String.valueOf (i).length () == 1) ? "000" + i :
//                                (String.valueOf (i).length () == 2) ? "00" + i : 
//                                (String.valueOf (i).length () == 3) ? "0" + i : i);

    return s;    
  } // getLastNum


  String quoteToPolicy (String quoteNum) throws Exception {

    Connection conn;
    PreparedStatement pstmt;
    String policyNum;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    policyNum = getLastNum ("PolicyHeader", "PolicyNum", "");
    pstmt = conn.prepareStatement ("INSERT INTO PolicyHeader (PolicyNum, PolicyDate, QuoteNum, EffectiveDate, ExpiryDate, Currency, Premium, TradingArea, Conditions, LimitLiability, ExpressWarranties, SanctionClause, ApplicableClause, SurveyWarranty, DefectWarranty, Comments) " + 
                                 " SELECT '" + policyNum + "' as PolicyNum, '" + new java.sql.Date(Calendar.getInstance().getTime().getTime()) + "' as PolicyDate, QuoteNum, EffectiveDate, ExpiryDate, Currency, Premium, TradingArea, Conditions, LimitLiability, ExpressWarranties, SanctionClause, ApplicableClause, SurveyWarranty, DefectWarranty, Comments FROM QuoteHeader WHERE QuoteNum = ?");
    pstmt.setString (1, quoteNum);
    pstmt.executeUpdate ();

    pstmt = conn.prepareStatement ("INSERT INTO PolicyLine (PolicyNum, DeductNum, Amt) " + 
                                 " SELECT '" + policyNum + "' as PolicyNum, DeductNum, Amt FROM QuoteDeductible WHERE QuoteNum = ?");
    pstmt.setString (1, quoteNum);
    pstmt.executeUpdate ();

    pstmt = conn.prepareStatement ("INSERT INTO PolicyVessel (PolicyNum, ShipNum, Type) " + 
                                 " SELECT '" + policyNum + "' as PolicyNum, '" + " ShipNum, Type FROM QuoteVessel WHERE QuoteNum = ?");
    pstmt.setString (1, quoteNum);
    pstmt.executeUpdate ();

    pstmt = conn.prepareStatement ("INSERT INTO PolicyAssured (PolicyNum, AssuredNum, Type) " + 
                                 " SELECT '" + policyNum + "' as PolicyNum, '" + " AssuredNum, Type FROM QuoteAssured WHERE QuoteNum = ?");
    pstmt.setString (1, quoteNum);
    pstmt.executeUpdate ();

    pstmt = conn.prepareStatement ("update QuoteHeader set Status = 'Converted to Policy' where QuoteNum = ?");
    pstmt.setString (1, quoteNum);
    pstmt.executeUpdate ();

    pstmt.close ();
    conn.close ();

    return policyNum;

  } // quoteToPolicy


/*

  String createIncident (String policyNum, String incidentDate, String status, String description, String location, String paidAmt, String outstandingAmt, String totalIncurredAmt, String remarks, String correspondent) throws Exception {

    Connection conn;
    PreparedStatement pstmt;
    String incidentNum;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    incidentNum = getLastNum ("Incidents", "IncidentNum", "");
    pstmt = conn.prepareStatement ("insert into Incidents (IncidentNum, PolicyNum, IncidentDate, Status, Description, Location, PaidAmt, OutstandingAmt, TotalIncurredAmt, Remarks, Correspondent) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    pstmt.setString (1, incidentNum);
    pstmt.setString (2, policyNum);
    pstmt.setTimestamp (3, new java.sql.Timestamp (new SimpleDateFormat("yyyy-MM-dd").parse (incidentDate).getTime ()) );
    pstmt.setString (4, status);
    pstmt.setString (5, description);
    pstmt.setString (6, location);
    pstmt.setDouble (7, Double.parseDouble (paidAmt));
    pstmt.setDouble (8, Double.parseDouble (outstandingAmt));
    pstmt.setDouble (9, Double.parseDouble (totalIncurredAmt));
    pstmt.setString (10, remarks);
    pstmt.setString (11, correspondent);
    pstmt.executeUpdate ();

    pstmt.close ();
    conn.close ();

    return incidentNum + " created successfully!";

  } // createIncident


  String updateIncident (String incidentNum, String incidentDate, String status, String description, String location, String paidAmt, String outstandingAmt, String totalIncurredAmt, String remarks, String correspondent) throws Exception {

    Connection conn;
    PreparedStatement pstmt;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    pstmt = conn.prepareStatement ("update Incidents set IncidentDate = ?, Status = ?, Description = ?, Location = ?, PaidAmt = ?, OutstandingAmt = ?, TotalIncurredAmt = ?, Remarks = ? where IncidentNum = ?)");
    pstmt.setTimestamp (1, new java.sql.Timestamp (new SimpleDateFormat("yyyy-MM-dd").parse (incidentDate).getTime ()) );
    pstmt.setString (2, status);
    pstmt.setString (3, description);
    pstmt.setString (4, location);
    pstmt.setDouble (5, Double.parseDouble (paidAmt));
    pstmt.setDouble (6, Double.parseDouble (outstandingAmt));
    pstmt.setDouble (7, Double.parseDouble (totalIncurredAmt));
    pstmt.setString (8, remarks);
    pstmt.setString (9, correspondent);
    pstmt.setString (10, incidentNum);
    pstmt.executeUpdate ();

    pstmt.close ();
    conn.close ();

    return incidentNum + " updated successfully!";

  } // updateIncident


  String createClaim (String incidentNum, String claimDate, String type, String claimParty, String currency, String estimatedAmt, String paidAmt, String remarks, String status) throws Exception {

    Connection conn;
    PreparedStatement pstmt;
    String claimNum; 

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    claimNum = getLastNum ("Claims", "IncidentNum", "");
    pstmt = conn.prepareStatement ("insert into Claims (IncidentNum, ClaimNum, ClaimDate, Type, ClaimParty, Currency, EstimatedAmt, PaidAmt, Remarks, Status) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    pstmt.setString (1, incidentNum);
    pstmt.setString (2, claimNum);
    pstmt.setTimestamp (3, new java.sql.Timestamp (new SimpleDateFormat("yyyy-MM-dd").parse (claimDate).getTime ()) );
    pstmt.setString (4, type);
    pstmt.setString (5, claimParty);
    pstmt.setString (6, currency);
    pstmt.setDouble (7, Double.parseDouble (estimatedAmt));
    pstmt.setDouble (8, Double.parseDouble (paidAmt));
    pstmt.setString (9, remarks);
    pstmt.setString (10, status);
    pstmt.executeUpdate ();

    pstmt.close ();
    conn.close ();

    return "New claim for " + incidentNum + " created successfully!";

  } // createClaim


  String updateClaim (String incidentNum, String claimNum, String claimDate, String type, String claimParty, String currency, String estimatedAmt, String paidAmt, String remarks, String status) throws Exception {

    Connection conn;
    PreparedStatement pstmt;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    pstmt = conn.prepareStatement ("update Claims set claimDate = ?, Type = ?, claimParty = ?, Currency = ?, EstimatedAmt = ?, PaidAmt = ?, Remarks = ?, Status = ? where IncidentNum = ? and ClaimNum = ?)");
    pstmt.setTimestamp (1, new java.sql.Timestamp (new SimpleDateFormat("yyyy-MM-dd").parse (claimDate).getTime ()) );
    pstmt.setString (2, type);
    pstmt.setString (3, claimParty);
    pstmt.setString (4, currency);
    pstmt.setDouble (5, Double.parseDouble (estimatedAmt));
    pstmt.setDouble (6, Double.parseDouble (paidAmt));
    pstmt.setString (7, remarks);
    pstmt.setString (8, status);
    pstmt.setString (9, incidentNum);
    pstmt.setString (10, claimNum);
    pstmt.executeUpdate ();

    pstmt.close ();
    conn.close ();

    return incidentNum + " " + claimNum + " updated successfully!";

  } // updateClaim


  String updateTimesheet (String incidentNum, String entryNum, String entryDate, String description, String hours, String amt) throws Exception {

    Connection conn;
    PreparedStatement pstmt;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    pstmt = conn.prepareStatement ("update Timesheet set EntryDate = ?, Description = ?, Hours = ?, Amt = ? where IncidentNum = ? and EntryNum = ?)");
    pstmt.setTimestamp (1, new java.sql.Timestamp (new SimpleDateFormat("yyyy-MM-dd").parse (entryDate).getTime ()) );
    pstmt.setString (2, description);
    pstmt.setDouble (3, Double.parseDouble (hours));
    pstmt.setDouble (4, Double.parseDouble (amt));
    pstmt.setString (5, incidentNum);
    pstmt.setString (6, entryNum);
    pstmt.executeUpdate ();

    pstmt.close ();
    conn.close ();

    return "";

  } // updateTimesheet

*/

  String [] getColumns (String table) throws Exception {

    Connection conn;
    ResultSet rs;
    ResultSetMetaData rsmd;
    String [] arr;
    int i;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    rs = conn.prepareStatement ("select top 1 * from " + table).executeQuery ();
    rsmd = rs.getMetaData ();
    arr = new String [rsmd.getColumnCount () + 1];
    for (i = 1; i <= rsmd.getColumnCount (); i++) arr [i] = rsmd.getColumnName (i);    
    conn.close ();

    return arr;

  } // getColumns


  String getColumnDescription (String table, String column) throws Exception {

    Connection conn;
    ResultSet rs;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    rs = conn.prepareStatement ("SELECT sc.name AS ColumnName, ep.value FROM sys.columns AS sc " +
                                "INNER JOIN sys.extended_properties AS ep ON ep.major_id = sc.[object_id] AND ep.minor_id = sc.column_id " +
                                "WHERE sc.[object_id] = OBJECT_ID('" + table + "') AND ep.name = 'MS_Description' AND sc.name = '" + column + "'").executeQuery ();

    column = rs.next () ? rs.getString (2) : column;
    conn.close ();
    return column;

  } // getColumnDescription


  String getDatalist (String table, String field, String listName) throws Exception {

    String s;
    Connection conn;
    ResultSet rs;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    rs = conn.prepareStatement ("SELECT " + field + " from " + table).executeQuery ();
    for (s = "<datalist id=\"" + listName + "\">"; rs.next (); s += "<option value=\"" + rs.getString (1) + "\">\n");    

    s += "</datalist>";

    conn.close ();
    return s;

  } // getDatalist


  String getDatalist (String table, String field, boolean distinctVal) throws Exception {

    String s;
    Connection conn;
    ResultSet rs;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    rs = conn.prepareStatement ("SELECT distinct " + field + " from " + table).executeQuery ();
    for (s = "<datalist id=\"" + field + "list\">\n"; rs.next (); s += "<option value=\"" + rs.getString (1) + "\">\n");    

    s += "</datalist>";

    conn.close ();
    return s;

  } // getDatalist


  String getFieldValue (String table, String fieldToFind, String condition) throws Exception {

    Connection conn;
    ResultSet rs;
    String s;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    rs = conn.prepareStatement ("SELECT " + fieldToFind + " from " + table + condition).executeQuery ();
    
    s = rs.next () ? (rs.getString (1) == null) ? "" : rs.getString (1) : "";

    conn.close ();
    return s;

  } // getFieldValue


  String getColTypeName (String table, String col) throws Exception {

    String s;
    Connection conn;
    ResultSet rs;
    ResultSetMetaData rsmd;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
//    rs = conn.prepareStatement ("SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '" + table + "' AND COLUMN_NAME = '" + col + "'").executeQuery ();
//    s = rs.next () ? rs.getString (1) : "";
    rs = conn.prepareStatement ("SELECT top 1 (" + col + ") from " + table).executeQuery ();
    s = rs.getMetaData ().getColumnTypeName (1);
    conn.close ();
    return s;

  } // getColTypeName


  String getColTypeSize (String table, String col) throws Exception {

    String s;
    Connection conn;
    ResultSet rs;
    ResultSetMetaData rsmd;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    rs = conn.prepareStatement ("SELECT top 1 (" + col + ") from " + table).executeQuery ();
    s = String.valueOf (rs.getMetaData ().getColumnDisplaySize (1));
    conn.close ();
    return s;

  } // getColTypeSize


  Map <String, String> getColTypeNameTempTable (String sql, String temptable) throws Exception {

    Connection conn;
    ResultSet rs;
    int i;
    Map <String, String> map;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    map = new HashMap <String, String> ();
    rs = conn.prepareStatement (sql + 
    "SELECT cols.name, ty.name FROM tempdb.sys.columns cols join sys.types ty on cols.system_type_id = ty.system_type_id WHERE object_id = Object_id('tempdb.." + temptable + "');").executeQuery ();
    for (; rs.next (); ) map.put (rs.getString (1), rs.getString (2));
    conn.close ();
    return map;

  } // getColTypeNameTempTable


  void dropTempTable (String temptable) throws Exception {

    Connection conn;

    Class.forName ("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;database=EFMarine;user=sa;password=p@ssw0rd");
    conn.prepareStatement ("IF OBJECT_ID ('tempdb.." + temptable + "') IS NOT NULL DROP TABLE " + temptable).executeUpdate ();
    conn.close ();

  } // dropTempTable

%>


