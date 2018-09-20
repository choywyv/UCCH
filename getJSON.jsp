<%@include file="/dbhelper.jsp" %>

<%!

  String s;
  String [] arr;
  int i;
  Map <String, String> map;

%>

<%

  map = getRecords ("select QuoteNum, QuoteDate, ApplicationDate, AssuredNum, AssuredAddress, EffectiveDate, ExpiryDate, Currency, Premium, PaymentTerms, Underwriter, Status, TradingArea, Comments, VAT from QuoteHeader where QuoteNum = 'quote-0009'").get (0);
  arr = map.keySet().toArray(new String[map.size()]);

%>

{

<%

  for (i = 0; i < arr.length; i++) {

%>

"<%= arr [i] %>":"<%= map.get (arr [i]) %>" 

<%

  if (i < arr.length - 1) out.println (", "); 

  }
%>
}
