using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App.UI.Web
{
    public partial class Site_Mobile : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //Notes: from stackoverflow.com/questions/22443932/cache-control-no-store-must-revalidate-not-sent-to-client-browser-in-iis7-as
            //The first line sets Cache-control to no-cache, and the second line adds the other attributes no-store, must-revalidate.
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.AppendCacheExtension("no-store, must-revalidate");
            Response.AppendHeader("Pragma", "no-cache");
            Response.AppendHeader("Expires", "0");   
        }
    }
}