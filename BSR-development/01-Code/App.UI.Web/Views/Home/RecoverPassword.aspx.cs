using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using App.UI.Web.Views.Shared;
using System.Configuration;
using App.Business;

namespace App.UI.Web.Views.Home
{
    public partial class RecoverPassword : BasePage
    {

        /// <summary>
        /// Specifying email template file and subject line
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            PasswordRecovery.MailDefinition.BodyFileName = Constants.URL_EMAIL_TEMPLATE_PASSWORD_RECOVERY;

            Button userNameCancelButton = (Button)PasswordRecovery.UserNameTemplateContainer.FindControl("CancelPushButton");
            userNameCancelButton.PostBackUrl = Constants.URL_LOGIN;

            Button questionCancelButton = (Button)PasswordRecovery.QuestionTemplateContainer.FindControl("CancelPushButton");
            questionCancelButton.PostBackUrl = Constants.URL_LOGIN;

            LinkButton homeLinkButton = (LinkButton)PasswordRecovery.SuccessTemplateContainer.FindControl("Home");
            homeLinkButton.PostBackUrl = Constants.URL_LOGIN;

            if (!Page.IsPostBack)
            {
                PasswordRecovery.MailDefinition.Subject = GetApplicationConfigValue(Constants.APP_CONFIG_KEY_PROJECT_NAME) + ": New Password";
            }

        }

        /// <summary>
        /// Populating email address in the sent-email confirmation message
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Email_PreRender(object sender, EventArgs e)
        {
            string userName = PasswordRecovery.UserName;
            MembershipUser user = Membership.GetUser(userName);

            if (user != null)
            {
                ((Label)sender).Text = user.Email;
            }

        }

        /// <summary>
        /// Checks Invalid User IDs
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void PasswordRecovery_UserLookupError(object sender, EventArgs e)
        {

            string userName = PasswordRecovery.UserName;
            MembershipUser user = Membership.GetUser(userName);

            if (user != null)
            {
                if (user.IsLockedOut)
                {
                    PasswordRecovery.UserNameFailureText = "Your account is locked";

                }
                else if (!user.IsApproved)
                {
                    PasswordRecovery.UserNameFailureText = "Your account is not active";

                }
            }
            else
            {
                PasswordRecovery.UserNameFailureText = "Your login attempt was not successful. Please try again later.";
            }


        }

        /// <summary>
        /// Checks Invalid Answer
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void PasswordRecovery_AnswerLookupError(object sender, EventArgs e)
        {
            PasswordRecovery.QuestionFailureText = "Valid answer is required - re-enter.";
        }

        /// <summary>
        /// Called before the user is looked up to check whether the account is locked or not
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void PasswordRecovery_VerifyingUser(object sender, LoginCancelEventArgs e)
        {
            string userName = PasswordRecovery.UserName;
            MembershipUser user = Membership.GetUser(userName);

            if (user != null)
            {

                if (!user.IsApproved)
                {
                    DisplayCustomMessageInValidationSummary("Contact BSR Reg Admin", "PasswordRecovery");
                    // Looks like a bug in membership where mthe error message is not being displayed under this condition.
                    PasswordRecovery.UserNameFailureText = "Contact BSR Reg Admin";
                    //PasswordRecovery.GeneralFailureText = "Contact BDR Reg Admin";
                    e.Cancel = true;
                }
                else if (user.IsLockedOut)
                {
                    PasswordRecovery.UserNameFailureText = "Contact BSR Reg Admin";

                }

                if (user.PasswordQuestion.ToUpper() == "The answer is yes".ToUpper())
                {
                    PasswordRecovery.Visible = false;
                    string projectName = ConfigurationManager.AppSettings["PROJECT_NAME"].ToString();
                    MessageNotification.Text = string.Format("Please contact {0} Administrator to recover your password.", projectName);
                }
                else
                {
                    PasswordRecovery.SubmitButtonStyle.CssClass = "showContent";
                    MessageNotification.Text = "";
                }
            }
        }

        /// <summary>
        /// Sending Email 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void PasswordRecovery_SendingMail(object sender, MailMessageEventArgs e)
        {
            string userName = PasswordRecovery.UserName;
            String userFullName = "";
            MembershipUser user = Membership.GetUser(userName);
            tbl_User dataItems;
            using (UnitOfWork userDetails = new UnitOfWork())
            {
                dataItems = userDetails.tbl_UserRepository.Get(x => x.UId == (System.Guid)user.ProviderUserKey).FirstOrDefault();
            }
            if (dataItems != null)
            { userFullName = dataItems.FName + " " + dataItems.LastName; }
            e.Message.IsBodyHtml = false;
            e.Message.Body = e.Message.Body.Replace("<%PROJECT_NAME%>", ConfigurationManager.AppSettings["PROJECT_NAME"].ToString());
            e.Message.Body = e.Message.Body.Replace("<%PROJECT_URL%>", ConfigurationManager.AppSettings["PROJECT_URL"].ToString());
            e.Message.Body = e.Message.Body.Replace("<%UserFullName%>", userFullName);



            //Setting the PasswordReset flag on in the user profile so that user is forced to change password
            UserProfile userProfile = new UserProfile(user.UserName);
            userProfile.PasswordReset = true;
            userProfile.Save();
        }

    }
}
