<%@ Page Language="C#"%>
<%@ Import Namespace="System.Data.OleDb" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <title></title>
    <style>
        #err{
            display:none;
        }
        input{
            border-radius:5px;
            background-color:white;
        }
        a{
            text-decoration:none;
            color:cornsilk;
        }
        .side
        {
            width:70px;
        }
        .oldLet{
            font-family:'Old English Text MT';
        }
        .Opts{
            width:10%;background-color:darkblue;color:cornsilk;
        }
        .Opts1{
            width:10%;background-color:green;
        }
        .Login{
            border-radius:30px;
        }
        .log{
            border-radius:30px;
        }
        #errors
        {
            color:red;
        }
    </style>
</head>
<body style="background: url(images.jpg) no-repeat;background-size:cover">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3mobile.css"/>
   <script runat="server">
       //C# part
       void options(bool connected)
       {
           string permissions = "0";
           string st1 = String.Format("<a href='Questions.aspx'>Questions</a>");
           string st2 = String.Format("<a href='asking.aspx'>Ask a question</a>");
           string st3 = String.Format("<a href='users.aspx'>Users</a>");
           string profileUpdate = "<a href='profileUpdate.aspx'>update your profile</a>";
           string tag = "<a href='addTag.aspx'>add a tag</a>";
           if (connected)
           {
               if(admin(Session["username"].ToString()))
               {
                   Response.Write("<table><tr><td class='Opts'>" + st1 + "</td><td class='Opts'>" + st2 + "</td><td class='Opts'>" + profileUpdate + "</td><td  class='Opts'>" + st3 + "</td><td class='Opts'>"+tag+"</td><td style='width:1200px;background-color:darkblue'></td></tr></table><br/>");
                   permissions = "2";
               }
               else
               {
                   Response.Write("<table><tr><td class='Opts'>" + st1 + "</td><td class='Opts'>" + st2 + "</td><td class='Opts'>" + profileUpdate + "</td><td style='width:1200px;background-color:darkblue'></td></tr></table><br/>");
                   permissions = "1";
               }
           }
           else
               Response.Write("<table><tr><td class='opts' style='width:600px;background-color:red;'>" + st1 + "</td><td style='width:1200px;background-color:red'></td></tr></table><br/>");
           Response.Write("<div style='display:none' id='permissions'>" + permissions + "</div>");
       }
       public bool admin(string username)
       {
           OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
           conn.Open();
           OleDbDataReader dr = query("select * from tusers where Username='" + username + "'", conn);
           if (dr.Read())
           {
               string st = dr["permissions"].ToString();
               conn.Close();
               return st == "2";
           }
           return false;
       }
       public void forLoggedIn(string s)
       {
           Response.Write("<h1 style='text-align:center;' id='user' class='oldLet'>Welcome " + s + "</h1>");
           Response.Write("<div style='text-align:center'><input value='sign out' type='button' onclick='f_Click2()' class='oldLet' id='btn'/></div>");
       }
       public string searchInCookies(string key)
       {
           if (Session[key] != null)
           {
               return Session[key].ToString();
           }
           else
               return null;
       }
       public void setCookie(string name,string value)
       {
           Session[name] = value;
       }
       public void Updatequery(string q,OleDbConnection conn)
       {
           OleDbCommand cmd = new OleDbCommand(q, conn);
           cmd.ExecuteNonQuery();
       }
       public OleDbDataReader query(string q,OleDbConnection conn)
       {
           OleDbCommand cmd = new OleDbCommand(q, conn);
           return cmd.ExecuteReader();
       }
       public static string Login()
       {
           string st = "";
           st += "<center>";
           //st += "<table><tr><td class='side'></td><td id='log' style='background-color:aqua;text-align:center;width:30%;'>";
           st += "<div id='Login' style='background-color:aqua;text-align:center;width:30%;'><form action='register.aspx' name='sign' value='up' method='post' id='form1'><table><tr><td colspan='2'><h1 id='titles'>Sign-up</h1></td></tr><tr><td><h3>username</h3></td><td><input type='text' name='username' id='username' /></td></tr><tr><td><h3>password</h3></td><td><input type='password' name='password' id='password'/></td></tr>";
           st += "<tr><td class='re'><h3>repeat password</h3></td><td class='re'><input type='password' id='repeat'/></td></tr>";
           st +="<tr><td id='email0'><h3>email</h3></td><td><input type='email' name='email' id='email1'></td></tr>";
           st+="<tr><td><input type='button' onclick='f_Click()' value='register' id='register'/></td><td><input type='button'onclick='f_Click3()'value='Login' id='login'/></td></tr><tr><td colspan='2'><input type='button' onclick='f_ClickS()' value='send'></td></tr><tr><td id='errors'><h2></h2></td></tr></table></form></div>";
           //st += "</td></tr></table>";
           st += "</center>";
           return st;
       }
       public void echo(string str)
       {
           Response.Write(str);
       }
       public void Page_Load()
       {
           /*int i = 0;
           Response.Write((5 / i).ToString());*///internal debugging (NOT NEEDED)
           string s;
           bool was = false;
           OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source="+Server.MapPath("db.accdb"));
           conn.Open();
           OleDbDataReader users;
           try
           {
               if (Request.Form["error"] == "1")
               {
                   options(false);
                   Response.Write("<h1 style='text-align:center' id='err'>Username Already exists</h1>");
                   string str = Login();
                   Response.Write(str);
                   was = true;
               }
               else if (Request.Form["error"] == "11")
               {
                   options(false);
                   Response.Write("<h1 style='text-align:center' id='err'>Password or username not correct</h1>");
                   string str = Login();
                   Response.Write(str);
                   was = true;
               }
           }
           catch { }
           try
           {

               if (Session["username"]!=null)
               {
                   options(true);
                   forLoggedIn(Session["username"].ToString());
               }
               else if(!was)
               {
                   string str = Login();
                   options(false);
                   Response.Write(str);
               }
           }
           catch(Exception e)
           {
               if(!was)
               {
                   string str = Login();
                   options(false);
                   Response.Write(str);
               }
           }
           conn.Close();
       }
