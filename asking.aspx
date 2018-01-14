<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>
<html>
<head>
    <title></title>
    <style>
        .Opts{
           width:10%;background-color:darkblue;
        }
        div{    
            text-align:center;
            background-color:brown;
        }
        td{
            color:cornsilk;
        }
        input{
            border-radius:10px;
        }
        textarea{
            border-radius:10px;
        }
        select{
            border-radius:30px;
        }
        a{
            text-decoration:none;
            color:yellow;   
        }
    </style>
</head>
<body style="background: url(images.jpg) no-repeat;background-size:cover">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3mobile.css"/>
<script runat="server">
    string st = "";
    string disp = "style='display:";
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
        disp += Session["username"] != null?"normal'":"none'";
        if (Session["username"]==null)
        {
            Response.Redirect("HomePage.aspx");//change to 404 not found
        }
        options(true);
        Response.Write("<center>");
        OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
        conn.Open();
        OleDbDataReader dr = query.queries.query("select * from tags", conn);
        st += "<select name='tag_name'>";
        while(dr.Read())
        {
            st += "<option name='tag' value='"+dr["tag_name"]+"'>"+dr["tag_name"]+"</option>";
        }st += "</select>";
        Response.Write("</center>");
    }
</script>
<form action="questionSending.aspx" method="get" id="form1" <%=disp %>>
<div id="qBox">
<table>
    <tr><td colspan="2">Question asking</td></tr>
    <tr><td>Enter the Title for your question</td><td><input type="text" id="Title" name="Title"/></td></tr>
    <tr><td>Write your question here</td><td><textarea name="Text" id="vals"></textarea></td></tr>
    <tr><td>Choose the topic of the question</td><td><%=st %></td></tr>   
    <tr><td><input type="button" onclick="check_values()" value="Ask"></td><td><input type="reset" value="Clear"/></td></tr>
</table>
<script type="text/javascript">
    function check_values()
    {
        var title = document.getElementById("Title");
        var values = document.getElementById("vals");
        if(false)
        {
            alert("you can't hack this website");
            return;
        }
        else
        {
            if(values.value==""||title.value=="")
            {
                alert("you must enter vlaues");
                return;
            }
            else if(values.value.indexOf("'")!=-1||title.value.indexOf("'")!=-1)
            {
                alert("can't enter ' ");
                return;
            }
        }
        document.getElementById("form1").submit();
        
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
</div>
</form>
</body>
</html>