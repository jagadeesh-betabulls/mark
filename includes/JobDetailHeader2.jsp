<%@ page import="java.sql.*;" %>
<%@ taglib uri="/WEB-INF/tld/iterationTagLib.tld" prefix="iterate" %>
<% String prod_thumb="/sitehosts/";
   String headerQuery = "SELECT sh.site_host_name as sitehost_name, j.id AS job_id, ljt.value AS job_type, lst.value AS service_type, j.project_id, p.order_id AS order_id, com1.company_name AS vendor_name, com2.company_name AS customer_name, com2.id AS customer_id, DATE_FORMAT(o.date_created,'%m/%d/%y') AS order_date FROM jobs j, projects p, orders o, companies com1, companies com2, lu_service_types lst, lu_job_types ljt, vendors v,site_hosts sh WHERE j.jsite_host_id=sh.id AND j.project_id = p.id AND p.order_id = o.id AND v.id = j.vendor_id AND com1.id = v.company_id AND com2.id = o.buyer_company_id AND j.service_type_id = lst.id AND j.job_type_id = ljt.id AND j.id = " + request.getParameter("jobId");
   Connection conn = com.marcomet.jdbc.DBConnect.getConnection();
   Statement st = conn.createStatement();
   Statement st2 = conn.createStatement();
   ResultSet headerRS = st.executeQuery(headerQuery); 
   request.setAttribute("headerRS", headerRS); %>
<table border="0" cellpadding="5" cellspacing="0" width="100%">
  <tr>
    <td class="tableheader">Customer</td>
    <td class="tableheader">Vendor</td>
    <td class="tableheader">Order #</td>
    <td class="tableheader">Order Date</td>
    <td class="tableheader">Project ID</td>
    <td class="tableheader">Job #</td>
    <td class="tableheader">Job Description</td>
  </tr>
  <iterate:dbiterate name="headerRS" id="i">
  <tr>
    <td class="lineitems" align="center"><$ customer_name $></td>
    <td class="lineitems" align="center"><$ vendor_name $></td>
    <td class="lineitems" align="center"><$ order_id $></td>
    <td class="lineitems" align="center"><$ order_date $></td>
    <td class="lineitems" align="center"><$ project_id $></td>
    <td class="lineitems" align="center"><$ job_id $></td>
    <td class="lineitems" align="center"><%
	prod_thumb+=headerRS.getString("sitehost_name")+"/fileuploads/product_images/";
	String pQuery = "Select p.small_picurl as prod_thumb,j.product_id, p.prod_name, p.prod_code, ppc.unit,j.quantity from jobs j LEFT JOIN products p on p.id=j.product_id LEFT JOIN product_price_codes ppc on p.prod_price_code=ppc.prod_price_code where j.id="+ request.getParameter("jobId");
       ResultSet qtyRS = st2.executeQuery(pQuery.toString());
       while (qtyRS.next()) { 
			prod_thumb=((qtyRS.getString("prod_thumb")==null || qtyRS.getString("prod_thumb").equals(""))?"":"<tr><td colspan=7><img src='"+prod_thumb+qtyRS.getString("prod_thumb")+"' border=1></td></tr>");
		   if (qtyRS.getString("j.product_id")!=null && !qtyRS.getString("j.product_id").equals("")){
		   %><%=qtyRS.getString("p.prod_code")%>: <%=qtyRS.getString("p.prod_name")%><%
		   if (qtyRS.getString("j.quantity")!=null && !qtyRS.getString("j.quantity").equals("")){
		   %>(<%=qtyRS.getString("j.quantity")%>&nbsp;<%=((qtyRS.getString("ppc.unit")!=null && !qtyRS.getString("ppc.unit").equals(""))?qtyRS.getString("ppc.unit"):"")%>)<%
		   }
			}else{
			%><$ job_type $>:<$ service_type $><%
			}
		}%></td>
  </tr><%=prod_thumb%>
  </iterate:dbiterate>
</table><%conn.close();%>