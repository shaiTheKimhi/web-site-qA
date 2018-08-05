<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <style>
        a
        {
            color:white;
            text-decoration:none;
        }
        input
        {
            border-radius:30px;
            background-color:white;
        }
        .Opts{
           width:10%;background-color:darkblue;color:cornsilk;
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
           OleDbDataReader dr = query.queries.query(String.Format("SELECT permissions FROM tusers where username='{0}'", Session["username"].ToString()),conn);
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
                Response.Write("<table><tr><td class='opts' style='width:600px;background-color:red;'>" + st1 + "&nbsp&nbsp&nbsp</td><td style='width:1200px;background-color:red'></td></tr></table><br/>");

        }

       ////javascript functions:
       string update = "";
       string del = "";
       /// <summary>
       /// Gloabal variables
       /// </summary>
       string img = "";
       string UserName = "";
       string password = "";
       string permissions = "";
       string email = "";
       string first = "";
       string second = "";
       public void Page_Load()
       {
           if (Session["username"] == null)
               Response.Redirect("HomePage.aspx");
           if (getStatus() != 2)
               Response.Redirect("HomePage.aspx");
           options(true);
           OleDbConnection conn = new OleDbConnection(query.queries.connconst(Server));
           conn.Open();
           if(Request.Form["user"]!=null)
           {
               OleDbDataReader user = query.queries.query(string.Format("select * from tusers where Username='{0}'", Request.Form["user"]), conn);
               user.Read();
               password = user["upass"].ToString();
               permissions = user["permissions"].ToString();
               email = user["email"].ToString();
               UserName = Request.Form["user"];
           }
           else
           {
               /*if(Request.Form["type"]=="U")
               {
                   string temp = string.Format("update tusers set upass='{0}',permissions={1},email={3} where Username='{2}'", Request.Form["password"], Request.Form["permissions"],Request.Form["userName"],Request.Form["email"]);
                   // query.queries.updateQuery(string.Format("update Questions set Username={0} where Username={1}", Request.Form["User"], Request.Form["prevName"]), conn);
                   query.queries.updateQuery(temp, conn);
                   password = Request.Form["upass"];
                   permissions = Request.Form["permissions"];
                   UserName = Request.Form["User"];
               }*/
           }
           conn.Close();
           //javascript functions
           update = "update('"+UserName+"')";
           del = "del('" + UserName + "')";
       }

   </script>
    <form action ="updateUser.aspx" method="post">
        <input type="text" name="User" value="<%=UserName %>" style="display:none"/>
    <table <%=first %>>
        <tr><td rowspan="3"><h3><%=UserName %></h3></td><td>password:<%=password %></td></tr>
        <tr><td>permissions:<%=permissions %></td></tr>
        <tr><td>email:</td><td><%=email %></td></tr>
        <tr><td><input type="submit" value="make admin"/></td><td><input type="button" onclick="<%=update%>" value="update profile" /></td></tr>
    </table>
    </form>
    <script>
        function submit()
        {
            
        }
        function httpGet(url)
        {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", url, false);
            xmlhttp.send(null);
            return xmlhttp.responseText;
        }
        function update(str)
        {
            document.write("<a href='profileUpdate.aspx?user=" + str + "'id='rdct'></a>");
            document.getElementById("rdct").click();
       }
        function del(str)
        {
            document.write("<a href='delete_User.aspx?User="+str+"' id='rdct'></a>");
            document.getElementById("rdct").click();
            /*document.documentElement.innerHTML = "";
            document.write(httpGet("delete_User.aspx?User=" + str));*/
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
