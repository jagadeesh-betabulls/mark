<%@ page errorPage="/errors/ExceptionPage.jsp" %>
<%@ page isErrorPage="true" %>
<%@ page import="java.util.*" %>
<html>
<head>
  <title>Error Page</title>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<link rel="stylesheet" href="/sitehosts/marketdaysinn/styles/vendor_styles.css" type="text/css">
<body>
<table border='0' width='95%' ALIGN='CENTER'><tr><td class="menuLINK" height='30'><span style="font-size:150%">An Error Has Occurred</span></td></tr></table>
<blockquote><p class="bodyBlack">We apologize for the inconvenience, we are experiencing some technical difficulties today, an error has occurred processing your last request. If you were placing an order please check your Job Console to see if it has gone through before trying to place it again, then <a href="/" class="subtitle1">return to the home page</a> and continue with your orders. If you continue to receive this error please contact customer service via one of the options below. Thank you.</p>

<span class="subtitle">Marketing Services Technical Support</span>
<ul><li>Email <a href="mailto:marketingservices@marcomet.com" class="subtitle1"><img border="0" src="/images/mail.gif" alt="MAIL" />&nbsp;techsupport@marcomet.com</a> with the details of what you were trying to do when you received the error. Please let us know the type of computer you are using (Windows XP, Vista, Apple Mac, etc) and the browser version (e.g. Internet Explorer version X, Apple Safari version X) Be sure to include a phone number we can reach you at.</li></ul>
       <blockquote>- or -</blockquote>
        <ul><li>Call <span class='subtitle'><img border='0' src="/images/phone.gif" />&nbsp;888-777-9832, option 4</span> 9am - 5pm EST, M-F
          </li></ul>
<div align='center'><a href="/l.jsp" class='menuLINK'>RETURN TO HOME PAGE</a></div></blockquote>
<!--
<b>Error(s):</b><br>
<pre><%= exception.getMessage() %></pre>
<p>
<b>Stack Trace:</b><br>
<pre>
<% 
	 java.io.PrintWriter outstream = new java.io.PrintWriter(out);
         exception.printStackTrace(outstream);
%>
</pre>
<p>

<table>
<tr><td colspan="2"><b>Session Variables</b></td></tr>
<%-- 
	Enumeration varNames = session.getAttributeNames();
	String varValue = "";
	String varName = "";
	if(varNames.hasMoreElements()){
		do{
			varName = (String)varNames.nextElement();
			try{
				if(session.getAttribute(varName) == null){
					varValue="HAS NO VALUE";		
				}else{
					//varValue = (String)session.getAttribute(varName);
					varValue = session.getAttribute(varName).toString();
				}	
			}catch(Exception e){
				varValue="IS AN OBJECT" + ": " + e.getMessage();	
			}
%>
<tr><td><%= varName%></td><td><%= varValue %></td></tr>
<%
		}while(varNames.hasMoreElements());
	}else{
%>
<tr><td colspan="2">No Session Variables</td></tr>
<%	
	}
%>
</table>
<p>
<table>
<tr><td colspan="2"><b>Request Information:</b></td></tr>
<tr><td>JSP Request Method:</td><td><%= request.getMethod() %></td></tr>
<tr><td>Request URI:</td><td><%= request.getRequestURI()  %></td></tr>
<tr><td>Request Protocol:</td><td><%= request.getProtocol() %></td></tr>
<tr><td>Servlet path:</td><td><%= request.getServletPath() %></td></tr>
<tr><td>Path info:</td><td><%= request.getPathInfo() %></td></tr>
<tr><td>Path translated:</td><td><%= request.getPathTranslated() %></td></tr>
<tr><td>Query string:</td><td><%= request.getQueryString() %></td></tr>
<tr><td>Content length:</td><td><%= request.getContentLength() %></td></tr>
<tr><td>Content type:</td><td><%= request.getContentType() %></td></tr>
<tr><td>Server name:</td><td><%= request.getServerName() %></td></tr>
<tr><td>Server port:</td><td><%= request.getServerPort() %></td></tr>
<tr><td>Remote user:</td><td><%= request.getRemoteUser() %></td></tr>
<tr><td>Remote address:</td><td><%= request.getRemoteAddr() %></td></tr>
<tr><td>Remote host:</td><td><%= request.getRemoteHost() %></td></tr>
<tr><td>Authorization scheme:</td><td><%= request.getAuthType() %></td></tr>
</table>
<hr>
The browser you are using is <%= request.getHeader("User-Agent") --%>

-->
</body>
</html>