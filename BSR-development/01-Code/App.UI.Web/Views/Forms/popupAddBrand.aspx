<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="popupAddBrand.aspx.cs" Inherits="App.UI.Web.Views.Forms.popupAddBrand" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/ContentHeader.ascx" TagPrefix="uc" TagName="ContentHeader" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="~/Styles/Site.css" rel="stylesheet" type="text/css" />
</head>
<script type="text/javascript">
    function CloseWindow(status) {
        var oWindow = GetRadWindow();
        var ReturnVal = "false";
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
        <uc:ContentHeader ID="chHeader" runat="server" Title="Add Brand" />
        <asp:ValidationSummary ID="vsManufacturer" runat="server" ValidationGroup="BrandDataValidationGroup" CssClass="failureNotification" DisplayMode="List" ForeColor="Red" />
        <%--  <asp:BulletedList ID="BrandErrorMsg" runat="server" ValidationGroup="BrandDataValidationGroup" CssClass="failureNotification" Style="list-style-type: none;"></asp:BulletedList>
        --%>
        <br />

        <div>
            <table>
                <colgroup>
                    <col width="150" style="height: 33px" />
                </colgroup>
                <tr>
                    <td>
                        <asp:Label ID="lblType" runat="server" Text="Device Type *" Width="100"></asp:Label>
                    </td>
                    <td>
                        <asp:DropDownList ID="DeviceType" runat="server" Width="250px" TabIndex="1"></asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvType" runat="server" ControlToValidate="DeviceType" Display="Dynamic"
                            ValidationGroup="BrandDataValidationGroup" ErrorMessage="Device Type is a required field"
                            CssClass="failureNotification">*</asp:RequiredFieldValidator>
                    </td>

                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblBrand" runat="server" Text="Brand Name *" Width="100"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="BrandName" runat="server" Width="245px" MaxLength="100" TabIndex="2"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvBrand" runat="server" ControlToValidate="BrandName" Display="Dynamic"
                            ValidationGroup="BrandDataValidationGroup" ErrorMessage="Brand is a required field"
                            CssClass="failureNotification">*</asp:RequiredFieldValidator>
                    </td>

                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblManfracturer" runat="server" Text="Manufacturer *" Width="100"></asp:Label>
                    </td>
                    <td>
                        <asp:DropDownList ID="Manufacturer" runat="server" Width="250px" TabIndex="3"></asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rvfddlManufacturer" runat="server" ControlToValidate="Manufacturer" Display="Dynamic"
                            ValidationGroup="BrandDataValidationGroup" ErrorMessage="Manufacturer is a required field"
                            CssClass="failureNotification">*</asp:RequiredFieldValidator>
                    </td>

                </tr>
                <tr>
                    <td colspan="2" style="height: 16px">
                        <br />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <table>
                            <tr>
                                <td>
                                    <asp:Button runat="server" Text="Cancel" ID="btnCancel" Width="90px" OnClientClick="CloseWindow('cancel')" TabIndex="4" /></td>
                                <td>
                                    <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="Add_Click" Width="90px" ValidationGroup="BrandDataValidationGroup" TabIndex="3" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <table>
                <tr>
                    <td>
                        <asp:Label ID="NotifyMessage" runat="server" Text=""></asp:Label>
                    </td>
                </tr>

            </table>
        </div>

    </form>

</body>
</html>
