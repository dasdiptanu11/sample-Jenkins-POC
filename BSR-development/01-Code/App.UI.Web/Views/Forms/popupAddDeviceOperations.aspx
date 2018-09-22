<%@ Page Title="Operation Details" Language="C#"
    AutoEventWireup="True" CodeBehind="popupAddDeviceOperations.aspx.cs" Inherits="App.UI.Web.Views.Forms.AddDeviceOperations" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="~/Styles/Site.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        html .RadComboBoxDropDown .rcbItem:nth-child(even) {
            background: #CCC;
        }

        html .RadComboBoxDropDown .rcbHovered:nth-child(even) {
            background: #3399FF;
        }

        html .RadComboBoxDropDown .rcbHovered:nth-child(odd) {
            background: #3399FF;
        }

        .RadComboBoxDropDown {
            font-size: 14px !important;
        }
    </style>
</head>
<telerik:RadCodeBlock ID="rcb" runat="server">



    <script type="text/javascript">

        function SetShowHideOtherManufacturer(sender, eventArgs) {
            if ($find("<%=Manufacturer.ClientID %>").get_value() == '-1') {
                $get("<%=OtherManfacturerPanel.ClientID%>").style.display = 'block';
            }
            else {
                $get("<%=OtherManfacturerPanel.ClientID%>").style.display = 'none';
                $get("<%=OtherManufacturer.ClientID%>").value = '';
            }
        }

        //

        function SetShowHideOtherManufacturerPrt(sender, eventArgs) {
            if ($find("<%=PortFixManufacturer.ClientID %>").get_value() == '-1') {
                $get("<%=PortFixManufacturerPanel.ClientID%>").style.display = 'block';
            }
            else {
                $get("<%=PortFixManufacturerPanel.ClientID%>").style.display = 'none';
                $get("<%=PortFixManufacturer.ClientID%>").value = '';
            }
        }

        function SetShowHideOtherModel(sender, eventArgs) {
            debugger;
            if ($find("<%=Model.ClientID %>").get_value() == '-1') {
                $get("<%=OtherModelPanel.ClientID%>").style.display = 'block';
               <%-- var item = $find("<%=rdDesc.ClientID %>").findItemByValue('-1');
                if (item) { item.select(); }
                $get("<%=pnlOtherDesc.ClientID%>").style.display = 'block';--%>
            }
            else {
                $get("<%=OtherModelPanel.ClientID%>").style.display = 'none';
                $get("<%=OtherModel.ClientID%>").value = '';
            }
        }

        function SetShowHideOtherModelPrt(sender, eventArgs) {
            if ($find("<%=PortFixModel.ClientID %>").get_value() == '-1') {
                $get("<%=PortFixOtherModelPanel.ClientID%>").style.display = 'block';
                <%--$find("<%=rdPFDesc.ClientID %>").set_value('-1');
                $get("<%=PortFixOtherDescPanel.ClientID%>").style.display = 'block';--%>
            }
            else {
                $get("<%=PortFixOtherModelPanel.ClientID%>").style.display = 'none';
                $get("<%=PortFixOtherModel.ClientID%>").value = '';
            }
        }

        function CloseWindow(status) {
            var oWindow = GetRadWindow();
            if (status == 'saved')
                ReturnVal = "true";
            else
                ReturnVal = 'false';
            oWindow.Argument = ReturnVal;
            //var oWnd = GetRadWindowManager().getWindowByName("RadWindow1");
            //var myData = "some information";
            oWindow.close();
            // oWindow.get_contentFrame().contentWindow.parent.RefreshPage();
        }

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow;
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow;
            return oWindow;
        }
    </script>
</telerik:RadCodeBlock>

