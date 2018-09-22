<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchControl.ascx.cs" Inherits="App.UI.Web.Views.SearchControl" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
    <script type="text/javascript">
        
    </script>
</telerik:RadCodeBlock>

<table width="100%">
    <tr>
        <td align="right">
            <asp:Label ID="SurgeonLabel" runat="server" Text="Surgeon" Font-Bold="true"></asp:Label>
        </td>
        <td>
            <telerik:RadComboBox ID="SurgeonSelection" runat="server"  Width="320px" Height="150px" CheckBoxes="true"
                AutoCompleteSeparator="," ItemsSource="{Binding Source={StaticResource DataSource}, Path=Agency}" DisplayMemberPath="Name" EnableCheckAllItemsCheckBox="True" EmptyMessage="None selected" Localization-CheckAllString="Select All" Localization-AllItemsCheckedString="All items selected" Localization-ItemsCheckedString="items selected">
            </telerik:RadComboBox>
        </td>
    </tr>

    <tr>
        <td align="right">
            <asp:Label ID="SiteLabel" runat="server" Text="Site" Font-Bold="true"></asp:Label>
        </td>
        <td>
            <telerik:RadComboBox ID="SiteSelection" runat="server"  Width="320px" Height="150px" CheckBoxes="true"
                AutoCompleteSeparator="," ItemsSource="{Binding Source={StaticResource DataSource}, Path=Agency}" DisplayMemberPath="Name" EnableCheckAllItemsCheckBox="True" EmptyMessage="None selected" Localization-CheckAllString="Select All"   Localization-AllItemsCheckedString="All items selected" Localization-ItemsCheckedString="items selected">
            </telerik:RadComboBox>
        </td>
    </tr>


    </table>

<asp:Panel ID="TreatmentSearchPanel"  Visible="false" runat="server">
    <table width="100%">

    <tr>
        <td align="right">
            <asp:Label ID="TreatmentCliniciansLabel" runat="server" Text="Treatment Clinicians" Font-Bold="true" ></asp:Label>
        </td>
        <td>
            <telerik:RadComboBox ID="TreatmentClinicians" runat="server"  Width="320px" Height="150px" CheckBoxes="true" 
                AutoCompleteSeparator="," ItemsSource="{Binding Source={StaticResource DataSource}, Path=Agency}" DisplayMemberPath="Name" EnableCheckAllItemsCheckBox="True" EmptyMessage="None selected" Localization-CheckAllString="Select All" Localization-AllItemsCheckedString="All items selected" Localization-ItemsCheckedString="items selected">
            </telerik:RadComboBox>
        </td>
    </tr>
    <tr>
        <td align="right">
            <asp:Label ID="TreatmentInstitutionsLabel" runat="server" Text="Treatment Institutions" Font-Bold="true" ></asp:Label>
        </td>
        <td>
            <telerik:RadComboBox ID="TreatmentInstitutions" runat="server"  Width="320px" Height="150px" CheckBoxes="true" 
                AutoCompleteSeparator="," ItemsSource="{Binding Source={StaticResource DataSource}, Path=Agency}" DisplayMemberPath="Name" EnableCheckAllItemsCheckBox="True" EmptyMessage="None selected" Localization-CheckAllString="Select All" Localization-AllItemsCheckedString="All items selected" Localization-ItemsCheckedString="items selected">
            </telerik:RadComboBox>
        </td>
    </tr>
</table>
</asp:Panel>