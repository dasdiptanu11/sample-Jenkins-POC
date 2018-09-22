<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Login.ascx.cs" Inherits="App.UI.Web.Views.Home.LoginUserControl" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Login ID="LoginUser" runat="server" EnableViewState="false"
    RenderOuterTable="false" FailureText="" 
    OnLoginError="LoginUser_LoginError" OnLoggedIn="LoginUser_LoggedIn" OnAuthenticate="Authenticate_Login">
    <LayoutTemplate>
        <div>
            <div class="loginPanel" >
                <div class="panelHeading">
                    <span style="float: left;">Log In</span><span style="width: 100px;"></span><span style="float: right;"><asp:Image ID="Image1"
                        Width="48px" runat="server" ImageUrl="~/Images/monash_logo.gif" /></span>
                </div>
                <div class="clear"></div>
                <div>
                    <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" Font-Bold="True">User ID</asp:Label>
                    <asp:TextBox ID="UserName" runat="server" AutoCompleteType="Disabled" autocomplete="off"></asp:TextBox>
                </div>
                <div>
                    <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" Font-Bold="True">Password</asp:Label>
                    <asp:TextBox ID="Password" runat="server" TextMode="Password"  AutoCompleteType="Disabled" autocomplete="off"></asp:TextBox>
                </div>
               <%-- <div>
                    <table>
                        <tr>
                            <td style="font-size: 12px; text-align: left; padding-top: 3px;">
                              <telerik:RadCaptcha ID="RadCaptcha1" runat="server" EnableRefreshImage="true" ErrorMessage="The code you entered is not valid." 
                                ValidationGroup="LoginUserValidationGroup" ValidatedTextBoxID="CaptchaTextBox" Display="None" IgnoreCase="true"
                                CaptchaLinkButtonText="Generate new code" CaptchaImage-TextLength="4" >

                                <CaptchaImage  CharSet="abcdefghijklmnpqrstuvwxyz" TextChars="CustomCharSet"
                                    EnableCaptchaAudio="false" RenderImageOnly="true"
                                    BackgroundColor="#609f0a" TextColor="White" BackgroundNoise="None"></CaptchaImage>
                            </telerik:RadCaptcha>                         
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="CaptchaLabel" runat="server" AssociatedControlID="CaptchaTextBox" Font-Bold="True" Text="Type the code from the image:"></asp:Label>
                                <br />
                                <asp:TextBox ID="CaptchaTextBox" runat="server" MaxLength="4" autocomplete="off"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </div>--%>
                <div>
                    <span class="failureNotification">
                        <%--<asp:Literal ID="FailureText" runat="server"></asp:Literal>--%>
                        <asp:ValidationSummary ID="LoginUserValidationSummary" runat="server" CssClass="failureNotification" Visible="true"
                            ValidationGroup="LoginUserValidationGroup" DisplayMode="List"/>
                    </span>
                </div>

                <div>
                    <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Log In" ValidationGroup="LoginUserValidationGroup" />
                </div>
                <div>
                    <asp:HyperLink ID="RequestAccount" runat="server">Request an Account</asp:HyperLink>
                </div>
                <div>
                    <asp:HyperLink ID="PasswordRecovery" runat="server">Forgot your password?</asp:HyperLink>
                </div>
            </div>
         </div>
    </LayoutTemplate>
</asp:Login>
