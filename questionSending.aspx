<%@ Page Language="C#"  %>
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
        try
        {
            OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
            conn.Open();
            if(Request.HttpMethod=="POST")
            {
                string text = Request.Form["Text"];
                string id = Request.Form["qID"];
                query.queries.query(String.Format("UPDATE Questions set MainText='{0}' WHERE qID={1}", text, id), conn);
                conn.Close();
                if (text == "")
                    Response.Redirect("Questions.aspx");
                else
                    Response.Redirect("question.aspx?q=" + id);
            }
            else
            {
                string title = Request.QueryString["Title"];
                string txt = Request.QueryString["Text"];
                int qid = query.queries.ConvertToUnixTimestamp();
                query.queries.updateQuery(String.Format("INSERT INTO Questions(qID, Title,MainText,Username,tag_name) VALUES ({0},'{1}','{2}','{3}','{4}');",qid, title, txt, Session["username"], Request.QueryString["tag_name"]), conn);
                string sql = string.Format("INSERT INTO comments_Questions(qID,Username,MainText,vote) values({0},'aaaa','',0)", qid);
                query.queries.updateQuery(sql,conn);
                conn.Close();
            }

        }
        catch(Exception e)
        {
            Response.Write(e.Message);
        }
    }
</script>
    <!---JavaScript Part--->
     <script type="text/javascript">
         function redirect(url){ 
	         document.write("<form id='form1' action='"+url+"' method='post'><input type='text' name='error' style='display:none' value='0'></form>");
	         document.getElementById("form1").submit();
         }
         redirect("HomePage.aspx");
    </script>
</body>
</html>
