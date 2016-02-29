<%@ page errorPage="/errors/ExceptionPage.jsp" %>
<%@ page import="java.util.*,java.sql.*,com.marcomet.tools.*,com.marcomet.environment.*,com.marcomet.users.admin.*,com.marcomet.users.security.*;" %>
<%@ taglib uri="/WEB-INF/tld/iterationTagLib.tld" prefix="iterate" %>
<jsp:useBean id="sl" class="com.marcomet.tools.SimpleLookups" scope="page" />
<jsp:useBean id="formatter" class="com.marcomet.tools.FormaterTool" scope="page" />
<jsp:useBean id="str" class="com.marcomet.tools.StringTool" scope="page" /><%
SiteHostSettings shs = (SiteHostSettings)session.getAttribute("siteHostSettings"); 

Connection conn = com.marcomet.jdbc.DBConnect.getConnection();
Statement st = conn.createStatement();
Statement st2 = conn.createStatement();
Statement st3 = conn.createStatement();
int prodNum=0;
boolean editor= ((((RoleResolver)session.getAttribute("roles")).roleCheck("editor")) && (request.getParameter("editor")!=null && request.getParameter("editor").equals("true")));
boolean showInfo=((session.getAttribute("proxyId")!=null || (((RoleResolver)session.getAttribute("roles")).roleCheck("editor")) )?true:false);
boolean sitehost= ((((RoleResolver)session.getAttribute("roles")).isSiteHost()) || (((RoleResolver)session.getAttribute("roles")).roleCheck("editor")));

String downloadText="Download";
String ioNumber=((request.getParameter("ioNumber")==null)?"":request.getParameter("ioNumber"));
String paramSpecId=((request.getParameter("specId")==null)?"":request.getParameter("specId"));
String paramSpecValue=((paramSpecId.equals(""))?"":"&"+paramSpecId+"="+request.getParameter(paramSpecId));

String paramSpecId1=((request.getParameter("specId1")==null)?"":request.getParameter("specId1"));
String paramSpecValue1=((paramSpecId1.equals(""))?"":"&"+paramSpecId1+"="+request.getParameter(paramSpecId1));

String paramSpecId2=((request.getParameter("specId2")==null)?"":request.getParameter("specId2"));
String paramSpecValue2=((paramSpecId2.equals(""))?"":"&"+paramSpecId2+"="+request.getParameter(paramSpecId2));

String paramSpecId3=((request.getParameter("specId3")==null)?"":request.getParameter("specId3"));
String paramSpecValue3=((paramSpecId3.equals(""))?"":"&"+paramSpecId3+"="+request.getParameter(paramSpecId3));

String siteHostRoot=((request.getParameter("siteHostRoot")==null)?(String)session.getAttribute("siteHostRoot"):request.getParameter("siteHostRoot"));
String campaignId=((request.getParameter("campaignId")==null)?"delete":request.getParameter("campaignId"));
String companyId=((request.getParameter("companyId")==null)?(String)session.getAttribute("companyId"):request.getParameter("companyId"));
String siteHostId=((request.getParameter("siteHostId")==null)?shs.getSiteHostId():request.getParameter("siteHostId"));
String prePopId=((request.getParameter("prePopId")==null)?"":request.getParameter("prePopId"));
String prePopTable=((request.getParameter("prePopTable")==null || request.getParameter("prePopTable").equals("null"))?"":request.getParameter("prePopTable"));
String prePopParams=paramSpecValue+paramSpecValue1+paramSpecValue2+paramSpecValue3+((!(prePopId.equals("")) && !(prePopTable.equals("")))?"&prePopTable="+prePopTable+"&prePopId="+prePopId:"");
boolean showChoice=((request.getParameter("showChoice")==null || request.getParameter("showChoice").equals(""))?false:true);
String prodLineId=((request.getParameter("prodLineId")==null)?"":request.getParameter("prodLineId"));
String ShowInactive=( ( (request.getParameter("ShowInactive")==null || request.getParameter("ShowInactive").equals("")) && !(editor) )?" AND p.status_id=2 ":((editor)?" AND (p.status_id<>3 and p.status_id<>4) ":" AND (p.status_id=2 OR p.status_id=9)") ); 
String SuppressFilter=((editor)?"":" show_in_primary_prod_line=1 and "); 
String ShowBrand=((request.getParameter("brandCode")==null || request.getParameter("brandCode").equals(""))?"":" AND p.brand_code= '"+request.getParameter("brandCode")+"'"); 
String ShowRelease=((request.getParameter("ShowRelease")==null || request.getParameter("ShowRelease").equals(""))?"":" AND p.release='"+request.getParameter("ShowRelease")+"' ");
String orderText="Order";
String defaultPropId=((request.getParameter("defaultPropId")==null)?"":request.getParameter("defaultPropId"));
String tempPropId="";
boolean useProdProps=(!(showChoice) && (sl.getValue("site_hosts","id",siteHostId, "use_property_product_filter").equals("1"))?true:false);

