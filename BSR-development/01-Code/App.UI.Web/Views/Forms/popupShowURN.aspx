<%@ Page Title="Patient URN(s)" Language="C#" AutoEventWireup="True" CodeBehind="popupShowURN.aspx.cs" Inherits="App.UI.Web.Views.Forms.ShowURN" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="~/Styles/Site.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        html .RadComboBoxDropDown .rcbItem:nth-child(even) {
            background: #CCC;
        }

        html .RadComboBoxDropDown .rcbHovered:nth-child(even) {
            background: #3399FF;
        }

        html .RadComboBoxDropDown .rcbHovered:nth-child(odd) {
            background: #3399FF;
        }

        .RadComboBoxDropDown {
            font-size: 14px !important;
        }
    </style>
</head>

<telerik:RadCodeBlock ID="scriptCodeBlock" runat="server">
    <script type="text/javascript">
    </script>
</telerik:RadCodeBlock>

<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID='scriptManager' runat='server' EnablePageMethods="true" />
        <asp:UpdatePanel ID="PatientOperationUpdatePanel" runat="server">
            <ContentTemplate>
                <%--<uc:ContentHeader ID="Header" runat="server" Title="Patient URN(s)" />--%>
                <div class="contentHeader">
                    <div class="chTitle">Patient URN(s)</div>
                </div>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:Label runat="server" Text="There is no URN" ID="URNNotFound" Style="display: none"></asp:Label>
                        <asp:Label runat="server" ID="WarningMessage" ForeColor="Red"></asp:Label>

                        <telerik:RadGrid ID="PatientURNGrid" runat="server" AllowFilteringByColumn="false" AutoGenerateColumns="False"
                            AllowSorting="True" CellSpacing="0" ShowStatusBar="True" OnItemCommand="PatientURNGrid_ItemCommand"
                            OnNeedDataSource="PatientURNGrid_NeedDataSource" GridLines="None"
                            PageSize="20">

                            <GroupingSettings CaseSensitive="false" />
                            <ClientSettings AllowColumnsReorder="False" ReorderColumnsOnClient="False" Selecting-AllowRowSelect="false"
                                EnablePostBackOnRowClick="false">
                                <Scrolling AllowScroll="true" />
                            </ClientSettings>

                            <MasterTableView CommandItemDisplay="Top" HeaderStyle-HorizontalAlign="Left" DataKeyNames="URN,SiteId,URId">
                                <CommandItemSettings ShowExportToPdfButton="false" ShowExportToExcelButton="false" ShowRefreshButton="false" ShowAddNewRecordButton="False"></CommandItemSettings>
                                <RowIndicatorColumn>
                                    <HeaderStyle Width="20px"></HeaderStyle>
                                </RowIndicatorColumn>
                                <ExpandCollapseColumn>
                                    <HeaderStyle Width="20px"></HeaderStyle>
                                </ExpandCollapseColumn>
                                <PagerStyle AlwaysVisible="true" />
                                <Columns>
                                    <telerik:GridBoundColumn DataField="URN" HeaderText="URN Number" UniqueName="URNNumber" HeaderStyle-Width="80px" ItemStyle-Width="100px">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="SiteName" HeaderText="Site Name" UniqueName="SiteName" HeaderStyle-Width="100px" ItemStyle-Width="200px">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridButtonColumn CommandName="Delete" Text="Delete" HeaderStyle-Width="8%" UniqueName="Delete" HeaderText="">
                                        <HeaderStyle Width="8%"></HeaderStyle>
                                        <ItemStyle Width="8%" HorizontalAlign="Left" />
                                    </telerik:GridButtonColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
