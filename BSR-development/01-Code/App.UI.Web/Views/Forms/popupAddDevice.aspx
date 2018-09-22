<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="popupAddDevice.aspx.cs" Inherits="App.UI.Web.Views.Forms.popupAddDevice" %>

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
        var ReturnVal = "true";
        if (status == 'add')
            ReturnVal = "true";
        else
            ReturnVal = 'false';
        oWindow.Argument = ReturnVal;
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
        <uc:ContentHeader ID="contentHeader" runat="server" Title="Add Device" />
        <asp:ValidationSummary ID="vsDevice" runat="server" ValidationGroup="DeviceDataValidationGroup" CssClass="failureNotification" DisplayMode="List" ForeColor="Red" />
        <asp:BulletedList ID="ErrorNotification" runat="server" CssClass="failureNotification" Style="list-style-type: none;"></asp:BulletedList>
        <br />
        <table border="0" cellpadding="5">
            <colgroup>
                <col width="150" style="height: 33px" />
            </colgroup>
            <tr>
                <td>
                    <asp:Label ID="lblDeviceTyper" AssociatedControlID="DeviceType" runat="server" Text="Device Type *"></asp:Label>
                </td>
                <td>
                    <asp:DropDownList ID="DeviceType" Width="250px" runat="server" TabIndex="1" OnSelectedIndexChanged="DeviceType_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvDeviceType" runat="server" ControlToValidate="DeviceType" Display="Dynamic"
                        ValidationGroup="DeviceDataValidationGroup" ErrorMessage="Device Type is a required field"
                        CssClass="failureNotification">*</asp:RequiredFieldValidator>
                </td>
            </tr>

            <tr>
                <td>
                    <asp:Label ID="lblBrand" AssociatedControlID="BrandName" runat="server" Text="Brand Name *"></asp:Label>
                </td>
                <td>
                    <asp:DropDownList ID="BrandName" Width="250px" runat="server" TabIndex="2" OnSelectedIndexChanged="BrandName_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rvfddlBrand" runat="server" ControlToValidate="BrandName" Display="Dynamic"
                        ValidationGroup="DeviceDataValidationGroup" ErrorMessage="Brand is a required field"
                        CssClass="failureNotification">*</asp:RequiredFieldValidator>
                </td>
            </tr>

            <tr>
                <td>
                    <asp:Label ID="lblDescription" AssociatedControlID="Description" runat="server" Text="Description *"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="Description" MaxLength="100" Width="245px" runat="server" TabIndex="3"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rvfDescription" runat="server" ControlToValidate="Description" Display="Dynamic"
                        ValidationGroup="DeviceDataValidationGroup" ErrorMessage="Description is a required field"
                        CssClass="failureNotification">*</asp:RequiredFieldValidator>
                </td>
            </tr>


            <tr>
                <td>
                    <asp:Label ID="lblModel" runat="server" AssociatedControlID="Model" Text="Model *"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="Model" MaxLength="100" Width="245px" runat="server" TabIndex="4"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rvfModel" runat="server" ControlToValidate="Model" Display="Dynamic"
                        ValidationGroup="DeviceDataValidationGroup" ErrorMessage="Model is a required field"
                        CssClass="failureNotification">*</asp:RequiredFieldValidator>
                </td>
            </tr>

            <tr>
                <td>
                    <asp:Label ID="lblManufacturer" runat="server" Text="Manufacturer"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="Manufacturer" MaxLength="100" Width="245px" ReadOnly="true" runat="server" TabIndex="400" CssClass="disabledDropDownList"></asp:TextBox>

                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblDeviceStatusId" AssociatedControlID="DeviceStatus" runat="server" Text="Device Status" />
                </td>
                <td valign="middle">
                    <asp:CheckBox ID="DeviceStatus" runat="server" Text="Active" Checked="True" />
                </td>
            </tr>

            <tr>
                <td colspan="2" style="height: 15px"></td>
            </tr>


            <tr>
                <td colspan="2" align="center">
                    <table>
                        <tr>
                            <td>
                                <asp:Button runat="server" Text="Cancel" ID="btnCancel" Width="90px" OnClientClick="CloseWindow('cancel')" TabIndex="6" />
                            </td>
                            <td>
                                <asp:Button ID="Update" runat="server" Text="Update" OnClick="Update_Click" Width="90px" ValidationGroup="DeviceDataValidationGroup" TabIndex="5" />
                                <asp:Button ID="Add" runat="server" Text="Add" OnClick="Add_Click" Width="90px" ValidationGroup="DeviceDataValidationGroup" TabIndex="5" />
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
    </form>
</body>
</html>
