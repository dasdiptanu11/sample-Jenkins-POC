using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.Security;
using Telerik.Web.UI;
using App.Business;

namespace App.UI.Web.Views.Shared
{
    public class BaseUserControl : System.Web.UI.UserControl
    {
        /// <summary>
        /// Reads config setting value from config file
        /// </summary>
        /// <param name="key">Config key for which value is needed</param>
        /// <returns>Config value for the config key passed as parameter</returns>
        protected String GetAppConfigValue(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }

        /// <summary>
        /// Checks whether the current logged-in user has a Surgeon role
        /// </summary>
        /// <returns>Returns a flag which indicates whether current logged-in user has Surgeon role</returns>
        protected bool IsSurgeon()
        {
            if (Roles.GetRolesForUser(UserName).ToList().Contains(BusinessConstants.ROLE_NAME_SURGEON) == true)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// Checks whether the current logged-in user has a Data Collector role
        /// </summary>
        /// <returns>Returns a flag which indicates whether current logged-in user has Data Collector role</returns>
        protected bool IsDataCollector()
        {
            if (Roles.GetRolesForUser(UserName).ToList().Contains(BusinessConstants.ROLE_NAME_DATACOLLECTOR) == true)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// Gets current logged in user name from the Session
        /// </summary>
        protected string UserName
        {
            get
            {
                return Session["username"] == null ? string.Empty : Session["username"].ToString();
            }
        }

        #region SessionData
        /// <summary>
        /// Gets a user's Session Data instance
        /// </summary>
        /// <returns>Returns Session Data instance</returns>
        public SessionData GetSessionData()
        {
            SessionData sessionData = null;
            Object sessionDataInstance = Session[Constants.SESSION_DATA_KEY];
            sessionData = sessionDataInstance != null ? (SessionData)sessionDataInstance : new SessionData();

            return sessionData;
        }

        /// <summary>
        /// Saves user's Session Data instance into the Session variable
        /// </summary>
        /// <param name="sessionData">Session Data instance to be saved</param>
        protected void SaveSessionData(SessionData sessionData)
        {
            Session[Constants.SESSION_DATA_KEY] = sessionData;
        }
        #endregion SessionData
    }
}