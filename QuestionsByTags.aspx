<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <style type="text/css">
        a{
            text-decoration:none;
            color:lightblue;
        }
        .oldLet{
            font-family:'Old English Text MT';
        }
        .Opts{
           width:10%;background-color:darkblue;color:cornsilk;
        }
        #ln{
            text-decoration:underline;
            color:white;
        }
    </style>
</head>
<body style="background: url(images.jpg) no-repeat;background-size:cover">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3mobile.css"/>
    <script runat="server">

        public bool admin(string username)
        {
            bool b=false;
            OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
            conn.Open();
            OleDbDataReader dr = query.queries.query("select * from tusers where Username='"+username+"'",conn);
            if(dr.Read())
                b = dr["permissions"].ToString() == "2";
            conn.Close();
            return b;
        }
        public void options(bool connected)
        {
            string st1=String.Format("<a href='HomePage.aspx' >Home Page</a>");
            string st2=String.Format("<a href='asking.aspx' >Ask a question</a>");
            string st3 = String.Format("<a href='users.aspx'>Users</a>");
            string st4 = String.Format("<a href='addTag.aspx'>add a tag</a>");
            string st5 = "<a href='profileUpdate.aspx'>update your profile</a>";
            ///TODO : add users link and add tag link for admin
            if (connected)
            {
                if(admin(Session["username"].ToString()))
                {
                    Response.Write("<table><tr><td class='Opts'>" + st1 + "</td><td class='Opts'>" + st2 + "</td><td class='Opts'>" + st3 + "</td><td class='Opts'>"+st4+"</td><td class='Opts'>"+st5+"</td><td style='width:1200px;background-color:darkblue'></td></tr></table><br/>");
                }
                else
                {
                    Response.Write("<table><tr><td class='Opts'>" + st1 + "</td><td class='Opts'>" + st2 + "</td><td class='Opts'>"+st5+"</td><td style='width:1200px;background-color:darkblue'></td></tr></table><br/>");
                }
            }
            else
                Response.Write("<table><tr><td class='opts' style='width:600px;background-color:red;'>" + st1 + "&nbsp&nbsp&nbsp</td><td style='width:1200px;background-color:red'></td></tr></table><br/>");
        }
        public void echo(string st)
        {
            Response.Write(st);
        }
        /// <summary>
        /// page's main function
        /// prints the questions
        /// </summary>
        public void Page_Load()
        {
            OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
            conn.Open();
            OleDbDataReader Dr = query.queries.query("select tag_name from tags",conn);
            options(Session["username"] != null);
            echo("<form id='frm1' action='QuestionsByTags.aspx' method='post'><select name='tag'>");
            while (Dr.Read())
            {
                string tag = Dr["tag_name"].ToString();
                if (tag == Request.Form["tag"])
                    echo("<option selected = 'selected'>");
                else
                    echo("<option>");
                echo(Dr["tag_name"].ToString());
                echo("</option>");
                // echo(Dr["tag_name"].ToString()+",");
            }
            echo("/select><input type='button' value='search' onclick='searchTag()'/></form>");
            echo("<a href='Questions.aspx' id='ln'>to search by title</a>");
            if (Request.HttpMethod=="POST")
            {
                string sql;
                string filter = Request.Form["tag"];
                if (filter != null&&filter!="")
                {
                    sql = " select Questions.qID,Questions.Username,Title,tag_name,SUM(comments_Questions.vote) as votes ";
                    sql+=" from Questions INNER JOIN  comments_Questions on Questions.qID=comments_Questions.qID";
                    sql += " where tag_name='"+filter+"'";
                    sql += " GROUP BY Questions.qID,Questions.Username,Title,tag_name";
                    sql += " ORDER BY SUM(comments_Questions.vote) desc";
                }
                else {
                    sql = " select Questions.qID,Questions.Username,Title,tag_name,SUM(comments_Questions.vote) as votes ";
                    sql+=" from Questions INNER JOIN  comments_Questions on Questions.qID=comments_Questions.qID";
                    sql += " GROUP BY Questions.qID,Questions.Username,Title,tag_name";
                    sql += " ORDER BY SUM(comments_Questions.vote) desc";
                }
                OleDbDataReader questions = query.queries.query(sql, conn);
                echo("<table style='border-radius:30px'>");
                while(questions.Read())
                {
                    echo("<tr><td style='width:70%'></td><td>");
                    echo("<div style='text-align:center;background-color:brown;color:white;border-radius:20px'>");
                    echo("<a href='question.aspx?q="+questions["qID"]+"'><h3>");
                    echo(questions["Title"].ToString()+"</h3>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp submitted by:"+questions["Username"]);
                    echo("</a></div>");
                    echo("</td></tr>");
                }
                echo("</table>");
            }

            conn.Close();
        }
    </script>
    <script type="text/javascript"> 
        function searchTag()
        {
            if(document.getElementById("frm1").tag.value!="")
            {
                document.getElementById("frm1").submit();
            }
            else
            {
                alert("select tag name or go to general questions");
            }
        }
    </script>
    <script src="jquery-3.2.1.min.js"></script>
    <script>
        $(document).ready(function () {
            $('.Opts').fadeTo('fast', 0.5);
            $('.Opts').mouseenter(function () {
                $(this).fadeTo('fast', 1);
            });
            $('.Opts').mouseleave(function () {
                $(this).fadeTo('fast', 0.5);
            });
            $('.opts').fadeTo('fast', 0.5);
            $('.opts').mouseenter(function () {
                $(this).fadeTo('fast', 1);
            });
            $('.opts').mouseleave(function () {
                $(this).fadeTo('fast', 0.5);
            });
        });
    </script>
     <script src ="annyang.min.js"></script>
<script>
    if (true) {
        var commands = {
            "goto *tag":function(tag)
            {
                annyang.trigger("go to " + tag);
            }
            ,"go to *tag": function (tag) {
                var text = tag;
                var elms;
                elms = document.getElementsByClassName("opts");
                if (elms == undefined || elms == null)
                    elms = document.getElementsByClassName("Opts");
                for (i = 0; i < elms.length; i++) {
                    /*alert(elms[i].innerText.toLowerCase() + ";" + text.toLowerCase());
                    alert(elms[i].innerText.toLowerCase()=="questions");
                    alert(text.toLowerCase()=="questions");*/
                    if (elms[i].innerText.toLowerCase() == text.toLowerCase()) {
                        elms[i].getElementsByTagName("a")[0].click();
                    }
                    else if (elms[i].innerText.toLowerCase() == text.toLowerCase() + "s") {
                        elms[i].getElementsByTagName("a")[0].click();
                    }
                }
                console.log(text);
            }, "search *tag": function (tag) {
                var parts = tag.split(" ");
                var text = "";
                for (i = 0; i < parts.length; i++) {
                    text += parts[i];
                    if (i != parts.length - 1)
                        text += "+";
                }
                alert(parts[0]);
                var b;
                if (parts.length > 1)
                    b = true;
               if(!b)
                    window.location = "https://www.google.co.il/search?rlz=1C1CHWA_enIL648IL648&q=" + text;
                else 
                    window.location = "https://www.google.co.il/search?rlz=1C1CHWA_enIL648IL648&q=" + text+"oq="+parts[0];
            }
            , "hi": function () {
                responsiveVoice.speak("hello");
            }, "filter": function (tag) {
                document.getElementById("txt").value = tag;
            }, "*tag": function (tag) {
                console.log(tag);
            }
        };
        annyang.addCommands(commands);
        annyang.start();
    }
</script>
</body>
</html>
