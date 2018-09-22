<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="ExplanatoryStatementWorkList.aspx.cs" Inherits="App.UI.Web.Views.Forms.ExplanatoryStatementWorkList" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/ContentHeader.ascx" TagPrefix="uc" TagName="ContentHeader" %>
<%@ Register Src="~/Views/Shared/SurgeonAndSite.ascx" TagPrefix="uc" TagName="SurgeonAndSite" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .auto-style1 {
            width: 36%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

    <telerik:RadCodeBlock ID="rcb" runat="server">
        <script type="text/javascript" src="../../Scripts/jquery-1.8.2.min.js"></script>
        <script type="text/javascript">
        </script>
    </telerik:RadCodeBlock>

    <uc:ContentHeader ID="Header" runat="server" Title="Explanatory Statement Pending Work List" />
    <asp:ValidationSummary ID="PatientSearchValidationSummary" runat="server" ValidationGroup="PatientESSWLValidationGroup"
        CssClass="failureNotification" HeaderText="" DisplayMode="List" />
    <asp:Label ID="MessageLabel" runat="server" Text="" Class="successNotification" Visible="false"></asp:Label>
    <br />

    <table width="100%">
        <tr>
            <td>
                <asp:Table ID="Table1" runat="server" CellPadding="0" CellSpacing="5">
                    <asp:TableRow>
                        <asp:TableCell Width="150">
                            <asp:Label ID="CountryLabel" AssociatedControlID="County" runat="server" Text="Country" />
                        </asp:TableCell><asp:TableCell>
                            <asp:DropDownList ID="County" Width="200" runat="server" />
                        </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
                <uc:SurgeonAndSite ID="SurgeonAndSite" labelSiteWidth="145" IncreaseSpaceForSiteRow="0" labelSurgeonWidth="145" IncreaseCellSpacing="5" EnableMandatoryFieldValidatorForSite="false" EnableMandatoryFieldValidatorForSurgeon="false" AddAllInSiteList="true" runat="server" />
            </td>
        </tr>
    </table>

    <div>
        <br />
        <table>
            <tr>
                <td>
                    <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="ApplyFilter" />
                </td>
                <td>
                    <asp:Button ID="ClearFilterButton" Width="100px" runat="server" Text="Clear" OnClick="ClearFilter" />
                </td>
                <td>
                    <asp:Button runat="server" ID="MarkAsSentButton" Text="Mark As Sent" OnClick="MarkAsSentClicked" />
                </td>
            </tr>
        </table>
    </div>

    <asp:UpdatePanel ID="PatientListESSWLUpdatePanel" runat="server">
        <ContentTemplate>
            <telerik:RadGrid ID="PatientESSWLListGrid" runat="server"
                AllowFilteringByColumn="false"
                AutoGenerateColumns="False"
                AllowSorting="True"
                Width="100%"
                CellSpacing="0"
                AllowPaging="True"
                ShowStatusBar="True"
                OnPageIndexChanged="PatientESSWLListGrid_PageIndexChanged"
                OnPreRender="PatientESSWLListGrid_PreRender"
                OnPdfExporting="PatientESSWLListGrid_PdfExporting"
                OnNeedDataSource="PatientESSWLListGrid_NeedDataSource"
                OnItemCreated="PatientESSWLListGrid_ItemCreated"
                AllowMultiRowSelection="True"
                OnItemCommand="PatientESSWLListGrid_ItemCommand"
                OnExcelExportCellFormatting="PatientESSWLListGrid_ExcelExportCellFormatting"
                GridLines="None"
                PageSize="10" ExportSettings-ExportOnlyData="true">
                <GroupingSettings CaseSensitive="false" />
                <ClientSettings AllowColumnsReorder="False"
                    ReorderColumnsOnClient="False"
                    Selecting-AllowRowSelect="true"
                    EnablePostBackOnRowClick="false">
                    <Scrolling AllowScroll="True" ScrollHeight="470px" />
                </ClientSettings>

                <MasterTableView DataKeyNames="PatientId" CommandItemDisplay="Top" HeaderStyle-HorizontalAlign="Left">
                    <CommandItemSettings ShowExportToPdfButton="true" ShowExportToExcelButton="true" ShowRefreshButton="False" ShowAddNewRecordButton="False"></CommandItemSettings>
                    <RowIndicatorColumn>
                        <HeaderStyle Width="20px"></HeaderStyle>
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn>
                        <HeaderStyle Width="20px"></HeaderStyle>
                    </ExpandCollapseColumn>
                    <PagerStyle AlwaysVisible="true" />
                    <Columns>

                        <telerik:GridTemplateColumn UniqueName="Select" ReadOnly="false">
                            <HeaderTemplate>
                                <asp:Label ID="SelectLabel" runat="server"></asp:Label><asp:CheckBox ID="SelectAll" UniqueName="SelectAll" ViewStateMode="Enabled" Enabled="true" runat="server" OnCheckedChanged="SelectAll_CheckedChanged" AutoPostBack="true" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="SelectColumn" Enabled="true" runat="server" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridBoundColumn DataField="PrimarySurgeon" HeaderText="Surgeon" UniqueName="PrimarySurgeon">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="PrimaryHospital" HeaderText="Consent Site" UniqueName="PrimaryHospital">
                        </telerik:GridBoundColumn>
                        <telerik:GridDateTimeColumn DataField="OperationDate" HeaderText="Operation Date" UniqueName="OpDate" DataFormatString="{0:dd/MM/yyyy}"></telerik:GridDateTimeColumn>
                        <telerik:GridBoundColumn DataField="OperationAge" HeaderText="Operation Age" UniqueName="OpAge" ItemStyle-HorizontalAlign="Left">
                            <HeaderStyle Wrap="true" />
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Title" HeaderText="Title" UniqueName="Title" ItemStyle-HorizontalAlign="Left">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="FamilyName" HeaderText="Family Name" UniqueName="FamilyName">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="GivenName" HeaderText="Given Name" UniqueName="GivenName">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Gender" HeaderText="Gender" UniqueName="Gender">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Street" HeaderText="Street Number and Name" UniqueName="Street">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Suburb" HeaderText="Suburb" UniqueName="Suburb">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="State" HeaderText="State" UniqueName="State">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Postcode" HeaderText="Postcode" UniqueName="Postcode">
                        </telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>

                <ExportSettings IgnorePaging="true" OpenInNewWindow="true" FileName="ExplanatoryStatementWorkList" ExportOnlyData="True" HideStructureColumns="true">
                    <Pdf PageHeight="210mm" PageWidth="297mm" DefaultFontFamily="Arial Unicode MS"
                        PageBottomMargin="20mm" PageTopMargin="20mm" PageLeftMargin="10mm" PageRightMargin="10mm"></Pdf>
                    <Excel Format="Html" AutoFitImages="true"></Excel>
                </ExportSettings>
            </telerik:RadGrid>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
