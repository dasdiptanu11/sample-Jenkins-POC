<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PatientLTFUList.aspx.cs" Inherits="App.UI.Web.Views.Forms.PatientLTFUList" Title="Patient LTFU List" MasterPageFile="~/Views/Shared/Site.Master" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Src="~/Views/Shared/SurgeonAndSite.ascx" TagPrefix="uc" TagName="SurgeonAndSite" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            function checkedColumn(index) {
                $get('<%= ErrorMessage.ClientID %>').innerText = '';
            }
        </script>
    </telerik:RadCodeBlock>

    <uc:ContentHeader ID="Header" runat="server" Title="LTFU Work List" />
    <br />

    <table cellspacing="5">
        <colgroup>
            <col width="50%" />
        </colgroup>
        <tr>
            <td>
                <asp:Label ID="ErrorMessage" runat="server" Text="" Class="failureNotification" Visible="true"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Button ID="UncheckLTFUStatusButton" runat="server" Text="Uncheck the LTFU Status" OnClick="UncheckLTFUStatusButtonClicked" />
            </td>
        </tr>
    </table>
    <br />


    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <telerik:RadGrid ID="PatientLTFUGrid"
                runat="server"
                AllowFilteringByColumn="true"
                AutoGenerateColumns="False"
                AllowSorting="True"
                AllowMultiRowSelection="False"
                Width="100%" CellSpacing="0" AllowPaging="True" ShowStatusBar="True"
                OnNeedDataSource="PatientLTFUGrid_NeedDataSource"
                OnItemCreated="PatientLTFUGrid_ItemCreated"
                OnItemCommand="PatientLTFUGrid_ItemCommand"
                OnExcelExportCellFormatting="PatientLTFUGrid_ExcelExportCellFormatting"
                GridLines="None" PageSize="10"
                ExportSettings-ExportOnlyData="true"
                OnPageIndexChanged="PatientLTFUGrid_PageIndexChanged"
                OnPreRender="PatientLTFUGrid_PreRender">
                <GroupingSettings CaseSensitive="false" />

                <ClientSettings>
                    <Selecting AllowRowSelect="true"></Selecting>
                    <Scrolling AllowScroll="true" ScrollHeight="500px" />
                </ClientSettings>

                <MasterTableView DataKeyNames="PatientId" CommandItemDisplay="Top">
                    <CommandItemSettings
                        ShowExportToPdfButton="true"
                        ShowExportToExcelButton="true"
                        ShowRefreshButton="false"
                        ShowAddNewRecordButton="False"></CommandItemSettings>
                    <PagerStyle AlwaysVisible="true" />

                    <Columns>
                        <telerik:GridTemplateColumn UniqueName="SelectColumn" HeaderText="Select" HeaderStyle-Font-Names="Verdana" AllowFiltering="false"
                            HeaderStyle-Width="50px" ReadOnly="false">
                            <ItemTemplate>
                                <asp:CheckBox ID="SelectColumn" Enabled="true" runat="server" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn UniqueName="PatientId" HeaderText="Patient ID" HeaderStyle-Font-Names="Verdana" AllowFiltering="false"
                            ItemStyle-Font-Names="Verdana"
                            HeaderStyle-Width="100">
                            <ItemTemplate>
                                <asp:LinkButton ID="EditPatientLink"
                                    Text='<%# Eval("PatientId") %>' runat="server" CommandName="EditPatient"> </asp:LinkButton>
                            </ItemTemplate>
                            <HeaderStyle Width="100px"></HeaderStyle>
                        </telerik:GridTemplateColumn>

                        <telerik:GridBoundColumn HeaderText="Patient ID" DataField="PatientId" UniqueName="PatientId1" Visible="false" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="FamilyName" HeaderText="Family Name" UniqueName="FamilyName" HeaderStyle-Width="150px" ItemStyle-Width="150px" AllowFiltering="true" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="GivenName" HeaderText="Given Name" UniqueName="GivenName" HeaderStyle-Width="200px" ItemStyle-Width="200px" AllowFiltering="true" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true">
                        </telerik:GridBoundColumn>

                        <telerik:GridDateTimeColumn DataField="FirstOperationDate" UniqueName="FirstOperationDate" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Operation Date (First)"
                            HeaderStyle-Width="110" ItemStyle-Width="110px" AllowFiltering="false">
                        </telerik:GridDateTimeColumn>

                        <telerik:GridDateTimeColumn DataField="LastOperationDate" UniqueName="LastOperationDate" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Operation Date (Last)"
                            HeaderStyle-Width="110" ItemStyle-Width="110px" AllowFiltering="false">
                        </telerik:GridDateTimeColumn>

                        <telerik:GridDateTimeColumn DataField="LastFollowUpDate" UniqueName="LastFollowUpDate" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Follow Up Date(Last)"
                            HeaderStyle-Width="110" ItemStyle-Width="110px" AllowFiltering="false">
                        </telerik:GridDateTimeColumn>
                    </Columns>
                </MasterTableView>

                <ExportSettings IgnorePaging="true" OpenInNewWindow="true" FileName="PatientUnknownDeviceList">
                    <Pdf PageHeight="210mm" PageWidth="297mm" PageTitle="LTFU Patient List" DefaultFontFamily="Arial Unicode MS"
                        PageBottomMargin="20mm" PageTopMargin="20mm" PageLeftMargin="20mm" PageRightMargin="20mm"></Pdf>
                    <Excel Format="Html"></Excel>
                </ExportSettings>

                <HeaderContextMenu CssClass="GridContextMenu GridContextMenu_Default">
                </HeaderContextMenu>
            </telerik:RadGrid>
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>