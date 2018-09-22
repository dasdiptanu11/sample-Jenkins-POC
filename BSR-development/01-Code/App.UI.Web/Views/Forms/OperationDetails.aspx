<%@ Page Title="Operation Details" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    AutoEventWireup="True" CodeBehind="OperationDetails.aspx.cs" Inherits="App.UI.Web.Views.Forms.OperationDetails" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Src="~/Views/Shared/PatientRibbon.ascx" TagPrefix="uc" TagName="PatientRibbon" %>
<%@ Register Src="~/Views/Shared/SurgeonAndSite.ascx" TagPrefix="uc" TagName="SurgeonAndSite" %>
<%@ Register Src="~/Views/Shared/AuditForm.ascx" TagName="AuditForm" TagPrefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadCodeBlock ID="rcb" runat="server">
        <script type="text/javascript" src="../../Scripts/jquery-1.8.2.min.js"></script>
        <script type="text/javascript">
            function ReasonCheckBoxHandler() {
                var CheckBox = $get("<%=LastFollowupReason.ClientID %>");
                var hidePanel = [$get("<%=FurtherInformationSlipPanel.ClientID %>"), $get("<%=FollowupPortPanel.ClientID %>"), $get("<%=OtherReasonPanel.ClientID %>"), $get("<%=BowelObstructionOperative.ClientID %>")];
                var fieldToReset = [$get("<%=FurtherInfoSlip.ClientID %>"), $get("<%=FurtherInfoPort.ClientID %>"), $get("<%=OtherReasonSpecify.ClientID %>"), $get("<%=BowelObstructionOptions.ClientID %>")];
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

                                displayPanel.push($get("<%=FollowupPortPanel.ClientID %>"));
                                hidePanel.splice(hidePanel.indexOf($get("<%=FollowupPortPanel.ClientID %>")), 1);
                                fieldToReset.splice(fieldToReset.indexOf($get("<%=FurtherInfoPort.ClientID %>")), 1);

                                break;
                            case "27":  //Other
                                optionchecked = true;

                                displayPanel.push($get("<%=OtherReasonPanel.ClientID %>"));
                                hidePanel.splice(hidePanel.indexOf($get("<%=OtherReasonPanel.ClientID %>")), 1);
                                fieldToReset.splice(fieldToReset.indexOf($get("<%=OtherReasonSpecify.ClientID %>")), 1);

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

            function ShowOtherPrim() {
                var chkBox = $get("<%=PrimaryProcedure.ClientID %>");
                var otherpanel = $get("<%=OtherDetailsPanel.ClientID %>");
                var othercntrl = $get("<%=OtherProcedureSpecify.ClientID %>");
                ShowOther(chkBox, otherpanel, othercntrl);
            }

            function ShowOtherSec() {
                var chkBox = $get("<%=SecondaryProcedure.ClientID %>");
                var otherpanel = $get("<%=OtherRevisionPanel.ClientID %>");
                var othercntrl = $get("<%=OtherSecondarySpecify.ClientID %>");
                ShowOther(chkBox, otherpanel, othercntrl);
            }

            function ShowOther(chkBox, otherpanel, othercntrl) {
                var optionchecked = null;
                var options = chkBox.getElementsByTagName('input');
                var listOfSpans = chkBox.getElementsByTagName('span');
                for (var i = 0; i < options.length; i++) {
                    if (options[i].checked) {
                        optionchecked = options[i].value;
                        break;
                    }
                }

                othercntrl.value = '';
                if (optionchecked == '9') {
                    otherpanel.style.display = 'block';
                }
                else {
                    otherpanel.style.display = 'none';
                }
            }

            $(function () {
                var chkSEvent = $('#<%=DiabetesTreatment.ClientID %>').find('input:checkbox');
                chkSEvent.click(function () {
                    var selectedIndex = chkSEvent.index($(this));
                    var items = $('#<% = DiabetesTreatment.ClientID %> input:checkbox');
                    for (i = 0; i < items.length; i++) {
                        if (i == selectedIndex && items[selectedIndex].checked == true) {
                            items[i].checked = true;
                        }
                        else {
                            items[i].checked = false;
                        }
                    }
                });

                var prim = $('#<%=PrimaryProcedure.ClientID %>').find('input:checkbox');
                prim.click(function () {
                    var selectedIndex = prim.index($(this));
                    var items = $('#<% = PrimaryProcedure.ClientID %> input:checkbox');
                    for (i = 0; i < items.length; i++) {
                        if (i == selectedIndex && items[selectedIndex].checked == true) {
                            items[i].checked = true;
                        }
                        else {
                            items[i].checked = false;
                        }
                    }
                });

                var sec = $('#<%=SecondaryProcedure.ClientID %>').find('input:checkbox');
                sec.click(function () {
                    var selectedIndex = sec.index($(this));
                    var items = $('#<% = SecondaryProcedure.ClientID %> input:checkbox');
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
                        var chkSEvent = $('#<%=DiabetesTreatment.ClientID %>').find('input:checkbox');
                        chkSEvent.click(function () {
                            var selectedIndex = chkSEvent.index($(this));
                            var items = $('#<% = DiabetesTreatment.ClientID %> input:checkbox');
                            for (i = 0; i < items.length; i++) {
                                if (i == selectedIndex && items[selectedIndex].checked == true) {
                                    items[i].checked = true;
                                }
                                else {
                                    items[i].checked = false;
                                }
                            }
                        });

                        var prim = $('#<%=PrimaryProcedure.ClientID %>').find('input:checkbox');
                        prim.click(function () {
                            var selectedIndex = prim.index($(this));
                            var items = $('#<% = PrimaryProcedure.ClientID %> input:checkbox');
                            for (i = 0; i < items.length; i++) {
                                if (i == selectedIndex && items[selectedIndex].checked == true) {
                                    items[i].checked = true;
                                }
                                else {
                                    items[i].checked = false;
                                }
                            }
                        });

                        var sec = $('#<%=SecondaryProcedure.ClientID %>').find('input:checkbox');
                        sec.click(function () {
                            //Clearing the selection values - due to upon selection of this will reload the reasons for procedures  
                            var RB1 = document.getElementById("<%=OperationEvent.ClientID%>");
                            var radio = RB1.getElementsByTagName("input");
                            for (var i = 0; i < radio.length; i++) {
                                radio[i].checked = false;
                            }

                            $get("<%=FollowupReasonPanel.ClientID %>").style.display = 'none';
                            var selectedIndex = sec.index($(this));
                            var items = $('#<% = SecondaryProcedure.ClientID %> input:checkbox');
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

            function DisableOtherOptions(chkBox, disable) {
                var options = chkBox.getElementsByTagName('input');
                var listOfSpans = chkBox.getElementsByTagName('span');
                for (var i = 0; i < options.length; i++) {
                    if (disable) {
                        if (!options[i].checked) {
                            options[i].disabled = true;
                        }
                    }
                    else {
                        options[i].disabled = false;
                    }
                }
            }

            function CheckPrimarySurgeon(PrimSurgId, SurgID) {
                var Surg = $get(SurgID).value;
                $get("<%=hdnSurg.ClientID %>").value = 'N';
                if (Surg != '' && PrimSurgId != Surg) {
                    var SurgName = $get(SurgID).options[$get(SurgID).selectedIndex].text;
                    var oWindow = window.radopen('YesNoConfirm.aspx?Timestamp=' + new Date().getMilliseconds() + '&Surgeon=' + SurgName);
                    oWindow.SetModal(true);
                    oWindow.set_visibleStatusbar(false);
                    oWindow.set_width('600px')
                    oWindow.set_height('150px')
                    oWindow.set_behaviors(Telerik.Web.UI.WindowBehaviors.Move + Telerik.Web.UI.WindowBehaviors.Close);
                    oWindow.set_autoSize(false);
                    oWindow.set_title('Confirm');
                    oWindow.set_showContentDuringLoad(false);
                    oWindow.add_close(ConfirmCallBack);
                    oWindow.show();
                }
                else {
                    $get("<%=hdnSurg.ClientID %>").value = 'N';
                }
            }

            function ConfirmCallBack(arg) {
                if (arg.Argument == '1') {
                    $get("<%=hdnSurg.ClientID %>").value = 'Y';
                }
                else {
                    $get("<%=hdnSurg.ClientID %>").value = 'N';
                }
            }

            function DisableDiabOptions() {
                var chkBox = $get("<%=DiabetesTreatment.ClientID %>");
                var optionchecked = null;
                var options = chkBox.getElementsByTagName('input');
                var listOfSpans = chkBox.getElementsByTagName('span');
                for (var i = 0; i < options.length; i++) {
                    if (options[i].checked) {
                        optionchecked = options[i].value;
                    }
                }
                if (optionchecked == null) {
                    DisableOtherOptions(chkBox, false);
                }
                else {
                    DisableOtherOptions(chkBox, true);
                }
            }

            function ShowHideOperation(Hasprimary, PrimOpid, Opid, poCount, firstOpId) {
                var opstat = $get("<%=OperationStatus.ClientID %>");
                switch (opstat.value) {
                    case "0":
                        $get("<%=PrimaryProcedurePanel.ClientID %>").style.display = 'block';
                        $get("<%=RevisionProcedurePanel.ClientID %>").style.display = 'none';
                        $get("<%=PatientStartWeightPanel.ClientID %>").style.display = 'block';
                        $get("<%=DiabetesPanel.ClientID %>").style.display = 'block';
                        Uncheckall($get("<%=SecondaryProcedure.ClientID %>"), $get("<%=OtherSecondarySpecify.ClientID %>"), $get("<%=OtherRevisionPanel.ClientID %>"));
                        break;

                    case "1":
                        $get("<%=PrimaryProcedurePanel.ClientID %>").style.display = 'none';
                        $get("<%=RevisionProcedurePanel.ClientID %>").style.display = 'block';
                        if (poCount == 0 || poCount == undefined) {
                            $get("<%=OperationEventPanel.ClientID %>").style.display = 'none';
                        }
                        else if (firstOpId == Opid) {
                            $get("<%=OperationEventPanel.ClientID %>").style.display = 'none';
                        }
                        else {
                            $get("<%=OperationEventPanel.ClientID %>").style.display = 'block';
                        }

                    $get("<%=PatientStartWeightPanel.ClientID %>").style.display = 'none';
                        $get("<%=DiabetesPanel.ClientID %>").style.display = 'block';
                        Uncheckall($get("<%=PrimaryProcedure.ClientID %>"), $get("<%=OtherProcedureSpecify.ClientID %>"), $get("<%=OtherDetailsPanel.ClientID %>"));
                        break;

                    default:
                        $get("<%=PrimaryProcedurePanel.ClientID %>").style.display = 'none';
                        $get("<%=RevisionProcedurePanel.ClientID %>").style.display = 'none';
                        Uncheckall($get("<%=PrimaryProcedure.ClientID %>"), $get("<%=OtherProcedureSpecify.ClientID %>"), $get("<%=OtherDetailsPanel.ClientID %>"));
                        Uncheckall($get("<%=SecondaryProcedure.ClientID %>"), $get("<%=OtherSecondarySpecify.ClientID %>"), $get("<%=OtherRevisionPanel.ClientID %>"));
                        break;
                }

                if (Hasprimary && PrimOpid == Opid && opstat.value == '1') {
                    $get("<%=LastBariatricProcedurePanel.ClientID %>").style.display = 'block';
                } else {
                    $get("<%=LastBariatricProcedurePanel.ClientID %>").style.display = 'none';
                }
            }

            function Uncheckall(obj, txtother, other) {
                var chkBox = obj;
                var optionchecked = null;
                var options = chkBox.getElementsByTagName('input');
                var listOfSpans = chkBox.getElementsByTagName('span');
                for (var i = 0; i < options.length; i++) {
                    if (options[i].checked) {
                        options[i].checked = false;
                    }
                }
                txtother.value = '';
                other.style.display = 'none';
            }

            function EnableDisable(txt, chk) {
                if ($get(chk).checked == true) {
                    $get(txt).disabled = true;

                    $find(txt).set_value('');
                    $get("<%=OperationBMI.ClientID %>").value = '';
                    $get("<%=PatientStartBMI.ClientID %>").value = '';
                }
                else {
                    $get(txt).disabled = false;
                }
            }

            function EnableDisableStWt(txtstwgt, chkstwtNotKnown, chksameOpWgt, txtstartBMI) {
                if ($get(chkstwtNotKnown).checked == true) {
                    $get(txtstwgt).disabled = true;
                    $get(chksameOpWgt).checked = false;
                    $get(txtstartBMI).value = '';
                    $get(txtstwgt).value = '';
                }
                else {
                    $get(txtstwgt).disabled = false;
                }
            }

            function EnableDisableOpWtNotKnown(txtopwgt, chkopwtNotKnown, chksameOpWgt, txtstartBMI, txtOpBMI) {
                if ($get(chkopwtNotKnown).checked == true) {
                    $get(txtopwgt).disabled = true;
                    //Clear start BMI when same as op Weight is ticked and disable the same as op weight
                    if ($get(chksameOpWgt).checked == true) {
                        $get(chksameOpWgt).checked = false;
                        $get(chksameOpWgt).disabled = true;
                        $get(txtstartBMI).value = '';
                    }
                    $get(txtopwgt).value = '';
                    $get(txtOpBMI).value = '';
                }
                else {
                    $get(txtopwgt).disabled = false;
                    $get(chksameOpWgt).disabled = false;
                }
            }

            //Same as Op Weight
            function EnableDisableOpWt(chkst, chk, chkstwt) {
                if ($get(chkst).checked == true) {
                    $get(chkstwt).checked = false;
                    $get(chkstwt).disabled = true;

                    $get(chk).checked = false;
                    $get(chk).disabled = true;
                    $get("<%=PatientStartWeight.ClientID %>").disabled = true;
                    if ($get("<%=PatientStartWeight.ClientID %>").value != '') {
                        $get("<%=PatientWeight.ClientID %>").value = $get("<%=PatientStartWeight.ClientID %>").value;
                    }
                    $get("<%=PatientStartWeight.ClientID %>").value = '';
                    $get("<%=PatientWeight.ClientID %>").disabled = false;
                    $get("<%=PatientWeight.ClientID %>").focus();
                    CalculateBMI("<%=PatientWeight.ClientID %>", "<%=PatientStartBMI.ClientID %>", "<%=OperationWeightWarning.ClientID %>", "<%=OperationBMIWarning.ClientID %>");
                }
                else {
                    $get(chk).disabled = false;
                    $get(chkstwt).disabled = false;
                    $get("<%=PatientStartWeight.ClientID %>").disabled = false;
                    $get("<%=PatientStartWeight.ClientID %>").value = '';
                    $get("<%=PatientStartBMI.ClientID %>").value = '';
                }
            }

            function CalculateBMI(wt, BMI, wtwarn, bmiwarn) {
                var wgt = $get(wt).value;
                if (wgt != '') {
                    if (Number(wgt) > 200) {
                        $get(wtwarn).innerHTML = 'A weight of over 200kg  has been entered. Please check.';
                    }
                    else {
                        $get(wtwarn).innerHTML = '';
                    }
                }
                else {
                    $get(wtwarn).innerHTML = ''
                }

                var ht = $get("<%=PatientHeight.ClientID %>").value;
                if (ht != '' && wgt != '' && ht != '0') {
                    var bmi = Number(wgt) / (Number(ht) * Number(ht));
                    bmi = bmi.toString();
                    if (bmi.indexOf('.') != -1) {
                        bmi = bmi.split('.')[0] + '.' + bmi.split('.')[1].substr(0, 2);
                    }
                    $get(BMI).value = bmi;
                    if ($get("<%=SameAsOperationWeight.ClientID%>").checked == true) {
                        $get("<%=PatientStartBMI.ClientID%>").value = bmi;
                    }

                    if (Number(bmi) > 99.9) {
                        $get(bmiwarn).innerHTML = 'Patient BMI > 99.9. Please check.';
                    }
                    else {
                        $get(bmiwarn).innerHTML = '';
                    }
                }
                else {
                    $get(BMI).value = '';
                    $get(bmiwarn).innerHTML = '';
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

            function CheckIfOutOfRange(ht) {
                var ht = $get(ht).value;
                $get('<%= HeightWarningMessage.ClientID %>').innerText = '';  //Needed if height is blanked out
            if (ht != '') {
                if (Number(ht) < 1 || Number(ht) > 3) {
                    $get('<%= HeightWarningMessage.ClientID %>').innerText = 'Patient height is out of range (1.00m - 3.00m). Please check.';
                }
                else {
                    $get('<%= HeightWarningMessage.ClientID %>').innerText = '';
                }
            }
            CalculateBMI("<%=PatientStartWeight.ClientID %>", "<%=PatientStartBMI.ClientID %>", "<%=StartWeightWarning.ClientID %>", "<%=StartBMIWarning.ClientID %>");
            CalculateBMI("<%=PatientWeight.ClientID %>", "<%=OperationBMI.ClientID %>", "<%=OperationWeightWarning.ClientID %>", "<%=OperationBMIWarning.ClientID %>");
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

        function genericPopup(href, width, height, Title, Mode) {
            if (Mode == 'A') {
                var oWindow = window.radopen(href + '?&IsAdd=true&Timestamp=' + new Date().getMilliseconds(), null, width, height, null, null);
            }
            else {
                var oWindow = window.radopen(href, null, width, height, null, null);
            }
            oWindow.SetModal(true);
            oWindow.set_visibleStatusbar(false);
            oWindow.set_width('950px')
            oWindow.set_behaviors(Telerik.Web.UI.WindowBehaviors.Move + Telerik.Web.UI.WindowBehaviors.Close);
            oWindow.set_autoSize(false);
            oWindow.set_title(Title);
            oWindow.set_showContentDuringLoad(false);
            oWindow.add_close(OnClientClose);
            oWindow.show();
        }

        function OnClientClose(obj) {
            m_RetVal = obj.Argument;
            if (m_RetVal != null && m_RetVal == 'true') {
                __doPostBack("<%=DeviceGrid.UniqueID %>", "");
            }
        }

        function ShowMessage(Value, drpOpStatId, DtValue, OPDtId, IsFUPDone) {
            RetVal1 = true;
            RetVal2 = true;

            if (IsFUPDone == 'YES') {
                if (Value == 0 && document.getElementById(drpOpStatId).value != Value) {
                    var m_Ret = confirm('Changing the Operation status from Primary to Revision will delete all the annual followups for this patient. By clicking "OK" you confirm to proceed with changing the Operation Status. If you do not wish to change the Operation Status click "Cancel"')
                    if (m_Ret == true) {
                        RetVal1 = true;
                    }
                    else {
                        RetVal1 = false;
                    }
                }
                if (DtValue != null && DtValue != "" && DtValue.indexOf(' ') != -1
                    && document.getElementById(OPDtId).value != '' && document.getElementById(OPDtId).value != null) {
                    DtValue = DtValue.split(' ')[0];
                    OpDt = $find(OPDtId).get_dateInput().get_selectedDate().format("d/MM/yyyy");
                    if (OpDt != DtValue) {
                        var m_Ret = confirm('Changing the Operation date will recreate the annual followups that are not due and not done for this patient. By clicking "OK" you confirm to proceed with changing the Operation Date. If you do not wish to change the Operation Date click "Cancel"')
                        if (m_Ret == true) {
                            RetVal2 = true;
                        }
                        else {
                            RetVal2 = false;
                        }
                    }
                }
            }

            formUnModified();
            if (RetVal1 == true && RetVal2 == true) {
                return true;
            }
            else {
                return false;
            }
        }
        </script>
    </telerik:RadCodeBlock>

    <uc:ContentHeader ID="Header" runat="server" Title="Operation Details" />
    <uc:PatientRibbon runat="server" ID="PatientRibbon" />
    <asp:Button ID="AddOperationButton" runat="server" Text="Add Operation" CausesValidation="false" OnClick="AddOperationClicked" OnClientClick="formUnModified()" />
    <div class="clear">
    </div>
    <br />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <telerik:RadGrid ID="OperationGrid" runat="server" AllowFilteringByColumn="false" AutoGenerateColumns="False"
                AllowSorting="True" Width="100%" CellSpacing="0" AllowPaging="True" ShowStatusBar="True" OnPreRender="OperationGrid_PreRender"
                OnNeedDataSource="OperationGrid_NeedDataSource" OnItemDataBound="OperationGrid_ItemDataBound"
                AllowMultiRowSelection="True" OnItemCommand="OperationGrid_ItemCommand" GridLines="None" OnDeleteCommand="OperationGrid_DeleteCommand"
                PageSize="20">

                <GroupingSettings CaseSensitive="false" />
                <ClientSettings AllowColumnsReorder="False" ReorderColumnsOnClient="False" Selecting-AllowRowSelect="false"
                    EnablePostBackOnRowClick="false">
                    <Scrolling AllowScroll="true" ScrollHeight="470px" />
                </ClientSettings>

                <MasterTableView DataKeyNames="PatientOperationId" CommandItemDisplay="Top" HeaderStyle-HorizontalAlign="Left">
                    <CommandItemSettings ShowExportToPdfButton="false" ShowExportToExcelButton="false" ShowRefreshButton="false" ShowAddNewRecordButton="False"></CommandItemSettings>
                    <RowIndicatorColumn>
                        <HeaderStyle Width="20px"></HeaderStyle>
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn>
                        <HeaderStyle Width="20px"></HeaderStyle>
                    </ExpandCollapseColumn>
                    <PagerStyle AlwaysVisible="true" />

                    <Columns>
                        <telerik:GridButtonColumn ButtonType="LinkButton" DataTextField="PatientOperationId" CommandName="EditOperation" HeaderTooltip="Edit this Patient"
                            HeaderText="Operation ID" SortExpression="PatientOperationId"
                            UniqueName="EditOperation" HeaderStyle-Width="80">
                        </telerik:GridButtonColumn>

                        <telerik:GridBoundColumn DataField="PatientOperationId" HeaderText="Operation ID" UniqueName="PatientOperationId" HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Right" Visible="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationStatus" HeaderText="Operation Status" UniqueName="OperationStatus" HeaderStyle-Width="100"
                            ItemStyle-HorizontalAlign="Right"
                            Visible="false">
                        </telerik:GridBoundColumn>

                        <telerik:GridDateTimeColumn DataField="OperationDate" UniqueName="OperationDate" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Operation Date" HeaderStyle-Width="110">
                        </telerik:GridDateTimeColumn>

                        <telerik:GridBoundColumn DataField="OperationStatus" HeaderText="Operation Status" UniqueName="OperationStatus" HeaderStyle-Width="110">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationType" HeaderText="Operation Type" UniqueName="OperationType" HeaderStyle-Width="110">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationWeight" HeaderText="Operation Weight" UniqueName="OperationWeight" HeaderStyle-Width="110">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationSite" HeaderText="Site" UniqueName="OperationSite" HeaderStyle-Width="100">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="OperationSurgeon" HeaderText="Surgeon" UniqueName="OperationSurgeon" HeaderStyle-Width="110">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="DiabetesStatus" HeaderText="Diabetes Status" UniqueName="DiabetesStatus" HeaderStyle-Width="80">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="DiabetesTreatment" HeaderText="Diabetes Treatment" UniqueName="DiabetesTreatment" HeaderStyle-Width="60">
                        </telerik:GridBoundColumn>

                        <telerik:GridButtonColumn ConfirmText="Deleting this operation will also delete all the followups. Are you sure you want to delete this Operation? Do you wish to continue?"
                            ConfirmDialogType="RadWindow" CommandName="Delete" Text="Delete" ItemStyle-Width="20px"
                            Visible="true" AutoPostBackOnFilter="true" ButtonType="LinkButton" UniqueName="Delete">
                        </telerik:GridButtonColumn>
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:UpdatePanel ID="PatientOperationUpdatePanel" runat="server">
        <ContentTemplate>
            <input type="hidden" id="modifiedStatus" value="F" />

            <table style="width: 100%;">
                <tr>
                    <td style="width: 50%;">
                        <asp:ValidationSummary ID="OperationValidationSummary" runat="server" ValidationGroup="PatientOperationDataValidationGroup"
                            CssClass="failureNotification" HeaderText="" DisplayMode="List" />
                        <asp:ValidationSummary ID="PrimaryOperationValidationSummary" runat="server" ValidationGroup="PatientOperationDataValidationGroup_Primary"
                            CssClass="failureNotification" HeaderText="" DisplayMode="List" />
                        <asp:ValidationSummary ID="DeviceValidationSummary" runat="server" ValidationGroup="PatientOperationDataValidationGroup_Device"
                            CssClass="failureNotification" HeaderText="" DisplayMode="List" />
                        <asp:ValidationSummary ID="PriOptValidationSummary" runat="server" ValidationGroup="PatientPriOperationDataValidationGroup"
                            CssClass="failureNotification" HeaderText="" DisplayMode="List" />
                    </td>
                </tr>
            </table>

            <asp:Panel ID="OperationPanel" runat="server" Style="display: none">
                <div class="form">
                    <div class="sectionPanel1">
                        <div class="sectionHeader">
                            Surgeon and Institution
                        </div>
                        <div class="sectionContent">
                            <table class="tableForm" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                            <tr>
                                                <td style="width: 268px">
                                                    <asp:Label ID="HospitalMRNumberLabel" AssociatedControlID="HospitalMRNumber" runat="server" Text="UR No" /></td>
                                                <td>
                                                    <asp:TextBox ID="HospitalMRNumber" runat="server" Width="100px" />
                                                    <asp:CustomValidator ID="CustomValidatorHospitalMRNumber" runat="server" OnServerValidate="ValidateHospitalMRNumber"
                                                        ValidationGroup="PatientOperationDataValidationGroup" CssClass="failureNotification"
                                                        ErrorMessage="">*</asp:CustomValidator>
                                                    <asp:RegularExpressionValidator runat="server" ID="RegularExpressionValidatorHospitlMRNumber" CssClass="failureNotification" ControlToValidate="HospitalMRNumber" ValidationExpression="^[a-z.A-Z0-9]*$"
                                                        ValidationGroup="PatientOperationDataValidationGroup" ErrorMessage="Please enter valid URN">*</asp:RegularExpressionValidator>
                                                    <asp:RequiredFieldValidator ID="URNoRequiredFieldValidator" runat="server" CssClass="failureNotification" ErrorMessage="Hospital UR Number is a required field" ControlToValidate="HospitalMRNumber" ValidationGroup="PatientPriOperationDataValidationGroup">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="OperationIdLabel" AssociatedControlID="OperationId" runat="server" Text="Operation ID" /></td>
                                                <td>
                                                    <asp:TextBox ID="OperationId" runat="server" Width="50px" Enabled="false" /></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <uc:SurgeonAndSite ID="SurgeonAndSite" runat="server" EnableMandatoryFieldValidatorForSite="true" EnableMandatoryFieldValidatorForSurgeon="true" ValidationGroupForSite="PatientOperationDataValidationGroup" ValidationGroupForSurgeon="PatientOperationDataValidationGroup" />
                                    </td>
                                </tr>

                                <asp:PlaceHolder runat="server" ID="AdmissionDischargeFields" Visible="false">
                                    <tr>
                                        <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                            <tr>
                                                <td>
                                                    <label for="AdmissionDate">Admission Date:</label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" ID="AdmissionDate" />
                                                </td>

                                                <td>
                                                    <label for="DischargeDate">Discharge Date:</label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" ID="DischargeDate" />
                                                </td>
                                            </tr>
                                        </table>
                                    </tr>
                                </asp:PlaceHolder>
                            </table>
                        </div>
                    </div>

                    <div class="sectionPanel1">
                        <div class="sectionHeader">
                            Operation Details
                        </div>
                        <div class="sectionContent">
                            <table class="tableForm" cellpadding="0" cellspacing="0" width="100%" border="0">
                                <colgroup>
                                    <col width="270px" />
                                </colgroup>
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                            <tr>
                                                <td style="width: 266px">
                                                    <asp:Label ID="OperationDateLabel" AssociatedControlID="OperationDate" runat="server" Text="Operation Date *" /></td>
                                                <td>
                                                    <div style="overflow: hidden;">
                                                        <div style="float: left">
                                                            <telerik:RadDatePicker ID="OperationDate" runat="server" Calendar-CultureInfo="en-AU" MinDate="1960-01-01" />
                                                            <asp:RequiredFieldValidator ID="OperationDateRequiredFieldValidator" runat="server" CssClass="failureNotification" ErrorMessage="Operation date is a required field" ControlToValidate="OperationDate" ValidationGroup="PatientPriOperationDataValidationGroup">*</asp:RequiredFieldValidator>
                                                            <asp:CustomValidator ID="CustomValidatorOperationDate" runat="server" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup" OnServerValidate="ValidateOperationDate" ErrorMessage="Operation date is a required field">*</asp:CustomValidator>
                                                        </div>
                                                        <div style="float: left">
                                                            &nbsp;
                                                            <asp:Image ID="imgInfo01" runat="server" ImageUrl="~/Images/info.png" />
                                                            <telerik:RadToolTip ID="rttInfo01" runat="server" TargetControlID="imgInfo01"
                                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                                AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                                <asp:Panel ID="pnrttInfo01" runat="server" Width="400px">
                                                                    <div class="form">
                                                                        <div style="padding-left: 5px">
                                                                            <asp:Label ID="lblrttInfo01" runat="server" Text="<b>Operation Date:</b> This is a Mandatory field. Please input the date of the patient’s procedure in the format of day/month/year or use the calendar to the side to pick the date." />
                                                                        </div>
                                                                    </div>
                                                                </asp:Panel>
                                                            </telerik:RadToolTip>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <asp:Label ID="AgeAtOperationLabel" AssociatedControlID="AgeAtOperation" runat="server" Text="Age at operation" /></td>
                                                <td>
                                                    <asp:TextBox ID="AgeAtOperation" runat="server" Width="70px" Enabled="false" /></td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <asp:Label ID="OperationStatusLabel" AssociatedControlID="OperationStatus" runat="server" Text="Operation Status" /></td>
                                                <td>
                                                    <div style="overflow: hidden;">
                                                        <div style="float: left">
                                                            <asp:DropDownList ID="OperationStatus" runat="server" />
                                                            <asp:CustomValidator ID="CustomValidatorOperationStatus" runat="server" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup"
                                                                OnServerValidate="ValidateOperationStatus" ErrorMessage="Operation Status is a required field">*</asp:CustomValidator>
                                                            <asp:RequiredFieldValidator ID="OpStatusRequiredFieldValidator" runat="server" CssClass="failureNotification" ErrorMessage="Operation Status is a required field" ControlToValidate="OperationStatus" ValidationGroup="PatientPriOperationDataValidationGroup">*</asp:RequiredFieldValidator>
                                                        </div>
                                                        <div style="float: left">
                                                            &nbsp;
                                                            <asp:Image ID="imgInfo02" runat="server" ImageUrl="~/Images/info.png" />
                                                            <telerik:RadToolTip ID="rttInfo02" runat="server" TargetControlID="imgInfo02"
                                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                                AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                                <asp:Panel ID="pnrttInfo02" runat="server" Width="400px">
                                                                    <div class="form">
                                                                        <div style="padding-left: 5px">
                                                                            <asp:Label ID="lblrttInfo02" runat="server" Text="<b>Operation Status:</b> This is pre-selected." />
                                                                        </div>
                                                                    </div>
                                                                </asp:Panel>
                                                            </telerik:RadToolTip>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <asp:CustomValidator ID="CustomValidatorPrimaryOperationStatus" runat="server" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup_Primary"
                                                        OnServerValidate="ValidatePrimaryOperationStatus" ErrorMessage="Operation Status is a required field">*</asp:CustomValidator>
                                                </td>
                                                <td>
                                                    <div style="overflow: hidden;">
                                                        <div style="float: left">
                                                            <asp:CheckBox runat="server" ID="AbandonedProcedure" Text="Procedure Abandoned" />
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
                                                                            <asp:Label ID="lblrttInfo03" runat="server" Text="<b>Procedure Abandoned:</b> This should be ticked if the procedure was abandoned and not completed. Please also tick 'other' on the list of primary procedures. A comments box will appear at the bottom of this list for you to include details on why it was abandoned." />
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
                                                    <asp:Label ID="ImportedOperationStatusLabel" AssociatedControlID="ImportedOperationStatus" runat="server" Text="Imported Operation Type" />
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="ImportedOperationStatus" runat="server" Width="280px" Enabled="false" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            </td>
                                </tr>
                            </table>

                            <asp:Panel ID="PrimaryProcedurePanel" runat="server" CssClass="EmbeddedViewPlaceholder" Style="display: none">
                                <table cellpadding="0" cellspacing="0">
                                    <colgroup>
                                        <col width="260px" />
                                    </colgroup>
                                    <tr>
                                        <td style="width: 50%" runat="server" id="tdPrim">
                                            <table cellpadding="0" cellspacing="0">
                                                <colgroup>
                                                    <col width="250px" />
                                                </colgroup>
                                                <tr>
                                                    <td>
                                                        <div style="overflow: hidden;">
                                                            <div style="float: left">
                                                                <asp:Label ID="PrimaryProcedureLabel" runat="server" Text="Primary Procedure *" />
                                                            </div>
                                                            <div style="float: left">
                                                                &nbsp;
                                                                <asp:Image ID="imgInfo20" runat="server" ImageUrl="~/Images/info.png" />
                                                                <telerik:RadToolTip ID="rttInfo20" runat="server" TargetControlID="imgInfo20"
                                                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                                    <asp:Panel ID="pnrttInfo20" runat="server" Width="400px">
                                                                        <div class="form">
                                                                            <div style="padding-left: 5px">
                                                                                <asp:Label ID="lblrttInfo20" runat="server" Text="<b>Primary Procedure:</b> This is a Mandatory field, if procedure is not known then select “Not stated/ inadequately described”. Please select from the 8 listed bariatric procedures or select “other” where you will be asked to specify the type of procedure being undertaken. Please note that procedures involving intraluminal devices are not included in the BSR so please do not enter." />
                                                                            </div>
                                                                        </div>
                                                                    </asp:Panel>
                                                                </telerik:RadToolTip>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <asp:CheckBoxList ID="PrimaryProcedure" runat="server" RepeatColumns="2" CellPadding="10" CellSpacing="10" />
                                                        <asp:CustomValidator ID="CustomValidatorPrimaryProcedure" runat="server"
                                                            SetFocusOnError="true" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup" ErrorMessage="Primary procedure is a required field"
                                                            OnServerValidate="ValidatePrimaryProcedure">*</asp:CustomValidator>
                                                    </td>
                                                </tr>
                                            </table>

                                            <asp:Panel ID="OtherDetailsPanel" runat="server" Style="display: none">
                                                <table cellpadding="0" cellspacing="0">
                                                    <colgroup>
                                                        <col width="260px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="OtherProcedureLabel" AssociatedControlID="OtherProcedureSpecify" runat="server" Text="Other (specify)" /></td>
                                                        <td>
                                                            <asp:TextBox ID="OtherProcedureSpecify" runat="server" Width="250px" MaxLength="250" />
                                                            <asp:CustomValidator ID="CustomValidatorOtherProcedure" runat="server" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup"
                                                                OnServerValidate="ValidateOtherProcedure" ErrorMessage="Other Procedure is a required field">*</asp:CustomValidator>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>

                            <asp:Panel ID="RevisionProcedurePanel" runat="server" CssClass="EmbeddedViewPlaceholder" Style="display: none">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <colgroup>
                                        <col width="260px" />
                                    </colgroup>
                                    <tr>
                                        <td id="tdRev" runat="server" style="width: 50%">
                                            <table cellpadding="0" cellspacing="0">
                                                <colgroup>
                                                    <col width="250px" />
                                                </colgroup>
                                                <tr>
                                                    <td>
                                                        <div style="overflow: hidden;">
                                                            <div style="float: left">
                                                                <asp:Label ID="SecondaryProcedureLabel" runat="server" Text="Revision Procedure *" />
                                                            </div>
                                                            <div style="float: left">
                                                                &nbsp;
                                                                <asp:Image ID="imgInfo04" runat="server" ImageUrl="~/Images/info.png" />
                                                                <telerik:RadToolTip ID="rttInfo04" runat="server" TargetControlID="imgInfo04"
                                                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                                    <asp:Panel ID="pnrttInfo04" runat="server" Width="400px">
                                                                        <div class="form">
                                                                            <div style="padding-left: 5px">
                                                                                <asp:Label ID="lblrttInfo04" runat="server" Text="<b>Revision Procedure:</b> This is a Mandatory field, if procedure is not known then select “Not stated/ inadequately described”. Please select from the 11 listed bariatric procedures or select “other” where you will be asked to specify the type of procedure being undertaken. Please note that procedures involving intraluminal devices are not included in the BSR so please do not enter." />
                                                                            </div>
                                                                        </div>
                                                                    </asp:Panel>
                                                                </telerik:RadToolTip>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <asp:CheckBoxList ID="SecondaryProcedure" runat="server" AutoPostBack="true" OnSelectedIndexChanged="SecondaryProcedure_SelectedIndexChanged" RepeatColumns="2" CellPadding="10" CellSpacing="10" />
                                                        <asp:CustomValidator ID="CustomValidatorSecondaryProcedure" runat="server"
                                                            SetFocusOnError="true" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup" ErrorMessage="Revision procedure is a required field"
                                                            OnServerValidate="ValidateSecondaryProcedure">*</asp:CustomValidator>
                                                    </td>
                                                </tr>
                                            </table>
                                            <asp:Panel ID="OtherRevisionPanel" runat="server" Style="display: none">
                                                <table cellpadding="0" cellspacing="0">
                                                    <colgroup>
                                                        <col width="260px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="OtherRevisionLabel" AssociatedControlID="OtherSecondarySpecify" runat="server" Text="Other (specify)" /></td>
                                                        <td>
                                                            <asp:TextBox ID="OtherSecondarySpecify" runat="server" Width="250px" MaxLength="250" />
                                                            <asp:CustomValidator ID="CustomValidatorOtherRevisionProcedure" runat="server" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup"
                                                                OnServerValidate="ValidateOtherRevisionProcedure" ErrorMessage="Other Procedure is a required field">*</asp:CustomValidator>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>

                                            <asp:Panel ID="LastBariatricProcedurePanel" runat="server" Style="display: none">
                                                <table id="Table1" cellpadding="0" cellspacing="0" runat="server">
                                                    <colgroup>
                                                        <col width="250px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td style="width: 250px">
                                                            <asp:Label ID="LastBariatricProcedureLabel" AssociatedControlID="LastBariatricProcedure" runat="server" Text="Last Major Bariatric Procedure *" /></td>
                                                        <td>
                                                            <div style="overflow: hidden;">
                                                                <div style="float: left">
                                                                    <asp:DropDownList ID="LastBariatricProcedure" runat="server" />
                                                                    <asp:CustomValidator ID="CustomValidatorLastBariatricProcedure" runat="server" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup"
                                                                        ErrorMessage="Last Major Bariatric procedure is a required field" OnServerValidate="ValidateLastBariatricProcedure">*</asp:CustomValidator>
                                                                </div>
                                                                <div style="float: left">
                                                                    &nbsp;
                                                                    <asp:Image ID="imgInfo05" runat="server" ImageUrl="~/Images/info.png" />
                                                                    <telerik:RadToolTip ID="rttInfo05" runat="server" TargetControlID="imgInfo05"
                                                                        Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                                        AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                                        <asp:Panel ID="pnrttInfo05" runat="server" Width="400px">
                                                                            <div class="form">
                                                                                <div style="padding-left: 5px">
                                                                                    <asp:Label ID="lblrttInfo05" runat="server" Text="<b>Last Major Bariatric Procedure:</b> This is a Mandatory field if the patient is a legacy patient. Please select from the list of major bariatric procedures the last known major procedure the patient has undergone (this does not include port revisions or surgical reversals).  If you are uncertain of the last major procedure, please choose 'Not Stated/ Inadequately Described'." />
                                                                                </div>
                                                                            </div>
                                                                        </asp:Panel>
                                                                    </telerik:RadToolTip>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>

                                            <asp:Panel runat="server" ID="OperationEventPanel" Style="display: none;">
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <colgroup>
                                                        <col width="250px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="OperationEventLabel" AssociatedControlID="OperationEvent" runat="server" Text="Operation *" /></td>
                                                        <td>
                                                            <asp:RadioButtonList runat="server" AutoPostBack="true" RepeatDirection="Horizontal" ID="OperationEvent">
                                                                <asp:ListItem Text="Planned" Value="1"></asp:ListItem>
                                                                <asp:ListItem Text="Unplanned" Value="2"></asp:ListItem>
                                                            </asp:RadioButtonList>
                                                            <asp:CustomValidator ID="CustomValidatorOperationEvent" runat="server" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup"
                                                                OnServerValidate="ValidateOperationEvent" ErrorMessage="Operation is a required field">*</asp:CustomValidator>
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
                                                            <asp:Label ID="FollowupReasonLabel" AssociatedControlID="LastFollowupReason" runat="server" Text="Reason *" Width="100"></asp:Label>
                                                            &nbsp;
                                                            <asp:Image ID="imgInfoReason" runat="server" ImageUrl="~/Images/info.png" />
                                                            <telerik:RadToolTip ID="RadToolTip2" runat="server" TargetControlID="imgInfoReason"
                                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                                AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                                <asp:Panel ID="Panel2" runat="server" Width="400px">
                                                                    <div class="form">
                                                                        <div style="padding-left: 5px">
                                                                            <asp:Label ID="Label2" runat="server" Text="<b>Reason:</b> This is a Mandatory field if a Sentinel Event has occurred.  Please indicate the reason(s) for the sentinel event.  If you select “Other”, you will be asked for a further explanation." />
                                                                        </div>
                                                                    </div>
                                                                </asp:Panel>
                                                            </telerik:RadToolTip>
                                                        </td>
                                                        <td>
                                                            <asp:CheckBoxList runat="server" ID="LastFollowupReason" RepeatColumns="4"></asp:CheckBoxList>
                                                            <asp:CustomValidator ID="CustomValidatorFollowupReason" runat="server" OnServerValidate="ValidateFollowupReason"
                                                                ValidationGroup="PatientOperationDataValidationGroup" CssClass="failureNotification" Enabled="false"
                                                                ErrorMessage="">*</asp:CustomValidator>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>

                                            <asp:Panel runat="server" ID="FurtherInformationPanel">
                                                <asp:Panel runat="server" ID="FurtherInformationSlipPanel">
                                                    <table border="0">
                                                        <colgroup>
                                                            <col width="255px" />
                                                        </colgroup>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="FollowupSlipLabel" AssociatedControlID="FurtherInfoSlip" runat="server" Text="Further information (Prolapse/Slip) *" Width="100"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="FurtherInfoSlip" runat="server">
                                                                </asp:DropDownList>
                                                                <asp:CustomValidator ID="CustomValidatorFollowupSlip" runat="server" OnServerValidate="ValidateFollowupSlip"
                                                                    ValidationGroup="PatientOperationDataValidationGroup" CssClass="failureNotification" Enabled="false"
                                                                    ErrorMessage="">*</asp:CustomValidator>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </asp:Panel>

                                                <asp:Panel runat="server" ID="FollowupPortPanel">
                                                    <table border="0">
                                                        <colgroup>
                                                            <col width="255px" />
                                                        </colgroup>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="FurtherInformationPortLabel" AssociatedControlID="FurtherInfoPort" runat="server" Text="Further information (Port) *" Width="100"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="FurtherInfoPort" runat="server">
                                                                </asp:DropDownList>
                                                                <asp:CustomValidator ID="CustomValidatorFurtherInformationPort" runat="server" OnServerValidate="ValidateFurtherInformationPort"
                                                                    ValidationGroup="PatientOperationDataValidationGroup" CssClass="failureNotification" Enabled="false"
                                                                    ErrorMessage="">*</asp:CustomValidator>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </asp:Panel>

                                                <asp:Panel runat="server" ID="OtherReasonPanel">
                                                    <table border="0">
                                                        <colgroup>
                                                            <col width="255px" />
                                                        </colgroup>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="OtherReasonLabel" runat="server" AssociatedControlID="OtherReasonSpecify" Text="Other reason (specify) *" />
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="OtherReasonSpecify" runat="server" Width="500px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                                                <asp:CustomValidator ID="CustomValidatorOtherReason" runat="server" OnServerValidate="ValidateOtherReason"
                                                                    ValidationGroup="PatientOperationDataValidationGroup" CssClass="failureNotification" Enabled="false"
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
                                                                <asp:Label ID="Label1" AssociatedControlID="BowelObstructionOptions" runat="server" Text="Bowel Obstruction Further Detail *" Width="100"></asp:Label>
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
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>

                            <table cellpadding="0" cellspacing="0" border="0">
                                <colgroup>
                                    <col width="275px" />
                                </colgroup>
                                <tr>
                                    <td>
                                        <asp:Label ID="PatientHeightLabel" AssociatedControlID="PatientHeight" runat="server" Text="Patient height (metres) *" />
                                    </td>
                                    <td>
                                        <telerik:RadNumericTextBox NumberFormat-DecimalDigits="2" ForeColor="Black" AllowOutOfRangeAutoCorrect="false" Width="50px" runat="server"
                                            MaxLength="4" NumberFormat-AllowRounding="false"
                                            NumberFormat-DecimalSeparator="." ID="PatientHeight" MinValue="0" MaxValue="3" />
                                        <asp:CustomValidator ID="CustomValidatorPatientHeight" runat="server" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup"
                                            OnServerValidate="ValidatePatientHeight" ErrorMessage="Patient height is a required field. Please complete Patient height or Select 'Height not known'">*</asp:CustomValidator>
                                    </td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:CheckBox ID="HeightUnknown" runat="server" Text="Height not known" />
                                            </div>
                                            <div style="float: left">
                                                &nbsp;
                                                <asp:Image ID="imgInfo06" runat="server" ImageUrl="~/Images/info.png" />
                                                <telerik:RadToolTip ID="rttInfo06" runat="server" TargetControlID="imgInfo06"
                                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                    <asp:Panel ID="pnrttInfo06" runat="server" Width="400px">
                                                        <div class="form">
                                                            <div style="padding-left: 5px">
                                                                <asp:Label ID="lblrttInfo06" runat="server" Text="<b>Patient height:</b> This is a Mandatory field unless 'Height not known' is ticked. If this patient is already enrolled on the BSR their height will appear in the box, otherwise, please enter their height in meters to 2 decimal places." />
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
                                        <asp:Label runat="server" ID="HeightWarningMessage" CssClass="failureNotification"></asp:Label>
                                    </td>
                                </tr>
                            </table>

                            <asp:Panel runat="server" ID="PatientStartWeightPanel">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <colgroup>
                                        <col width="275px" />
                                    </colgroup>
                                    <tr>
                                        <td width="268px">
                                            <asp:Label ID="PatientStartWeightLabel" AssociatedControlID="PatientStartWeight" runat="server" Text="Start weight (kgs) *" /></td>
                                        <td width="235px">
                                            <telerik:RadNumericTextBox NumberFormat-DecimalDigits="1" ForeColor="Black" AllowOutOfRangeAutoCorrect="false" Width="50px" runat="server" MaxLength="5"
                                                NumberFormat-AllowRounding="false" NumberFormat-GroupSeparator="" ID="PatientStartWeight" />
                                            <asp:CustomValidator ID="CustomValidatorPatientStartWeight" runat="server" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup"
                                                OnServerValidate="VaildatePatientStartWeight" ErrorMessage="Patient start weight is a required field. Please complete Patient start weight or Select 'Start weight not known'">*</asp:CustomValidator>
                                            <asp:CheckBox ID="SameAsOperationWeight" runat="server" Text="Same as Op weight" />
                                        </td>
                                        <td style="width: 260px">
                                            <div style="overflow: hidden;">
                                                <div style="float: left">
                                                    <asp:CheckBox ID="PatientStartWeightUnknown" runat="server" Text="Start weight not known" />
                                                </div>
                                                <div style="float: left">
                                                    &nbsp;
                                                <asp:Image ID="imgInfo21" runat="server" ImageUrl="~/Images/info.png" />
                                                    <telerik:RadToolTip ID="rttInfo21" runat="server" TargetControlID="imgInfo21"
                                                        Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                        AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                        <asp:Panel ID="pnrttInfo21" runat="server" Width="400px">
                                                            <div class="form">
                                                                <div style="padding-left: 5px">
                                                                    <asp:Label ID="lblrttInfo21" runat="server" Text="<b>Start weight:</b> This is a Mandatory field unless “Start weight not known”or “Same as Op Weight” is ticked. This is the patient’s weight at their first presentation to the surgeon for bariatric treatment in kilograms and to one decimal place. Weight must be between 35-600kg.  If you have a weight outside this range, please contact the BSR directly." />
                                                                </div>
                                                            </div>
                                                        </asp:Panel>
                                                    </telerik:RadToolTip>
                                                </div>
                                            </div>
                                        </td>
                                        <td style="width: 60px">
                                            <asp:Label ID="PatientStartBMILabel" AssociatedControlID="PatientStartBMI" runat="server" Text="Start BMI" /></td>
                                        <td>
                                            <asp:TextBox ID="PatientStartBMI" runat="server" Width="50px" Enabled="false" /></td>
                                        <td>
                                            <asp:Label runat="server" ID="StartBMIWarning" CssClass="failureNotification"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="2">
                                            <asp:Label runat="server" ID="StartWeightWarning" CssClass="failureNotification"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <table cellpadding="0" cellspacing="0" border="0">
                                <colgroup>
                                    <col width="275px" />
                                </colgroup>
                                <tr>
                                    <td>
                                        <asp:Label ID="PatientOperationWeightLabel" AssociatedControlID="PatientWeight" runat="server" Text="Patient Op weight (kgs) *" /></td>
                                    <td>
                                        <telerik:RadNumericTextBox NumberFormat-DecimalDigits="1" ForeColor="Black" AllowOutOfRangeAutoCorrect="false" Width="50px" runat="server" MaxLength="5"
                                            NumberFormat-AllowRounding="false" NumberFormat-GroupSeparator="" ID="PatientWeight" />
                                        <asp:CustomValidator ID="CustomValidatorPatientOperationWeight" runat="server" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup"
                                            OnServerValidate="ValidatePatientOperationWeight" ErrorMessage="Patient Op weight is a required field. Please complete Patient Op weight or Select 'Op weight not known'">*</asp:CustomValidator>
                                    </td>
                                    <td style="width: 435px">
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:CheckBox ID="PatientWeightUnknown" runat="server" Text="Op weight not known" />
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
                                                                <asp:Label ID="lblrttInfo07" runat="server" Text="<b>Patient Op Weight:</b> This is a Mandatory field unless “Op weight not known” is ticked. This is the patient’s weight at the time of the procedure in kilograms and to one decimal place.  Weight must be between 35-600kg.  If you have a weight outside this range, please contact the BSR directly." />
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </telerik:RadToolTip>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="width: 60px">
                                        <asp:Label ID="OperationBMILabel" AssociatedControlID="OperationBMI" runat="server" Text="Op BMI" /></td>
                                    <td>
                                        <asp:TextBox ID="OperationBMI" runat="server" Width="50px" Enabled="false" /></td>
                                    <td>
                                        <asp:Label runat="server" ID="OperationBMIWarning" CssClass="failureNotification"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="2">
                                        <asp:Label runat="server" ID="OperationWeightWarning" CssClass="failureNotification"></asp:Label>
                                    </td>
                                </tr>
                            </table>

                            <asp:Panel runat="server" ID="DiabetesPanel">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <colgroup>
                                        <col width="275px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="DiabetesStatusLabel" AssociatedControlID="DiabetesStatus" runat="server" Text="Diabetes Status *" /></td>
                                        <td>
                                            <div style="overflow: hidden;">
                                                <div style="float: left">
                                                    <asp:DropDownList ID="DiabetesStatus" runat="server" OnPreRender="DiabetesStatus_PreRender" />
                                                    <asp:CustomValidator ID="CustomValidatorDiabetesStatus" OnServerValidate="ValidateDiabetesStatus" runat="server" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup" ErrorMessage="Diabetes status is a required field">*</asp:CustomValidator>
                                                </div>
                                                <div style="float: left">
                                                    &nbsp;
                                                <asp:Image ID="imgInfo08" runat="server" ImageUrl="~/Images/info.png" />
                                                    <telerik:RadToolTip ID="rttInfo08" runat="server" TargetControlID="imgInfo08"
                                                        Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                        AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                        <asp:Panel ID="pnrttInfo08" runat="server" Width="400px">
                                                            <div class="form">
                                                                <div style="padding-left: 5px">
                                                                    <asp:Label ID="lblrttInfo08" runat="server" Text="<b>Diabetes Status:</b> This is a Mandatory field. Please indicate whether the patient identifies as having diabetes.  If it is not known, please select “not stated/ inadequately described”.  If you select “Yes” a dropdown of the type of treatment required will appear." />
                                                                </div>
                                                            </div>
                                                        </asp:Panel>
                                                    </telerik:RadToolTip>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>

                            <asp:Panel ID="DiabetesTreatmentPanel" runat="server" CssClass="EmbeddedViewPlaceholder" Style="display: none">
                                <table cellpadding="0" cellspacing="0">
                                    <colgroup>
                                        <col width="250px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <div style="overflow: hidden;">
                                                <div style="float: left">
                                                    <asp:Label ID="DiabetesTreatmentLabel" AssociatedControlID="DiabetesTreatment" runat="server" Text="Diabetes Treatment (Tick one)" />
                                                </div>
                                                <div style="float: left">
                                                    &nbsp;
                                                <asp:Image ID="imgInfo09" runat="server" ImageUrl="~/Images/info.png" />
                                                    <telerik:RadToolTip ID="rttInfo09" runat="server" TargetControlID="imgInfo09"
                                                        Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                        AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                        <asp:Panel ID="pnrttInfo09" runat="server" Width="400px">
                                                            <div class="form">
                                                                <div style="padding-left: 5px">
                                                                    <asp:Label ID="lblrttInfo09" runat="server" Text="<b>Diabetes Treatment:</b> This is a Mandatory field if you have selected “Yes” to the Diabetes Status.  Please tick the type of treatment the patient is currently undertaking for their diabetes." />
                                                                </div>
                                                            </div>
                                                        </asp:Panel>
                                                    </telerik:RadToolTip>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <asp:CheckBoxList ID="DiabetesTreatment" runat="server" />
                                            <asp:CustomValidator ID="CustomValidatorDiabetesTreatment" runat="server" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup"
                                                OnServerValidate="ValidateDiabetesTreatment" ErrorMessage="Treatment  is a required field">*</asp:CustomValidator>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>

                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                <colgroup>
                                    <col width="275px" />
                                </colgroup>
                                <tr>
                                    <td>
                                        <asp:Label ID="RenalTransplantLabel" AssociatedControlID="RenalTransplant" runat="server" Text="Renal Transplant *" /></td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:RadioButtonList ID="RenalTransplant" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" />
                                                <asp:CustomValidator Display="Dynamic" ID="CustomValidatorRenalTransplant" runat="server" CssClass="failureNotification"
                                                    ValidationGroup="PatientOperationDataValidationGroup" OnServerValidate="ValidateRenalTransplant" ErrorMessage="Renal transplant is a required field">*</asp:CustomValidator>
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
                                                                <asp:Label ID="lblrttInfo10" runat="server" Text="<b>Renal Transplant:</b> If the patient is undergoing a concurrent renal transplant, please select the “Yes” switch" />
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
                                        <asp:Label ID="LiverTransplantLabel" AssociatedControlID="LiverTransplant" runat="server" Text="Liver Transplant *" /></td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <asp:RadioButtonList ID="LiverTransplant" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" />
                                                <asp:CustomValidator ID="CustomValidatorLiverTransplant" Display="Dynamic" runat="server" CssClass="failureNotification"
                                                    ValidationGroup="PatientOperationDataValidationGroup" OnServerValidate="ValidateLiverTransplant" ErrorMessage="Liver transplant is a required field">*</asp:CustomValidator>
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
                                                                <asp:Label ID="lblrttInfo11" runat="server" Text="<b>Liver Transplant:</b> If the patient is undergoing a concurrent liver transplant, please select the “Yes” switch" />
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </telerik:RadToolTip>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>

                            <asp:Panel ID="CommentPanel" runat="server">
                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                    <colgroup>
                                        <col width="275px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="CommentLabel" AssociatedControlID="Comments" runat="server" Text="Comments" /></td>
                                        <td>
                                            <div style="overflow: hidden;">
                                                <div style="float: left">
                                                    <asp:TextBox ID="Comments" runat="server" Width="500px" TextMode="MultiLine" Rows="3" />
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
                                                                    <asp:Label ID="lblrttInfo12" runat="server" Text="<b>Comments:</b> Please add any comments you feel relevant in the space provided" />
                                                                </div>
                                                            </div>
                                                        </asp:Panel>
                                                    </telerik:RadToolTip>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            </table>
                        </div>
                    </div>

                    <div class="sectionPanel1">
                        <div class="sectionHeader">
                            Device Tracking
                        </div>
                        <table cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <div style="overflow: hidden;">
                                        <div style="float: left">
                                            <asp:Button ID="AddDeviceButton" runat="server" Text="Add Devices" CausesValidation="true" ValidationGroup="PatientOperationDataValidationGroup" OnClick="AddDeviceClicked" OnClientClick="formUnModified()" />
                                            <asp:CustomValidator ID="CustomValidatorAddDevice" runat="server"
                                                SetFocusOnError="true" CssClass="failureNotification" ValidationGroup="PatientOperationDataValidationGroup_Device" ErrorMessage="No device has been recorded for this operation"
                                                OnServerValidate="ValidateAddDevice">*</asp:CustomValidator>
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
                                                            <asp:Label ID="lblrttInfo13" runat="server" Text="<b>Add Devices:</b> This is a Mandatory field unless the procedure involves a Gastric Imbrication, Surgical Reversal or is an Other.  If the existing device is used in the procedure and not replaced, please click on Add Device and under “Device Type” select “Existing Device”.  Please note that multiple devices can be added." />
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </telerik:RadToolTip>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <asp:Label runat="server" Text="There is no device"
                                        ID="NoDeviceLabel" Style="display: none"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        <asp:Label runat="server" ID="WarningLabel" ForeColor="Red"></asp:Label>
                        <div class="sectionContent">
                            <div class="clear"></div>
                            <br />
                            <telerik:RadGrid ID="DeviceGrid" runat="server"
                                GridLines="None"
                                AllowFilteringByColumn="false" AllowPaging="True" AllowSorting="True" MasterTableView-CommandItemSettings-ShowRefreshButton="false"
                                AutoGenerateColumns="False" Width="100%" OnItemDataBound="DeviceGrid_ItemDataBound" OnPreRender="DeviceGrid_PreRender"
                                OnItemCommand="DeviceGrid_ItemCommand"
                                CellSpacing="0" PageSize="10">
                                <MasterTableView DataKeyNames="PatientOperationDevId,ParentPatientOperationDevId">
                                    <RowIndicatorColumn>
                                        <HeaderStyle Width="20px"></HeaderStyle>
                                    </RowIndicatorColumn>
                                    <ExpandCollapseColumn>
                                        <HeaderStyle Width="20px"></HeaderStyle>
                                    </ExpandCollapseColumn>

                                    <Columns>
                                        <telerik:GridButtonColumn ButtonType="LinkButton" DataTextField="PatientOperationDevId" CommandName="EditDevice" HeaderTooltip="Edit this Patient"
                                            HeaderText="Action" SortExpression="PatientOperationDevId" Text="Edit"
                                            UniqueName="EditDevice" HeaderStyle-Width="80">
                                        </telerik:GridButtonColumn>

                                        <telerik:GridBoundColumn DataField="ParentPatientOperationDevId" HeaderText="ParentPatientOperationDevId" UniqueName="ParentPatientOperationDevId" Visible="false">
                                        </telerik:GridBoundColumn>

                                        <telerik:GridBoundColumn DataField="DeviceType" HeaderText="Device Type" UniqueName="DeviceType">
                                        </telerik:GridBoundColumn>

                                        <telerik:GridBoundColumn DataField="DeviceBrand" HeaderText="Brand Name" UniqueName="BrandName">
                                        </telerik:GridBoundColumn>

                                        <telerik:GridBoundColumn DataField="DeviceDescription" HeaderText="Description" UniqueName="Description">
                                        </telerik:GridBoundColumn>

                                        <telerik:GridBoundColumn DataField="DeviceModel" HeaderText="Model" UniqueName="Model">
                                        </telerik:GridBoundColumn>

                                        <telerik:GridBoundColumn DataField="DeviceManufacturer" HeaderText="Manufacturer" UniqueName="Manufacturer">
                                        </telerik:GridBoundColumn>

                                        <telerik:GridBoundColumn DataField="LotNo" HeaderText="Serial No/Lot No" UniqueName="SerialLotNo">
                                        </telerik:GridBoundColumn>

                                        <telerik:GridButtonColumn CommandName="Delete" Text="Delete" HeaderStyle-Width="8%"
                                            UniqueName="Delete" HeaderText="">
                                            <HeaderStyle Width="8%"></HeaderStyle>
                                            <ItemStyle Width="8%" HorizontalAlign="Left" />
                                        </telerik:GridButtonColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </div>
                    </div>
                </div>
                <div>
                    <table border="0">
                        <tr>
                            <td>
                                <asp:Button ID="CancelButton" runat="server" Text="Cancel" CausesValidation="false" OnClick="CancelClicked" />
                                <asp:Button ID="SaveButton" runat="server" Text="Save" CausesValidation="true"
                                    OnClick="SaveDraftClicked" ValidationGroup="PatientOperationDataValidationGroup_Primary" />
                                <asp:Button ID="SubmitButton" runat="server" Text="Submit" CausesValidation="true" ValidationGroup="PatientOperationDataValidationGroup" OnClick="SubmitClicked" OnClientClick="formUnModified()" />
                                <asp:Button ID="ResetButton" runat="server" Text="Reset" CausesValidation="false" Visible="false" />
                                <asp:Label ID="ValidateLabel" runat="server" Visible="false" />
                            </td>
                            <td>
                                <asp:Label ID="FormSavedMessage" runat="server" Class="successNotification"></asp:Label></td>
                        </tr>
                    </table>
                </div>
                <uc3:AuditForm ID="auditForm" runat="server" />
                <asp:HiddenField runat="server" ID="hdnSurg" />
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
