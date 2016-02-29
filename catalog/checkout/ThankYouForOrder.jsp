<%@ page errorPage="/errors/ExceptionPage.jsp" %>
<%
//if this page was entered as a result of a self-help designed file run remove the 'usePreview' and 'selfDesigned' attributes from session.
boolean selfDesigned=((session.getAttribute("selfDesigned")!=null && session.getAttribute("selfDesigned").toString().equals("true"))?true:false);
if(session.getAttribute("selfDesigned")!=null && session.getAttribute("selfDesigned").toString().equals("true")){
	session.removeAttribute("usePreview");
	session.removeAttribute("selfDesigned");
}
String homeLink=((session.getAttribute("baseURL")!=null)?"http://"+session.getAttribute("baseURL")+"/":"/");
String orderId=((request.getAttribute("orderId")==null)?((request.getParameter("orderId")==null)?"0":request.getParameter("orderId")):request.getAttribute("orderId").toString());
String payType=((request.getParameter("pay_type")==null)?"account":request.getParameter("pay_type"));
String ccNumberMasked = ((request.getParameter("ccNumberMasked")!=null)?request.getParameter("ccNumberMasked"):((request.getParameter("ccNumber")==null || request.getParameter("ccNumber").length()<5)?"":request.getParameter("ccNumber").substring(request.getParameter("ccNumber").length()-4,request.getParameter("ccNumber").length())));
String ccMonth=((request.getParameter("ccMonth")==null)?"":request.getParameter("ccMonth"));
String ccYear=((request.getParameter("ccYear")==null)?"":request.getParameter("ccYear"));
String pastref=((request.getParameter("pastref")==null)?"":request.getParameter("pastref"));
String ccType=((request.getParameter("ccType")==null)?"Other Card":request.getParameter("ccType"));
String totalDollarAmount=((request.getParameter("totalDollarAmount")==null)?"0":request.getParameter("totalDollarAmount"));
String pastACref=((request.getParameter("pastACref")==null)?"0":request.getParameter("pastACref"));
String bankName=((request.getParameter("bankName")==null)?"0":request.getParameter("bankName"));
String accountNumber=((request.getParameter("accountNumber")==null)?"0":request.getParameter("accountNumber"));


if (session.getAttribute("promoCode")!=null){
	session.removeAttribute("promoCode");
}
String finalFileAddress=((request.getAttribute("finalFileAddress")==null)?"":request.getAttribute("finalFileAddress").toString());

boolean rePrint=((session.getAttribute("reprintJob")==null || session.getAttribute("reprintJob").toString().equals("") || session.getAttribute("reprintJob").toString().equals("false"))?false:true);

String jobId=((request.getAttribute("jobId")==null)?"":request.getAttribute("jobId").toString());
boolean fileSaved=((finalFileAddress.equals(""))?false:true);
if(!jobId.equals("") && !finalFileAddress.equals("")){
	%>
	<jsp:include page="/catalog/moveTempImageFiles.jsp" flush="true" >
		<jsp:param name="id" value="<%=jobId%>" />
	</jsp:include><%
	
//if this file should be immediately printed go to the reprint page.
}

