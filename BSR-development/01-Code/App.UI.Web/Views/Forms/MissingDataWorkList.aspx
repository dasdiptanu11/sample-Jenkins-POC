<%@ Page Language="C#" Title="Missing Data Work List" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="MissingDataWorkList.aspx.cs"
    Inherits="App.UI.Web.Views.Forms.MissingDataWorkList" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Src="~/Views/Shared/SurgeonAndSite.ascx" TagPrefix="uc" TagName="SurgeonAndSite" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .auto-style16 {
            height: 30px;
            width: 119px;
        }

        .auto-style17 {
            width: 49px;
        }

        .auto-style18 {
            width: 45px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <uc:ContentHeader ID="Header" runat="server" Title="Missing Data Work List" />
    <br />

    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <table width="100%">
                <tr>
                    <td>
                        <asp:Table ID="Table1" runat="server" CellPadding="0" CellSpacing="5">
                            <asp:TableRow>
                                <asp:TableCell ColumnSpan="2">
                                    <asp:Label ID="ErrorMessage" runat="server" Text="" CssClass="failureNotification"></asp:Label>
                                </asp:TableCell>
                            </asp:TableRow>

                            <asp:TableRow>
                                <asp:TableCell Width="150">
                                    <asp:Label ID="CountryLabel" AssociatedControlID="Country" runat="server" Text="Country" />
                                </asp:TableCell><asp:TableCell>
                                    <asp:DropDownList ID="Country" Width="200" runat="server" />
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                        <uc:SurgeonAndSite ID="SurgeonAndSite" labelSiteWidth="145" IncreaseSpaceForSiteRow="0" labelSurgeonWidth="145" IncreaseCellSpacing="5" EnableMandatoryFieldValidatorForSite="false" EnableMandatoryFieldValidatorForSurgeon="false" AddAllInSiteList="true" runat="server" />

                        <asp:Table ID="Table2" runat="server" CellPadding="0" CellSpacing="5">
                            <asp:TableRow>
                                <asp:TableCell Width="150">
                                    <asp:Label ID="OperationStatusLabel" runat="server" Text="Operation Status" />
                                </asp:TableCell><asp:TableCell>
                                    <asp:DropDownList ID="OperationStatus" Width="200" runat="server" />
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
                                    <asp:Label ID="OperationDateToLabel" AssociatedControlID="OperationDateTo" runat="server" Text="To: " Font-Bold="false" />
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
                                <asp:TableCell ColumnSpan="2" HorizontalAlign="Left">
                                    <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="ApplyFilter" Width="100px" />
                                    <asp:Label ID="Label2" runat="server" Text="" Width="20px" />
                                    <asp:Button ID="ClearFilterButton" Width="100px" runat="server" Text="Clear" OnClick="ClearFilter" />
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                    </td>
                    <td align="justify" valign="top">
                        <asp:Panel ID="Panel1" runat="server">

                            <table>
                                <tr>
                                    <td class="auto-style16">
                                        <asp:Label ID="CompleteLabel" runat="server" Text="Complete" Font-Bold="True"></asp:Label></td>
                                    <td align="center" class="auto-style18">
                                        <asp:Image ID="CompleteImage" runat="server" ImageUrl="~/Images/Complete.png" />
                                    </td>
                                </tr>

                                <tr>
                                    <td class="auto-style16">
                                        <asp:Label ID="NotDueLabel" runat="server" Text="Not Due" Font-Bold="True"></asp:Label></td>
                                    <td align="center" class="auto-style18">
                                        <asp:Image ID="NotDueImage" runat="server" ImageUrl="~/Images/NotDue.png" ImageAlign="Right" /></td>
                                </tr>

                                <tr>
                                    <td class="auto-style16">
                                        <asp:Label ID="InCompleteLabel" runat="server" Text="Incomplete" Font-Bold="True"></asp:Label></td>
                                    <td align="center" class="auto-style18">
                                        <asp:Image ID="InCompleteImage" runat="server" ImageUrl="~/Images/Incomplete.png" />
                                    </td>
                                </tr>

                                <tr>
                                    <td class="auto-style16">
                                        <asp:Label ID="NotApplicableLabel" runat="server" Text="Not Applicable" Font-Bold="True"></asp:Label></td>
                                    <td align="center" class="auto-style18">
                                        <asp:Image ID="NotApplicableImage" runat="server" ImageAlign="Right" ImageUrl="~/Images/NotApplicable.png" Height="19px" Width="34px" /></td>
                                </tr>

                            </table>

                        </asp:Panel>
                    </td>

                </tr>

            </table>
        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:UpdatePanel ID="MissingWorkListPanel" runat="server">
        <ContentTemplate>
           <telerik:RadGrid ID="MissingDataWorkListGrid" runat="server" ExportSettings-ExportOnlyData="true"
                AllowPaging="True"
                CellSpacing="0"
                GridLines="None"
                AutoGenerateColumns="False"
                AllowSorting="True"
                OnNeedDataSource="MissingDataWorkListGrid_NeedDataSource"
                OnExcelExportCellFormatting="MissingDataWorkListGrid_ExcelExportCellFormatting"
                OnItemCommand="MissingDataWorkListGrid_ItemCommand"
                OnItemCreated="MissingDataWorkListGrid_ItemCreated"
                OnItemDataBound="MissingDataWorkListGrid_ItemDataBound"
                OnPageSizeChanged="MissingDataWorkListGrid_PageSizeChanged" 
                EnableLinqExpressions="False"
                ReadOnly="false"
                AllowFilteringByColumn="true"
                OnPdfExporting="MissingDataWorkListGrid_PdfExporting"
                PageSize="10">

                <ClientSettings AllowColumnsReorder="False" ReorderColumnsOnClient="False" Selecting-AllowRowSelect="false"
                    EnablePostBackOnRowClick="false">
                    <Resizing AllowColumnResize="True" ResizeGridOnColumnResize="True" />
                    <Scrolling AllowScroll="true" SaveScrollPosition="true" ScrollHeight="625px" />
                </ClientSettings>

                <GroupingSettings CaseSensitive="false" />

                <MasterTableView DataKeyNames="PatientId, OperationId, SiteId" CommandItemDisplay="Top" HeaderStyle-HorizontalAlign="Left">

                    <PagerStyle PageSizeControlType="RadComboBox" />

                    <CommandItemSettings ShowExportToPdfButton="true" ShowExportToExcelButton="true" ShowRefreshButton="false"
                        ShowAddNewRecordButton="False"></CommandItemSettings>
                    <Columns>

                        <telerik:GridBoundColumn DataField="PatientId" HeaderText="Patient ID" UniqueName="PatientId" HeaderStyle-Width="100px" ItemStyle-Width="100px" AllowFiltering="false" CurrentFilterFunction="EqualTo" ShowFilterIcon="false" AutoPostBackOnFilter="true">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="URNo" HeaderText="UR No" UniqueName="UR_No" HeaderStyle-Width="100px" ItemStyle-Width="100px" AllowFiltering="true" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationId" HeaderText="Operation ID" UniqueName="OperationID" Display="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="FamilyName" HeaderText="Family Name" UniqueName="FamilyName" HeaderStyle-Width="100px" ItemStyle-Width="100px" AllowFiltering="true" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="GivenName" HeaderText="Given Name" UniqueName="GivenName" HeaderStyle-Width="100px" ItemStyle-Width="100px" AllowFiltering="true" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="Gender" HeaderText="Gender" UniqueName="Gender" HeaderStyle-Width="80px" ItemStyle-Width="80px" AllowFiltering="true" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true">
                        </telerik:GridBoundColumn>


                        <telerik:GridDateTimeColumn DataField="OperationDate" UniqueName="OperationDate" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Operation Date" AllowFiltering="false"
                            ItemStyle-HorizontalAlign="Left" ItemStyle-Width="100" HeaderStyle-Width="100">
                        </telerik:GridDateTimeColumn>


                        <telerik:GridBoundColumn DataField="Site" HeaderText="Site" UniqueName="Site" HeaderStyle-Width="100px" ItemStyle-Width="100px" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="SiteId" HeaderText="SiteId" UniqueName="SiteId" HeaderStyle-Width="100px" ItemStyle-Width="100px" AllowFiltering="false" Display="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="Surgeon" HeaderText="Surgeon" UniqueName="Surgeon" HeaderStyle-Width="100px" ItemStyle-Width="100px" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OpFormCompleted" HeaderText="Op Form" UniqueName="OpFormCompleted" HeaderStyle-Width="40px" ItemStyle-Width="40px" AllowFiltering="false" Display="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridTemplateColumn UniqueName="imgOpFormCompleted_" HeaderText="Op Form" HeaderStyle-Width="50px" ItemStyle-Width="50px" AllowFiltering="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgOpFormCompleted" runat="server" CommandName="OpForm"></asp:ImageButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>


                        <telerik:GridBoundColumn DataField="Day30FU" HeaderText="Periop" UniqueName="Day30FU" DataType="System.String" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridTemplateColumn UniqueName="Day30FU_" HeaderText="Periop" HeaderStyle-Width="50px" ItemStyle-Width="50px" AllowFiltering="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgDay30FU" runat="server" CommandName="Day30FU" align="center"></asp:ImageButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>



                        <telerik:GridBoundColumn DataField="Year1FU" HeaderText="1 Yr" UniqueName="Yr1FU" HeaderStyle-Width="50px" ItemStyle-Width="50px" Display="false" AllowFiltering="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn UniqueName="imgYr1FU_" HeaderText="1 Yr" HeaderStyle-Width="50px" ItemStyle-Width="50px" AllowFiltering="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgYr1FU" runat="server" CommandName="Yr1FU" align="center"></asp:ImageButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridBoundColumn DataField="Year2FU" HeaderText="2 Yr" UniqueName="Yr2FU" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn UniqueName="imgYr2FU_" HeaderText="2 Yr" HeaderStyle-Width="50px" ItemStyle-Width="50px" AllowFiltering="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgYr2FU" runat="server" CommandName="Yr2FU" align="center"></asp:ImageButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridBoundColumn DataField="Year3FU" HeaderText="3 Yr" UniqueName="Yr3FU" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridTemplateColumn UniqueName="imgYr3FU_" HeaderText="3 Yr" HeaderStyle-Width="50px" ItemStyle-Width="50px" AllowFiltering="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgYr3FU" runat="server" CommandName="Yr3FU" align="center"></asp:ImageButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>



                        <telerik:GridBoundColumn DataField="Year4FU" HeaderText="4 Yr" UniqueName="Yr4FU" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridTemplateColumn UniqueName="imgYr4FU_" HeaderText="4 Yr" HeaderStyle-Width="50px" ItemStyle-Width="50px" AllowFiltering="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgYr4FU" runat="server" CommandName="Yr4FU" align="center"></asp:ImageButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>


                        <telerik:GridBoundColumn DataField="Year5FU" HeaderText="5 Yr" UniqueName="Yr5FU" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridTemplateColumn UniqueName="imgYr5FU_" HeaderText="5 Yr" HeaderStyle-Width="50px" ItemStyle-Width="50px" AllowFiltering="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgYr5FU" runat="server" CommandName="Yr5FU" align="center"></asp:ImageButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>


                        <telerik:GridBoundColumn DataField="Year6FU" HeaderText="6 Yr" UniqueName="Yr6FU" HeaderStyle-Width="40px" ItemStyle-Width="40px " Display="false" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridTemplateColumn UniqueName="imgYr6FU_" HeaderText="6 Yr" HeaderStyle-Width="50px" ItemStyle-Width="50px" AllowFiltering="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgYr6FU" runat="server" CommandName="Yr6FU" align="center"></asp:ImageButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>


                        <telerik:GridBoundColumn DataField="Year7FU" HeaderText="7 Yr" UniqueName="Yr7FU" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridTemplateColumn UniqueName="imgYr7FU_" HeaderText="7 Yr" HeaderStyle-Width="50px" ItemStyle-Width="50px" AllowFiltering="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgYr7FU" runat="server" CommandName="Yr7FU" align="center"></asp:ImageButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridBoundColumn DataField="Year8FU" HeaderText="8 Yr" UniqueName="Yr8FU" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridTemplateColumn UniqueName="imgYr8FU_" HeaderText="8 Yr" HeaderStyle-Width="50px" ItemStyle-Width="50px" AllowFiltering="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgYr8FU" runat="server" CommandName="Yr8FU" align="center"></asp:ImageButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridBoundColumn DataField="Year9FU" HeaderText="9 Yr" UniqueName="Yr9FU" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridTemplateColumn UniqueName="imgYr9FU_" HeaderText="9 Yr" HeaderStyle-Width="50px" ItemStyle-Width="50px" AllowFiltering="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgYr9FU" runat="server" CommandName="Yr9FU" align="center"></asp:ImageButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>


                        <telerik:GridBoundColumn DataField="Year10FU" HeaderText="10 Yr" UniqueName="Yr10FU" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridTemplateColumn UniqueName="imgYr10FU_" HeaderText="10 Yr" HeaderStyle-Width="50px" ItemStyle-Width="50px" AllowFiltering="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgYr10FU" runat="server" CommandName="Yr10FU" align="center"></asp:ImageButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

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
</asp:Content>
