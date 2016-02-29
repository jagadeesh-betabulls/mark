<%@ page errorPage="/errors/ExceptionPage.jsp" %>
<%@ page import="com.marcomet.catalog.*;" %>
<%@ taglib uri="/WEB-INF/tld/taglib.tld" prefix="taglib" %>

<jsp:useBean id="validator" class="com.marcomet.tools.FieldValidationBean" scope="page" />
<jsp:useBean id="cB" class="com.marcomet.beans.SBPContactBean" scope="page" />
<jsp:useBean id="formater" class="com.marcomet.tools.FormaterTool" scope="page" />

<jsp:setProperty name="cB" property="*"/>  
<%
	//load up required fields always present
	String[] flds= {"firstName","lastName","addressMail1","cityMail","zipcodeMail","email"};
if (((ShoppingCart)session.getAttribute("shoppingCart")).getOrderEscrowTotal()>0){
//	flds.add("ccNumber");
}

	validator.setReqTextFields(flds);	
    String[] ipflds = {"newUserName","newPassword"}; 
	validator.setReqTextFieldsIP(ipflds);
	String[] reqCheckBoxesIP = {"userAgreement"};
	validator.setReqCheckBoxesIP(reqCheckBoxesIP);
	//String[] numFlds = {""};
	//validator.setNumberFields(numFlds);
	//String[] zipcodeFlds = {"zipcodeMail"};
	//validator.setZipcodeFields(zipcodeFlds);
	String[] passwords = {"newPassword","newPasswordCheck"};
	validator.setPasswordMatchesIP(passwords);

	//if is null, first time here, or is "" due to return from login.
	if(request.getParameter("firstName")==null || request.getParameter("firstName").trim().equals("")){
		cB.setContactId((String)session.getAttribute("contactId"));
	}
%>
<html>
<head>
<title>Order Check Out</title>
<META HTTP-EQUIV="pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Pragma-directive" CONTENT="no-cache">
<META HTTP-EQUIV="cache-directive" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="<%=(String)session.getAttribute("siteHostRoot")%>/styles/vendor_styles.css" type="text/css">
</head>
<script language="JavaScript">
	function submitLogin(){
		document.forms[0].action ="/servlet/com.marcomet.users.security.LoginUserServlet";
		document.forms[0].$$Return.value= "[/catalog/checkout/OrderCheckOutForm.jsp]";
		document.forms[0].submit();
	}
</script>
<jsp:getProperty name="validator" property="javaScripts" />
<script language="JavaScript" src="/javascripts/mainlib.js"></script>
<body bgcolor="#FFFFFF" text="#000000"  onLoad="populateTitle('Order Checkout')" background="<%=(String)session.getAttribute("siteHostRoot")%>/images/back3.jpg">
<div id="waitSection" style="display: 'none';">
<br><br><br><br><br><br>
  <div align="center"> 
    <h2>Please Standby<img src="/images/generic/dotdot.gif" width="72" height="10"></h2>
  </div>
</div>
<div id="formSection" style="display: '';"><p class="Title">Process Jobs Confirmation</p>
<form method="post" action="/servlet/com.marcomet.sbpprocesses.ProcessJobSubmit" >
<input type="hidden" name="nextStepActionId" value="">
<input type="hidden" name="jobId" value="0">
<input type="hidden" name="defaultRoleId" value="1">
<input type="hidden" name="errorPage" value="/catalog/checkout/OrderCheckOutForm.jsp">
<input type="hidden" name="dollarAmount" value="<%= ((ShoppingCart)session.getAttribute("shoppingCart")).getOrderEscrowTotal()%>">
<input type="hidden" name="companyId" value="<%=cB.getCompanyIdString()%>">
<input type="hidden" name="$$Return" value="[/catalog/checkout/ThankYouForOrder.jsp]">
<input type="hidden" name="formChangedPhones" value="<%= (request.getParameter("formChangedPhones") == null )?"0":request.getParameter("formChangedPhones") %>">
<input type="hidden" name="formChangedLocations" value="<%= (request.getParameter("formChangedLocations") == null )?"0":request.getParameter("formChangedLocations") %>">
<input type="hidden" name="formChangedContact" value="<%= (request.getParameter("formChangedCompany") == null )?"0":request.getParameter("formChangedContact") %>">
<input type="hidden" name="formChangedCompany" value="<%= (request.getParameter("formChangedCompany") == null )?"0":request.getParameter("formChangedCompany") %>">

