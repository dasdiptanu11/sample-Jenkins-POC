<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="FollowUp.aspx.cs" Inherits="App.UI.Web.Views.Forms.FollowUp" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/PatientRibbon.ascx" TagPrefix="uc" TagName="PatientRibbon" %>
<%@ Register Src="~/Views/Shared/SurgeonAndSite.ascx" TagPrefix="uc" TagName="SurgeonAndSite" %>
<%@ Register Src="~/Views/Shared/AuditForm.ascx" TagName="AuditForm" TagPrefix="uc3" %>
<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        body {
            margin: 0;
            padding: 0;
            font-family: Arial;
        }

        .modalPopup {
            position: fixed;
            z-index: 2901;
            height: 100%;
            margin: 0;
            padding: 0;
            width: 100%;
            top: 0;
            left: 0;
            background-color: grey;
            opacity: 0.8;
        }

        .center {
            z-index: 2905;
            margin: 300px auto;
            padding: 3px;
            width: 180px;
            background-color: White;
            border-radius: 10px;
            opacity: 1;
        }

            .center img {
                height: 170px;
                width: 170px;
            }
    </style>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="../../Scripts/jquery-1.8.2.min.js"></script>
    <telerik:RadCodeBlock ID="rcb" runat="server">

        <script type="text/javascript">
            $(function () {
                var DTreatment = $('#<%=FollowUpDiabetesTreatment.ClientID %>').find('input:checkbox');
                DTreatment.click(function () {
                    var selectedIndex = DTreatment.index($(this));

                    var items = $('#<% = FollowUpDiabetesTreatment.ClientID %> input:checkbox');
                    for (i = 0; i < items.length; i++) {
                        if (i == selectedIndex && items[selectedIndex].checked == true) {
                            items[i].checked = true;
                        }
                        else {
                            items[i].checked = false;
                        }
                    }
                });
            });

            //On UpdatePanel Refresh
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            if (prm != null) {
                prm.add_endRequest(function (sender, e) {
                    if (sender._postBackSettings.panelsToUpdate != null) {
                        //Diabetes Treatment
                        var DTreatment = $('#<%=FollowUpDiabetesTreatment.ClientID %>').find('input:checkbox');
                        DTreatment.click(function () {
                            var selectedIndex = DTreatment.index($(this));

                            var items = $('#<% = FollowUpDiabetesTreatment.ClientID %> input:checkbox');
                            for (i = 0; i < items.length; i++) {
                                if (i == selectedIndex && items[selectedIndex].checked == true) {
                                    items[i].checked = true;
                                }
                                else {
                                    items[i].checked = false;
                                }
                            }
                        });

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

            function ShowReason_Sentinel() {
                var seEventChecked = false;
                var chkBox = $get("<%=FollowUpSentinelEvent.ClientID %>");
                          var options = chkBox.getElementsByTagName('input');
                          var listOfSpans = chkBox.getElementsByTagName('span');
                          for (var i = 0; i < options.length; i++) {
                              if (options[i].checked) {
                                  seEventChecked = true;
                                  break;
                              }
                          }

                          ShowOrHideReason(seEventChecked)
                      }

                      function ShowReason_Reoperation() {
                          var seEventChecked = false;
                          if ($get("<%=FollowUpReOperation.ClientID %>").value == '1') {
                    seEventChecked = true;
                }

                ShowOrHideReason(seEventChecked)
            }

            function ShowOrHideReason(Show) {
                if (Show)
                { document.getElementById('<%=FollowupReasonPanel.ClientID%>').style.display = 'block'; }
                else
                {
                    UncheckAll();
                    document.getElementById('<%=FollowupReasonPanel.ClientID%>').style.display = 'none';
                    document.getElementById('<%=FurtherInformationPanel.ClientID%>').style.display = 'none';
                    $get("<%=FurtherInfoPort.ClientID %>").value = '';
                    $get("<%=FurtherInfoSlip.ClientID %>").value = '';
                    $get("<%=FollowUpOther.ClientID %>").value = '';
                }
            }

            function CalculateBMI(height) {
                if (document.getElementById('<%=FollowUpPatientWeight.ClientID%>') != null) {
                    var wgt = document.getElementById('<%=FollowUpPatientWeight.ClientID%>').value;
                    if (wgt != '') {
                        document.getElementById('<%=FollowupPatientWeightUnknown.ClientID%>').disabled = true;
                        if (Number(wgt) > 200) {
                            document.getElementById('<%=FollowUpPatientWeightWarning.ClientID%>').innerHTML = 'A weight of over 200kg  has been entered. Please check';
                        }
                        else {
                            document.getElementById('<%=FollowUpPatientWeightWarning.ClientID%>').innerHTML = '';
                        }
                    }
                    else {
                        document.getElementById('<%=FollowupPatientWeightUnknown.ClientID%>').disabled = false;
                    }

                    var ht = height;
                    if (ht != '' && wgt != '' && ht != 0) {
                        var bmi = (Number(wgt) / (Number(parseFloat(height)) * Number(parseFloat(height)))).toString();
                        //bmi = bmi.toString();
                        if (bmi.indexOf('.') != -1) {
                            bmi = bmi.split('.')[0] + '.' + bmi.split('.')[1].substr(0, 2);
                        }
                        document.getElementById('<%=FollowUpBMI.ClientID%>').value = bmi;

                        if (Number(bmi) > 99.9) {
                            document.getElementById('<%=FollowUpBMIWarning.ClientID%>').innerHTML = 'Patient BMI > 99.9. Please check';
                        }
                        else {
                            document.getElementById('<%=FollowUpBMIWarning.ClientID%>').innerHTML = '';
                        }
                    }
                }
            }

            window.onbeforeunload = null;
            function formModified() {
                document.getElementById('modifiedStatus').value = 'T';
            }

            function formUnModified() {
                window.onbeforeunload = null;
            }

            function confirmExit() {
                if (document.getElementById('modifiedStatus').value == 'T') {
                    return "Warning :  Any unsaved data will be lost. Do you want to continue?";
                }
                else {
                    return false;
                }
            }

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

            function enableDisableCheckBox(control, controlId) {
                if (controlId == 'FollowUpPatientWeight') {
                    document.getElementById("<%=FollowUpPatientWeight.ClientID%>").value = '';
                    if (control.value != '') {
                        document.getElementById("<%= FollowUpSelfReportedWeight.ClientID%>").disabled = true;
                        document.getElementById("<%= FollowupPatientWeightUnknown.ClientID%>").disabled = true;
                    }
                    else {
                        document.getElementById("<%= FollowUpSelfReportedWeight.ClientID%>").disabled = false;
                        document.getElementById("<%=FollowupPatientWeightUnknown.ClientID%>").disabled = false;
                    }
                }
            }

            function enableDisable(checked, controlId) {
                if (controlId == 'FollowUpPatientWeight') {
                    document.getElementById("<%=FollowUpPatientWeight.ClientID%>").value = '';
                    document.getElementById("<%= FollowUpSelfReportedWeight.ClientID%>").checked = false;
                    if (checked.toString().toLowerCase() == "true") {
                        document.getElementById("<%=FollowUpPatientWeight.ClientID%>").disabled = true;
                        document.getElementById("<%=FollowUpBMI.ClientID%>").value = '';
                        ValidatorEnable(document.getElementById('<%=CustomValidatorFollowUpPatientWeight.ClientID%>'), false);
                        document.getElementById("<%= FollowUpSelfReportedWeight.ClientID%>").disabled = true;
                    }
                    else {
                        document.getElementById("<%=FollowUpPatientWeight.ClientID%>").disabled = false;
                        ValidatorEnable(document.getElementById('<%=CustomValidatorFollowUpPatientWeight.ClientID%>'), true);
                        document.getElementById("<%= FollowUpSelfReportedWeight.ClientID%>").disabled = false;
                    }
                }

                if (controlId == 'FollowUpDateOfDeath') {
                    var dpDateofDeath = $find("<%=FollowUpDateOfDeath.ClientID %>");

                    if (checked == true) {
                        dpDateofDeath.set_selectedDate(null);
                        dpDateofDeath.set_enabled(false);
                        ValidatorEnable(document.getElementById('<%=CustomValidatorDateofDeath.ClientID%>'), false);
                    }
                    else {
                        dpDateofDeath.set_enabled(true);
                        ValidatorEnable(document.getElementById('<%=CustomValidatorDateofDeath.ClientID%>'), true);
                    }
                }
            }

            function ReasonCheckBoxHandler() {
                var CheckBox = $get("<%=FollowUpReason.ClientID %>");
                var hidePanel = [$get("<%=FurtherInformationSlipPanel.ClientID %>"), $get("<%=PortPanel.ClientID %>"), $get("<%=OtherReasonPanel.ClientID %>"), $get("<%=BowelObstructionOperative.ClientID %>")];
                var fieldToReset = [$get("<%=FurtherInfoSlip.ClientID %>"), $get("<%=FurtherInfoPort.ClientID %>"), $get("<%=FollowUpOther.ClientID %>"), $get("<%=BowelObstructionOptions.ClientID %>")];
                var displayPanel = [];

                var optionchecked = false;
                var options = CheckBox.getElementsByTagName('input');

                for (var i = 0; i < options.length; i++) {
                    if (options[i].checked) {
                        switch (options[i].value) {
                            case "1": //Further Information
                                optionchecked = true;

                                //Add to the display list
                                displayPanel.push($get("<%=FurtherInformationSlipPanel.ClientID %>"));
                                //Remove it from the list to hide
                                hidePanel.splice(hidePanel.indexOf($get("<%=FurtherInformationSlipPanel.ClientID %>")), 1);
                                //remove the field to reset the value
                                fieldToReset.splice(fieldToReset.indexOf($get("<%=FurtherInfoSlip.ClientID %>")), 1);

                                break;
                            case "8": //Port
                                optionchecked = true;

                                displayPanel.push($get("<%=PortPanel.ClientID %>"));
                                hidePanel.splice(hidePanel.indexOf($get("<%=PortPanel.ClientID %>")), 1);
                                fieldToReset.splice(fieldToReset.indexOf($get("<%=FurtherInfoPort.ClientID %>")), 1);

                                break;
                            case "27":  //Other
                                optionchecked = true;

                                displayPanel.push($get("<%=OtherReasonPanel.ClientID %>"));
                                hidePanel.splice(hidePanel.indexOf($get("<%=OtherReasonPanel.ClientID %>")), 1);
                                fieldToReset.splice(fieldToReset.indexOf($get("<%=FollowUpOther.ClientID %>")), 1);

                                break;
                            case "44": //Bowel Obstruction - operative
                                optionchecked = true;

                                displayPanel.push($get("<%=BowelObstructionOperative.ClientID %>"));
                                hidePanel.splice(hidePanel.indexOf($get("<%=BowelObstructionOperative.ClientID %>")), 1);
                                fieldToReset.splice(fieldToReset.indexOf($get("<%=BowelObstructionOptions.ClientID %>")), 1);
                                break;
                        }
                    }
                }

                displayPanel.forEach(function (x) { x.style.display = "block"; });
                hidePanel.forEach(function (x) { x.style.display = "none"; });
                fieldToReset.forEach(function (x) { x.value = ''; });

                if (optionchecked) {
                    $get("<%=FurtherInformationPanel.ClientID %>").style.display = 'block';
                } else {
                    $get("<%=FurtherInformationPanel.ClientID %>").style.display = 'none';
                }
            }

            function UncheckAll() {
                var chkBox = $get("<%=FollowUpReason.ClientID %>");
                var options = chkBox.getElementsByTagName('input');
                var listOfSpans = chkBox.getElementsByTagName('span');
                for (var i = 0; i < options.length; i++) {
                    if (options[i].checked) {
                        options[i].checked = false;
                    }
                }
            }
        </script>
    </telerik:RadCodeBlock>

    <uc:ContentHeader ID="Header" runat="server" />
    <%--Title="30 Day/Annual Follow-Up Form"--%>
    <uc:PatientRibbon runat="server" ID="PatientRibbon" />
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
        <ProgressTemplate>
            <div class="modalPopup">
                <div class="center">
                    <img alt="" src="../../Images/Loader.gif" />
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="form">
                <telerik:RadGrid ID="FollowUpGrid" runat="server"
                    OnNeedDataSource="FollowUpGrid_NeedDataSource" GridLines="None"
                    AllowFilteringByColumn="false" AllowPaging="True" AllowSorting="True"
                    OnItemCommand="FollowUpGrid_ItemCommand"
                    AutoGenerateColumns="False" Width="100%"
                    CellSpacing="0" PageSize="10">

                    <ClientSettings EnablePostBackOnRowClick="false">
                        <Selecting AllowRowSelect="false" UseClientSelectColumnOnly="true" />
                    </ClientSettings>

                    <MasterTableView DataKeyNames="FollowUpID" RowIndicatorColumn-ShowFilterIcon="false">
                        <PagerStyle AlwaysVisible="true" />
                        <Columns>
                            <telerik:GridTemplateColumn UniqueName="FollowUpID" HeaderText="Follow Up ID" DataField="FollowUpID" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                <ItemTemplate>
                                    <asp:LinkButton ID="ManageLink" CausesValidation="false" runat="server" CommandName="Select" Text='<%# Eval("FollowUpID") %>'></asp:LinkButton>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="URNNo" HeaderText="UR No" UniqueName="URNNo" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                            </telerik:GridBoundColumn>
                            <telerik:GridDateTimeColumn DataField="OperationDate" EnableTimeIndependentFiltering="true" AllowFiltering="false" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Operation Date" UniqueName="OpDate" HeaderStyle-Width="150px">
                            </telerik:GridDateTimeColumn>
                            <telerik:GridBoundColumn DataField="OperationStatus" HeaderText="Operation Status" UniqueName="OpStat" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="OperationType" HeaderText="Operation Type" UniqueName="OpType" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="FollowUpPeriod" HeaderText="Follow Up Period" UniqueName="FUPeriod" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                            </telerik:GridBoundColumn>
                            <telerik:GridDateTimeColumn DataField="FollowUpDate" EnableTimeIndependentFiltering="true" AllowFiltering="false" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Follow Up Date" UniqueName="FUDate" HeaderStyle-Width="150px">
                            </telerik:GridDateTimeColumn>
                            <telerik:GridBoundColumn DataField="FollowUpStatusLabel" AllowFiltering="false" HeaderText="Status" UniqueName="FUStatusLabel" HeaderStyle-Width="150px" />
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
                <br />

                <asp:Label ID="NotificationMessage" runat="server" Class="successNotification"></asp:Label>
                <input type="hidden" id="modifiedStatus" value="F" />
                <asp:ValidationSummary ID="FollowUpValidationSummary" runat="server" ValidationGroup="FollowUpDataValidationGroup"
                    CssClass="failureNotification" HeaderText="" DisplayMode="List" />
                <br />
                <div class="sectionPanel1">
                    <asp:Panel runat="server" ID="FollowUpFormPanel">
                        <asp:Panel runat="server" Enabled="false" ID="ContactInformationPanel">
                            <div class="sectionHeader"><b>Contact Details</b> </div>
                            <br />
                            <div class="ContactDetails">
                                <table border="0">
                                    <colgroup>
                                        <col width="250px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="FollowUpAddressLabel" AssociatedControlID="Address" runat="server" Text="Address" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="Address" runat="server" Width="200"></asp:TextBox>
                                        </td>

                                        <td style="width: 55px"></td>

                                        <td>
                                            <asp:Label ID="FollowUpHomePhoneLabel" AssociatedControlID="HomePhoneNumber" runat="server" Text="Home Phone No" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="HomePhoneNumber" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <asp:Label ID="FollowupCountryLabel" runat="server" Text="Country" /></td>
                                        <td>
                                            <asp:DropDownList ID="CountryId" runat="server" CssClass="disabledDropDownList" />
                                        </td>

                                        <td></td>

                                        <td>
                                            <asp:Label ID="FollowUpMobileLabel" runat="server" AssociatedControlID="MobileNumber" Text="Mobile No" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="MobileNumber" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <asp:Label ID="FollowupSuburbAddressLabel" AssociatedControlID="SuburbAddress" runat="server" Text="Suburb" /></td>
                                        <td colspan="4">
                                            <asp:TextBox ID="SuburbAddress" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                                <asp:Panel runat="server" ID="AustraliaPanel">
                                    <table border="0">
                                        <colgroup>
                                            <col width="250px" />
                                        </colgroup>
                                        <tr>
                                            <td>
                                                <asp:Label ID="FollowUpStateLabel" AssociatedControlID="StateId" runat="server" Text="State" />
                                            </td>
                                            <td colspan="4">
                                                <asp:DropDownList ID="StateId" runat="server" CssClass="disabledDropDownList">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>
                                                <asp:Label ID="FollowupPostcodeLabel" AssociatedControlID="PostCode" runat="server" Text="Postcode" /></td>
                                            <td>
                                                <asp:TextBox ID="PostCode" runat="server" Width="80"></asp:TextBox>
                                            </td>
                                            <td colspan="3"></td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </div>
                            <br />
                            <div class="sectionHeader"><b>Surgeon and Institution</b> </div>
                            <br />
                            <div class="SurgeonAndInstitution">
                                <table border="0">
                                    <colgroup>
                                        <col width="250px" />
                                    </colgroup>

                                    <tr>
                                        <td>
                                            <asp:Label ID="FollowupOperationIdLabel" AssociatedControlID="OperationId" runat="server" Text="Operation ID" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="OperationId" runat="server" Width="50px"></asp:TextBox>
                                        </td>

                                        <td style="width: 155px"></td>

                                        <td>
                                            <asp:Label ID="FollowUpOpeationDateLabel" AssociatedControlID="OperationDate" runat="server" Text="Operation Date" />
                                        </td>
                                        <td>
                                            <telerik:RadDatePicker ID="OperationDate" MinDate="1900-01-01" runat="server" Calendar-CultureInfo="en-AU" CssClass="disabledDropDownList" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <asp:Label ID="FollowupHospitalMRNumberLabel" AssociatedControlID="HospitalMRNumber" runat="server" Text="UR No" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="HospitalMRNumber" runat="server"></asp:TextBox>
                                        </td>

                                        <td style="width: 155px"></td>

                                        <td>
                                            <asp:Label ID="FollowupOperationTypeLabel" AssociatedControlID="OperationType" runat="server" Text="Operation Type" />
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="OperationType" runat="server" Width="70%" CssClass="disabledDropDownList"></asp:DropDownList></td>

                                    </tr>

                                    <tr>
                                        <td colspan="3">
                                            <uc:SurgeonAndSite ID="SurgeonAndSite" ddlSurgeonWidth="204px" ddlSiteWidth="204px" ddlSiteBackgroundColor="#EBEBE4" ErrorMessageEmptySurgeonString="Surgeon is a required field" ErrorMessageEmptySite="Site is a required field" ddlSurgeonBackgroundColor="#EBEBE4" ddlSiteWidthMarginleftWidth="-10px" ddlSurgeonMarginleftWidth="-10px" labelSiteWidthMarginleftWidth="-3px" labelSurgeonMarginleftWidth="-3px" runat="server" />
                                        </td>


                                        <td>
                                            <asp:Label ID="DiabetesStatusLabel" AssociatedControlID="DiabetesStatus" runat="server" Text="Diabetes Status" />
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="DiabetesStatus" runat="server" Width="70%" CssClass="disabledDropDownList"></asp:DropDownList>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td>
                                            <asp:Label ID="DiabetesTreatmentLabel" AssociatedControlID="DiabetesTreatment" runat="server" Text="Diabetes Treatment" />
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="DiabetesTreatment" runat="server" Width="70%" CssClass="disabledDropDownList"></asp:DropDownList>
                                        </td>


                                    </tr>
                                </table>
                            </div>
                        </asp:Panel>

                        <asp:Panel runat="server" ID="FollowUpPanel">
                            <br />
                            <div id="divFollowUpDetails" class="sectionHeader"><b>Follow-up Details</b></div>
                            <br />
                            <table border="0">
                                <colgroup>
                                    <col width="250px" />
                                </colgroup>

                                <tr>
                                    <td>Follow-up ID
                                    </td>
                                    <td>
                                        <div style="margin-left: 3px;">
                                            <asp:Label runat="server" ID="PatientFollowupId"></asp:Label>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <asp:Label ID="FollowupDataLabel" AssociatedControlID="FollowUpDate" runat="server" Text="Follow-up Date *"></asp:Label></td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <telerik:RadDatePicker ID="FollowUpDate" Date="2012-01-01" runat="server" Calendar-CultureInfo="en-AU" />
                                                <asp:CustomValidator ID="CustomValidatorFollowupDate" runat="server" OnServerValidate="ValidateFollowupDate"
                                                    ValidationGroup="FollowUpDataValidationGroup" CssClass="failureNotification"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                            </div>
                                            <div style="float: left">
                                                &nbsp;
                                        <asp:Image ID="imgInfo01" runat="server" ImageUrl="~/Images/info.png" />
                                                <telerik:RadToolTip ID="rttInfo01" runat="server" TargetControlID="imgInfo01"
                                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                    <asp:Panel ID="pnrttInfo01" runat="server" Width="650px">
                                                        <div class="form">
                                                            <div style="padding-left: 5px">
                                                                <asp:Label ID="lblrttInfo01" runat="server" Text="<b>Follow-up Date:</b> This is a Mandatory field. Please input the date of the patient’s follow up with the surgeon in the format of day/month/year or use the calendar to the side to pick the date.<br/><br/>Please note, only follow up that has occurred:<br/>- between 20 and 90 days from the procedure date can be entered for<b> Perioperative Follow-Up</b><br/>- between 3 – 15 months from the procedure date can be entered for<b> Year 1 Follow-Up</b><br/>- between 15 - 27 months from the procedure date can be entered for<b> Year 2 Follow-Up</b><br/>- between 27 - 39 months from the procedure date can be entered for<b> Year 3 Follow-Up</b><br/>, etc." />
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </telerik:RadToolTip>
                                            </div>
                                        </div>
                                    </td>

                                    <td style="width: 93px"></td>

                                    <td>
                                        <asp:Label ID="FollowupPeriodLabel" AssociatedControlID="FollowupPeriod" runat="server" Text="Follow-up Period *"></asp:Label></td>
                                    <td>
                                        <asp:DropDownList ID="FollowupPeriod" runat="server" Enabled="false">
                                        </asp:DropDownList>
                                        <asp:CustomValidator ID="CustomValidatorFollowPeriod" runat="server" OnServerValidate="ValidateFollowupPeriod"
                                            ValidationGroup="FollowUpDataValidationGroup" CssClass="failureNotification"
                                            ErrorMessage="">*</asp:CustomValidator>
                                    </td>
                                </tr>
                            </table>

                            <asp:Panel runat="server" ID="RecommenddLTFUPanel">
                                <table border="0">
                                    <colgroup>
                                        <col width="250px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="RecommendedLosttoFollowupLabel" AssociatedControlID="RecommendedLostToFollowUp" runat="server" Text="BSR to Follow Up"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:CheckBox ID="RecommendedLostToFollowUp" runat="server" OnPreRender="RecommendedLostToFollowUp_PreRender" /></td>
                                        <td>&nbsp;
                                                <asp:Image ID="imgInfo02" runat="server" ImageUrl="~/Images/info.png" />
                                            <telerik:RadToolTip ID="rttInfo02" runat="server" TargetControlID="imgInfo02"
                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                <asp:Panel ID="pnrttInfo02" runat="server" Width="400px">
                                                    <div class="form">
                                                        <div style="padding-left: 5px">
                                                            <asp:Label ID="lblrttInfo02" runat="server" Text="<b>BSR to Follow Up:</b> If you have been unable to follow up this patient please tick this box for BSR to call them." />
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </telerik:RadToolTip>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </table>

                                <asp:Panel runat="server" ID="RecommendedLTFUReasonPanel">
                                    <table border="0">
                                        <colgroup>
                                            <col width="250px" />
                                        </colgroup>
                                    </table>
                                </asp:Panel>
                            </asp:Panel>
                        </asp:Panel>

                        <asp:Panel runat="server" ID="LostToFollowupPanel">
                            <table border="0">
                                <colgroup>
                                    <col width="250px" />
                                </colgroup>
                                <tr>
                                    <td>
                                        <asp:Label ID="LosttoFollowupLabel" AssociatedControlID="LostToFollowUp" runat="server" Text="Lost to Follow-up"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="LostToFollowUp" runat="server" OnPreRender="LostToFollowUp_PreRender" /></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </table>
                        </asp:Panel>

                        <asp:Panel runat="server" ID="LostToFollowupDatePanel">
                            <table border="0">
                                <colgroup>
                                    <col width="250px" />
                                </colgroup>
                                <tr>
                                    <td>
                                        <asp:Label ID="LosttoFollowUpDateLabel" AssociatedControlID="FollowUpLTFUDate" runat="server" Text="LTFU Date"></asp:Label></td>
                                    <td>
                                        <telerik:RadDatePicker ID="FollowUpLTFUDate" MinDate="1960-01-01" runat="server" Calendar-CultureInfo="en-AU" />
                                        <asp:CustomValidator ID="CustomValidatorLosttoFollowupDate" runat="server" OnServerValidate="ValidateLostToFollowupDate"
                                            ValidationGroup="FollowUpDataValidationGroup" CssClass="failureNotification"
                                            ErrorMessage="">*</asp:CustomValidator>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>

                        <asp:Panel runat="server" ID="FollowupOptionsPanel">
                            <asp:Panel runat="server" ID="Panel30Days">
                                <table border="0">
                                    <colgroup>
                                        <col width="250px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="FollowupSentinelEventLabel" AssociatedControlID="FollowUpSentinelEvent" runat="server" Text="Defined Adverse Event"></asp:Label>
                                            &nbsp;
                                    <asp:Image ID="imgInfo05" runat="server" ImageUrl="~/Images/info.png" />
                                            <telerik:RadToolTip ID="rttInfo05" runat="server" TargetControlID="imgInfo05"
                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                <asp:Panel ID="pnrttInfo05" runat="server" Width="400px">
                                                    <div class="form">
                                                        <div style="padding-left: 5px">
                                                            <asp:Label ID="lblrttInfo05" runat="server" Text="<b>Defined Adverse Event:</b> If any of these events have occurred in the follow up period, please indicate by ticking the box(es).  Please note that multiple events can be selected" />
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </telerik:RadToolTip>

                                        </td>
                                        <td>
                                            <div style="margin-left: -6px;">
                                                <asp:CheckBoxList runat="server" ID="FollowUpSentinelEvent" RepeatDirection="Vertical">
                                                </asp:CheckBoxList>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>

                            <asp:Panel runat="server" ID="YearTo10YearsPanel">
                                <table border="0">
                                    <colgroup>
                                        <col width="250px" />
                                    </colgroup>

                                    <tr>
                                        <td colspan="3">
                                            <asp:Label runat="server" ID="FailureNotification" CssClass="failureNotification"></asp:Label>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <asp:Label ID="FollowupPatientWeightLabel" AssociatedControlID="FollowUpPatientWeight" runat="server" Text="Follow-up Weight *" Width="100px"></asp:Label></td>
                                        <td>
                                            <asp:TextBox ID="FollowUpPatientWeight" runat="server" Width="100"></asp:TextBox>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidatorFollowupPatientWeight" runat="server" ControlToValidate="FollowUpPatientWeight" CssClass="failureNotification" ErrorMessage="Please enter valid weight" ValidationExpression="^\d{1,3}(\.\d{1})?$" ValidationGroup="FollowUpDataValidationGroup">*</asp:RegularExpressionValidator>
                                            <asp:CustomValidator ID="CustomValidatorFollowUpPatientWeight" runat="server" OnServerValidate="ValidateFollowupPatientWeight"
                                                ValidationGroup="FollowUpDataValidationGroup" CssClass="failureNotification"
                                                ErrorMessage="">*</asp:CustomValidator>

                                        </td>
                                        <td>
                                            <div style="overflow: hidden;">
                                                <div style="float: left">
                                                    <asp:CheckBox ID="FollowupPatientWeightUnknown" runat="server" Text="Patient follow-up weight not known" OnClick="enableDisable(this.checked, 'FollowUpPatientWeight');" />
                                                </div>
                                                <div style="float: left">
                                                    &nbsp;
                                        <asp:Image ID="imgInfo03" runat="server" ImageUrl="~/Images/info.png" />
                                                    <telerik:RadToolTip ID="rttInfo03" runat="server" TargetControlID="imgInfo03"
                                                        Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                        AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                        <asp:Panel ID="pnrttInfo03" runat="server" Width="400px">
                                                            <div class="form">
                                                                <div style="padding-left: 5px">
                                                                    <asp:Label ID="lblrttInfo03" runat="server" Text="<b>Follow-up Weight:</b> This is a Mandatory field unless “Patient Follow up weight not known” is ticked. This is the patient’s weight at the time of the follow up in kilograms and to one decimal place. Weight must be between 35-600kg.  If you have a weight outside this range, please contact the BSR directly." />
                                                                </div>
                                                            </div>
                                                        </asp:Panel>
                                                    </telerik:RadToolTip>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td></td>
                                        <td colspan="2">
                                            <asp:Label ID="FollowUpPatientWeightWarning" Visible="true" runat="server" CssClass="failureNotification" /></td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <asp:Label ID="FollowupSelfReportWeightLabel" AssociatedControlID="FollowUpSelfReportedWeight" runat="server" Text="Self-reported weight"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:CheckBox ID="FollowUpSelfReportedWeight" runat="server" />
                                            &nbsp;
                                <asp:Image ID="imgInfo04" runat="server" ImageUrl="~/Images/info.png" />
                                            <telerik:RadToolTip ID="rttInfo04" runat="server" TargetControlID="imgInfo04"
                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                <asp:Panel ID="pnrttInfo04" runat="server" Width="400px">
                                                    <div class="form">
                                                        <div style="padding-left: 5px">
                                                            <asp:Label ID="lblrttInfo04" runat="server" Text="<b>Self-reported weight:</b> If the surgeon was unable to verify the patient’s weight and relied on the patient’s self reporting, please tick this box." />
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </telerik:RadToolTip>
                                        </td>
                                        <td></td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <asp:Label ID="FollowupBMILabel" AssociatedControlID="FollowUpBMI" runat="server" Text="Follow-up BMI" Width="100"></asp:Label></td>
                                        <td>
                                            <asp:TextBox ID="FollowUpBMI" runat="server" Width="50px" ReadOnly="True"></asp:TextBox>
                                            <asp:Label ID="FollowUpBMIWarning" runat="server" Visible="true" CssClass="failureNotification" />
                                        </td>
                                        <td>
                                            <asp:Button ID="CalculateBMIButton" runat="server" Text="Calculate BMI" Visible="false" /></td>
                                    </tr>
                                </table>

                                <table border="0" id="DiabetesTable" runat="server">
                                    <colgroup>
                                        <col width="250px" />
                                    </colgroup>
                                    <tr>
                                        <td style="width: 240px">
                                            <asp:Label ID="FollowupDiabetesStatusLabel" AssociatedControlID="FollowUpDiabetesStatus" runat="server" Text="Diabetes Status *"></asp:Label></td>
                                        <td>
                                            <div style="margin-left: 0.3em">
                                                <asp:DropDownList ID="FollowUpDiabetesStatus" runat="server" OnPreRender="FollowUpDiabetesStatus_PreRender">
                                                </asp:DropDownList>
                                                <asp:CustomValidator ID="CustomValidatorFollowupDiabetesStatus" runat="server" OnServerValidate="ValidateFollowupDiabetesStatus"
                                                    ValidationGroup="FollowUpDataValidationGroup" CssClass="failureNotification"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                            </div>
                                        </td>
                                        <td>&nbsp;
                                    <asp:Image ID="imgInfo09" runat="server" ImageUrl="~/Images/info.png" />
                                            <telerik:RadToolTip ID="rttInfo09" runat="server" TargetControlID="imgInfo09"
                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                <asp:Panel ID="pnrttInfo09" runat="server" Width="400px">
                                                    <div class="form">
                                                        <div style="padding-left: 5px">
                                                            <asp:Label ID="lblrttInfo09" runat="server" Text="<b>Diabetes Status:</b> This is a Mandatory field. Please indicate whether the patient identifies as having diabetes.  If it is not known, please select “not stated/ inadequately described”.  If you select “Yes” a dropdown of the type of treatment required will appear." />
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </telerik:RadToolTip>

                                        </td>
                                    </tr>
                                </table>

                                <asp:Panel runat="server" ID="DiabetesTreatmentPanel">
                                    <table border="0">
                                        <colgroup>
                                            <col width="250px" />
                                        </colgroup>
                                        <tr>
                                            <td>
                                                <div style="overflow: hidden;">
                                                    <div style="float: left">
                                                        <asp:Label ID="FollowupDiabetesTreatmentLabel" AssociatedControlID="FollowUpDiabetesTreatment" runat="server" Text="Diabetes Treatment (tick one)"></asp:Label>
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
                                                                        <asp:Label ID="lblrttInfo10" runat="server" Text="<b>Diabetes Treatment:</b> This is a Mandatory field if you have selected “Yes” to the Diabetes Status.  Please tick the type of treatment the patient is currently undertaking for their diabetes." />
                                                                    </div>
                                                                </div>
                                                            </asp:Panel>
                                                        </telerik:RadToolTip>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div style="margin-left: -0.4em">
                                                    <asp:CheckBoxList runat="server" ID="FollowUpDiabetesTreatment" RepeatDirection="Vertical">
                                                    </asp:CheckBoxList>
                                                    <asp:CustomValidator ID="CustomValidatorDiabetesTreatment" runat="server" OnServerValidate="ValidateDiabetesTreatment"
                                                        ValidationGroup="FollowUpDataValidationGroup" CssClass="failureNotification"
                                                        ErrorMessage="">*</asp:CustomValidator>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>

                                <table border="0">
                                    <colgroup>
                                        <col width="260px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="FollowupReoperationLabel" AssociatedControlID="FollowUpReOperation" runat="server" Text="Has the patient had a reoperation in the last 12 months? *" Width="250px"></asp:Label></td>
                                        <td>
                                            <div style="margin-left: -0.7em">
                                                <asp:DropDownList ID="FollowUpReOperation" runat="server">
                                                </asp:DropDownList>
                                                <asp:CustomValidator ID="CustomValidatorFollowupReopeation" runat="server" ValidationGroup="FollowUpDataValidationGroup"
                                                    CssClass="failureNotification" ErrorMessage="Re-operation missing"
                                                    OnServerValidate="ValidateFollowupReoperation">*</asp:CustomValidator>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>

                            <asp:Panel runat="server" ID="FollowupReasonPanel">
                                <table border="0">
                                    <colgroup>
                                        <col width="245px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="FollowupReasonLabel" AssociatedControlID="FollowUpReason" runat="server" Text="Reason *" Width="100"></asp:Label>
                                            &nbsp;
                                    <asp:Image ID="imgInfo06" runat="server" ImageUrl="~/Images/info.png" />
                                            <telerik:RadToolTip ID="rttInfo06" runat="server" TargetControlID="imgInfo06"
                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                <asp:Panel ID="pnrttInfo06" runat="server" Width="400px">
                                                    <div class="form">
                                                        <div style="padding-left: 5px">
                                                            <asp:Label ID="lblrttInfo06" runat="server" Text="<b>Reason:</b> This is a Mandatory field if a Sentinel Event has occurred.  Please indicate the reason(s) for the sentinel event.  If you select “Other”, you will be asked for a further explanation." />
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </telerik:RadToolTip>

                                        </td>
                                        <td>
                                            <asp:CheckBoxList runat="server" ID="FollowUpReason" RepeatColumns="4"></asp:CheckBoxList>
                                            <asp:CustomValidator ID="CustomValidatorFollowupReason" runat="server" OnServerValidate="ValidateFollowupReason"
                                                ValidationGroup="FollowUpDataValidationGroup" CssClass="failureNotification" Enabled="false"
                                                ErrorMessage="">*</asp:CustomValidator>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>

                            <asp:Panel runat="server" ID="FurtherInformationPanel" CssClass="EmbeddedViewPlaceholder">
                                <asp:Panel runat="server" ID="FurtherInformationSlipPanel">
                                    <table border="0">
                                        <colgroup>
                                            <col width="240px" />
                                        </colgroup>
                                        <tr>
                                            <td>
                                                <asp:Label ID="FollowupSlipLabel" AssociatedControlID="FurtherInfoSlip" runat="server" Text="Further information (Prolapse/Slip) *" Width="100"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="FurtherInfoSlip" runat="server">
                                                </asp:DropDownList>
                                                <asp:CustomValidator ID="CustomValidatorFurtherInformationSlip" runat="server" OnServerValidate="ValidateFurtherInformationSlip"
                                                    ValidationGroup="FollowUpDataValidationGroup" CssClass="failureNotification" Enabled="false"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>

                                <asp:Panel runat="server" ID="PortPanel">
                                    <table border="0">
                                        <colgroup>
                                            <col width="240px" />
                                        </colgroup>
                                        <tr>
                                            <td>
                                                <asp:Label ID="FollowupPortLabel" AssociatedControlID="FurtherInfoPort" runat="server" Text="Further information (Port) *" Width="100"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="FurtherInfoPort" runat="server">
                                                </asp:DropDownList>
                                                <asp:CustomValidator ID="CustomValidatorFurtherInformationPort" runat="server" OnServerValidate="ValidateFurtherInformationPort"
                                                    ValidationGroup="FollowUpDataValidationGroup" CssClass="failureNotification" Enabled="false"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>

                                <asp:Panel runat="server" ID="OtherReasonPanel">
                                    <table border="0">
                                        <colgroup>
                                            <col width="240px" />
                                        </colgroup>
                                        <tr>
                                            <td>
                                                <asp:Label ID="FollowupOtherReasonLabel" runat="server" AssociatedControlID="FollowUpOther" Text="Other reason (specify) *" />
                                            </td>
                                            <td>
                                                <asp:TextBox ID="FollowUpOther" runat="server" Width="500px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                                <asp:CustomValidator ID="CustomValidatorFollowupOtherReason" runat="server" OnServerValidate="ValidateFollowupOtherReason"
                                                    ValidationGroup="FollowUpDataValidationGroup" CssClass="failureNotification" Enabled="false"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>

                                <asp:Panel runat="server" ID="BowelObstructionOperative">
                                    <table border="0">
                                        <colgroup>
                                            <col width="255px" />
                                        </colgroup>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label2" AssociatedControlID="BowelObstructionOptions" runat="server" Text="Bowel Obstruction Further Detail *" Width="100"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="BowelObstructionOptions" runat="server"></asp:DropDownList>
                                                <asp:CustomValidator ID="CustomValidatorBowelObstructionOperative" runat="server" OnServerValidate="ValidateBowelObstruction"
                                                    ValidationGroup="PatientOperationDataValidationGroup" CssClass="failureNotification" Enabled="false"
                                                    ErrorMessage="">*</asp:CustomValidator>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </asp:Panel>

                            <table border="0">
                                <colgroup>
                                    <col width="250px" />
                                </colgroup>
                                <tr>
                                    <td>
                                        <asp:Label ID="FollowupVitalStatusLabel" AssociatedControlID="FollowUpVitalStatus" runat="server" Text="Vital Status"></asp:Label></td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:DropDownList ID="FollowUpVitalStatus" runat="server" OnPreRender="FollowUpVitalStatus_PreRender">
                                                </asp:DropDownList>
                                            </div>
                                            <div style="float: left">
                                                &nbsp;
                                        <asp:Image ID="imgInfo07" runat="server" ImageUrl="~/Images/info.png" />
                                                <telerik:RadToolTip ID="rttInfo07" runat="server" TargetControlID="imgInfo07"
                                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                    <asp:Panel ID="pnrttInfo07" runat="server" Width="400px">
                                                        <div class="form">
                                                            <div style="padding-left: 5px">
                                                                <asp:Label ID="lblrttInfo07" runat="server" Text="<b>Vital Status:</b> This is defaulted to alive, so should only be changed if the patient is deceased" />
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </telerik:RadToolTip>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>

                            <asp:Panel runat="server" ID="DeathPanel" CssClass="EmbeddedViewPlaceholder">
                                <table border="0">
                                    <colgroup>
                                        <col width="240px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="DateOfDeathLabel" AssociatedControlID="FollowUpDateOfDeath" runat="server" Text="Date of Death"></asp:Label></td>
                                        <td>
                                            <div style="overflow: hidden;">
                                                <div style="float: left">
                                                    <telerik:RadDatePicker ID="FollowUpDateOfDeath" MinDate="1900-01-01" runat="server" Calendar-CultureInfo="en-AU" />
                                                    <asp:CustomValidator ID="CustomValidatorDateofDeath" runat="server" OnServerValidate="ValidateDateOfDeath"
                                                        ValidationGroup="FollowUpDataValidationGroup" CssClass="failureNotification" Enabled="false"
                                                        ErrorMessage="">*</asp:CustomValidator>
                                                </div>
                                                <div style="float: left; margin-top: 2px; margin-left: -3px;">
                                                    <asp:CheckBox ID="DateofDeathUnknown" runat="server" Text="Date of Death not known" OnClick="enableDisable(this.checked, 'FollowUpDateOfDeath');" />
                                                </div>
                                            </div>
                                        </td>
                                        <td></td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <asp:Label ID="CauseOfDeathLabel" AssociatedControlID="FollowUpCauseOfDeath" runat="server" Text="Cause of Death"></asp:Label></td>
                                        <td colspan="4">
                                            <asp:TextBox ID="FollowUpCauseOfDeath" runat="server" MaxLength="200" TextMode="MultiLine" Rows="3" Width="500px"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <asp:Label ID="DeathRelatedtoPrimaryProcedureLabel" AssociatedControlID="DeathRelatedToPrimaryProcedure" runat="server" Text="Death Related to Bariatric Procedure*"></asp:Label></td>
                                        <td>
                                            <asp:DropDownList runat="server" ID="DeathRelatedToPrimaryProcedure"></asp:DropDownList>
                                            <asp:CustomValidator ID="DeathRelatedValidator" runat="server" OnServerValidate="ValidateRelatedDeath"
                                                ValidationGroup="FollowUpDataValidationGroup" CssClass="failureNotification" Enabled="false" ErrorMessage="">*</asp:CustomValidator>

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

                            <asp:Panel ID="CommentPanel" runat="server">
                                <table border="0">
                                    <colgroup>
                                        <col width="250px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="CommentsLabel" AssociatedControlID="Comments" runat="server" Text="Comments"></asp:Label></td>
                                        <td colspan="4">
                                            <asp:TextBox ID="Comments" runat="server" TextMode="MultiLine" Rows="3" MaxLength="500" Width="500px"></asp:TextBox>
                                            &nbsp;
                                    <asp:Image ID="imgInfo08" runat="server" ImageUrl="~/Images/info.png" />
                                            <telerik:RadToolTip ID="rttInfo08" runat="server" TargetControlID="imgInfo08"
                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                <asp:Panel ID="pnrttInfo08" runat="server" Width="400px">
                                                    <div class="form">
                                                        <div style="padding-left: 5px">
                                                            <asp:Label ID="lblrttInfo08" runat="server" Text="<b>Comments:</b> Please add any comments you feel relevant in the space provided" />
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </telerik:RadToolTip>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </asp:Panel>
                    </asp:Panel>
                </div>
            </div>
            <asp:Panel runat="server" ID="ButtonsPanel">
                <table border="0">
                    <tr>
                        <td colspan="4">
                            <div style="overflow: hidden">
                                <div style="float: left;">
                                    <asp:Button ID="BackButton" runat="server" Text="Cancel" OnClick="BackClicked" CausesValidation="false" />
                                    <asp:Button ID="SaveButton" runat="server" Text="Save" CausesValidation="false" OnClick="SaveClicked" OnClientClick="formUnModified()" />
                                    <asp:Button ID="SubmitButton" runat="server" Text="Submit" OnClientClick="formUnModified();" ValidationGroup="FollowUpDataValidationGroup" OnClick="SubmitButtonClicked" />
                                </div>
                                <div style="float: left;">
                                    <asp:Label ID="SuccessNotification" runat="server" Class="successNotification"></asp:Label>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </asp:Panel>

            <uc3:AuditForm ID="auditForm" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
