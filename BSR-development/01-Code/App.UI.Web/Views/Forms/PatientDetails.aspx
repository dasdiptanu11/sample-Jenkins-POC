<%@ Page Title="Patient Details" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    AutoEventWireup="True" CodeBehind="PatientDetails.aspx.cs" Inherits="App.UI.Web.Views.Forms.PatientDetails" %>

<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/PatientRibbon.ascx" TagPrefix="uc" TagName="PatientRibbon" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .auto-style2 {
            width: 89px;
        }

        .auto-style3 {
            width: 103px;
        }

        .auto-style4 {
            width: 253px;
        }

        .auto-style5 {
            width: 96px;
        }

        .auto-style6 {
            width: 250px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <uc:PatientRibbon runat="server" ID="PatientRibbon" />
    <div class="form">
        <div class="sectionPanel1">
            <div class="sectionHeader">
                Contact Details
            </div>
            <br />

            <div>
                <table border="0">
                    <colgroup>
                        <col width="250px" />
                    </colgroup>
                    <tr>
                        <td>
                            <asp:Label ID="PatientAddressLabel" AssociatedControlID="PatientAddress" runat="server" Text="Address" />
                        </td>
                        <td width="225px">
                            <asp:TextBox ID="PatientAddress" runat="server" Width="200" Enabled="False"></asp:TextBox>
                        </td>
                        <td width="50px"></td>
                        <td>
                            <asp:Label ID="PatientHomePhoneLabel" AssociatedControlID="PatientHomePhone" runat="server" Text="Home Phone No" />
                        </td>
                        <td width="225px">
                            <asp:TextBox ID="PatientHomePhone" Enabled="False" runat="server"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <asp:Label ID="PatientSuburbAddressLabel" AssociatedControlID="PatientAddressSuburb" runat="server" Text="Suburb" />
                        </td>
                        <td width="225px">
                            <asp:TextBox ID="PatientAddressSuburb" runat="server" Enabled="False"></asp:TextBox>
                        </td>
                        <td width="50px"></td>
                        <td>
                            <asp:Label ID="PatientMobileLabel" AssociatedControlID="PatientMobile" runat="server" Text="Mobile No" />
                        </td>
                        <td>
                            <asp:TextBox ID="PatientMobile" runat="server" Enabled="False"></asp:TextBox>
                        </td>
                    </tr>
                </table>

                <asp:Panel ID="PatientPostcodeAndStatePanel" runat="server">
                    <table>
                        <colgroup>
                            <col width="250px" />
                        </colgroup>
                        <tr>
                            <td>
                                <asp:Label ID="PatientStateLabel" AssociatedControlID="PatientState" runat="server" Text="State" />
                            </td>
                            <td width="225px">
                                <asp:TextBox ID="PatientState" runat="server" Enabled="False"></asp:TextBox>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <asp:Label ID="PatientPostcodeLabel" AssociatedControlID="PatientPostCode" runat="server" Text="Post Code" /></td>
                            <td width="225px">
                                <asp:TextBox ID="PatientPostCode" runat="server" Enabled="False" Width="80"></asp:TextBox>
                            </td>
                        </tr>
                    </table>

                </asp:Panel>
                <table>
                    <colgroup>
                        <col width="250px" />
                    </colgroup>
                    <tr>
                        <td>
                            <asp:Label ID="PatientCountryLabel" AssociatedControlID="PatientCountry" runat="server" Text="Country" /></td>
                        <td width="225px">
                            <asp:TextBox ID="PatientCountry" runat="server" Enabled="False" Width="150"></asp:TextBox>
                        </td>

                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="PatientVitalStatusLabel" AssociatedControlID="PatientVitalStatus" runat="server" Text="Vital Status" /></td>

                        <td width="225px">
                            <asp:TextBox ID="PatientVitalStatus" runat="server" Width="80" Enabled="False"></asp:TextBox>

                        </td>
                        <td width="50px"></td>
                        <td>
                            <asp:Label ID="PatientLostToFollowupLabel" AssociatedControlID="PatientLossToFollowUp" runat="server" Text="Lost to Follow Up" /></td>
                        <td>
                            <asp:TextBox ID="PatientLossToFollowUp" runat="server" Width="80" Enabled="False"></asp:TextBox>
                        </td>

                    </tr>
                </table>
            </div>

            <br />
            <div class="sectionHeader">Operation Summary </div>
            <br />
            <telerik:RadGrid ID="OperationGrid" runat="server" AutoGenerateColumns="False"
                AllowSorting="false"
                Width="100%" CellSpacing="0"
                AllowPaging="True"
                ShowStatusBar="True"
                GridLines="None"
                OnNeedDataSource="OperationGrid_NeedDataSource"
                OnItemCommand="OperationGrid_ItemCommand">

                <ClientSettings AllowColumnsReorder="False" ReorderColumnsOnClient="False" Selecting-AllowRowSelect="false"
                    EnablePostBackOnRowClick="false">
                    <Scrolling AllowScroll="true" />
                </ClientSettings>


                <MasterTableView DataKeyNames="PatientOperationId, SiteID" CommandItemDisplay="Top">
                    <CommandItemSettings ShowExportToPdfButton="false"
                        ShowExportToExcelButton="false"
                        ShowRefreshButton="false"
                        ShowAddNewRecordButton="False"></CommandItemSettings>
                    <Columns>

                        <telerik:GridTemplateColumn UniqueName="PatientOperationId" HeaderText="Operation ID" AllowFiltering="false" HeaderStyle-Width="80">
                            <ItemTemplate>
                                <asp:LinkButton ID="EditOperationLink" Text='<%# Eval("PatientOperationId") %>' runat="server" CommandName="EditOperation"> </asp:LinkButton>
                            </ItemTemplate>

                            <HeaderStyle Width="80px"></HeaderStyle>
                        </telerik:GridTemplateColumn>

                        <telerik:GridDateTimeColumn DataField="OperationDate" HeaderText="Operation Date" UniqueName="OperationDate" HeaderStyle-Width="120"
                            DataFormatString="{0:dd/MM/yyyy}" AutoPostBackOnFilter="true">
                        </telerik:GridDateTimeColumn>

                        <telerik:GridBoundColumn DataField="OperationStatus" HeaderText="Operation Status" UniqueName="OperationStatus" HeaderStyle-Width="120" AutoPostBackOnFilter="true">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text=""></ModelErrorMessage>
                            </ColumnValidationSettings>

                            <HeaderStyle Width="120px"></HeaderStyle>
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationType" HeaderText="Operation Type" UniqueName="OperationType" AutoPostBackOnFilter="true">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text=""></ModelErrorMessage>
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationWeight" HeaderText="Operation Weight" UniqueName="OperationWeight" AutoPostBackOnFilter="true">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text=""></ModelErrorMessage>
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationSite" HeaderText="Site" UniqueName="Site" AutoPostBackOnFilter="true">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text=""></ModelErrorMessage>
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="SiteId" HeaderText="Site ID" UniqueName="SiteId" Display="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationSurgeon" HeaderText="Surgeon" UniqueName="User" AutoPostBackOnFilter="true">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text=""></ModelErrorMessage>
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="DiabetesStatus" HeaderText="Diabetes Status" UniqueName="DiabetesStatus" AutoPostBackOnFilter="true">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text=""></ModelErrorMessage>
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="DiabetesTreatment" HeaderText="Diabetes Treatment" UniqueName="DiabetesTreatment" AutoPostBackOnFilter="true">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text=""></ModelErrorMessage>
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>

                    </Columns>

                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column"></EditColumn>
                    </EditFormSettings>

                    <PagerStyle PageSizeControlType="RadComboBox"></PagerStyle>
                </MasterTableView>

                <PagerStyle PageSizeControlType="RadComboBox"></PagerStyle>

                <FilterMenu EnableImageSprites="False"></FilterMenu>
            </telerik:RadGrid>

            <br />
            <asp:TextBox ID="Height" runat="server" Visible="false"></asp:TextBox>
            <asp:TextBox ID="StartWeight" runat="server" Visible="false"></asp:TextBox>
            <br />

            <asp:Panel ID="PatientSummary" runat="server">
                <div class="sectionHeader">
                    <table width="60%" border="0">
                        <tr>
                            <td>
                                <asp:Label ID="PatientSummaryLabel" runat="server" Text="Patient Summary"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="FollowupDate" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                    </table>

                </div>
                <br />

                <table border="0">
                    <colgroup>
                        <col width="250px" />
                    </colgroup>
                    <tr>
                        <td>
                            <asp:Label ID="PatientInitialWeightLabel" AssociatedControlID="InitialWeight" runat="server" Text="Intial Weight"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="InitialWeight" runat="server" Enabled="False" Width="100"></asp:TextBox></td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td class="auto-style2">
                            <asp:Label ID="PatientInitialBMILabel" AssociatedControlID="InitialBMI" runat="server" Text="Intial BMI"></asp:Label>&nbsp;</td>
                        <td class="auto-style3">
                            <asp:TextBox ID="InitialBMI" runat="server" Enabled="False" Width="100"></asp:TextBox></td>
                    </tr>
                </table>

                <asp:Panel ID="PatientFollowUpSummary" runat="server">
                    <table border="0">
                        <colgroup>
                            <col width="250px" />
                        </colgroup>

                        <tr>
                            <td>
                                <asp:Label ID="PatientFollowupWeightLabel" AssociatedControlID="PatientFollowUpWeight" runat="server" Text="Follow Up Weight"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="PatientFollowUpWeight" runat="server" Width="100" Enabled="False"></asp:TextBox></td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                <asp:Label ID="PatientFollowupBMILabel" AssociatedControlID="PatientFollowUpBMI" runat="server" Text="Follow Up BMI" Width="100"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="PatientFollowUpBMI" runat="server" Width="100" Enabled="False"></asp:TextBox></td>
                        </tr>

                        <tr>
                            <td>
                                <asp:Label ID="PatientWeightLossLabel" AssociatedControlID="PatientWeightLoss" runat="server" Text="Weight Loss" Width="100"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="PatientWeightLoss" runat="server" Width="100" Enabled="False"></asp:TextBox></td>
                            <td></td>
                            <td>
                                <asp:Label ID="PatientBMIChangeLabel" AssociatedControlID="PatientBMIChange" runat="server" Text="BMI Change" Width="100"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="PatientBMIChange" runat="server" Width="100" Enabled="False"></asp:TextBox></td>
                        </tr>

                        <tr>
                            <td>
                                <asp:Label ID="PatientPercentEWLLabel" AssociatedControlID="PatientEWLPercent" runat="server" Text="% EWL" Width="100"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="PatientEWLPercent" runat="server" Width="100" Enabled="False"></asp:TextBox></td>
                        </tr>

                    </table>
                </asp:Panel>
            </asp:Panel>
        </div>
    </div>
    <div>
        <table>
            <tr>
                <td colspan="2">
                    <asp:Button ID="BackButton" runat="server" Text="Cancel" CausesValidation="false" OnClick="BackButtonClicked" TabIndex="40" />
                </td>
            </tr>
        </table>

    </div>
</asp:Content>
