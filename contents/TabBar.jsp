<%@ page import="java.sql.*,java.util.*,com.marcomet.jdbc.*,com.marcomet.tools.*,com.marcomet.catalog.*,com.marcomet.users.security.*" %><jsp:useBean id="str" class="com.marcomet.tools.StringTool" scope="session" /><%Connection conn = DBConnect.getConnection();Statement st = conn.createStatement();boolean editorRole=((((RoleResolver)session.getAttribute("roles")).roleCheck("editor")) || (((RoleResolver)session.getAttribute("roles")).roleCheck("ROC_editor")));boolean editor=((session.getAttribute("editorOff")!=null && session.getAttribute("editorOff").equals("true"))?false:editorRole);String ShowRelease=((request.getParameter("ShowRelease")==null || request.getParameter("ShowRelease").equals("")) ? "":" AND release='"+request.getParameter("ShowRelease")+"' ");boolean showHelp=((request.getParameter("showHelp")==null || request.getParameter("showHelp").equals("false")) ?false:true);String ShowInactive=((request.getParameter("ShowInactive")==null || request.getParameter("ShowInactive").equals(""))?" AND status_id=2 ":""); String navTitle=((request.getParameter("navTitle")==null)?"":request.getParameter("navTitle")); String navSubTitle=((request.getParameter("navSubTitle")==null || request.getParameter("navSubTitle").equals(""))?"":request.getParameter("navSubTitle")); String pageName=((request.getParameter("pageName")==null || request.getParameter("pageName").equals(""))?" AND n.page_name='xxx' ":" AND n.page_name= '"+request.getParameter("pageName")+"' "); String sitehostId=((SiteHostSettings)session.getAttribute("siteHostSettings")).getSiteHostId();String nSQL="SELECT  n.id,n.link,n.link_text,n.target,n.link_page,n.prodline_id,nh.title,nh.subtitle FROM nav_menus n left join nav_menu_headers nh on n.page_name=nh.page_name where sitehost_id="+sitehostId+pageName+ShowInactive+ShowRelease+" ORDER BY sequence";ResultSet rs = st.executeQuery(nSQL); int x=1;int y=1;%><script>function selectThis(el){		document.getElementById('home').className='menuLINK';		document.getElementById('user').className='menuLINK';		document.getElementById('console').className='menuLINK';		document.getElementById('files').className='menuLINK';		document.getElementById('reports').className='menuLINK';		el.className='menuLINKSelected';	}</script><%while(rs.next()){	String link=str.replaceSubstring(rs.getString("link"),"SHD",(String)session.getAttribute("siteHostRoot"));	//link=link+((rs.getString("link").indexOf("?")>-1)?"&menuId="+rs.getString("id"):"?menuId="+rs.getString("id"));	String target=((rs.getString("target").equals(""))?"main":rs.getString("target"));		%>		<a href="<%=link%>" target="<%=target%>" class="menuLINK" id='<%=rs.getString("id")%>'  onClick='selectThis(this)'><%=rs.getString("link_text")%></a><%	y++;	x++;}if (rs  != null)	rs.close();	st.close();     %></table></td></tr></table>