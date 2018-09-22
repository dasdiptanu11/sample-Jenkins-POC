using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace App.UI.Web.Views.Shared
{
    public class Constants
    {
        /// <summary>
        /// Session Data key
        /// </summary>
        public const string SESSION_DATA_KEY = "BSR_SESSION_DATA_KEY";

        /// <summary>
        /// Surgeon Home Page
        /// </summary>
        public const string SURGEON_HOMEPAGE = "Dashboard";

        /// <summary>
        /// Password for the Admin user
        /// </summary>
        public const string RECOVERY_ADMIN_PASSWORD = "Admin123@";

        /// <summary>
        /// Application project config key
        /// </summary>
        public const string APP_CONFIG_KEY_PROJECT_NAME = "PROJECT_NAME";

        /// <summary>
        /// Application Project short name config key
        /// </summary>
        //public const string APP_CONFIG_KEY_PROJECT_SHORT_NAME = "PROJECT_SHORT_NAME";

        /// <summary>
        /// Application Setting configuration key for Accounr Request Bid
        /// </summary>
        public const string APP_CONFIG_KEY_ACCOUNT_REQUEST_EMAIL = "ACCOUNT_REQUEST_EMAIL";

        //public const string APP_CONFIG_KEY_PROJECT_URL = "PROJECT_URL";

        /// <summary>
        /// Application Setting configuration key for Recovery Username key
        /// </summary>
        public const string APP_CONFIG_KEY_RECOVERY_USERNAME = "RECOVERY";

        /// <summary>
        /// Application Setting configuration key for Recovery Email
        /// </summary>
        public const string APP_CONFIG_KEY_RECOVERY_EMAIL = "RECOVERY_EMAIL";

        /// <summary>
        /// Application Setting configuration key for Password Expiry day 
        /// </summary>
        public const string APP_CONFIG_KEY_PASSOWRD_EXPIRY_DAYS = "PASSOWRD_EXPIRY_DAYS";

        /// <summary>
        /// Application Setting configuration key for Password Reset on First Login
        /// </summary>
        public const string APP_CONFIG_KEY_PASSWORD_RESET_FIRST_LOGIN = "PASSWORD_RESET_FIRST_LOGIN";

        /// <summary>
        /// Application Setting configuration key for Security Question on First time login
        /// </summary>
        public const string APP_CONFIG_KEY_SECURITYQUESTION_RESET_FIRST_LOGIN = "SECURITYQUESTION_RESET_FIRST_LOGIN";
        /// <summary>
        /// Application Setting configuration key for file size
        /// </summary>
        public const string APP_CONFIG_KEY_MAX_BULK_LOAD_FILE_SIZE = "MAX_BULK_LOAD_FILE_SIZE";
        /// <summary>
        /// Parameter for User Id query
        /// </summary>
        public const string QUERY_PARAM_USER_ID = "u";

        /// <summary>
        /// Code for Password Change on First Login
        /// </summary>
        public const int CODE_PASSWORD_CHANGE_FIRST_LOGIN = 1;

        /// <summary>
        /// Code for Password change on Expiration
        /// </summary>
        public const int CODE_PASSWORD_CHANGE_EXPIRATION = 2;

        /// <summary>
        /// Code for Password Change on Reset
        /// </summary>
        public const int CODE_PASSWORD_CHANGE_RESET = 3;

        /// <summary>
        /// Code for Security Question change on First Login
        /// </summary>
        public const int CODE_SECURITY_QUESTION_CHANGE_FIRST_LOGIN = 1;

        /// <summary>
        /// URL for Password Recovery Page
        /// </summary>
        public const string URL_PWD_RECOVERY = "~/Views/Home/RecoverPassword.aspx";

        /// <summary>
        /// URL for User List page
        /// </summary>
        public const string URL_USER_LIST = "~/Views/Admin/UserList.aspx";

        /// <summary>
        /// URL for User Create Page
        /// </summary>
        public const string URL_CREATE_USER_ACCOUNT = "~/Views/Admin/CreateAccount.aspx";

        /// <summary>
        /// URL for New User Create mail tempalte
        /// </summary>
        public const string URL_EMAIL_TEMPLATE_NEW_USER_ACCOUNT = "~/EmailTemplates/NewUserAccount.txt";

        /// <summary>
        /// URL for Password Recovery Mail template
        /// </summary>
        public const string URL_EMAIL_TEMPLATE_PASSWORD_RECOVERY = "~/EmailTemplates/PasswordRecovery.txt";

        /// <summary>
        /// URL for Reoperation not found mail template
        /// </summary>
        public const string URL_EMAIL_TEMPLATE_REOPERATION_NOTFOUND = "~/EmailTemplates/ReoperationNotFound.txt";

        /// <summary>
        /// URL for Recommended LTFU mail template
        /// </summary>
        public const string URL_EMAIL_TEMPLATE_RECOMMENDED_LTFU = "~/EmailTemplates/RecommendedLTFU.txt";

        /// <summary>
        /// URL for Home page
        /// </summary>
        public const string URL_HOME = "~/Default.aspx";

        /// <summary>
        /// URL for Login Page
        /// </summary>
        public const string URL_LOGIN = "~/Views/Home/Login.aspx";

        /// <summary>
        /// URL for Patient Search page
        /// </summary>
        public const string URL_SUCCESSFUL_LOGIN = "~/Views/Forms/PatientSearch.aspx";

        /// <summary>
        /// URL for successful login for user of type surgeon and data collectors
        /// </summary>
        public const string URL_SUCCESSFUL_LOGIN_FOR_SURGEON_N_DATACOLLECTORS = "~/Views/Forms/SurgeonDashboard.aspx";

        /// <summary>
        /// URL for Change Password page
        /// </summary>
        public const string URL_CHANGE_PWD = "~/Views/AccountSetting/ChangePassword.aspx";

        /// <summary>
        /// URL for Change Security Question page
        /// </summary>
        public const string URL_CHANGE_SECURITY_QUESTION = "~/Views/AccountSetting/ChangeSecurityQuestion.aspx";

        /// <summary>
        /// URL for Regisetring a new Patient page
        /// </summary>
        public const string URL_REGISTER_PATIENT = "~/Views/Forms/PatientList.aspx";

        /// <summary>
        /// Page for Change Password page
        /// </summary>
        public const string PAGE_CHANGE_PWD = "ChangePassword.aspx";

        /// <summary>
        /// Page for Change Security question
        /// </summary>
        public const string PAGE_CHANGE_SECURITY_QUESTION = "ChangeSecurityQuestion.aspx";

        /// <summary>
        /// Other Device Code
        /// </summary>
        public const string BSR_Device_Other = "-1";

        /// <summary>
        /// Unknown Device code
        /// </summary>
        public const string BSR_Device_NotKnown = "-88";

        /// <summary>
        /// Not Recorded Device code
        /// </summary>
        public const string BSR_Device_NotRecorded = "-99";

        /// <summary>
        /// Country code for Austrlia
        /// </summary>
        public const int COUNTRY_CODE_FOR_AUSTRALIA = 1;

        /// <summary>
        /// Country code for New Zealand
        /// </summary>
        public const int COUNTRY_CODE_FOR_NEWZEALAND = 2;

        /// <summary>
        /// Code for Consented Patient Status
        /// </summary>
        public const int OPTOFF_CODE_FOR_CONSENTED = 0;

        /// <summary>
        /// Constant Add Revision operation
        /// </summary>
        public const string ADD_REVISION = "ADD REVISION";

        /// <summary>
        /// Constant for Add Primary operation
        /// </summary>
        public const string ADD_PRIMARY = "ADD PRIMARY";

        /// <summary>
        /// Constant for Add Follow up
        /// </summary>
        public const string ADD_FOLLOWUP = "ADD FOLLOW UP";

        /// <summary>
        /// Constant string for Edit Unknown Device
        /// </summary>
        public const string EDIT_UNKNOWN_DEVICE = "EDIT UNKNOWN DEVICE";

        /// <summary>
        /// Constant string for Add Unknown Device
        /// </summary>
        public const string ADD_UNKNOWN_DEVICE = "ADD UNKNOWN DEVICE";

        /// <summary>
        /// Constnt for Revision Operation Type
        /// </summary>
        public const string OPERATION_TYPE_REVISION = "Revision bariatric procedure";

        /// <summary>
        /// Constant for Primary Operation tyep
        /// </summary>
        public const string OPERATION_TYPE_PRIMARY = "Primary bariatric procedure";

        /// <summary>
        /// Revision Operation Type Id
        /// </summary>
        public const int OPTYPEID_REVISION = 1;

        /// <summary>
        /// Primary Opration Type Id
        /// </summary>
        public const int OPERATION_TYPEID_PRIMARY = 0;

    }
}
