<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="App.UI.Web.Views.Forms.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ValidationSummary ID="vsPatient" runat="server" ValidationGroup="PatientDataValidationGroup"
        CssClass="failureNotification" HeaderText="" DisplayMode="List" />
    <asp:Panel runat="server" ID="pn_PatitentSearch" Visible="true">
        <table border="0">
            <colgroup>
                <col width="220px" />
            </colgroup>
            <tr>
                <td colspan="4">
                    <asp:Label ID="PatientMessage" runat="server" Visible="false" CssClass="failureNotification" /></td>
            </tr>
            <tr>
                <td colspan="4">
                    <br />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblPatient_Site" runat="server" AssociatedControlID="PatientSiteId" Text="Site *" /></td>
                <td colspan="3">
                    <asp:DropDownList ID="PatientSiteId" runat="server" />
                    <asp:RequiredFieldValidator ID="rfvPatient_Site" runat="server" CssClass="failureNotification" ValidationGroup="PatientDataValidationGroup" ControlToValidate="PatientSiteId"
                        ErrorMessage="Site is missing">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblPatient_URN" runat="server" AssociatedControlID="PatientUrn" Text="URN *" /></td>
                <td>
                    <asp:TextBox ID="PatientUrn" runat="server" />
                    <asp:RequiredFieldValidator ID="rfvPatient_URN" runat="server" ControlToValidate="PatientUrn" CssClass="failureNotification" ErrorMessage="URN missing" ValidationGroup="PatientDataValidationGroup">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator runat="server" ID="revPatient_URN" CssClass="failureNotification" ControlToValidate="PatientUrn" ValidationExpression="^[a-zA-Z0-9]*$"
                        ValidationGroup="PatientDataValidationGroup" ErrorMessage="Please enter valid URN">*</asp:RegularExpressionValidator>
                </td>
                <td></td>
            </tr>
            <tr runat="server" id="tr_addPatient" visible="true">
                <td></td>
                <td>
                    <asp:Button ID="btnCheck" runat="server" Text="Check" OnClick="CheckPatient_Click" ValidationGroup="PatientDataValidationGroup" />
                </td>
                <td>
                    <asp:Button ID="AddPatient" runat="server" Text="Add Patient" OnClick="AddPatient_Click" Visible="false" ValidationGroup="PatientDataValidationGroup" />
                </td>
            </tr>

        </table>
    </asp:Panel>
</asp:Content>
