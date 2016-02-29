<%@ page import="java.util.*,java.sql.*, com.marcomet.catalog.*,com.marcomet.jdbc.*,com.marcomet.environment.*,java.io.*,java.io.File,java.nio.channels.*,java.nio.*" %>
<%
	ResourceBundle bundle = ResourceBundle.getBundle("com.marcomet.marcomet");
	String transfers = bundle.getString("transfers");
	String homeDir = bundle.getString("transfersPrefix");
	String tempFilesDir = bundle.getString("tempFiles");
 	String id=((request.getParameter("id")==null)?"":request.getParameter("id"));
 		
	Connection conn = null; 
	try {	
			 	conn = DBConnect.getConnection();
				Statement qsI = conn.createStatement();
				ResultSet rsI = qsI.executeQuery("Select j.jbuyer_company_id as bcId, js.id as jobspecid, cs.id as catspecid,concat('"+tempFilesDir+"',js.value) as fileName,csb.pdfblock_name,concat(js.job_id,'_', csb.pdfblock_name,'.jpg') as newFileName from job_specs js left join catalog_specs cs on cs.id=js.cat_spec_id left join catspec_template_bridge csb on csb.catspecid=cs.id left join jobs j on j.id=js.job_id where js.value not like '%transfers%' and cs.field_type='800' and js.value<>'' and js.job_id="+id);
				while(rsI.next()){
					String buyerCompanyId=((rsI.getString("bcId")==null)?"":rsI.getString("bcId"));
					String transfersDir=transfers+buyerCompanyId+"/";
					String tFileName= ((rsI.getString("fileName")==null)?"":rsI.getString("fileName"));
					String tNewFileName= ((rsI.getString("newFileName")==null)?"":rsI.getString("newFileName"));
					File tJpg=new File(tFileName);
					
					File tNewJpg=new File(transfersDir+tNewFileName);
					if (tJpg.exists()){
				    	InputStream in = new FileInputStream(tJpg);
				        OutputStream outt = new FileOutputStream(tNewJpg);
	
				        byte[] buf = new byte[1024];
				        int len;
				        while ((len = in.read(buf)) > 0) {
				            outt.write(buf, 0, len);
				        }
				        in.close();
				        outt.close();
				        boolean fileChanged=true;
				        
				        if(tFileName.indexOf("data")==-1){
				        	fileChanged=tJpg.delete();
				        }
				        
						if(tNewJpg.exists()){
							Statement qs2 = conn.createStatement();
							qs2.executeUpdate("update job_specs set value='/transfers/"+buyerCompanyId + "/"+tNewFileName+"' where id="+rsI.getString("jobspecid"));
							%><!-- Files moved --><%
						}
					}
				}
	} catch (Exception exc) {
				throw new SQLException(exc.getMessage());		
	}finally{
		conn.close();
	}
%>