<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PasswordConfirmation.aspx.cs" Inherits="App.UI.Web.Views.Forms.PasswordConfirmation" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<telerik:RadCodeBlock ID="rcb" runat="server">
    <script src="../../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../../Scripts/PCRcommon.js" type="text/javascript"></script>
    <script type="text/javascript">

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow;
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow;
            return oWindow;
        }

        function CloseWindow() {
            var oWindow = GetRadWindow();
            oWindow.close();
        }

        function SetFocus() {
            document.getElementById('Password').focus();
        }

    </script>
</telerik:RadCodeBlock>
<body onload="SetFocus">
    <form runat="server" width="100%" id="Form1" defaultbutton="btnOK" defaultfocus="Password" >
        <asp:ScriptManager ID='scriptManager' runat='server' EnablePageMethods="true" />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                    <table width="100%">
            <tr>
                <td>Reenter Password</td>
                <td colspan="2">
                    <asp:TextBox runat="server" ID="Password" TextMode="Password" />
                     <asp:ValidationSummary ID="vsInstituteList" runat="server" ValidationGroup="PasswordValidationGroup"
                CssClass="failureNotification" HeaderText="" />
                </td>
            </tr>
               <tr>
                <td colspan="3" style="height:50px">
                    <asp:label ID="Error" Visible="true" runat="server" ForeColor="Red" ></asp:label>
                </td>
            </tr>

            <tr>
                <td></td>
                <td>
                    <asp:Button runat="server" Text="OK" ID="btnOK" OnClick="OK_Click" />
                </td>
                <td>
                    <asp:Button runat="server" Text="Cancel" ID="btnCancel" OnClientClick="CloseWindow()" />
                </td>
            </tr>
         
        </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    
    </form>
</body>
