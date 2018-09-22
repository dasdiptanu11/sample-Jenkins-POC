<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="CreateAccount.aspx.cs" Inherits="App.UI.Web.Views.Admin.CreateAccount" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Src="~/Views/Shared/AuditForm.ascx" TagName="AuditForm" TagPrefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .auto-style1 {
            height: 29px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <uc:ContentHeader ID="PageHeader" runat="server" Title="Create New User Account" />
    <br />
    <asp:HiddenField ID="EditingUser" runat="server" Value="" />
    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            function callConfirm() {
                radconfirm('Patients are associated with this hospital, if you change them, still the followup emails send to the existing surgeon, Are you sure you want to proceed with the site change?', confirmCallBackFn, 600);
            }

            function confirmCallBackFn(arg) {
                var ajaxManager = $find("<%=RadAjaxManager1.ClientID%>");
                if (arg) {
                    ajaxManager.ajaxRequest('ok');
                }
                else {
                    ajaxManager.ajaxRequest('cancel');
                }
            }

            function RestrictOpen(e, args) {
                if (e.get_items().toArray().length == 0)
                    args.set_cancel(true);
            }

            /* Uncheck the checkboxes for the States Name */
            function OnClientDropDownOpening(sender, eventArgs) {
                var items = sender.get_items();
                for (i = 0; i < items.get_count() ; i++) {
                    if (items.getItem(i).get_isSeparator()) {
                        var checkBox = items.getItem(i).get_checkBoxElement();
                        checkBox.style.display = "none";
                    }
                }
            }

            /* set checked property false for state elements*/
            function OnClientDropDownClosing(sender, eventArgs) {
                var items = sender.get_items();
                for (j = 0; j < items.get_count() ; j++) {
                    if (items.getItem(j).get_isSeparator()) {
                        var checkBox = items.getItem(j);
                        checkBox.set_checked(false);
                    }
                }
            }

            /* show an item to a list on itemchecked */
            function OnClientItemChecked(sender, eventArgs) {
                var item = eventArgs.get_item();
                var list = document.getElementById('itemList');
                var showSitesLabel = document.getElementById('showCheckedSites');
                showSitesLabel.style.display = 'inherit';
                var itemName = item.get_text();
                if (item.get_checked() && !item.get_isSeparator()) {
                    var node = document.createElement("LI");
                    var itemNode = document.createTextNode(itemName);
                    node.appendChild(itemNode);
                    list.appendChild(node)
                }
                else {
                    var items = Array.prototype.slice.call(list.childNodes);
                    for (k = 0; k < items.length; k++) {
                        if (items[k].innerHTML == itemName) {
                            list.removeChild(items[k]);
                        }
                    }
                }
                /* display none for showSitesLabel */
                if (list.childNodes.length == 0) {
                    showSitesLabel.style.display = 'none';
                }
            }

            /* loads all checked items in the list on load */
            function OnClientLoad(sender, eventArgs) {
                var items = sender.get_items();
                var list = document.getElementById('itemList');
                var checkedIndices = items._parent._checkedIndices;
                var checkedIndicesCount = checkedIndices.length;
                if (checkedIndicesCount > 0) {
                    for (var itemIndex = 0; itemIndex < checkedIndicesCount; itemIndex++) {
                        var item = items.getItem(checkedIndices[itemIndex]);
                        var node = document.createElement("LI");
                        var textnode = document.createTextNode(item.get_text());
                        node.appendChild(textnode);
                        list.appendChild(node)
                    }
                }
                else {
                    document.getElementById('showCheckedSites').style.display = 'none';
                }
            }

            /* showCheckedSites display none for data collector role*/
            window.onload = function () {
                var userRole = document.getElementById('UserRole');
                var selectedValue = userRole.options[userRole.selectedIndex].text;
                if (selectedValue == 'Data Collector')
                    document.getElementById('showCheckedSites').style.display = 'none';
           }


        </script>
    </telerik:RadCodeBlock>

    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="failureNotification" ValidationGroup="UserDataValidationGroup" HeaderText="" DisplayMode="List" />

    <div class="form">
        <asp:Label runat="server" ID="TestLabel"></asp:Label>
        <br />
        <asp:Label runat="server" ID="SiteId"></asp:Label>
        <table class="tableForm" cellpadding="0" cellspacing="0">
            <colgroup>
                <col width="250px" />
            </colgroup>

            <tr>
                <td>User ID *</td>
                <td>
                    <asp:UpdatePanel runat="server" ID="UserIdUpdatePanel">
                        <ContentTemplate>
                            <asp:TextBox ID="UserIdControl" runat="server" MaxLength="50" Width="202px" AutoPostBack="true" OnTextChanged="UserNameChanged"></asp:TextBox>
                            <asp:Image ID="UserAvailabilityImage" runat="server" Visible="false" />&nbsp;<asp:Label runat="server" ID="UserAvailabilityMessage"></asp:Label>

                            <asp:RequiredFieldValidator ID="RequiredVaidatorUserId" runat="server"
                                ErrorMessage="User ID is a required field." ControlToValidate="UserIdControl"
                                CssClass="failureNotification" ValidationGroup="UserDataValidationGroup">*</asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="CustomValidatorUserId" runat="server" ControlToValidate="UserIdControl"
                                CssClass="failureNotification" ErrorMessage="User ID already exists."
                                OnServerValidate="ValidateUserId" ValidationGroup="UserDataValidationGroup">*</asp:CustomValidator>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidatorUserId" runat="server" ValidationGroup="UserDataValidationGroup"
                                ControlToValidate="UserIdControl" CssClass="failureNotification"
                                ErrorMessage="Please enter valid User ID (At least 3 characters)"
                                ValidationExpression="^.{3,50}$">*</asp:RegularExpressionValidator>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>

            <tr>
                <td>
                    <asp:Label ID="UserTitleLabel" AssociatedControlID="UserTitle" runat="server" Text="Title *" />
                </td>
                <td>
                    <asp:DropDownList ID="UserTitle" runat="server" />
                    <asp:RequiredFieldValidator ID="RequiredValidatorUserTitle" runat="server" CssClass="failureNotification" ValidationGroup="UserDataValidationGroup"
                        ControlToValidate="UserTitle" ErrorMessage="Title is a required field">*</asp:RequiredFieldValidator>
                </td>
            </tr>

            <tr>
                <td>
                    <asp:Label ID="UserFamilyNameLabel" AssociatedControlID="UserFamilyName" runat="server" Text="Family Name *" />
                </td>
                <td>
                    <asp:TextBox ID="UserFamilyName" runat="server" MaxLength="40" onkeyup="this.value = this.value.toUpperCase();" />
                    <asp:RequiredFieldValidator ID="RequiredValidatorUserFamilyName" runat="server" CssClass="failureNotification"
                        ValidationGroup="UserDataValidationGroup" ControlToValidate="UserFamilyName"
                        ErrorMessage="Family Name is a required field">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidatorUserFamily" runat="server" ValidationGroup="UserDataValidationGroup"
                        ControlToValidate="UserFamilyName" CssClass="failureNotification"
                        ErrorMessage="" ValidationExpression="^[a-zA-Z '-_]{1,40}$">*</asp:RegularExpressionValidator>
                </td>
            </tr>

            <tr>
                <td class="auto-style1">
                    <asp:Label ID="UserGivenNameLabel" AssociatedControlID="UserGivenName" runat="server" Text="Given Name *" />
                </td>
                <td class="auto-style1">
                    <asp:TextBox ID="UserGivenName" runat="server" MaxLength="40" onkeyup="this.value = this.value.toUpperCase();" />
                    <asp:RequiredFieldValidator ID="RequiredValidatorGivenName" runat="server" CssClass="failureNotification"
                        ValidationGroup="UserDataValidationGroup" ControlToValidate="UserGivenName"
                        ErrorMessage="Given Name is a required field">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidatorGivenName" runat="server" ValidationGroup="UserDataValidationGroup"
                        ControlToValidate="UserGivenName" CssClass="failureNotification"
                        ErrorMessage="" ValidationExpression="^[a-zA-Z '-_]{1,40}$">*</asp:RegularExpressionValidator>
                </td>
            </tr>

            <tr>
                <td>Role *</td>
                <td>
                    <asp:DropDownList ID="UserRole" runat="server" OnSelectedIndexChanged="UserRoleSelectionChange" AutoPostBack="true" ClientIDMode="Static" />
                    <asp:RequiredFieldValidator ID="RequiredValidatorUserRole" runat="server" ValidationGroup="UserDataValidationGroup"
                        ControlToValidate="UserRole" CssClass="failureNotification"
                        ErrorMessage="User Role is a required field">*</asp:RequiredFieldValidator>
                </td>
            </tr>

            <tr>
                <td>
                    <asp:Label ID="CountryLabel" runat="server" AssociatedControlID="UserCountry" Text="Country *" /></td>
                <td>
                    <asp:DropDownList ID="UserCountry" runat="server" OnSelectedIndexChanged="CountrySelectionChange" OnPreRender="CountryPreRender" AutoPostBack="true" />
                    <asp:RequiredFieldValidator ID="RequiredValidatorCountry" runat="server" ValidationGroup="UserDataValidationGroup"
                        ControlToValidate="UserCountry" CssClass="failureNotification"
                        ErrorMessage="User Country is a required field">*</asp:RequiredFieldValidator></td>
            </tr>

            <tr>
                <td colspan="2">
                    <asp:Panel ID="SitePanel" runat="server" CssClass="EmbeddedViewPlaceholder">
                        <table cellpadding="0" cellspacing="0">
                            <colgroup>
                                <col width="235px" />
                            </colgroup>

                            <tr>
                                <td>Site Access</td>
                                <td>
                                    <table cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td>
                                                <telerik:RadComboBox ID="SitesComboBox" runat="server" AllowCustomText="true" AutoPostBack="false" CheckBoxes="true" Filter="Contains" MaxHeight="400px" OnClientDropDownOpening="OnClientDropDownOpening" OnClientDropDownClosing="OnClientDropDownClosing" OnClientItemChecked="OnClientItemChecked" OnClientLoad="OnClientLoad" Width="200px">
                                                </telerik:RadComboBox>
                                                <telerik:RadComboBox ID="SitesCollector" runat="server" AllowCustomText="true" AutoPostBack="false" Filter="Contains" MaxHeight="400px" Width="200px">
                                                </telerik:RadComboBox>
                                            </td>
                                            <%--  <td>
                                                <asp:Button ID="CheckSites" Text="Checked Sites" runat="server" OnClick="CheckSites_Click" Width="125px" />
                                            </td>--%>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="showCheckedSites" runat="server" Text="Checked Sites" ClientIDMode="Static"></asp:Label>
                    <ul id="itemList"></ul>
                </td>
            </tr>
            <tr style="display: none;">
                <td>
                    <asp:Label ID="UserHPIILabel" runat="server" CssClass="disabledLabel" AssociatedControlID="UserHPII" Text="HPI-I" />
                </td>
                <td>
                    <asp:TextBox ID="UserHPII" runat="server" MaxLength="16" Enabled="false" />
                    <asp:RegularExpressionValidator ID="RegularExpressionValidatorUserHPII" runat="server" ControlToValidate="UserHPII" CssClass="failureNotification" ErrorMessage="Please enter valid HPII Number (At least 16 Digit)" ValidationExpression="^\d{16,20}$" ValidationGroup="UserDataValidationGroup">*</asp:RegularExpressionValidator>
                    <asp:Button ID="GetHPIButton" runat="server" Enabled="false" Text="Get IHI-I" CausesValidation="false" OnClientClick="alert('This feature is not yet active');" />
                    <asp:Label ID="FeatureNotActiveLabel" runat="server" Visible="false" ForeColor="Red"><i>This feature is not active.</i> </asp:Label>
                </td>
            </tr>

            <tr>
                <td>Email *</td>
                <td>
                    <asp:TextBox ID="Email" runat="server" MaxLength="200" Width="300px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredValidatorUserEmail" runat="server"
                        ControlToValidate="Email" CssClass="failureNotification" ValidationGroup="UserDataValidationGroup"
                        ErrorMessage="Email is a required field">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidatorEmail" runat="server" ValidationGroup="UserDataValidationGroup"
                        ControlToValidate="Email" CssClass="failureNotification"
                        ErrorMessage="Please enter valid email address (e.g. name123@domain.com)"
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">*</asp:RegularExpressionValidator>

                </td>
            </tr>

            <tr>
                <td colspan="2">
                    <table cellpadding="0" cellspacing="0">
                        <colgroup>
                            <col width="240px" />
                        </colgroup>
                        <tr>
                            <td>Account Status</td>
                            <td>
                                <table cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td align="left">
                                            <asp:CheckBox ID="AccountActive" runat="server" Text="Active" />
                                        </td>
                                        <td>
                                            <asp:CheckBox ID="AccountLocked" runat="server" Text="Locked" /></td>
                                        <td>
                                            <asp:Button Width="150px" ID="ResetPasswordButton" runat="server" Text="Reset Password" CausesValidation="False" OnClick="ResetPasswordClicked" /></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>

    <table cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <div style="overflow: hidden;">
                    <div style="float: left">
                        <asp:Button ID="CancelButton" runat="server" Text="Back" CausesValidation="false" />
                        <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveClicked" ValidationGroup="UserDataValidationGroup" />
                    </div>
                    <div style="float: left; margin-left: 13px">
                        <asp:Label ID="FormSavedMessage" runat="server" Class="successNotification" Visible="false"></asp:Label>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="3"></td>
        </tr>
    </table>
    <asp:Label ID="lblLastSavedBy" runat="server" />
    <%--  </asp:View>--%>

    <%--View for confirmation--%>
    <uc3:AuditForm ID="auditForm" runat="server" />
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" OnAjaxRequest="RadAjaxManager1_AjaxRequest">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadAjaxManager1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="FormSavedMessage" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <telerik:RadWindowManager ID="RadWindowManager1" runat="server">
    </telerik:RadWindowManager>
    <%--    </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>
