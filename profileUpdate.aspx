<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="query" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        #bbton{
            width:300px;
            background-color:black;
            color:cornsilk;
        }
        h1{
            color:blue;
        }
        h3{
            color:green;
        }
        input{
            font-size:medium;
        }
        .Opts
        {
            width:10px;background-color:darkblue;
        }
        a{
            text-decoration:none;
            color:white;
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
            string profileUpdate = "<a href='users.aspx'>Users</a>";
            if (connected)
            {
                if(query.queries.admin(Session["username"].ToString(),Server))
                {
                    Response.Write("<table><tr><td class='Opts'>" + st1 + "</td><td class='Opts'>" + st2 + "</td><td class='Opts'>" + profileUpdate + "</td><td class='Opts'>" + st3 + "</td><td style='width:1200px;background-color:darkblue'></td></tr></table><br/>");
                }
                else
                {
                    Response.Write("<table><tr><td class='Opts'>" + st1 + "</td><td class='Opts'>" + st2 + "</td><td style='width:1200px;background-color:darkblue'></td></tr></table><br/>");
                }
            }
            else
                Response.Write("<table><tr><td style='width:600px;background-color:red;'>" + st1 + "&nbsp&nbsp&nbsp</td><td style='width:1200px;background-color:red'></td></tr></table><br/>");

        }
        public void Page_Load()
        {
            if (Session["username"] == null)
                Response.Redirect("HomePage.aspx");
            if(Request.HttpMethod=="POST")
            {
                OleDbConnection conn = new OleDbConnection(queries.connconst(Server));
                conn.Open();
                string pass = Request.Form["password"];
                string username = Request.Form["user"];
                OleDbDataReader dr = queries.query("select * from tusers where Username='"+username+"'", conn);
                if(dr.Read())
                {
                    if(dr["upass"].ToString()!=pass)
                    {
                        conn.Close();
                        Response.Write("password does not match");
                        return;
                    }
                }
                string sql = string.Format("update tusers set upass='{0}',email='{1}' where Username='{2}'", Request.Form["Npassword"], Request.Form["email"], username);
                queries.updateQuery(sql, conn);
                conn.Close();
                Response.Write("<div id='rd'></div>");
                Response.Write("your details have been updated successfully");
                //Response.Redirect("HomePage.aspx");
            }
            else
            {
                bool admin = false;
                string nameUser;
                if (Request.QueryString["user"] != null)
                {
                    if (Request.QueryString["user"] == null)
                        Response.Redirect("HomePage.aspx");
                    nameUser = Request.QueryString["user"];
                    admin = true;
                    if (!queries.admin(Session["username"].ToString(), Server))
                    {
                        Response.Write("you do not have sufficient permissions");
                        Response.Write("<div id='rd'></div>");
                        return;
                    }

                }
                else
                    nameUser = Session["username"].ToString();
                options(true);
                OleDbConnection conn = new OleDbConnection(queries.connconst(Server));
                conn.Open();
                string query = string.Format("select * from tusers where Username='{0}'", nameUser);
                OleDbDataReader user = queries.query(query,conn);
                Response.Write("<center>");
                Response.Write(showForm(user,admin));
                Response.Write("</center>");
                conn.Close();
            }
        }
        public string showForm(OleDbDataReader user,bool admin)
        {
            if (user.Read())
            {
                if(!admin)
                {
                    string st = "";
                    st += "<form action='profileUpdate.aspx' method='post' name='frm1'>";
                    st += "<input type='text' name='user' value='" + user["Username"] + "' style='display:none'>";
                    /* st += "<table>";
                     st += "<tr rowspan='3'><td><h4>" + Session["username"].ToString() + "</h4></td>";
                     st += "<td>password</td>";
                     st += "<td><input type='text' value='" + user["upass"] + " name='password'</td></tr>";
                     st += "<tr><td>email</td><td><input type='text' name='email' value='" + user["email"] + "'></td>";
                     st += "</tr><tr><td colspan='2'><input type='button' value='update' onClick='send()'></td></tr>";*/
                    st += "<table><tr><td rowspan='3'><h1>" + user["Username"] + "</h1></td>";
                    st += "<td><h3>password:</h3></td><td><input type='password' id='password' name='password'></td></tr>";
                    st += "<td><h3>new password</h3></td><td><input type='password' id='Npassword' name='Npassword'></td></tr>";
                    st += "<tr><td><h3>email:</h3></td><td><input type='text' id='email' name='email' value='" + user["email"] + "'></td></tr>";
                    st += "<tr><td colspan='2'><input type='button' id='bbton' value='update' onClick='send()'></td></tr>";
                    st += "</form>";
                    return st;
                }
                else
                {
                    string st = "";
                    st += "<form action='profileUpdate.aspx' method='post' name='frm1'>";
                    st += "<input type='text' name='user' value='" + user["Username"] + "' style='display:none'>";
                    /* st += "<table>";
                     st += "<tr rowspan='3'><td><h4>" + Session["username"].ToString() + "</h4></td>";
                     st += "<td>password</td>";
                     st += "<td><input type='text' value='" + user["upass"] + " name='password'</td></tr>";
                     st += "<tr><td>email</td><td><input type='text' name='email' value='" + user["email"] + "'></td>";
                     st += "</tr><tr><td colspan='2'><input type='button' value='update' onClick='send()'></td></tr>";*/
                    st += "<table><tr><td rowspan='3'><h1>" + user["Username"] + "</h1></td>";
                    st += "<td style='display:none'><h3>password:</h3></td><td style='display:none'><input type='password' id='password' name='password' value='"+user["upass"]+"'></td></tr>";
                    st += "<td><h3>new password</h3></td><td><input type='password' id='Npassword' name='Npassword'></td></tr>";
                    st += "<tr><td><h3>email:</h3></td><td><input type='text' id='email' name='email' value='" + user["email"] + "'></td></tr>";
                    st += "<tr><td colspan='2'><input type='button' id='bbton' value='update' onClick='send()'></td></tr>";
                    st += "</form>";
                    return st;
                }
            }//unreacheable code:
            else return null;
        }
        //A function that writes text to html document
        public void echo(string st)
        { Response.Write(st); }
    </script>


    <script type="text/javascript">
        if (document.getElementById("rd") != undefined)
            setTimeout(function () { redirect("HomePage.aspx"); },1500);
        function send()
        {
            var Npassword = document.frm1.Npassword;
            var password = document.frm1.password;
            var email = document.frm1.email;
            if(password.value==""||email.value==""||Npassword.value=="")
            {
                alert("your'e email and password must not be empty");
            }
            else if(password.value.lastIndexOf("'")!=-1||email.value.lastIndexOf("'")!=-1||Npassword.value.lastIndexOf("'")!=-1)
            {
                alert("you cannot enter the ' character");
            }
            else//submitting the form
            {
                document.frm1.submit();
            }
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
    setTimeout(function () { alert("speak now");rec.start(); }, 200);
    
</script>
</body>
</html>
