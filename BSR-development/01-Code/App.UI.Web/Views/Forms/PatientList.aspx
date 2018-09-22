<%@ Page Title="Patient List" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    AutoEventWireup="True" CodeBehind="PatientList.aspx.cs" Inherits="App.UI.Web.Views.Forms.PatientList" %>

<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%--<%@ Register Src="PatientInfo.ascx" TagName="PatientInfo" TagPrefix="uc1" %>--%>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            var column = null;
            function MenuShowing(sender, args) {
                if (column == null) return;
                var menu = sender; var items = menu.get_items();
                if (column.get_dataType() == "System.DateTime") {
                    var i = 0;
                    while (i < items.get_count()) {
                        if (!(items.getItem(i).get_value() in { 'NoFilter': '', 'GreaterThan': '', 'LessThan': '', 'EqualTo': '' })) {
                            var item = items.getItem(i);
                            if (item != null) {
                                item.set_visible(false);
                            }
                        }
                        else {
                            var item = items.getItem(i);
                            if (item != null)
                                item.set_visible(true);
                        } i++;
                    }
                }

                if (column.get_dataType() == "System.String") {
                    var i = 0;
                    while (i < items.get_count()) {
                        if (!(items.getItem(i).get_value() in { 'NoFilter': '', 'Contains': '', 'NotIsEmpty': '', 'IsEmpty': '', 'NotEqualTo': '', 'EqualTo': '' })) {
                            var item = items.getItem(i);
                            if (item != null)
                                item.set_visible(false);
                        }
                        else {
                            var item = items.getItem(i);
                            if (item != null)
                                item.set_visible(true);
                        } i++;
                    }
                }

                if (column.get_dataType() == "System.Int32") {
                    var j = 0; while (j < items.get_count()) {
                        if (!(items.getItem(j).get_value() in { 'NoFilter': '', 'GreaterThan': '', 'LessThan': '', 'NotEqualTo': '', 'EqualTo': '' })) {
                            var item = items.getItem(j); if (item != null)
                                item.set_visible(false);
                        }
                        else { var item = items.getItem(j); if (item != null) item.set_visible(true); } j++;
                    }
                }

                column = null;
                menu.repaint();
            }

            function filterMenuShowing(sender, eventArgs) {
                column = eventArgs.get_column();
            }
        </script>
    </telerik:RadCodeBlock>

    <uc:ContentHeader ID="Header" runat="server" Title="Patient List" />

    <br />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <asp:ValidationSummary ID="PatientListValidationSummary" runat="server" ValidationGroup="PatientListValidationGroup"
                ShowMessageBox="false" CssClass="failureNotification" HeaderText="" DisplayMode="List" />
            <div>

                <asp:Button ID="CreatePatientButton" runat="server" Text="Register New Patient" OnClick="CreatePatientClicked" />
                <div class="clear">
                </div>
                <br />
                <telerik:RadGrid ID="PatientListGrid" runat="server" AllowFilteringByColumn="True" AutoGenerateColumns="False"
                    AllowSorting="True" Width="100%" CellSpacing="0" AllowPaging="True" ShowStatusBar="True"
                    OnNeedDataSource="PatientListGrid_NeedDataSource"
                    OnItemDataBound="PatientListGrid_ItemDataBound" OnItemCreated="PatientListGrid_ItemCreated"
                    AllowMultiRowSelection="True" OnItemCommand="PatientListGrid_ItemCommand" GridLines="None"
                    PageSize="20" ExportSettings-ExportOnlyData="true" OnExcelExportCellFormatting="PatientListGrid_ExcelExportCellFormatting" OnInit="rgPatientList_Init">
                    <GroupingSettings CaseSensitive="false" />
                    <ClientSettings AllowColumnsReorder="False" ReorderColumnsOnClient="False" Selecting-AllowRowSelect="false"
                        EnablePostBackOnRowClick="false">
                        <Scrolling AllowScroll="true" ScrollHeight="470px" />
                        <ClientEvents OnFilterMenuShowing="filterMenuShowing" />
                    </ClientSettings>
                    <FilterMenu OnClientShown="MenuShowing">
                    </FilterMenu>
                    <MasterTableView DataKeyNames="PatientId" CommandItemDisplay="Top" HeaderStyle-HorizontalAlign="Left">
                        <CommandItemSettings ShowExportToPdfButton="true" ShowExportToExcelButton="true" ShowRefreshButton="true" ShowAddNewRecordButton="False"></CommandItemSettings>
                        <RowIndicatorColumn>
                            <HeaderStyle Width="20px"></HeaderStyle>
                        </RowIndicatorColumn>
                        <ExpandCollapseColumn>
                            <HeaderStyle Width="20px"></HeaderStyle>
                        </ExpandCollapseColumn>
                        <PagerStyle AlwaysVisible="true" />
                        <Columns>
                            <telerik:GridTemplateColumn UniqueName="EditPatient" DataField="PatientId" Reorderable="false" Resizable="false" HeaderStyle-Width="80"
                                AllowFiltering="true" HeaderText="Patient ID" SortExpression="PatientId">
                                <ItemTemplate>
                                    <asp:LinkButton ID="EditPatientLinkButton" Text='<%#Eval("PatientId")%>' runat="server" CommandName="EditPatient" ToolTip="Edit this Patient"></asp:LinkButton>
                                </ItemTemplate>

                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="PatientId" HeaderText="Patient ID" UniqueName="PatientId" HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Right" Visible="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="FamilyName" HeaderText="Family Name" UniqueName="FamilyName" HeaderStyle-Width="110">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="RecentFormerName" HeaderText="Recent Former Name" UniqueName="RecentFormerName" HeaderStyle-Width="110">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="FormerName" HeaderText="Former Name" UniqueName="FormerName" HeaderStyle-Width="110">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="GivenName" HeaderText="Given Name" UniqueName="GivenName" HeaderStyle-Width="110">
                            </telerik:GridBoundColumn>
                            <telerik:GridDateTimeColumn DataField="DOB" UniqueName="DOB" DataFormatString="{0:dd/MM/yyyy}" HeaderText="DOB" HeaderStyle-Width="110">
                            </telerik:GridDateTimeColumn>
                            <telerik:GridBoundColumn DataField="MedicareNo" HeaderText="Medicare Number" UniqueName="MedicareNo" HeaderStyle-Width="100">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Consent" HeaderText="Consent" UniqueName="Consent" HeaderStyle-Width="60">
                            </telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>

                    <ExportSettings IgnorePaging="true" OpenInNewWindow="true" FileName="PatientList" ExportOnlyData="True">
                        <Pdf PageHeight="210mm" PageWidth="297mm" PageTitle="Patient List" DefaultFontFamily="Arial Unicode MS"
                            PageBottomMargin="20mm" PageTopMargin="20mm" PageLeftMargin="10mm" PageRightMargin="10mm"></Pdf>
                        <Excel Format="Html"></Excel>
                    </ExportSettings>

                </telerik:RadGrid>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
    <br />
    <asp:Button ID="BackButton" runat="server" Text="Back" CausesValidation="false" OnClick="BackButtonClicked" />
</asp:Content>
