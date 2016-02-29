<%@ page errorPage="/errors/ExceptionPage.jsp" %>
<%@ page import="java.sql.*,java.text.*,java.util.*,com.marcomet.jdbc.*,com.marcomet.tools.*,com.marcomet.workflow.*,com.marcomet.users.security.*;" %>
<%@ include file="/includes/SessionChecker.jsp" %>
<jsp:useBean id="validator" class="com.marcomet.tools.FieldValidationBean" scope="page" /><%
String jobId = (String)request.getParameter("jobId");
String groupId = (String)request.getParameter("groupId");
String query = "SELECT message, max(time_stamp), last_status_id, status_id, form_id FROM form_messages, jobs WHERE (form_id = 1 OR form_id = 2) AND jobs.id = job_id AND group_id = " + groupId + " AND job_id = " + jobId + " GROUP BY time_stamp ORDER BY time_stamp DESC";

Connection conn = DBConnect.getConnection();
Statement st = conn.createStatement();

Hashtable rehash = new Hashtable();
//preload to prevent the NPE
rehash.put("message","non found in db");
rehash.put("statusid","non found in db");

ResultSet rs0 = st.executeQuery(query);
if (rs0.next()) {
	rehash.put("message", rs0.getString("message"));
	rehash.put("statusid", rs0.getString("status_id"));
	rehash.put("formId", rs0.getString("form_id"));
}

int fileCounter = 0;
String fileQuery = "select file_name, id, description, comments, company_id from file_meta_data where status = 'Submitted' AND group_id = " + groupId + " and job_id = " + jobId;
ResultSet rs1 = st.executeQuery(fileQuery);
while (rs1.next()) {
	rehash.put("file" + fileCounter, rs1.getString("file_name"));
	rehash.put("fileId" + fileCounter, rs1.getString("id"));
	rehash.put("fileDescription" + fileCounter, rs1.getString("description"));
	rehash.put("fileComments" + fileCounter, rs1.getString("comments"));
	rehash.put("companyid", rs1.getString("company_id"));
	fileCounter++;
}
rehash.put("fileCount", new Integer(fileCounter));

int materialCounter = 0;
String materialQuery = "select file_name, mmd.id as id, mmd.description, mmd.comments ,method from material_meta_data mmd, shipping_data sd where mmd.status = 'Submitted' and shipping_data_id = sd.id AND mmd.group_id = " + groupId + " and mmd.job_id = " + jobId + " and sd.job_id = " + jobId;
ResultSet rs2 = st.executeQuery(materialQuery);
while (rs2.next()) {
	rehash.put("material" + materialCounter, rs2.getString("file_name"));
	rehash.put("materialId" + materialCounter, rs2.getString("id"));
	rehash.put("materialDescription" + materialCounter, rs2.getString("description"));
	rehash.put("materialComments" + materialCounter, rs2.getString("comments"));
	rehash.put("method" + materialCounter, rs2.getString("method"));
	materialCounter++;
}
rehash.put("materialCount", new Integer(materialCounter));

st.close();
conn.close();
%>

<html>
<head>
<title>Approve Work/Proof</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="<%=(String)session.getAttribute("siteHostRoot")%>/styles/vendor_styles.css" type="text/css">
</head>
<jsp:getProperty name="validator" property="javaScripts" />
<script language="JavaScript" src="/javascripts/mainlib.js"></script>
<body background="<%=(String)session.getAttribute("siteHostRoot")%>/images/back3.jpg">
<form method="post" action="/servlet/com.marcomet.sbpprocesses.ProcessJobSubmit">
  <p class="Title">Approve Work/Proof</p>
  <% if ((new Integer((String)rehash.get("formId"))).intValue() == 8) { %>
  <p>Please indicate your approval of the work referenced below. If multiple choices 
    are available, as in approving a choice of designs, please only select the 
    one for which you desire final production. <b>Your approval means that you 
    are authorizing the final production or printing process to be conducted, 
    no further modifications will be permitted, and you will be charged in full 
    for your order.</b> If you are unsure how to proceed, please call. Note: if 
    a file's delivery is via Upload, you should be able to view file by clicking 
    on it's name. 
    <% } else { %>
    <!--<b>Instructions:</b> Please indicate your approval of the work referenced 
    below. If multiple choices are available, as in approving a choice of designs, 
    please only select the one for which you desire development for final production. -->
    <% } %>
  </p>
  <jsp:include page="/includes/ApproveWorkHeader.jsp" flush="true">
  <jsp:param  name="jobId" value="<%=request.getParameter("jobId")%>" />
  </jsp:include>
  <hr width="100%" size="1">
<span class="label">Sender's Message:</span>
  <p class="label"><font size=4 color="red"> <%= (String)rehash.get("message") %> </font></p>
  <hr width="100%" size="1">
  <p><!--<span class="subtitle">Indicate your Choice below: &nbsp;</span>--><i>Please view proof(s) below, then please select &quot;Approve&quot; to authorize proof to be printed/produced, or &quot;Modify&quot; to return with requested changes. Then click &quot;Submit&quot; to continue.</i></p>
  <table border="0" width="100%">
    <tr> 
      <td class="minderheaderleft" width="14%">Ref. or File</td>
      <td class="minderheaderleft" width="11%">Sent Via</td>
      <td class="minderheaderleft" width="15%">Description</td>
      <td class="minderheaderleft" width="15%">Comments</td>
      <td class="greybutton" width="5%" >Approve</td>
      <td class="greybutton" width="5%" >Modify</td>
