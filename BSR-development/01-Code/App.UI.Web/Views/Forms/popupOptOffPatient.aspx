<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="popupOptOffPatient.aspx.cs" Inherits="App.UI.Web.Views.Forms.popupOptOffPatient" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/ContentHeader.ascx" TagPrefix="uc" TagName="ContentHeader" %>
<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>
    <link href="~/Styles/Site.css" rel="stylesheet" type="text/css" />
</head>
<script type="text/javascript">
    function CloseWindow() {
        var oWindow = GetRadWindow();
        var ReturnVal = "true";
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

    function ShowConfirm(button) {
        var optOffStatusId = $get("<%=PatientOptOffStatusId.ClientID %>").value;
        if (optOffStatusId == "1") {
            radconfirm('You are about to fully opt off this patient. This means all data for this patient would be deleted. Do you wish to proceed?', LaunchWindow, 440, 110, null, "Confirm");
        }
        else
            __doPostBack("<%=PatientOptOffButton.UniqueID %>", "");
    }

    function LaunchWindow(arg) {
        if (arg == true)
        { radconfirm('Are you sure, you want to fully opt off this patient?', LaunchWindow_1, 440, 110, null, "Confirm"); }
        else
        { return false; }
    }

    function LaunchWindow_1(arg) {
        if (arg == true) {
            __doPostBack("<%=PatientOptOffButton.UniqueID %>", "");
            return true;
        }
        else { return false; }
    }

    function PatientOptOffChanged() {
        document.getElementById('<%=PatientOptOffStatusWarning.ClientID%>').innerHTML = '';
        if (document.getElementById('<%=PatientOptOffStatusId.ClientID%>').value == '2') {
            document.getElementById('<%=PatientOptOffStatusWarning.ClientID%>').innerHTML = 'Warning: Do not phone (Partial Opt Off)';
        }
        else if (document.getElementById('<%=PatientOptOffStatusId.ClientID%>').value == '1') {
            document.getElementById('<%=PatientOptOffStatusWarning.ClientID%>').innerHTML = 'Warning: Patient will be deleted';
        }
}
</script>

<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID='scriptManager' runat='server' EnablePageMethods="true" />
        <uc:ContentHeader ID="Header" runat="server" Title="Edit Patient Opt Off Status" style="font-size: small" />
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableShadow="true"></telerik:RadWindowManager>
        <asp:ValidationSummary ID="PatientOptOffValidationSummary" runat="server" ValidationGroup="OptOffPatientValidationGroup" CssClass="failureNotification" DisplayMode="List" ForeColor="Red" />

        <asp:Panel runat="server" ID="CompleteOptOffPanel">
            <table border="0">
                <tr>
                    <td colspan="2">
                        <br />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="NameLabel" AssociatedControlID="NameValue" runat="server" Text="Name" />
                    </td>
                    <td>
                        <asp:Label ID="NameValue" runat="server" />
                    </td>
                </tr>
                <tr style="vertical-align: top">
                    <td style="width: 110px">
                        <asp:Label ID="PatientOptOffStatusLabel" AssociatedControlID="PatientOptOffStatusId" runat="server" Text="Opt off status" />
                    </td>
                    <td>
                        <asp:DropDownList ID="PatientOptOffStatusId" runat="server" />
                        <asp:RequiredFieldValidator ID="RequiredValidatorOptOffStatus" runat="server" CssClass="failureNotification" Enabled="true"
                            ValidationGroup="OptOffPatientValidationGroup" ControlToValidate="PatientOptOffStatusId" ErrorMessage="Please select Opt off Status">*</asp:RequiredFieldValidator>

                    </td>

                </tr>
                <tr>
                    <td></td>
                    <td>
                        <asp:Label ID="PatientOptOffStatusWarning" CssClass="failureNotification" runat="server" /></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <br />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="width: 500px">
                        <div style="text-align: center; padding-right: 80px">
                            <asp:Button runat="server" Text="Cancel" ID="CancelButton" Width="90px" OnClientClick="CloseWindow()" TabIndex="4" />
                            <asp:Button ID="PatientOptOffButton" runat="server" Text="Update" Width="90px" OnClientClick="ShowConfirm(this);return false;" OnClick="PatientOptOffClicked" ValidationGroup="OptOffPatientValidationGroup" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Label ID="Message" runat="server" Text=""></asp:Label>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </form>
</body>
</html>
