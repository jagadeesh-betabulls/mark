<%@ page import="java.sql.*,com.marcomet.users.security.*,com.marcomet.tools.*;import java.text.*;" %><%@ include file="/includes/SessionChecker.jsp" %>
<%boolean editor= (((RoleResolver)session.getAttribute("roles")).roleCheck("editor"));%><html>
<head>
<title>Warehouse Reports Menu</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="<%=(String)session.getAttribute("siteHostRoot")%>/styles/vendor_styles.css" type="text/css">
<style>
	ul.list {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 9pt;
		color: #0b3b25;
		vertical-align: top;
		font-style: normal;
		font-weight: normal;
		font-variant: normal;
		list-style-position: inside;
		list-style-type: lower-alpha;
		list-style-image: url(/images/raquote.gif);
		line-height: 150%;
	}
A:hover {
	border-top: 1px solid #52bef1;
	border-bottom: 1px solid #52bef1;
}
</style>
<script language="JavaScript" src="/javascripts/mainlib.js"></script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<table>
	<tr>
		<td class="minderheadercenter">Reports and Data Entry</td>
	</tr>
	<tr>
		<td class="subtitle">Add/Edit data forms:</td>
	</tr>
	<tr>
		<td>
			<ul class='list'>
				<li><a href="/popups/QuickShipForm.jsp"  class='subtitle1' >Enter shipment</a></li>
<!--				<li><a href="/popups/QuickBillForm.jsp"  class='subtitle1' >Bill Job</a></li>
				<li><a href="/admin/collections/EntryFormFromQuick.jsp"  class='subtitle1' >Enter collection</a></li>
				<li><a href="/app-admin/payments/APAddEntryFromQuick.jsp"  class='subtitle1' >Manage Accruals</a></li>
				<li><a href="/popups/ProductInfo.jsp"  class='subtitle1' target='_blank'>View/Edit Product Information</a></li>
				<li><a href="/minders/workflowforms/InventoryUpdateForm.jsp"  class='subtitle1' target='_blank'>View/Adjust Product Inventory</a></li>
-->
			</ul>
		</td>
	</tr>

<!--	<tr>
		<td class="subtitle">Reports:</td>
	</tr>
	<tr>
		<td>
			<ul class='list'>
				<li><a href="/reports/vendors/SalesReportFilters.jsp" class='subtitle1'>Sales: Invoice History Report</a></li>
				<li><a href="/reports/vendors/orderHistoryFilters.jsp"  class='subtitle1'>Sales: Order History Report</a></li>
				<li><a href="/reports/vendors/invoiceHistoryForCompanyFilters.jsp"  class='subtitle1'>Purchases: Invoice History Report</a></li>
				<li><a href="/reports/vendors/AgedARRptFilters.jsp"  class='subtitle1'>Accounts Receivable Open Invoices with Aging</a></li><%if(editor){%><li><a href="/app-admin/payments//APReportFilters.jsp"  class='subtitle1'>AP Accrual Reports</a></li>
					<li><a href="http://lms.marcomet.com/app-admin/product/Inventory.jsp" class='subtitle1'>Complete Inventory Spreadsheet</a> -- shows current listing of all products with their inventory and on-order amounts. When prompted, save as a file with a .xls extension, will save to an excel spreadsheet.
	</li>
	<ul class='list'>
		<li><a href="http://lms.marcomet.com/app-admin/product/Inventory.jsp?asap=true" class='subtitle1'>Inventoriable Products Needing Order/Reorder ASAP</a> -- shows current listing of all active inventoriable products that need action: either need to be reordered immmediately to avoid backorders, or have never been initialized with a manual inventory count.</li>
			<li><a href="http://lms.marcomet.com/app-admin/product/Inventory.jsp?asap=true&initialized=true" class='subtitle1'>Initialized Products Needing Order/Reorder ASAP</a> -- shows current listing of all inventoriable products that have been initialized previously which require immediate reordering to avoid backorders.</li>
		<li><a href="http://lms.marcomet.com/app-admin/product/Inventory.jsp?active=true" class='subtitle1'>Active Products Only</a> -- shows current listing of all active products.</li>
		<li><a href="http://lms.marcomet.com/app-admin/product/Inventory.jsp?inventory=true" class='subtitle1'>Inventoriable Products Only</a> -- shows current listing of all inventoriable products.</li>
			<li><a href="http://lms.marcomet.com/app-admin/product/Inventory.jsp?initialized=true" class='subtitle1'>Initialized Products Only</a> -- shows current listing of all inventoriable products that have been initialized with a manual inventory count.</li>
			<li><a href="http://lms.marcomet.com/app-admin/product/Inventory.jsp?active=true&inventory=true" class='subtitle1'>Active, Inventoriable Products Only</a></li>			
			<li><a href="http://lms.marcomet.com/app-admin/product/Inventory.jsp?active=true&inventory=true&initialized=true" class='subtitle1'>Active, Inventoriable, Initialized Products Only</a></li>
	</ul>
				<%}%>
			</ul>
		</td>
	</tr>
	<tr>
		<td class="subtitle">Other:</td>
	</tr>
	<tr>
		<td>
			<ul class='list'>
				<li><a href="/app-admin/index.jsp"  class='subtitle1' target='_blank'>Marcomet Application Administration</a></li>
				<li><a href="/popups/MCSiteDirectory.jsp"  class='subtitle1' target='_blank'>Marcomet Site Directory</a></li>
			</ul>
		</td>
	</tr>
-->
</table>
</body>
</html>
