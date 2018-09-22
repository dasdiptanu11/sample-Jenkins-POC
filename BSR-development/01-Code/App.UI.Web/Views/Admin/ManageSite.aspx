<%@ Page Title="Manage Sites" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    AutoEventWireup="True" CodeBehind="ManageSite.aspx.cs" Inherits="App.UI.Web.Views.Forms.ManageSite" %>

<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <uc:ContentHeader ID="Header" runat="server" Title="Manage Sites" />
    <br />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:ValidationSummary ID="vsManageSite" runat="server" ValidationGroup="ManageSiteValidationGroup"
                ShowMessageBox="false" CssClass="failureNotification" HeaderText="" DisplayMode="List" />
            <div>
                <asp:Button ID="CreateSiteButton" runat="server" Text="Add New Site" OnClick="CreateSiteClicked" />
                <div class="clear"></div>
                <br />

                <telerik:RadGrid ID="ManageSiteGrid" runat="server" AllowFilteringByColumn="True" AutoGenerateColumns="False"
                    AllowSorting="True" Width="99%" CellSpacing="0" AllowPaging="True" ShowStatusBar="True"
                    OnNeedDataSource="ManageSiteGrid_NeedDataSource" OnPreRender="ManageSiteGrid_PreRender"
                    OnItemCommand="ManageSiteGrid_ItemCommand"
                    AllowMultiRowSelection="True" GridLines="None" ExportSettings-ExportOnlyData="true" EnableLinqExpressions="false">

                    <ClientSettings AllowColumnsReorder="False" ReorderColumnsOnClient="False" Selecting-AllowRowSelect="false"
                        EnablePostBackOnRowClick="false">
                        <Resizing AllowColumnResize="True" ResizeGridOnColumnResize="True" />
                    </ClientSettings>

                    <GroupingSettings CaseSensitive="false" />
                    <PagerStyle PageSizeControlType="RadComboBox" AlwaysVisible="True" />
                    <MasterTableView DataKeyNames="SiteId" CommandItemDisplay="Top">
                        <CommandItemSettings ShowExportToPdfButton="false" ShowExportToExcelButton="false" ShowRefreshButton="false" ShowAddNewRecordButton="False"></CommandItemSettings>
                        <RowIndicatorColumn>
                            <HeaderStyle Width="20px"></HeaderStyle>
                        </RowIndicatorColumn>
                        <ExpandCollapseColumn>
                            <HeaderStyle Width="20px"></HeaderStyle>
                        </ExpandCollapseColumn>
                        <Columns>
                            <telerik:GridTemplateColumn UniqueName="SiteID" AllowFiltering="true" HeaderText="Site ID" DataField="SiteId"
                                HeaderStyle-Width="70" ItemStyle-Width="100px" CurrentFilterFunction="NoFilter"
                                FilterControlWidth="50" ShowFilterIcon="false" AutoPostBackOnFilter="true" DataType="System.Int32">
                                <ItemTemplate>
                                    <asp:LinkButton ID="EditLinkButton" Text='<%# Eval("SiteID") %>' runat="server" CommandName="EditSite" />
                                </ItemTemplate>
                                <HeaderStyle Width="70px" />
                                <ItemStyle Width="100px" />
                            </telerik:GridTemplateColumn>

                            <telerik:GridBoundColumn DataField="SiteName" HeaderText="Site Name" UniqueName="Sitename" HeaderStyle-Width="150" ItemStyle-Width="150px"
                                FilterControlWidth="130" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                <ColumnValidationSettings>
                                    <ModelErrorMessage Text="" />
                                </ColumnValidationSettings>
                                <HeaderStyle Width="150px" />
                                <ItemStyle Width="150px" />
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn DataField="SiteAddr" HeaderText="Street Address" UniqueName="SiteStreet" HeaderStyle-Width="200"
                                FilterControlWidth="180" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                <ColumnValidationSettings>
                                    <ModelErrorMessage Text="" />
                                </ColumnValidationSettings>
                                <HeaderStyle Width="200px" />
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn DataField="SiteSuburb" HeaderText="Suburb" UniqueName="SiteSuburb" HeaderStyle-Width="170"
                                FilterControlWidth="150" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                <ColumnValidationSettings>
                                    <ModelErrorMessage Text="" />
                                </ColumnValidationSettings>
                                <HeaderStyle Width="170px" />
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn DataField="tlkp_State.Description" HeaderText="State" UniqueName="SiteState" HeaderStyle-Width="80"
                                FilterControlWidth="60" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                <ColumnValidationSettings>
                                    <ModelErrorMessage Text="" />
                                </ColumnValidationSettings>
                                <HeaderStyle Width="80px" />
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn DataField="SitePCode" HeaderText="Postcode" UniqueName="SitePostCode" HeaderStyle-Width="70"
                                FilterControlWidth="50" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                <ColumnValidationSettings>
                                    <ModelErrorMessage Text="" />
                                </ColumnValidationSettings>
                                <HeaderStyle Width="70px" />
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn DataField="tlkp_SiteType.Description" HeaderText="Site Type" UniqueName="SiteType" HeaderStyle-Width="100"
                                FilterControlWidth="80" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                <ColumnValidationSettings>
                                    <ModelErrorMessage Text="" />
                                </ColumnValidationSettings>
                                <HeaderStyle Width="100px" />
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn DataField="tlkp_SiteStatus.Description" HeaderText="Site Status" UniqueName="SiteStatus" HeaderStyle-Width="90"
                                FilterControlWidth="70" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                <ColumnValidationSettings>
                                    <ModelErrorMessage Text="" />
                                </ColumnValidationSettings>
                                <HeaderStyle Width="90px" />
                            </telerik:GridBoundColumn>
                        </Columns>

                        <EditFormSettings>
                            <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                            </EditColumn>
                        </EditFormSettings>
                        <PagerStyle PageSizeControlType="RadComboBox" AlwaysVisible="True" />
                    </MasterTableView>

                    <ExportSettings IgnorePaging="true" OpenInNewWindow="true" FileName="ManageSite">
                        <Pdf PageHeight="210mm" PageWidth="297mm" PageTitle="Patient List" DefaultFontFamily="Arial Unicode MS"
                            PageBottomMargin="20mm" PageTopMargin="20mm" PageLeftMargin="20mm" PageRightMargin="20mm"></Pdf>
                        <Excel Format="Biff"></Excel>
                    </ExportSettings>

                    <ValidationSettings CommandsToValidate="PerformInsert,Update" ValidationGroup="rgReviewListValidationGroup" />
                    <FilterMenu EnableImageSprites="False">
                    </FilterMenu>
                    <HeaderContextMenu CssClass="GridContextMenu GridContextMenu_Default">
                    </HeaderContextMenu>
                </telerik:RadGrid>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
