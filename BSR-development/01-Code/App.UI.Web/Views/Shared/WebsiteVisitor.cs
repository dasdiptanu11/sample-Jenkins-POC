using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Collections.Generic;

namespace WebApplication.Views
{
    /// <summary>
    /// Summary description for WebsiteVisitor
    /// </summary>
    public class WebsiteVisitor
    {
        // stores Session Id
        private string _sessionId;

        /// <summary>
        /// Gets or sets Session Id
        /// </summary>
        public string SessionId
        {
            get { return _sessionId; }
            set { _sessionId = value; }
        }

        /// <summary>
        /// Gets or sets User Ip Property
        /// </summary>
        public string IpAddress
        {
            get { return _ipAddress; }
            set { _ipAddress = value; }
        }

        // Stores User IP Address
        private string _ipAddress;

        /// <summary>
        /// Gets or sets URL Referrer Property
        /// </summary>
        public string UrlReferrer
        {
            get { return _urlReferrer; }
            set { _urlReferrer = value; }
        }

        // stores URL Referrer
        private string _urlReferrer;

        /// <summary>
        /// Gets or sets Enter URL Property
        /// </summary>
        public string EnterUrl
        {
            get { return _enterUrl; }
            set { _enterUrl = value; }
        }

        // stores Enter URL
        private string _enterUrl;


        /// <summary>
        /// Gets or sets Host Name Property
        /// </summary>
        public string HostName
        {
            get { return _hostName; }
            set { _hostName = value; }
        }

        // Stores Host Name
        private string _hostName;

        /// <summary>
        /// Gets or sets User Agent Property
        /// </summary>
        public string UserAgent
        {
            get { return _userAgent; }
            set { _userAgent = value; }
        }

        // Stores User Agent
        private string _userAgent;

        /// <summary>
        /// Gets or sets Session Started Property
        /// </summary>
        public DateTime SessionStarted
        {
            get { return _sessionStarted; }
            set { _sessionStarted = value; }
        }

        // Stores Session Started values
        private DateTime _sessionStarted;

        /// <summary>
        /// Gets or sets Logged In User Name
        /// </summary>
        public String UserName
        {
            get { return _userName; }
            set { _userName = value; }
        }

        // Stores Logged in User Name
        private String _userName;

        /// <summary>
        /// Constructor method - Initializes all the private variables values
        /// </summary>
        /// <param name="context">HTTP Context</param>
        /// <param name="userName">Current Logged in User Name</param>
        public WebsiteVisitor(HttpContext context, String userName = null)
        {
            if ((context != null) && (context.Request != null) && (context.Session != null))
            {
                this._sessionId = context.Session.SessionID;
                _sessionStarted = DateTime.Now;
                _userAgent = string.IsNullOrEmpty(context.Request.UserAgent) ? string.Empty : context.Request.UserAgent;
                _ipAddress = context.Request.UserHostAddress;
                if (context.Request.UrlReferrer != null)
                {
                    _urlReferrer = string.IsNullOrEmpty(context.Request.UrlReferrer.OriginalString) ? string.Empty : context.Request.UrlReferrer.OriginalString;
                }

                _enterUrl = string.IsNullOrEmpty(context.Request.Url.OriginalString) ? string.Empty : context.Request.Url.OriginalString;
                //username
                this._userName = userName;
            }
        }
    }
}