%><html>
<head>
<title>Products Page</title>
<link rel="stylesheet" href="/styles/marcomet.css" type="text/css">
<link rel="stylesheet" href="<%=siteHostRoot%>/styles/vendor_styles.css" type="text/css">
<script language="JavaScript" src="/javascripts/mainlib.js"></script>
<link rel="stylesheet" href="/styles/misc_styles.css" type="text/css">
<style>
.saleLINK {
	font-weight: bold;font-size: 8pt;font-family: Arial,Verdana,Geneva;text-decoration: none;text-align: center;width: 8%;padding-left: 10px;padding-right: 10px;padding-top: 5px;padding-bottom: 0px;white-space: nowrap;border: 1px red solid;height: 27px;vertical-align: middle;color:black;
}
.saleLINK {
	font-weight: bold;font-size: 8pt;font-family: Arial,Verdana,Geneva;text-decoration: none;text-align: center;width: 8%;padding-left: 10px;padding-right: 10px;padding-top: 5px;padding-bottom: 0px;white-space: nowrap;border: 1px red solid;height: 27px;vertical-align: middle;color:black;
}
a.saleLINK:link {
	font-weight: bold;font-size: 8pt;font-family: Arial,Verdana,Geneva;text-decoration: none;text-align: center;width: 8%;padding-left: 10px;padding-right: 10px;padding-top: 5px;padding-bottom: 0px;white-space: nowrap;border: 1px red solid;height: 27px;vertical-align: middle;color:black;
}
a.saleLINK:visited {
	font-weight: bold;font-size: 8pt;font-family: Arial,Verdana,Geneva;text-decoration: none;text-align: center;width: 8%;padding-left: 10px;padding-right: 10px;padding-top: 5px;padding-bottom: 0px;white-space: nowrap;border: 1px red solid;height: 27px;vertical-align: middle;color:black;
}
</style>
<script>
function showInfo(){

}
</script>
<%

//Gather all products bridged to properties for the sitehost company:  hProperties
//Create the script to hide and show property materials on demand from dropdown.
Hashtable hProperties=new Hashtable<String,String>();
Hashtable hCProperties=new Hashtable<String,String>();

//Gather all properties to be available to current user based on session properties hashtable: sProperties 
//If hashtable is empty check to see if user has sitehost role - 
		//if YES --> continue and show ALL properties bridged to products for that company in the dropdown
		//if NO --> message user that there appears to be a problem, show NO property dropdown and HIDE ALL property bridged products
//Get the product line info
String sql = ((prodLineId.equals(""))?"SELECT pl.* FROM product_lines pl, products p, site_hosts sh WHERE sh.id= " + siteHostId + " AND sh.company_id=pl.company_id AND pl.id = p.prod_line_id "+ShowRelease+ShowInactive+ShowBrand+" GROUP BY pl.id ORDER BY pl.id":"SELECT * FROM product_lines where  id="+prodLineId);
ResultSet rsProdLine = st2.executeQuery(sql);

