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
    public partial class ChangeEmail : BasePage
    {
        /// <summary>
        ///Loads Change Email Page
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            MultiView.ActiveViewIndex = 0;
            //CancelPushButton.PostBackUrl = Constants.URL_SUCCESSFUL_LOGIN;
            if (UserName != "")
            {
                string[] roles = Roles.GetRolesForUser(UserName);
                if (roles.Contains(BusinessConstants.ROLE_NAME_SURGEON) || roles.Contains(BusinessConstants.ROLE_NAME_DATACOLLECTOR))
                {
                    CancelPushButton.PostBackUrl = Constants.URL_SUCCESSFUL_LOGIN_FOR_SURGEON_N_DATACOLLECTORS;
                }
                else
                {
                    CancelPushButton.PostBackUrl = Constants.URL_SUCCESSFUL_LOGIN;//    
                }
            }
            else
                CancelPushButton.PostBackUrl = Constants.URL_SUCCESSFUL_LOGIN;
        }
        /// <summary>
        /// Authenticate user and saves new email to DB
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ChangeEmailPushButton_Click(object sender, EventArgs e)
        {

            MembershipUser user = Membership.GetUser(UserName);

            if (!Membership.ValidateUser(User.Identity.Name, Password.Text))
            {
                if (user.IsLockedOut)
                {
                    FormsAuthentication.SignOut();
                    ShowMessageInValidationSummary("Your Account is locked out.");
                }
                else
                {
                    ShowMessageInValidationSummary("Invalid password. Please try again.");
                }
            }
            else 
            {
                if (user.Email == Email.Text)
                {
                    ShowMessageInValidationSummary("New email address cannot be the same as the old email address.");
                }
                else
                {
                    user.Email = Email.Text;
                    Membership.UpdateUser(user);
                    MultiView.ActiveViewIndex = 1;
                }
            }

    }
        /// <summary>
        /// Render email text box and fill it with email which is going to be changed 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Email_PreRender(object sender, EventArgs e)
        {
            if(!Page.IsPostBack) 
            {
                MembershipUser user = Membership.GetUser(UserName);
                Email.Text = user.Email;
            }
       
        }

        /// <summary>
        /// Render username and fill it with current logged in user name
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void LoggedInUser_PreRender(object sender, EventArgs e)
        {
            MembershipUser user = Membership.GetUser(UserName);
            LoggedInUser.Text = user.UserName; 
        }

    }
}
