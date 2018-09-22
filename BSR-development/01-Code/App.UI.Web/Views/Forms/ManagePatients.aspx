<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="ManagePatients.aspx.cs" Inherits="App.UI.Web.Views.Forms.ManagePatients" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <script src="../../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        function Uncheck(first, second) {
            if ($get(first).checked) {
                $get(second).checked = false;
            }

            if (!$get(first).checked && !$get(second).checked) {
                $get(first).checked = true;
            }
        }
    </script>

    <asp:UpdatePanel runat="server" ID="UpdatePanel">
        <ContentTemplate>
            <asp:ValidationSummary ID="PatientMergeValidationSummary" runat="server" ValidationGroup="PatientMergeValidationGroup"
                CssClass="failureNotification" HeaderText="" DisplayMode="List" />

            <div class="form">
                <div style="font-size: 20px; padding-left: 0.5em;">
                    Total number of records to merge:
            <asp:Label runat="server" ID="TotalPatientRecords"></asp:Label>
                </div>
                <telerik:RadListView ID="PatientMergeGrid" runat="server" OnNeedDataSource="PatientMergeGrid_NeedDataSource" Width="100%"
                    ItemPlaceholderID="PatientsContainer" DataKeyNames="PatientId1,PatientId2,PriSite1,PriSite2,procAbon1,procAbon2,OpType1,OpType2,opDate1,opDate2" AllowPaging="true">
                    <LayoutTemplate>
                        <!--  OnItemCommand="rlvPatientMerge_ItemCommand" Set the id of the wrapping container to match the CLIENT ID of the RadListView control to display the ajax loading panel
                         In case the listview is embedded in another server control, you will need to append the id of that server control -->
                        <asp:PlaceHolder ID="PatientsContainer" runat="server"></asp:PlaceHolder>
                        <div style="clear: both">
                        </div>
                    </LayoutTemplate>

                    <ItemTemplate>
                        <!--The widths/heights of the fieldset/outer tables in the item/edit/insert templates should match to avoid wrapping or visual discrepancies
                             in the tiles layout-->
                        <div class="sectionPanel1">
                            <table cellpadding="0" cellspacing="0" style="width: 100%">
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                            <tr>
                                                <td colspan="2">
                                                    <div style="margin-bottom: 5px" class="sectionHeader">Matched Patients  (Matched on: <%# Eval("Identifier") %>)</div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 45%; padding-right: 15px;">
                                                    <fieldset class="EmbeddedViewPlaceholder">
                                                        <table cellpadding="0" style="width: 100%;" cellspacing="0">
                                                            <tr>
                                                                <td colspan="2" style="font-size: x-large; font-weight: bolder; text-align: center;">Original Record</td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div class="sectionHeader"><b>Patient URN:</b> <%# Eval("PatientURN1") %> </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="">Patient Id
                                                                </td>
                                                                <td>
                                                                    <%#Eval("PatientId1")%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="">Title
                                                                </td>
                                                                <td>
                                                                    <%#Eval("Title1")%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="">Family Name
                                                                </td>
                                                                <td>
                                                                    <%#Eval("PatientLastName1")%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="">Given Name
                                                                </td>
                                                                <td>
                                                                    <%#Eval("PatientFirstName1")%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 30%">DOB
                                                                </td>
                                                                <td style="width: auto">
                                                                    <%#Eval("DOB1", "{0:dd/MM/yyyy}")%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="">Gender
                                                                </td>
                                                                <td>
                                                                    <%#Eval("Gender1")%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="">Street Number and Name
                                                                </td>
                                                                <td>
                                                                    <%#Eval("Addr1")%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="">Suburb
                                                                </td>
                                                                <td>
                                                                    <%#Eval("Suburb1")%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="">Country
                                                                </td>
                                                                <td>
                                                                    <%#Eval("Country1")%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="">State
                                                                </td>
                                                                <td>
                                                                    <%#Eval("State1")%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="">Postcode
                                                                </td>
                                                                <td>
                                                                    <%#Eval("Postcode1")%>
                                                                </td>
                                                            </tr>
                                                        </table>

                                                        <asp:Panel runat="server" ID="AustraliaPanel1" Visible='<%# DataBinder.Eval(Container.DataItem, "Country1") != null && (DataBinder.Eval(Container.DataItem, "Country1").ToString().ToUpper()=="AUSTRALIA") ? true : false %>'>
                                                            <table cellpadding="0" style="width: 100%;" cellspacing="0">
                                                                <tr>
                                                                    <td style="width: 30%">Medicare Number
                                                                    </td>
                                                                    <td>
                                                                        <%#Eval("MedicareNo1")%>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="">DVA Number
                                                                    </td>
                                                                    <td>
                                                                        <%# Eval("DvaNo1")%>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>

                                                        <asp:Panel runat="server" ID="NewZealandPanel1" Visible='<%# DataBinder.Eval(Container.DataItem, "Country1") != null && (DataBinder.Eval(Container.DataItem, "Country1").ToString().ToUpper()=="NEW ZEALAND") ? true : false %>'>
                                                            <table cellpadding="0" style="width: 100%;" cellspacing="0">
                                                                <tr>
                                                                    <td style="width: 30%">NHI
                                                                    </td>
                                                                    <td>
                                                                        <%# Eval("NhiNo1")%>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>

                                                        <asp:Panel runat="server" ID="IndigenousStatusPanel1" Visible='<%# DataBinder.Eval(Container.DataItem, "Country1") != null && (DataBinder.Eval(Container.DataItem, "Country1").ToString().ToUpper()=="AUSTRALIA") ? true : false %>'>
                                                            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                                <tr>
                                                                    <td style="width: 30%">Indigenous Status
                                                                    </td>
                                                                    <td>
                                                                        <%# Eval("IndigenousSts1")%>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>

                                                        <table cellpadding="0" style="width: 100%;" cellspacing="0">
                                                            <tr>
                                                                <td style="width: 30%">Home Phone Number
                                                                </td>
                                                                <td>
                                                                    <%# Eval("HomePh1")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Mobile Phone Number
                                                                </td>
                                                                <td>
                                                                    <%# Eval("MobPh1")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Vital Status
                                                                </td>
                                                                <td>
                                                                    <%# Eval("HealthSts1")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Opt Off Status
                                                                </td>
                                                                <td>
                                                                    <%# Eval("OptOffSts1")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">URN
                                                                </td>
                                                                <td>
                                                                    <%# Eval("PatientURN1")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td colspan="2">
                                                                    <div style="margin-bottom: 5px; margin-top: 5px" class="sectionHeader">Operation Details</div>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Operation URN
                                                                </td>
                                                                <td>
                                                                    <%# Eval("PriOpURN1")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Operation Date
                                                                </td>
                                                                <td>
                                                                    <%#Eval("opDate1", "{0:dd/MM/yyyy}")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Operation Type
                                                                </td>
                                                                <td>
                                                                    <%# Eval("OpType1")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Operation Procedure
                                                                </td>
                                                                <td>
                                                                    <%#Eval("OpProc1")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Operation Surgeon
                                                                </td>
                                                                <td>
                                                                    <%#Eval("PriOpSurg1")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td colspan="2">
                                                                    <div style="margin-bottom: 5px; margin-top: 5px" class="sectionHeader">Consent Site & On-going Care Surgeon Details</div>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">On-going Care Surgeon
                                                                </td>
                                                                <td>
                                                                    <%#Eval("PriSurg1")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Consent Site
                                                                </td>
                                                                <td>
                                                                    <%#Eval("PriSite1")%>
                                                                </td>
                                                            </tr>
                                                        </table>

                                                    </fieldset>
                                                </td>

                                                <td align="right" style="width: 45%; padding-left: 15px;">
                                                    <fieldset class="EmbeddedViewPlaceholder">
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <tr>
                                                                <td colspan="2" style="font-size: x-large; font-weight: bolder; text-align: center;">Matching Record</td>
                                                            </tr>

                                                            <tr>
                                                                <td colspan="2">
                                                                    <div class="sectionHeader"><b>Patient URN:</b> <%# Eval("PatientURN2") %> </div>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Patient Id
                                                                </td>
                                                                <td>
                                                                    <%#Eval("PatientId2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Title
                                                                </td>
                                                                <td>
                                                                    <%#Eval("Title2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Family Name
                                                                </td>
                                                                <td>
                                                                    <%#Eval("PatientLastName2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Given Name
                                                                </td>
                                                                <td>
                                                                    <%#Eval("PatientFirstName2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="width: 30%">DOB
                                                                </td>
                                                                <td style="width: auto">
                                                                    <%#Eval("DOB2", "{0:dd/MM/yyyy}")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Gender
                                                                </td>
                                                                <td>
                                                                    <%#Eval("Gender2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Street Number and Name
                                                                </td>
                                                                <td>
                                                                    <%#Eval("Addr2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Suburb
                                                                </td>
                                                                <td>
                                                                    <%#Eval("Suburb2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Country
                                                                </td>
                                                                <td>
                                                                    <%#Eval("Country2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">State
                                                                </td>
                                                                <td>
                                                                    <%#Eval("State2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Postcode
                                                                </td>
                                                                <td>
                                                                    <%#Eval("Postcode2")%>
                                                                </td>
                                                            </tr>
                                                        </table>

                                                        <asp:Panel runat="server" ID="AustraliaPanel2" Visible='<%# DataBinder.Eval(Container.DataItem, "Country2") != null && (DataBinder.Eval(Container.DataItem, "Country2").ToString().ToUpper()=="AUSTRALIA") ? true : false %>'>
                                                            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                                <tr>
                                                                    <td style="width: 30%">Medicare Number
                                                                    </td>
                                                                    <td>
                                                                        <%#Eval("MedicareNo2")%>
                                                                    </td>
                                                                </tr>

                                                                <tr>
                                                                    <td style="">DVA Number
                                                                    </td>
                                                                    <td>
                                                                        <%# Eval("DvaNo2")%>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>

                                                        <asp:Panel runat="server" ID="NewZealandPanel2" Visible='<%# DataBinder.Eval(Container.DataItem, "Country2") != null && (DataBinder.Eval(Container.DataItem, "Country2").ToString().ToUpper()=="NEW ZEALAND") ? true : false %>'>
                                                            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                                <tr>
                                                                    <td style="width: 30%">NHI
                                                                    </td>
                                                                    <td>
                                                                        <%# Eval("NhiNo2")%>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                        <asp:Panel runat="server" ID="IndigenousStatusPanel2" Visible='<%# DataBinder.Eval(Container.DataItem, "Country2") != null && (DataBinder.Eval(Container.DataItem, "Country2").ToString().ToUpper()=="AUSTRALIA") ? true : false %>'>
                                                            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                                <tr>
                                                                    <td style="width: 30%">Indigenous Status
                                                                    </td>
                                                                    <td>
                                                                        <%# Eval("IndigenousSts2")%>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>

                                                        <table cellpadding="0" style="width: 100%;" cellspacing="0">
                                                            <tr>
                                                                <td style="width: 30%">Home Phone Number
                                                                </td>
                                                                <td>
                                                                    <%# Eval("HomePh2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Mobile Phone Number
                                                                </td>
                                                                <td>
                                                                    <%# Eval("MobPh2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Vital Status
                                                                </td>
                                                                <td>
                                                                    <%# Eval("HealthSts2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Opt Off Status
                                                                </td>
                                                                <td>
                                                                    <%# Eval("OptOffSts2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">URN
                                                                </td>
                                                                <td>
                                                                    <%# Eval("PatientURN2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td colspan="2">
                                                                    <div style="margin-bottom: 5px; margin-top: 5px" class="sectionHeader">Operation Details</div>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Operation URN
                                                                </td>
                                                                <td>
                                                                    <%# Eval("PriOpURN2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Operation Date
                                                                </td>
                                                                <td>
                                                                    <%#Eval("opDate2", "{0:dd/MM/yyyy}")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Operation Type
                                                                </td>
                                                                <td>
                                                                    <%# Eval("OpType2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Operation Procedure
                                                                </td>
                                                                <td>
                                                                    <%#Eval("OpProc2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Operation Surgeon
                                                                </td>
                                                                <td>
                                                                    <%#Eval("PriOpSurg2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td colspan="2">
                                                                    <div style="margin-bottom: 5px; margin-top: 5px" class="sectionHeader">Consent Site & On-going Care Surgeon Details</div>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">On-going Care Surgeon
                                                                </td>
                                                                <td>
                                                                    <%#Eval("PriSurg2")%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="">Consent Site
                                                                </td>
                                                                <td>
                                                                    <%#Eval("PriSite2")%>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </fieldset>
                                                </td>
                                            </tr>

                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <fieldset style="width: 98%">
                            <legend>Patients</legend>No records for patients available.
                        </fieldset>
                    </EmptyDataTemplate>
                </telerik:RadListView>
                <asp:Panel runat="server" ID="ButtonsPanel">
                    <table style="width: 100%; padding-top: 5px;">
                        <tr>
                            <td colspan="3" style="text-align: left; width:100%">
                                <asp:BulletedList ID="MergePatientErrorMessages" runat="server" CssClass="failureNotification" Style="list-style-type: none;"></asp:BulletedList>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; width: 40%;">
                                <asp:Button ID="MergePatientButton" runat="server" OnClick="MergePatientClicked" Text="Merge Records"></asp:Button>
                                <asp:Button ID="IgnorePatientButton" runat="server" OnClick="IgnorePatientClicked" Text="Do Not Merge"></asp:Button>
                            </td>
                            <td style="text-align: center; width: 20%;">Current Record:
                                <asp:Label runat="server" ID="CurrentRecordNumber"><%=PageIndex %></asp:Label>
                            </td>
                            <td style="text-align: right; width: 40%;">
                                <asp:Button ID="PreviousRecordsButon" runat="server" OnClick="PreviousRecordsClicked" Text="Previous"></asp:Button>
                                <asp:Button ID="NextRecordsButton" runat="server" OnClick="NextRecordsClicked" Text="Next"></asp:Button>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Label runat="server" ID="MessageLabel"></asp:Label>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
