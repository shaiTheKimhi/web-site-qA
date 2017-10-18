<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="background: url(images.jpg) no-repeat;background-size:cover">
    <script runat="server">
        /* public void Page_Load()
         {
             if (Session["username"] == null)
                 Response.Redirect("HomePage.aspx");
             if (!query.queries.admin(Session["username"].ToString(), Server))
                 Response.Redirect("HomePage.aspx");
             OleDbConnection conn = new OleDbConnection(query.queries.connconst(Server));
             conn.Open();
             //string sqlQuery = string.Format("DELETE FROM tusers WHERE Username='{0}'",Request.QueryString["User"]);
             string sqlQuery = string.Format("update tusers set upass = 'NOTRELEVANT' email='NULL' where Username ='{0}'", Request.QueryString["User"]);
             query.queries.updateQuery(sqlQuery, conn);
             conn.Close();
             Response.Redirect("users.aspx");
         }*/
        public void Page_Load() { }
    </script>
</body>
</html>
