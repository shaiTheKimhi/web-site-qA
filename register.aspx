<%@ Page Language="C#"%>
<%@ Import Namespace="System.Data.OleDb" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
</head>
<body style="background: url(images.jpg) no-repeat;background-size:cover">
    <script runat="server">
        public void Page_Load()
        {
            OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
            conn.Open();
            string name = Request.Form["username"];
            string password = Request.Form["password"];
            string email = Request.Form["email"];
            email = email!=null?email.ToLower():null;
            //string email = "";//todelete
            OleDbDataReader users = query.queries.query("SELECT Username FROM tusers WHERE Username='" + name + "';", conn);
            if(name=="DELETE")
            {
                Session["username"] = null;
                Response.Write("<h8 style='display:none' id='1'>0</h1>");
            }
            else if(users.Read())
            {
                Response.Write("<h8 id='1'>1</h8>");
            }
            else{
                query.queries.updateQuery(String.Format("INSERT INTO tusers (Username, upass,permissions,Email) VALUES ('{0}', '{1}',1,'{2}');",name,password,email),conn);
                Session["username"] = name;
                //setCookie("password",password,100);
                Response.Write("<h8 id='1' style='color:white'>0</h1>");
            }
            conn.Close();
        }
    </script>
    

<script type="text/javascript">
 function redirect(url){
	 var x=document.getElementById("1").innerText;
	 document.write("<div style='display:none'><form  id='form1' action='"+url+"' method='post'><input type='text' name='error' value='"+x+"'></form></div>");
	 document.getElementById("form1").submit();
 }
 redirect("HomePage.aspx");
 </script>
</body>
</html>
