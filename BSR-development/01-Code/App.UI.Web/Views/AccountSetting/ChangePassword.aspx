<%@ Page Title="Change Password" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="App.UI.Web.Views.AccountSetting.ChangePassword" %>

<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <uc:ContentHeader ID="chHeader" runat="server" Title="Change Password" />
    <br />
   <div style="padding-bottom:10px;"> <asp:Label ID="WarningNotification" runat="server" OnPreRender="WarningNotification_PreRender" CssClass="warningNotification" /></div>

    <asp:ChangePassword ID="Password" runat="server"
        OnChangePasswordError="Password_ChangeError"
        OnChangedPassword="Password_Changed"
       >
        <ChangePasswordTemplate>
            <%--ValidationGroup="Password"--%>

            <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="failureNotification" ValidationGroup="Password" DisplayMode="List"  />
            <div class="failureNotification">
                <asp:Literal ID="FailureText" runat="server" EnableViewState="False" />
            </div>
            <br />
            <asp:Panel ID="pn_password" runat="server" CssClass="form" DefaultButton="ChangePasswordPushButton">

                <table>
                    <table>
                        <tr>
                            <td>
                                <asp:Label ID="Label2" runat="server" Text="User ID" />
                            </td>
                            <td>
                                <asp:Label ID="UserName" runat="server" Font-Bold="True" OnPreRender="UserName_PreRender" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="CurrentPasswordLabel" runat="server" AssociatedControlID="CurrentPassword">Password *</asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="CurrentPassword" runat="server" autocomplete="off" TextMode="Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="CurrentPasswordRequired" runat="server" ControlToValidate="CurrentPassword" CssClass="failureNotification" Display="Dynamic" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="Password">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="NewPasswordLabel" runat="server" AssociatedControlID="NewPassword">New Password *</asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="NewPassword" runat="server" autocomplete="off" TextMode="Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="NewPasswordRequired" runat="server" ControlToValidate="NewPassword" CssClass="failureNotification" Display="Dynamic" ErrorMessage="New password is required." ToolTip="New password is required." ValidationGroup="Password">*</asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="NewPassword" CssClass="failureNotification" Display="Dynamic" ErrorMessage="Password need to be 8 characters in length minimum with at least 1 number, 1 letter and 1 special character." ValidationExpression="^(?=(.*\d))(?=(.*\W)).{8,}" ValidationGroup="Password">*</asp:RegularExpressionValidator>
                                <asp:CompareValidator ID="cvNewCurrent" runat="server" ControlToCompare="CurrentPassword" ControlToValidate="NewPassword" CssClass="failureNotification" Display="Dynamic" ErrorMessage="New password cannot be the same as current password." Operator="NotEqual" ValidationGroup="Password">*</asp:CompareValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="ConfirmNewPasswordLabel" runat="server" AssociatedControlID="ConfirmNewPassword">Confirm New Password *</asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="ConfirmNewPassword" runat="server" autocomplete="off" TextMode="Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" runat="server" ControlToValidate="ConfirmNewPassword" CssClass="failureNotification" Display="Dynamic" ErrorMessage="Confirm new password is required." ToolTip="Confirm new password is required." ValidationGroup="Password">*</asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="NewPasswordCompare" runat="server" ControlToCompare="NewPassword" ControlToValidate="ConfirmNewPassword" CssClass="failureNotification" Display="Dynamic" ErrorMessage="The confirm new password must match the new password entry." ValidationGroup="Password">*</asp:CompareValidator>
                            </td>
                        </tr>
                    </table>
                    <td>
                        <table>
                            <tr>
                                <td></td>
                            </tr>
                            <tr>
                                <td></td>
                            </tr>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;Password needs to be 8 characters in length and include
                                    <br />
                                    &nbsp;&nbsp;&nbsp;at least 1 number, 1 letter and 1 special character ~!@#$%^&amp;*()</td>
                            </tr>
                            <tr>
                                <td></td>
                            </tr>
                        </table>
                    </td>
                </table>
                <asp:Button ID="CancelPushButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" PostBackUrl="~/Default.aspx" />
                <asp:Button ID="ChangePasswordPushButton" runat="server" CommandName="ChangePassword" Text="Save" ValidationGroup="Password" />


            </asp:Panel>
        </ChangePasswordTemplate>
        <SuccessTemplate>
            <br />
            <div class="successNotification">
                <asp:Label ID="lblStatus" runat="server" Text="Your password has been successfully changed!" />
            </div>
            <br />
            To ensure maximum security, you are encouraged to change your security question.
        <br />
            <br />
            The security question is used to establish your identity in the event that you lose your password.
        <br />
            <br />
            <asp:Button ID="bChangeQuestion" runat="server" Text="Change Security Question" />
        </SuccessTemplate>
    </asp:ChangePassword>

</asp:Content>