<table align="center" width="80%" class=label>
<% if(session.getAttribute("contactId") == null){ %>
	<tr>
		<td colspan="4">
			I'm a returning Registered User
		</td>
	</tr>
	<tr>	
		
      <td colspan="4" height="32">
	  	  <input type="text" name="userName" value="">
          <input type="password" name="password" value="">
          <a href="javascript:submitLogin()" class="menuLINK" >Login</a> --or 
          Complete the Information Below-- </td>
	</tr>
<%	} else { %>
	<tr>
		<td colspan="4">&nbsp; </td>
	</tr>
<% } %>	</table>
    <table align="center" width="80%" class=label>
	<tr>
		<td colspan="4" height="31"> <span class="catalogTITLE">Please ensure 
          all information is correct. * = Required Information</span><font color="red"><span class="catalogTITLE"> 
          </span><%= (request.getAttribute("errorMessage")==null)?"":(String)request.getAttribute("errorMessage")%></font></td>
	</tr>
	<tr>
		<td colspan="4" class="subtitle1">User Information</td>	
	<tr>
	</tr>	
      <td height="22">Title:</td>
    	
      <td height="22" colspan="3"> 
			<taglib:LUDropDownTag dropDownName="titleId" table="lu_titles" extra="onChange=\"formChangedArea('Contact')\"" selected="<%= cB.getTitleIdString()%>"/>
      </td>
	</tr>
	<tr>
		<td>First &amp; Last Name: *</td>
		
      <td colspan="3"> 
        <input name="firstName" type="text" size="20" max="20" value="<%= cB.getFirstName() %>" onChange="formChangedArea('Contact')">
        <input name="lastName" type="text" size="30" max="30" value="<%= cB.getLastName() %>" onChange="formChangedArea('Contact')">
		</td>
	</tr>
	<tr>
		<td>Company Name: *</td>
		<td colspan="3"><input name="companyName" type="text" size="32" max="64" value="<%= cB.getCompanyName() %>" onChange="formChangedArea('Company')"></td>
	</tr>
	<tr>
		<td>Wyndham Site #: </td>
		<td colspan="3"><input name="siteNumber" type="text" size="10" max="64" value="<%= cB.getSiteNumber() %>" onChange="formChangedArea('Contact')"></td>
	</tr>
	<tr>
		<td>Property Management Site #: </td>
		<td colspan="3"><input name="pmSiteNumber" type="text" size="10" max="64" value="<%= cB.getPMSiteNumber() %>" onChange="formChangedArea('Contact')"></td>
	</tr>
	<tr>
		<td>Job Title:</td>
		<td colspan="3"><input type="text" name="jobTitle" size="20" max="20" value="<%= cB.getJobTitle() %>" onChange="formChangedArea('Contact')"></td>
	</tr>
	<tr>
		
        <td>E-mail: *</td>
		
      <td colspan="3">
