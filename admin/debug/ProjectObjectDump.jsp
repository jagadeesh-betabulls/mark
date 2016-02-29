<%@ page errorPage="/errors/ExceptionPage.jsp" %>
<%@ page import="com.marcomet.catalog.*, java.util.*;" %>
<html>
<head>
  <title>ProjectObject Dump</title>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
  <link rel="stylesheet" href="<%=(String)session.getAttribute("siteHostRoot")%>/styles/vendor_styles.css" type="text/css">
  <META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
  <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
  <META HTTP-EQUIV="Expires" CONTENT="-1">
</head>
<body><%
  ProjectObject po = (ProjectObject)session.getAttribute("currentProject");
  if (po != null) {
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td>&nbsp;</td>
    <td colspan="3"><b>Project Id</b></td>
    <td><%=po.getId()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td colspan="3">Project Name</td>
    <td><%=po.getProjectName()%></td>
  </tr>
  <tr> 
    <td>&nbsp; 
    <td colspan="3">Project Sequence</td>
    <td><%=po.getProjectSequence()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">&nbsp;</td>
    <td>&nbsp;</td>
  </tr><%
        Vector jobs = po.getJobs();
        for (Enumeration e1 = jobs.elements(); e1.hasMoreElements(); ) {
           JobObject jo = (JobObject)e1.nextElement();
%>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2"><b>Job Id</b></td>
    <td><%=jo.getId()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">Job Name</td>
    <td><%=jo.getJobName()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">Job Price</td>
    <td><%=jo.getPrice()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">Job Type Id</td>
    <td><%=jo.getJobTypeId()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">Service Type Id</td>
    <td><%=jo.getServiceTypeId()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">Escrow Percentage</td>
    <td><%=jo.getEscrowPercentage()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">Escrow Dollar Amount</td>
    <td><%=jo.getEscrowDollarAmount()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">Vendor Contact Id</td>
    <td><%=jo.getVendorContactId()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">Vendor Id</td>
    <td><%=jo.getVendorId()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr><%
           Hashtable jobSpecs = jo.getJobSpecs();
           for (Enumeration e2 = jobSpecs.elements(); e2.hasMoreElements(); ) {
              JobSpecObject jso = (JobSpecObject)e2.nextElement();
%>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><b>JobSpecId</b></td>
    <td><%=jso.getSpecId()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><b>CatSpecId</b></td>
    <td><%=jso.getCatSpecId()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>Spec Value</td>
    <td><%=jso.getValue()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>Escrow Percentage</td>
    <td><%=jso.getEscrowPercentage()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>Cost</td>
    <td><%=jso.getCost()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>Markup</td>
    <td><%=jso.getMu()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>Fee</td>
    <td><%=jso.getFee()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>Price</td>
    <td><%=jso.getPrice()%></td>
  </tr><%
           }
        }
  } else {
%>
  <tr> 
    <td colspan="4">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="5" align="center"><b>There is no current project in memory</b></td>
  </tr><%
  }
%>
</table>
</body>
</html>
