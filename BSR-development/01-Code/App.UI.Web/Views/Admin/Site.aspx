<%@ Page Title="Site" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    AutoEventWireup="True" CodeBehind="Site.aspx.cs" Inherits="App.UI.Web.Views.Forms.Site" Trace="false" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Src="~/Views/Shared/AuditForm.ascx" TagName="AuditForm" TagPrefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .auto-style1 {
            width: 191px;
        }

        .auto-style2 {
            width: 191px;
            height: 33px;
        }

        .auto-style3 {
            height: 33px;
        }

        .auto-style5 {
            height: 33px;
            width: 195px;
        }

        .auto-style7 {
            width: 212px;
        }

        .auto-style8 {
            width: 195px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadCodeBlock ID="rcb" runat="server">
        <script src="../../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>

        <script type="text/javascript">
            $(document).ready(function () {
                document.getElementById("<%=SiteName.ClientID %>").focus();
            });
        </script>
    </telerik:RadCodeBlock>

    <uc:ContentHeader ID="Header" runat="server" Title="Add New Site" />
    <br />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:ValidationSummary ID="InstituteValidationSummary" runat="server" ValidationGroup="SiteDataValidationGroup"
                CssClass="failureNotification" HeaderText="" DisplayMode="List" />

            <div class="form">
                <div class="sectionPanel1">
                    <div class="sectionContent2">
                        <input type="hidden" id="modifiedStatus" value="F" />
                        <table cellpadding="0" cellspacing="0" width="100%">
                            <colgroup>
                                <col width="250px" />
                            </colgroup>

                            <tr style="display: none;">
                                <td>
                                    <asp:Label ID="SiteHPIOLabel" AssociatedControlID="SiteHPIO" runat="server" CssClass="disabledLabel" Text="HPI-O" />
                                </td>
                                <td valign="middle">
                                    <asp:TextBox ID="SiteHPIO" runat="server" MaxLength="16" Enabled="False" />

                                    <asp:RegularExpressionValidator ID="RegularExpressionValidatorSiteHPIO" runat="server" ControlToValidate="SiteHPIO" CssClass="failureNotification" ErrorMessage="Please enter valid HPIO Number (At least 16 Digit)" ValidationExpression="^\d{16,20}$" ValidationGroup="SiteDataValidationGroup">*</asp:RegularExpressionValidator>
                                    <asp:Button ID="GetHPIButton" runat="server" Text="Get IHI-O" CausesValidation="false" OnClientClick="alert('This feature is not yet active');" Enabled="False" />
                                    <asp:Label ID="FeatureNotActiveLabel" runat="server" Visible="false" ForeColor="Red"><i>This feature is not active.</i> </asp:Label>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="SiteIdLabel" runat="server" Text="Site ID" />
                                </td>
                                <td valign="middle">
                                    <asp:Label ID="SiteId" runat="server" />
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="SiteNameLabel" AssociatedControlID="SiteName" runat="server" Text="Site Name *" />
                                </td>
                                <td valign="middle">
                                    <asp:TextBox ID="SiteName" runat="server" MaxLength="200" Width="300px" />
                                    <asp:CustomValidator ID="CustomValidator2SiteName" runat="server" CssClass="failureNotification"
                                        ErrorMessage="Duplicate site name" ValidationGroup="SiteDataValidationGroup" OnServerValidate="ValidateSiteName">*</asp:CustomValidator>
                                    <asp:CustomValidator ID="CustomValidatorSiteName" runat="server" CssClass="failureNotification"
                                        ErrorMessage="Site Name is a required field" ValidationGroup="SiteDataValidationGroup" OnServerValidate="ValidateMissingSiteName">*</asp:CustomValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="PrimaryContactLabel" AssociatedControlID="SitePrimaryContact" runat="server" Text="Site Primary Contact" /></td>
                                <td width="350px">
                                    <asp:TextBox ID="SitePrimaryContact" runat="server" MaxLength="100" Width="301px" />
                                </td>

                                <td width="150px">
                                    <asp:Label ID="Telephone1Label" AssociatedControlID="SitePhone1" runat="server" Text="Telephone" /></td>
                                <td>
                                    <asp:TextBox ID="SitePhone1" runat="server" MaxLength="30" Width="150px" />
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidatorSitePhone" runat="server" ControlToValidate="SitePhone1" CssClass="failureNotification" ErrorMessage="Please enter a valid phone number for primary contact" ValidationExpression="^\+*(?:([0-9]| )*?)([0-9]| )*$" ValidationGroup="SiteDataValidationGroup">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="SecondaryContactLabel" AssociatedControlID="SiteSecondaryContact" runat="server" Text="Site Secondary Contact" /></td>
                                <td>
                                    <asp:TextBox ID="SiteSecondaryContact" runat="server" MaxLength="100" Width="301px" />
                                </td>

                                <td>
                                    <asp:Label ID="TelephoneLabel" AssociatedControlID="SitePhone2" runat="server" Text="Telephone" /></td>
                                <td>
                                    <asp:TextBox ID="SitePhone2" runat="server" MaxLength="30" Width="150px" />
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidatorSitePhone2" runat="server" ControlToValidate="SitePhone2" CssClass="failureNotification" ErrorMessage="Please enter valid phone number for secondary contact" ValidationExpression="^\+*(?:([0-9]| )*?)([0-9]| )*$" ValidationGroup="SiteDataValidationGroup">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Country *</td>
                                <td valign="middle">
                                    <asp:DropDownList ID="SiteCountryId" runat="server" OnPreRender="CountryPreRender" AutoPostBack="true" OnSelectedIndexChanged="CountrySelectionChanged">
                                    </asp:DropDownList>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="SiteStreetLabel" AssociatedControlID="SiteAddress" runat="server" Text="Street Number and Name *" />
                                </td>
                                <td>
                                    <asp:TextBox ID="SiteAddress" runat="server" MaxLength="100" Width="301px" />

                                    <asp:CustomValidator ID="CustomValidatorSiteStreet" runat="server" CssClass="failureNotification"
                                        ErrorMessage="Site Address is a required field" ValidationGroup="SiteDataValidationGroup"
                                        OnServerValidate="ValidateMissingSiteStreet">*</asp:CustomValidator>
                                </td>

                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="SiteSuburbLabel" AssociatedControlID="SiteSuburb" runat="server" Text="Suburb *" />
                                </td>
                                <td valign="middle">
                                    <asp:TextBox ID="SiteSuburb" runat="server" MaxLength="50" />
                                    <asp:CustomValidator ID="CustomValidatorSiteSuburb" runat="server" CssClass="failureNotification"
                                        ErrorMessage="Site Suburb is a required field" ValidationGroup="SiteDataValidationGroup"
                                        OnServerValidate="ValidatingMissingSiteSuburb">*</asp:CustomValidator>
                                </td>
                            </tr>
                        </table>

                        <asp:Panel ID="StatePanel" runat="server">
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <colgroup>
                                    <col width="252px" />
                                </colgroup>

                                <tr>
                                    <td>
                                        <asp:Label ID="SiteStateLabel" AssociatedControlID="SiteStateId" runat="server" Text="State *" />
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="SiteStateId" runat="server" Width="96px" />
                                        <asp:CustomValidator ID="CustomValiadatorSiteState" runat="server" CssClass="failureNotification" ValidationGroup="SiteDataValidationGroup"
                                            ErrorMessage="Site State is a required field" OnServerValidate="ValidateSiteState">*</asp:CustomValidator>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>

                        <table width="100%" cellpadding="0" cellspacing="0">
                            <colgroup>
                                <col width="250px" />
                            </colgroup>

                            <tr>
                                <td>
                                    <asp:Label ID="SitePostCodeLabel" AssociatedControlID="SitePostCode" runat="server" Text="Postcode *" />
                                </td>
                                <td valign="middle">
                                    <asp:TextBox ID="SitePostCode" runat="server" Width="40px" MaxLength="4" />
                                    <asp:CustomValidator ID="CustomValidatorSitePostCode" runat="server" CssClass="failureNotification"
                                        ValidationGroup="SiteDataValidationGroup" OnServerValidate="ValidateSitePostCode"
                                        ErrorMessage="Site Postcode is a required field">*</asp:CustomValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionPostCode" runat="server" ControlToValidate="SitePostCode"
                                        CssClass="failureNotification" ErrorMessage="Please enter valid Postcode (At least 4 Digit)"
                                        ValidationExpression="^\d{4,4}$" ValidationGroup="SiteDataValidationGroup">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="SiteTypeLabel" AssociatedControlID="SiteTypeId" runat="server" Text="Site Type *" />
                                </td>
                                <td valign="middle">
                                    <asp:DropDownList ID="SiteTypeId" runat="server" />
                                    <asp:CustomValidator ID="CustomValidatorSiteType" runat="server" CssClass="failureNotification"
                                        ErrorMessage="Site Type is a required field" ValidationGroup="SiteDataValidationGroup"
                                        OnServerValidate="ValidateSiteType">*</asp:CustomValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="SiteStatusLabel" AssociatedControlID="SiteStatusId" runat="server" Text="Site Status *" />
                                </td>
                                <td valign="middle">
                                    <asp:DropDownList ID="SiteStatusId" runat="server" />
                                    <asp:CustomValidator ID="CustomValidatorSiteStatus" runat="server" CssClass="failureNotification"
                                        ErrorMessage="Site status is a required field" ValidationGroup="SiteDataValidationGroup"
                                        OnServerValidate="ValidateSiteStatus">*</asp:CustomValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="PatientEADLabel" runat="server" AssociatedControlID="PatientEAD" Text="Ethics Approval Date (dd/mm/yyyy) *" />
                                </td>
                                <td>
                                    <telerik:RadDatePicker ID="PatientEAD" MinDate="1900-01-01" runat="server" Calendar-CultureInfo="en-AU" TabIndex="5" Width="150px">
                                    </telerik:RadDatePicker>
                                </td>
                                <td>
                                    <div style="overflow: hidden;">
                                        <div style="float: left">
                                            <asp:CustomValidator ID="CustomValidatePatientEAD" runat="server" OnServerValidate="ValidatePatientEAD" Display="Dynamic"
                                                ValidationGroup="SiteDataValidationGroup" CssClass="failureNotification"
                                                ErrorMessage="">*</asp:CustomValidator>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <asp:Button ID="CancelButton" runat="server" Text="Back" CausesValidation="false" />
                        <asp:Button ID="SaveButton" runat="server" Text="Save" ValidationGroup="SiteDataValidationGroup" CausesValidation="true"
                            OnClick="SaveClicked" />
                        <asp:Label ID="FormSavedMessage" runat="server" Class="successNotification"></asp:Label>

                    </td>
                </tr>
                <tr>
                    <td colspan="2"></td>
                </tr>
            </table>
            <uc3:AuditForm ID="auditForm" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
