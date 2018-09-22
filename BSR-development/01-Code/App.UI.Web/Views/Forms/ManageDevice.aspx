<%@ Page Title="Manage Devices" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    AutoEventWireup="True" CodeBehind="ManageDevice.aspx.cs" Inherits="App.UI.Web.Views.Forms.ManageDevice" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/ContentHeader.ascx" TagPrefix="uc" TagName="ContentHeader" %>
<%--<%@ Register Assembly="ASP.Web.UI.PopupControl"   Namespace="ASP.Web.UI.PopupControl"  TagPrefix="ASPP" %>--%>



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

        function Func_Click() {
            var objClientIDTextBox = document.getElementById(txtClientID.Text);
            var objManufacturer = document.getElementById('txtManufacturer').value;
            objClient.value = objManufacturer;

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
    <uc:ContentHeader ID="chHeader" runat="server" Title="Manage Devices" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:BulletedList ID="DeviceErrorMsg" runat="server" CssClass="failureNotification" Style="list-style-type: none;">
            </asp:BulletedList>

            <asp:ValidationSummary ID="vsDevice" runat="server" ValidationGroup="DeviceValidationGroup" CssClass="failureNotification" DisplayMode="List" />
            <br />
            <table>
                <tr>
                    <td>
                        <asp:Button ID="AddDevice" runat="server" Text="Add Device" Width="150px" />
                    </td>

                    <td>
                        <asp:Button ID="AddBrand" runat="server" Text="Add Brand" Width="150px" />
                    </td>
                    <td>
                        <asp:Button ID="AddManufacturer" runat="server" Text="Add Manufacturer" Width="150px" />
                    </td>
                </tr>
            </table>
            <br />

            <asp:Label ID="NotifyMessage" runat="server" Text="" Class="successNotification" Visible ="false"></asp:Label>
            <div class="clear">
            </div>
            <br />

            <telerik:RadGrid ID="DeviceGrid" runat="server"
                AllowPaging="True"
                AllowSorting="True"
                Width="100%"
                GridLines="None" PageSize="20" CellPadding="0"
                MasterTableView-DataKeyNames="DeviceId"
                OnNeedDataSource="DeviceGrid_DataSource"
                ExportSettings-ExportOnlyData="true"
                OnDeleteCommand="Device_DeleteCommand"
                OnItemCreated="DeviceEdit_ItemCreated"
                OnExcelExportCellFormatting="DeviceGrid_ExcelExportCellFormatting"
                OnItemCommand="DeviceGrid_ItemCommand"
                AllowFilteringByColumn="True">
                <GroupingSettings CaseSensitive="false" />
                <ClientSettings>
                    <Selecting CellSelectionMode="None" AllowRowSelect="false"></Selecting>
                    <Scrolling AllowScroll="true" ScrollHeight="500px" />
                </ClientSettings>
                <MasterTableView CommandItemDisplay="Top" AutoGenerateColumns="false">
                    <CommandItemSettings ShowExportToPdfButton="true"
                        ShowExportToExcelButton="true"
                        ShowRefreshButton="false"
                        ShowAddNewRecordButton="false"></CommandItemSettings>
                    <Columns>

                             


                        <telerik:GridTemplateColumn HeaderText="DeviceID" DataField="DeviceId" Visible="false" UniqueName="DeviceId">
                            <ItemTemplate>
                                <asp:Label ID="lblDeviceId" runat="server" Text='<%# Bind("DeviceId") %>' Visible="false" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridButtonColumn UniqueName="EditLink" HeaderText="Action" Text='Edit' HeaderStyle-Width="80px" HeaderStyle-Font-Names ="verdana"  
                             HeaderStyle-Font-Size ="small"     
                             runat="server" CommandName="EditDevice">
                        </telerik:GridButtonColumn>

                          
                         


                         <telerik:GridTemplateColumn HeaderText="Device Type"    HeaderStyle-Font-Names ="Verdana" 
                             DataField ="DeviceTypeDescription" UniqueName="DeviceTypeDescription"
                            FilterControlWidth="250" ShowFilterIcon="false" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                            <ItemTemplate>
                                <asp:Label ID="lblType" runat="server" Width="200" Text='<%# Bind("DeviceTypeDescription")%>' />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>


                     <%--   <telerik:GridTemplateColumn 
                            HeaderText="Brand Name"    HeaderStyle-Font-Names ="Verdana" 
                            FilterControlAltText="Filter brand Column" DataField="DeviceBrandDescription" SortExpression="DeviceBrandDescription"
                            UniqueName="BrandName" FilterControlWidth="170" 
                            ShowFilterIcon="false" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">

                            <ItemTemplate>
                                <asp:Label ID="lblBrandName" runat="server" Text='<%#Bind("DeviceBrandDescription")%>' />
                            </ItemTemplate>

                        </telerik:GridTemplateColumn>--%>

                          <telerik:GridTemplateColumn HeaderText="Brand Name"    HeaderStyle-Font-Names ="Verdana" 
                             DataField ="DeviceBrandDescription" UniqueName="DeviceBrandDescription"
                            FilterControlWidth="250" ShowFilterIcon="false" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                            <ItemTemplate>
                                <asp:Label ID="lblDeviceBrandDescription" runat="server" Width="200" Text='<%# Bind("DeviceBrandDescription")%>' />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn HeaderText="Description"    HeaderStyle-Font-Names ="Verdana" DataField ="DeviceDescription" UniqueName="DeviceDescription"
                            FilterControlWidth="250" ShowFilterIcon="false" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                            <ItemTemplate>
                                <asp:Label ID="lblDescription" runat="server" Width="200" Text='<%# Bind("DeviceDescription")%>' />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderText="Model"    HeaderStyle-Font-Names ="Verdana" DataField="DeviceModel" UniqueName="DeviceModel"
                            FilterControlWidth="150" ShowFilterIcon="false" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                            <ItemTemplate>
                                <asp:Label ID="lblModel" runat="server" Text='<%# Bind("DeviceModel") %>' />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderText="Manufacturer"    HeaderStyle-Font-Names ="Verdana" DataField="DeviceManufacturerDescription" UniqueName="DeviceManufacturer"
                            FilterControlWidth="160" ShowFilterIcon="false" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                            <ItemTemplate>
                                <asp:Label ID="lblDeviceManufacturerDescription" runat="server" Text='<%# Bind("DeviceManufacturerDescription") %>' />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                      
                     
                              <telerik:GridTemplateColumn HeaderText="Active"    HeaderStyle-Font-Names ="Verdana" DataField="IsDeviceActive" 
                              UniqueName="IsDeviceActive1" ShowFilterIcon ="false"  DataType="System.Boolean" AllowFiltering="false" >
                            <ItemTemplate>
                                <asp:CheckBox ID="IsDeviceActive" runat="server" Checked ='<%# Bind("IsDeviceActive") %>' Enabled ="false"  />
                            </ItemTemplate>
                          </telerik:GridTemplateColumn>
             

                    </Columns>
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column"></EditColumn>
                    </EditFormSettings>
                    <PagerStyle PageSizeControlType="RadComboBox"></PagerStyle>
                </MasterTableView>
                <ExportSettings IgnorePaging="true" OpenInNewWindow="true" ExportOnlyData="True">
                    <Pdf PageHeight="210mm" PageWidth="297mm" PageTitle="Device List" DefaultFontFamily="Arial Unicode MS"
                        PageBottomMargin="20mm" PageTopMargin="20mm" PageLeftMargin="10mm" PageRightMargin="10mm"></Pdf>
                    <Excel Format="Html"></Excel>
                </ExportSettings>
                <ValidationSettings CommandsToValidate="PerformInsert,Update" ValidationGroup="DeviceValidationGroup" />
                <PagerStyle PageSizeControlType="RadComboBox"></PagerStyle>
                <FilterMenu EnableImageSprites="False"></FilterMenu>
            </telerik:RadGrid>
            <br />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>



