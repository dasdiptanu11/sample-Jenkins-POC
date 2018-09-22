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
    public partial class popupOptOffPatient : BasePage
    {
        /// <summary>
        /// Initializing controls and events of the controls
        /// </summary>
        /// <param name="sender">Popup Opt Off Patient page as sender</param>
        /// <param name="e">Event argument</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            PatientOptOffStatusId.Attributes.Add("onchange", "PatientOptOffChanged()");
            if (!Page.IsPostBack)
            {
                InitData();
            }
        }

        /// <summary>
        /// Loading popup controls with the patient data
        /// </summary>
        private void InitData()
        {
            SessionData sessionData = GetSessionData();
            Dictionary<System.Web.UI.Control, Object> controlMapping = new Dictionary<System.Web.UI.Control, Object>();

            tbl_Patient patient;
            using (UnitOfWork dataRepository = new UnitOfWork())
            {
                patient = dataRepository.tbl_PatientRepository.Get(x => x.PatId == sessionData.PatientId).FirstOrDefault();
                if (patient.OptOffStatId == 4)
                { Helper.BindCollectionToControl(PatientOptOffStatusId, dataRepository.Get_tlkp_OptOffStatus(true, true), "Id", "Description"); }
                else
                { Helper.BindCollectionToControl(PatientOptOffStatusId, dataRepository.Get_tlkp_OptOffStatus(true, false), "Id", "Description"); }

                controlMapping.Add(NameValue, patient.FName + ' ' + patient.LastName);
                controlMapping.Add(PatientOptOffStatusId, patient.OptOffStatId);
                PopulateControl(controlMapping);
            }

            if (PatientOptOffStatusId.SelectedValue == "2")
            { PatientOptOffStatusWarning.Text = "Warning: Do not phone (Partial Opt Off)"; }
            else if (PatientOptOffStatusId.SelectedValue == "1")
            { PatientOptOffStatusWarning.Text = "Warning: Patient will be deleted"; }
            else
            { PatientOptOffStatusWarning.Text = string.Empty; }

            if (PatientOptOffStatusId.SelectedValue == "1")
            { CompleteOptOffPanel.Enabled = false; }
            else
            { CompleteOptOffPanel.Enabled = true; }
        }

        /// <summary>
        /// Patient selecting Opt Off
        /// </summary>
        /// <param name="sender">Opt Off button as sender</param>
        /// <param name="e">Event argument</param>
        protected void PatientOptOffClicked(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    SessionData sessionData = GetSessionData();
                    if (sessionData.OptOffDate != null)
                    {
                        patientRepository.PatientRepository.Update_OptOffDetails(
                                                                                    patientRepository,
                                                                                    sessionData.PatientId.ToString(),
                                                                                    PatientOptOffStatusId.SelectedValue,
                                                                                    (DateTime)sessionData.OptOffDate);
                    }
                    else
                    {
                        patientRepository.PatientRepository.Update_OptOffDetails(
                                                                                    patientRepository,
                                                                                    sessionData.PatientId.ToString(),
                                                                                    PatientOptOffStatusId.SelectedValue);
                    }

                    sessionData.OptOffDate = null;
                    SaveSessionData(sessionData);
                    ShowMessage("Data has been saved - " + DateTime.Now.ToString());
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "MyFunc1", "CloseWindow();", true);
                }
            }
        }

        /// <summary>
        /// Display status message on the screen
        /// </summary>
        /// <param name="message">Message to be displayed</param>
        public void ShowMessage(string message)
        {
            Message.ForeColor = System.Drawing.Color.Black;
            Message.Text = message;
        }
    }
}