<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="PatientOptOffList.aspx.cs" Inherits="App.UI.Web.Views.Forms.PatientOptOffList" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
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

        function RefreshPage() {
            window.location.replace(window.location);
        }
    </script>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <uc:ContentHeader ID="Header" runat="server" Title="Patient Opt Off List" />
            <asp:ValidationSummary ID="PatintOptOffListValidationSummary" runat="server" ValidationGroup="PatientOptOffListValidationGroup"
                ShowMessageBox="false" CssClass="failureNotification" HeaderText="" DisplayMode="List" />
            <br />

            <div class="form">
                <asp:Panel ID="PatientInformationPanel" runat="server">
                    <div style="float: left; overflow: hidden; width: 100%;">
                        <div style="float: left;">
                            <fieldset class="EmbeddedViewPlaceholder" style="height: 80px; margin-bottom: 10px;">
                                <legend><strong>Opt Off Information</strong></legend>
                                <div class="p1">Full = No data included and No Follow Up Contact</div>
                                <div class="p1">Partial = Data included and No Follow Up Contact</div>
                                <div class="p1">LTFU = Data included and No Follow Up Contact</div>
                            </fieldset>
                        </div>

                        <div style="float: right; padding-right: 25px">
                            <fieldset class="EmbeddedViewPlaceholder" style="width: 350px; height: 80px;">
                                <legend><strong>Patient(s) count summary</strong></legend>
                                <table cellpadding="0px" cellspacing="1px">
                                    <tr>
                                        <td style="width: 150px; padding-top: 5px; padding-bottom: 15px;">Total:
                                            <asp:Label runat="server" ID="PatientsCountDisplay"></asp:Label>
                                        </td>
                                        <td style="padding-top: 5px; padding-bottom: 15px;">Full Opt Off:
                                            <asp:Label runat="server" ID="PatientFullOptOffDisplay"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="width: 150px; padding-top: 5px; padding-bottom: 15px;">LTFU:
                                            <asp:Label runat="server" ID="PatientLTFUDisplay"></asp:Label></td>
                                        <td style="padding-top: 5px; padding-bottom: 15px;">Partial Opt Off:
                                            <asp:Label runat="server" ID="PatientPartialOptOffDisplay"></asp:Label></td>
                                    </tr>
                                </table>
                            </fieldset>
                        </div>
                    </div>
                </asp:Panel>
                <br />

                <div style="width: 100%; overflow: hidden;">
                    <telerik:RadGrid ID="PatientOptOffGrid" runat="server" AllowFilteringByColumn="false" AutoGenerateColumns="False"
                        AllowSorting="True" Width="100%" CellSpacing="0" AllowPaging="True" ShowStatusBar="True"
                        OnNeedDataSource="PatientOptOffGrid_NeedDataSource" OnItemCreated="PatientOptOffGrid_ItemCreated" OnItemCommand="PatientOptOffGrid_ItemCommand"
                        AllowMultiRowSelection="True" GridLines="None"
                        PageSize="10" ExportSettings-ExportOnlyData="true" OnExcelExportCellFormatting="PatientOptOffGrid_ExcelExportCellFormatting">
                        <GroupingSettings CaseSensitive="false" />

                        <ClientSettings AllowColumnsReorder="False" ReorderColumnsOnClient="False" Selecting-AllowRowSelect="false"
                            EnablePostBackOnRowClick="false">
                            <Scrolling AllowScroll="true" ScrollHeight="470px" />
                        </ClientSettings>

                        <MasterTableView DataKeyNames="PatientId,OperationOffStatus,OperationOffDate" CommandItemDisplay="Top" HeaderStyle-HorizontalAlign="Left">
                            <CommandItemSettings ShowExportToPdfButton="true" ShowExportToExcelButton="true" ShowRefreshButton="false" ShowAddNewRecordButton="False"></CommandItemSettings>
                            <RowIndicatorColumn>
                                <HeaderStyle Width="20px"></HeaderStyle>
                            </RowIndicatorColumn>
                            <ExpandCollapseColumn>
                                <HeaderStyle Width="20px"></HeaderStyle>
                            </ExpandCollapseColumn>
                            <PagerStyle AlwaysVisible="true" />
                            <Columns>
                                <telerik:GridTemplateColumn UniqueName="EditPatient" DataField="PatientId" Reorderable="false" Resizable="false" HeaderStyle-Width="80"
                                    AllowFiltering="true" HeaderText="Patient ID" SortExpression="PatId">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="EditPatientLink" Text='<%#Eval("PatientId")%>' runat="server" CommandName="EditPatient" ToolTip="Edit this Patient"></asp:LinkButton>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn DataField="PatientId" HeaderText="Patient ID" UniqueName="PatientId" HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Right" Visible="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="LastName" HeaderText="Family Name" UniqueName="lastName" HeaderStyle-Width="110">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="FirstName" HeaderText="Given Name" UniqueName="FName" HeaderStyle-Width="110">
                                </telerik:GridBoundColumn>
                                <telerik:GridDateTimeColumn DataField="OperationDate" UniqueName="OpDate" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Operation Date" HeaderStyle-Width="110">
                                </telerik:GridDateTimeColumn>
                                <telerik:GridTemplateColumn UniqueName="OptOffStat" DataField="OperationOffStatus" Reorderable="false" Resizable="false" HeaderStyle-Width="80"
                                    AllowFiltering="false" HeaderText="Opt Off Status" SortExpression="OptOffStat">
                                    <ItemTemplate>
                                        <asp:Label ID="PatientOptOffStatusLabel" Text='<%#optOffmessage((int)Eval("OperationOffStatus"))%>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridDateTimeColumn DataField="OperationOffDate" UniqueName="OptOffDate" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Date Opt Off" HeaderStyle-Width="110"></telerik:GridDateTimeColumn>
                            </Columns>
                        </MasterTableView>

                        <ExportSettings IgnorePaging="true" OpenInNewWindow="true" FileName="PatientList" ExportOnlyData="True">
                            <Pdf PageHeight="210mm" PageWidth="297mm" PageTitle="Patient List" DefaultFontFamily="Arial Unicode MS"
                                PageBottomMargin="20mm" PageTopMargin="20mm" PageLeftMargin="10mm" PageRightMargin="10mm"></Pdf>
                            <Excel Format="Html"></Excel>
                        </ExportSettings>
                    </telerik:RadGrid>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
