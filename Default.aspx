<%@ Page Language="C#" %>
<script runat="server">
    public void createCookie(string key,string value)
    {
        Session[key] = value;
    }
    public string searchInCookies(string key)
    {
        if(Session[key]!=null)
        {
            return Session[key].ToString();
        }
        else
        {
            return null;
        }
    }
    public void Page_Load()
    {
        
    }
</script>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
