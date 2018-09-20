<% // https://www.tutorialspoint.com/apache_poi_word/  %>

<%@ page import = "java.io.*, java.math.*, java.util.*, org.apache.poi.*, org.apache.poi.xwpf.usermodel.*, org.apache.poi.xwpf.model.*, org.openxmlformats.schemas.wordprocessingml.x2006.main.*, org.apache.xmlbeans.impl.xb.xmlschema.SpaceAttribute.*, org.apache.poi.util.*, org.apache.poi.xwpf.extractor.*" %>

<%@include file="/dbhelper.jsp" %>

<%!

  XWPFDocument doc;
  XWPFHeaderFooterPolicy policy;
  String s, policyNum;

  void saveDoc (XWPFDocument doc) throws Exception  {
   
    FileOutputStream ops;

    ops = new FileOutputStream (new File("webapps/test/createdocument.docx"));
    doc.write (ops);
    ops.close ();

  }


  void createDocHeader () throws Exception {

    XWPFHeader header;
    XWPFParagraph paragraph;
    XWPFRun run;
    XWPFTable table;
    XWPFTableRow row;
    XWPFTableCell cell;
    int i;
    int[] cols = {4000, 4000, 4000};    
    
    header = policy.createHeader(XWPFHeaderFooterPolicy.DEFAULT);
    paragraph = header.createParagraph();
    paragraph.setAlignment(ParagraphAlignment.LEFT);
    header.removeParagraph (header.getParagraphs().get(0));

    table = header.createTable(1,3);
    table.getCTTbl().getTblPr().unsetTblBorders();

    for (i = 0; i < table.getNumberOfRows(); i++){
      row = table.getRow (i);
      for(int j = 0; j < row.getTableCells().size(); j++) row.getCell(j).getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(cols[j]));        
    }

    cell = table.getRow(0).getCell(0);
    run = cell.getParagraphs ().get (0).createRun();  
    run.addPicture(new FileInputStream ("webapps\\test\\image\\logo.jpg"), XWPFDocument.PICTURE_TYPE_JPEG, "logo.jpg", Units.toEMU(50), Units.toEMU(50));


    cell = table.getRow(0).getCell(2);
    cell.removeParagraph(0);
    paragraph = cell.addParagraph();
    paragraph.setAlignment(ParagraphAlignment.RIGHT);
    CTPPr ppr = paragraph.getCTP().getPPr();
    if (ppr == null) ppr = paragraph.getCTP().addNewPPr();
    CTSpacing spacing = ppr.isSetSpacing() ? ppr.getSpacing() : ppr.addNewSpacing();
    spacing.setAfter(BigInteger.valueOf(0));
    spacing.setBefore(BigInteger.valueOf(0));
    spacing.setLineRule(STLineSpacingRule.AUTO);
    spacing.setLine(BigInteger.valueOf(240));

    run = paragraph.createRun();  
    run.setText("7 Suntec Tower 1"); 
    run.addBreak();
    run.setText("Singapore");


  } // createDocHeader


  void createDocFooter () {

    XWPFFooter footer;
    XWPFParagraph paragraph;
    XWPFRun run;
    CTP ctpFooter;
    CTR ctr;
    XWPFParagraph[] parsFooter;
    CTText ct;
/*
    footer = policy.createFooter(XWPFHeaderFooterPolicy.DEFAULT);
    paragraph = footer.createParagraph();
    paragraph.setAlignment(ParagraphAlignment.CENTER);

    run = paragraph.createRun();  
    run.setText("The Footer:");
*/

    parsFooter = new XWPFParagraph[1];
    ctpFooter = CTP.Factory.newInstance();
//    ctr = ctpFooter.addNewR();
//    ct = ctr.addNewT();
//    ct.setStringValue("Page ");
//    ct.setSpace(Space.PRESERVE);
//    ctr.addNewPgNum(); 

    paragraph = new XWPFParagraph(ctpFooter, doc);
    paragraph.setAlignment(ParagraphAlignment.RIGHT);
    parsFooter[0] = paragraph;



  run = paragraph.createRun();  
  run.setText("Page ");
  // this adds the page counter
  paragraph.getCTP().addNewFldSimple().setInstr("PAGE \\* MERGEFORMAT");
  run = paragraph.createRun();
  run.setText(" of ");
  // this adds the page total number
  paragraph.getCTP().addNewFldSimple().setInstr("NUMPAGES \\* MERGEFORMAT");


    policy.createFooter(XWPFHeaderFooterPolicy.DEFAULT, parsFooter);

  } // createDocFooter


  void createDocBody () throws Exception {

    XWPFParagraph paragraph;
    XWPFTable table;
    XWPFTableRow row;
    XWPFTableCell cell;
    XWPFRun run;
    String s;

    paragraph = doc.createParagraph();
    paragraph.setAlignment(ParagraphAlignment.CENTER);
    run = paragraph.createRun();
    run.setText("CERTIFICATE OF INSURANCE");
    run.setBold(true);
    run.setFontSize(18);
//  run.setItalic(true);
    run.addBreak();

    paragraph = doc.createParagraph();
    paragraph.setAlignment(ParagraphAlignment.BOTH);
    run = paragraph.createRun ();
    run.setText("the vessel(s) set out herein for account of the Assured named hereunder subject to the By-Laws and Rules of the Insurer from time to time in force and to any special terms and conditions endorsed hereon and/or as may from time to time be circularized. Unless indicated to the contrary herein, the cover evidenced by this Certificate of Insurance commences at noon GMT on the date specified below in Section \"COVER TO COMMENCE\" and continues until the moment immediately prior to noon GMT on the date specified below in Section \"OVER TO TERMINATE\" or until cover ceases or is terminated in accordance with the said By-Laws and Rules.");
    run.addCarriageReturn();
    run.addCarriageReturn();



    paragraph = doc.createParagraph();
    paragraph.setBorderBottom(Borders.BASIC_BLACK_DASHES);
    paragraph.setBorderLeft(Borders.BASIC_BLACK_DASHES);
    paragraph.setBorderRight(Borders.BASIC_BLACK_DASHES);
    paragraph.setBorderTop(Borders.BASIC_BLACK_DASHES);

    run = paragraph.createRun();
    run.setText("PolicyNum" + policyNum);
    run.addCarriageReturn();


    paragraph = doc.createParagraph();
    table = doc.createTable(1, 2);
    row = table.getRow(0);
    cell = row.getCell(0);
    cell.getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(4000));
    cell.removeParagraph(0);
    paragraph = cell.addParagraph ();
    run = paragraph.createRun();
    run.setText("Policy Num");
    run.setBold(true);

    cell = row.getCell(1);
    cell.getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(2*4000));
    cell.removeParagraph(0);
    paragraph = cell.addParagraph ();
    run = paragraph.createRun();
    run.setText(policyNum);


    createAssured ();

    paragraph = doc.createParagraph();
    table = doc.createTable(1, 2); 
    cell = table.getRow(0).getCell(0);
    cell.getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(4000));
    run = cell.getParagraphs ().get (0).createRun();
    run.setText("Type Insurance");
    run.setBold(true);


    cell = table.createRow ().getCell(0);
    cell.getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(4000));
    run = cell.getParagraphs ().get (0).createRun();
    run.setText("Attachment Date");
    run.setBold (true);


    cell = table.createRow ().getCell(0);
    cell.getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(4000));
    run = cell.getParagraphs ().get (0).createRun();
    run.setText("Period of Insurance");
    run.setBold(true);


    cell = table.createRow ().getCell(0);
    cell.getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(4000));
    run = cell.getParagraphs ().get (0).createRun();
    run.setText("Vessel");
    run.setBold(true);


    createSection (table, "Trading Area", "PolicyHeader", "TradingArea", " where PolicyNum = '" + policyNum + "'");
    createSection (table, "Conditions", "PolicyHeader", "Conditions", " where PolicyNum = '" + policyNum + "'");
    createSection (table, "Limit of Liability", "PolicyHeader", "LimitLiability", " where PolicyNum = '" + policyNum + "'");
    createSection (table, "Deductibles", "PolicyHeader", "TradingArea", " where PolicyNum = '" + policyNum + "'");
    createSection (table, "Express Warranties", "PolicyHeader", "ExpressWarranties", " where PolicyNum = '" + policyNum + "'");
    createSection (table, "Sanction Clause", "PolicyHeader", "SanctionClause", " where PolicyNum = '" + policyNum + "'");
    createSection (table, "Applicable Clause", "PolicyHeader", "ApplicableClause", " where PolicyNum = '" + policyNum + "'");
    createSection (table, "Survey Warranty", "PolicyHeader", "SurveyWarranty", " where PolicyNum = '" + policyNum + "'");
    createSection (table, "Defect Warranty", "PolicyHeader", "DefectWarranty", " where PolicyNum = '" + policyNum + "'");



    createImportant ();
    run.addCarriageReturn();




  

