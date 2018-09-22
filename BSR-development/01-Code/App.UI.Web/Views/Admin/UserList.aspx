<%@ Page Title="Manage User Accounts" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="UserList.aspx.cs" Inherits="App.UI.Web.Views.Admin.ListUsers" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
    </telerik:RadAjaxManager>

    <uc:ContentHeader ID="Header" runat="server" Title="Manage User Accounts" />
    <br />

    <asp:Button ID="CreateAccountButton" runat="server" Text="Add User Account" />
    <div class="clear"></div>
    <br />

    <telerik:RadGrid ID="UsersListGrid" runat="server"
        OnNeedDataSource="UsersListGrid_NeedDataSource" GridLines="None"
        AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True"
        AutoGenerateColumns="False" Width="100%" 
        OnItemCreated="UsersListGrid_ItemCreated" OnInit="UsersListGrid_Init" 
        CellSpacing="0" PageSize="10">
        <GroupingSettings CaseSensitive="false" /> 
                <ClientSettings>
                    <Scrolling AllowScroll="True" ScrollHeight="470" />
                </ClientSettings>
        <MasterTableView DataKeyNames="UserName,UserPrivilegeRole" RowIndicatorColumn-ShowFilterIcon="false"  >
            <RowIndicatorColumn>
                <HeaderStyle Width="30px"></HeaderStyle>
            </RowIndicatorColumn>
            <ExpandCollapseColumn>
                <HeaderStyle Width="30px"></HeaderStyle>
            </ExpandCollapseColumn>
             <PagerStyle AlwaysVisible="true" />
            <Columns>
                <telerik:GridTemplateColumn UniqueName="UserName" HeaderText="User ID" DataField="UserName" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                    <ItemTemplate>
                        <asp:HyperLink ID="ManageUserLink" runat="server" Text='<%# Eval("UserName") %>' ></asp:HyperLink>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn DataField="FullName" HeaderText="User Name" UniqueName="FullName" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                </telerik:GridBoundColumn>               
                <telerik:GridBoundColumn DataField="UserPrivilegeRole" HeaderText="Role" UniqueName="UserPrivilegeRole" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Email" HeaderText="Email" UniqueName="Email" ShowFilterIcon="false" FilterControlWidth="250px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                </telerik:GridBoundColumn>
                <telerik:GridCheckBoxColumn UniqueName="IsActive" HeaderText="Active" DataField="IsActive" DataType="System.Boolean" AllowFiltering="false" />
                <telerik:GridCheckBoxColumn UniqueName="IsLocked" HeaderText="Locked" DataField="IsLocked" DataType="System.Boolean" AllowFiltering="false" />
                <telerik:GridDateTimeColumn DataField="LastLoginDate" EnableTimeIndependentFiltering="true"  AllowFiltering="false"   HeaderText="Last login date" UniqueName="LastLoginDate" HeaderStyle-Width="300px">
                </telerik:GridDateTimeColumn>

            </Columns>
        </MasterTableView>
    </telerik:RadGrid>
    <br />
    <br />
</asp:Content>