if(rePrint){
%>
<html><head><script>window.location.replace("/catalog/reprintJobsFromFile.jsp?gtc=true&jobId=<%=jobId%>")</script></head></html>

<%	
}else{

%>
<html>
<head>
<title><%=((selfDesigned)?"File Saved":"Order")%> Confirmation</title>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> 
  <link rel="stylesheet" href="<%=(String)session.getAttribute("siteHostRoot")%>/styles/vendor_styles.css" type="text/css">
</head>
<script language="javascript" src="/javascripts/mainlib.js"></script>
<body style="margin-left:10px;" topmargin="10" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('/images/buttons/continueover.gif')" background="<%=(String)session.getAttribute("siteHostRoot")%>/images/back3.jpg">
<script type="text/javascript">
/* <![CDATA[ */
var google_conversion_id = 1005192787;
var google_conversion_language = "en";
var google_conversion_format = "3";
var google_conversion_color = "ffffff";
var google_conversion_label = "GvRDCPWv1wEQ04yo3wM";
var google_conversion_value = 0;
/* ]]> */
</script>
<script type="text/javascript" src="https://www.googleadservices.com/pagead/conversion.js">
</script>
<noscript>
<div style="display:inline;">
<img height="1" width="1" style="border-style:none;" alt="" src="https://www.googleadservices.com/pagead/conversion/1005192787/?label=GvRDCPWv1wEQ04yo3wM&amp;guid=ON&amp;script=0"/>
</div>
</noscript>
<%if(fileSaved){%>
<jsp:include page="/catalog/SHDCHeader.jsp" flush="true" >
	<jsp:param name="subTitle" value="File Saved" />
</jsp:include>
<%}%>
<div style="display:none;" id="pdfPrepDiv"><iframe height="0" width="0" marginwidth="0" marginheight="0" frameborder="0" id="pdfPrep" name="downloads" ></iframe></div>
<table height="100%" width="100%">
  <tr> 
    <td valign="top"> 

    </td>
  </tr>
  <tr> 
    <%
    if(selfDesigned){
    %>

<!--  Commented out by CSA to replace non-working code with a temporary workaround
<td align="center" class="catalogLABEL"><p class="bodyBlack"><blockquote>Your file has been saved. You may download it now by clicking on the link below, or at anytime in the future by going to your 'Self-Help Designed Files' under the FILES menu.<br> Click 'Continue' to return to your marketing site home page.</blockquote></p><br>
      <div align="center"><a href="/popups/downloadOneFile.jsp?dlFile=<%=finalFileAddress%>" class="plainLink" target="downloads">&nbsp;DOWNLOAD FILE&nbsp;&raquo;</a></div><br><br>
         </td>
temporary replacement code starts next -->

<td align="center" class="catalogLABEL"><p class="bodyBlack"><blockquote>Your file has been saved. You may download it on the following page, or at any time by going to your 'DIY Files' under the MY FILES menu.<br> Please click 'Continue'.</blockquote></p><br>
         </td>
<!-- End temporary replacement code -->
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2" align="center"> <a href="<%=homeLink%>index.jsp?contents=/files/fileManager.jsp?shdc=true" class="greybutton" target="_parent">Continue</a> 
    <%
    }else{%>
    <td align="left" class="catalogLABEL">
      	<jsp:include page="/includes/OrderConfirmOnAccount.jsp" flush="true">
        	<jsp:param name="orderId" value="<%=orderId%>"></jsp:param>
        	<jsp:param name="pay_type" value="<%=payType%>"></jsp:param>
        </jsp:include>
     </td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2" align="center"
    ><form action="/contents/OrderConfirm.jsp?print=true" target=_blank>
	    <input type="hidden" name="ccNumberMasked" value="<%=ccNumberMasked%>" >
	    <input type="hidden" name="orderId" value="<%=orderId%>" >
	    <input type="hidden" name="ccMonth" value="<%=ccMonth%>" >
	    <input type="hidden" name="ccYear" value="<%=ccYear%>" >
	    <input type="hidden" name="pastref" value="<%=pastref%>" >
	    <input type="hidden" name="ccType" value="<%=ccType%>" >
	    <input type="hidden" name="totalDollarAmount" value="<%=totalDollarAmount%>" >
	    <input type="hidden" name="pastACref" value="<%=pastACref%>" >
	    <input type="hidden" name="bankName" value="<%=bankName%>" >
	    <input type="hidden" name="accountNumber" value="<%=accountNumber%>" >
   	 	<a href="javascript:document.forms[0].submit()" class="greybutton" >PRINT</a> <a href="<%=homeLink%>index.jsp" class="greybutton" target="_parent">Continue</a> </form>
      <%}%>
    </td>
  </tr>
</table>
</body>
</html><%}%>
