using App.Business;
using App.UI.Web.Views.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App.UI.Web.Views.Forms
{
    public partial class Home : BasePage
    {
        /// <summary>
        /// Loads home Page after successful login
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                using (UnitOfWork hospitalDetails = new UnitOfWork())
                {
                    string userName = Session["username"] == null ? "" : Session["username"].ToString();
                    Helper.BindCollectionToControl(PatientSiteId, hospitalDetails.Get_HospitalList(userName, -1, true, false), "Id", "Description");
                }
            }
        }
        /// <summary>
        /// Checks patient Details on the basis of URN and Site
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void CheckPatient_Click(object sender, EventArgs e)
        {
            if ((PatientSiteId.SelectedIndex != 0) && (!string.IsNullOrEmpty(PatientUrn.Text)))
            {
                using (UnitOfWork patientDetails = new UnitOfWork())
                {
                    SessionData sessionData;
                    int patientId;
                    sessionData = GetDefaultSessionData();
                    patientId = sessionData.PatientId = patientDetails.PatientRepository.GetPatientId(PatientSiteId.SelectedValue == "" ? -1 : Convert.ToInt32(PatientSiteId.SelectedValue),
                        PatientUrn.Text);
                    if (patientId == 0)
                    {
                        PatientMessage.Visible = true;
                        AddPatient.Visible = true;
                        PatientMessage.Text = "No patient exist in this site with that URN.";
                    }
                    else
                    {
                        PatientMessage.Visible = false;
                        AddPatient.Visible = false;
                        Response.Redirect(Properties.Resource2.PatientHomePath);
                    }
                    sessionData.PatientId = patientId;
                }
            }
        }
        /// <summary>
        /// Adds a patient if not found
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void AddPatient_Click(object sender, EventArgs e)
        {
            SessionData sessionData = GetDefaultSessionData(); ;
            sessionData.PatientId = 0;
            Response.Redirect(Properties.Resource2.PatientHomePath);
        }
    }
}