while(rsProdLine.next()){
  if (useProdProps){
  	String contPropSQL="Select * from v_contact_properties where property_code<>0 and contact_id="+(String)session.getAttribute("contactId")+" order by property_code";
	ResultSet rsContProds = st.executeQuery(contPropSQL);
	int cnt=0;
	while(rsContProds.next()){
		hCProperties.put(rsContProds.getString("title"),rsContProds.getString("property_code"));
		cnt++;
	}

	boolean useFullList=(hCProperties.size()==0 && sitehost);

	String prodpropSQL="SELECT distinct property_id,property_code,title FROM v_product_properties p  left join product_line_bridge pb on pb.prod_id=p.prod_id where company_id="+sl.getValue("site_hosts","id",siteHostId, "company_id")+" AND (("+SuppressFilter+" (p.prod_line_id="+rsProdLine.getString("id")+" or p.prod_line_id="+rsProdLine.getString("top_level_prod_line_id")+")) or pb.prod_line_id="+rsProdLine.getString("id")+") "+ShowRelease+ShowInactive+" ORDER BY property_code desc";
	ResultSet rsPropProds = st.executeQuery(prodpropSQL);
	while(rsPropProds.next()){
		hProperties.put(rsPropProds.getString("title"),rsPropProds.getString("property_code")+"|"+rsPropProds.getString("title"));
	}
	useProdProps=(useProdProps && hProperties.size()>0);
}

%></head>
<body topmargin="0" bgcolor=white><%if (useProdProps){%><form method=post><%}%><%=((showChoice)?"<br><div class=Title>STEP 2: PRODUCT CHOICE<br>Check box next to products to be included, Click Next at bottom of page.</div>":"") %><%
if (!showChoice){
	%><div align="right" width=90%><a href="javascript:history.go(-2)" class="menuLINK">&laquo;&nbsp;Back&nbsp;</a> <a href="mailto:marketingsvcs@marcomet.com" class="menuLINK">&nbsp;Email Support&nbsp;</a></div><%
	}
String backorderaction="";
String backorderText="";
String invSQL="";
String statusTxt="Active (2)";
String statusColor="white";
int invAmount=0;
int onOrderAmount=0;

	String prod_line_name=rsProdLine.getString("prod_line_name");
%><table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" dwcopytype="CopyTableRow">
<tr>
    <td width="61%" height="35" valign="middle"><div id='release' class="Title" align="left"></div></td>
  </tr>
</table>
<table width="95%" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td class="body" ><%if (editor){%><a href='javascript:pop("/popups/QuickChangeHTMLForm.jsp?cols=80&rows=10&question=Change%20Product%20Line%20Description&primaryKeyValue=<%=rsProdLine.getString("id")%>&columnName=description&tableName=product_lines&valueType=string",600,500)'>&raquo;</a>&nbsp;<%}%><%=((rsProdLine.getString("description")==null || rsProdLine.getString("description").equals(""))?"":rsProdLine.getString("description"))%></td>
  </tr><%if (request.getParameter("showSearch")!=null){%>
    <tr>
    <td class="subtitle">Don't see what you want? <a href="http://www.promoplace.com/ws/ws.dll?DistID=5393" class='greybutton'>&raquo;&nbsp;Click Here to SEARCH for NEW ITEMS...</a></td>
  </tr><%}%>
  <tr>
    <td class="body" ><%=((rsProdLine.getString("usp")==null || rsProdLine.getString("usp").equals(""))?"":rsProdLine.getString("usp"))%></td>
  </tr>
</table>
<%
if(editor) {
%><a href='javascript:pop("/popups/QuickChangeAddProductToLine.jsp?question=Add%20Product%20To%20Line&primaryKeyValue=<%=rsProdLine.getString("id")%>",700,150)' class=greybutton> + Add Product to this Line </a>
<a href='javascript:history.go(-1)' class=greybutton> Review Page </a><br><div class=subTitle>(9) ON HOLD=Show with next release (Client sees it on demo; (1) DRAFT=Hold Indefinitely (Client won't see it on demo)</div><%
}

if(!(editor) && (((RoleResolver)session.getAttribute("roles")).roleCheck("editor"))){
	%><a href='javascript:location.href=location.href+"&editor=true"' class=greybutton> Edit Page </a><%
}

//Product Line Presentation Table:
%><table border=1 cellpadding=5 cellspacing=0 width=90% align="center">
  <tr style='display:visible'>
    <td valign="top" <%=(((hCProperties.size()>0 || (hCProperties.size()==0 && sitehost)) && useProdProps)?"":"colspan='2'")%> class="menuLINKText" height="30">
		<div align="left" ><strong>&nbsp;&nbsp;<%=((rsProdLine.getString("mainfeatures")==null)?"":rsProdLine.getString("mainfeatures"))%></strong></div>
	</td><%
	
	//If there are property-specific products and the user has the rights to see them:
	if((hCProperties.size()>0 || (hCProperties.size()==0 && sitehost)) && useProdProps){
	
	%><td valign="top" class="menuLINKText" height="30">
		<%if (ioNumber.equals("")){%><div align="right" >Show Materials for Property:&nbsp;<select name='defaultPropId' onChange="document.forms[0].submit()"><%
		}else{
			%><div align="left" ><%=((ioNumber.equals(""))?"":"Choose Ad for Insertion #"+ioNumber)%><%
		}
		String options="";
		//Enumeration e = hProperties.keys();
		Vector v = new Vector(hProperties.keySet());
    	Collections.sort(v);
    	Iterator e = v.iterator();
		int c=0;
    	while (e.hasNext()) {
			String tempProp=(String)e.next();		
			if (hCProperties.get(tempProp)!=null || sitehost){
				tempPropId=(String)hProperties.get(tempProp);
				String viewStr=tempPropId.substring(tempPropId.indexOf("|",0)+1,tempPropId.length());
				tempPropId=tempPropId.substring(0,tempPropId.indexOf("|",0));
				options+="<option "+((tempPropId.equals(defaultPropId) || defaultPropId.equals(""))?"Selected":"")+" value='"+tempPropId+"'>"+viewStr+"</option>";
				c++;
			}
		}
		defaultPropId=((defaultPropId.equals(""))?tempPropId:defaultPropId);
		if (c>1 && 2==1){
			options="<option value='0'>Show All</option>"+options;
		}
		if(ioNumber.equals("")){
			%><%=options%></select><%
		}%></div>
	</td><%
	
	}
	
	%></tr><%
		String sql2 = "SELECT pbr.property_code,p.csr_notes csr_notes, p.std_lead_time std_lead_time, p.internal_notes internal_notes,ppb.property_code, vp.title 'sale_title',vp.sale_id 'sale_id', show_in_primary_prod_line,p.prod_line_id prod_line_id,p.status_id,p.id lineId, 'products' lineTable, p.inventory_amount,p.inventory_initialized,p.inv_on_order_amount,p.backorder_action,p.hide_order_button,p.inventory_product_flag,if(p.root_inv_prod_id=0,p.id,p.root_inv_prod_id) root_inv_id, pr.display_title,p.sequence sequence, if(p.backorder_notes is null,'',p.backorder_notes) backorder_notes, p.headline,p.company_id,p.root_prod_code, lbs.presentation_language brand_standard,round(min(pp.price/pp.quantity),2) priceper, p.id,p.prod_name,p.product_features,p.prod_code,if(p.image_coming_soon=1,concat(p.brand_code,'coming_soon.jpg'),p.small_picurl) 'small_picurl',p.offering_id,p.price_list,p.spec_diagram_picurl,if(p.image_coming_soon=1,concat(p.brand_code,'coming_soon.jpg'),p.full_picurl) 'full_picurl',p.download_url,p.detailed_description FROM products p  left join product_property_bridge pbr on p.id=pbr.product_id left join product_property_bridge ppb on ppb.product_id=p.id and ppb.property_company_id=p.company_id left join v_promo_prods vp on p.id=vp.prod_id and vp.start_date<=now() and vp.end_date>=now() left join lu_brand_std_cat lbs on lbs.id=p.brand_std_cat left join product_releases pr on p.release=pr.release_code and p.company_id=pr.company_id  left join product_prices pp on pp.prod_price_code=p.prod_price_code where "+SuppressFilter+" (prod_line_id="+rsProdLine.getString("id")+" or prod_line_id="+rsProdLine.getString("top_level_prod_line_id")+") "+ShowRelease+ShowInactive+" and (pbr.property_code='"+defaultPropId+"' or pbr.property_code is null) group by p.id union SELECT pbr.property_code,p.csr_notes csr_notes, p.std_lead_time std_lead_time, p.internal_notes internal_notes, ppb.property_code, vp.title 'sale_title',vp.sale_id 'sale_id', show_in_primary_prod_line,p.prod_line_id prod_line_id,p.status_id,pb.id lineId, 'product_line_bridge' lineTable, p.inventory_amount,p.inventory_initialized,p.inv_on_order_amount,p.backorder_action,p.hide_order_button,p.inventory_product_flag,if(p.root_inv_prod_id=0,p.id,p.root_inv_prod_id) root_inv_id, pr.display_title,pb.sequence sequence, if(p.backorder_notes is null,'',p.backorder_notes) backorder_notes, if(pb.headline='',p.headline,pb.headline) headline,p.company_id company_id,p.root_prod_code root_prod_code, lbs.presentation_language brand_standard,round(min(pp.price/pp.quantity),2) priceper,p.id id,p.prod_name prod_name,if(pb.product_features='',p.product_features,pb.product_features) product_features,p.prod_code prod_code,if(p.image_coming_soon=1,concat(p.brand_code,'coming_soon.jpg'),p.small_picurl) 'small_picurl',p.offering_id offering_id,p.price_list price_list,p.spec_diagram_picurl spec_diagram_picurl,if(p.image_coming_soon=1,concat(p.brand_code,'coming_soon.jpg'),p.full_picurl) 'full_picurl',p.download_url,if(pb.detailed_description='',p.detailed_description,pb.detailed_description) detailed_description FROM product_line_bridge pb,products p  left join product_property_bridge pbr on p.id=pbr.product_id left join product_property_bridge ppb on ppb.product_id=p.id and ppb.property_company_id=p.company_id left join v_promo_prods vp on p.id=vp.prod_id and vp.start_date<=now() and vp.end_date>=now() left join lu_brand_std_cat lbs on lbs.id=p.brand_std_cat left join product_releases pr on p.release=pr.release_code and p.company_id=pr.company_id  left join product_prices pp on pp.prod_price_code=p.prod_price_code where pb.prod_id=p.id AND pb.status_id=2 AND (pb.prod_line_id="+rsProdLine.getString("id")+" or pb.prod_line_id="+rsProdLine.getString("top_level_prod_line_id")+")  "+ShowRelease+ShowInactive+" and (pbr.property_code='"+defaultPropId+"' or pbr.property_code is null) group by p.id ORDER BY sequence";
%><!--<%=sql2%>--><%
ResultSet rsProds = st.executeQuery(sql2);
int minAmount=0;
int x=0;
 while (rsProds.next()){ 
	if (x==0){
		%><script>document.getElementById("release").innerHTML='<%=((rsProds.getString("display_title")==null || rsProds.getString("display_title").equals(""))?"":rsProds.getString("display_title")+": <br>")%><%=prod_line_name%>';</script><%
	}
	x++;
	backorderaction="0";
	backorderText="";
	invAmount=0;
	statusTxt=((rsProds.getString("status_id").equals("1"))?" Draft (1) ":((rsProds.getString("status_id").equals("2"))?" Active (2) ":" On Hold ("+rsProds.getString("status_id")+") ") );
	statusColor=( (rsProds.getString("show_in_primary_prod_line").equals("0") && rsProds.getString("lineTable").equals("products") )?"#f0d6ff":((rsProds.getString("status_id").equals("9"))?"#FFFFCC":((rsProds.getString("status_id").equals("2"))?"white":"#FFCCCC") ));
	onOrderAmount=Integer.parseInt(((rsProds.getString("inv_on_order_amount")==null || rsProds.getString("inv_on_order_amount").equals(""))?"0":rsProds.getString("inv_on_order_amount")));
	if ((rsProds.getString("inventory_product_flag").equals("1") || rsProds.getString("hide_order_button").equals("1"))){
		invAmount=Integer.parseInt(((rsProds.getString("inventory_amount")==null || rsProds.getString("inventory_amount").equals(""))?"0":rsProds.getString("inventory_amount")));

		ResultSet rsMinAmount = st3.executeQuery("Select min(pp.quantity) from product_prices pp,products p where pp.prod_price_code=p.prod_price_code and  p.id="+rsProds.getString("id"));
		if (rsMinAmount.next()){
			minAmount=Integer.parseInt(((rsMinAmount.getString(1)==null || rsMinAmount.getString(1).equals(""))?"0":rsMinAmount.getString(1)));
		}

		rsMinAmount.close();

		if ((invAmount - onOrderAmount < minAmount) || rsProds.getString("hide_order_button").equals("1")){ //if product is on backorder
			backorderaction=rsProds.getString("backorder_action"); //1=show notes and allow order, 2=disable order and show prod not available
			if ((rsProds.getString("backorder_action").equals("2"))|| rsProds.getString("hide_order_button").equals("1")){
				backorderText=((rsProds.getString("backorder_notes").equals(""))?((rsProds.getString("hide_order_button").equals("1"))?"See Notes for Ordering":"Product Not Currently Available"):rsProds.getString("backorder_notes"));
									
			}else{
				backorderText=((rsProds.getString("backorder_notes").equals(""))?"Available for Backorder":rsProds.getString("backorder_notes"));
			}
		}
	}else{
		backorderText=((rsProds.getString("backorder_notes") == null || rsProds.getString("backorder_notes").equals("0"))?"":rsProds.getString("backorder_notes"));
	}
	%><tr<%=((editor)?" BGCOLOR="+statusColor:"")%> class='<%=((rsProds.getString("property_code")==null)?"":rsProds.getString("property_code"))%>' style='display:visible' >
    <td valign="top" width=3%><div id="pn<%=x%>" class="tip"><em>Click to add a product note</em><hr>ID: <%=rsProds.getString("id")%> | STD LEAD: <%=rsProds.getString("std_lead_time")%><hr>CSR NOTES:<%=rsProds.getString("csr_notes")%><hr>INTERNAL NOTES:<%=rsProds.getString("internal_notes")%></div><a href="javascript:pop('<%=((rsProds.getString("full_picurl")==null || rsProds.getString("full_picurl").equals(""))?"":""+siteHostRoot+"/fileuploads/product_images/"+ str.replaceSubstring(rsProds.getString("full_picurl")," ","%20"))%>','800','600')" >
		<%=((rsProds.getString("small_picurl")==null || rsProds.getString("small_picurl").equals(""))?"":"<img src='"+siteHostRoot+"/fileuploads/product_images/"+ str.replaceSubstring(rsProds.getString("small_picurl")," ","%20") +"' border=0>")%>
		</a>
		</td>
    <td valign="top" width="73%" align="left"><%
	
	String sql3 = "SELECT * FROM offerings o, offering_sequences os where o.id=os.offering_id and os.sequence=0 and o.id="+(rsProds.getString("offering_id"));
	ResultSet rsOfferings = st3.executeQuery(sql3);
	
%><table width=100% cellpadding=0 cellspacing=0 border=0>
<%
if(editor){
	%><tr><td align=right><%
	if(rsProds.getString("lineTable").equals("product_line_bridge")){
	%><a href='javascript:pop("/popups/QuickChangeAcrossBrandsForm.jsp?cols=5&rows=1&question=Remove%20From%20This%20Product%20Line&primaryKeyValue=<%=rsProds.getString("lineId")%>&columnName=status_id&tableName=<%=rsProds.getString("lineTable")%>&valueFieldVal=9&valueType=string",300,150)' class=greybutton> REMOVE FROM PROD LINE </a><%
	}else{
	%><a href='javascript:pop("/popups/QuickChangeProdLinesDropDown.jsp?question=Change%20Product%20Line&primaryKeyValue=<%=rsProds.getString("lineId")%>&columnName=prod_line_id&valueFieldVal=<%=rsProds.getString("prod_line_id")%>&tableName=products&companyId=<%=rsProds.getString("company_id")%>&valueType=string",500,200)' class=greybutton> CHANGE PROD LINE </a><%
	}
	%><a href='javascript:pop("/popups/QuickChangeAcrossBrandsForm.jsp?cols=5&rows=1&question=Change%20Product%20Position%20In%20List&primaryKeyValue=<%=rsProds.getString("lineId")%>&columnName=sequence&tableName=<%=rsProds.getString("lineTable")%>&valueType=string",300,150)' class=greybutton> SET ORDER [<%=rsProds.getString("sequence")%>] </a><a href='javascript:pop("/popups/QuickChangeDropDown.jsp?cols=4&rows=1&question=Change%20Product%20Status&valueField=id&textField=value&valueFieldVal=<%=rsProds.getString("status_id")%>&luTableName=lu_product_status&compField=1&compValue=1&orderBy=sequence&primaryKeyValue=<%=rsProds.getString("id")%>&columnName=status_id&tableName=products&valueType=int",650,150)' class=greybutton> SET STATUS [<%=((rsProds.getString("status_id")==null)?"":sl.getValue("lu_product_status","id",rsProds.getString("status_id"), "value"))%></a><a href="javascript:popw('/popups/ProductInfo.jsp?productId=<%=rsProds.getString("id")%>',900,700)" class=greybutton> INFO </a></td></tr><%
}
%><tr><td ><%
if (showInfo){
	%><img src='/images/info.gif' onMouseOut='popUpTT(event,"<%="pn"+x%>")' onMouseover='popUpTT(event,"<%="pn"+x%>")' onClick="pop('/popups/QuickChangeAppendForm.jsp?tableName=products&columnName=csr_notes&valueType=String&question=Edit%20CSR%20Notes&rows=5&cols=40&update=y&primaryKeyValue=<%=rsProds.getString("id")%>', '500', '500')"><%
}%><span align='left' class="catalogLABEL"><%=((showChoice)?"<input type='checkbox' name='prodId_"+ prodNum++ +"' value='"+rsProds.getString("id")+"' >&nbsp;":"")%><%

if (editor){%><a href='javascript:pop("/popups/QuickChangeForm.jsp?cols=60&rows=1&question=Change%20Product%20Name&primaryKeyValue=<%=rsProds.getString("id")%>&columnName=prod_name&tableName=products&valueType=string",500,150)'>&raquo;</a>&nbsp;<%
}%><%=rsProds.getString("prod_name")%>&nbsp;-&nbsp;<%=rsProds.getString("prod_code")%><%=((rsProds.getString("property_code")==null)?"":" | For Property #"+rsProds.getString("property_code"))%></td></tr></table>
<div class="subtitle">
	<%=((rsProds.getString("brand_standard")!=null && !rsProds.getString("brand_standard").equals(""))?"<em><span style='color:red'>"+rsProds.getString("brand_standard")+"</em></span><br>":"")%>		
	<%=((rsProds.getString("headline")!=null && !rsProds.getString("headline").equals(""))?rsProds.getString("headline")+"<br>":"")%> 
	<%=((rsProds.getString("product_features")!=null && !rsProds.getString("product_features").equals(""))?rsProds.getString("product_features")+"<br>":"")%>
</div>
<div class="bodyBlack"><%
if (editor){
	%><a href='javascript:pop("/popups/QuickChangeForm.jsp?cols=60&rows=6&question=Change%20Product%20Description&primaryKeyValue=<%=rsProds.getString("id")%>&columnName=detailed_description&tableName=products&valueType=string",500,200)'>&raquo;</a>&nbsp;<%
}
%><%=((rsProds.getString("detailed_description")!=null)?rsProds.getString("detailed_description"):"")%>
</div><br /><%
%>
<table width=100% cellpadding=0 cellspacing=0 border=0><tr><td align='left'>
<a href="javascript:pop('<%=((rsProds.getString("full_picurl")==null || rsProds.getString("full_picurl").equals(""))?"":""+siteHostRoot+"/fileuploads/product_images/"+ str.replaceSubstring(rsProds.getString("full_picurl")," ","%20"))%>','800','600')" class='menuLINK'>
<%=((rsProds.getString("small_picurl")==null || rsProds.getString("small_picurl").equals(""))?"":"Enlarge&nbsp;Product&nbsp;Image")%></a>
<%=((rsProds.getString("spec_diagram_picurl")==null || rsProds.getString("spec_diagram_picurl").equals(""))?"":"<a class='menuLINK' href=\"javascript:pop('"+siteHostRoot+"/fileuploads/product_images/"+ str.replaceSubstring(rsProds.getString("spec_diagram_picurl")," ","%20") +"','800','600')\" >"+((rsProds.getString("spec_diagram_picurl")==null || rsProds.getString("spec_diagram_picurl").equals(""))?"":"View&nbsp;Back") + "</a>")%>
</td><%if ((rsProds.getString("sale_title") !=null && !rsProds.getString("sale_title").equals(""))){
orderText=((rsProds.getString("download_url")!=null && !rsProds.getString("download_url").equals(""))?downloadText:((rsProds.getString("sale_title").toUpperCase().indexOf("PREORDER")>0)?"Preorder":"Order"));
%><td align=center><a href="javascript:pop('/popups/promoDetails.jsp?id=<%=rsProds.getString("sale_id")%>',600,400)"  class='saleLINK'><%=rsProds.getString("sale_title")%> - Click for Details</a></td><%}else{orderText=((rsProds.getString("download_url")!=null && !rsProds.getString("download_url").equals(""))?downloadText:"Order");}%><td align='right'><%
String priceList=((rsProds.getString("price_list")==null || rsProds.getString("price_list").equals(""))?"":((rsProds.getString("price_list").indexOf("<a")>-1)?"<a class='menuLINK' "+rsProds.getString("price_list").substring(3,rsProds.getString("price_list").length()):"<a href=\"javascript:pop('/images/pricing/"+rsProds.getString("price_list")+"','550','400')\"  class='menuLINK'>Price List</a>"));

%><%=priceList%><%=((backorderText.equals(""))?"":"<span class='subTitle' style='color:Red;'>"+backorderText+"</span>&nbsp;")%><%

if (Integer.parseInt(((backorderaction==null || backorderaction.equals(""))?"0":backorderaction))<2  && !showChoice && !(rsProds.getString("hide_order_button").equals("1"))){

	if (rsProds.getString("download_url")==null || rsProds.getString("download_url").equals("")){
		%><a href= "/frames/InnerFrameset.jsp?contents=/servlet/com.marcomet.catalog.CatalogNavigationServlet?offeringId=<%=rsProds.getString("offering_id")%>&jobTypeId=<%=((rsOfferings.next())?rsOfferings.getString("job_type_id"):"")%>&serviceTypeId=<%=rsOfferings.getString("service_type_id")%>&productId=<%=rsProds.getString("id")%><%=prePopParams%>" target="_top" class="menuLINK"><%=orderText%>&nbsp;&raquo;</a><%
	}else{
		%><a href="<%=siteHostRoot+"/fileuploads/product_images/"+ str.replaceSubstring(rsProds.getString("download_url")," ","%20")%>" target="_blank" class="menuLINK"><%=downloadText%></a><%	
	}

}%></td></tr></table>
	</td></tr><%
 } %></table><% } 
if (showChoice){
	%><input type='hidden' name='pagename' value='<%=campaignId%>'>
	<input type='hidden' name='numProds' value='<%=prodNum%>'><br>
	<%
	}else{%><hr width="82%" size="1">
<div align="center"><font size="1">Need help? We are here 9am-5pm, M-F, EST. Marketing Specialists<b>:</b> email <a href="mailto:marketingsvcs@marcomet.com"><u>marketingsvcs@marcomet.com</u></a> or
    leave a Voice Message Alert: at 1-888-777-9832, option 2.<br>
  To order by phone call a Customer Service Representative at 1-888-777-9832,
  option 3.<br>
  Technical Support? <a href="mailto:techsupport@marcomet.com"><u>techsupport@marcomet.com</u></a> or
  1-888-777-9832 option 4. Comments? Please email us <a href="mailto:comments@marcomet.com"><u>comments@marcomet.com</u></a></font></div>
<%}

if (useProdProps){%></form><%}

%></body>
</html><%

st.close();
st2.close();
st3.close();
conn.close();%>
