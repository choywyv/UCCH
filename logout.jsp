<% session.invalidate(); %>

<%!

  Cookie[] cookielist;
  String msg;

%>

<%
 
  cookielist = request.getCookies();
  if (cookielist != null) for (Cookie cookie : cookielist) if (cookie.getName ().equals ("JSESSIONID")) {
    cookie.setMaxAge(0);
    cookie.setValue(null);
    cookie.setPath("/");
    response.addCookie(cookie);
    break;
  }
   
  msg = (request.getParameter ("msg") == null) ? "" : request.getParameter ("msg"); 
  if (!msg.equals ("")) response.setStatus (401);

%>

<script>window.location.href="/test/index.jsp"</script>