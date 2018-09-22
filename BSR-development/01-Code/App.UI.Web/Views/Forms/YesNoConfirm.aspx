<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="YesNoConfirm.aspx.cs" Inherits="App.UI.Web.Views.Forms.YesNoConfirm" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/ContentHeader.ascx" TagPrefix="uc" TagName="ContentHeader" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="~/Styles/Site.css" rel="stylesheet" type="text/css" />
</head>
<script type="text/javascript">
    function CloseWindow(args) {
        var oWindow = GetRadWindow();
        var WinContent = oWindow.get_contentFrame().contentWindow.parent;
        var ParentName = oWindow.get_contentFrame().contentWindow.parent.document.nameProp;
        oWindow.Argument = args;
        oWindow.close();
    }

    function GetRadWindow() {
        var oWindow = null;
        if (window.radWindow) oWindow = window.radWindow;
        else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow;
        return oWindow;
    }


</script>


<body>

    <form id="form1" runat="server">
        <asp:ScriptManager ID='scriptManager' runat='server' EnablePageMethods="true" />
        <%--  <asp:BulletedList ID="BrandErrorMsg" runat="server" ValidationGroup="BrandDataValidationGroup" CssClass="failureNotification" Style="list-style-type: none;"></asp:BulletedList>
        --%>
        <br />
        <div>
            <table width="100%">
                <tr>
                    <td>
                        <asp:Label ID="NotifyMessage" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%">
                            <tr>
                                <td style="width:30%"></td>
                                <td style="width:30%">
                                    <asp:Button ID="Button1" runat="server" Text="Yes" OnClientClick="CloseWindow('1')" Width="90px" ValidationGroup="BrandDataValidationGroup" TabIndex="3" /></td>
                                <td>
                                    <asp:Button runat="server" Text="No" ID="Button2" Width="90px" OnClientClick="CloseWindow('0')" TabIndex="4" /></td>
                                <td style="width:30%"></td>
                            </tr>
                        </table>
                    </td>

                </tr>
            </table>
        </div>

    </form>

</body>
</html>
