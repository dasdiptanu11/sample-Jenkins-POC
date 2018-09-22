<%@ Page Title="Patient Details" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    AutoEventWireup="True" CodeBehind="SurgeonDashboard.aspx.cs" Inherits="App.UI.Web.Views.Forms.SurgeonHome" %>

<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/PatientRibbon.ascx" TagPrefix="uc" TagName="PatientRibbon" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <uc:ContentHeader ID="Header" runat="server" Title="Dashboard" />
    <asp:ValidationSummary ID="PatientSearchValidationSummary" runat="server" ValidationGroup="PatientSearchDataValidationGroup" CssClass="failureNotification" HeaderText="" DisplayMode="List" />
    <br />

    <div class="form">
        <table cellpadding="0" cellspacing="0" width="80%" border="0">
            <tr>
                <td width="50%" valign="top">
                    <asp:Label ID="ExactMatchLabel" runat="server" Text="Exact Match" Font-Bold="True"></asp:Label>
                </td>

                <td width="50%">
                    <asp:Label ID="LikeMatchLabel" runat="server" Text="Best 'Like' Match (enter one or more fields)" Font-Bold="True" Font-Italic="False"></asp:Label>
                </td>
            </tr>
            <tr>
                <td width="40%">
                    <table width="100%" cellpadding="0" cellspacing="0" border="0" style="border-right: solid; border-right-width: 1px">
                        <tr>
                            <td width="20%">
                                <asp:Label ID="PatientSiteLabel" runat="server" AssociatedControlID="PatientSiteId" Text="Site " />
                            </td>
                            <td width="40%">
                                <asp:DropDownList ID="PatientSiteId" runat="server" Width="90%" Height="21px" TabIndex="2" />
                            </td>
                            <td width="30px">
                                <asp:Image ID="imgInfo1" runat="server" ImageUrl="~/Images/info.png" />
                                <telerik:RadToolTip ID="rttInfo1" runat="server" TargetControlID="imgInfo1"
                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                    <asp:Panel ID="pnrttInfo1" runat="server" Width="400px">
                                        <div class="form">
                                            <div style="padding-left: 5px">
                                                <asp:Label ID="lblrttInfo1" runat="server" Text="<b>Site:</b> Please choose the site the procedure is taking place, or in the case of follow up, took place.  If the site is not listed please contact the BSR at med-bsr@monash.edu or 03-9903 0722 to have an additional site added to your profile" />
                                            </div>
                                        </div>
                                    </asp:Panel>
                                </telerik:RadToolTip>
                            </td>
                            <td width="10%"></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="PatientURNLabel" runat="server" AssociatedControlID="PatientURN" Text="UR No " /></td>
                            <td>
                                <asp:TextBox ID="PatientURN" runat="server" Width="88%" Height="20px" TabIndex="1" />
                            </td>
                            <td width="30px">
                                <asp:Image ID="imgInfo2" runat="server" ImageUrl="~/Images/info.png" />
                                <telerik:RadToolTip ID="rttInfo2" runat="server" TargetControlID="imgInfo2"
                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                    <asp:Panel ID="pnrttInfo2" runat="server" Width="400px">
                                        <div class="form">
                                            <div style="padding-left: 5px">
                                                <asp:Label ID="lblrttInfo2" runat="server" Text="<b>UR No:</b> Please type in the patient’s UR number (medical record number) for the site chosen, ignoring leading zeros or letters at the start of the number.  If the patient is already registered in the BSR their details will appear below.  If they are not, you will be told “No matching patient record found” and you will be given the option to add the patient." />
                                            </div>
                                        </div>
                                    </asp:Panel>
                                </telerik:RadToolTip>
                            </td>
                        </tr>
                    </table>
                </td>
                <td valign="top">
                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td width="30%">
                                <asp:Label ID="PatientFamilyNameLabel" AssociatedControlID="FamilyName" runat="server" Text=" Family Name" />
                            </td>
                            <td width="50%">
                                <asp:TextBox ID="FamilyName" runat="server" MaxLength="40" Width="100%" onkeyup="this.value = this.value.toUpperCase();" />
                            </td>
                            <td width="20%"></td>
                        </tr>
                        <tr>
                            <td width="30%">
                                <asp:Label ID="PatientGivenNameLabel" AssociatedControlID="GivenName" runat="server" Text=" Given Name" />
                            </td>
                            <td width="50%">
                                <asp:TextBox ID="GivenName" runat="server" MaxLength="40" Width="100%" onkeyup="this.value = this.value.toUpperCase();" />
                            </td>
                            <td width="20%"></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br />
        <table>
            <tr>
                <td>
                    <asp:Button ID="SearchButton" Height="32px" runat="server" Width="125px" Text="Search" ValidationGroup="PatientSearchDataValidationGroup" TabIndex="3" OnClick="SearchClicked" />
                </td>
                <td>
                    <asp:Button ID="ClearButton" Height="32px" runat="server" Width="125px" Text="Clear" TabIndex="4" OnClick="ClearClicked" />
                </td>
            </tr>
        </table>
        <asp:BulletedList ID="PatientSearchErrorMessages" runat="server" CssClass="failureNotification" Style="list-style-type: none;"></asp:BulletedList>

        <table cellpadding="0" cellspacing="0" width="100%" border="0">
             <tr>
                <td colspan="5">
                    <asp:Label ID="PatientSearch" runat="server" Text="Label"></asp:Label></td>
            </tr>
            <tr>
                <td>
                    <asp:Button ID="AddPatientButton" Width="125px" runat="server" Text="Add Patient" CausesValidation="false" Height="32px" OnClick="AddPatientClicked" Visible="False" />
                </td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="5"></td>
            </tr>
        </table>
        <asp:Panel ID="PatientListPanel" runat="server" Visible="false">
            <telerik:RadGrid ID="PatientDetailsGrid" runat="server" AllowFilteringByColumn="false" AutoGenerateColumns="False"
                AllowSorting="True" Width="100%" CellSpacing="0" AllowPaging="True" ShowStatusBar="True"
                OnNeedDataSource="PatientGrid_NeedDataSource" OnPreRender="PatientGrid_PreRender"
                OnItemCreated="PatientGrid_ItemCreated"
                AllowMultiRowSelection="True" OnItemCommand="PatientGrid_ItemCommand" GridLines="None" PageSize="10" >

                <GroupingSettings CaseSensitive="false" />

                <ClientSettings AllowColumnsReorder="False" ReorderColumnsOnClient="False" Selecting-AllowRowSelect="false"
                    EnablePostBackOnRowClick="false">
                    <Scrolling AllowScroll="True" ScrollHeight="470px" />
                </ClientSettings>

                <MasterTableView DataKeyNames="PatientId,URN,SiteId,StatusId" CommandItemDisplay="Top" HeaderStyle-HorizontalAlign="Left">
                    <CommandItemSettings ShowExportToPdfButton="false" ShowExportToExcelButton="false" ShowRefreshButton="False" ShowAddNewRecordButton="False"></CommandItemSettings>
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

                        <telerik:GridTemplateColumn UniqueName="ShowPatient" DataField="URN" Reorderable="false" Resizable="false" HeaderStyle-Width="80"
                            AllowFiltering="true" HeaderText="URN" SortExpression="URN" ShowFilterIcon="false">
                            <ItemTemplate>
                                <asp:LinkButton ID="ShowPatientLinkButton" Text='<%#Eval("URN")%>' runat="server" CommandName="ShowPatient" ToolTip="Display Patient details"></asp:LinkButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="URN" HeaderText="URN" UniqueName="URN" HeaderStyle-Width="80" Visible="false" >
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
            </telerik:RadGrid>
        </asp:Panel>
     
        <br />
        <asp:Panel ID="TotalOptOffPanel" runat="server" Width="100%">
            <asp:Label ID="Label1" runat="server" Text="This patient has totally opted off from the registry ((Do not contact or add their details into the Registry)" ForeColor="Red"></asp:Label>
        </asp:Panel>
    
        <asp:Panel ID="PatientsExistPanel" runat="server" Width="100%">
            <%--  <asp:Label ID="lblActionsToBeTaken" runat="server" Text=" Actions To Be Taken" Font-Bold="True" Font-Size="Medium" Font-Underline="False" ForeColor="Blue" Height="32px"></asp:Label>--%>
            <div class="sectionPanel1">
                <div class="sectionHeader">
                    Actions To Be Taken
                </div>
            </div>

            <asp:Table ID="PatientDetailsTable" runat="server" Width="100%" CellPadding="10">
                <%--Header Row--%>
                <asp:TableRow Height="15%">
                    <asp:TableCell Width="33%" BorderWidth="1" HorizontalAlign="Center">
                        <asp:Label ID="PrimaryOperationLabel" Font-Bold="True" runat="server" Text="Primary Operation"></asp:Label>
                    </asp:TableCell>

                    <asp:TableCell Width="33%" BorderWidth="1" HorizontalAlign="Center">
                        <asp:Label ID="RevisionOperationLabel" Font-Bold="True" runat="server" Text="Revision Operation(s)"></asp:Label>
                    </asp:TableCell>

                    <asp:TableCell Width="33%" BorderWidth="1" HorizontalAlign="Center">
                        <asp:Label ID="FollowUpLabel" runat="server" Font-Bold="True" Text="Follow Up(s) Due"></asp:Label>
                    </asp:TableCell>
                </asp:TableRow>

                <%--  Details of Operations--%>
                <asp:TableRow Height="55%">
                    <asp:TableCell BorderWidth="1">
                        <asp:Panel ID="PrimaryOperationPanel" runat="server" Style="padding: 10px">
                            <asp:Label ID="PrimaryOperationDetailsLabel" runat="server" Text=""></asp:Label>
                        </asp:Panel>
                    </asp:TableCell>

                    <asp:TableCell BorderWidth="1" Style="padding: 10px">
                        <asp:Panel ID="RevisionOperationPanel" Width="100%" runat="server">
                        </asp:Panel>
                    </asp:TableCell>

                    <asp:TableCell BorderWidth="1" Style="padding: 10px">
                        <asp:Panel ID="FollowupPanel" Width="100%" runat="server"></asp:Panel>
                    </asp:TableCell>

                </asp:TableRow>

                <asp:TableRow Height="15%">
                    <asp:TableCell ColumnSpan="1">
                        <asp:Label ID="ErrorPrimaryOperationLabel" runat="server" Text="" CssClass="failureNotification"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell ColumnSpan="1">
                        <asp:Label ID="ErrorRevisionOperationLabel" runat="server" Text="" CssClass="failureNotification"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell ColumnSpan="1">
                        <asp:Label ID="ErrorFollowUpLabel" runat="server" Text="" CssClass="failureNotification"></asp:Label>
                    </asp:TableCell>

                </asp:TableRow>
                <asp:TableRow Height="15%">
                    <asp:TableCell>
                        <asp:Button ID="AddPrimaryOperationButton" Height="32px" runat="server" Text="Add Primary Operation" CausesValidation="false" OnClick="AddPrimaryOperationClicked" />
                        &nbsp;
                        <asp:Image ID="HelpImage3" runat="server" ImageUrl="~/Images/info.png" />
                        <telerik:RadToolTip ID="rttInfo03" runat="server" TargetControlID="HelpImage3"
                            Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                            AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                            <asp:Panel ID="pnrttInfo03" runat="server" Width="400px">
                                <div class="form">
                                    <div style="padding-left: 5px">
                                        <asp:Label ID="lblrttInfo03" runat="server" Text="<b>Add Primary Operation:</b> Choose this option if this is a primary operation for the patient, ie it is their first bariatric procedure." />
                                    </div>
                                </div>
                            </asp:Panel>
                        </telerik:RadToolTip>

                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:Button ID="AddRevisionOperationButton" runat="server" Text="Add Revision Operation" CausesValidation="false" Height="32px" OnClick="AddRevisionOperationClicked" />
                        &nbsp;
                        <asp:Image ID="imgInfo04" runat="server" ImageUrl="~/Images/info.png" />
                        <telerik:RadToolTip ID="rttInfo04" runat="server" TargetControlID="imgInfo04"
                            Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                            AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                            <asp:Panel ID="pnrttInfo04" runat="server" Width="400px">
                                <div class="form">
                                    <div style="padding-left: 5px">
                                        <asp:Label ID="lblrttInfo04" runat="server" Text="<b>Add Revision Operation:</b> Choose this option if this is a revision or subsequent bariatric operation for the patient." />
                                    </div>
                                </div>
                            </asp:Panel>
                        </telerik:RadToolTip>
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:Button ID="AddFollowupButton" runat="server" Text="Add Follow Up" CausesValidation="false" Height="32px" OnClick="AddFollowupClicked" />
                        &nbsp;
                        <asp:Image ID="HelpImage5" runat="server" ImageUrl="~/Images/info.png" />
                        <telerik:RadToolTip ID="rttInfo05" runat="server" TargetControlID="HelpImage5"
                            Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                            AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                            <asp:Panel ID="pnrttInfo05" runat="server" Width="400px">
                                <div class="form">
                                    <div style="padding-left: 5px">
                                        <asp:Label ID="lblrttInfo05" runat="server" Text="<b>Add Follow Up:</b> Choose this option if you need to complete a follow up for the patient.  A follow up may be 30 days after surgery or annual follow up.  Please select the follow up above that you would like to complete and then press the blue button." />
                                    </div>
                                </div>
                            </asp:Panel>
                        </telerik:RadToolTip>
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
        </asp:Panel>

        <asp:Panel ID="Panel1" runat="server" Visible="false">
            <telerik:RadGrid ID="FollowupGrid" runat="server"
                MasterTableView-DataKeyNames="PatientId, OperationDate, OperationType, OperationID, FollowUpID"
                OnNeedDataSource="FollowupGrid_NeedDataSource">
                <GroupingSettings CaseSensitive="false" />
                <MasterTableView CommandItemDisplay="Top" AutoGenerateColumns="false">
                    <Columns>
                        <telerik:GridBoundColumn DataField="PatientId" HeaderText="Patient ID" UniqueName="PatientId" HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationID" HeaderText="Operation ID" UniqueName="OperationID" HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="FollowUpID" HeaderText="FollowUp ID" UniqueName="FollowUpID" HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="URNo" HeaderText="UR No" UniqueName="URNo" HeaderStyle-Width="100">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="FamilyName" HeaderText="Family Name" UniqueName="FamilyName" HeaderStyle-Width="150">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="GivenName" HeaderText="Given Name" UniqueName="GivenName" HeaderStyle-Width="150">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationType" HeaderText="Operation Status" UniqueName="OperationType" HeaderStyle-Width="150">
                        </telerik:GridBoundColumn>

                        <telerik:GridDateTimeColumn DataField="OperationDate" UniqueName="OperationDate" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Operation Date" ItemStyle-Width="140" HeaderStyle-Width="140">
                        </telerik:GridDateTimeColumn>

                        <telerik:GridBoundColumn DataField="FollowUpPeriod" HeaderText="Follow Up Period" UniqueName="FollowUpPeriod" HeaderStyle-Width="110" ItemStyle-Width="110">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="FollowUpStatus" HeaderText="Follow Up Status" UniqueName="FollowUpStatus" HeaderStyle-Width="110" ItemStyle-Width="110">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="AttemptedCalls" HeaderText="Attempted Calls" UniqueName="AttemptedCalls" HeaderStyle-Width="80" ItemStyle-Width="80">
                        </telerik:GridBoundColumn>
                    </Columns>
                    <PagerStyle PageSizeControlType="RadComboBox"></PagerStyle>
                </MasterTableView>
            </telerik:RadGrid>

            <telerik:RadGrid ID="RevisionOperationGrid" runat="server"
                MasterTableView-DataKeyNames="OpID, OpDate, PatientId"
                OnNeedDataSource="RevisionOperationGrid_NeedDataSource">
                <GroupingSettings CaseSensitive="false" />
                <MasterTableView CommandItemDisplay="Top" AutoGenerateColumns="false">
                    <Columns>
                        <telerik:GridBoundColumn DataField="OpID" HeaderText="OpID" UniqueName="OpID" HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OpDate" HeaderText="OpDate" DataFormatString="{0:dd/MM/yyyy}" UniqueName="OpDate" HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="PatientId" HeaderText="Patient ID" UniqueName="PatientId" HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                    </Columns>
                    <PagerStyle PageSizeControlType="RadComboBox"></PagerStyle>
                </MasterTableView>
            </telerik:RadGrid>
        </asp:Panel>
    </div>
</asp:Content>