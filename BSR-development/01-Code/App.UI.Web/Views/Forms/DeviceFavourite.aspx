<%@ Page Title="Device Favourite" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    AutoEventWireup="True" CodeBehind="DeviceFavourite.aspx.cs" Inherits="App.UI.Web.Views.Forms.DeviceFavourite" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/ContentHeader.ascx" TagPrefix="uc" TagName="ContentHeader" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">

        function genericPopup(href, width, height, Title) {
            var oWindow = window.radopen(href, null, width, height, null, null);
            oWindow.SetModal(true);
            oWindow.set_visibleStatusbar(false);
            oWindow.heigh
            oWindow.set_behaviors(Telerik.Web.UI.WindowBehaviors.Move + Telerik.Web.UI.WindowBehaviors.Close);
            oWindow.set_autoSize(false);
            oWindow.set_title(Title);
            oWindow.set_showContentDuringLoad(false);
            oWindow.add_close(RefreshPage);
            oWindow.show();
        }
        function RefreshPage(obj) {
            if (obj != null) {
                m_RetVal = obj.Argument;
                if (m_RetVal != null && m_RetVal == 'true') {
                    window.location.replace(window.location);
                }
            }
        }




    </script>

    <telerik:RadWindowManager ID="Dialog" runat="server"
        AutoSize="true" KeepInScreenBounds="true"
        Modal="true">
    </telerik:RadWindowManager>

    <uc:ContentHeader ID="chHeader" runat="server" Title="Favourite Devices" />

    <asp:UpdatePanel ID="DevFavPanel" runat="server">
        <ContentTemplate>
            <asp:BulletedList ID="DeviceErrorMsg" runat="server" CssClass="failureNotification" Style="list-style-type: none;">
            </asp:BulletedList>

            <asp:ValidationSummary ID="vsFavouriteDeviceList" runat="server" ValidationGroup="DeviceValidationGroup" CssClass="failureNotification" DisplayMode="List" />
            <br />
            <table>
                <tr>
                    <td style="width: 900px">
                        <asp:Panel ID="ShowFavPanel" runat="server" Visible="false">
                            <asp:Table ID="FilterTable" runat="server">
                                <asp:TableRow>
                                    <asp:TableCell>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Country" runat="server" Text="Country "></asp:Label>
                                                </td>
                                                <td>
                                                    <div style="float: left">
                                                        <asp:DropDownList ID="Country_DropDown" Font-Size="14px" runat="server" Width="200px" AutoPostBack="true" OnSelectedIndexChanged="Country_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="clear"></div>
                                                </td>
                                                <td>
                                                    <asp:Label ID="Surgeon" runat="server" Text="Surgeon "></asp:Label>
                                                </td>
                                                <td>
                                                    <div style="float: left">
                                                        <asp:DropDownList Font-Size="14px" ID="Surgeon_DropDown" runat="server" Width="200px"></asp:DropDownList>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:TableCell>
                                    <asp:TableCell>
                                        <asp:Button ID="ShowFavourite" runat="server" Text="Show Favourite" OnClick="showFavouriteClick" />
                                    </asp:TableCell>
                                </asp:TableRow>
                            </asp:Table>
                        </asp:Panel>
                    </td>
                    <td style="width: 1100px"></td>
                    <td align="right">
                        <asp:Panel ID="AddFavPanel" runat="server">
                            <asp:Button ID="AddFavourite" runat="server" Text="Add Favourite" />
                        </asp:Panel>
                    </td>
                </tr>
            </table>
            <br />
            <asp:Label ID="NotifyMessage" runat="server" Text="" CssClass="successNotification" Visible="false"></asp:Label>

            <asp:Panel runat="server" ID="adminNotification" Style="display: none">
                <font color="#5c86ea" style="font-size: 13px"><strong>Only Surgeons that already have a Favourite Device(s) recorded will be listed here. If the Surgeon is not listed here, Please click "Add Favourite" and Surgeon can be selected and their Favourite Device recorded.</strong></font>
                <br />
                <br />
            </asp:Panel>
            <asp:Panel ID="FavouriteDevicePanel" runat="server">
                <telerik:RadGrid runat="server" ID="FavouriteDeviceListGrid"
                    AllowPaging="true"
                    AllowSorting="true"
                    Width="100%"
                    GridLines="None" PageSize="20" CellPadding="0"
                    MasterTableView-DataKeyNames="FavDevId,ParentFavDevId"
                    OnNeedDataSource="FavouriteDeviceListGrid_NeedDataSource"
                    ExportSettings-ExportOnlyData="true"
                    OnItemCreated="FavouriteDeviceListEdit_ItemCreated"
                    OnExcelExportCellFormatting="FavouriteDeviceListGrid_ExcelExportCellFormatting"
                    OnItemCommand="FavouriteDeviceListGrid_ItemCommand"
                    AllowFilteringByColumn="true">
                    <ClientSettings>
                        <Selecting CellSelectionMode="None" AllowRowSelect="false" />
                        <Scrolling AllowScroll="true" ScrollHeight="500px" />
                    </ClientSettings>
                    <GroupingSettings CaseSensitive="false" />
                    <MasterTableView CommandItemDisplay="Top" AutoGenerateColumns="false">
                        <CommandItemSettings ShowExportToExcelButton="true" ShowExportToPdfButton="true" ShowRefreshButton="false" ShowAddNewRecordButton="false" />
                        <Columns>
                            <telerik:GridTemplateColumn HeaderText="FavDevId" DataField="FavDevId" Visible="false" UniqueName="FavDevId">
                                <ItemTemplate>
                                    <asp:Label ID="FavDeviceId" runat="server" Text='<%# Bind("FavDevId") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridTemplateColumn HeaderText="ParentFavDevId" DataField="ParentFavDevId" Visible="false" UniqueName="ParentFavDevId">
                                <ItemTemplate>
                                    <asp:Label ID="ParentFavDeviceId" runat="server" Text='<%# Bind("ParentFavDevId") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridButtonColumn UniqueName="EditLink" HeaderText="Action" Text='Edit' HeaderStyle-Width="80px" HeaderStyle-Font-Names="Verdana"
                                HeaderStyle-Font-Size="small"
                                runat="server" CommandName="EditDevice">
                            </telerik:GridButtonColumn>
                            <telerik:GridTemplateColumn HeaderText="Procedure" HeaderStyle-Font-Names="Verdana"
                                DataField="Procedure" UniqueName="Procedure" FilterControlWidth="250" ShowFilterIcon="false"
                                CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                                <ItemTemplate>
                                    <asp:Label ID="ProcedureHeader" runat="server" Width="200" Text='<%# Bind("Procedure") %>'></asp:Label>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridTemplateColumn HeaderText="Type" HeaderStyle-Font-Names="Verdana"
                                DataField="Type" UniqueName="Type" FilterControlWidth="250" ShowFilterIcon="false"
                                CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                                <ItemTemplate>
                                    <asp:Label ID="TypeHeader" runat="server" Width="200" Text='<%# Bind("Type") %>'></asp:Label>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridTemplateColumn HeaderText="Hospital" HeaderStyle-Font-Names="Verdana"
                                DataField="Hospital" UniqueName="Hospital" FilterControlWidth="250" ShowFilterIcon="false"
                                CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                                <ItemTemplate>
                                    <asp:Label ID="HospitalHeader" runat="server" Width="200" Text='<%# Bind("Hospital") %>'></asp:Label>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridTemplateColumn HeaderText="Device" HeaderStyle-Font-Names="Verdana"
                                DataField="DeviceDetail" UniqueName="DeviceDetail" FilterControlWidth="250" ShowFilterIcon="false"
                                CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                                <ItemTemplate>
                                    <asp:Label ID="DeviceDetailsHeader" runat="server" Width="400" Text='<%# Bind("DeviceDetail") %>'></asp:Label>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>

                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </asp:Panel>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
