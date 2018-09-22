<%@ Control Language="C#" AutoEventWireup="True" CodeBehind="AuditForm.ascx.cs" Inherits="App.UI.Web.Views.Forms.AuditForm" %>
<br />
<asp:UpdatePanel ID="AuditUpdatePanel" runat="server" UpdateMode="Always">
    <ContentTemplate>
        <div class="form" runat="server" id="FormContainer">
            <asp:Label ID="SubmittedByLabel" runat="server" Text="Data checked & saved by" />&nbsp;
        <asp:TextBox ID="SubmittedBy" runat="server" Enabled="false"></asp:TextBox>&nbsp;

        <asp:Label ID="SavedDateLabel" runat="server" Text="Date & time saved"></asp:Label>&nbsp;
        <asp:TextBox ID="SubmittedDate" runat="server" Enabled="false"></asp:TextBox>&nbsp;
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
