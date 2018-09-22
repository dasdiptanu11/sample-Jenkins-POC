<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Views/Shared/Site.master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="App.UI.Web._Default" %>

<%@ Register Src="Views/Home/Login.ascx" TagName="Login" TagPrefix="uc1" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
   
	    <telerik:RadCodeBlock ID="rcb" runat="server">
        <script src="Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                document.getElementById("MainContent_ucLogin_LoginUser_UserName").focus();
            });
        </script>

    </telerik:RadCodeBlock>


</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <br />
    <br />
    <br />
 
</asp:Content>
