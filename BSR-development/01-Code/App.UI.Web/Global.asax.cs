using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using log4net;
using log4net.Config;

namespace App.UI.Web
{
    public class Global : System.Web.HttpApplication
    {
        private static readonly ILog _logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        protected void Application_Start(object sender, EventArgs e)
        {
            XmlConfigurator.Configure();
            _logger.Debug("Application Start");
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// logs an entry on application error
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Application_Error(object sender, EventArgs e)
        {
            try
            {
                Exception appError = Server.GetLastError().GetBaseException();
                string error = "Error Caught in Application_Error event\n" +
                        "Error in: " + Request.Url.ToString() +
                        "\nError Message:" + appError.Message.ToString() +
                        "\nStack Trace:" + appError.StackTrace.ToString();
                _logger.Error(error);
                //EventLog.WriteEntry("Sample_WebApp", err, EventLogEntryType.Error);
                //Server.ClearError();
            }
            catch (Exception ex)
            {
                _logger.Error(ex.StackTrace);
            } 
        }

        /// <summary>
        /// removing session keys and cancelling it on session end
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Session_End(object sender, EventArgs e)
        {
            Session.RemoveAll();
            Session.Abandon();
       }

        protected void Application_End(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// Enforcement Single Session
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Application_PreRequestHandlerExecute(Object sender, EventArgs e)
        {
            if (ConfigurationManager.AppSettings["SingleSessionEnforcement"] != null)
            {
                if (ConfigurationManager.AppSettings["SingleSessionEnforcement"].ToString() == "true")
                {
                    if (HttpContext.Current.Session != null)
                    {
                        if (Session["username"] != null)
                        {
                            string cacheKey = Session["username"].ToString();
                            if ((string)HttpContext.Current.Cache[cacheKey] != Session.SessionID)
                            {
                                FormsAuthentication.SignOut();
                                Session.Abandon();
                                Response.Redirect("~/Views/Home/ConcurrentLogin.aspx?un=" + (string)HttpContext.Current.Cache[cacheKey]);
                            }

                            string user = (string)HttpContext.Current.Cache[cacheKey];
                        }
                    }
                }
            }
        }

    }
}