<%@ Page Language="C#"  %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="query" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <style>
        #form
        {
            background-color:black;
            color:white;
        }
        td
        {
            color:white;
        }
        input
        {
            background-color:cornsilk;
            border-radius:30px;
            color:brown;
            border:none;
        }
        .Opts{
            width:10%;background-color:darkblue;color:cornsilk;
        }
        a{
            color:cornsilk;
            text-decoration:none;
        }
    </style>
</head>
    <body style="background: url(images.jpg) no-repeat;background-size:cover">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3mobile.css"/>
        <script runat="server">
            public void options(bool connected)
            {
                string st1 = String.Format("<a href='HomePage.aspx'>HomePage</a>");
                string st2 = String.Format("<a href='Questions.aspx'>Questions</a>");
                string st3 = String.Format("<a href='asking.aspx'>Ask a question</a>");
                string profileUpdate = "<a href='profileUpdate.aspx'>update your profile</a>";
                string users = "<a href='users.aspx'>Users</a>";
                if (connected)
                {
                    if(query.queries.admin(Session["username"].ToString(),Server))
                    {
                        Response.Write("<table><tr><td class='Opts'>" + st1 + "</td><td class='Opts'>" + st2 + "</td><td class='Opts'>" + profileUpdate + "</td><td class='Opts'>" + st3 + "</td><td class='Opts'>"+users+"</td><td style='width:1200px;background-color:darkblue'></td></tr></table><br/>");
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
                object o = Session["Username"];
                if (o == null)
                    Response.Redirect("HomePage.aspx");
                if (!queries.admin(o.ToString(), Server))
                    Response.Redirect("HomePage.aspx");
                options(true);
                if(Request.HttpMethod=="POST")
                {
                    OleDbConnection conn = new OleDbConnection(query.queries.connconst(Server));
                    conn.Open();
                    string sql = string.Format("insert into tags values('{0}')", Request.Form["tagName"]);
                    query.queries.updateQuery(sql, conn);
                    conn.Close();
                    Response.Redirect("HomePage.aspx");
                }
                else
                {
                    Response.Write("<table><tr><td style='width:450px '></td><td>");
                    Response.Write(showForm());
                    Response.Write("</td></tr></table>");
                }
            }
            public string showForm()
            {
                string st = "";
                st += "<form method='post' id='form'><table>";
                st += "<tr><td colspan='2'><h1>Add a new Tag</h1><td></tr>";
                st += "<tr><td>tag name:</td><td><input type='text' name='tagName' id='text'/></td></tr>";
                st += "<tr><td colspan='2' id='errors' style='color:red'></td></tr>";
                st += "<tr><td colspan='2'><input type='button' onclick='buttonOnclick()' value='submit' id='submitButton'/></td></tr>";
                return st;
            }
</script>



    <script type="text/javascript">
        function main()
        {
            var redirect = document.getElementById("redirect");
            if(redirect==undefined)
            {
                redirect("HomePage.aspx");
            }
        }
        function buttonOnclick()
        {
            if(document.getElementById("text").value!="")
            {
                if(document.getElementById("text").value.lastIndexOf("'")!=-1)
                    document.getElementById("errors").innerText = "error:you cannot enter the ' character";
                else 
                    document.getElementById("form").submit();
            }
            else
            {
                document.getElementById("errors").innerText= "error:you must enter values"
            }
        }
      /*  function redirect(url)
        {
            document.write("<form style='display:none' id='rd' action='" + url + "'><input type='submit'/></form>");
            document.getElementById("rd").submit();
        }*/
    </script>
        <script src="jquery-3.2.1.min.js"></script>
        <script>
            $('.Opts').fadeTo('fast', 0.5);
            $('.Opts').mouseenter(function () {
                $(this).fadeTo('fast', 1);
            });
            $('.Opts').mouseleave(function () {
                $(this).fadeTo('fast', 0.5);
            });
            $('#submitButton').mouseenter(function () {
                $('#submitButton').css("background-color", "black");
                $('#submitButton').css("color", "white");
            });
            $('#submitButton').mouseleave(function () {
                $('#submitButton').css("background-color", "white");
                $('#submitButton').css("color", "black");
            });
        </script>
        <script>
    var rec = new webkitSpeechRecognition();
    rec.onresult = function (event) {
        var text = event.results[0][0]["transcript"];
        var elms;
        elms = document.getElementsByClassName("opts");
        if (elms == undefined || elms == null)
            elms = document.getElementsByClassName("Opts");
        for(i=0;i<elms.length;i++)
        {
            /*alert(elms[i].innerText.toLowerCase() + ";" + text.toLowerCase());
            alert(elms[i].innerText.toLowerCase()=="questions");
            alert(text.toLowerCase()=="questions");*/
            if(elms[i].innerText.toLowerCase()==text.toLowerCase())
            {
                elms[i].getElementsByTagName("a")[0].click();
            }
            else if(elms[i].innerText.toLowerCase()==text.toLowerCase()+"s")
            {
                elms[i].getElementsByTagName("a")[0].click();
            }
        }
    }
    setTimeout(function () { alert("speak now");rec.start(); }, 3500);
    
</script>
</body>
</html>
