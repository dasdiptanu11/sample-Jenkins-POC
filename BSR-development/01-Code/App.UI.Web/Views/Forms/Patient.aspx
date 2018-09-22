<%@ Page Title="Add Patient" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="True" CodeBehind="Patient.aspx.cs" Inherits="App.UI.Web.Views.Forms.Patient" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/SurgeonAndSite.ascx" TagPrefix="uc" TagName="SurgeonAndSite" %>
<%@ Register Src="~/Views/Shared/PatientRibbon.ascx" TagPrefix="uc" TagName="PatientRibbon" %>
<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Src="~/Views/Shared/AuditForm.ascx" TagName="AuditForm" TagPrefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .auto-style1 {
            width: 84%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadCodeBlock ID="rcb" runat="server">
        <script type="text/javascript">
            /* disable PatientDateOfDeath for patient upload by bulk load*/
            window.onload = function () {
                var dpDateofDeath = $find("<%= PatientDateOfDeath.ClientID %>");
                var dateOfDeathKnown = document.getElementById("<%= DateOfDeathKnown.ClientID %>").checked;
                if (dpDateofDeath != null) {
                    if (dateOfDeathKnown) {
                        dpDateofDeath.clear();
                        dpDateofDeath.set_enabled(false);
                        ValidatorEnable($('[id$=CustomValidatorPatientDateOfDeath]')[0], false);
                    }
                }
                var addressNotKnown = document.getElementById('<%=PatientAddressNotKnown.ClientID%>').checked;
                if (addressNotKnown == true) {
                    document.getElementById('<%=PatientStreetAddress.ClientID%>').value = "";
                    document.getElementById('<%=PatientSuburbAddress.ClientID%>').value = "";
                    document.getElementById('<%=PatientAddressPostcode.ClientID%>').value = '';
                    if (document.getElementById('<%=PatientStateId.ClientID%>') != null) {
                        document.getElementById('<%=PatientStateId.ClientID%>').selectedIndex = -1;
                            document.getElementById('<%=PatientStateId.ClientID%>').disabled = true;
                            document.getElementById('<%=PatientStateId.ClientID%>').className = "disabledDropDownList";
                    }
                    document.getElementById('<%=PatientAddressPostcode.ClientID%>').disabled = true;
                    document.getElementById('<%=PatientPostcodeNotKnown.ClientID%>').checked = true;
                }
            }

            function ShowConfirm(button) {
                var optOffStatusId = $get("<%=OptOffStatusId.ClientID %>")==null? "": $get("<%=OptOffStatusId.ClientID %>").value;
                if (optOffStatusId == "1") {
                    radconfirm('You are about to fully opt off this patient. This means all data for this patient would be deleted. Do you wish to proceed?', LaunchWindow, 450, 110, null, "Confirm");
                }
                else
                    __doPostBack("<%=SaveButton.UniqueID %>", "");
            }

            function ShowConfirm_Delete(button) {
                if (confirm("You are about to delete this patient and all data for this patient would be deleted. Do you wish to proceed?")) {
                    return true;
                }
                else {
                    return false;
                }
            }

            function ShowURN() {
                var oWindow = window.radopen('popupShowURN.aspx');
                oWindow.SetModal(true);
                oWindow.set_visibleStatusbar(false);
                oWindow.set_behaviors(Telerik.Web.UI.WindowBehaviors.Move + Telerik.Web.UI.WindowBehaviors.Close);
                oWindow.set_autoSize(false);
                oWindow.set_title('Patient URN(s)');
                oWindow.set_height('400px');
                oWindow.set_width('650px');
                oWindow.set_showContentDuringLoad(false);
                oWindow.add_close();
                oWindow.show();
            }

            function LaunchWindow(arg) {
                if (arg == true) {
                    radconfirm('Are you sure, you want to fully opt off this patient?', LaunchWindow_1, 450, 110, null, "Confirm");
                } else {
                    return false;
                }
            }


            function LaunchWindow_1(arg) {
                if (arg == true) {
                    __doPostBack("<%=SaveButton.UniqueID %>", "");
                    return true;
                }
                else { return false; }
            }

            function ClientSaveChecks() {
                formUnModified();
                ShowConfirm(true);
                return false;
            }

            function populateState(destination, source) {
                var dest = document.getElementById(destination);
                var postcode = document.getElementById(source).value;
                var postcode1 = document.getElementById(source).value;
                var addressNotKnown = document.getElementById('<%=PatientAddressNotKnown.ClientID%>').checked;
                if (addressNotKnown == false) {
                    if (postcode.charAt(0) == "1" || postcode.charAt(0) == "2") {
                        if (postcode >= 2600 && postcode <= 2612 || postcode >= 2614 && postcode <= 2617 || postcode >= 2900 && postcode <= 2906 || postcode >= 2911 && postcode <= 2914) {
                            dest.value = 8;//ACT
                        }
                        else {
                            dest.value = 1;//NSW
                        }
                    }
                    else if (postcode.substr(0, 2) == "08") {
                        dest.value = 7;//NT
                    }
                    else if (postcode.substr(0, 2) == "02") {
                        dest.value = 8;//ACT
                    }
                    else if (postcode.charAt(0) == 3 || (postcode.charAt(0) == 8 && postcode1 != "8888")) {
                        dest.value = 2;//VIC
                    }
                    else if (postcode.charAt(0) == 4 || (postcode.charAt(0) == 9 && postcode1 != "9999")) {
                        dest.value = 3;//QLD
                    }
                    else if (postcode.charAt(0) == 5) {
                        dest.value = 4;//SA
                    }
                    else if (postcode.charAt(0) == 6) {
                        dest.value = 5;//WA
                    }
                    else if (postcode.charAt(0) == 7) {
                        dest.value = 6;//TAS
                    }
                    else {
                        dest.value = '';
                    }
                }
            }

            function DateOfDeathKnown_ChekedChanged() {
                var dpDateofDeath = $find("<%= PatientDateOfDeath.ClientID %>");
                if (dpDateofDeath != null) {
                    if (document.getElementById('MainContent_DateOfDeathKnown').checked == true) {
                        dpDateofDeath.clear();
                        dpDateofDeath.set_enabled(false);
                        ValidatorEnable($('[id$=CustomValidatorPatientDateOfDeath]')[0], false);
                    }
                    else {
                        dpDateofDeath.set_enabled(true);
                        ValidatorEnable($('[id$=CustomValidatorPatientDateOfDeath]')[0], true);
                    }
                }
            }

            function HealthStatusId_SelectedIndexChanged(IsOnload) {
                var healthStatus = document.getElementById('<%=HealthStatusId.ClientID%>');
                var dpDateofDeath = $find("<%=PatientDateOfDeath.ClientID %>");
                
                var options = $("#<%= DeathRelatedToPrimaryProcedure.ClientID %>");

                if (options.val()=="") {
                    options.val("0").change();
                }

                var deathControlsPanel = $get("<%=DeathControlsPanel.ClientID %>");
                var DateOfDeathKnown = $get("<%=DateOfDeathKnown.ClientID%>");
                var txtPatient_CauseofDeath = $get("<%=CauseOfDeath.ClientID%>");
                if (healthStatus[healthStatus.selectedIndex].value == "1") {
                    ValidatorEnable($('[id$=CustomValidatorPatientDateOfDeath]')[0], true);
                    deathControlsPanel.style.display = 'block';
                    if (!IsOnload) {
                        dpDateofDeath.clear();
                    }
                }
                else {
                    deathControlsPanel.style.display = 'none';
                    ValidatorEnable($('[id$=CustomValidatorPatientDateOfDeath]')[0], false);
                    DateOfDeathKnown.checked = false;
                    txtPatient_CauseofDeath.value = '';
                }
            }

            window.onbeforeunload = null;
            function formModified() {
                document.getElementById('<%=modifiedStatus.ClientID%>').value = 'T';
            }

            function formUnModified() {
                window.onbeforeunload = null;
            }

            function confirmExit() {
                if (document.getElementById('<%=modifiedStatus.ClientID%>').value == 'T') {
                    return "Warning :  Any unsaved data will be lost. Do you want to continue?";
                }
                else {
                    return false;
                }
            }

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            if (prm != null) {
                prm.add_endRequest(function (sender, e) {
                    if (sender._postBackSettings.panelsToUpdate != null) {
                        $("input[type=text],input[type=password],input[type=radio],input[type=checkbox],select,textarea").focus(function () {
                            formModified();
                            window.onbeforeunload = confirmExit;
                        });

                        $("input[type=text],input[type=password],input[type=radio],input[type=checkbox],select,textarea").change(function () {
                            formModified();
                            window.onbeforeunload = confirmExit;
                        });

                        $("input[type=text],input[type=password],input[type=radio],input[type=checkbox],textarea").select(function () {
                            formModified();
                            window.onbeforeunload = confirmExit;
                        });
                    }
                });
            };

            $(document).ready(function () {
                $("input[type=text],input[type=password],input[type=radio],input[type=checkbox],select,textarea").focus(function () {
                    formModified();
                    window.onbeforeunload = confirmExit;
                });

                $("input[type=text],input[type=password],input[type=radio],input[type=checkbox],select,textarea").change(function () {
                    formModified();
                    window.onbeforeunload = confirmExit;
                });

                $("input[type=text],input[type=password],input[type=radio],input[type=checkbox],textarea").select(function () {
                    formModified();
                    window.onbeforeunload = confirmExit;
                });
            });

            var __oldDoPostBack = __doPostBack;
            __doPostBack = CatchExplorerError;

            function CatchExplorerError(eventTarget, eventArgument) {

                try {
                    return __oldDoPostBack(eventTarget, eventArgument);
                } catch (ex) {
                    // don't want to mask a genuine error
                    // lets just restrict this to our 'Unspecified' one
                    if (ex.message.indexOf('Unspecified') == -1) {
                        throw ex;
                    }
                    else {
                        alert('caught the error!');
                    }
                }
            }

            function OnError(sender, eventArgs) {
                // set cancel to hide the default message
                eventArgs.set_cancel(true);
                //show custom Error message
                var label = $get('<%= AgeLessThan18Label.ClientID %>');
                label.innerHTML = "";
            }

            function PatientBirthDateSelected() {
                var lbllessthan18 = document.getElementById('<%=AgeLessThan18Label.ClientID%>');
                lbllessthan18.innerHTML = '';
                var rdpPatient_DOB = document.getElementById('<%=PatientDOB.ClientID%>');
                var DOB = new Date();
                DOB = rdpPatient_DOB.value;
                if (DOB) {
                    if (CalcAge(DOB) < 18) {
                        lbllessthan18.innerHTML = "Patient is less than 18 years old";
                    }
                }
            }

            function CalcAge(birthday) {
                var dob = new Date(birthday);
                var now = new Date();
                now.getDate();
                var age = now.getYear() - dob.getYear();
                var newdob = new Date(new Date(birthday).setYear(dob.getFullYear() + age));
                if (now < newdob) age--;
                return age;
            }

            //Postcode enable or disable
            function postcodeEnableOrDisable(checked) {
                document.getElementById('<%=PatientAddressPostcode.ClientID%>').value = '';
                if (checked == true) {
                    document.getElementById('<%=PatientAddressPostcode.ClientID%>').disabled = true;
                }
                else {
                    document.getElementById('<%=PatientAddressPostcode.ClientID%>').disabled = false;
                }
            }

            function enableDisable(checked, controlId) {
                if (controlId == 'PatientHomePhone') {
                    document.getElementById('<%=PatientHomePhone.ClientID%>').value = '';
                    if (checked == true) {
                        document.getElementById('<%=PatientHomePhone.ClientID%>').disabled = true;
                    }
                    else {
                        document.getElementById('<%=PatientHomePhone.ClientID%>').disabled = false;
                    }
                }

                if (controlId == 'PatientMobile') {

                    document.getElementById('<%=PatientMobile.ClientID%>').value = '';
                    if (checked == true) {
                        document.getElementById('<%=PatientMobile.ClientID%>').disabled = true;
                        ValidatorEnable(document.getElementById('<%=RegularExpressionValidatorPatientMobile.ClientID%>'), false);
                    }
                    else {
                        document.getElementById('<%=PatientMobile.ClientID%>').disabled = false;
                        ValidatorEnable(document.getElementById('<%=RegularExpressionValidatorPatientMobile.ClientID%>'), true);
                    }
                }

                if (controlId == 'PatientAddressPostcode') {
                    postcodeEnableOrDisable(checked);
                }
                if (controlId == 'PatientStreetAddress') {

                    if (checked == true) {
                        document.getElementById('<%=PatientStreetAddress.ClientID%>').value = "";
                        document.getElementById('<%=PatientSuburbAddress.ClientID%>').value = "";
                        document.getElementById('<%=PatientAddressPostcode.ClientID%>').value = '';
                        if (document.getElementById('<%=PatientStateId.ClientID%>') != null) {
                            document.getElementById('<%=PatientStateId.ClientID%>').selectedIndex = -1;
                            document.getElementById('<%=PatientStateId.ClientID%>').disabled = true;
                            document.getElementById('<%=PatientStateId.ClientID%>').className = "disabledDropDownList";
                        }
                        document.getElementById('<%=PatientStreetAddress.ClientID%>').disabled = true;
                        document.getElementById('<%=PatientSuburbAddress.ClientID%>').disabled = true;
                        document.getElementById('<%=PatientAddressPostcode.ClientID%>').disabled = true;
                        document.getElementById('<%=PatientPostcodeNotKnown.ClientID%>').checked = true;
                        postcodeEnableOrDisable(true);
                    }
                    else {
                        document.getElementById('<%=PatientStreetAddress.ClientID%>').disabled = false;
                        document.getElementById('<%=PatientSuburbAddress.ClientID%>').disabled = false;
                        document.getElementById('<%=PatientAddressPostcode.ClientID%>').disabled = false;
                        document.getElementById('<%=PatientPostcodeNotKnown.ClientID%>').checked = false;
                        //document.getElementById('<%=PatientPostcodeNotKnown.ClientID%>').disabled = false;
                        postcodeEnableOrDisable(false);
                        if (document.getElementById('<%=PatientStateId.ClientID%>') != null) {
                            document.getElementById('<%=PatientStateId.ClientID%>').disabled = false;
                            document.getElementById('<%=PatientStateId.ClientID%>').className = "enabledDropDownList";
                        }
                    }
                }

                if (controlId == 'PatientMedicareNo') {
                    if (checked == true) {
                        document.getElementById('<%=PatientMedicareNo.ClientID%>').value = "";
                        document.getElementById('<%=PatientMedicareNoRef.ClientID%>').value = "";
                        ValidatorEnable(document.getElementById('<%=RegularExpressionValidatorMedicareNo.ClientID%>'), false);
                        ValidatorEnable(document.getElementById('<%=RegularExpressionMedicareNumberRef.ClientID%>'), false);
                        document.getElementById('<%=PatientMedicareNo.ClientID%>').disabled = true;
                        document.getElementById('<%=PatientMedicareNoRef.ClientID%>').disabled = true;
                    }
                    else {
                        ValidatorEnable(document.getElementById('<%=RegularExpressionValidatorMedicareNo.ClientID%>'), true);
                        ValidatorEnable(document.getElementById('<%=RegularExpressionMedicareNumberRef.ClientID%>'), true);
                        document.getElementById('<%=PatientMedicareNo.ClientID%>').disabled = false;
                        document.getElementById('<%=PatientMedicareNoRef.ClientID%>').disabled = false;
                    }
                }

                if (controlId == 'PatientNHINumber') {
                    document.getElementById('<%=PatientNHINumber.ClientID%>').value = '';
                    if (checked == true) {
                        document.getElementById('<%=PatientNHINumber.ClientID%>').disabled = true;
                    }
                    else {
                        document.getElementById('<%=PatientNHINumber.ClientID%>').disabled = false;
                    }
                }

                if (controlId == 'PatientDVANumber') {
                    document.getElementById('<%=PatientDVANumber.ClientID%>').value = '';
                    if (checked == true) {
                        document.getElementById('<%=PatientDVANumber.ClientID%>').disabled = true;
                    }
                    else {
                        document.getElementById('<%=PatientDVANumber.ClientID%>').disabled = false;
                    }
                }

                if (controlId == 'PatientDOB') {
                    var dp = $find("<%= PatientDOB.ClientID %>");
                    dp.clear();
                    if (checked == true) {
                        dp.set_enabled(false);
                        ValidatorEnable(document.getElementById('<%=CustomValidatorBirthdate.ClientID%>'), false);
                    }
                    else {
                        dp.set_enabled(true);
                        ValidatorEnable(document.getElementById('<%=CustomValidatorBirthdate.ClientID%>'), true);
                    }
                }
            }

            function PatientOptOffChanged() {
                if (document.getElementById('<%=PatientOptOffStatusWarningLabel.ClientID%>') != null) {
                    document.getElementById('<%=PatientOptOffStatusWarningLabel.ClientID%>').innerHTML = '';
                }

                var optOffDate = $find('<%=OptOffDate.ClientID%>');

                if (document.getElementById('<%=OptOffStatusId.ClientID%>') != null) {
                    if (document.getElementById('<%=OptOffStatusId.ClientID%>').value == '1' || document.getElementById('<%=OptOffStatusId.ClientID%>').value == '2') {
                        document.getElementById('<%=PatientOptOffPanel.ClientID%>').style.display = 'block';
                        
                        if (optOffDate != null) {
                            optOffDate.set_selectedDate(new Date());
                        }

                        if (document.getElementById('<%=OptOffStatusId.ClientID%>').value == '2') {
                            document.getElementById('<%=PatientOptOffStatusWarningLabel.ClientID%>').innerHTML = 'Warning: Do not phone (Partial Opt Off)';
                        }
                        else if (document.getElementById('<%=OptOffStatusId.ClientID%>').value == '1') {
                            document.getElementById('<%=PatientOptOffStatusWarningLabel.ClientID%>').innerHTML = 'Warning: Patient will be deleted';
                        }
                }
                else {
                    document.getElementById('<%=PatientOptOffPanel.ClientID%>').style.display = 'none';
                        if (optOffDate != null) {
                            optOffDate.set_selectedDate(null);
                        }
                    }
                }
            }
        </script>
    </telerik:RadCodeBlock>

    <asp:UpdatePanel ID="PatientUpdatePanel" runat="server">
        <ContentTemplate>
            <uc:ContentHeader ID="Header" runat="server" Title="Patient Demographics" />

            <uc:PatientRibbon runat="server" ID="PatientRibbon" />

            <asp:ValidationSummary ID="PatientValidationSummary" runat="server" ValidationGroup="PatientDataValidationGroup"
                CssClass="failureNotification" HeaderText="" DisplayMode="List" />

            <asp:ValidationSummary ID="PatientSearchValidationSummary" runat="server" ValidationGroup="PatientSearchDataValidationGroup"
                CssClass="failureNotification" HeaderText="" DisplayMode="List" />

            <input type="hidden" id="modifiedStatus" runat="server" value="F" />

            <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableShadow="true"></telerik:RadWindowManager>

            <div class="form">
                <div class="sectionPanel1">
                    <div class="sectionContent2">
                        <asp:Panel runat="server" ID="PatientInformationPanel">
                            <table border="0">
                                <colgroup>
                                    <col width="270px" />
                                </colgroup>
                                <tr>
                                    <td>Patient ID
                                    </td>
                                    <td>
                                        <div style="margin-left: 3px;">
                                            <asp:Label runat="server" ID="PatientIdPanel"></asp:Label>
                                        </div>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="PatientURNLabel" runat="server" AssociatedControlID="PatientURN" Text="UR No *" /></td>
                                    <td>
                                        <asp:TextBox ID="PatientURN" MaxLength="16" runat="server" TabIndex="1" />
                                        <asp:CustomValidator ID="CustomValidatorPatientURN" runat="server" OnServerValidate="ValidatePatientURN"
                                            ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                            ErrorMessage="">*</asp:CustomValidator>
                                        <asp:RegularExpressionValidator runat="server" ID="RegularExpressionValidatorPatientURN" CssClass="failureNotification" ControlToValidate="PatientURN"
                                            ValidationExpression="^[a-z.A-Z0-9]*$" ValidationGroup="PatientDataValidationGroup" ErrorMessage="Please enter valid URN">*</asp:RegularExpressionValidator>
                                    </td>

                                    <td>
                                        <asp:Button ID="ShowURNButton" runat="server" Text="Show URN(s)" CausesValidation="false" OnClientClick="ShowURN()" TabIndex="40" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="PatientTitleLabel" runat="server" AssociatedControlID="PatientTitleId" Text="Title" />
                                    </td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:DropDownList ID="PatientTitleId" runat="server" TabIndex="2" />
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="float: left">
                                            &nbsp;
                                                <asp:Image ID="imgInfo1" runat="server" ImageUrl="~/Images/info.png" />
                                            <telerik:RadToolTip ID="rttInfo1" runat="server" TargetControlID="imgInfo1"
                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                <asp:Panel ID="pnrttInfo1" runat="server" Width="400px">
                                                    <div class="form">
                                                        <div style="padding-left: 5px">
                                                            <asp:Label ID="lblrttInfo1" runat="server" Text="<b>Title:</b> Please choose patient’s preferred title or leave blank" />
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </telerik:RadToolTip>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="FamilyNameLabel" runat="server" AssociatedControlID="PatientFamilyName" Text="Family Name *" />
                                    </td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:TextBox ID="PatientFamilyName" runat="server" MaxLength="40" TabIndex="3" onkeyup="this.value = this.value.toUpperCase();" />
                                                <asp:CustomValidator ID="CustomValidatorFamilyName" runat="server" OnServerValidate="ValidatePatientFamilyName"
                                                    ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidatorFamilyName" runat="server" ValidationGroup="PatientDataValidationGroup"
                                                    ControlToValidate="PatientFamilyName" CssClass="failureNotification"
                                                    ErrorMessage="Please enter valid family name"
                                                    ValidationExpression="^[a-zA-Z_ '-]{1,40}$">*</asp:RegularExpressionValidator>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="float: left">
                                            &nbsp;
                                                <asp:Image ID="imgInfo3" runat="server" ImageUrl="~/Images/info.png" />
                                            <telerik:RadToolTip ID="rttInfo3" runat="server" TargetControlID="imgInfo3"
                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                <asp:Panel ID="pnrttInfo3" runat="server" Width="400px">
                                                    <div class="form">
                                                        <div style="padding-left: 5px">
                                                            <asp:Label ID="lblrttInfo3" runat="server" Text="<b>Family Name:</b> This is a Mandatory field.  Please input the Family Name (or Surname) of the patient.  Hyphenated surnames are permitted as are apostrophes (do not leave a space either side of hyphen or apostrophe eg Miller-Brown and D’Souza).  Spaces can be left between words (eg Van der Humm) but you cannot use a full-stop in the name." />
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </telerik:RadToolTip>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="GivenNameLabel" runat="server" AssociatedControlID="PatientGivenName" Text="Given Name *" />
                                    </td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:TextBox ID="PatientGivenName" runat="server" MaxLength="40" TabIndex="4" onkeyup="this.value = this.value.toUpperCase();" />
                                                <asp:CustomValidator ID="CustomValidatorGivenName" runat="server" OnServerValidate="ValidatePatientGivenName"
                                                    ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidatorGivenName" runat="server" ValidationGroup="PatientDataValidationGroup"
                                                    ControlToValidate="PatientGivenName" CssClass="failureNotification"
                                                    ErrorMessage="Please enter valid given name"
                                                    ValidationExpression="^[a-zA-Z_ '-]{1,40}$">*</asp:RegularExpressionValidator>
                                            </div>

                                        </div>
                                    </td>
                                    <td>
                                        <div style="float: left">
                                            &nbsp;
                                                <asp:Image ID="imgInfo2" runat="server" ImageUrl="~/Images/info.png" />
                                            <telerik:RadToolTip ID="rttInfo2" runat="server" TargetControlID="imgInfo2"
                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                <asp:Panel ID="pnrttInfo2" runat="server" Width="400px">
                                                    <div class="form">
                                                        <div style="padding-left: 5px">
                                                            <asp:Label ID="lblrttInfo2" runat="server" Text="<b>Given Name:</b> This is a Mandatory field. Please input the Given Name (or First Name) of the patient. Hyphenated given names are permitted as are apostrophes (do not leave a space either side of hyphen or apostrophe eg Mary-Jane and D’Angel). Spaces can be left between words where a patient identifies themselves with multiple names (eg Mary Ann).  If only the initial is known, please enter the initial (with no full stop). If the patient does not have a Given Name or it is unknown please enter ‘Unknown’. Middle names can be entered if known." />
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </telerik:RadToolTip>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="BirthDateLabel" runat="server" AssociatedControlID="PatientDOB" Text="DOB (dd/mm/yyyy) *" />
                                    </td>
                                    <td>
                                        <telerik:RadDatePicker ID="PatientDOB" MinDate="1900-01-01" runat="server" Calendar-CultureInfo="en-AU" TabIndex="5" Width="150px">
                                            <ClientEvents OnDateSelected="PatientBirthDateSelected" />
                                        </telerik:RadDatePicker>

                                    </td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:CustomValidator ID="CustomValidatorBirthdate" runat="server" OnServerValidate="ValidatePatientBirthdate" Display="Dynamic"
                                                    ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                                <asp:CheckBox ID="PatientDOBUnknown" runat="server" Text="DOB Not Known" OnClick="enableDisable(this.checked, 'PatientDOB');" TabIndex="6" />
                                                <asp:Label ID="AgeLessThan18Label" runat="server" CssClass="failureNotification" />
                                            </div>
                                            <div style="float: left">
                                                &nbsp;
                                                <asp:Image ID="imgInfo4" runat="server" ImageUrl="~/Images/info.png" />
                                                <telerik:RadToolTip ID="rttInfo4" runat="server" TargetControlID="imgInfo4"
                                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                    <asp:Panel ID="pnrttInfo4" runat="server" Width="400px">
                                                        <div class="form">
                                                            <div style="padding-left: 5px">
                                                                <asp:Label ID="lblrttInfo4" runat="server" Text="<b>DOB:</b> This is a Mandatory field. Please input the patient’s Date of Birth (DOB) in the format of day/month/year or use the calendar to the side to pick the date.  If DOB is unknown, please check the box 'DOB Not Known'" />
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </telerik:RadToolTip>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="GenderLabel" runat="server" AssociatedControlID="PatientGenderId" Text="Gender *" />
                                    </td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:DropDownList ID="PatientGenderId" runat="server" TabIndex="7" />
                                                <asp:CustomValidator ID="CustomValidatorPatientGender" runat="server" OnServerValidate="ValidatePatientGender" Display="Dynamic"
                                                    ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                            </div>
                                        </div>
                                    </td>
                                    <td>&nbsp;
                                        <asp:Image ID="imgInfo5" runat="server" ImageUrl="~/Images/info.png" />
                                        <telerik:RadToolTip ID="rttInfo5" runat="server" TargetControlID="imgInfo5"
                                            Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                            AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                            <asp:Panel ID="pnrttInfo5" runat="server" Width="400px">
                                                <div class="form">
                                                    <div style="padding-left: 5px">
                                                        <asp:Label ID="lblrttInfo5" runat="server" Text="<b>Gender:</b> This is a Mandatory field. Please select from 'Female', 'Male' or 'Intersex or Indeterminate'" />
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </telerik:RadToolTip>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <uc:SurgeonAndSite ID="SurgeonAndSite" TabIndex="8" ddlSiteWidthMarginleftWidth="-3px" ddlSurgeonMarginleftWidth="-3px" ErrorMessageEmptySurgeonString="Surgeon is a required field" ErrorMessageEmptySite="Site is a required field" EnableMandatoryFieldValidatorForSite="true" ValidationGroupForSite="PatientDataValidationGroup" EnableMandatoryFieldValidatorForSurgeon="true" runat="server" />
                                        <asp:CustomValidator ID="CustomValidatorSurgeon" runat="server" OnServerValidate="ValidateSurgeon" Display="Dynamic"
                                            ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                            ErrorMessage="The surgeon selected is inactive. Please change the selection">*</asp:CustomValidator>
                                    </td>
                                </tr>
                            </table>
                            <table border="0">
                                <colgroup>
                                    <col width="270px" />
                                </colgroup>
                                <tr>
                                    <td>
                                        <asp:Label ID="StreetAddressLabel" AssociatedControlID="PatientStreetAddress" runat="server" Text="Street Number and Name *" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="PatientStreetAddress" runat="server" MaxLength="100" Width="300" TabIndex="10" />
                                        <asp:CustomValidator ID="CustomValidatorStreetAddress" runat="server" OnServerValidate="ValidatePatientStreetAddress" Display="Dynamic"
                                            ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                            ErrorMessage="">*</asp:CustomValidator>&nbsp;&nbsp;&nbsp;
                                            <asp:CheckBox ID="PatientAddressNotKnown" runat="server" OnClick="enableDisable(this.checked, 'PatientStreetAddress');" TabIndex="11" />
                                        <asp:Label ID="StreeAddressUnknownLabel" AssociatedControlID="PatientAddressNotKnown" runat="server" Text="Address Not Known" />
                                    </td>
                                    <td>&nbsp;
                                        <asp:Image ID="imgInfo6" runat="server" ImageUrl="~/Images/info.png" />
                                        <telerik:RadToolTip ID="rttInfo6" runat="server" TargetControlID="imgInfo6"
                                            Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                            AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                            <asp:Panel ID="pnrttInfo6" runat="server" Width="400px">
                                                <div class="form">
                                                    <div style="padding-left: 5px">
                                                        <asp:Label ID="lblrttInfo6" runat="server" Text="<b>Street Number and Name:</b> This is a Mandatory field.  Please type in the patient’s street number and name followed by the acronym for the street type (eg 22 George St, 36 Arthur Rd).  RMB and PO Box addresses are acceptable.  Unit or building numbers are indicated by the use of a '/' (eg 1/56 Michael Ave).  If the patient’s address is unknown, please tick the box 'Address Not Known' and this field and subsequent 'Suburb', 'State' and 'Postcode' fields will not be required." />
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </telerik:RadToolTip>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="SuburbAddressLabel" AssociatedControlID="PatientSuburbAddress" runat="server" Text="Suburb *" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="PatientSuburbAddress" runat="server" MaxLength="50" Width="300" TabIndex="12" />
                                        <asp:CustomValidator ID="CustomValidatorSuburbAddress" runat="server" OnServerValidate="ValidateSuburbAddress" Display="Dynamic"
                                            ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                            ErrorMessage="">*</asp:CustomValidator>
                                    </td>
                                    <td>&nbsp;
                                        <asp:Image ID="imgInfo7" runat="server" ImageUrl="~/Images/info.png" />
                                        <telerik:RadToolTip ID="rttInfo7" runat="server" TargetControlID="imgInfo7"
                                            Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                            AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                            <asp:Panel ID="pnrttInfo7" runat="server" Width="400px">
                                                <div class="form">
                                                    <div style="padding-left: 5px">
                                                        <asp:Label ID="lblrttInfo7" runat="server" Text="<b>Suburb:</b> This is a Mandatory field unless 'Address Not Known' is ticked.  Please type the suburb from the patient’s address." />
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </telerik:RadToolTip>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="CountryLabel" Text="Country *"></asp:Label></td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:DropDownList ID="PatientCountryId" AutoPostBack="true" OnSelectedIndexChanged="CountrySelectionChanged" runat="server" TabIndex="13" />
                                                <asp:CustomValidator ID="CustomValidatorCountry" runat="server" OnServerValidate="ValidatePatientCountry" Display="Dynamic"
                                                    ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                            </div>
                                            <div style="float: left">
                                                &nbsp;
                                                <asp:Image ID="imgInfo8" runat="server" ImageUrl="~/Images/info.png" />
                                                <telerik:RadToolTip ID="rttInfo8" runat="server" TargetControlID="imgInfo8"
                                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                    <asp:Panel ID="pnrttInfo8" runat="server" Width="400px">
                                                        <div class="form">
                                                            <div style="padding-left: 5px">
                                                                <asp:Label ID="lblrttInfo8" runat="server" Text="<b>Country:</b> This is a Mandatory field that is populated depending on the site chosen.  We will only be tracking patients who currently reside in the country." />
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </telerik:RadToolTip>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr runat="server" id="StateAddressRow">
                                    <td>
                                        <asp:Label ID="StateAddressLabel" AssociatedControlID="PatientStateId" runat="server" Text="State *" />
                                    </td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:DropDownList ID="PatientStateId" runat="server" TabIndex="14" />
                                                <asp:CustomValidator ID="CustomValidatorAddressState" runat="server" OnServerValidate="ValidatePatientState" Display="Dynamic"
                                                    ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                            </div>
                                            <div style="float: left">
                                                &nbsp;
                                                <asp:Image ID="imgInfo10" runat="server" ImageUrl="~/Images/info.png" />
                                                <telerik:RadToolTip ID="rttInfo10" runat="server" TargetControlID="imgInfo10"
                                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                    <asp:Panel ID="pnrttInfo10" runat="server" Width="400px">
                                                        <div class="form">
                                                            <div style="padding-left: 5px">
                                                                <asp:Label ID="lblrttInfo10" runat="server" Text="<b>State:</b> This is a Mandatory field unless 'Address Not Known' is ticked.  Please select from dropdown menu or type in the postcode and it will automatically populate." />
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </telerik:RadToolTip>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="AddressPostCodeLabel" AssociatedControlID="PatientAddressPostcode" runat="server" Text="Postcode *" />
                                    </td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:TextBox ID="PatientAddressPostcode" runat="server" MaxLength="4" TabIndex="15" Width="165px" />
                                                <asp:CustomValidator ID="CustomValidatorPostCode" runat="server" OnServerValidate="ValidatePatientPostCode"
                                                    ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidatorPostCode" runat="server" ValidationGroup="PatientDataValidationGroup"
                                                    ControlToValidate="PatientAddressPostcode" CssClass="failureNotification"
                                                    ErrorMessage="Please enter valid Postcode (At least 4 Digits)"
                                                    ValidationExpression="^\d{4,4}$">*</asp:RegularExpressionValidator>
                                                <asp:CheckBox ID="PatientPostcodeNotKnown" runat="server" OnClick="enableDisable(this.checked, 'PatientAddressPostcode');" TabIndex="16" />
                                                <asp:Label ID="PostCodeAddressUnknownLabel" AssociatedControlID="PatientPostcodeNotKnown" runat="server" Text="No Postcode" />
                                            </div>
                                            <div style="float: left">
                                                &nbsp;
                                                <asp:Image ID="imgInfo11" runat="server" ImageUrl="~/Images/info.png" />
                                                <telerik:RadToolTip ID="rttInfo11" runat="server" TargetControlID="imgInfo11"
                                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                    <asp:Panel ID="pnrttInfo11" runat="server" Width="400px">
                                                        <div class="form">
                                                            <div style="padding-left: 5px">
                                                                <asp:Label ID="lblrttInfo11" runat="server" Text="<b>Postcode:</b> This is a Mandatory field unless 'Address Not Known' is ticked.  Please type the patient’s postcode.  The postcode will override the 'State' that is chosen if it is incorrect." />
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </telerik:RadToolTip>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <asp:Panel ID="DisplayForAustralia" runat="server">
                                <table border="0">
                                    <colgroup>
                                        <col width="270px" />
                                    </colgroup>

                                    <tr>
                                        <td>
                                            <asp:Label ID="MedicareNumberLabel" runat="server" AssociatedControlID="PatientMedicareNo" Text="Medicare Number *" />
                                        </td>
                                        <td>
                                            <div style="overflow: hidden;">
                                                <div style="float: left">
                                                    <asp:TextBox ID="PatientMedicareNo" runat="server" MaxLength="10" TabIndex="17" Width="140px" />
                                                    <asp:TextBox ID="PatientMedicareNoRef" runat="server" MaxLength="1" TabIndex="18" Width="16px" />

                                                    <asp:CustomValidator ID="CustomValidatorMedicareNumber" runat="server" OnServerValidate="ValidatePatientMedicareNumber"
                                                        ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification" ErrorMessage="">*</asp:CustomValidator>
                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidatorMedicareNo" runat="server" ControlToValidate="PatientMedicareNo" CssClass="failureNotification" ErrorMessage="Please enter valid Medicare Number (10 or 11 Digits)" ValidationExpression="^\d{10,11}$" ValidationGroup="PatientDataValidationGroup">*</asp:RegularExpressionValidator>
                                                    <asp:RegularExpressionValidator ID="RegularExpressionMedicareNumberRef" runat="server" ControlToValidate="PatientMedicareNoRef" CssClass="failureNotification" ErrorMessage="Please enter valid Medicare reference number - single digits)" ValidationExpression="^\d{1}$" ValidationGroup="PatientDataValidationGroup">*</asp:RegularExpressionValidator>
                                                </div>
                                                <div style="float: left; margin-left: -5px">
                                                    <asp:CheckBox ID="PatientMedicareNoUnknown" runat="server" OnClick="enableDisable(this.checked, 'PatientMedicareNo');" TabIndex="18" />
                                                    <asp:Label ID="MedicareNumberUnknownLabel" runat="server" AssociatedControlID="PatientMedicareNoUnknown" Text="No Medicare Number" />
                                                </div>
                                                <div style="float: left">
                                                    &nbsp;
                                                <asp:Image ID="imgInfo12" runat="server" ImageUrl="~/Images/info.png" />
                                                    <telerik:RadToolTip ID="rttInfo12" runat="server" TargetControlID="imgInfo12"
                                                        Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                        AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                        <asp:Panel ID="pnrttInfo12" runat="server" Width="400px">
                                                            <div class="form">
                                                                <div style="padding-left: 5px">
                                                                    <asp:Label ID="lblrttInfo12" runat="server" Text="<b>Medicare Number:</b> This is a Mandatory field unless 'No Medicare Number' is ticked.  It requires the input of the patient’s 10 digit number from their Medicare Card and then the reference number from the card that refers to them specifically in the box to the right." />
                                                                </div>
                                                            </div>
                                                        </asp:Panel>
                                                    </telerik:RadToolTip>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="PatientDVANumberLabel" runat="server" AssociatedControlID="PatientDVANumber" Text="DVA Number *" />
                                        </td>
                                        <td>
                                            <div style="overflow: hidden;">
                                                <div style="float: left">
                                                    <asp:TextBox ID="PatientDVANumber" runat="server" MaxLength="9" TabIndex="19" Width="165px" />
                                                    <asp:CustomValidator ID="CustomValidatorPatientDVANumber" runat="server" OnServerValidate="ValidatePatientDVANumber"
                                                        ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification" ErrorMessage="">*</asp:CustomValidator>
                                                </div>
                                                <div style="float: left; margin-left: 13px">
                                                    <asp:CheckBox ID="PatientDVANumberUnknown" runat="server" OnClick="enableDisable(this.checked, 'PatientDVANumber');" TabIndex="20" />
                                                    <asp:Label ID="PatientDVANumberUnknownLabel" runat="server" AssociatedControlID="PatientDVANumberUnknown" Text="No DVA Number" />
                                                </div>
                                                <div style="float: left">
                                                    &nbsp;
                                                <asp:Image ID="imgInfo13" runat="server" ImageUrl="~/Images/info.png" />
                                                    <telerik:RadToolTip ID="rttInfo13" runat="server" TargetControlID="imgInfo13"
                                                        Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                        AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                        <asp:Panel ID="pnrttInfo13" runat="server" Width="400px">
                                                            <div class="form">
                                                                <div style="padding-left: 5px">
                                                                    <asp:Label ID="lblrttInfo13" runat="server" Text="<b>DVA Number:</b> This is a Mandatory field unless 'No DVA Number' is ticked. It requires the input of the patient’s 9 digit DVA number if they have one." />
                                                                </div>
                                                            </div>
                                                        </asp:Panel>
                                                    </telerik:RadToolTip>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="PatientIHILabel" AssociatedControlID="PatientIHI" CssClass="disabledLabel" runat="server" Text="IHI No" />
                                        </td>
                                        <td>
                                            <div style="overflow: hidden;">
                                                <div style="float: left">
                                                    <asp:TextBox ID="PatientIHI" runat="server" MaxLength="16" Enabled="false" TabIndex="21" Width="135px" />
                                                </div>
                                                <div style="float: left; margin-left: 24px">
                                                    <asp:Button ID="GetIHIButton" runat="server" Text="Get IHI" Enabled="false" CausesValidation="false" OnClick="GetIHIClicked" OnClientClick="alert('This feature is not yet active');" Height="27" TabIndex="22" />
                                                </div>
                                                <div style="float: left">
                                                    <asp:Label ID="FeatureNotActiveLabel" runat="server" Visible="false" ForeColor="Red"><i>This feature is not active.</i> </asp:Label>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <asp:Panel ID="DisplayForNewZealLand" runat="server">
                                <table border="0">
                                    <colgroup>
                                        <col width="270px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="PatientNHINumberLabel" runat="server" AssociatedControlID="PatientNHINumber" Text="National Health Index(NHI) Number *" />
                                        </td>
                                        <td valign="middle">
                                            <div style="overflow: hidden;">
                                                <div style="float: left">
                                                    <asp:TextBox ID="PatientNHINumber" runat="server" MaxLength="10" TabIndex="23" />
                                                </div>
                                                <div style="float: left">
                                                    <asp:CustomValidator ID="CustomValidatorPatientNHINumber" runat="server" OnServerValidate="ValidatePatientNHINumber"
                                                        ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification" ErrorMessage="">*</asp:CustomValidator>
                                                </div>
                                                <div style="float: left; padding-left: 17px">
                                                    <asp:CheckBox ID="PatientNHIUnknown" runat="server" OnClick="enableDisable(this.checked, 'PatientNHINumber');" TabIndex="24" />
                                                </div>
                                                <div style="float: left; padding-left: 4px">
                                                    <asp:Label ID="PatientNHINumberUnknownLabel" runat="server" AssociatedControlID="PatientNHIUnknown" Text="No NHI Number" />
                                                </div>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>

                                </table>
                            </asp:Panel>
                            <table border="0">
                                <colgroup>
                                    <col width="270px" />
                                </colgroup>
                                <tr runat="server" id="AboriginalRow">
                                    <td>
                                        <asp:Label ID="PatientAboriginalLabel" AssociatedControlID="PatientAboriginalStatusId" runat="server" Text="Indigenous Status *" /></td>
                                    <td>
                                        <div style="overflow: hidden">
                                            <div style="float: left;">
                                                <asp:DropDownList ID="PatientAboriginalStatusId" runat="server" TabIndex="25" />
                                            </div>
                                            <div style="float: left; margin-top: 8px; padding-left: 5px;">
                                                <asp:CustomValidator ID="CustomValidatorPatientAboriginal" runat="server" OnServerValidate="ValidatePatientAboriginalStatus"
                                                    ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification" ErrorMessage="">*</asp:CustomValidator>
                                            </div>
                                            <div style="float: left">
                                                &nbsp;
                                                <asp:Image ID="imgInfo14" runat="server" ImageUrl="~/Images/info.png" />
                                                <telerik:RadToolTip ID="rttInfo14" runat="server" TargetControlID="imgInfo14"
                                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                    <asp:Panel ID="pnrttInfo14" runat="server" Width="400px">
                                                        <div class="form">
                                                            <div style="padding-left: 5px">
                                                                <asp:Label ID="lblrttInfo14" runat="server" Text="<b>Indigenous Status:</b> This is a Mandatory field and requires selection from the drop-down of one of the five options." />
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </telerik:RadToolTip>
                                            </div>
                                        </div>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr runat="server" id="PatientIndigenousRow">
                                    <td>
                                        <asp:Label ID="PatientIndigenousLabel" AssociatedControlID="PatientIndigenousStatusId" runat="server" Text="Indigenous Status *" /></td>
                                    <td>
                                        <div style="overflow: hidden">
                                            <div style="float: left;">
                                                <asp:DropDownList ID="PatientIndigenousStatusId" runat="server" TabIndex="25" />
                                            </div>
                                            <div style="float: left; margin-top: 8px; padding-left: 5px;">
                                                <%--<asp:CustomValidator ID="cvddlPatient_IndigenousStatusId" runat="server" OnServerValidate="cvddlPatient_IndigenousStatusId_ServerValidate"
                                                    ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification" ErrorMessage="">*</asp:CustomValidator>--%>
                                            </div>
                                            <div style="float: left">
                                                &nbsp;
                                                <asp:Image ID="imgInfo15" runat="server" ImageUrl="~/Images/info.png" />
                                                <telerik:RadToolTip ID="rttInfo15" runat="server" TargetControlID="imgInfo15"
                                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                    <asp:Panel ID="pnrttInfo15" runat="server" Width="400px">
                                                        <div class="form">
                                                            <div style="padding-left: 5px">
                                                                <asp:Label ID="lblrttInfo15" runat="server" Text="<b>Indigenous Status:</b> This is a Mandatory field and requires selection from the drop-down of one of the six options." />
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </telerik:RadToolTip>
                                            </div>
                                        </div>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="PatientHomePhoneLabel" AssociatedControlID="PatientHomePhone" runat="server" Text="Home Phone Number (add area code) *" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="PatientHomePhone" runat="server" MaxLength="15" TabIndex="26" Minlength="9" Width="165px" />
                                        <asp:CustomValidator ID="CustomValidatorPatientHomePhone" runat="server" OnServerValidate="ValidatePatientHomePhone"
                                            ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                            ErrorMessage="">*</asp:CustomValidator>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidatorHomePhone" runat="server" ValidationGroup="PatientDataValidationGroup"
                                            ControlToValidate="PatientHomePhone" CssClass="failureNotification"
                                            ErrorMessage="Please enter valid home phone number (At least 9 digits without spaces)"
                                            ValidationExpression="^(\+?)([0-9]{9,15})">*</asp:RegularExpressionValidator>
                                        <asp:CheckBox ID="PatientHomePhoneUnknown" runat="server" OnClick="enableDisable(this.checked, 'PatientHomePhone');" TabIndex="27" />
                                        <asp:Label ID="PatientHomePhoneUnknownLabel" AssociatedControlID="PatientHomePhoneUnknown" runat="server" Text="No Phone Number" />
                                    </td>
                                    <td>&nbsp;
                                                <asp:Image ID="imgInfo16" runat="server" ImageUrl="~/Images/info.png" />
                                        <telerik:RadToolTip ID="rttInfo16" runat="server" TargetControlID="imgInfo16"
                                            Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                            AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                            <asp:Panel ID="pnrttInfo16" runat="server" Width="400px">
                                                <div class="form">
                                                    <div style="padding-left: 5px">
                                                        <asp:Label ID="lblrttInfo16" runat="server" Text="<b>Home Phone Number:</b> This is a Mandatory field unless 'No Phone Number' is ticked.  It requires the input of the patient’s home number including area code without any spaces." />
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </telerik:RadToolTip>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="PatientMobileLabel" AssociatedControlID="PatientMobile" runat="server" Text="Mobile Phone Number (add area code) *" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="PatientMobile" runat="server" MaxLength="15" TabIndex="28" Minlength="9" Width="165px" />
                                        <asp:CustomValidator ID="CustomValidatorPatientMobile" runat="server" OnServerValidate="ValidatePatientMobile"
                                            ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                            ErrorMessage="">*</asp:CustomValidator>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidatorPatientMobile" runat="server" ValidationGroup="PatientDataValidationGroup"
                                            ControlToValidate="PatientMobile" CssClass="failureNotification"
                                            ErrorMessage="Please enter valid mobile phone (At least 9 digits without spaces)"
                                            ValidationExpression="^(\+?)([0-9]{9,15})">*</asp:RegularExpressionValidator>
                                        <asp:CheckBox ID="PatientMobileUnknown" runat="server" OnClick="enableDisable(this.checked, 'PatientMobile');" TabIndex="29" />
                                        <asp:Label ID="PatientMobileUnknownLabel" AssociatedControlID="PatientMobileUnknown" runat="server" Text="No Mobile Number" />
                                    </td>
                                    <td>&nbsp;
                                                <asp:Image ID="imgInfo17" runat="server" ImageUrl="~/Images/info.png" />
                                        <telerik:RadToolTip ID="rttInfo17" runat="server" TargetControlID="imgInfo17"
                                            Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                            AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                            <asp:Panel ID="pnrttInfo17" runat="server" Width="400px">
                                                <div class="form">
                                                    <div style="padding-left: 5px">
                                                        <asp:Label ID="lblrttInfo17" runat="server" Text="<b>Mobile Phone Number:</b> This is a Mandatory field unless 'No Mobile Number' is ticked. It requires the input of the patient’s mobile number in full without any spaces." />
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </telerik:RadToolTip>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="PatientHealthStatusLabel" AssociatedControlID="HealthStatusId" runat="server" Text="Vital Status *" />
                                    </td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:DropDownList ID="HealthStatusId" runat="server" TabIndex="30" />
                                                <asp:CustomValidator ID="CustomValidatorHealthStatus" runat="server" OnServerValidate="HealthStatusValidation"
                                                    ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                            </div>
                                            <div style="float: left">
                                                &nbsp;
                                                <asp:Image ID="imgInfo18" runat="server" ImageUrl="~/Images/info.png" />
                                                <telerik:RadToolTip ID="rttInfo18" runat="server" TargetControlID="imgInfo18"
                                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                    <asp:Panel ID="pnrttInfo18" runat="server" Width="400px">
                                                        <div class="form">
                                                            <div style="padding-left: 5px">
                                                                <asp:Label ID="lblrttInfo18" runat="server" Text="<b>Vital Status:</b> This is defaulted to alive, so should only be changed if the patient is deceased." />
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </telerik:RadToolTip>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <asp:Panel ID="DeathControlsPanel" runat="server" Enabled="true">
                                <table border="0">
                                    <colgroup>
                                        <col width="270px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="PatientDateOfDeathLabel" AssociatedControlID="PatientDateOfDeath" runat="server" Text="Date of Death *" />
                                        </td>
                                        <td>
                                            <div style="overflow: hidden;">
                                                <div style="float: left">
                                                    <telerik:RadDatePicker ID="PatientDateOfDeath" runat="server" Calendar-CultureInfo="en-AU" MinDate="1900-01-01" TabIndex="31" />
                                                </div>
                                                <div style="float: left">
                                                    <asp:CustomValidator ID="CustomValidatorPatientDateOfDeath" runat="server" OnServerValidate="ValidatePatientDateOfDeath"
                                                        ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                                        ErrorMessage="">*</asp:CustomValidator>
                                                </div>
                                                <div style="float: left; margin-left: -1px">
                                                    <asp:CheckBox ID="DateOfDeathKnown" runat="server" Text="Date of Death Not Known" TabIndex="32" />
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="PatientCauseOfDeathLabel" runat="server" Text="Cause Of Death" />
                                        </td>
                                        <td colspan="3">
                                            <div>
                                                <asp:TextBox runat="server" ID="CauseOfDeath" Rows="3" TextMode="MultiLine" Width="100%" TabIndex="33"></asp:TextBox>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="PatientCauseOfDeathProcedureLabel" AssociatedControlID="DeathRelatedToPrimaryProcedure" runat="server" Text="Death Related to Bariatric Procedure? *" />
                                        </td>
                                        <td>
                                            <asp:DropDownList runat="server" ID="DeathRelatedToPrimaryProcedure" RepeatDirection="Horizontal" TabIndex="34"></asp:DropDownList>
                                            <asp:CustomValidator ID="DeathRelatedValidator" runat="server" OnServerValidate="ValidateRelatedDeath"
                                                        ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification" ErrorMessage="">*</asp:CustomValidator>

                                            <asp:Image ID="RelatedDeathInfo" runat="server" ImageUrl="~/Images/info.png" />
                                            <telerik:RadToolTip ID="RelatedDeathTip" runat="server" TargetControlID="RelatedDeathInfo"
                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip" AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                            <asp:Panel ID="Panel1" runat="server" Width="400px">
                                                <div class="form">
                                                    <div style="padding-left: 5px">
                                                        <asp:Label ID="Label1" runat="server" Text="<b>Death Related to Bariatric Procedure:</b> If known, please indicate whether the death is unrelated, possibly related, probably related, definitely related to the procedure – if this is not known, please select 'Not yet determined'" />
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </telerik:RadToolTip>

                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>

                            <asp:Panel ID="InfoPanel" runat="server">
                                <div class="sectionHeader">
                                    FOR ADMIN AND DATA ENTRY - Information only
                                </div>

                                <div style="margin-top: 10px; margin-bottom: 5px; margin-left: 5px;">
                                </div>
                                <div class="sectionContent2">
                                    <table border="0" width="100%">
                                        <colgroup>
                                            <col width="270px" />
                                        </colgroup>
                                        <tr>
                                            <td>
                                                <asp:Label ID="DateExplanatoryStatementSentLabel" AssociatedControlID="DateExplanatoryStatementSent" runat="server" Text="Date explanatory statement sent" />
                                            </td>
                                            <td>
                                                <telerik:RadDatePicker ID="DateExplanatoryStatementSent" runat="server" Calendar-CultureInfo="en-AU" MinDate="1900-01-01" Enabled="false" TabIndex="35" DateInput-DateFormat="dd/MM/yyyy"/>
                                                <asp:CustomValidator ID="CustomValidatorESSDate" runat="server" OnServerValidate="ESSDateValidation"
                                                    ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="DateExplanatoryStatementReturned" AutoPostBack="true" OnCheckedChanged="ExplanatoryStatementReturnedUndeliverableChecked" runat="server" Enabled="true" TabIndex="36" />
                                                <asp:Label ID="ExplanatoryStatementReturnedUndeliverableLabel" AssociatedControlID="DateExplanatoryStatementReturned" runat="server" Text="Explanatory statement returned undeliverable" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <div class="line-separator"></div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="PatientOptOffStatusLabel" AssociatedControlID="OptOffStatusId" runat="server" Text="Opt off status" />
                                            </td>
                                            <td colspan="2">
                                                <asp:DropDownList ID="OptOffStatusId" runat="server" TabIndex="37" />
                                                <asp:CustomValidator ID="CustomValidatorOptOffStatus" runat="server" OnServerValidate="OptOffStatusValidation"
                                                    ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                                <asp:Label ID="PatientOptOffStatusWarningLabel" CssClass="failureNotification" runat="server" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:Panel ID="PatientOptOffPanel" runat="server">
                                        <table border="0" width="100%">
                                            <colgroup>
                                                <col width="270px" />
                                            </colgroup>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="PatientOptOutDateLabel" AssociatedControlID="OptOffDate" runat="server" Text="Date opt off" />
                                                </td>
                                                <td width="200px" colspan="2">
                                                    <telerik:RadDatePicker ID="OptOffDate" runat="server" Calendar-CultureInfo="en-AU" MinDate="2012-01-01" Enabled="true" TabIndex="38" />
                                                    <asp:CustomValidator ID="CustomValidatorPatientOptOffDate" runat="server" CssClass="failureNotification"
                                                        ValidationGroup="PatientDataValidationGroup" OnServerValidate="ValidatePatientOptOffDate"
                                                        ErrorMessage="Opt-off date must be '>1/01/2012' and 'less than Current date'; cannot be a future date.">*</asp:CustomValidator>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </div>
                            </asp:Panel>
                        </asp:Panel>
                    </div>
                </div>
            </div>

            <table width="100%">
                <colgroup>
                </colgroup>
                <tr>
                    <td class="auto-style1">
                        <asp:Button ID="BackButton" runat="server" Text="Cancel" CausesValidation="false" OnClick="BackButtonClicked" TabIndex="40" />
                        <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButtonClicked" OnClientClick="ClientSaveChecks();return false;" ValidationGroup="PatientDataValidationGroup" TabIndex="41" />
                        <asp:Label ID="FormSavedMessageLabel" runat="server" Class="successNotification"></asp:Label>
                    </td>
                    <td style="float: right;">
                        <asp:Button ID="DeletePatientButton" runat="server" Text="Delete Patient" OnClick="DeletePatientClicked" OnClientClick="return ShowConfirm_Delete(this);" ValidationGroup="PatientDataValidationGroup" TabIndex="41" />
                    </td>
                </tr>
            </table>
            <uc3:AuditForm ID="auditForm" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
