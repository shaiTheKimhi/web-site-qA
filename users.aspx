<%@ Page Language="C#"%>
<%@ Import Namespace="System.Data.OleDb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <style>
        #tabl
        {
            font-size:x-large;
        }
        .primeOpts{
            width:10%;
            background-color:darkgreen;
        }
        .Opts{
           width:10%;background-color:darkblue;color:cornsilk;
        }
        .titles{
            background-color:yellowgreen;
            color:brown;
        }
        .names{
            background-color:gray;
        }
        .buttons{
            background-color:turquoise;
        }
        a{
            text-decoration:none;
            color:cornsilk;
        }
        input{
            border-radius:30px;
            font-size:medium;
            background-color:white;
        }
    </style>
</head>
<body style="background: url(images.jpg) no-repeat;background-size:cover">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3mobile.css"/>
    <script runat="server">
        public int getStatus()
        {
            OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
            conn.Open();
            string str = Session["username"] == null ? "" : Session["username"].ToString();
            OleDbDataReader dr = query.queries.query(String.Format("SELECT permissions FROM tusers where username='{0}'", str),conn);
            int status = 0;
            if (dr.Read())
            {
                status = (int)dr[0];
            }
            conn.Close();
            return status;
        }
        public void options(bool connected)
        {

            string st1 = String.Format("<a href='HomePage.aspx'>HomePage</a>");
            string st2 = String.Format("<a href='Questions.aspx'>Questions</a>");
            string st3 = String.Format("<a href='asking.aspx'>Ask a question</a>");
            string profileUpdate = "<a href='profileUpdate.aspx'>update your profile</a>";
            string st4 = "<a href='addTag.aspx'>add a tag</a>";
            if (connected)
            {
                if(query.queries.admin(Session["username"].ToString(),Server))
                {
                    Response.Write("<table><tr><td class='Opts'>" + st1 + "</td><td class='Opts'>" + st2 + "</td><td class='Opts'>" + profileUpdate + "</td><td class='Opts'>" + st3 + "</td><td class='Opts'>"+st4+"</td><td style='width:1200px;background-color:darkblue'></td></tr></table><br/>");
                }
                else
                {
                    Response.Write("<table><tr><td class='Opts'>" + st1 + "</td><td class='Opts'>" + st2 + "</td><td class='Opts'>" + profileUpdate + "</td><td style='width:1200px;background-color:darkblue'></td></tr></table><br/>");
                }
            }
            else
                Response.Write("<table><tr><td style='width:600px;background-color:red;'>" + st1 + "&nbsp&nbsp&nbsp</td><td style='width:1200px;background-color:red'></td></tr></table><br/>");

        }
        public void Page_Load()
        {
            OleDbDataReader dr2;
            if (Session["username"] == null)
                Response.Redirect("HomePage.aspx");
            int status = getStatus();
            if(status==2)
            {
                string st = null;
                options(true);
                Response.Write("<center>");
                OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
                conn.Open();
                //string sqls = "select tusers.Username,Count(qID) as ques from tusers INNER JOIN Questions";
                //sqls += " ON tusers.Username=Questions.Username Group By tusers.Username";
                string sqls = "SELECT * FROM tusers ";
                OleDbDataReader dr = query.queries.query(sqls, conn);
                Response.Write("<table>");
                Response.Write("<tr style='width:70%'>");
                Response.Write("</tr><tr>");
                Response.Write("<form action='user.aspx' method='post'>");//the sending form
                Response.Write("<table id='tabl'>");
                Response.Write("<tr><td class='titles'>user name</td><td class='titles'>questions asked</td><td class='titles'>see profile</td></tr>");
                while(dr.Read())
                {
                    if(dr["permissions"].ToString()=="1")
                    {
                        sqls = "SELECT COUNT(qID) as ques FROM Questions WHERE Username='" + dr["Username"] + "' GROUP BY Username;";
                        dr2 = query.queries.query(sqls, conn);
                        if (dr2.Read())
                        {
                            Response.Write("<tr>");
                            Response.Write("<td class='names'>" + dr["Username"] + "</td>");
                            Response.Write("<td>" + dr2["ques"] + "</td>");
                            Response.Write(string.Format("<td class='buttons'><input type='submit' name='user' value='{0}' /></td>", dr["Username"]));
                            Response.Write("</tr>");
                        }
                        else
                        {
                            Response.Write("<tr>");
                            Response.Write("<td class='names'>" + dr["Username"] + "</td>");
                            Response.Write("<td>0</td>");
                            Response.Write(string.Format("<td class='buttons'><input type='submit' name='user' value='{0}' /></td>", dr["Username"]));
                            Response.Write("</tr>");
                        }
                    }
                }
                Response.Write("</table></from></tr></table>");
                Response.Write("</center>");
                conn.Close();
            }
            else
            {
                Response.Write("<center>");
                Response.Write("<marquee behavior=scroll direction='left' scrollamount='20'><h1 style='background-color:red'>You are not allowed here!");
                Response.Write("<div id='time'>3 Seconds</div></h1></marquee></center>");
                //Response.Redirect("HomePage.aspx");
            }
        }
    </script>
    <script type="text/javascript">
        if (document.getElementById("time") != undefined) {
            setTimeout(function () { redirect("HomePage.aspx") }, 3000);
            setInterval(function () { setTimer(); }, 1000);
        }
        function setTimer()
        {
            var time = document.getElementById("time").innerText.split(" ")[0];
            //alert(time);
            document.getElementById("time").innerText = (parseInt(time) - 1).toString() + "Seconds";
        }
        function redirect(url)
        {
            document.write("<a href='" + url + "' id='rdct'></a>");
            document.getElementById("rdct").click();
        }
       
    </script>
    <script src="jquery-3.2.1.min.js"></script>
    <script>
        $(document).ready(function () {
            $('.Opts').fadeTo('fast',0.5);
            $('.Opts').mouseenter(function () {
                $(this).fadeTo('fast', 1);
            });
            $('.Opts').mouseleave(function () {
                $(this).fadeTo('fast', 0.5);
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
    </script>
    <script src ="annyang.min.js"></script>
<script>
        if (true) {
            var commands = {
                "goto *tag": function (tag) {
                    annyang.trigger("go to " + tag);
                }
                , "go to *tag": function (tag) {
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
                    if (!b)
                        window.location = "https://www.google.co.il/search?rlz=1C1CHWA_enIL648IL648&q=" + text;
                    else
                        window.location = "https://www.google.co.il/search?rlz=1C1CHWA_enIL648IL648&q=" + text + "oq=" + parts[0];
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
</body>
</html>
