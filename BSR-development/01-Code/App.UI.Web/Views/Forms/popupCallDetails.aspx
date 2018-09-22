<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="popupCallDetails.aspx.cs" Inherits="App.UI.Web.Views.Forms.popupCallDetails" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/ContentHeader.ascx" TagPrefix="UserControl" TagName="ContentHeader" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="~/Styles/Site.css" rel="stylesheet" type="text/css" />
</head>

<script type="text/javascript">
    function CloseWindow(status) {
        var oWindow = GetRadWindow();
        var WinContent = oWindow.get_contentFrame().contentWindow.parent;
        var ParentName = oWindow.get_contentFrame().contentWindow.parent.document.nameProp;
        oWindow.Argument = status;
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
        <UserControl:ContentHeader ID="PageHeader" runat="server" Title="Call Details" />

        <asp:ValidationSummary ID="ValidationSummaryAddFollowUpCall" runat="server" ValidationGroup="FollowUpCallDataValidationGroup"
            CssClass="failureNotification" DisplayMode="List" ForeColor="Red" />
        <br />

        <div>
            <table style="margin: 15px -15px 15px 15px; border-spacing: 10px">
                <colgroup>
                    <col width="150" style="height: 33px" />
                </colgroup>

                <asp:HiddenField runat="server" ID="FollowUpId" />
                <asp:HiddenField runat="server" ID="FollowUpCallId" />
                <asp:HiddenField runat="server" ID="FollowUpCallDetails" />

                <tr>
                    <td valign="top">
                        <asp:Label ID="ResultLabel" runat="server" Text="Call Result"></asp:Label>
                        <asp:RequiredFieldValidator ID="rfvType" runat="server" ControlToValidate="CallResultSelection" Display="Dynamic"
                            ValidationGroup="FollowUpCallDataValidationGroup" ErrorMessage="Please select call result."
                            CssClass="failureNotification">*</asp:RequiredFieldValidator>
                    </td>
                    <td>
                        <asp:RadioButtonList AutoPostBack="true" ID="CallResultSelection" runat="server" RepeatDirection="Vertical" RepeatLayout="Flow" />
                    </td>
                </tr>

                <tr>
                    <td valign="top">
                        <asp:Label ID="NoteLabel" runat="server" Text="Note" Width="100"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="FollowUpNote" runat="server" Width="245px" MaxLength="100" TabIndex="2"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td colspan="2" align="right">
                        <table>
                            <tr>
                                <td>
                                    <asp:Button ID="CancelButton" runat="server" Text="Cancel"  Width="90px" OnClientClick="CloseWindow('refresh')" TabIndex="3" />
                                </td>
                                <td>
                                    <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" Width="90px" ValidationGroup="FollowUpCallDataValidationGroup" TabIndex="4" />
                                </td>
                                <td>
                                    <asp:Button ID="ClearButton" runat="server" Text="Clear" OnClick="ClearButton_Click" Visible="false" Width="90px" TabIndex="5" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>