</script>

<!-- JAVASCRIPT SCPIRT   -->
<script type="text/javascript">
    function containError(user)
    {
        var str = "!@#$%^&*()";
        for (i = 0; i < str.length; i++) {
            if (user.lastIndexOf(str[i]) != -1)
                return true;
        }
        return false;
    }
    String.prototype.contains = function(str)
    {
        var counter = 0;
        for(var i=0;i<this.length;i++)
        {
            if(this[i]==str[counter])
            {
                counter++;
            }
            if(counter==str.length())
            {
                return true;
            }
        }
        return false;
    }
    function f_Click() {
        var x = document.getElementById("username");
        var y = document.getElementById("password");
        for (i = 0; i <= 1; i += 1) {
            var email = document.getElementById("email" + i.toString());
            email.style = '';
        }
        var re = document.getElementsByClassName("re");
        for (i = 0; i < re.length; i++)
        {
            re[i].style = '';
        }
        document.getElementById("register").style = 'background-color:blue;color:white';
        document.getElementById("login").style = "";
        document.getElementById("titles").innerText = "Sign-up";
        document.getElementById("form1").action = "register.aspx";
    }
    function f_Click2() {
        var str = "<div id='Login' style='background-color:aqua;text-align:right'><h4>Sign-up</h4><form action='register.aspx' name='sign' value='up' method='post' id='form1'>username <input type='text' name='username' id='username' /><br/>password <input type='password' name='password' id='password'/><br /><input type='button' onclick='f_Click()' value='submit'/></form></div>";
        document.write(str);
        document.getElementById("username").value = "DELETE";
        document.getElementById("form1").submit();
    }
    function f_Click3() {
        document.getElementById("password").value = "";
        document.getElementById("username").value = "";
        var form = document.getElementById("form1");
        for (i = 0; i <= 1; i += 1) {
            var email = document.getElementById("email" + i.toString());
            email.style = 'display:none';
        }
        var arr = document.getElementsByClassName("re");
        for (i = 0; i < arr.length; i++)
        {
            arr[i].style = "display:none";
        }
        document.getElementById("login").style = 'background-color:blue;color:white';
        document.getElementById("register").style = "";
        document.getElementById("titles").innerText = "Login";
        form.action = "Login.aspx";
    }
    function f_ClickS() {
        document.getElementById("errors").innerText = "";
        var form = document.getElementById("form1");
        if (document.getElementById("username").value.indexOf("'") != -1 || document.getElementById("password").value.indexOf("'") != -1)
        {
            document.getElementById("errors").innerText = "cannot enter ' characher";
            return;
        }
        if (form.action == "http://localhost:56266/Login.aspx") {
            if (document.getElementById("username").value == "") {
                document.getElementById("errors").innerText = "you must enter username";
                 //alert("you must enter username");
            }
            else if (document.getElementById("password").value == "") {
                document.getElementById("errors").innerText = "you must enter password";
               // alert("you must enter passowrd");
            }
            else {
                form.submit();
            }
        }
        else {
            if (document.getElementById("password").value != document.getElementById("repeat").value)
            {
                document.getElementById("errors").innerText = "password does not match";
                return;
            }
            if (document.getElementById("username").value != "" && document.getElementById("password").value != "") {
                if (document.getElementById("password").value.length >= 3) {
                    //document.getElementById("password").value
                    // alert("123");
                    var email = document.getElementById("email1").value;
                    if (email.indexOf("@") != -1 && email.indexOf("'") == -1) {
                        //alert(document.getElementById("email1").value);
                        if (email.indexOf(".") != -1 && email.indexOf("@") < email.indexOf(".")) {
                            if (!containError(document.getElementById("username").value))
                                form.submit();
                            else
                                document.getElementById("errors").innerText = "Invalid Username";
                        }
                        else {
                            document.getElementById("errors").innerText = "Invalid Email";
                        }
                    }
                    else {
                        document.getElementById("errors").innerText = "Invalid Email";
                    }
                }
                else {
                    document.getElementById("errors").innerText = "password must conatin at least 3 characters";
                    //alert("password must contain at least 3 characters");
                }
            }
            else {
                document.getElementById("errors").innerText = "you must enter values";
                //alert("you must enter values");
            }
        }
        responsiveVoice.speak(document.getElementById("errors").innerText);
    }
    if (document.getElementById("password") != undefined)
        f_Click3();
    /*function showLogin(){
	 var str="<div  style='background-color:aqua;text-align:right'><h4>Sign-up</h4><form name='sign' value='up' method='post' id='form1'>username <input type='text' name='username' id='username' /><br/>password <input type='password' name='password' id='password'/><br />email<input type='text' name='email' id='email'/><br/><input type='button' onclick='f_Click()' value='submit'/></form></div>";
	 document.getElementById("Login").innerHTML="<h1>afae</h1>";
	 //document.getElementById("Sign").innerHTML="<div  style='background-color:red;text-align:left'><h4>Sign-up</h4><form name='sign' value='in' method='post' id='form1'>username <input type='text' name='username' id='username' /><br/>password <input type='password' name='password' id='password'/><br/><input type='button' onclick='f_Click()' value='submit'/></form></div>";
	}*/
    var err = document.getElementById("err");
    if(err!=undefined&&err!=null)
    {
        document.getElementById("errors").innerText = err.innerText;
        
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
        $('#btn').mouseenter(function () {
            $(this).css("background-color", "black");
            $(this).css("color", "white");
        });
        $('#btn').mouseleave(function () {
            $(this).css("background-color", "white");
            $(this).css("color", "black");
        });
    });
