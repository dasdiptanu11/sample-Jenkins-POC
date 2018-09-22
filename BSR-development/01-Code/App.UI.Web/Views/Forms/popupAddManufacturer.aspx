<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="popupAddManufacturer.aspx.cs" Inherits="App.UI.Web.Views.Forms.popupAddManufacturer" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/ContentHeader.ascx" TagPrefix="uc" TagName="ContentHeader" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="~/Styles/Site.css" rel="stylesheet" type="text/css" />
</head>
<script type="text/javascript">


    function CloseWindow() {
        var oWindow = GetRadWindow(status);
        var ReturnVal = "true";
        if (status == 'add')
            ReturnVal = "true";
        else
            ReturnVal = 'false';
        var WinContent = oWindow.get_contentFrame().contentWindow.parent;
        var ParentName = oWindow.get_contentFrame().contentWindow.parent.document.nameProp;
        oWindow.Argument = ReturnVal;
        oWindow.close();
        oWindow.get_contentFrame().contentWindow.parent.RefreshPage();
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


        <uc:ContentHeader ID="chHeader" runat="server" Title="Add Manufacturer" style="font-size: small" />
        <asp:ValidationSummary ID="vsManufacturer" runat="server" ValidationGroup="ManufacturerValidationGroup" CssClass="failureNotification" DisplayMode="List" ForeColor="Red" />
        <table border="0" cellpadding="5">
            <tr>
                <td>
                    <asp:Label ID="lblManfracturer" runat="server" Width="150" Text="Manufacturer *"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="Manufacturer" runat="server" Width="180" MaxLength="100" TabIndex="1"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rvftxtManufacturer" runat="server" ControlToValidate="Manufacturer"
                        ValidationGroup="ManufacturerValidationGroup" ErrorMessage="Manufacturer is a required field"
                        CssClass="failureNotification">*</asp:RequiredFieldValidator>
                </td>

            </tr>
            <tr>
                <br />
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <table>
                        <tr>
                            <td>
                                <asp:Button runat="server" Text="Cancel" ID="btnCancel" Width="90px" OnClientClick="CloseWindow('close')" TabIndex="4" />
                            </td>
                            <td>
                                <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="Add_Click" Width="90px" ValidationGroup="ManufacturerValidationGroup" TabIndex="3" />
                            </td>

                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Label ID="NotifyMessage" runat="server" Text=""></asp:Label>
                </td>
            </tr>


        </table>
    </form>
</body>
</html>

