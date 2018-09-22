using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.UI.Web.Views.Shared;
using App.Business;
using System.Web.Services.Description;


namespace App.UI.Web.Views.Forms
{
    public partial class YesNoConfirm : BasePage
    {
        /// <summary>
        /// Loads up Surgeon and patient follow up confirmation Page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
           if(Request.QueryString["Surgeon"] != null)
           {
               NotifyMessage.Text = "Will '<b>" + Request.QueryString["Surgeon"] + "</b>' be the ongoing follow up surgeon for this patient?";
           }
        }

    }
}