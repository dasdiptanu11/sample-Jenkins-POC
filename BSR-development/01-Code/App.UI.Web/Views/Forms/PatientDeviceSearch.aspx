<%@ Page Title="Search Device" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    AutoEventWireup="True" CodeBehind="PatientDeviceSearch.aspx.cs" Inherits="App.UI.Web.Views.Forms.PatientDeviceSearch" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="upDeviceSearch" runat="server">
        <ContentTemplate>
            <asp:ValidationSummary ID="vsDeviceSearch" runat="server" ValidationGroup="PatientDeviceSearchDataValidationGroup"
                CssClass="failureNotification" HeaderText="" DisplayMode="List" />
            <uc:ContentHeader ID="chHeader" runat="server" Title="Search Device" />
            <div class="form">
                <div class="sectionPanel1">
                    <div class="sectionContent2">

                        <table border="0" cellpadding="3px" width="100%">
                            <colgroup>
                                <col width="250px" />
                            </colgroup>
                            <tr>
                                <td>
                                    <asp:Label ID="lblCountry" runat="server" AssociatedControlID="CountryList" Text="Country" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="CountryList" runat="server" Width="250" TabIndex="0" />
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="lblDeviceType" runat="server" AssociatedControlID="DeviceTypeList" Text="Device Type *" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="DeviceTypeList" runat="server" Width="250" OnSelectedIndexChanged="DeviceTypeList_SelectedIndexChanged" TabIndex="1" AutoPostBack="True" />
                                    <asp:RequiredFieldValidator ID="rfvDeviceType" runat="server" ControlToValidate="DeviceTypeList" Display="Dynamic"
                                        ValidationGroup="PatientDeviceSearchDataValidationGroup" ErrorMessage="Device Type is a required field"
                                        CssClass="failureNotification">*</asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblBrand" AssociatedControlID="DeviceBrand" runat="server" Text="Brand Name *" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="DeviceBrand" runat="server" Width="250" TabIndex="2" OnSelectedIndexChanged="DeviceBrand_SelectedIndexChanged" Enabled="False" AutoPostBack="True" />
                                    <asp:RequiredFieldValidator ID="rfvBrand" runat="server" ControlToValidate="DeviceBrand" Display="Dynamic"
                                        ValidationGroup="PatientDeviceSearchDataValidationGroup" ErrorMessage="Device Brand is a required field"
                                        CssClass="failureNotification">*</asp:RequiredFieldValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="lblDeviceDescription" AssociatedControlID="DeviceDescription" runat="server" Text="Description *" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="DeviceDescription" runat="server" Width="250" TabIndex="3" OnSelectedIndexChanged="DeviceDescription_SelectedIndexChanged" Enabled="False" AutoPostBack="True" />
                                    <asp:RequiredFieldValidator ID="rfvDescrition" runat="server" ControlToValidate="DeviceDescription" Display="Dynamic"
                                        ValidationGroup="PatientDeviceSearchDataValidationGroup" ErrorMessage="Device Description is a required field"
                                        CssClass="failureNotification">*</asp:RequiredFieldValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="lblModel" runat="server" AssociatedControlID="DeviceModel" Text="Model *" Width="200px" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="DeviceModel" runat="server" Width="250" TabIndex="4" OnSelectedIndexChanged="DeviceModel_SelectedIndexChanged" Enabled="False" AutoPostBack="True" />
                                    <asp:RequiredFieldValidator ID="rfvModel" runat="server" ControlToValidate="DeviceModel" Display="Dynamic"
                                        ValidationGroup="PatientDeviceSearchDataValidationGroup" ErrorMessage="Device Model is a required field"
                                        CssClass="failureNotification">*</asp:RequiredFieldValidator>
                                </td>

                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblDeviceManufacturer" runat="server" AssociatedControlID="Manufacturer" Text="Manufacturer" />
                                </td>
                                <td>
                                    <%--      <asp:DropDownList ID="ddlManufacturer" runat="server" Width="200px" TabIndex="3" OnSelectedIndexChanged="ddlManufacturer_SelectedIndexChanged" />
                                    <asp:RequiredFieldValidator ID="rfvManufacturer" runat="server" ControlToValidate="ddlManufacturer" Display="Dynamic"
                                        ValidationGroup="PatientDeviceSearchDataValidationGroup" ErrorMessage="Device Type is required"
                                        CssClass="failureNotification">*</asp:RequiredFieldValidator>--%>

                                    <asp:TextBox ID="Manufacturer" MaxLength="100" Width="245px" ReadOnly="true" runat="server" TabIndex="400" CssClass="disabledDropDownList"></asp:TextBox>

                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblLotNo" AssociatedControlID="LotNo" runat="server" Text="Serial No / Lot No" />
                                </td>
                                <td>
                                    <asp:TextBox ID="LotNo" runat="server" Width="195px" TabIndex="5"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                        <table>
                            <tr>
                                <td>
                                    <asp:Button ID="btnSearch" runat="server" Text="Search" CausesValidation="true" OnClick="Search_Click"
                                        ValidationGroup="PatientDeviceSearchDataValidationGroup" TabIndex="7" Width="100px" />
                                </td>
                                <td>
                                    <asp:Button ID="btnClear" runat="server" Text="Clear" CausesValidation="false" OnClick="Clear_Click" TabIndex="8" Width="100px" />
                                </td>
                            </tr>
                        </table>
                        <asp:BulletedList ID="ErrorMessagesList" runat="server" CssClass="failureNotification" Style="list-style-type: none;"></asp:BulletedList>
                    </div>
                </div>
            </div>


            <asp:Panel ID="PatientDeviceListPanel" runat="server" Visible="false">

                <div class="sectionPanel1">
                    <div class="sectionHeader">
                        <b>Patient List</b>
                    </div>
                </div>
                <br />

                <telerik:RadGrid ID="PatientDeviceGrid" runat="server" Width="100%"
                    AutoGenerateColumns="False"
                    AllowSorting="True"
                    PageSize="10"
                    AllowPaging="True"
                    GridLines="None"
                    CellPadding="0" CellSpacing="0"
                    OnNeedDataSource="PatientDeviceGrid_NeedDataSource"
                    OnItemCommand="PatientDeviceGrid_ItemCommand"
                    OnItemDataBound="PatientDeviceGrid_ItemDataBound"
                    OnItemCreated="PatientDeviceGrid_ItemCreated"
                    OnPdfExporting="PatientDeviceGrid_PdfExporting">
                    <GroupingSettings CaseSensitive="false" />

                    <ClientSettings AllowColumnsReorder="False" ReorderColumnsOnClient="False" Selecting-AllowRowSelect="false"
                        EnablePostBackOnRowClick="false">
                        <Resizing AllowColumnResize="True" ResizeGridOnColumnResize="True" />
                        <Scrolling AllowScroll="True" ScrollHeight="470" />
                    </ClientSettings>

                    <MasterTableView DataKeyNames="PatientOperationId,PatientId, URNo" CommandItemDisplay="Top">

                        <PagerStyle PageSizeControlType="RadComboBox" />
                        <CommandItemSettings ShowExportToPdfButton="true" ShowExportToExcelButton="false" ShowRefreshButton="false" ShowAddNewRecordButton="false"></CommandItemSettings>

                        <Columns>
                            <telerik:GridBoundColumn UniqueName="PatientId" HeaderStyle-Width="50px" ItemStyle-Width="30px" DataField="PatientId" Reorderable="false"
                                Resizable="false" HeaderText="Patient ID" Visible="true">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn UniqueName="UR_No" HeaderStyle-Width="50px" ItemStyle-Width="50px" DataField="URNo" Reorderable="false"
                                Resizable="false" HeaderText="UR No">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn UniqueName="PatientPrimarySite" HeaderStyle-Width="80px" ItemStyle-Width="80px" DataField="PatientPrimarySite" Reorderable="false"
                                Resizable="false" HeaderText="Primary Site">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn UniqueName="PatientOperationId" ItemStyle-Width="50px" HeaderStyle-Width="50px" DataField="PatientOperationId" Reorderable="false"
                                Resizable="false" HeaderText="OperationId" Visible="false">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn UniqueName="PatientName" ItemStyle-Width="120px" HeaderStyle-Width="120px" DataField="PatientName" Reorderable="false"
                                Resizable="false" HeaderText="Patient Name" Visible="true">
                            </telerik:GridBoundColumn>


                             <telerik:GridBoundColumn DataField="PatientDOB" ItemStyle-Width="80px" HeaderStyle-Width="80px" HeaderText="DOB"
                                UniqueName="DOB" DataFormatString="{0:dd/MM/yyyy}">
                            </telerik:GridBoundColumn>

                              <telerik:GridBoundColumn UniqueName="PatientIHI" ItemStyle-Width="80px" HeaderStyle-Width="80px" DataField="PatientIHI" Reorderable="false"
                                Resizable="false" HeaderText="IHI No" >
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn UniqueName="PatientMedicareNo" ItemStyle-Width="80px" HeaderStyle-Width="80px" DataField="PatientMedicareNo" Reorderable="false"
                                Resizable="false" HeaderText="Medicare No" Visible="true">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn UniqueName="PatientNHINo" ItemStyle-Width="80px" HeaderStyle-Width="80px" DataField="PatientNHINo" Reorderable="false"
                                Resizable="false" HeaderText="NHI No" Visible="false">
                            </telerik:GridBoundColumn>

                                


                            <telerik:GridBoundColumn UniqueName="PatientAddress" HeaderStyle-Width="170px" ItemStyle-Width="170px" DataField="PatientAddress" Reorderable="false"
                                HeaderText="Patient Address" Visible="false">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn UniqueName="PatientTelephone" HeaderStyle-Width="100px" ItemStyle-Width="100px" DataField="PatientTelephone" Reorderable="false"
                                HeaderText="PatientTelephone" Visible="false">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn DataField="OperationDate" ItemStyle-Width="80px" HeaderStyle-Width="80px" HeaderText="Operation Date"
                                UniqueName="OperationDate" DataFormatString="{0:dd/MM/yyyy}">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn DataField="SurgeonName" ItemStyle-Width="100px" HeaderStyle-Width="100px" HeaderText="Surgeon Name" UniqueName="SurgeonName">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn DataField="SurgeonEmail" ItemStyle-Width="90px"  HeaderStyle-Width ="90px" HeaderText="Surgeon Email"  ItemStyle-Wrap ="true"  UniqueName ="SurgeonEmail" Visible="false">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn DataField="LotNo" HeaderText="Serial No / Lot No" HeaderStyle-Width="100px" ItemStyle-Width="100px" UniqueName="LotNo" Visible="false">
                            </telerik:GridBoundColumn>
                        </Columns>
                        <PagerStyle AlwaysVisible="true" />
                    </MasterTableView>
                    <ExportSettings IgnorePaging="true" OpenInNewWindow="true" ExportOnlyData="True">
                        <Pdf PageHeight="210mm" PageWidth="297mm" PageTitle="" DefaultFontFamily="Arial Unicode MS"
                            PageBottomMargin="20mm" PageTopMargin="20mm" PageLeftMargin="5mm" PageRightMargin="5mm"></Pdf>
                        <Excel Format="Html"></Excel>
                    </ExportSettings>
                    <PagerStyle PageSizeControlType="RadComboBox" />
                    <FilterMenu EnableImageSprites="False">
                    </FilterMenu>
                </telerik:RadGrid>

            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
