
<%@include file="/dbhelper.jsp" %>

<%= getFieldValue (request.getParameter ("table"), request.getParameter ("fieldToFind"), " where " + request.getParameter ("condition") + " = '" + request.getParameter ("conditionValue") + "'") %>

