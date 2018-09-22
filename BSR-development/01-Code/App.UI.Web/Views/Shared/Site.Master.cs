using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using App.UI.Web.Views.Shared;
using Telerik.Web.UI;
using System.Web.Security;
using App.Business;

namespace App.UI.Web.Views.Shared
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        #region SessionData
        /// <summary>
        /// Gets Session Data instance
        /// </summary>
        /// <returns>Return Session Data instance</returns>
        public SessionData GetSessionData()
        {
            SessionData sessionData = null;
            Object sessionObject = Session[Constants.SESSION_DATA_KEY];

            if (sessionObject != null)
            {
                sessionData = (SessionData)sessionObject;
            }
            else
            {
                Response.Redirect(Properties.Resource2.PatientSearchPath);
                return null;
            }

            return sessionData;
        }

        /// <summary>
        /// Gets or Create a Session Data instance
        /// </summary>
        /// <returns>Returns Session data instance</returns>
        protected SessionData GetDefaultSessionData()
        {
            SessionData sessionData = null;
            Object sessionObject = Session[Constants.SESSION_DATA_KEY];

            if (sessionObject != null)
            {
                sessionData = (SessionData)sessionObject;
            }
            else
            {
                return null;
            }

            return sessionData;
        }
        #endregion

        /// <summary>
        /// Saving Session Data instance in session variable
        /// </summary>
        /// <param name="sessionData"></param>
        protected void SaveSessionData(SessionData sessionData)
        {
            Session[Constants.SESSION_DATA_KEY] = sessionData;
        }

        // Getting Configuration setting value from config file
        private String GetAppConfigValue(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }

        /// <summary>
        /// Page Load event handler for Master Page, Initializing controls
        /// </summary>
        /// <param name="sender">Master Page as sender</param>
        /// <param name="e">Event Arguments</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            MembershipUser memberUser = null;
            UserProfile userProfile = null;

            ContentPlaceHolder contentPlaceHolder = (ContentPlaceHolder)this.FindControl("Login");
            if (contentPlaceHolder != null)
            {
                HyperLink requestAccountLink = contentPlaceHolder.FindControl("LoginView").FindControl("RequestAccountLink") as HyperLink;
                if (requestAccountLink != null)
                {
                    requestAccountLink.NavigateUrl = "mailto:" + GetAppConfigValue(Constants.APP_CONFIG_KEY_ACCOUNT_REQUEST_EMAIL);
                }
            }

            if (!IsPostBack)
            {
                SiteTitle.Text = ConfigurationManager.AppSettings[Constants.APP_CONFIG_KEY_PROJECT_NAME];
                VersionLabel.Text = "Version " + System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.Major.ToString() + "." +
                    System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.Minor.ToString();
            }

            if (Page.User.Identity.IsAuthenticated && LoginView != null)
            {
                memberUser = Membership.GetUser();
                if (memberUser != null)
                {
                    userProfile = new UserProfile(memberUser.UserName);
                    if (!IsPostBack)
                    {
                        if (SiteTitle != null && VersionLabel != null)
                        {
                            if (Page.User.Identity.IsAuthenticated)
                            {
                                ManageSessionFixation(memberUser, userProfile);
                                ConditionalPasswordReset(memberUser, userProfile);
                            }
                        }
                    }
                }
            }

            //Notes: from stackoverflow.com/questions/22443932/cache-control-no-store-must-revalidate-not-sent-to-client-browser-in-iis7-as
            //The first line sets Cache-control to no-cache, and the second line adds the other attributes no-store, must-revalidate.
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.AppendCacheExtension("no-store, must-revalidate");
            Response.AppendHeader("Pragma", "no-cache");
            Response.AppendHeader("Expires", "0");
        }

        // Managing Session fixation
        private void ManageSessionFixation(MembershipUser memberUser, UserProfile userProfile)
        {
            //http://www.codeproject.com/Articles/210993/Session-Fixation-vulnerability-in-ASP-NET
            //NOTE: Keep this Session and Auth Cookie check
            //condition in your Master Page Page_Load event
            if (Session["username"] != null && Session["AuthToken"] != null
                   && Request.Cookies["AuthToken"] != null)
            {
                if (!Session["AuthToken"].ToString().Equals(Request.Cookies["AuthToken"].Value))
                {
                    Logoff();
                }
            }
            else
            {
                Logoff();
            }
        }

        // Redirect User to password reset page if user's password is expired
        private void ConditionalPasswordReset(MembershipUser memberUser, UserProfile userProfile)
        {
            // Not in change password page already AND Not in change security question page already
            if (!(Page.AppRelativeVirtualPath.Contains(Constants.PAGE_CHANGE_PWD)) && !(Page.AppRelativeVirtualPath.Contains(Constants.PAGE_CHANGE_SECURITY_QUESTION)))
            {
                int daysSincePasswordChange = Convert.ToInt32(DateTime.Now.Subtract(memberUser.LastPasswordChangedDate).TotalDays);

                //If Password Change Mandatory and First Log In
                if (IsFirstLoginPasswordChangeMandatory() && memberUser.LastPasswordChangedDate == memberUser.CreationDate)
                {
                    Response.Redirect(Constants.URL_CHANGE_PWD + "?code=" + Constants.CODE_PASSWORD_CHANGE_FIRST_LOGIN);
                }
                else if (GetPasswordExpiryLimitInDays() != -1 && (daysSincePasswordChange > GetPasswordExpiryLimitInDays()))
                {
                    Response.Redirect(Constants.URL_CHANGE_PWD + "?code=" + Constants.CODE_PASSWORD_CHANGE_EXPIRATION);
                }
                else if (userProfile.PasswordReset)
                {
                    Response.Redirect(Constants.URL_CHANGE_PWD + "?code=" + Constants.CODE_PASSWORD_CHANGE_RESET);
                }
                else if (IsFirstLoginSecurityQuestionChangeMandatory() && 
                    (userProfile.LastSecurityQuestionChangedDate == memberUser.CreationDate || userProfile.LastSecurityQuestionChangedDate.ToShortDateString() == "1/01/0001"))
                {
                    //Security Question Change is Mandatory at First Log In
                    Response.Redirect(Constants.URL_CHANGE_SECURITY_QUESTION + "?code=" + Constants.CODE_SECURITY_QUESTION_CHANGE_FIRST_LOGIN);
                }
            }
        }

        // Get the mandatory password expiration day
        private int GetPasswordExpiryLimitInDays()
        {
            int limit = -1;
            string mandatoryPasswordExpirationDay = ConfigurationManager.AppSettings[Constants.APP_CONFIG_KEY_PASSOWRD_EXPIRY_DAYS];

            try
            {
                limit = Int32.Parse(mandatoryPasswordExpirationDay);
            }
            catch
            {
                limit = -1;
            }

            return limit;
        }

        // Get the config value for whether Password required is mandatory on the first login of the user
        private bool IsFirstLoginPasswordChangeMandatory()
        {
            string isPasswordChangeRequiredOnFirstLogin = ConfigurationManager.AppSettings[Constants.APP_CONFIG_KEY_PASSWORD_RESET_FIRST_LOGIN];
            try
            {
                int configValue = Int32.Parse(isPasswordChangeRequiredOnFirstLogin);
                if (configValue == 1)
                {
                    return true;
                }
            }
            catch { }

            return false;
        }

        // Get the config value for whether Security Question change is mandatory on the first login of the user
        private bool IsFirstLoginSecurityQuestionChangeMandatory()
        {
            string isSecurityQuestionChangeMandatoryOnFirstLogin = ConfigurationManager.AppSettings[Constants.APP_CONFIG_KEY_SECURITYQUESTION_RESET_FIRST_LOGIN];
            try
            {
                int configValue = Int32.Parse(isSecurityQuestionChangeMandatoryOnFirstLogin);
                if (configValue == 1)
                {
                    return true;
                }
            }
            catch { }

            return false;
        }

        /// <summary>
        /// Display an alert window
        /// </summary>
        /// <param name="url">url of the page to be displayed in the Alert Window</param>
        public void ShowWindow(string url)
        {
            string radAlertscript = "<script language='javascript'>function f(){showWindow('" + url + "'); Sys.Application.remove_load(f);}; Sys.Application.add_load(f);</script>";
            Page.ClientScript.RegisterStartupScript(this.GetType(), "radalert", radAlertscript);
        }

        /// <summary>
        /// Gets an object of Window Manager
        /// </summary>
        public RadWindowManager WindowManager
        {
            get { return RadWindowManager1; }
        }

        /// <summary>
        /// Adjusting timezone offset whenever timezone option selection has changed
        /// </summary>
        /// <param name="sender">Timezone control as sender</param>
        /// <param name="e">Event Arguments</param>
        protected void TimezoneOffsetControl_ValueChanged(object sender, EventArgs e)
        {
            int timezoneOffset = 0;
            string offset = TimezoneOffsetControl.Value;
            SessionData sessionData = null;

            if (Session[Constants.SESSION_DATA_KEY] != null)
            {
                sessionData = (SessionData)Session[Constants.SESSION_DATA_KEY];
            }
            else
            {
                sessionData = new SessionData();
                sessionData.ClientTimezoneOffset = 0;
                Session[Constants.SESSION_DATA_KEY] = sessionData;
            }


            if (offset != null)
            {
                try
                {
                    timezoneOffset = Int32.Parse(offset);
                    sessionData.ClientTimezoneOffset = timezoneOffset;
                    Session[Constants.SESSION_DATA_KEY] = sessionData;
                }
                catch (Exception ex)
                {

                }
            }

        }


        // Find a menu item in the Application Menu and set it's visibility
        private static void FindItem(RadMenu applicationMenu, string item, Boolean flag)
        {
            RadMenuItem applicationMenuItem = (RadMenuItem)applicationMenu.FindItemByText(item);
            if (applicationMenuItem != null)
            {
                applicationMenuItem.Visible = flag;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ApplicationMenu_DataBound(object sender, EventArgs e)
        {


            if (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON) || Roles.IsUserInRole(BusinessConstants.ROLE_NAME_DATACOLLECTOR))
            {
                SetUpMenuForSurgeon();
            }
            else
            {
                SessionData sessionData = null;
                Object obj = Session[Constants.SESSION_DATA_KEY];
                sessionData = (obj != null) ? (SessionData)obj : null;
                RadMenu rmMenu = (RadMenu)LoginView3.FindControl("ApplicationMenu");
                FindItem(rmMenu, Constants.SURGEON_HOMEPAGE, false);
                if (sessionData != null)
                {
                    if (sessionData.PatientId != 0)
                    {
                        FindItem(rmMenu, "Patient Details", true);
                        FindItem(rmMenu, "Patient Demographics", true);
                        FindItem(rmMenu, "Operation Details", true);
                        FindItem(rmMenu, "Follow Up", true);
                    }
                    else
                    {
                        FindItem(rmMenu, "Patient Details", false);
                        FindItem(rmMenu, "Patient Demographics", false);
                        FindItem(rmMenu, "Operation Details", false);
                        FindItem(rmMenu, "Follow Up", false);
                    }
                }
                else
                {
                    FindItem(rmMenu, "Patient Details", false);
                    FindItem(rmMenu, "Patient Demographics", false);
                    FindItem(rmMenu, "Operation Details", false);
                    FindItem(rmMenu, "Follow Up", false);
                }

                // find by navigateurl
                RadMenu rmMenuUrl = (RadMenu)LoginView3.FindControl("ApplicationMenu");
                RadMenuItem rmItemUrl_Institute = (RadMenuItem)rmMenuUrl.FindItem(x => x.NavigateUrl.Contains("/Views/Admin/Institute.aspx"));
                SetVisibleRadMenuItem(rmItemUrl_Institute, false);

                RadMenuItem rmItemUrl_Clinician = (RadMenuItem)rmMenuUrl.FindItem(x => x.NavigateUrl.Contains("/Views/Admin/Clinician.aspx"));
                SetVisibleRadMenuItem(rmItemUrl_Clinician, false);

                RadMenuItem rmItemUrl_Study = (RadMenuItem)rmMenuUrl.FindItem(x => x.NavigateUrl.Contains("/Views/Admin/Study.aspx"));
                SetVisibleRadMenuItem(rmItemUrl_Study, false);

            }

            RadMenu rmMenuUrl1 = (RadMenu)LoginView3.FindControl("ApplicationMenu");
            RadMenuItem rmItemUrl_FAQ = (RadMenuItem)rmMenuUrl1.FindItem(x => x.NavigateUrl.Contains("/Documents/FAQ.pdf"));
            rmItemUrl_FAQ.Target = "_blank";

        }

        #region radmenu
        /// <summary>
        /// Setting visibility for Appplication menu item
        /// </summary>
        /// <param name="applicationMenuItem">menu item for which visibility needs to be changed</param>
        /// <param name="isVisible">Visibility Flag to determine whether to display of hide the menu item</param>
        public static void SetVisibleRadMenuItem(RadMenuItem applicationMenuItem, Boolean isVisible)
        {
            if (applicationMenuItem != null)
            {
                if (isVisible)
                {
                    applicationMenuItem.Visible = true;
                }
                else
                {
                    applicationMenuItem.Visible = false;
                }
            }
        }
        #endregion

        /// <summary>
        /// Setting Application menu for Surgeon user
        /// </summary>
        public void SetUpMenuForSurgeon()
        {
            RadMenu applicationMenu = (RadMenu)LoginView3.FindControl("ApplicationMenu");
            for (int i = 0; i < applicationMenu.Items.Count; i++)
            {
                if (applicationMenu.Items[i].Text == Constants.SURGEON_HOMEPAGE || applicationMenu.Items[i].Text == "Work Lists" 
                    || applicationMenu.Items[i].Text == "Settings" || applicationMenu.Items[i].Text == "FAQ")
                {
                    applicationMenu.Items[i].Visible = true;
                }
                else
                {
                    applicationMenu.Items[i].Visible = false;
                }
            }

        }

        /// <summary>
        /// Logging out the current logged in user
        /// </summary>
        /// <param name="sender">Login starus n</param>
        /// <param name="e">Event Arguments</param>
        protected void LoginStatus_LoggedOut(object sender, EventArgs e)
        {
            Logoff();
        }

        /// <summary>
        /// Logging off the user and clearing out the session variables for the user
        /// </summary>
        protected void Logoff()
        {
            Session.Clear();
            Session.Abandon();
            Session.RemoveAll();
            FormsAuthentication.SignOut();
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            }

            if (Request.Cookies["AuthToken"] != null)
            {
                Response.Cookies["AuthToken"].Value = string.Empty;
                Response.Cookies["AuthToken"].Expires = DateTime.Now.AddMonths(-20);
            }

            Roles.DeleteCookie();
            FormsAuthentication.RedirectToLoginPage();
        }
    }
}
