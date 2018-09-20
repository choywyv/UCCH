<%@ page import = "org.apache.poi.xssf.usermodel.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.HSSFWorkbook, 
                 java.util.Map, java.util.HashMap, java.util.Calendar, java.io.*, java.text.SimpleDateFormat"
%>

<%

  response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
  response.setHeader("Content-Disposition", "attachment; filename=temp.xlsx");

  Workbook wb = new XSSFWorkbook();

  Sheet sheet = wb.createSheet("Business Plan");

  Row row;
  Cell cell;

  for (int i = 0; i < 10; i++) {
    row = sheet.createRow(i);
    for (int j = 0; j < 5; j++) {
      cell = row.createCell(j);
      cell.setCellValue("hello world " + j);
    }
  }
      
  wb.write(response.getOutputStream());
  wb.close();

%>


<%= new File(".").getAbsolutePath() %>