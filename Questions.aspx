<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <style>
        input{
            border-radius:5px;background-color:white;
        }
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
        .opts{
            color:cornsilk;
        }
        #ln{
            text-decoration:underline;color:blue;
        }
        .opts{
            color:white;
        }
    </style>
</head>
<body style="background: url(images.jpg) no-repeat;background-size:cover">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3mobile.css"/>
    <div style="text-align:left">
    <script runat="server">
        string JS = "";
        //  public string  searchInCookies(string key)
        public void echo(string str)
        {
            Response.Write(str);
        }
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
                Response.Write("<table><tr><td class='opts' style='width:600px;background-color:red;'>" + st1 + "</td><td style='width:1200px;background-color:red'></td></tr></table><br/>");
        }
        public void Page_Load()
        {
            int i = 0;
            string lnk = "";
            bool connected = Session["username"] != null;
            OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
            conn.Open();
            string filter = Request.QueryString["search"];
            string sql;
            if (filter != null&&filter!="")
            {
                sql = " select Questions.MainText,Questions.qID,Questions.Username,Title,tag_name,SUM(comments_Questions.vote) as votes ";
                sql+=" from Questions INNER JOIN  comments_Questions on Questions.qID=comments_Questions.qID";
                sql += " where Title like '%" + filter + "%'";
                sql += " GROUP BY Questions.qID,Questions.Username,Title,tag_name,Questions.MainText";
                sql += " ORDER BY SUM(comments_Questions.vote) desc";
            }
            else {
                sql = " select Questions.MainText,Questions.qID,Questions.Username,Title,tag_name,SUM(comments_Questions.vote) as votes ";
                sql+=" from Questions INNER JOIN  comments_Questions on Questions.qID=comments_Questions.qID";
                sql += " GROUP BY Questions.qID,Questions.Username,Title,tag_name,Questions.MainText";
                sql += " ORDER BY SUM(comments_Questions.vote) desc";
            }
            OleDbDataReader questions = query.queries.query(sql, conn);
            options(connected);
            lnk = "<a  href='QuestionsByTags.aspx' id='ln'>to search by tags</a>";
            //search form
            echo("<form id='search' onsubmit='check()'><table><tr><td>");
            echo("<input type='text'name='search'id='txt'/></td><td><input type='submit' value='search' /></td>");
            echo("<td><input type='button' onclick = 'speak()' value='speak'></td>");
            echo("</tr></table></form>");
            //echo("<input type='button' onclick='move()' value='To Search By tags'>");
            //link to Questions by tags
            echo(lnk);
            //Questions showing
            echo("<center>");
            echo("<table style='border-radius:30px'>");
            while(questions.Read())
            {
                if (questions["MainText"].ToString() == "")
                    continue;
                echo("<tr><td>");
                echo("<div id='div"+i+"' style='text-align:center;background-color:brown;color:white;border-radius:20px'>");
                echo("<a href='question.aspx?q="+questions["qID"]+"'><h3>");
                echo(questions["Title"].ToString()+"</h3>submitted by:"+questions["Username"]);
                echo("</br>votes:" + questions["votes"]+"</br>");
                echo("</a></div>");
                echo("</td></tr>");
                i++;
            }
            echo("</table></center>");
            conn.Close();
        }
    </script>
    </div>
    <script src="jquery-3.2.1.min.js"></script>
    <script type="text/javascript">
        function Question(id) {
            try {
                var str = "<form method='post' action='question.aspx' id='form1'><input type='text' name='questionname' value='" + doucument.getElementById(id).innerText + "'</form>";
                document.write(str);
                document.getElementById("form1").submit();
            }
            catch (e) {
                alert(e.ToString());
            }

        }
        function move()
        {
            document.write("<a href='QuestionsByTags.aspx' id='lnk'></a>");
            document.getElementById("lnk").click();
        }
        function check()
        {
            if(document.getElementById("txt").value.indexOf("'")!=-1)
            {
                alert("cannot enter ' ");
                return false;
            }
            return true;
        }
    </script>    
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
        $('div').mouseenter(function () {
            $(this).css("background-color","green");
        });
        $('div').mouseleave(function () {
            $(this).css("background-color", "brown");
        });
        $('input').mouseenter(function () {
            $(this).css("background-color", "black");
            $(this).css("color", "white");
        });
        $('input').mouseleave(function () {
            $(this).css("background-color", "white");
            $(this).css("color", "black");
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
            }, "submit": function () {
                document.getElementsByTagName("input")[1].click();
            }, "hi": function () {
                responsiveVoice.speak("hello");
            }, "filter *tag": function (tag) {
                document.getElementById("txt").value = tag;
            }, "*tag": function (tag) {
                console.log(tag);
            }
        };
        annyang.addCommands(commands);
        annyang.start();
    }
</script>
    <script>
    var rec = new webkitSpeechRecognition();
    rec.onresult = function (event) {
        var text = event.results[0][0]["transcript"];
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
    }
    //setTimeout(function () { alert("speak now"); rec.start(); }, 200);
    var rc = new webkitSpeechRecognition();
    rc.onresult = function (event) {
        var text = event.results[0][0]["transcript"];
        document.getElementById("txt").value = text;
        console.log(text);
    };
    function speak()
    {
        rc.start();
    }
</script>
</body>
</html>
