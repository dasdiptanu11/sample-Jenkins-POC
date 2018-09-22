<%@ Page Title="Change Security Question" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="ChangeSecurityQuestion.aspx.cs" Inherits="App.UI.Web.Views.AccountSetting.ChangeSecurityQuestion" %>

<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <uc:ContentHeader ID="chHeader" runat="server" Title="Change Security Question" />
    <br />
    <asp:Label ID="WarningNotification" runat="server" OnPreRender="WarningNotification_PreRender" CssClass="warningNotification" />


    <asp:MultiView ID="MultiView" runat="server">
        <asp:View ID="View1" runat="server">
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="failureNotification" ValidationGroup="ChangePassword1" DisplayMode="List" />
            <div class="failureNotification">
                <asp:Literal ID="FailureText" runat="server" EnableViewState="False" />
            </div>
            <br />
            <div class="form" style="width: 40%">
                <table>
                    <tr>
                        <td>
                            <asp:Label ID="Label2" runat="server" Text="User ID"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="LoggedInUser" runat="server"
                                OnPreRender="LoggedInUser_PreRender" Font-Bold="True" Font-Italic="False"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblPassword" runat="server" Text="Password: *"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="Password" runat="server" TextMode="Password" MaxLength="50" autocomplete="off"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="Password" CssClass="failureNotification"
                                ErrorMessage="Password is required" ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblQuestion" runat="server" Text="Question: *"></asp:Label>
                        </td>
                        <td>
                           <%-- <asp:TextBox ID="txtQuestion" runat="server" OnPreRender="txtQuestion_PreRender" autocomplete="off"></asp:TextBox>--%>
                            
                            <asp:DropDownList ID="Question" runat="server" OnPreRender="Question_PreRender"></asp:DropDownList>

                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="Question" CssClass="failureNotification"
                                ErrorMessage="Security Question not entered" ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="cvQuestion" runat="server" ControlToValidate="Question" CssClass="failureNotification"
                                ErrorMessage="You must change your question" ValidationGroup="ChangePassword1" OnServerValidate="Question_ServerValidate">*</asp:CustomValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblAnswer" runat="server" Text="Answer: *"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="Answer" runat="server" MaxLength="50" autocomplete="off"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvAnswer" runat="server" ControlToValidate="Answer" CssClass="failureNotification"
                                ErrorMessage="Answer to security question must be entered" ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="cvAnswer" runat="server" ControlToValidate="Answer" CssClass="failureNotification"
                                ErrorMessage="Answer cannot be 'yes' or 'no'" ValidationGroup="ChangePassword1" OnServerValidate="Answer_ServerValidate">*</asp:CustomValidator>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:Button ID="CancelPushButton" runat="server" CausesValidation="False" CommandName="Cancel"
                Text="Cancel" />
            <asp:Button ID="ChangeQuestionPushButton" runat="server"
                Text="Save" CausesValidation="true" ValidationGroup="ChangePassword1"
                OnClick="ChangeQuestionPushButton_Click" />

        </asp:View>
        <asp:View ID="View2" runat="server">
            <div class="successNotification">
                <asp:Label ID="lblStatus" runat="server" Text="Your security question and answer have been successfully changed!" />
            </div>
            <br />
        </asp:View>
    </asp:MultiView>
</asp:Content>
