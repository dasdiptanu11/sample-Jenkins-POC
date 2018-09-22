using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication.Views
{

    public partial class WebsiteVisitorList : Page
    {
        /// <summary>
        /// Loading Website Visitors data in the grid
        /// </summary>
        /// <param name="sender">Website Visitor List page as sender</param>
        /// <param name="e">Event Argument</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (OnlineVisitorsUtility.Visitors != null)
                {
                    VisitorsGrid.DataSource = OnlineVisitorsUtility.Visitors.Values;
                    VisitorsGrid.DataBind();
                }
            }
        }
    }
}