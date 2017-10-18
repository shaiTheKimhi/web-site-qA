<%@ Page Language="C#"  %>
<%@ Import Namespace="System.Data.OleDb"%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="background: url(images.jpg) no-repeat;background-size:cover">
   <script runat="server">
       public void Page_Load()
       {
           OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
           conn.Open();
           string name=Request.Form["username"];
           string password=Request.Form["password"];
           OleDbDataReader users=query.queries.query("SELECT Username FROM tusers WHERE Username='"+name+"'AND upass='"+password+"';",conn);
           if(users.Read()){
               Session["username"] = name;
               Response.Write("<h8 id='1'>12</h1>");
           }
           else{
               Response.Write("<h8 id='1'>11</h1>");
           }
           conn.Close();
       }
   </script>

<script type="text/javascript">
 function redirect(url){
	 var x=document.getElementById("1").innerText;
	 document.write("<form id='form1' action='"+url+"' method='post'><input type='text' name='error' value='"+x+"'></form>");
	 document.getElementById("form1").submit();
 }
 redirect("HomePage.aspx");
</script>
</body>
</html>
