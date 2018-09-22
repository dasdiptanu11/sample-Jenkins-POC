<%@ Page Title="Search Patient" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    AutoEventWireup="True" CodeBehind="PatientSearch.aspx.cs" Inherits="App.UI.Web.Views.Forms.PatientSearch" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            function ShowHideMedicareAndDVA() {
                var opstat = $get("<%=Country.ClientID %>");
                var NHItxt = $get("<%=NhiNumber.ClientID %>");
                var NHIlbl = $get("<%=PatientNHINumberLabel.ClientID %>");

                if (opstat.value == '2') {
                    $get("<%=MedicarePanel.ClientID %>").style.display = 'none';
                    $get("<%=PatientNHIPanel.ClientID %>").style.display = 'block';
                }
                else {
                    $get("<%=MedicarePanel.ClientID %>").style.display = 'block';
                    $get("<%=PatientNHIPanel.ClientID %>").style.display = 'none';
                }
            }
        </script>
    </telerik:RadCodeBlock>

    <uc:ContentHeader ID="Header" runat="server" Title="Search Patient" />

    <asp:ValidationSummary ID="PatientSearchValidationSummary" runat="server" ValidationGroup="PatientSearchDataValidationGroup"
        CssClass="failureNotification" HeaderText="" DisplayMode="List" />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="form">
                <table cellpadding="0" cellspacing="0" width="80%" border="0">
                    <tr>
                        <td width="50%" valign="top">
                            <asp:Label ID="ExactMatchLabel" runat="server" Text="Exact Match (enter one or more fields)" Font-Bold="True"></asp:Label>
                        </td>

                        <td width="50%">
                            <asp:Label ID="LikeMatchLabel" runat="server" Text="Best 'Like' Match (enter two or more fields)" Font-Bold="True" Font-Italic="False"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" cellpadding="0" cellspacing="0" border="0" style="border-right: solid; border-right-width: 1px">
                                <tr>
                                    <td colspan="2">
                                        <asp:Panel ID="GenericFieldsPanel" runat="server" Width="100%" Style="height: 100%">
                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td width="300px">
                                                        <asp:Label ID="PatientIdLabel" AssociatedControlID="PatientId" runat="server" Text="Patient Id" />
                                                    </td>
                                                    <td abbr="50%">
                                                        <asp:TextBox ID="PatientId" runat="server" Width="250px" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="300px">
                                                        <asp:Label ID="URNNumberLabel" AssociatedControlID="UrnNumber" runat="server" Text=" UR No" />
                                                    </td>
                                                    <td width="50%">
                                                        <asp:TextBox ID="UrnNumber" runat="server" MaxLength="40" Width="250px" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="50%">
                                                        <asp:Label ID="CountryLabel" AssociatedControlID="Country" runat="server" Text=" Country" />
                                                    </td>
                                                    <td width="50%">
                                                        <asp:DropDownList ID="Country" runat="server" Width="70%" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <asp:Panel ID="MedicarePanel" runat="server" Width="100%" Style="height: 100%; margin-top: -6px">
                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td width="292px">
                                                        <asp:Label ID="MedicareNumberLabel" AssociatedControlID="MedicareNumber" runat="server" Text="Medicare No" />
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="MedicareNumber" runat="server" MaxLength="11" Width="250px" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="PatientDVALabel" AssociatedControlID="DvaNumber" runat="server" Text="DVA No" />
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="DvaNumber" runat="server" MaxLength="9" Width="250px" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                        <asp:Panel ID="PatientNHIPanel" runat="server" Width="100%" Style="margin-top: -6px;">
                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td width="50%">
                                                        <asp:Label ID="PatientNHINumberLabel" AssociatedControlID="NhiNumber" runat="server" Text="NHI No" />
                                                    </td>
                                                    <td width="50%">
                                                        <asp:TextBox ID="NhiNumber" runat="server" MaxLength="10" Width="250px" />
                                                    </td>
                                                </tr>
                                                <tr style="height: 29px">
                                                    <td></td>
                                                    <td></td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top">
                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td width="50%">
                                        <asp:Label ID="PatientFamilyNameLabel" AssociatedControlID="FamilyName" runat="server" Text=" Family Name" />
                                    </td>
                                    <td width="50%">
                                        <asp:TextBox ID="FamilyName" runat="server" MaxLength="40" Width="100%" onkeyup="this.value = this.value.toUpperCase();" />
                                    </td>
                                </tr>
                                <tr>
                                    <td width="50%">
                                        <asp:Label ID="PatientGivenNameLabel" AssociatedControlID="GivenName" runat="server" Text=" Given Name" />
                                    </td>
                                    <td width="50%">
                                        <asp:TextBox ID="GivenName" runat="server" MaxLength="40" Width="100%" onkeyup="this.value = this.value.toUpperCase();" />
                                    </td>
                                </tr>
                                <tr>
                                    <td width="50%">
                                        <asp:Label ID="PatientDateofBirthLabel" AssociatedControlID="BirthDate" runat="server" Text="DOB" />
                                    </td>
                                    <td width="50%">
                                        <telerik:RadDatePicker ID="BirthDate" runat="server" Calendar-CultureInfo="en-AU" MinDate="1900-01-01" Calendar-Enabled="true" DateInput-DateFormat="dd/MM/yyyy" />
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>

                <br />
                <table width="20%">
                    <tr>
                        <td width="50%">
                            <asp:Button ID="SearchButton" runat="server" CausesValidation="false" OnClick="SearchClicked" Text="Search" Width="100px" />
                        </td>
                        <td width="50%">
                            <asp:Button ID="ClearButton" runat="server" Text="Clear" CausesValidation="false" OnClick="ClearClicked" Width="100px" />
                        </td>
                    </tr>
                </table>
                <asp:BulletedList ID="PatientSearchErrorMessages" runat="server" CssClass="failureNotification" Style="list-style-type: none;"></asp:BulletedList>
            </div>
            <asp:Panel ID="PatientListPanel" runat="server" Visible="false">
                <div style="height: 50px">
                    <asp:Button ID="AddPatientButton" runat="server" Text="Add New Patient" CausesValidation="false" OnClick="AddPatientClicked" />
                </div>

                <telerik:RadGrid ID="PatientListGrid" runat="server" AllowFilteringByColumn="false" AutoGenerateColumns="False"
                    AllowSorting="True" Width="100%" CellSpacing="0" AllowPaging="True" ShowStatusBar="True"
                    OnNeedDataSource="PatientGrid_NeedDataSource" OnPreRender="PatientGrid_PreRender"
                    OnItemDataBound="PatientGrid_ItemDataBound" OnItemCreated="PatientGrid_ItemCreated"
                    AllowMultiRowSelection="True" OnItemCommand="PatientGrid_ItemCommand" GridLines="None"
                    PageSize="10" ExportSettings-ExportOnlyData="true" OnExcelExportCellFormatting="PatientGrid_ExcelExportCellFormatting">

                    <GroupingSettings CaseSensitive="false" />

                    <ClientSettings AllowColumnsReorder="False" ReorderColumnsOnClient="False" Selecting-AllowRowSelect="false"
                        EnablePostBackOnRowClick="false">
                        <Scrolling AllowScroll="True" ScrollHeight="470px" />
                    </ClientSettings>


                    <MasterTableView DataKeyNames="PatientId,URN,SiteId,StatusId" CommandItemDisplay="Top" HeaderStyle-HorizontalAlign="Left">
                        <CommandItemSettings ShowExportToPdfButton="true" ShowExportToExcelButton="true" ShowRefreshButton="False" ShowAddNewRecordButton="False"></CommandItemSettings>
                        <RowIndicatorColumn>
                            <HeaderStyle Width="20px"></HeaderStyle>
                        </RowIndicatorColumn>
                        <ExpandCollapseColumn>
                            <HeaderStyle Width="20px"></HeaderStyle>
                        </ExpandCollapseColumn>
                        <PagerStyle AlwaysVisible="true" />
                        <Columns>
                            <telerik:GridTemplateColumn UniqueName="EditPatient" DataField="PatientId" Reorderable="false" Resizable="false" HeaderStyle-Width="80"
                                AllowFiltering="true" HeaderText="Patient ID" SortExpression="PatientId" ShowFilterIcon="false">
                                <ItemTemplate>
                                    <asp:LinkButton ID="EditPatientLinkButton" Text='<%#Eval("PatientId")%>' runat="server" CommandName="EditPatient" ToolTip="Edit this Patient"></asp:LinkButton>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="PatientId" HeaderText="Patient ID" UniqueName="PatientId" HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Right"
                                Visible="false">
                            </telerik:GridBoundColumn>

                            <telerik:GridBoundColumn DataField="URN" HeaderText="URN" UniqueName="URN" HeaderStyle-Width="80">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="FamilyName" HeaderText="Family Name" UniqueName="FamilyName" HeaderStyle-Width="130" ItemStyle-Width="130">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="GivenName" HeaderText="Given Name" UniqueName="GivenName" HeaderStyle-Width="125">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Site" HeaderText="Site" UniqueName="Site" HeaderStyle-Width="110">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="SiteId" HeaderText="SiteId" UniqueName="SiteId" HeaderStyle-Width="110" Visible="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Country" HeaderText="Country" UniqueName="Country" HeaderStyle-Width="130">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Medicare" HeaderText="Medicare No" UniqueName="MedicareNo" HeaderStyle-Width="110">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="DVANO" HeaderText="DVA No" UniqueName="DVA" HeaderStyle-Width="100">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="NHI" HeaderText="NHI No" UniqueName="NHINo" HeaderStyle-Width="100">
                            </telerik:GridBoundColumn>
                            <telerik:GridDateTimeColumn DataField="DOB" UniqueName="DOB" DataFormatString="{0:dd/MM/yyyy}" HeaderText="DOB" HeaderStyle-Width="110">
                            </telerik:GridDateTimeColumn>
                            <telerik:GridBoundColumn DataField="URId" HeaderText="URId" UniqueName="URId" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Status" HeaderText="Status" UniqueName="Status" HeaderStyle-Width="100">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="StatusId" HeaderText="StatusId" UniqueName="StatusId" Display="false">
                            </telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>

                    <ExportSettings IgnorePaging="true" OpenInNewWindow="true" FileName="PatientList" ExportOnlyData="True">
                        <Pdf PageHeight="210mm" PageWidth="297mm" PageTitle="Patient List" DefaultFontFamily="Arial Unicode MS"
                            PageBottomMargin="20mm" PageTopMargin="20mm" PageLeftMargin="10mm" PageRightMargin="10mm"></Pdf>
                        <Excel Format="Html"></Excel>
                    </ExportSettings>

                </telerik:RadGrid>

            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
