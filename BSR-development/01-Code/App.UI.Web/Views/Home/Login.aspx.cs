using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App.UI.Web.Views.Home
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        //need to check more whether its in use or not
        protected void litContactAdmin_PreRender(object sender, EventArgs e)
        {
            ((Literal)sender).Text = "<a href='mailto:" + ConfigurationManager.AppSettings["EMAIL_PROJECT"] + "?subject=" + ConfigurationManager.AppSettings["PROJECT_NAME"] + " Web Login'>" + ConfigurationManager.AppSettings["EMAIL_PROJECT"] + "</a>";

        }
    }
}
