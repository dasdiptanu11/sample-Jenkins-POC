<%@ Page Title="Patient Unknown Device List" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    AutoEventWireup="True" CodeBehind="PatientUnknownDeviceList.aspx.cs" Inherits="App.UI.Web.Views.Forms.PatientUnknownDeviceList" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/ContentHeader.ascx" TagPrefix="uc" TagName="ContentHeader" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            function genericPopup(href, width, height, title) {
                //   DeselectAll();
                var oWindow = window.radopen(href, null, width, height, null, null);
                oWindow.SetModal(true);
                oWindow.set_visibleStatusbar(false);
                oWindow.heigh
                oWindow.set_behaviors(Telerik.Web.UI.WindowBehaviors.Move + Telerik.Web.UI.WindowBehaviors.Close);
                oWindow.set_autoSize(false);
                oWindow.set_title(title);
                oWindow.set_showContentDuringLoad(false);
                oWindow.add_close(RefreshPage);
                oWindow.show();
            }

            function RefreshPage(obj) {
                window.location.replace(window.location);
            }

            function RowDeselected() {
                $get('<%= ErrorMessage.ClientID %>').innerText = '';
            }

        </script>

    </telerik:RadCodeBlock>

    <telerik:RadWindowManager ID="Dialog" runat="server"
        AutoSize="true" KeepInScreenBounds="true"
        Modal="true">
    </telerik:RadWindowManager>

    <uc:ContentHeader ID="Header" runat="server" Title="Patient Unknown Device List" />
    <br />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td colspan="4">
                        <asp:Label ID="ErrorMessage" runat="server" Text="" CssClass="failureNotification"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="AddBrandButton" runat="server" Text="Add Brand" Width="150px" />
                        <asp:Button ID="AddManufacturerButton" runat="server" Text="Add Manufacturer" Width="150px" />
                    </td>
                    <td colspan="3">
                </tr>
                <tr>
                    <td colspan="4">
                        <asp:Label ID="Label1" runat="server" Visible="False"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <asp:Label ID="SuccessMessage" runat="server" Class="successNotification" Visible="False"></asp:Label>
                    </td>
                </tr>
            </table>


            <asp:Panel ID="PatientUnknownDevicePanel" runat="server">
                <br />
                <telerik:RadGrid ID="PatientUnknownDeviceGrid"
                    runat="server"
                    AllowFilteringByColumn="false"
                    AutoGenerateColumns="False"
                    AllowSorting="True"
                    AllowMultiRowSelection="False"
                    Width="100%" CellSpacing="0" AllowPaging="True" ShowStatusBar="True"
                    OnNeedDataSource="PatientUnknownDeviceGrid_NeedDataSource"
                    OnItemCreated="PatientUnknownDeviceGrid_ItemCreated"
                    OnItemCommand="PatientUnknownDeviceGrid_ItemCommand"
                    OnExcelExportCellFormatting="PatientUnknownDeviceGrid_ExcelExportCellFormatting"
                    GridLines="None" PageSize="10"
                    ExportSettings-ExportOnlyData="true">
                    <GroupingSettings CaseSensitive="false" />

                    <ClientSettings>
                        <Selecting AllowRowSelect="true" CellSelectionMode="SingleCell" UseClientSelectColumnOnly="true"></Selecting>
                        <Scrolling AllowScroll="true" ScrollHeight="500px" />
                        <ClientEvents OnRowDeselected="RowDeselected" />
                    </ClientSettings>

                    <MasterTableView DataKeyNames="PatientOperationDeviceID, PatientOperationId, PatientSiteId, PatientId, DeviceBrandId, ManufacturerId, ManufacturerDescrition, DeviceBrandDescrition" CommandItemDisplay="Top">
                        <CommandItemSettings
                            ShowExportToPdfButton="true"
                            ShowExportToExcelButton="true"
                            ShowRefreshButton="false"
                            ShowAddNewRecordButton="False"></CommandItemSettings>
                        <PagerStyle AlwaysVisible="true" />
                        <Columns>

                            <telerik:GridBoundColumn HeaderText="PatientOperationDeviceID" DataField="PatientOperationDeviceID" UniqueName="PatientOperationDeviceID" Visible="false">
                            </telerik:GridBoundColumn>

                            <telerik:GridButtonColumn UniqueName="Select" HeaderText="Action" Text='Edit' HeaderStyle-Width="50px" ItemStyle-Width="50px" HeaderStyle-Font-Names="verdana"
                                HeaderStyle-Font-Size="small" runat="server" CommandName="EditDevice">
                            </telerik:GridButtonColumn>

                            <telerik:GridTemplateColumn UniqueName="PatientId" HeaderText="Patient ID" HeaderStyle-Font-Names="Verdana"
                                ItemStyle-Font-Names="Verdana"
                                HeaderStyle-Width="100">
                                <ItemTemplate>
                                    <asp:LinkButton ID="EditOperationLink" Text='<%# Eval("PatientId") %>' runat="server" CommandName="EditOperation"> </asp:LinkButton>
                                </ItemTemplate>
                                <HeaderStyle Width="100px"></HeaderStyle>
                            </telerik:GridTemplateColumn>


                            <telerik:GridBoundColumn HeaderText="Patient ID" DataField="PatientId" UniqueName="PatientId1" Visible="false">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn HeaderText="Device Type" DataField="DeviceTypeDescrition" UniqueName="DeviceTypeDescrition">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn HeaderText="DeviceTypeId" DataField="DeviceTypeId" UniqueName="DeviceTypeId" Visible="false">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn HeaderText="Brand Name" DataField="DeviceBrandDescrition" UniqueName="DeviceBrandDescrition">
                            </telerik:GridBoundColumn>


                            <telerik:GridBoundColumn HeaderText="DeviceBrandId" HeaderStyle-Font-Names="Verdana" DataField="DeviceBrandId" UniqueName="DeviceBrandId" Visible="false">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn HeaderText="Description" DataField="DeviceDescrition" UniqueName="DeviceDescrition">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn HeaderText="Model" DataField="DeviceModel" UniqueName="DeviceModel">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn HeaderText="Manufacturer" DataField="ManufacturerDescrition" UniqueName="ManufacturerDescrition">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn HeaderText="ManufacturerId" DataField="ManufacturerId" UniqueName="ManufacturerId" Visible="false">
                            </telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>

                    <ExportSettings IgnorePaging="true" OpenInNewWindow="true" FileName="PatientUnknownDeviceList">
                        <Pdf PageHeight="210mm" PageWidth="297mm" PageTitle="Patient Unknown Device List" DefaultFontFamily="Arial Unicode MS"
                            PageBottomMargin="20mm" PageTopMargin="20mm" PageLeftMargin="20mm" PageRightMargin="20mm"></Pdf>
                        <Excel Format="Html"></Excel>
                    </ExportSettings>

                    <HeaderContextMenu CssClass="GridContextMenu GridContextMenu_Default">
                    </HeaderContextMenu>
                </telerik:RadGrid>
                <%-- </ContentTemplate>
    </asp:UpdatePanel>--%>
            </asp:Panel>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
