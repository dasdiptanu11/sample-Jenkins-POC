<%@ Page Title="Follow up Work List" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="FollowUpWorkList.aspx.cs" Inherits="App.UI.Web.Views.Forms.FollowUpWorkList" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Src="~/Views/Shared/SurgeonAndSite.ascx" TagPrefix="uc" TagName="SurgeonAndSite" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .auto-style6 {
            height: 32px;
        }

        .auto-style7 {
            width: 174px;
        }

        .auto-style8 {
            width: 128px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
        <%--to dynamically adjust the height of radgrid (no vertical scroll will be displayed)--%>
        <style type="text/css">
            .rgDataDiv {
                height: auto !important;
            }
        </style>
    </telerik:RadScriptBlock>
    <script type="text/javascript">
        var column = null;
        var selected = new Array();

        function ShowConfirm() {
            if (selected.length <= 0) {
                radalert("Please select the patients to Mark as Sent");
                return false;
            }
        }

        function RadGrid1_RowSelected(sender, args) {
            var PatientId = args.getDataKeyValue("PatientId");
            var Found = false;
            for (var i = 0; i < selected.length; i++) {
                if (selected[i] == PatientId) {
                    Found = true;
                }
            }

            if (!Found) {
                selected.push(PatientId);
            }
        }

        function RadGrid1_RowDeselected(sender, args) {
            var PatientId = args.getDataKeyValue("PatientId");
            var Found = false;
            var index = -1;
            for (var i = 0; i < selected.length; i++) {
                if (selected[i] == PatientId) {
                    index = i;
                    Found = true;
                }
            }

            if (Found) {
                selected.splice(index, 1);
            }
        }
    </script>

    <uc:ContentHeader ID="Header" runat="server" Title="Follow Up Work List" />
    <br />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <asp:BulletedList ID="FollowUpWorkListErrorMessages" runat="server" CssClass="failureNotification" Style="list-style-type: none;"></asp:BulletedList>

            <uc:SurgeonAndSite ID="SurgeonAndSite" labelSiteWidth="145" IncreaseSpaceForSiteRow="0" labelSurgeonWidth="145" IncreaseCellSpacing="5"
                EnableMandatoryFieldValidatorForSite="false" EnableMandatoryFieldValidatorForSurgeon="false" runat="server" AddAllInSiteList="true" />


            <asp:Table ID="Table1" runat="server" CellPadding="0" CellSpacing="5">
                <asp:TableRow>
                    <asp:TableCell>
                        <asp:Label ID="OperationStatusLabel" runat="server" Text="Operation Status" Width="126"></asp:Label>
                    </asp:TableCell><asp:TableCell>
                        <asp:DropDownList ID="OperationStatus" EnableViewState="true" runat="server" TabIndex="5" Width="200px"></asp:DropDownList>
                    </asp:TableCell><asp:TableCell></asp:TableCell><asp:TableCell></asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>

                    <asp:TableCell Width="150" ColumnSpan="4">
                        <asp:Label ID="Operation" runat="server" Text="Operation Date" Width="200" Font-Bold="false" />
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell Width="150" HorizontalAlign="Right">
                        <asp:Label ID="OperationDateFromLabel" AssociatedControlID="OperationDateFrom" runat="server" Text="From: " Font-Bold="false" />
                    </asp:TableCell><asp:TableCell>
                        <telerik:RadDatePicker ID="OperationDateFrom" runat="server" Calendar-CultureInfo="en-AU" MinDate="1900-01-01" DateInput-DateFormat="dd/MM/yyyy" />
                    </asp:TableCell><asp:TableCell>
                        <asp:Label ID="DateToLabel" AssociatedControlID="OperationDateTo" runat="server" Text="To: " Font-Bold="false" />
                    </asp:TableCell><asp:TableCell>
                        <telerik:RadDatePicker ID="OperationDateTo" runat="server" Calendar-CultureInfo="en-AU" MinDate="1900-01-01" DateInput-DateFormat="dd/MM/yyyy" />
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell ColumnSpan="4">
                        <asp:Label ID="Label1" runat="server" Text=" " Visible="false" />
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell ColumnSpan="2">
                        <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="ApplyFilter" Width="100px" />
                        <asp:Label ID="Label2" runat="server" Text=" " Width="20px" />
                        <asp:Button ID="ClearFilterButton" Width="100px" runat="server" Text="Clear" OnClick="ClearFilter" />
                    </asp:TableCell><asp:TableCell></asp:TableCell><asp:TableCell></asp:TableCell>
                </asp:TableRow>
            </asp:Table>
            <br />
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdatePanel ID="FollowupWorkListPanel" runat="server">
        <ContentTemplate>
            <telerik:RadGrid ID="FollowupWorkListGrid" runat="server" ExportSettings-ExportOnlyData="true" AllowFilteringByColumn="true"
                AllowPaging="True"
                CellSpacing="0"
                GridLines="None"
                AutoGenerateColumns="False"
                AllowSorting="True"
                OnNeedDataSource="FollowupWorkListGrid_NeedDataSource"
                OnItemCreated="FollowupWorkListGrid_ItemCreated"
                OnExcelExportCellFormatting="FollowupWorkListGrid_ExcelExportCellFormatting"
                OnItemCommand="FollowupWorkListGrid_ItemCommand"
                EnableLinqExpressions="False"
                ReadOnly="false"
                OnItemDataBound="FollowupWorkListGrid_ItemDataBound"
                OnPdfExporting="FollowupWorkListGrid_PdfExporting">

                <ClientSettings AllowColumnsReorder="False" ReorderColumnsOnClient="False" Selecting-AllowRowSelect="false"
                    EnablePostBackOnRowClick="false">
                    <Resizing AllowColumnResize="True" ResizeGridOnColumnResize="True" />
                    <Scrolling AllowScroll="true" SaveScrollPosition="true" ScrollHeight="625px" />
                </ClientSettings>
                <GroupingSettings CaseSensitive="false" />


                <MasterTableView DataKeyNames="PatientId, OperationID, FollowUpID" CommandItemDisplay="Top" HeaderStyle-HorizontalAlign="Left">

                    <PagerStyle PageSizeControlType="RadComboBox" />

                    <CommandItemSettings ShowExportToPdfButton="true" ShowExportToExcelButton="true" ShowRefreshButton="false"
                        ShowAddNewRecordButton="False"></CommandItemSettings>
                    <Columns>

                        <telerik:GridBoundColumn DataField="FollowUpID" HeaderText="FollowUp ID" UniqueName="FollowUpID" HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Right" Display="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridButtonColumn ButtonType="LinkButton" DataTextField="PatientId" CommandName="EditFollowUpDetails"
                            HeaderText="Patient ID" SortExpression="PatientId"
                            UniqueName="lnkPatId" HeaderStyle-Width="80">
                            <HeaderStyle Width="100px" />
                        </telerik:GridButtonColumn>

                        <telerik:GridBoundColumn DataField="PatientId" HeaderText="Patient ID" AllowFiltering="true" UniqueName="PatientId" HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Right" Display="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationID" HeaderText="Operation ID" UniqueName="OperationID" HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Right" Display="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="URNo" HeaderText="UR No" UniqueName="URNo" HeaderStyle-Width="100" AutoPostBackOnFilter="true" ShowFilterIcon="false"
                            AllowFiltering="true" CurrentFilterFunction="Contains">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="FamilyName" HeaderText="Family Name" UniqueName="FamilyName" HeaderStyle-Width="150" AutoPostBackOnFilter="true" AllowFiltering="true" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="GivenName" HeaderText="Given Name" UniqueName="GivenName" HeaderStyle-Width="150" AutoPostBackOnFilter="true" AllowFiltering="true" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationType" HeaderText="Operation Status" UniqueName="OperationType" HeaderStyle-Width="150" AutoPostBackOnFilter="true" AllowFiltering="false" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                        </telerik:GridBoundColumn>

                        <telerik:GridDateTimeColumn DataField="OperationDate" UniqueName="OperationDate" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Operation Date" AllowFiltering="false" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="140" HeaderStyle-Width="140">
                        </telerik:GridDateTimeColumn>

                        <telerik:GridBoundColumn DataField="FollowUpPeriod" HeaderText="Follow Up Period" UniqueName="FollowUpPeriod" HeaderStyle-Width="110" ItemStyle-Width="110" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="FollowUpStatus" HeaderText="Follow Up Status" UniqueName="FollowUpStatus" HeaderStyle-Width="110" ItemStyle-Width="110" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="AttemptedCalls" HeaderText="Attempted Calls" UniqueName="AttemptedCalls" HeaderStyle-Width="80" ItemStyle-Width="80" AllowFiltering="false">
                        </telerik:GridBoundColumn>
                    </Columns>
                    <PagerStyle AlwaysVisible="true" />

                </MasterTableView>
                <ExportSettings IgnorePaging="true" OpenInNewWindow="true" ExportOnlyData="True" HideStructureColumns="False">
                    <Pdf PageHeight="210mm" PageWidth="350mm" DefaultFontFamily="Arial Unicode MS"
                        PageBottomMargin="20mm" PageTopMargin="20mm" PageLeftMargin="5mm" PageRightMargin="5mm"></Pdf>
                    <Excel Format="Html"></Excel>
                </ExportSettings>
                <EditItemStyle BackColor="#FF9900" />
                <FilterMenu EnableImageSprites="False">
                </FilterMenu>
            </telerik:RadGrid>
        </ContentTemplate>
    </asp:UpdatePanel>

    <%--to dynamically adjust the height of radgrid (no vertical scroll will be displayed)--%>
</asp:Content>