paragraph = doc.createParagraph();
  paragraph.setPageBreak(true);
  run = paragraph.createRun();
  run.setText(String.valueOf (doc.getProperties().getExtendedProperties().getUnderlyingProperties().getLines()));

paragraph = doc.createParagraph();
paragraph.getCTP().addNewFldSimple().setInstr("NUMPAGES \\* MERGEFORMAT");
 

  } // createDocBody


  void createAssured () throws Exception {
    XWPFParagraph paragraph;
    XWPFTable table;
    XWPFTableRow row;
    XWPFTableCell cell;
    XWPFRun run;

    paragraph = doc.createParagraph();
    table = doc.createTable(1, 2);
    cell = table.getRow(0).getCell(0);
    cell.getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(4000));
    run = cell.getParagraphs ().get (0).createRun();
    run.setText("Assured");
    run.setBold(true);

    cell = table.getRow(0).getCell(1);
    cell.getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(2*4000));
    run = cell.getParagraphs ().get (0).createRun();
    run.setText(getFieldValue ("PolicyHeader", " (select AssuredNum from QuoteHeader where PolicyHeader.QuoteNum = QuoteHeader.QuoteNum) AS Assured ", " where PolicyNum = 'efm-6004'"));
  } // createAssured


  void createSection (XWPFTable table, String sectionHeading, String dbTable, String dbField, String condition) throws Exception {
    XWPFTableRow row;
    XWPFTableCell cell;
    XWPFRun run;
    String data;
    String[] lines;
    int i;

    row = table.createRow ();
    cell = row.getCell(0);
    cell.getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(4000));
    run = cell.getParagraphs ().get (0).createRun();
    run.setText (sectionHeading);
    run.setBold (true);

    cell = row.getCell(1);
    cell.getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(2*4000));
    run = cell.getParagraphs ().get (0).createRun();

    data = getFieldValue (dbTable, dbField, condition);
    if (data.contains("\n")) {
      lines = data.split("\n");
      run.setText(lines[0], 0); // set first line into XWPFRun
      for (i = 1; i < lines.length; i++){
        run.addBreak();
        run.setText(lines[i]);
      }
    }
    else run.setText(data, 0);

  } // createSection


  void createImportant () throws Exception {
    XWPFParagraph paragraph;
    XWPFTable table;
    XWPFTableRow row;
    XWPFTableCell cell;
    XWPFRun run;

    paragraph = doc.createParagraph();
    table = doc.createTable(1, 2);
table.getCTTbl().getTblPr().unsetTblBorders();
    cell = table.getRow(0).getCell(0);
    cell.getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(4000));

    run = cell.getParagraphs ().get (0).createRun();
    run.setText("Important");
    run.setBold(true);

    cell = table.getRow(0).getCell(1);
    cell.getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(2*4000));
    run = cell.getParagraphs ().get (0).createRun();
    run.setText("This Certificate of Insurance is evidence only of the contract of indemnity insurance between the above-named Assured and the Insurer and shall not be construed as evidence of any undertaking, financial or otherwise, on the part of the Insurer to any other party. " +
                "Unless otherwise stated in the attached Special Terms and Conditions, the cover evidenced by this Certificate of Insurance includes the Insurer's liability to reimburse the Asured for claims in respect of cargo, liability for pollution, liability for the removal of wreck and liability for damage to third-party property (dock damage) as defined in the By-Laws and Rules of the Insurer and any Special Terms and Conditions appended to this Certificate of Insurance. " +
                "If an Assured tenders this Certificate as evidence of insurance under any applicable law relating to financial responsibility, or otherwise shows or offers it to any other party as evidence of insurance, such use of this Certificate by the Assured is not to be taken as any indication that the Insurer thereby consents to act as guarantor or to be sued directly in any jurisdiction whatsoever. The Insurer does not so consent. " +
                "Breach of premium warranty may lead to rejection of all claims whether arising before or after the breach.");
  } // createImportant

%>

<%

  policyNum = (request.getParameter ("PolicyNum") == null) ? "" : request.getParameter ("PolicyNum");

  doc = new XWPFDocument();
  policy = new XWPFHeaderFooterPolicy(doc, doc.getDocument().getBody().addNewSectPr());

  createDocHeader ();
  createDocFooter ();
  createDocBody ();


  //prompt user to save
  response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
  response.setHeader("Content-Disposition", "attachment; filename=certificate.docx");

  //doc.enforceReadonlyProtection();
  doc.write (response.getOutputStream());

  doc.close();




%>


