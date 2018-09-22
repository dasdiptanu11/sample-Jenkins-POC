<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SurgeonAndSite.ascx.cs" Inherits="App.UI.Web.Views.Shared.SurgeonAndSite" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Table ID="TableHospitalAndSurgeons" runat="server" CellPadding="0" CellSpacing="0">
    <asp:TableRow ID="Row1">

        <asp:TableCell ID="SiteLabelColumn" Width="145">
            <asp:Label ID="SiteLabel" runat="server" Text="Hospital"></asp:Label>
        </asp:TableCell>
        <asp:TableCell>
            <asp:Label ID="SpaceSiteLabel" runat="server" Text=""></asp:Label>
        </asp:TableCell>

        <asp:TableCell ID="SiteOptionsColumn">
            <div style="float: left">
                <asp:DropDownList ID="SiteOptions" EnableViewState="true" runat="server" Width="200" TabIndex="1" OnSelectedIndexChanged="SiteOptions_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                <asp:CustomValidator ID="CustomValidatorSiteOptions" runat="server" CssClass="failureNotification"
                    ErrorMessage="Site is a required field" OnServerValidate="ValidateSiteOptions">*</asp:CustomValidator>
                <asp:RequiredFieldValidator ID="SiteRequiredFieldValidator" runat="server" CssClass="failureNotification" ErrorMessage="Site is a required field" ControlToValidate="SiteOptions"
                    ValidationGroup="PatientPriOperationDataValidationGroup">*</asp:RequiredFieldValidator>
            </div>
            <div style="float: left">
                &nbsp;
                <asp:Image ID="SiteOptionsInformationImage" runat="server" ImageUrl="~/Images/info.png" Visible="false" />
                <telerik:RadToolTip ID="rttInfoSite" runat="server" TargetControlID="SiteOptionsInformationImage"
                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                    <asp:Panel ID="pnrttInfoSite" runat="server" Width="400px">
                        <div class="form">
                            <div style="padding-left: 5px">
                                <asp:Label ID="SiteOptionsInformationLabel" runat="server" Text="" />
                            </div>
                        </div>
                    </asp:Panel>
                </telerik:RadToolTip>
            </div>
        </asp:TableCell>

    </asp:TableRow>

    <asp:TableRow ID="Row2">

        <asp:TableCell ID="SurgeonLabelColumn">
            <asp:Label ID="SurgeonLabel" runat="server" Text="Surgeon"></asp:Label>
        </asp:TableCell>

        <asp:TableCell>
            <asp:Label ID="SpaceSurgeonLabel" runat="server" Text=""></asp:Label>
        </asp:TableCell>

        <asp:TableCell ID="SurgeonOptionsColumn">
            <div style="float: left">
                <asp:DropDownList ID="SurgeonOptions" EnableViewState="true" runat="server" AutoPostBack="True" TabIndex="2" Width="200"></asp:DropDownList>
                <asp:CustomValidator ID="CustomValidatorSurgeon" runat="server" CssClass="failureNotification"
                    ErrorMessage="Surgeon is a required field" OnServerValidate="ValidateSurgeonOptions">*</asp:CustomValidator>
                <asp:RequiredFieldValidator ID="SurgeonRequiredFieldValidator" runat="server" CssClass="failureNotification" ErrorMessage="Surgeon is a required field" ControlToValidate="SurgeonOptions" ValidationGroup="PatientPriOperationDataValidationGroup">*</asp:RequiredFieldValidator>
            </div>
            <div style="float: left">
                &nbsp;
                <asp:Image ID="SurgeonOptionsInformationImage" runat="server" ImageUrl="~/Images/info.png" Visible="false" />
                <telerik:RadToolTip ID="rttInfoSurgeon" runat="server" TargetControlID="SurgeonOptionsInformationImage"
                    Position="TopRight" HideEvent="LeaveTargetAndToolTip"
                    AutoCloseDelay="0" ShowEvent="OnMouseOver" ShowDelay="1">
                    <asp:Panel ID="pnrttInfoSurgeon" runat="server" Width="400px">
                        <div class="form">
                            <div style="padding-left: 5px">
                                <asp:Label ID="SurgeonOptionsInformationLabel" runat="server" Text="" />
                            </div>
                        </div>
                    </asp:Panel>
                </telerik:RadToolTip>
            </div>
        </asp:TableCell>

    </asp:TableRow>

</asp:Table>


