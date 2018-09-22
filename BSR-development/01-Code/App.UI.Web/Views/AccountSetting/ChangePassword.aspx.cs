using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using App.UI.Web.Views.Shared;
using App.Business;

namespace App.UI.Web.Views.AccountSetting
{
    public partial class ChangePassword : BasePage
    {
        /// <summary>
        /// Render username and fill it with current logged in user name
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void UserName_PreRender(object sender, EventArgs e)
        {
            ((Label)sender).Text = UserName;
        }

        /// <summary>
        ///Loads Change Password Page
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param
        protected void Page_Load(object sender, EventArgs e)
        {
            Button changeSecurityQuestion = (Button)Password.SuccessTemplateContainer.FindControl("bChangeQuestion");
            changeSecurityQuestion.PostBackUrl = Constants.URL_CHANGE_SECURITY_QUESTION;

            Button cancelPushButton = (Button)Password.ChangePasswordTemplateContainer.FindControl("CancelPushButton");
            //CancelPushButton.PostBackUrl = Constants.URL_SUCCESSFUL_LOGIN;
            if (UserName != "")
            {
                string[] roles = Roles.GetRolesForUser(UserName);
                if (roles.Contains(BusinessConstants.ROLE_NAME_SURGEON) || roles.Contains(BusinessConstants.ROLE_NAME_DATACOLLECTOR))
                {
                    cancelPushButton.PostBackUrl = Constants.URL_SUCCESSFUL_LOGIN_FOR_SURGEON_N_DATACOLLECTORS;
                }
                else
                {
                    cancelPushButton.PostBackUrl = Constants.URL_SUCCESSFUL_LOGIN;   
                }
            }
            else
                cancelPushButton.PostBackUrl = Constants.URL_SUCCESSFUL_LOGIN;

        }

        /// <summary>
        /// save new password 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Password_Changed(object sender, EventArgs e)
        {
            UserProfile userProfile = new UserProfile(UserName);
            userProfile.PasswordReset = false;
            userProfile.Save();

            ValidationSummary validationSummary = (ValidationSummary)Password.ChangePasswordTemplateContainer.FindControl("ValidationSummary1");
            Password.ChangePasswordTemplateContainer.Controls.Remove(validationSummary);


        }

        /// <summary>
        /// Renders warning messages if any 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void WarningNotification_PreRender(object sender, EventArgs e)
        {
            string messageCode = Request["code"];

            if (Page.IsPostBack || string.IsNullOrEmpty(messageCode))
            {
                ((Label)sender).Visible = false;
                ((Label)sender).Text = "";
            }
            else
            {
                ((Label)sender).Visible = true;
                try
                {
                    if (Int32.Parse(messageCode) == Constants.CODE_PASSWORD_CHANGE_FIRST_LOGIN)
                    {
                        ((Label)sender).Text = "You must change your password.";
                    }
                    if (Int32.Parse(messageCode) == Constants.CODE_PASSWORD_CHANGE_EXPIRATION)
                    {
                        ((Label)sender).Text = "Your password has expired and must be changed.";
                    }
                    if (Int32.Parse(messageCode) == Constants.CODE_PASSWORD_CHANGE_RESET)
                    {
                        ((Label)sender).Text = "Your password has been reset and must be changed.";
                    }
                }
                catch
                {
                }
            }
        }
        /// <summary>
        /// users forcefully sign out on error while saving
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Password_ChangeError(object sender, EventArgs e)
        {
            MembershipUser user = Membership.GetUser(UserName);

            if (user != null)
            {
                if (user.IsLockedOut)
                {
                    FormsAuthentication.SignOut();
                }
            }
        }

        }
}
