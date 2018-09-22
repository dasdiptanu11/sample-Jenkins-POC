using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.UI.Web.Views.Shared;
using System.Configuration;
using System.Web.Security;
using Telerik.Web.UI;
using App.Business;


namespace App.UI.Web.Views.Home
{
    public partial class LoginUserControl : BaseUserControl
    {
        /// <summary>
        /// Overriding onLoad method to authorize users.
        /// it also navigates users to respective URL for new account and password recovery
        /// </summary>
        /// <param name="e">it contains event data</param>
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            
            HyperLink requestAccount = LoginUser.FindControl("RequestAccount") as HyperLink; 
            requestAccount.NavigateUrl = "mailto:" + GetAppConfigValue(Constants.APP_CONFIG_KEY_ACCOUNT_REQUEST_EMAIL);

            HyperLink recoverPassword = LoginUser.FindControl("PasswordRecovery") as HyperLink;
            recoverPassword.NavigateUrl = Constants.URL_PWD_RECOVERY;
             string userName = ((TextBox)LoginUser.FindControl("UserName")).Text;
             if(!string.IsNullOrEmpty(userName))
            {
                string[] roles = Roles.GetRolesForUser(userName);
                if (roles.Contains(BusinessConstants.ROLE_NAME_SURGEON) || roles.Contains(BusinessConstants.ROLE_NAME_DATACOLLECTOR))
                {
                    LoginUser.DestinationPageUrl = Constants.URL_SUCCESSFUL_LOGIN_FOR_SURGEON_N_DATACOLLECTORS;
                }
                else
                {
                    LoginUser.DestinationPageUrl = Constants.URL_SUCCESSFUL_LOGIN; 
                }
            }

        }

        /// <summary>
        /// //Logs Logged in user details in tbl_HistoryLoginRepository with Status FAIL or SUCCESS 
        /// </summary>
        /// <param name="status">FAIL or SUCCESS</param>
        protected void LoginAudit(String status)
        {
            using (UnitOfWork auditDetails = new UnitOfWork())
            {
                tbl_HistoryLogin dataItems = new tbl_HistoryLogin();
                dataItems.Username = ((TextBox)LoginUser.FindControl("UserName")).Text;
                dataItems.AttemptDateTime = System.DateTime.Now;
                dataItems.Status = status;
                dataItems.IpAddress = GetUser_IP();
                dataItems.UserAgent = Request.UserAgent;
                 auditDetails.tbl_HistoryLoginRepository.Insert(dataItems);
                auditDetails.Save();
            }

        }