</script>
<script src="responsivevoice.js"></script>
<script>
    if (document.getElementById("err") == undefined || document.getElementById("err") == null) {
        var permissions = document.getElementById("permissions").innerText;
        if (permissions == "0")
            responsiveVoice.speak("hello guest and welcome to stack OVERFLOW", "Deutsch Female");
        else if (permissions == "1") {
            var text = document.getElementById("user").innerText;
            var parts = text.split(" ");
            text = "";
            for (i = 1; i < parts.length; i++) {
                text += parts[i];
            }
            responsiveVoice.speak("hello " + text + " and welcome to stack overflow");//text is the name of the user
        }
        else
            responsiveVoice.speak("hello Admin, you probably know what to do");
    }
    else
        responsiveVoice.speak(document.getElementById("err").innerText);
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
            }
            , "*tag": function (tag) {
                console.log(tag);
            }
        };
        annyang.addCommands(commands);
        annyang.start();
    }
</script>
<script>
  /*  var rec = new webkitSpeechRecognition();
    rec.onresult = function (event) {
        var text = event.results[0][0]["transcript"];
        var elms;
        elms = document.getElementsByClassName("opts");
        if(elms==undefined||elms==null)
            elms = document.getElementsByClassName("Opts");
        for(i=0;i<elms.length;i++)
        {
            /*alert(elms[i].innerText.toLowerCase() + ";" + text.toLowerCase());
            alert(elms[i].innerText.toLowerCase()=="questions");
            alert(text.toLowerCase()=="questions");
            if(elms[i].innerText.toLowerCase()==text.toLowerCase())
            {
                elms[i].getElementsByTagName("a")[0].click();
            }
            else if(elms[i].innerText.toLowerCase()==text.toLowerCase()+"s")
            {
                elms[i].getElementsByTagName("a")[0].click();
            }
        }
        console.log(text);
    }
    setTimeout(function () { alert("speak now");rec.start(); }, 3500);
    */
</script>
    <h1 id="time"></h1>
</body>
</html>
