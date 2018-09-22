<%@ Page Title="Change Email" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="ChangeEmail.aspx.cs" Inherits="App.UI.Web.Views.AccountSetting.ChangeEmail" %>

<%@ Register src="../Shared/ContentHeader.ascx" tagname="ContentHeader" tagprefix="uc" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<uc:ContentHeader ID="chHeader" runat="server" Title="Change Email" />

<br />
    <asp:MultiView ID="MultiView" runat="server">
        <asp:View ID="View1" runat="server">
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="failureNotification" DisplayMode="List"/>
            <div class="form" style="width:40%;">
                <table >
                    <tr>
                        <td>
                            <asp:Label ID="Label2" runat="server" Text="User ID"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="LoggedInUser" runat="server" onprerender="LoggedInUser_PreRender" 
                                Font-Bold="True"></asp:Label> 
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="Label1" runat="server" Text="Password *"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="Password" runat="server" TextMode="Password" Width="203px" autocomplete="off"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="Password"
                                ErrorMessage="Password must be entered" CssClass="failureNotification">*</asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblEmail" runat="server" Text="Email *"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="Email" runat="server" MaxLength="150" autocomplete="off"
                                onprerender="Email_PreRender" Width="247px"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="Email" CssClass="failureNotification"
                                ErrorMessage="Email must be entered">*</asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="rexEmail" runat="server" ControlToValidate="Email"
                                Display="Dynamic" ErrorMessage="Invalid email address" CssClass="failureNotification"
                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">*</asp:RegularExpressionValidator>
                        </td>
                    </tr>
                </table>
            </div>
                <asp:Button ID="CancelPushButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
        <asp:Button ID="ChangeEmailPushButton" runat="server" Text="Save" onclick="ChangeEmailPushButton_Click" />
    

        </asp:View>
        <asp:View ID="View2" runat="server">
            <div class="successNotification">
                <asp:Label ID="lblStatus" runat="server" Text="Your email address has been successfully changed!" />
            </div>
        </asp:View>
    </asp:MultiView><br />

</asp:Content>
