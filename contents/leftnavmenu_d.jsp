<%@ page errorPage="/errors/ExceptionPage.jsp" %><%@ page import="java.sql.*,com.marcomet.tools.*,com.marcomet.environment.*,com.marcomet.users.security.*;" %><jsp:useBean id="connection" class="com.marcomet.jdbc.ConnectionBean" scope="session" /><%boolean editor= (((RoleResolver)session.getAttribute("roles")).roleCheck("editor"));String ShowRelease=((request.getParameter("ShowRelease")==null || request.getParameter("ShowRelease").equals("")) ? "":" AND nav_menus.release='"+request.getParameter("ShowRelease")+"' ");String ShowInactive=((request.getParameter("ShowInactive")==null || request.getParameter("ShowInactive").equals(""))?" AND status_id=2 ":""); String pageName=((request.getParameter("pageName")==null || request.getParameter("pageName").equals(""))?" AND page_name='home' ":" AND pagename= '"+request.getParameter("pageName")+"' "); String sitehostId=((SiteHostSettings)session.getAttribute("siteHostSettings")).getSiteHostId();%><table border=0 cellpadding=0 cellspacing=0 width="232">	<tr><td valign="top">		<table align="top" cellpadding=0 cellspacing=0 width=100%>			<tr><td width=100% class="leftNavBarHeader">&nbsp;&nbsp;Marketing&nbsp;Services</td></tr>			<tr><td>				<table id="subMenu0" width=100% cellspacing=0 cellpadding=0><%		Connection conn = com.marcomet.jdbc.DBConnect.getConnection();		Statement st = conn.createStatement();ResultSet rs = st.executeQuery("SELECT  * FROM nav_menus where sitehost_id="+sitehostId+pageName+ShowInactive+ShowRelease+" ORDER BY sequence");int x=1;int y=1;while(rs.next()){	String target=((rs.getString("target").equals(""))?"main":rs.getString("target"));	if (rs.getString("link_page").equals("logos.jsp") || editor ){		%><tr><td class="leftNavBarItem2" onMouseOver="this.className='leftNavBarItemOver2';cmslnk<%=y%>.className='leftNavBarItemHover2'" onMouseOut="this.className='leftNavBarItem2';cmslnk<%=y%>.className='leftNavBarItem2'" height="30"><%if (editor){%><a href='javascript:pop("/popups/QuickChangeForm.jsp?cols=60&rows=2&question=Change%20Navigation%20Menu%20Text&primaryKeyValue=<%=rs.getString("id")%>&columnName=link_text&tableName=nav_menus&valueType=string",500,100)'>&raquo;</a>&nbsp;<%}%><a href="/contents/logos.jsp?title=<%=rs.getString("link_text")%><%=((request.getParameter("ShowRelease")==null || request.getParameter("ShowRelease").equals("") )?"":"&ShowRelease="+request.getParameter("ShowRelease"))%><%=((request.getParameter("ShowInactive")==null || request.getParameter("ShowInactive").equals("") )?"":"&ShowInactive="+request.getParameter("ShowInactive"))%><%=((rs.getString("prodline_id").equals(""))?"":"&prodLineId="+rs.getString("prodline_id"))%>" class="leftNavBarItem2" id='cmslnk<%=y%>' target='<%=target%>'><%=rs.getString("link_text")%></a></td></tr><%		}else {		%><tr><td class="leftNavBarItem2" onMouseOver="this.className='leftNavBarItemOver2';cmslnk<%=y%>.className='leftNavBarItemHover2'" onMouseOut="this.className='leftNavBarItem2';cmslnk<%=y%>.className='leftNavBarItem2'" height="30"><%if (editor){%><a href='javascript:pop("/popups/QuickChangeForm.jsp?cols=60&rows=2&question=Change%20Navigation%20Menu%20Text&primaryKeyValue=<%=rs.getString("id")%>&columnName=link_text&tableName=nav_menus&valueType=string",500,100)'>&raquo;</a>&nbsp;<%}%><a href="<%=rs.getString("link")%>" class='leftNavBarItem2' id='cmslnk<%=y%>' target='<%=target%>'><%=rs.getString("link_text")%></a></td></tr><%	}	y++;	x++;	}%><tr>           <td class="leftNavBarBottom" onMouseOver="this.className='leftNavBarBottomOver';cmslnk<%=y%>.className='leftNavBarBottomTextOver'" onMouseOut="this.className='leftNavBarBottom';cmslnk<%=y%>.className='leftNavBarBottomText'" height="30"><a href="javascript:pop('/popups/help.jsp','650','550')" id='cmslnk<%=y%>' class='leftNavBarBottomText'>Need Help? Click here... </a></td>        </tr></table><%if (session.getAttribute("contactId")!=null){	%><table width="100%" cellspacing="0" cellpadding="0" height="200">		     <tr>			  <td valign="top" height="22"><br><jsp:include page="/includes/ClientARSummary.jsp" />			  </td>			</tr>			<tr>			  <td valign="top"><jsp:include page="/includes/ClientAppvlSummary.jsp"/>			  </td>			</tr>		</table><%}%></td></tr></table></td></tr></table><%conn.close();%>