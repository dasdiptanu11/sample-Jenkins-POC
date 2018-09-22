<%@ Page Title="Recover Password" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="RecoverPassword.aspx.cs" Inherits="App.UI.Web.Views.Home.RecoverPassword" %>

<%@ Register src="../Shared/ContentHeader.ascx" tagname="ContentHeader" tagprefix="uc" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<uc:ContentHeader ID="chHeader" runat="server" Title="Recover Password" ShowSiteMapPath="false" />
    
 <div style="padding-bottom:5px;">   <asp:Label runat="server" ID="MessageNotification" CssClass="failureNotification"></asp:Label></div>

<asp:PasswordRecovery ID="PasswordRecovery" runat="server" 
UserNameTitleText="" QuestionFailureText="" UserNameFailureText="" 
onanswerlookuperror="PasswordRecovery_AnswerLookupError" 
onverifyinguser="PasswordRecovery_VerifyingUser" 
onsendingmail="PasswordRecovery_SendingMail" 
onuserlookuperror="PasswordRecovery_UserLookupError">
        <UserNameTemplate>
            <h3>
                Step 1: Enter your User ID
            </h3>

            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="PasswordRecovery" CssClass="failureNotification" DisplayMode="List"/>
            <div class="failureNotification" >
                <asp:Literal ID="FailureText" runat="server" EnableViewState="False"/>
            </div>
            <br/>
            
            <div class="form">
                <table>
                    <tr>
                        <td>
                            <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" Font-Size="Small">User ID *</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="UserName" runat="server"  Width="248px" MaxLength="50" autocomplete="off"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                ErrorMessage="Your login attempt was not successful. Please try again later." ValidationGroup="PasswordRecovery"
                                CssClass="failureNotification" Display="Dynamic">*</asp:RequiredFieldValidator>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:Button ID="CancelPushButton" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="button"
                Text="Cancel" />
            &nbsp;
 <asp:Button ID="SubmitButton" runat="server" CommandName="Submit" Text="Submit" ValidationGroup="PasswordRecovery" CssClass="button" />
        </UserNameTemplate>
    <QuestionTemplate>
        <h3>
            Step 2: Identity Confirmation (Answer your Security Question)        
        </h3>
            <asp:ValidationSummary ID="ValidationSummary2" runat="server"  CssClass="failureNotification" ValidationGroup="PasswordRecovery" DisplayMode="List"/>
            <div class="failureNotification"> 
                <asp:Literal ID="FailureText" runat="server" EnableViewState="False"/>
            </div>
            <br/>
                <div class="form">
                    <table>
                        <tr>
                            <td>
                                User ID
                            </td>
                            <td>
                                <b><asp:Literal ID="UserName" runat="server"></asp:Literal></b>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Question
                            </td>
                            <td>
                                <asp:Literal ID="Question" runat="server"></asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="AnswerLabel" runat="server" AssociatedControlID="Answer">Answer *</asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="Answer" runat="server"  MaxLength="50" autocomplete="off"></asp:TextBox>
                               <asp:RequiredFieldValidator ID="AnswerRequired" runat="server" ControlToValidate="Answer"
                                ErrorMessage="Answer is required." ValidationGroup="PasswordRecovery">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                    </table>
                </div>
         <asp:Button ID="CancelPushButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />                
                <asp:Button ID="SubmitButton" runat="server" CommandName="Submit" Text="Submit" ValidationGroup="PasswordRecovery" CssClass="button" />
               
        </QuestionTemplate>
        <SuccessTemplate>
                <br />
                <div class="successNotification">
                A new password has been sent to your email address: <asp:Label ID="lblEmail" runat="server" Font-Bold="True" OnPreRender="Email_PreRender" Text=""/>
                </div>
                <br />
                <asp:LinkButton ID="Home" runat="server" CausesValidation="False">Return to Home Page</asp:LinkButton>
        </SuccessTemplate>
    </asp:PasswordRecovery>



</asp:Content>