<input type="text" name="email" value="<%= cB.getEmail() %>" onChange="formChangedArea('Contact')"></td>
	</tr>
	<tr>
		<td>Website Address:</td>
		<td colspan="3"><input type="text" name="companyURL" value="<%= cB.getCompanyURL() %>" onChange="formChangedArea('Company')"></td>
	</tr>		
	<tr>
		<td colspan="4" class="subtitle1">Mailing Address:</td>
	</tr>	
	<tr>
		
        <td width="27%">Address: *</td>
		<td colspan="3">
			<input type="text" name="addressMail1" size=56 max=200 value="<%= cB.getAddressMail1() %>" onChange="formChangedArea('Locations')"><br>
        	<input type="text" name="addressMail2" size=56 max=200 value="<%= cB.getAddressMail2() %>" onChange="formChangedArea('Locations')">
   		</td>
	</tr>
	<tr>
    	
        <td width="27%">City, State &amp; Zip: *</td>
      	<td colspan="3">

        <input type="text" name="cityMail" value="<%= cB.getCityMail() %>" onChange="formChangedArea('Locations')">
        , 
		<taglib:LUDropDownTag extra="onChange=\"formChangedArea('Locations')\"" dropDownName="stateMailId" table="lu_abreviated_states" selected="<%= cB.getStateMailId()%>" /> 
        <input type="text" name="zipcodeMail" value="<%= cB.getZipcodeMail() %>" onChange="formChangedArea('Locations')">
		</td>
	</tr>
	<tr>
		<td>Country: *</td>
		<td colspan="3">
			<taglib:LUDropDownTag dropDownName="countryMailId" table="lu_countries"  extra="onChange=\"formChangedArea('Locations')\""  selected="<%= cB.getCountryMailId()%>"/>
		</td>
	</tr>	
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>	
	<tr>
		<td colspan="3"><span class="subtitle1">Billing Information:</span>*</td>
      <td width="63%"> 
        <input type="checkbox" value="true" name="sameAsAbove" <%= (cB.getSameAsAbove())?"checked":""%> onClick="formChangedArea('Locations')">Same as above</td>
	</tr>
	<tr>		
      <td width="27%">Address:</td>				
      <td colspan="3"> 
        <input type="text" name="addressBill1" size=56 max=200 value="<%= cB.getAddressBill1() %>" onChange="formChangedArea('Locations')" ><br>
       	<input type="text" name="addressBill2" size=56 max=200 value="<%= cB.getAddressBill2() %>" onChange="formChangedArea('Locations')" >
      	</td>
	</tr>
	<tr>    	
      <td width="27%">City, State &amp; Zip:</td>      	
      <td colspan="3"> 
        <input type="text" name="cityBill" value="<%= cB.getCityBill() %>" onChange="formChangedArea('Locations')">
        , 
		<taglib:LUDropDownTag dropDownName="stateBillId" table="lu_abreviated_states" extra="onChange=\"formChangedArea('Locations')\"" selected="<%= cB.getStateBillId()%>" /> 
        <input type="text" name="zipcodeBill" value="<%= cB.getZipcodeBill() %>" onChange="formChangedArea('Locations')">
		</td>
	</tr>
	<tr>
		<td>Country:</td>
		<td colspan="3"><taglib:LUDropDownTag dropDownName="countryBillId" table="lu_countries"  extra="onChange=\"formChangedArea('Locations')\"" selected="<%= cB.getCountryBillId()%>" /></td>
	</tr>	
	<tr>
		<td colspan="4"><%= (request.getParameter("ccerrormessage")==null)?"":request.getParameter("ccerrormessage")%></td>
	</tr>
	<tr><td colspan=4><hr size=1></td></tr>
