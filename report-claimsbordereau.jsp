<%@ page import = "org.apache.poi.xssf.usermodel.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.hssf.util.*, 
                 java.util.Map, java.util.HashMap, java.util.Calendar, java.io.*, java.text.SimpleDateFormat"
%>

<%@include file="/dbhelper.jsp" %>

<%!

  Workbook workbook;
  Sheet sheet;
  Row row;
  Cell cell;
  CellStyle style;
  Font font;
  int i, rowCount, colCount;
  String sql;

%>

<%

  response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
  response.setHeader("Content-Disposition", "attachment; filename=temp.xlsx");

  sql = "SELECT YEAR(Incidents.IncidentDate) AS Year, Incidents.Status, Incidents.IncidentNum, Incidents.PolicyNum, Ships.ShipName AS 'Ship Name', Incidents.Description, Incidents.Location, CONVERT(varchar, Incidents.IncidentDate, 105) AS 'Incident Date', Incidents.PaidAmt, Incidents.OutstandingAmt, Incidents.TotalIncurredAmt, Incidents.Remarks " +
        "FROM Incidents INNER JOIN PolicyHeader ON Incidents.PolicyNum = PolicyHeader.PolicyNum INNER JOIN Ships ON PolicyHeader.ShipNum = Ships.ShipNum";
//  sql = "select * from Incidents";

  workbook = new XSSFWorkbook ();
  sheet = workbook.createSheet ("Claims Bordereau");
  sheet.createFreezePane( 0, 1, 0, 1 );

  font = workbook.createFont ();
  font.setFontHeightInPoints((short) 14);
  font.setBold(true);

  style = workbook.createCellStyle ();
  style.setFont(font);

  rowCount = 0;
  colCount = 0;
 
  // header
  row = sheet.createRow (rowCount++);

  for (Map.Entry entry : getRecords (sql).get (0).entrySet ()) {
    cell = row.createCell (colCount);
    cell.setCellValue (String.valueOf (entry.getKey ()));
    cell.setCellStyle (style);
    sheet.autoSizeColumn (colCount);
    colCount++; 
  }


  // data
  for (Map <String, String> map : getRecords (sql) ) {

    row = sheet.createRow (rowCount++);
    colCount = 0;

    for (Map.Entry entry : map.entrySet ()) {
      cell = row.createCell (colCount++);   
      cell.setCellValue (String.valueOf (entry.getValue ()));
             
    }

        
  }





      
  workbook.write(response.getOutputStream());
  workbook.close();

%>


<%= new File(".").getAbsolutePath() %>