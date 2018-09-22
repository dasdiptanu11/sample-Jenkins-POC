using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.Business;
using App.UI.Web.Views.Shared;
using Telerik.Web.UI;
using CDMSValidationLogic;

namespace App.UI.Web.Views.Home
{
    public partial class ConcurrentLogin : BasePage
    {
        /// <summary>
        /// Its used to block Concurrent logins  of a user.
        /// User will be logged out from the  session if more then one session are opened.
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (WebApplication.Views.OnlineVisitorsUtility.Visitors != null)
                {

                    string userName = Request.QueryString["un"];
                    if (!string.IsNullOrEmpty(userName))
                    {

                        VisitorsGrid.DataSource = WebApplication.Views.OnlineVisitorsUtility.Visitors.Values.Where(x => x.SessionId == userName.ToString());
                        VisitorsGrid.DataBind();
                    }
                   
                }
            }
        }
    }
}