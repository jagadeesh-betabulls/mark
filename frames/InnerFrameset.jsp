<%@ page import="com.marcomet.environment.SiteHostSettings;" %>
<%@ page errorPage="/errors/ExceptionPage.jsp" %>
<jsp:include page="/includes/LoadSiteHostInformation.jsp" flush="true"/>
<%
String demoStr=((session.getAttribute("demo")==null)?"":"/demo");
	SiteHostSettings settings = (SiteHostSettings)session.getAttribute("siteHostSettings");

	String height = "100";
	try{
		height = settings.getInnerFrameSetHeight();
	} catch ( Exception e ){}

	String host = request.getHeader("host");
	int pos = host.indexOf(".");

	String root = "/sitehosts/" + host.substring(0, pos)+demoStr;
	try{
		root = settings.getSiteHostRoot();
	} catch ( Exception e ){}
%>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
  <title>Catalog Wizard</title>
</head>
<frameset  ID=innerFr  framespacing="0" border="0" rows="<%= ((session.getAttribute("homeNotice")==null)?"":"70,")+height %>,23,*,0" frameborder="0" cols="*"> 
<%=((session.getAttribute("homeNotice")==null)?"":"<frame name='proxy' scrolling='no' noresize src='/contents/homenotice.jsp'>")%>
  <frame name="header" scrolling="no" noresize target="main" src="<%= root %>/headers/topmast_inner.jsp">
  <frame name="title" scrolling="no" noresize target="main" src="/headers/InnerTitle.jsp"><%
  String queryString = (String)request.getQueryString();
  int splitMark = (queryString).indexOf('=')  + 1;
  String source =  queryString.substring(splitMark);%><frame name="contents" src="<%=source%>" target="_self" scrolling="yes" noresize>
  <frame name="refresher" scrolling="no" noresize src="/contents/TimedRefreshPage.jsp">
<frame src="UntitledFrame-23"></frameset>
<noframes>
 <body>
   <p>This page uses frames, but your browser doesn't support them.</p>
<%= settings == null ? "NULL" : "OK" %>
 </body>
</noframes>
</html>