<%if (((ShoppingCart)session.getAttribute("shoppingCart")).getOrderEscrowTotal()>0){%>
	<tr> 
        <td valign="top" class="subtitle1">Order Total:</td>
        <td colspan=3><%= formater.getCurrency(((ShoppingCart)session.getAttribute("shoppingCart")).getOrderEscrowTotal()) %><font color="#FF0000"></font></td>
      </tr>	
<tr><td colspan=4><hr size=1></td></tr>

	<tr>
		<td colspan="4" height="30" class="subtitle1">Credit Card Information:</td>
	</tr>
	<tr>
		
        <td width="27%">Credit Card Type: *</td>
		<td colspan="3">
			<taglib:LUDropDownTag dropDownName="ccType" table="lu_credit_cards" selected="<%= (request.getParameter(\"ccType\")==null)?\"\":request.getParameter(\"ccType\")%>"/>
		</td>
	</tr>	
	<tr>		
        <td width="27%">Credit Card Number: *</td>		
      <td colspan="3"> 
        <input type="text" name="ccNumber" value="<%= (request.getParameter("ccNumber")==null)?"0":request.getParameter("ccNumber")%>" size="19">
      </td>		
	</tr>
	<tr>		
        <td width="27%">Credit Card Exp. Date: *</td>		
      <td colspan="3"> Month: 
        <select name="ccMonth">
				<option value="01">January</option>

				<option value="02">February</option>
				<option value="03">March</option>
				<option value="04">April</option>
				<option value="05">May</option>
				<option value="06">June</option>
				<option value="07">July</option>
				<option value="08">August</option>
				<option value="09">September</option>
				<option value="10">October</option>				
				<option value="11">November</option>
				<option value="12">December</option>				
        	</select>
        	Year: 
			<select name="ccYear">
				<option value="01">2001</option>
				<option value="02">2002</option>
				<option value="03">2003</option>
				<option value="04">2004</option>
				<option value="05">2005</option>
				<option value="06">2006</option>
				<option value="07">2007</option>
				<option value="08">2008</option>
				<option value="09">2009</option>
				<option value="10">2010</option>
        	</select>
		</td>
	</tr>
<%}%>
<%-- </table>
<table align="center" width="80%" class=label>	 --%>
	<tr>
		
        <td width="27%">Phone: * 
          <input type="hidden" name="phoneCount" value="3">
		</td>
		<td colspan="3">
			<taglib:LUDropDownTag dropDownName="phoneTypeId0" table="lu_phone_types" extra="onChange=\"formChangedArea('Phones')\"" selected="<%= cB.getPhoneTypeIdString(0)%>"/>	   
          <input type="text" name="areaCode0" size="3" value="<%= cB.getAreaCode(0) %>" onChange="formChangedArea('Phones')">
          <input type="text" name="prefix0" size="4" value="<%= cB.getPrefix(0) %>" onChange="formChangedArea('Phones')">
          <input type="text" name="lineNumber0" size="5" value="<%= cB.getLineNumber(0) %>" onChange="formChangedArea('Phones')">
          ex:
          <input type="text" name="extension0" size="4" value="<%= cB.getExtension(0) %>" onChange="formChangedArea('Phones')">
          <br>
			<taglib:LUDropDownTag dropDownName="phoneTypeId1" table="lu_phone_types" extra="onChange=\"formChangedArea('Phones')\"" selected="<%= cB.getPhoneTypeIdString(1)%>"/>	   
          <input type="text" name="areaCode1" size="3" value="<%= cB.getAreaCode(1) %>" onChange="formChangedArea('Phones')">
          <input type="text" name="prefix1" size="4" value="<%= cB.getPrefix(1) %>" onChange="formChangedArea('Phones')">
          <input type="text" name="lineNumber1" size="5" value="<%= cB.getLineNumber(1) %>" onChange="formChangedArea('Phones')">
          ex:
          <input type="text" name="extension1" size="4" value="<%= cB.getExtension(1) %>" onChange="formChangedArea('Phones')">
          <br>
		<taglib:LUDropDownTag dropDownName="phoneTypeId2" table="lu_phone_types" extra="onChange=\"formChangedArea('Phones')\"" selected="<%= cB.getPhoneTypeIdString(2)%>"/>	   												
          <input type="text" size="3" name="areaCode2" value="<%= cB.getAreaCode(2) %>" onChange="formChangedArea('Phones')">
          <input type="text" name="prefix2" size="4" value="<%= cB.getPrefix(2) %>" onChange="formChangedArea('Phones')">
          <input type="text" name="lineNumber2" size="5" value="<%= cB.getLineNumber(2) %>" onChange="formChangedArea('Phones')">
          ex:
          <input type="text" name="extension2" size="4" value="<%= cB.getExtension(2) %>" onChange="formChangedArea('Phones')">
          <br>
        </td>
	</tr>
</table>	
<% if(session.getAttribute("Login") == null){ %>
<table align="center" width="80%" class=label>
	<tr>		
        <td colspan=4 height="30" class="subtitle1">New User Section</td>
	</tr>
	<tr>
		<td>Choose Login Name: *</td>
		<td colspan="3"><input type="text" name="newUserName" value="<%=cB.getNewUserName()%>"></td>
	</tr>
	<tr>
		<td>Choose Password: *</td>
		<td><input type="password" name="newPassword" value=""></td>
		<td>Confirm: *</td>
		<td><input type="password" name="newPasswordCheck" value=""></td>
	</tr>
 	<tr>
        <td colspan="4">I have read and agree to the <a href="javascript:pop('/legal/terms_page_1.jsp','600','650')" class="minderACTION">MarComet 
          Site Use Agreement</a> 
          <input type="checkbox" name="userAgreement" value="true">
          &lt;== Please Review and Check to continue.</td>
	</tr>
</table>  

<%	}	%>	

<hr size=1 color=red>
  <table width="50%" align="center">
    <tr>
        <td align="right" width="48%">
          <div align="right"><a href="/catalog/summary/OrderSummary.jsp" class="greybutton">Cancel</a></div>
        </td>
        <td width="4%">&nbsp;</td>
        <td align="left" width="48%">
          <div align="left"><a href="javascript:moveWorkFlow('1')" class="greybutton">Submit 
            Jobs</a></div>
        </td>
    </tr>
  </table>
</form>
</div>
</body>
<% if(session.getAttribute("contactId") != null && session.getAttribute("useCC") != null && session.getAttribute("useCC").toString().equals("0")){ %>
<script>moveWorkFlow('1');</script>
<%}%>
</html>