<body>


    <form id="form1" runat="server">
        <asp:ScriptManager ID='scriptManager' runat='server' EnablePageMethods="true" />
        <uc:ContentHeader ID="contentHeader" runat="server" Title="Add Device" />

        <asp:UpdatePanel ID="upPatientOperations" runat="server">
            <ContentTemplate>
                <asp:ValidationSummary ID="vsDevice" runat="server" ValidationGroup="DeviceDataValidationGroup" CssClass="failureNotification" DisplayMode="List" ForeColor="Red" />

                <table width="100%" runat="server" border="0">
                    <tr>
                        <td width="50%">
                            <table border="0">
                                <colgroup>
                                    <col width="200px" />
                                </colgroup>
                                <tr>
                                    <td>

                                        <asp:Label ID="lblDeviceTyper" runat="server" Text="Device Type *"></asp:Label>
                                    </td>
                                    <td>
                                        <div style="overflow: hidden;">
                                            <div style="float: left">
                                                <telerik:RadComboBox Font-Size="14px" ID="DeviceType" runat="server" Width="200px" Height="150px" AutoPostBack="true"
                                                    OnSelectedIndexChanged="DeviceType_SelectedIndexChanged">
                                                </telerik:RadComboBox>
                                                <%-- <asp:RequiredFieldValidator ID="rfvDeviceType" runat="server" ControlToValidate="rdDeviceType" Display="Dynamic"
                                            ValidationGroup="DeviceDataValidationGroup" ErrorMessage="Device Type is a required field"
                                            CssClass="failureNotification">*</asp:RequiredFieldValidator>--%>
                                                <asp:CustomValidator ID="cvDeviceType" runat="server" CssClass="failureNotification"
                                                    ValidationGroup="DeviceDataValidationGroup" OnServerValidate="DeviceType_ServerValidate" ErrorMessage="Device Type is a required field">*</asp:CustomValidator>
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
                                                                <asp:Label ID="lblrttInfo01" runat="server" Text="<b>Device Type:</b> This is a Mandatory field please choose from the drop-down menu the type of device being implanted.  If an existing device is being used, please choose this option." />
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </telerik:RadToolTip>
                                            </div>
                                        </div>

                                    </td>
                                </tr>
                            </table>
                            <asp:Panel ID="PrimaryPortPanel" runat="server" Style="display: none">
                                <table border="0">
                                    <colgroup>
                                        <col width="200px" />
                                    </colgroup>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <asp:CheckBox ID="ChkPrimPortRet" runat="server" Text="Primary Port Retained" />
                                        </td>
                                        <td>&nbsp;
                                                <asp:Image ID="imgInfo02" runat="server" ImageUrl="~/Images/info.png" />
                                            <telerik:RadToolTip ID="rttInfo02" runat="server" TargetControlID="imgInfo02"
                                                Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                <asp:Panel ID="pnrttInfo02" runat="server" Width="400px">
                                                    <div class="form">
                                                        <div style="padding-left: 5px">
                                                            <asp:Label ID="lblrttInfo02" runat="server" Text="<b>Primary Port Retained:</b> Please tick if the primary port is retained from previous operations" />
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </telerik:RadToolTip>

                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <table border="0">
                                <colgroup>
                                    <col width="200px" />
                                </colgroup>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblBrand" AssociatedControlID="BrandName" runat="server" Text="Brand Name *"></asp:Label>
                                    </td>
                                    <td>
                                        <telerik:RadComboBox Font-Size="14px" ID="BrandName" Width="200px" runat="server" OnSelectedIndexChanged="BrandName_SelectedIndexChanged"
                                            AutoPostBack="True">
                                        </telerik:RadComboBox>
                                        <%-- <asp:RequiredFieldValidator ID="rvfrdBrand" runat="server" ControlToValidate="rdBrandName" Display="Dynamic"
                                            ValidationGroup="DeviceDataValidationGroup" ErrorMessage="Brand is a required field"
                                            CssClass="failureNotification">*</asp:RequiredFieldValidator>--%>
                                        <asp:CustomValidator ID="cvBrandName" runat="server" CssClass="failureNotification"
                                            ValidationGroup="DeviceDataValidationGroup" OnServerValidate="BrandName_ServerValidate" ErrorMessage="Brand is a required field">*</asp:CustomValidator>
                                    </td>
                                    <td>&nbsp;
                                                <asp:Image ID="imgInfo05" runat="server" ImageUrl="~/Images/info.png" />
                                        <telerik:RadToolTip ID="rttInfo05" runat="server" TargetControlID="imgInfo05"
                                            Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                            AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                            <asp:Panel ID="pnrttInfo05" runat="server" Width="400px">
                                                <div class="form">
                                                    <div style="padding-left: 5px">
                                                        <asp:Label ID="lblrttInfo05" runat="server" Text="<b>Brand Name:</b> This is a Mandatory field please choose from the drop-down menu, this will automatically populate the Manufacturer field.  If the brand is not listed, please select “Other” and additional information will be requested." />
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </telerik:RadToolTip>

                                    </td>
                                </tr>
                            </table>
                            <asp:Panel ID="OtherBrandPanel" runat="server">
                                <table border="0">
                                    <colgroup>
                                        <col width="200px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblOtherBrandName" AssociatedControlID="OtherBrandName" runat="server" Text="Other Brand Name (specify)" /></td>
                                        <td>
                                            <asp:TextBox ID="OtherBrandName" runat="server" Width="200px" />
                                            <asp:CustomValidator ID="cvOtherBrandName" runat="server" CssClass="failureNotification"
                                                ValidationGroup="DeviceDataValidationGroup" OnServerValidate="OtherBrandName_ServerValidate" ErrorMessage="Other Brand Name is a required field">*</asp:CustomValidator></td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <table border="0">
                                <colgroup>
                                    <col width="200px" />
                                </colgroup>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblDesc" AssociatedControlID="Description" runat="server" Text="Description *" /></td>
                                    <td>
                                        <telerik:RadComboBox Font-Size="14px" ID="Description" runat="server" AutoPostBack="true" Width="200px" OnSelectedIndexChanged="Description_SelectedIndexChanged" />
                                        <%--<asp:RequiredFieldValidator ID="rfDesc" runat="server" CssClass="failureNotification" ControlToValidate="rdDesc"
                                            ValidationGroup="DeviceDataValidationGroup" ErrorMessage="Description is a required field">*</asp:RequiredFieldValidator>--%>
                                        <asp:CustomValidator ID="cvDesc" runat="server" CssClass="failureNotification"
                                            ValidationGroup="DeviceDataValidationGroup" OnServerValidate="Desc_ServerValidate" ErrorMessage="Description is a required field">*</asp:CustomValidator>
                                    </td>
                                    <td>&nbsp;
                                            <asp:Image ID="imgInfo06" runat="server" ImageUrl="~/Images/info.png" />
                                        <telerik:RadToolTip ID="rttInfo06" runat="server" TargetControlID="imgInfo06"
                                            Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                            AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                            <asp:Panel ID="pnrttInfo06" runat="server" Width="400px">
                                                <div class="form">
                                                    <div style="padding-left: 5px">
                                                        <asp:Label ID="lblrttInfo06" runat="server" Text="<b>Description:</b> This is a Mandatory field please choose from the drop-down menu, this will automatically populate the Model field.  If the description is not listed, please select “Other” and additional information will be requested." />
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </telerik:RadToolTip>

                                    </td>
                                </tr>
                            </table>
                            <asp:Panel ID="OtherDescPanel" runat="server">
                                <table>
                                    <colgroup>
                                        <col width="200px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblOtherDesc" AssociatedControlID="OtherDescription" runat="server" Text="Other Description (specify)" /></td>
                                        <td>
                                            <asp:TextBox ID="OtherDescription" runat="server" Width="200px" />
                                            <asp:CustomValidator ID="cvOtherDesc" runat="server" CssClass="failureNotification"
                                                ValidationGroup="DeviceDataValidationGroup" OnServerValidate="OtherDesc_ServerValidate" ErrorMessage="Other Brand Name is a required field">*</asp:CustomValidator></td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <table>
                                <colgroup>
                                    <col width="200px" />
                                </colgroup>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblModel" AssociatedControlID="Model" runat="server" Text="Model *" /></td>
                                    <td>
                                        <telerik:RadComboBox Font-Size="14px" ID="Model" runat="server" OnClientSelectedIndexChanged="SetShowHideOtherModel" Width="200px" />
                                        <%--<asp:RequiredFieldValidator ID="rfModel" ControlToValidate="Model" runat="server" CssClass="failureNotification" ValidationGroup="DeviceDataValidationGroup"
                                            ErrorMessage="Model is a required field">*</asp:RequiredFieldValidator>--%>
                                        <asp:CustomValidator ID="cvModel" runat="server" CssClass="failureNotification"
                                            ValidationGroup="DeviceDataValidationGroup" OnServerValidate="Model_ServerValidate" ErrorMessage="Model is a required field">*</asp:CustomValidator>
                                    </td>
                                </tr>
                            </table>
                            <asp:Panel ID="OtherModelPanel" runat="server">
                                <table>
                                    <colgroup>
                                        <col width="200px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblOtherModel" AssociatedControlID="OtherModel" runat="server" Text="Other Model (specify)" /></td>
                                        <td>
                                            <asp:TextBox ID="OtherModel" runat="server" Width="200px" />
                                            <asp:CustomValidator ID="cvOtherModel" runat="server" CssClass="failureNotification"
                                                ValidationGroup="DeviceDataValidationGroup" OnServerValidate="OtherModel_ServerValidate" ErrorMessage="Other Model is a required field">*</asp:CustomValidator></td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <table>
                                <colgroup>
                                    <col width="200px" />
                                </colgroup>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblManufacturer" AssociatedControlID="Manufacturer" runat="server" Text="Manufacturer *" /></td>
                                    <td>
                                        <telerik:RadComboBox Font-Size="14px" ID="Manufacturer" runat="server" OnClientSelectedIndexChanged="SetShowHideOtherManufacturer" Width="200px" />
                                        <%--<asp:RequiredFieldValidator ID="rfManufacturer" runat="server" CssClass="failureNotification" ControlToValidate="Manufacturer"
                                            ValidationGroup="DeviceDataValidationGroup" ErrorMessage="Manufacturer is a required field">*</asp:RequiredFieldValidator>--%>
                                        <asp:CustomValidator ID="cvManufacturer" runat="server" CssClass="failureNotification"
                                            ValidationGroup="DeviceDataValidationGroup" OnServerValidate="Manufacturer_ServerValidate" ErrorMessage="Manufacturer is a required field">*</asp:CustomValidator>
                                    </td>
                                </tr>
                            </table>
                            <asp:Panel ID="OtherManfacturerPanel" runat="server">
                                <table>
                                    <colgroup>
                                        <col width="200px" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblOtherManufacturer" AssociatedControlID="OtherManufacturer" runat="server" Text="Other Manufacturer (specify)" /></td>
                                        <td>
                                            <asp:TextBox ID="OtherManufacturer" runat="server" Width="200px" />
                                            <asp:CustomValidator ID="cvOtherManufacturer" runat="server" CssClass="failureNotification"
                                                ValidationGroup="DeviceDataValidationGroup" OnServerValidate="OtherManufacturer_ServerValidate" ErrorMessage="Other Manufacturer is a required field">*</asp:CustomValidator></td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <table>
                                <colgroup>
                                    <col width="200px" />
                                </colgroup>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblSerialNoLotNo" AssociatedControlID="SerialNoLotNo" runat="server" Text="Serial No/Lot No" /></td>
                                    <td>
                                        <asp:TextBox ID="SerialNoLotNo" runat="server" Width="200px" />
                                        <%--<asp:RequiredFieldValidator ID="rdserlotnum" runat="server" ControlToValidate="txtSerialNoLotNo" CssClass="failureNotification" ValidationGroup="DeviceDataValidationGroup"
                                            ErrorMessage="Serial No/Lot No is a required field">*</asp:RequiredFieldValidator>--%>
                                        <%--<asp:CustomValidator ID="cvserlotnum" runat="server" CssClass="failureNotification"
                                                ValidationGroup="DeviceDataValidationGroup" OnServerValidate="SerialLot_ServerValidate" ErrorMessage="Serial No/Lot No is a required field">*</asp:CustomValidator>--%>
                                    </td>
                                    <%--<td>
                                        &nbsp;
                                                <asp:Image ID="imgInfo07" runat="server" ImageUrl="~/Images/info.png" />
                                                <telerik:RadToolTip ID="rttInfo07" runat="server" TargetControlID="imgInfo07"
                                                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                    <asp:Panel ID="pnrttInfo07" runat="server" Width="400px">
                                                        <div class="form">
                                                            <div style="padding-left: 5px">
                                                                <asp:Label ID="lblrttInfo07" runat="server" Text="<b>Serial No/Lot No:</b> This is a Mandatory field please input the serial or lot number of the device being implanted." />
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </telerik:RadToolTip>

                                    </td>--%>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <table border="0">
                                <tr>
                                    <td>
                                        <asp:Panel runat="server" ID="ButtressPanel" Style="display: none" CssClass="EmbeddedViewPlaceholder">
                                            <table width="100%">
                                                <colgroup>
                                                    <col width="200px" />
                                                </colgroup>
                                                <tr id="trButress">
                                                    <td>
                                                        <asp:Label ID="lblButress" AssociatedControlID="Buttress" runat="server" Text="Buttress" /></td>
                                                    <td>
                                                        <asp:RadioButtonList ID="Buttress" runat="server" RepeatDirection="Horizontal" />
                                                        <asp:CustomValidator ID="cvButress" runat="server" CssClass="failureNotification" ValidationGroup="DeviceDataValidationGroup"
                                                            OnServerValidate="Butress_ServerValidate" ErrorMessage="Buttress is a required field">*</asp:CustomValidator>
                                                    </td>
                                                    <td>&nbsp;
                                                        <asp:Image ID="imgInfo04" runat="server" ImageUrl="~/Images/info.png" />
                                                        <telerik:RadToolTip ID="rttInfo04" runat="server" TargetControlID="imgInfo04"
                                                            Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                            AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                            <asp:Panel ID="pnrttInfo04" runat="server" Width="400px">
                                                                <div class="form">
                                                                    <div style="padding-left: 5px">
                                                                        <asp:Label ID="lblrttInfo04" runat="server" Text="<b>Buttress:</b> This is a Mandatory field please indicate if a buttress is being used with the stapling device." />
                                                                    </div>
                                                                </div>
                                                            </asp:Panel>
                                                        </telerik:RadToolTip>

                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                        <asp:Panel runat="server" ID="PortFixPanel" Style="display: none" CssClass="EmbeddedViewPlaceholder">
                                            <table width="100%">
                                                <colgroup>
                                                    <col width="200px" />
                                                </colgroup>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblPrtFixMethod" AssociatedControlID="PortFixMethod" runat="server" Text="Port Fixation Method" /></td>
                                                    <td>
                                                        <telerik:RadComboBox Font-Size="14px" ID="PortFixMethod" runat="server" AutoPostBack="true" OnSelectedIndexChanged="PortFixMethod_SelectedIndexChanged" Width="170px" />
                                                        <asp:CustomValidator ID="cvPrtFixMethod" runat="server" CssClass="failureNotification"
                                                            ValidationGroup="DeviceDataValidationGroup" OnServerValidate="PrtFixMethod_ServerValidate" ErrorMessage="Port Fixation Method is a required field">*</asp:CustomValidator>

                                                    </td>
                                                    <td>&nbsp;
                                                        <asp:Image ID="imgInfo03" runat="server" ImageUrl="~/Images/info.png" />
                                                        <telerik:RadToolTip ID="rttInfo03" runat="server" TargetControlID="imgInfo03"
                                                            Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                                                            AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                                                            <asp:Panel ID="pnrttInfo03" runat="server" Width="400px">
                                                                <div class="form">
                                                                    <div style="padding-left: 5px">
                                                                        <asp:Label ID="lblrttInfo03" runat="server" Text="<b>Port Fixation Method:</b> This is a Mandatory field please choose from the drop-down menu." />
                                                                    </div>
                                                                </div>
                                                            </asp:Panel>
                                                        </telerik:RadToolTip>
                                                    </td>
                                                </tr>
                                            </table>
                                            <asp:Panel ID="AccessPortPanel" runat="server" Style="display: none">
                                                <table width="100%">
                                                    <colgroup>
                                                        <col width="200px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lblPFBrandName" AssociatedControlID="PortFixBrandName" runat="server" Text="Brand Name *" /></td>
                                                        <td>
                                                            <telerik:RadComboBox Font-Size="14px" ID="PortFixBrandName" runat="server" AutoPostBack="true" OnSelectedIndexChanged="PortFixBrandName_SelectedIndexChanged" Width="200px" />
                                                            <asp:CustomValidator ID="cvPFBrandName" runat="server" CssClass="failureNotification"
                                                                ValidationGroup="DeviceDataValidationGroup" OnServerValidate="PFBrandName_ServerValidate" ErrorMessage="Brand Name is a required field">*</asp:CustomValidator></td>
                                                    </tr>
                                                </table>
                                                <asp:Panel ID="PortFixOtherBrandPanel" runat="server" Style="display: none">
                                                    <table cellpadding="0" cellspacing="0">
                                                        <colgroup>
                                                            <col width="205px" />
                                                        </colgroup>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="lblPFOtherBrandName" AssociatedControlID="PortFixOtherBrandName" runat="server" Text="Other Brand Name (specify)" /></td>
                                                            <td>
                                                                <asp:TextBox ID="PortFixOtherBrandName" runat="server" Width="200px" />
                                                                <asp:CustomValidator ID="cvPFOtherBrandName" runat="server" CssClass="failureNotification"
                                                                    ValidationGroup="DeviceDataValidationGroup" OnServerValidate="PFOtherBrandName_ServerValidate" ErrorMessage="Other Brand name is a required field">*</asp:CustomValidator></td>
                                                        </tr>
                                                    </table>
                                                </asp:Panel>
                                                <table>
                                                    <colgroup>
                                                        <col width="200px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lblPFDesc" AssociatedControlID="PortFixDescription" runat="server" Text="Description *" /></td>
                                                        <td>
                                                            <telerik:RadComboBox Font-Size="14px" ID="PortFixDescription" runat="server" AutoPostBack="true" OnSelectedIndexChanged="PortFixDescription_SelectedIndexChanged" Width="200px" />
                                                            <asp:CustomValidator ID="cvPFDesc" runat="server" CssClass="failureNotification"
                                                                ValidationGroup="DeviceDataValidationGroup" OnServerValidate="PFDesc_ServerValidate" ErrorMessage="Description is a required field">*</asp:CustomValidator></td>
                                                    </tr>
                                                </table>
                                                <asp:Panel ID="PortFixOtherDescPanel" runat="server" Style="display: none">
                                                    <table cellpadding="0" cellspacing="0">
                                                        <colgroup>
                                                            <col width="205px" />
                                                        </colgroup>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="lblPFDescOther" AssociatedControlID="PortFixOtherDesc" runat="server" Text="Other Description (specify)" /></td>
                                                            <td>
                                                                <asp:TextBox ID="PortFixOtherDesc" runat="server" Width="200px" />
                                                                <asp:CustomValidator ID="cvPFDescOther" runat="server" CssClass="failureNotification"
                                                                    ValidationGroup="DeviceDataValidationGroup" OnServerValidate="PFDescOther_ServerValidate" ErrorMessage="Other Brand name is a required field">*</asp:CustomValidator></td>
                                                        </tr>
                                                    </table>
                                                </asp:Panel>
                                                <table>
                                                    <colgroup>
                                                        <col width="200px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lblPFModel" AssociatedControlID="PortFixModel" runat="server" Text="Model *" /></td>
                                                        <td>
                                                            <telerik:RadComboBox Font-Size="14px" ID="PortFixModel" runat="server" OnClientSelectedIndexChanged="SetShowHideOtherModelPrt" Width="200px" />
                                                            <asp:CustomValidator ID="cvPFModel" runat="server" CssClass="failureNotification" ValidationGroup="DeviceDataValidationGroup"
                                                                OnServerValidate="PFModel_ServerValidate" ErrorMessage="Model is a required field">*</asp:CustomValidator></td>
                                                    </tr>
                                                </table>
                                                <asp:Panel ID="PortFixOtherModelPanel" runat="server">
                                                    <table cellpadding="0" cellspacing="0">
                                                        <colgroup>
                                                            <col width="205px" />
                                                        </colgroup>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="lblPFOtherModel" AssociatedControlID="PortFixOtherModel" runat="server" Text="Other Model (specify)" /></td>
                                                            <td>
                                                                <asp:TextBox ID="PortFixOtherModel" runat="server" Width="200px" />
                                                                <asp:CustomValidator ID="cvPFOtherModel" runat="server" CssClass="failureNotification"
                                                                    ValidationGroup="DeviceDataValidationGroup" OnServerValidate="PFOtherModel_ServerValidate" ErrorMessage="Other Model is a required field">*</asp:CustomValidator></td>
                                                        </tr>
                                                    </table>
                                                </asp:Panel>
                                                <table>
                                                    <colgroup>
                                                        <col width="200px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lblPFManufacturer" AssociatedControlID="PortFixManufacturer" runat="server" Text="Manufacturer *" /></td>
                                                        <td>
                                                            <telerik:RadComboBox Font-Size="14px" ID="PortFixManufacturer" runat="server" OnClientSelectedIndexChanged="SetShowHideOtherManufacturerPrt" Width="200px" />
                                                            <asp:CustomValidator ID="cvPFManufacturer" runat="server" CssClass="failureNotification" ValidationGroup="DeviceDataValidationGroup"
                                                                OnServerValidate="PFManufacturer_ServerValidate" ErrorMessage="Manufacturer is a required field">*</asp:CustomValidator>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:Panel ID="PortFixManufacturerPanel" runat="server">
                                                    <table cellpadding="0" cellspacing="0">
                                                        <colgroup>
                                                            <col width="205px" />
                                                        </colgroup>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="lblPFOtherManufacturer" AssociatedControlID="PortFixOtherManufacturer" runat="server" Text="Other Manufacturer (specify)" /></td>
                                                            <td>
                                                                <asp:TextBox ID="PortFixOtherManufacturer" runat="server" Width="200px" />
                                                                <asp:CustomValidator ID="cvPFOtherManufacturer" runat="server" CssClass="failureNotification"
                                                                    ValidationGroup="DeviceDataValidationGroup" OnServerValidate="PFOtherManufacturer_ServerValidate" ErrorMessage="Other Model is a required field">*</asp:CustomValidator></td>
                                                        </tr>
                                                    </table>
                                                </asp:Panel>
                                                <table>
                                                    <colgroup>
                                                        <col width="200px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lblPFSerialNoLotNo" AssociatedControlID="PortFixSerialNoLotNo" runat="server" Text="Serial No/Lot No" /></td>
                                                        <td>
                                                            <asp:TextBox ID="PortFixSerialNoLotNo" runat="server" Width="200px" />
                                                            <%-- <asp:CustomValidator ID="cvPFSerialNoLotNo" runat="server" CssClass="failureNotification" ValidationGroup="DeviceDataValidationGroup"
                                                                OnServerValidate="PFSerialNoLotNo_ServerValidate" ErrorMessage="Serial No/Lot No is a required field">*</asp:CustomValidator>--%>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>
                                        </asp:Panel>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 15px"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td align="center">
                            <table>
                                <tr>
                                    <td>
                                        <asp:Button runat="server" Text="Cancel" ID="btnCancel" Width="90px" OnClientClick="CloseWindow('close')" />
                                    </td>
                                    <td>
                                        <asp:Button ID="AddDevices" runat="server" Text="Add" Width="90px" ValidationGroup="DeviceDataValidationGroup" OnClick="Submit_Click" />
                                    </td>


                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="NotifyMessage" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>

                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
        <%--    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="progressBackgroundFilter" class="progressBackgroundFilter">
            </div>
            <div id="processMessage" class="processMessage">
                <img alt="Loading" src="../../App_Themes/_Shared/Wait.gif" />
                &nbsp;&nbsp; Loading...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>--%>
    </form>
</body>
</html>
