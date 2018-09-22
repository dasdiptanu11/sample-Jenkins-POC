<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ContentHeader.ascx.cs" Inherits="App.UI.Web.Views.Shared.ContentHeader" %>

<asp:UpdatePanel ID="ContentHeaderUpdatePanel" runat="server" UpdateMode="Always">
    <ContentTemplate>
        <div class="contentHeader">
            <div runat="server" id="PageHeader" class="chTitle">Content Title</div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
