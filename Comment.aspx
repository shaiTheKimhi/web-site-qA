<%@ Page Language="C#"  %>
<%@ Import Namespace="System.Data.OleDb" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
</head>
<body style="background: url(images.jpg) no-repeat;background-size:cover">
<script runat="server">
    public void echo(string str)
    {
        Response.Write(str);
    }
    public void Page_Load()
    {
        if (Session["username"] == null)
            Response.Redirect("HomePage.aspx");
        OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
        OleDbDataReader dr;
        conn.Open();
        try
        {
            if(Request.Form["qa"]=="q")
            {
                if(Request.Form["upV"]==null||Request.Form["upV"]=="0")
                {
                    query.queries.updateQuery(String.Format("INSERT INTO comments_Questions (qID,Username,MainText,vote) values({0},'{1}','{2}',{3})",Request.Form["id"],Session["username"],Request.Form["text"],Request.Form["value"]),conn);
                }
                else
                {
                    query.queries.updateQuery(String.Format("INSERT INTO comments_Questions(qID,Username,vote) values ({0},'{1}',{2})",Request.Form["id"],Session["username"],Request.Form["upV"]),conn);
                }
            }
            else{
                query.queries.updateQuery(string.Format("INSERT INTO comments_Answers (aID,Username,MainText) values ({0},'{1}','{2}')",Request.Form["id"],Session["username"],Request.Form["text"]),conn);
            }
            if (Request.Form["qa"] == "q")
            {
                echo("<div id='1'>" + Request.Form["id"] + "</div>");
            }
            else
            {
                dr = query.queries.query("select qID from Answers where aID=" + Request.Form["id"], conn);
                dr.Read();
                echo("<div id='1'>" + dr["qID"] + "</div>");

            }
        }
        finally
        {
            conn.Close();

        }
    }
</script>
    <!--JavaScript--->
<script>
    var str = document.getElementById("1").innerText;
    document.write("<a href='question.aspx?q=" + str + "' id='lnk'></a>");
    document.getElementById("lnk").click();
 </script>
</body>
</html>