        /// <summary>
        /// Checks Logged in User IP Address
        /// </summary>
        /// <returns>Users IP Address</returns>
        public String GetUser_IP()
        {
            string visitorsIPAddress = string.Empty;
            if (HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
            {
                visitorsIPAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
            }
            else if (HttpContext.Current.Request.UserHostAddress.Length != 0)
            {
                visitorsIPAddress = HttpContext.Current.Request.UserHostAddress;
            }
            return visitorsIPAddress;
        }
        /// <summary>
        /// custom error messages for failed logins
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void LoginUser_LoginError(object sender, EventArgs e)
        {
            string userName = LoginUser.UserName;

            MembershipUser memberUser = Membership.GetUser(userName);

            if (memberUser != null)
            {
                if (memberUser.IsLockedOut) // Locked Out 
                {
                    //LoginUser.FailureText = Properties.Resource.MessageAccountLocked;
                    DisplayCustomMessageInValidationSummary(Properties.Resource.MessageAccountLocked, "LoginUserValidationGroup");
                }
                else if (!memberUser.IsApproved) // Not active 
                {
                    //LoginUser.FailureText = Properties.Resource.MessageAccountInactive;
                    DisplayCustomMessageInValidationSummary(Properties.Resource.MessageAccountInactive, "LoginUserValidationGroup");
                }
                else // Incorrect Password
                {
                    //LoginUser.FailureText = Properties.Resource.AccountLoginAttemptFailed;
                    DisplayCustomMessageInValidationSummary(Properties.Resource.AccountLoginAttemptFailed, "LoginUserValidationGroup");
                }
            }

            LoginAudit("Fail");
        }
        /// <summary>
        /// Single Session Enforcement
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void LoginUser_LoggedIn(object sender, EventArgs e)
        {
            Session[Constants.SESSION_DATA_KEY] = null;
            System.Web.UI.WebControls.Login senderLogin = sender as System.Web.UI.WebControls.Login;
            if (ConfigurationManager.AppSettings["SingleSessionEnforcement"] != null)
            {
                if (ConfigurationManager.AppSettings["SingleSessionEnforcement"].ToString()=="true")
                {
                    string key = senderLogin.UserName;

                    TimeSpan timeOut = new TimeSpan(0, 0, HttpContext.Current.Session.Timeout, 0, 0);

                    HttpContext.Current.Cache.Insert(key,
                        Session.SessionID,
                        null,
                        DateTime.MaxValue,
                        timeOut,
                        System.Web.Caching.CacheItemPriority.NotRemovable,
                        null);

                    Session["username"] = key;
                    //http://www.codeproject.com/Articles/210993/Session-Fixation-vulnerability-in-ASP-NET
                    // createa a new GUID and save into the session
                    string guid = Guid.NewGuid().ToString();
                    Session["AuthToken"] = guid;
                    // now create a new cookie with this guid value
                    Response.Cookies.Add(new HttpCookie("AuthToken", guid));
                }
            }

            //Online Visitor List
            HttpContext currentContext = HttpContext.Current;
            if (currentContext != null)
            {
                if (WebApplication.Views.OnlineVisitorsUtility.Visitors.ContainsKey(currentContext.Session.SessionID))
                {
                    WebApplication.Views.OnlineVisitorsUtility.Visitors.Remove(currentContext.Session.SessionID);

                }
                if (!WebApplication.Views.OnlineVisitorsUtility.Visitors.ContainsKey(currentContext.Session.SessionID))
                {
                    WebApplication.Views.OnlineVisitorsUtility.Visitors.Add(currentContext.Session.SessionID, new WebApplication.Views.WebsiteVisitor(currentContext, senderLogin.UserName));

                }
            }
            //log an entry to DB
            LoginAudit("Success");
        }
        /// <summary>
        /// Autheticating users 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Authenticate_Login(object sender, System.Web.UI.WebControls.AuthenticateEventArgs e)
        {
            //Validating credentials
            bool validCredentials = Membership.ValidateUser(LoginUser.UserName, LoginUser.Password);
            if (validCredentials)
            {
                if (Session["SessionLockStartTime"] == null || DateTime.Now >= Convert.ToDateTime(Session["SessionLockStartTime"]).AddMinutes(Convert.ToInt32(ConfigurationManager.AppSettings["LoginLockoutTimeForSession"])))
                {
                    e.Authenticated = true;
                    Session["CountLoginAttempts"] = 0;
                    Session["SessionLockStartTime"] = null;
                    return;
                }
                else
                {
                    DisplayCustomMessageInValidationSummary(Properties.Resource.AccountLoginAttemptFailed2, "LoginUserValidationGroup");
                }
            }

            MembershipUser memberUser = Membership.GetUser(LoginUser.UserName);
            if (memberUser == null)
            {

                e.Authenticated = false;

                if (Session["CountLoginAttempts"] == null || Session["CountLoginAttempts"] == string.Empty || Convert.ToInt32(Session["CountLoginAttempts"]) == 0)
                {
                    Session["CountLoginAttempts"] = "1";
                    //LoginUser.FailureText = Properties.Resource.AccountLoginAttemptFailed;
                    DisplayCustomMessageInValidationSummary(Properties.Resource.AccountLoginAttemptFailed, "LoginUserValidationGroup");
                }
                else
                {
                    Session["CountLoginAttempts"] = Convert.ToInt32(Session["CountLoginAttempts"]) + 1;
                    if (Convert.ToInt32(Session["CountLoginAttempts"]) < Membership.MaxInvalidPasswordAttempts)
                    {
                        //LoginUser.FailureText = Properties.Resource.AccountLoginAttemptFailed;
                        DisplayCustomMessageInValidationSummary(Properties.Resource.AccountLoginAttemptFailed, "LoginUserValidationGroup");
                    }
                    if (Convert.ToInt32(Session["CountLoginAttempts"]) == Membership.MaxInvalidPasswordAttempts)
                    {
                        //time starts now                           
                        Session["SessionLockStartTime"] = DateTime.Now;
                        //LoginUser.FailureText = Properties.Resource.AccountLoginAttemptFailed2;
                        DisplayCustomMessageInValidationSummary(Properties.Resource.AccountLoginAttemptFailed2, "LoginUserValidationGroup");
                    }
                    else if (Convert.ToInt32(Session["CountLoginAttempts"]) > Membership.MaxInvalidPasswordAttempts)
                    {
                        if (DateTime.Now < Convert.ToDateTime(Session["SessionLockStartTime"]).AddMinutes(Convert.ToInt32(ConfigurationManager.AppSettings["LoginLockoutTimeForSession"])))
                        {
                            //LoginUser.FailureText = Properties.Resource.AccountLoginAttemptFailed2;
                            DisplayCustomMessageInValidationSummary(Properties.Resource.AccountLoginAttemptFailed2, "LoginUserValidationGroup");
                        }
                        else
                        {
                            Session["CountLoginAttempts"] = 0;
                            Session["SessionLockStartTime"] = null;
                        }
                    }
                }

            }
        }

        private int _countError = 0;
        /// <summary>
        /// Displays custom messages in validation summary 
        /// </summary>
        /// <param name="message">custom message</param>
        /// <param name="validationGroup">validation group to which the controls belong</param>
        protected void DisplayCustomMessageInValidationSummary(string message, string validationGroup = null)
        {        
            _countError = _countError + 1; 

            if (_countError <= 1)
            {
            CustomValidator customValidator = new CustomValidator();
            customValidator.IsValid = false;
            customValidator.ErrorMessage = message;
            customValidator.Text = "*";
            customValidator.ValidationGroup = validationGroup;
            customValidator.Visible = false;
            LoginUser.Controls.Add(customValidator);  
            }
        }
        //need to check more whether it is in use or not
        protected void litContactAdmin_PreRender(object sender, EventArgs e)
        {
            ((Literal)sender).Text = "<a href='mailto:" + ConfigurationManager.AppSettings["EMAIL_PROJECT"] + "?subject=" + ConfigurationManager.AppSettings["PROJECT_NAME"] + " Web Login'>" + ConfigurationManager.AppSettings["EMAIL_PROJECT"] + "</a>";

        }

         
    }
}