#region Assembly Derivatives
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.Business;
using App.UI.Web.Views.Shared;
using Telerik.Web.UI;
using CDMSValidationLogic;
using System.Web.Security;
#endregion

namespace App.UI.Web.Views.Forms
{
    public partial class PasswordConfirmation : BasePage
    {

        #region Page_Load
        /// <summary>
        ///Loads Password Confirmation Page
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param
        protected void Page_Load(object sender, EventArgs e)
        {

            //First time on load this is null
            if (Request.QueryString["ReturnValue"] != null)
            {
                //This returns if authentication was successful or not
                string authenticationValue = Request.QueryString["ReturnValue"];
                //If successful injects javascript to return value on close and close the window
                if (authenticationValue == "1")
                {
                    if (Request.QueryString["FormName"] != null)
                    {
                        string formName = Request.QueryString["FormName"];
                        ExtractAudit(formName);
                    }
                    Page.ClientScript.RegisterClientScriptBlock(GetType(), "CloseScript", "var oWindow = GetRadWindow(); oWindow.Argument ='" + authenticationValue.ToString() + "';" + "oWindow.close();", true);
                }
                //If user is disabled or locked out
                else if (authenticationValue == "-1" || authenticationValue == "-2")
                {
                    Page.ClientScript.RegisterClientScriptBlock(GetType(), "CloseScript", "var oWindow = GetRadWindow(); oWindow.Argument ='" + authenticationValue.ToString() + "';" + "oWindow.close();", true);
                }
                else
                {
                    //If unsuccessful injects javascript to return value on close
                    Page.ClientScript.RegisterClientScriptBlock(GetType(), "CloseScript", "var oWindow = GetRadWindow(); oWindow.Argument ='" + authenticationValue.ToString() + "';", true);
                }
                if (authenticationValue == "-3")
                {
                    Error.Text = "Authentication failed.";
                }
                else

                    Error.Text = "";

            }
        }
        #endregion

        #region btnOK_Click
        /// <summary>
        /// This method is called to authenticate the user to download data
        /// </summary>
        /// <param name="sender">Button</param>
        /// <param name="e">Args</param>
        protected void OK_Click(object sender, EventArgs e)
        {
            int authenticationValue = 0;
            if (Membership.ValidateUser(Membership.GetUser().UserName, Password.Text))
            {
                authenticationValue = 1;
            }
            else if (Membership.GetUser().IsApproved == false)
            {
                authenticationValue = -1;
                FormsAuthentication.SignOut();
            }
            else if (Membership.GetUser().IsLockedOut == true)
            {
                authenticationValue = -2;
                FormsAuthentication.SignOut();
            }
            else
            {
                authenticationValue = -3;
            }
            if (Request.QueryString["FormName"] != null)
            {
                string formName = Request.QueryString["FormName"];
                Response.Redirect(Request.ServerVariables["URL"] + "?ReturnValue=" + authenticationValue + "&FormName=" + formName);
            }
        }
        #endregion
    }


}

