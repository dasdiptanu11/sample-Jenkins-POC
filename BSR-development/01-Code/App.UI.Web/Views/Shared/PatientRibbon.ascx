<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PatientRibbon.ascx.cs" Inherits="App.UI.Web.Views.Shared.PatientRibbon" %>
<asp:UpdatePanel ID="RibbonUpdatePanel" runat="server" UpdateMode="Always">
    <ContentTemplate>
        <div class="patientInfo">
            <table border="0" width="80%" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <asp:Label ID="PatientURNumberLabel" runat="server" Text="" Font-Bold="true"></asp:Label>
                        <asp:Label ID="PatientURNumberValue" runat="server"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="PatientIdLabel" runat="server" Text="Patient ID: " Font-Bold="true"></asp:Label>
                        <asp:Label ID="PatientIdValue" runat="server"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="PatientNameLabel" runat="server" Text="Patient Name: " Font-Bold="true"></asp:Label>
                        <asp:Label ID="PatientNameValue" runat="server"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="GenderLabel" runat="server" Text="Gender: " Font-Bold="true"></asp:Label>
                        <asp:Label ID="GenderValue" runat="server"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="DateOfBirthLabel" runat="server" Text="DOB: " Font-Bold="true"></asp:Label>
                        <asp:Label ID="DateOfBirthValue" runat="server"></asp:Label>
                    </td>
                </tr>
            </table>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
