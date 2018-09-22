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
    public partial class ChangeSecurityQuestion : BasePage
    {
        /// <summary>
        ///Loads Change Security Question Page
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>>
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

            if (!Page.IsPostBack)
            {
                Loadlookup();
            }
        }
        /// <summary>
        /// Loads home screen on cancel button click
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ChangeQuestionPushButton_Click(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsValid)
                {
                    return;
                }

                MembershipUser user = Membership.GetUser(UserName);

                if(!Membership.ValidateUser(UserName, Password.Text)) 
                {
                    if(user.IsLockedOut) 
                    {
                        FormsAuthentication.SignOut();
                        //ShowMessageInValidationSummary("Your Account is Locked Out.");
                        DisplayCustomMessageInValidationSummary("Your Account is Locked Out.", "ChangePassword1");
                    } 
                    else 
                    {
                        //ShowMessageInValidationSummary("Invalid password. Please try again.");
                        DisplayCustomMessageInValidationSummary("Password is invalid - re-enter", "ChangePassword1");
                    }
                } 
                else 
                {
                    //mbshipUser.ChangePasswordQuestionAndAnswer(Password.Text, txtQuestion.Text, Answer.Text);
                    user.ChangePasswordQuestionAndAnswer(Password.Text, Question.SelectedItem.Text , Answer.Text);

                    //<Changes for security implementation for checking lastSecurityQuestionChangedDate>
                    //For updating from "CreateAccount.aspx" page, lastSecurityQuestionChangedDate = existing value from userProfile (no change)
                    //For inserting from "CreateAccount.aspx" page, lastSecurityQuestionChangedDate = username CreateDate
                    //For updating from "ChangeSecurityQuestion.aspx", lastSecurityQuestionChangedDate = now                    

                    UserProfile userProfile = new UserProfile(UserName);
                    userProfile.LastSecurityQuestionChangedDate = System.DateTime.Now;
                    userProfile.Save();
                    //</Changes for security implementation for checking lastSecurityQuestionChangedDate>

                    MultiView.ActiveViewIndex = 1;
                }

            }
            catch (Exception ex) 
            { 
                //ShowMessageInValidationSummary("Error occured: " + ex.Message);
                DisplayCustomMessageInValidationSummary("Error occured: " + ex.Message, "ChangePassword1");
            }
        }

        //Commented on  05/06/2013
        //protected void txtQuestion_PreRender(object sender, EventArgs e)
        //{
        //    if(!Page.IsPostBack) 
        //    {
        //        MembershipUser mbshipUser = Membership.GetUser(Username);
        //        txtQuestion.Text = mbshipUser.PasswordQuestion;
        //    }
        //}
        //Commented on  05/06/2013

        //loads question and bind them to dropdown
        private void Loadlookup()
        {
            using (UnitOfWork questionDetails = new UnitOfWork())
            {
                Helper.BindCollectionToControl(Question, questionDetails.Get_tlkp_SecurityQuestions(true), "Id", "Description");
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
        /// <summary>
        /// Validates Question
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void Question_ServerValidate(object source, ServerValidateEventArgs args)
        {
            //Commented on  05/06/2013
            if (Question.SelectedValue == "")//(txtQuestion.Text.ToUpper() == "ANSWER IS YES")
            {
                args.IsValid = false;
                ((CustomValidator)source).ErrorMessage = "You must change your question";
            }
            else
            {
                args.IsValid = true;
            }
            //Commented on  05/06/2013


        }
        /// <summary>
        /// Validates Answer
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void Answer_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (Answer.Text.ToUpper() == "YES" || Answer.Text.ToUpper() == "NO")
            {
                args.IsValid = false;
                ((CustomValidator)source).ErrorMessage = "Answer cannot be 'yes' or 'no'";
            }
            else
            {
                args.IsValid = true;
            }

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
                    if (Int32.Parse(messageCode) == Constants.CODE_SECURITY_QUESTION_CHANGE_FIRST_LOGIN)
                    {
                        ((Label)sender).Text = "You must change your security question (This is the first time login or you have never changed it before).";
                    }                    
                }
                catch
                {
                }
            }
        }

        /// <summary>
        /// Renders Questions and bind them to a control
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Question_PreRender(object sender, EventArgs e)
        {
                if(!Page.IsPostBack) 
                {
                    MembershipUser user = Membership.GetUser(UserName);
                    Dictionary<System.Web.UI.Control, Object> controlMapping = new Dictionary<System.Web.UI.Control, Object>();

                    controlMapping.Add(Question, user.PasswordQuestion);

                    PopulateControl(controlMapping);
                  //  txtQuestion.Text = mbshipUser.PasswordQuestion;
               }
        }
    }
}
