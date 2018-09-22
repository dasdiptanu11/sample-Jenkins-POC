<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="ConcurrentLogin.aspx.cs"
    Inherits="App.UI.Web.Views.Home.ConcurrentLogin" Title="ConcurrentLogin" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    You have been logged out from this session as this account has been logged in from another session. Please review the information below.
    <br />
    <br />
    Please do not share your account, if you think that your account has been compromised. Please change your password or contact Administrator.
    <br />
    <br />
    We appologise for any inconvenience caused.
    <br />
    <br />
    <br />
    <asp:GridView ID="VisitorsGrid" runat="server" AutoGenerateColumns="False"
        CellPadding="2" ForeColor="#333333" GridLines="Both">
        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
        <RowStyle BackColor="#EFF3FB" />
        <Columns>
            <asp:TemplateField HeaderText="UserName">
                <ItemTemplate>
                    <%# Eval("UserName") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Session Started">
                <ItemTemplate>
                    <%# ((DateTime)Eval("SessionStarted")).ToString("dd/MM/yyyy HH:mm:ss") %><br />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ip">
                <ItemTemplate>
                    <%# Eval("IpAddress") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Other">
                <ItemTemplate>
                    <span style="font-size: small;">
                        <%# Eval("UserAgent") %><br />
                        <%# Eval("EnterUrl") %><br />
                    </span>

                    <asp:HyperLink ID="refurl" Text='<%# Eval("UrlReferrer") %>' Font-Size="Small"
                        NavigateUrl='<%# Eval("UrlReferrer") %>' runat="server" Target="_blank" />
                </ItemTemplate>
            </asp:TemplateField>

        </Columns>
        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
        <EditRowStyle BackColor="#2461BF" />
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>

</asp:Content>
