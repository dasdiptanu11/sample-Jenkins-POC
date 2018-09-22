using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.Business;
namespace App.UI.Web.Views.Shared {
    public partial class PatientRibbon : BaseUserControl {
        /// <summary>
        /// Initiate controls with the Initial values for the patient if available
        /// </summary>
        /// <param name="sender">Patient Ribbon user control</param>
        /// <param name="e">event argument</param>
        protected void Page_Load(object sender, EventArgs e) {
            InitData();
        }

        /// <summary>
        /// Reloading the Patient data in the ribbon controls
        /// </summary>
        public void ReloadData() {
            InitData();
        }

        /// <summary>
        /// Load ribbon controls with the given values
        /// </summary>
        /// <param name="patientId">Patient Id to be displayed in the ribbon</param>
        /// <param name="patientName">Patient Name to be displayed in the ribbon</param>
        /// <param name="birthDate">Patient Date of Birth to be displayed in the ribbon</param>
        /// <param name="gender">Patient Gender to be displayed in the ribbon</param>
        /// <param name="urnNumber">Patient URN Number to be displayed in the ribbon</param>
        public void LoadData(string patientId, string patientName, string birthDate, string gender, string urnNumber) {
            PatientIdValue.Text = patientId;
            DateOfBirthValue.Text = birthDate;
            PatientNameValue.Text = patientName;
            GenderValue.Text = gender;
            if ((IsSurgeon() || IsDataCollector()) && !string.IsNullOrEmpty(urnNumber)) {
                ShowHideURNNo(urnNumber, true);
            }
        }

        // Get the Patient data from the database and Load ribbon controls with the Patient data
        private void InitData() {
            SessionData sessionData = GetSessionData();

            using (UnitOfWork patientRepository = new UnitOfWork()) {
                if (sessionData != null && sessionData.PatientId != 0) {
                    tbl_Patient patient = patientRepository.tbl_PatientRepository.Get(x => x.PatId == sessionData.PatientId).SingleOrDefault();

                    if (patient != null) {
                        if (patient.PatId != 0) {
                            PatientIdValue.Text = patient.PatId.ToString();
                        }

                        PatientNameValue.Text = patient.FName + " " + patient.LastName;
                        DateOfBirthValue.Text = string.Format("{0:dd/MM/yyyy}", patient.DOB);
                        if (patient.GenderId != null) {
                            GenderValue.Text = patient.GenderId == null ? string.Empty : patient.tlkp_Gender.Description;
                        }

                        if ((IsSurgeon() || IsDataCollector()) && sessionData.PatientURNNumber != null && !string.IsNullOrEmpty(sessionData.PatientURNNumber)) {
                            ShowHideURNNo(sessionData.PatientURNNumber, true);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Showing or Hiding Patient URN Number in the Patient Ribbon
        /// </summary>
        /// <param name="patientURN">Patient URN Number to be displayed in the Patient Ribbon</param>
        /// <param name="showURN">Flag indicating if Patient URN Number has to be displayed</param>
        public void ShowHideURNNo(string patientURN, bool showURN) {
            if (showURN) {
                PatientURNumberValue.Text = patientURN;
                PatientURNumberLabel.Text = "UR No: ";
                PatientURNumberLabel.Visible = true;
                PatientURNumberValue.Visible = true;
                PatientIdLabel.Text = string.Empty;
                PatientIdLabel.Visible = false;
                PatientIdValue.Text = string.Empty;
                PatientIdValue.Visible = false;
            } else {
                PatientURNumberValue.Text = string.Empty;
                PatientURNumberLabel.Text = string.Empty;
                PatientURNumberLabel.Visible = false;
                PatientURNumberValue.Visible = false;
                PatientIdLabel.Text = "Patient ID: ";
                PatientIdLabel.Visible = true;
                PatientIdValue.Text = string.Empty;
                PatientIdValue.Visible = true;
            }
        }


        public UpdatePanelUpdateMode UpdateMode {
            get {
                return RibbonUpdatePanel.UpdateMode;
            }
            set {
                RibbonUpdatePanel.UpdateMode = value;
            }
        }

        public void Update() {
            RibbonUpdatePanel.Update();
        }

    }
}