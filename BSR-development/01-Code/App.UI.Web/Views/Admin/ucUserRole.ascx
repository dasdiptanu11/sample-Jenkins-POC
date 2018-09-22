<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucUserRole.ascx.cs" Inherits="App.UI.Web.Views.Admin.ucUserRole" %>


<asp:CheckBox ID="Admin" runat="server" Text="Administrator" TextAlign="Left"/>

<div style="margin-bottom:5px;margin-top:15px;">
    <b>Site Access</b>
</div>

<asp:CheckBoxList ID="SitesList" runat="server">
</asp:CheckBoxList>
