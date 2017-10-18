<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Collections.Generic" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <title></title>
    <style>
        input{
            border-radius:30px;
        }
        textarea{
            border-radius:5px;
        }
		 #EditQuestion{
			 background-color:white;
			 color:black;
		 }
         #question{
             text-align:center;
             color:cornsilk;
             background-color:brown;
         }
         #q{
             color:cornflowerblue;
         }
         #qBox{
             background-color:brown;
             color:white;
         }
		 h7
		 {
			 font-family:Old English Text;
			 color:black;
		 }
		 .side{
			 width:300px;
			 background-color:white;
		 }
		 .cmtt{
			 background-color:white;
			 color:black;
		 }
		 .oldLet{
			font-family:Old English Text MT;
		}
        .T {
            background-color:brown;
            color:green;
        }
        .Opts{
            color:cornsilk;background-color:darkblue;width:10%;
        }
        .opts{
            color:cornsilk;
        }
		 a{
			 text-decoration:none;
			 color:yellow;
		 }
         .text{
           
         }
     </style>
</head>
<body style="background: url(images.jpg) no-repeat;background-size:cover">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3mobile.css"/>
    <script runat="server">
        public void options(bool connected)
        {
            string st1=String.Format("<a href='HomePage.aspx'>HomePage</a>");
            string st2=String.Format("<a href='asking.aspx' >Ask a question</a>");
            string st3 = String.Format("<a href='users.aspx'>Users</a>");
            string st4 = String.Format("<a href='addTag.aspx'>add a tag</a>");
            string st5 = String.Format("<a href='Questions.aspx'>Questions</a>");
            ///TODO : add users link and add tag link for admin
            if (connected)
            {
                if(query.queries.admin(Session["username"].ToString(),Server))
                {
                    Response.Write("<table><tr><td class='Opts'>" + st1 + "</td><td class='Opts'>"+st5+"</td><td class='Opts'>" + st2 + "</td><td style='width:1200px;background-color:darkblue'></td> <td class='Opts'>" + st3 + "</td></tr></table><br/>");
                }
                else
                {
                    Response.Write("<table><tr><td class='Opts'>" + st1 + "</td><td class='Opts'>"+st5+"</td><td class='Opts'>" + st2 + "</td><td style='width:1200px;background-color:darkblue'></td></tr></table><br/>");
                }
            }
            else
                Response.Write("<table><tr><td class='op' style='width:200px;background-color:red;'>" + st1 + "</td><td class='op' style='width:600px;background-color:red;'>"+st5+"</td><td style='width:1200px;background-color:red'></td></tr></table><br/>");

        }
        public void echo(string str)
        {
            Response.Write(str);
        }
        public string VF(int i)
        {
            char c='a';
            if(i==0)
            {
                c='q';
            }
            string st;
            st = "<h2>Voting</h2>";
            st += "<form action='Comment.aspx' method='post'>";
            st += "<input type='text' style='display:none' name='qa' value='q'/>";
            st += "<input type='text' style='display:none' name='id' value='"+Request.QueryString["q"]+"'/>";
            st += "<table style='background-color:brown;color:white'><tr><td>upVote</td><td><input type='radio' id='upv' name='upV' value='1'/></td></tr>";
            st += "<tr><td>downVote</td><td><input type='radio' name='upV' id='downv' value='-1'/></td></tr>";
            st+="<tr><td colspan='2'><input type='submit' value='send'></td></tr>";
            return st;
        }
        /// <summary>
        /// checks whether the user is valid for voting for the question
        /// </summary>
        /// <param name="conn"></param>
        /// <returns></returns>
        public bool validForVote(OleDbConnection conn)
        {
            bool valid = false;
            OleDbDataReader data;
            try
            {
                if(Session["username"]!=null)
                {
                    string sql = "SELECT * FROM Questions WHERE qID=" + Request.QueryString["q"] + " AND Username='" + Session["username"].ToString() + "';";
                    data = query.queries.query(sql, conn);
                    if(data.Read())
                    {
                        return false;
                    }
                    sql = "SELECT * FROM comments_Questions WHERE Username='" + Session["username"].ToString()+ "' AND qID=" + Request.QueryString["q"] + " AND (vote=-1 OR vote=1)";
                    data = query.queries.query(sql, conn);
                    if(!data.Read())
                    {
                        valid = true;
                    }
                }
            }
            catch
            {
                valid = false;
            }
            ///finally
            return valid;
        }
        /// <summary>
        /// chceks whether the user is valid for edit of the post
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public bool ValidForEdit(string str)
        {
            try
            {
                if (Session["username"].ToString() == str)
                {
                    return true;
                }
                if(query.queries.admin(Session["username"].ToString(),Server))
                {
                    return true;
                }
            }
            catch { }
            return false;
        }
        public int getStauts(OleDbConnection conn)
        {
            if (Session["username"] == null)
                return 0;
            if (query.queries.admin(Session["username"].ToString(), Server))
            {
                return 2;
            }
            else
                return 1;
        }
        string voting = "";
        public void showQuestionsAndAnswers()
        {

            OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
            int stauts=getStauts(conn);
            int i=0,j=0;
            string st1,st2,st3;
            string st4,st5,st6="";
            string st10="", st20="", st30 = "" ;
            OleDbDataReader qA,cmt;//qA is the data reader for answers and question and cmt is for comments_Questions
            conn.Open();
            echo("<table>");
            qA=query.queries.query("SELECT * FROM Questions WHERE qID="+Request.QueryString["q"]+";",conn);
            //Question data:
            while(qA.Read()){
                if (qA["MainText"] == "")
                    Response.Redirect("Questions.aspx");
                cmt=query.queries.query("SELECT * FROM comments_Questions WHERE qID="+qA["qID"]+" AND vote=0",conn);
                st3=qA["Username"].ToString();
                st2=qA["MainText"].ToString();
                st1=qA["Title"].ToString();
                st4="";
                st5="<tr></tr>";
                st6="";
                while(cmt.Read())
                {
                    if(cmt["MainText"].ToString()!="")
                    {
                        j++;
                        st5+="<tr><td><div style='background-color:gray;color:yellow'><h1>"+cmt["Username"]+"</h1><b style='color:black'>___________________</b><br />"+cmt["MainText"]+"</div></td></tr>";
                    }
                }
                if (validForVote(conn))
                {
                    //st4="<form id='cmt0' action='Comment.aspx' method='post'><textarea name='text' id='cmtt0'></textarea><input type='text' style='display:none' id='cmtid0' name='id' value='"+Request.Form["id"]+"'/><input type='text' style='display:none' id='cmtv0' name='vote' value='0'/></form>";
                    //st4=VF(0);
                    voting = VF(0);
                }
                if(ValidForEdit(st3))//st3 == question's sender's username
                {
                    st10="<textarea id='EditQuestion"+i+"'>";
                    st2+="</textarea>";
                    //st1=" id='EditQuestion"+i.ToString()+"'";
                    st30 = "<td><form action='questionSending.aspx' method='post' id='f" + i.ToString() + "'>";
                    st30 += "<textarea  name='Text' id='txt" + i.ToString() + "' style='display:none'></textarea><input type='text' name='qID' id='qid" + i.ToString() + "'style='display:none'/><input type='text' name='type' value='U' style='display:none'/><input type='button' value='edit' onclick='sf(" + i.ToString() + ")'/>";
                    st30+="<input type='button' value='delete' onclick='del("+i.ToString()+")'></form></td>";
                }
                else
                {
                    st10 = "<p>";
                    st2 += "</p>";
                }
                if (Session["username"] != null)//COMMENT FORM
                    st6="<tr><td><div style='background-color:gray;color:yellow'><h1>add a comment</h1><b style='color:black'>___________________</b><br /><form id='cmt0' action='Comment.aspx' method='post'><textarea name='text' class='cmtt' id='cmtt0'></textarea><input type='text' style='display:none' id='cmtid0' name='id' value='"+Request.QueryString["q"]+"'/><input type='text' style='display:none' id='cmtv0' name='value' value='0'/><input type='button' value='submit' onclick='scmt(0)'><input type='text' style='display:none' name='qa' value='q'></form></div></td></tr>";
                echo("<tr><td>");
                echo("<div align='center' id='question'><table  id='q'><tr><td colspan='2' class='T'><h2>"+st1+"</h2></td><td>"+st4+"</td></tr><tr><td colspan='2' class='text'>"+st10+st2+"</td><td>"+st30+"</td><tr></tr><tr><td>submitted by:</td><td>"+st3+"</td></tr><tr><td style='color:black'>______________________</td></tr><tr>"+st5+"</tr>"+st6+"</table></div>");
                echo("</td></tr>");
            }
            echo("<br/>");
            echo("<tr><td><h1>Answers</h1></td></tr>");
            qA=query.queries.query("SELECT * FROM Answers WHERE qID="+Request.QueryString["q"]+";",conn);
            //Answers Data:
            while(qA.Read()){
                cmt=query.queries.query("SELECT * FROM comments_Answers WHERE aID="+qA["aID"]+"",conn);
                i++;
                st1 = "";
                st3=qA["Username"].ToString();
                st2=qA["MainText"].ToString();
                st4="<td></td>";
                st5="<tr></tr>";
                while(cmt.Read())
                {
                    st5+="<tr><td><div style='background-color:gray;color:yellow;'><h1>"+cmt["Username"]+"</h1><b style='color:black'>___________________</b><br />"+cmt["MainText"]+"</div></td></tr>";
                }
                if(Session["username"]!=null)
                    st6="<tr><td><div style='background-color:gray;color:yellow'><h1>add a comment</h1><b style='color:black'>___________________</b><br /><form id='cmt"+i+"' action='Comment.aspx' method='post'><textarea name='text' class='cmtt' id='cmtt"+i+"'></textarea><input type='text' style='display:none' id='cmtid"+i+"' name='id' value='"+qA["aID"]+"'/><input type='text' style='display:none' id='cmtv"+i+"' name='value' value='0'/><input type='button' value='submit' onclick='scmt("+i+")'><input type='text' style='display:none' name='qa' value='a'></form></div></td></tr>";
                /*if(ValidForEdit(st3))//st3 = question's sender's username
                {
                    st1 = "<input type='text' name='type' value='U' style='display:none'>";
                    st1+="<textarea id='EditQuestion"+i.ToString()+"'>";
                    st2+="</textarea>";
                    //st1=" id='EditQuestion"+i.ToString()+"'";
                    st4="<td><form action='answersend.aspx' method='post' id='f"+i.ToString()+"'><textarea  name='Text' id='txt"+i.ToString()+"' style='display:none'></textarea><input type='text' name='qID' id='qid"+i.ToString()+"'style='display:none'/><input type='text' name='type' value='U' style='display:none'/><input type='text' name='aID' value='"+qA["aID"]+"' style='display:none'/><input type='button' value='edit' onclick='sf("+i.ToString()+")'/></form></td>";
                }*/
                else
                {
                    st1="<p>";
                    st2+="</p>";
                }
                echo("<tr><td>");
                echo("<div style='background-color:brown;color:cornsilk;'><table align='left' id='q' style='background-color:brown'><tr><td colspan='2' class='text'>"+st1+st2+"</td>"+st4+"</tr><tr></tr><tr><td colspan='2'>answered by:"+st3+"</td></tr><tr><td colspan='2'></td></tr>"+st5+"<tr>"+st6+"</tr></table></div>");
                echo("</td></tr>");
            }
            conn.Close();

            /*catch(Exception e)
            {
                echo(e.Message);
            }*/
        }

        public void Page_Load()
        {
            if (Request.QueryString["q"] ==null)
                Response.Redirect("Questions.aspx");
            bool connection = false;
            string st1="",st2="";
            connection = Session["username"] != null;
            options(connection);
            echo("<center>");
            // echo("<table><tr><td class='side'></td><td style='background-color:aqua'>");
            showQuestionsAndAnswers();
            //echo("</td></tr></table>");
            if(connection)
            {
                //echo("<tr><td class='side'></td><td>");
                st1="<div><form action='answersend.aspx' method='post' id='qs'><div id='qBox'><table style='background-color:brown;color:white;'><tr><td colspan='2'>Question answering</td></tr><tr><td>Write your answer here</td><td><textarea id='text' name='Text'></textarea></td></tr><tr><td>";
                st2="<input type='button' value='submit' onclick='check()'></td><td><input type='reset' value='Clear'/></td></tr></table></div><input type='text' name='qID' id='qID'  style='display:none;color:brown' value='"+Request.QueryString["q"]+"'/><input type='text' name='type' style='display:none;color:brown' value='S'/></form></div>";
                echo("</td><td class='side'></td></tr>");
                echo(st1+st2);
                echo("</br>" + voting);
            }
            echo("</center>");
        }
    </script>
    <!------------------------             javascript part  ------------------------->
    <script type="text/javascript">
        document.getElementById("upv").checked = true;
		 function fVote(vote)
		 {
			 var f=document.getElementById("fvote");
			 var votetxt=document.getElementById("vote");
			 votetxt.value=vote.toString();
			 f.submit();
			 
		 }
		 function supv(i)
		 {
			 var f=document.getElementById("vote"+i.toString());
			 var v=document.getElementById("vv"+i.toString());
			 v.value='1';
			 f.submit();
		 }
		 function scmt(i)
		 {
			 var f=document.getElementById("cmt"+i.toString());
			 var t=document.getElementById("cmtt"+i.toString());
			 if(t.value=="")
			 {
				 alert("you must enter a value");
			 }
			 else if(t.value.indexOf("'")!=-1)
			 {
			     alert("you can't enter ' character");
			 }
			 else 
			 {
				 f.submit();
			 }
		 }
         function sf(x)
         {
             var f = document.getElementById("f" + x.toString());
             var txt = document.getElementById("txt" + x.toString());
             var qid = document.getElementById("qid" + x.toString());
			 //alert(document.getElementById("EditQuestion" + x.toString()).value);
             txt.value = document.getElementById("EditQuestion" + x.toString()).value;
             qid.value = document.getElementById("qID").value;
             f.submit();
         }
         function del(i)
         {
             document.getElementById("qid" + i.toString()).value = document.getElementById("qID").value;
             document.getElementById("txt" + i.toString()).value = "";
             document.getElementById("f" + i.toString()).submit();
         }
		 function check()
         {
		     if (document.getElementById("text").value.indexOf("'") != -1)
		     {
		         alert("can't enter '");
		         return;
		     }
		     if(!document.getElementById("text").value=="")
		     {
		         document.getElementById("qs").submit();
		     }
		     else
		     {
		         alert("You must enter a value");
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
            $('.op').fadeTo('fast', 0.5);
            $('.op').mouseenter(function () {
                $(this).fadeTo('fast', 1);
            });
            $('.op').mouseleave(function () {
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
        console.log(text);
    }
    setTimeout(function () { alert("speak now");rec.start(); }, 200);
    
</script>
</body>
</html>
