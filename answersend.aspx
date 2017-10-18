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
                OleDbConnection conn=new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source="+Server.MapPath("db.accdb"));
                conn.Open();//Creating the connection
                string txt=Request.Form["Text"];
                string questionId=Request.Form["qID"];
                Response.Write("<h4 id='qid' style='display:none'>"+questionId+"</h4>");
                /*if(_POST["type"]=="D")
		        {
			        Updatequery(String.Format("DELETE FROM Answers WHERE qID="+questionId+";"),conn);
		        }*/
                if(Request.Form["type"]=="S")
                {
                    string sql = String.Format("INSERT INTO Answers(qID,MainText,Username) VALUES ({0},'{1}','{2}');", questionId, txt, Session["username"]);
                    query.queries.updateQuery(sql,conn);
                }
                else if (Request.Form["type"]=="U")
                {
                    //echo("<h1>"+txt+"</h1>");
                    string st = Request.Form["aID"];
                    query.queries.updateQuery(String.Format("UPDATE Answers SET MainText='{0}' WHERE aID={2}",txt,Request.Form["aID"]),conn);
                }   
                else
                {

                }
                conn.Close();
            }
            catch(Exception e){
                Response.Write(e.Message);
            }
            finally
            {
                Response.Redirect("question.aspx?q=" + Request.Form["qID"]);
            }
        }
    </script>
</body>
</html>
