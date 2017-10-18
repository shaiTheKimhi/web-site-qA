<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="background: url(images.jpg) no-repeat;background-size:cover">
    <script runat="server">
        string img = "";
        string password = "";
        string email = "";
        string permissions = "";
        string first = "";
        string second = "";
        public void Page_Load()
        {
            if (Session["username"]==null||!query.queries.admin(Session["username"].ToString(), Server))
                Response.Redirect("HomePage.aspx");
            if(Request.HttpMethod=="POST")
            {
                OleDbConnection conn = new OleDbConnection(query.queries.connconst(Server));
                conn.Open();
                query.queries.updateQuery(string.Format("UPDATE tusers SET permissions=2 WHERE Username='{0}';", Request.Form["User"]), conn);
                conn.Close();
                Response.Redirect("users.aspx");
            }
            else
            {

            }
        }
    </script>
   <form action="user.aspx" method="post" id="frm">
        <input type="text" style="display:none" name="userName" value="<%=Request.QueryString["User"] %>" />
       <input type="text" style="display:none" name="type" value="U" /> 
       <table <%=second %>>
            <tr><td rowspan="3">name:<%=Request.QueryString["User"] %>/></td><td>password:<input type="text" value="<%=password %>" id="password" name="password"/></td></tr>
            <tr><td>email:</td><td><input type="text" name="email" value="<%=email %>" /></td></tr>
           <tr><td>permissions:<%=permissions %></td></tr>
            <tr><td colspan="2"><input type="submit" onclick="submit()"/></td></tr>
        </table>
    </form>
    <script>
        function submit()
        {
            var name = document.getElementById("username").value;
            var pass = document.getElementById("password").value;
            if(name==null||pass==null)
            {
                alert("Email and password must not be null");
                document.getElementById("frm").submit();
            }
            document.getElementById("frm").submit();
        }
    </script>
</body>
</html>
