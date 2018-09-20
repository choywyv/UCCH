<% // https://www.tutorialspoint.com/apache_poi_word/  %>

<%@ page import = "java.io.*, java.math.*, java.util.*, org.apache.poi.*, org.apache.poi.xwpf.usermodel.*, org.apache.poi.xwpf.model.*, org.openxmlformats.schemas.wordprocessingml.x2006.main.*, org.apache.xmlbeans.impl.xb.xmlschema.SpaceAttribute.*, org.apache.poi.util.*, org.apache.poi.xwpf.extractor.*" %>

<%!

  XWPFDocument doc;
  XWPFHeaderFooterPolicy policy;
  String s;



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
    cell.removeParagraph(0);
    paragraph = cell.addParagraph();
    run = paragraph.createRun();  
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
    ctr = ctpFooter.addNewR();
    ct = ctr.addNewT();
    ct.setStringValue("Page ");
    ct.setSpace(Space.PRESERVE);
    ctr.addNewPgNum(); 

    paragraph = new XWPFParagraph(ctpFooter, doc);
    paragraph.setAlignment(ParagraphAlignment.RIGHT);
    parsFooter[0] = paragraph;

    policy.createFooter(XWPFHeaderFooterPolicy.DEFAULT, parsFooter);

  } // createDocFooter


  void createDocBody () {

    XWPFParagraph paragraph;
    XWPFRun run;

  paragraph = doc.createParagraph();
  paragraph.setAlignment(ParagraphAlignment.CENTER);
  run = paragraph.createRun();
  run.setText("This is a new paragraph.");
  run.setBold(true);
  run.setFontSize(18);
  run.setItalic(true);
  run.addBreak();

  paragraph = doc.createParagraph();
  paragraph.setAlignment(ParagraphAlignment.BOTH);
  run = paragraph.createRun ();
  run.setText("of the vessel(s) set out herein for account of the Member named hereunder subject to the By-Laws and Rules of the Association from time to time in force and to any special terms and conditions endorsed hereon and/or as may from time to time be circularized. Unless indicated to the contrary herein, the cover evidenced by this Certificate of Entry commences at 12:00 noon GMT on the date specified below in Section “COVER TO COMMENCE” and continues until the moment immediately prior to 12:00 noon GMT on the date specified below in Section “COVER TO TERMINATE” or until cover ceases or is terminated in accordance with the said By-Laws and Rules. ");
  run.addCarriageReturn();
  run.addCarriageReturn();

  paragraph = doc.createParagraph();
  //Set bottom border to paragraph
  paragraph.setBorderBottom(Borders.BASIC_BLACK_DASHES);
        
  //Set left border to paragraph
  paragraph.setBorderLeft(Borders.BASIC_BLACK_DASHES);
        
  //Set right border to paragraph
  paragraph.setBorderRight(Borders.BASIC_BLACK_DASHES);
        
  //Set top border to paragraph
  paragraph.setBorderTop(Borders.BASIC_BLACK_DASHES);

  run = paragraph.createRun();
  run.setText("At tutorialspoint.com, we strive hard to provide quality tutorials for self-learning purpose in the domains of Academics, Information Technology, Management and Computer Programming Languages.");
  run.addCarriageReturn();


  paragraph = doc.createParagraph();
run = paragraph.createRun ();
run.setText("The process for underwriting is as follows:" +

"A broker sends an enquiry to EF Marine. The underwriter judges the enquiry and may have further questions. Based on the information gathered the underwriter decides whether an indication or quotation will be given. When the quotation is given there may be some negotiation on terms and conditions. When the client accepts the quotation it becomes an order. When the client does not accept our quotation we close our file and may try again next year. When the quotation becomes an order we have to issue documentation such certificate of insurance and invoice. For Shipowners’ P&I the vessel(s) will be insured and for Charterers’ Liability we will get declarations of vessels as the vessels are insured for short period. For MultiModal we get declaration of what will be insured. For Charterers’ Liability after each declaration we normally issue an invoice. Unless it is monthly or quarterly declaration by the client. For Shipowners’ P&I you can look how it is done at BSM. The process for EF Marine is same. " +
"All invoices need to go automatically (with certain checks) to the finance system. Once premium is paid information needs to go back from finance system to underwriting system." +

"Your summary below is correct." +

"For claims it works as follows. We get a notification of a new claim and then open a claims file. When we open a claim the system needs to check whether the claims date falls within period insured of the declaration. Further we need to check whether all premiums are insured. The claim is handled by the claims handler and invoices of third parties such as lawyers, surveyors and correspondents need to be paid. We may also need to pay the claim. Also we need to be able to make invoices for deductibles. All invoices need to go automatically (with certain checks) to the finance system. When a client pays the deductible the finance system needs to inform the claims system." +


"In my previous email I provided you the data that needs to be trapped. I think with that you have a good view on what needs to be built.");
  run.addCarriageReturn();
  run.addCarriageReturn();
  paragraph = doc.createParagraph();
run = paragraph.createRun ();
run.setText("The process for underwriting is as follows:" +

"A broker sends an enquiry to EF Marine. The underwriter judges the enquiry and may have further questions. Based on the information gathered the underwriter decides whether an indication or quotation will be given. When the quotation is given there may be some negotiation on terms and conditions. When the client accepts the quotation it becomes an order. When the client does not accept our quotation we close our file and may try again next year. When the quotation becomes an order we have to issue documentation such certificate of insurance and invoice. For Shipowners’ P&I the vessel(s) will be insured and for Charterers’ Liability we will get declarations of vessels as the vessels are insured for short period. For MultiModal we get declaration of what will be insured. For Charterers’ Liability after each declaration we normally issue an invoice. Unless it is monthly or quarterly declaration by the client. For Shipowners’ P&I you can look how it is done at BSM. The process for EF Marine is same. " +
"All invoices need to go automatically (with certain checks) to the finance system. Once premium is paid information needs to go back from finance system to underwriting system." +

"Your summary below is correct." +

"For claims it works as follows. We get a notification of a new claim and then open a claims file. When we open a claim the system needs to check whether the claims date falls within period insured of the declaration. Further we need to check whether all premiums are insured. The claim is handled by the claims handler and invoices of third parties such as lawyers, surveyors and correspondents need to be paid. We may also need to pay the claim. Also we need to be able to make invoices for deductibles. All invoices need to go automatically (with certain checks) to the finance system. When a client pays the deductible the finance system needs to inform the claims system." +


"In my previous email I provided you the data that needs to be trapped. I think with that you have a good view on what needs to be built.");
  run.addCarriageReturn();
  run.addCarriageReturn();
  paragraph = doc.createParagraph();
run = paragraph.createRun ();
run.setText("The process for underwriting is as follows:" +

"A broker sends an enquiry to EF Marine. The underwriter judges the enquiry and may have further questions. Based on the information gathered the underwriter decides whether an indication or quotation will be given. When the quotation is given there may be some negotiation on terms and conditions. When the client accepts the quotation it becomes an order. When the client does not accept our quotation we close our file and may try again next year. When the quotation becomes an order we have to issue documentation such certificate of insurance and invoice. For Shipowners’ P&I the vessel(s) will be insured and for Charterers’ Liability we will get declarations of vessels as the vessels are insured for short period. For MultiModal we get declaration of what will be insured. For Charterers’ Liability after each declaration we normally issue an invoice. Unless it is monthly or quarterly declaration by the client. For Shipowners’ P&I you can look how it is done at BSM. The process for EF Marine is same. " +
"All invoices need to go automatically (with certain checks) to the finance system. Once premium is paid information needs to go back from finance system to underwriting system." +

"Your summary below is correct." +

"For claims it works as follows. We get a notification of a new claim and then open a claims file. When we open a claim the system needs to check whether the claims date falls within period insured of the declaration. Further we need to check whether all premiums are insured. The claim is handled by the claims handler and invoices of third parties such as lawyers, surveyors and correspondents need to be paid. We may also need to pay the claim. Also we need to be able to make invoices for deductibles. All invoices need to go automatically (with certain checks) to the finance system. When a client pays the deductible the finance system needs to inform the claims system." +


"In my previous email I provided you the data that needs to be trapped. I think with that you have a good view on what needs to be built.");
  run.addCarriageReturn();
  run.addCarriageReturn();




  

paragraph = doc.createParagraph();
  paragraph.setPageBreak(true);
  run = paragraph.createRun();
  run.setText(String.valueOf (doc.getProperties().getExtendedProperties().getUnderlyingProperties().getLines()));



  }



%>

<%


  doc = new XWPFDocument();
  policy = new XWPFHeaderFooterPolicy(doc, doc.getDocument().getBody().addNewSectPr());

  createDocHeader ();
  createDocFooter ();
  createDocBody ();







  // save to server webapp
  saveDoc (doc);

  //prompt user to save
//  response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
//  response.setHeader("Content-Disposition", "attachment; filename=certificate.docx");

  //doc.enforceReadonlyProtection();
//  doc.write (response.getOutputStream());

  doc.close();






  FileInputStream fis = new FileInputStream (new File("webapps/test/createdocument.docx"));


  doc = new XWPFDocument(fis);

  out.println ("Lines: " + "" + "<br><br>");

  for (XWPFParagraph para : doc.getParagraphs()) {
    out.println(para.getText() + "<br><br>");          
//  out.println ("Parasize: " + doc.getParagraphs().size ());
    out.println (para.isPageBreak ());
}
  fis.close();




/*
      XWPFWordExtractor we = new XWPFWordExtractor(new XWPFDocument(new FileInputStream (new File("webapps/test/createdocument.docx"))));
out.println (we.getExtendedProperties().getPages() + "<br><br>");
      out.println(we.getText());
      we.close ();
*/
%>