<!--      <td class="greybutton" width="5%" >Reject</td>-->
      <td class="greybutton" width="30%" align="left">Instructions for 
        Modification (If Applicable)</td>
    </tr>
    <% int fileCount = ((Integer)rehash.get("fileCount")).intValue();
   for (int i=0; i<fileCount; i++) {
      String fileId = (String)rehash.get("fileId"+i);
%>
    <tr valign="top"> 
      <td class="minderLink" align="left"><a href="javascript:pop('/transfers/<%=rehash.get("companyid")%>/<%=rehash.get("file"+i)%>',300,300)" class="greybutton" ><b><font size=4>CLICK HERE TO VIEW PROOF</font></b><br><%=rehash.get("file"+i)%></a></td>
      <td class="body" align="left">Upload</td>
      <td class="body"><%= rehash.get("fileDescription"+i) %></td>
      <td class="body"><%= rehash.get("fileComments"+i) %></td>
      <td align="center"> 
        <input type="radio" name="comp" value="1:<%=fileId%>">
        <input type="hidden" name="file<%=i%>" value="<%=fileId%>">
      </td>
      <td align="center"> 
        <input type="radio" name="comp" value="0:<%=fileId%>" onClick="alert('Please be sure to note any modifications to the file necessary to continue processing the job.')">
      </td>
<!--      <td align="center"> 
        <input type="radio" name="comp" value="0:0" onClick="alert('Please be sure to note your reason for rejecting the file and any modifications necessary to continue processing the job.')">
      </td> -->
      <td align="left"> 
        <textarea cols="40" rows="2" name="fileComments<%= i %>"></textarea>
      </td>
    </tr>
    <% } %>
    <input type="hidden" name="fileCount" value="<%= fileCount %>">
    <% int materialCount = ((Integer)rehash.get("materialCount")).intValue();
   for (int i=0; i<materialCount; i++) {
      String materialId = (String)rehash.get("materialId"+i);
%>
    <tr valign="top"> 
      <td class="body"><%= rehash.get("material"+i) %></td>
      <td class="body"><%= rehash.get("method"+i) %></td>
      <td class="body"><%= rehash.get("materialDescription"+i) %></td>
      <td class="body"><%= rehash.get("materialComments"+i) %></td>
      <td align="center"> 
        <input type="radio" name="comp" value="1:<%=materialId%>">
        <input type="hidden" name="material<%=i%>" value="<%=materialId%>">
      </td>
      <td align="center"> 
        <input type="radio" name="comp" value="0:<%=materialId%>">
      </td>
      <td align="center"> 
        <input type="radio" name="comp" value="0:0">
      </td>
      <td> 
        <textarea cols="40" rows=2 name="materialComments<%=i%>"></textarea>
      </td>
    </tr>
    <% } %>
    <tr> 
      <td colspan="7"> 
        <hr size="1">
      </td>
    </tr><%
if (materialCount>1){
    %><tr> 
      <td class="body" valign="top"><span class="label">None of the above: </span> 
        <input type="hidden" name="materialCount" value="<%=materialCount%>">
      </td>
      <td class="body" colspan="3" valign="top"> 
        <div align="right"> 
          <p align="left">None of the submitted items are currently acceptable. 
            Please resubmit based on the following comments included to the right.</p>
        </div>
      </td>
      <td class="body" colspan="2" valign="top"> 
        <div align="center"> 
          <input type="radio" name="comp" value="0:0">
        </div>
      </td>
      <td class="body"> 
        <div align="left"> 
          <textarea cols="40" rows=2 name="message"></textarea>
        </div>
      </td>
    </tr><%
}
%>
    <tr> 
      <td class="body" colspan="6"> 
        <div align="left"> </div>
      </td>
  </table>
  <hr width="100%" size="1">
   <table border="0" width="25%" align="center">
    <tr> 
      <td width=3%>&nbsp;</td>
      <td>
        <div align="center"><a href="javascript:moveJobApproveCompProof()" class="greybutton">Submit</a></div>
      </td>
      <td width=3%>&nbsp;</td>
      <td>
        <div align="center"><a href="javascript:history.go(-1)" class="greybutton">Cancel</a></div>
      </td>
    </tr>
  </table>
  <script language="JavaScript">
function isLastRadio(){
	var y = document.forms[0].comp.length - 1;
	//loop for modifies and check on 0, works on the n/a also
	for(x = 0; x < document.forms[0].comp.length; x++){
		if(document.forms[0].comp[x].checked){
			return (document.forms[0].comp[x].value.split(":")[0] == "0");
		}	
	}
}
function moveJobApproveCompProof(){
	var check = false;
	for(i = 0; i< document.forms[0].comp.length; i++){
		if(document.forms[0].comp[i].checked){
			check = true;
		}
	}
	//return if nothing is checked
	if(!check){
		alert('You need to select an approval option before continuing');
		return;
	}
	
	if(isLastRadio()){
		moveWorkFlow(89);
	}else{	
		moveWorkFlow(88);
	}	
}
</script>
  <input type="hidden" name="nextStepActionId" value="">
  <input type="hidden" name="materialCount" value="<%=materialCount%>">
  <input type="hidden" name="$$Return" value="[/minders/JobMinderSwitcher.jsp]">
  <input type="hidden" name="jobId" value="<%= request.getParameter("jobId") %>" >
</form>
</body>
</html>