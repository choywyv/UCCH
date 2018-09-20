<%@ page import="java.sql.*" %>

<%@include file="/dbhelper.jsp" %>

<%!

  int i;
  String policyNum, s;
  
%>

<%

  policyNum = quoteToPolicy (request.getParameter ("QuoteNum"));

%>


Certificate <%= policyNum %> has been generated from Quote Number <%= quoteNum %> 
<br>

<jsp:include page="minidetails.jsp" >
  <jsp:param name="table" value="PolicyHeader" />
  <jsp:param name="PolicyNum" value="<%= policyNum %>" />
</jsp:include>

<br><br>

<jsp:include page="listing.jsp" >
  <jsp:param name="report" value="deductiblelisting" />
  <jsp:param name="source" value="policy" />
  <jsp:param name="PolicyNum" value="<%= policyNum %>" />
</jsp:include>

<button type="submit" form="printform" formtarget="_blank" formaction="print.jsp">Print</button>

        <form id="printform" method="post">
          <input type="hidden" name="PolicyNum" value="<%= policyNum%>">
        </form>

<script>
  ajax ('policy.jsp?PolicyNum=<%= policyNum %>', '', 'content');
</script>