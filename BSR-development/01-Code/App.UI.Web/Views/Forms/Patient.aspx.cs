using App.Business;
using App.UI.Web.Views.Shared;
using CDMSValidationLogic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App.UI.Web.Views.Forms
{
    public partial class Patient : BasePage
    {
        // Flag to determine if Patient's data is saved
        private Boolean _formSaved;

        #region Pageload
        /// <summary>
        /// Initialize all the controls on the page and show patient data
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">event arguments</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            TurnTextBoxAutoCompleteOff();

            // Binding onchange event for the client side script
            DateOfDeathKnown.Attributes.Add("onchange", "DateOfDeathKnown_ChekedChanged()");
            HealthStatusId.Attributes.Add("onchange", "HealthStatusId_SelectedIndexChanged(false)");
            OptOffStatusId.Attributes.Add("onchange", "PatientOptOffChanged()");
            if (!IsPostBack)
            {
                InitSurgeonSiteList();
                SaveReferrerForBackButton();
                LoadLookup();
                InitData();
                SetAutoPopulate();
            }

            CDMSValidation.SetControlVisible(DeathControlsPanel, HealthStatusId.SelectedValue == "1");
            EnableDisableControls();
            ShowingFormSavedMessage();
            SurgeonAndSite.EnableSiteDropDownEvenIfItHasJustOneValue = false;
        }

        // Setting auto populate for Post code control
        private void SetAutoPopulate()
        {
            PatientAddressPostcode.Attributes["onkeyUp"] += "populateState('" + PatientStateId.ClientID + "','" + PatientAddressPostcode.ClientID + "');";
        }

        // Setting session data and url referrer for previous button click handler
        private void SaveReferrerForBackButton()
        {
            if (!IsPostBack)
            {
                SessionData sessionData;
                if (Request.QueryString["AddPatient"] == "Y")
                {
                    sessionData = GetDefaultSessionData();
                    if (sessionData != null)
                    {
                        sessionData.PatientId = 0;
                        sessionData.PanelNewPatient = false;
                    }
                }
                else
                {
                    sessionData = GetSessionData();
                }
                sessionData.PreviousPagePatient = Request.UrlReferrer != null ? Request.UrlReferrer.ToString() : String.Empty;
                SaveSessionData(sessionData);
            }
        }
        #endregion Pageload

        #region ShowHide or EnableDisable
        // Enable or disable UI controls
        private void EnableDisableControls()
        {
            SessionData sessionData = GetSessionData();

            // Handles address not known selection - enable or disabled controls accordingly
            if (PatientAddressNotKnown.Checked == true)
            {
                PatientStreetAddress.Enabled = false;
                PatientSuburbAddress.Enabled = false;
                PatientAddressPostcode.Enabled = false;
                PatientStateId.Enabled = false;
                if (PatientAddressPostcode.Text == string.Empty) { PatientPostcodeNotKnown.Checked = true; }
            }
            else
            {
                PatientStreetAddress.Enabled = true;
                PatientSuburbAddress.Enabled = true;
                PatientAddressPostcode.Enabled = true;
                PatientStateId.Enabled = true;
                //PatientPostcodeNotKnown.Checked = false;
            }

            // if No address and No Postcode  are not ticked - enable the textbox else disable the textbox
            if ((PatientPostcodeNotKnown.Checked == false && PatientAddressNotKnown.Checked == false) ||
                (PatientPostcodeNotKnown.Checked == false && PatientAddressNotKnown.Checked == true))
            {
                PatientAddressPostcode.Enabled = true;
            }
            else
            {
                PatientAddressPostcode.Enabled = false;
            }

            //Handles No Mediacare Number selection - enable or disable Mediacare number textbox
            if (PatientMedicareNoUnknown.Checked == true)
            {
                PatientMedicareNo.Enabled = false;
                PatientMedicareNoRef.Enabled = false;
                PatientMedicareNo.Text = string.Empty;
                PatientMedicareNoRef.Text = string.Empty;
            }
            else
            {
                PatientMedicareNo.Enabled = true;
                PatientMedicareNoRef.Enabled = true;
            }

            // Handles No DVA number selection - enable or disable DVA number textbox
            if (PatientDVANumberUnknown.Checked == true)
            {
                PatientDVANumber.Enabled = false;
            }
            else
            {
                PatientDVANumber.Enabled = true;
            }

            // Handles No NHI number selection - enable or disable NHI number textbox
            if (PatientNHIUnknown.Checked == true)
            {
                PatientNHINumber.Enabled = false;
            }
            else
            {
                PatientNHINumber.Enabled = true;
            }

            // Handles No Phone selection - enable or disable Phone number texbox
            if (PatientHomePhoneUnknown.Checked == true)
            {
                PatientHomePhone.Enabled = false;
                PatientHomePhone.Text = string.Empty;
            }
            else
            {
                PatientHomePhone.Enabled = true;
            }

            // Handles No Mobile selection - enable or disable Mobile number textbox
            if (PatientMobileUnknown.Checked == true)
            {
                PatientMobile.Text = string.Empty;
                PatientMobile.Enabled = false;
            }
            else
            {
                PatientMobile.Enabled = true;
            }

            // Handles No Date of Birth selection - enable Date of Birth control
            if (PatientDOBUnknown.Checked)
            {
                PatientDOB.Enabled = false;
                CustomValidatorBirthdate.Enabled = false;
            }
            else
            {
                PatientDOB.Enabled = true;
                CustomValidatorBirthdate.Enabled = true;
            }

            // Handles Health status selection - hide or show death controls panel
            if (HealthStatusId.SelectedValue == "0" || string.IsNullOrEmpty(HealthStatusId.SelectedValue))
            {
                DeathControlsPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            }
            else
            {
                DeathControlsPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
            }

            if (OptOffStatusId.SelectedValue == "1")
            {
                PatientOptOffStatusWarningLabel.Text = "Warning: Patient will be deleted";
            }
            else if (OptOffStatusId.SelectedValue == "2")
            {
                PatientOptOffStatusWarningLabel.Text = "Warning: Do not phone (Partial Opt Off)";
            }
            else
            {
                PatientOptOffStatusWarningLabel.Text = string.Empty;
            }

            //Setting up administrator section visibility
            if (IsAdministrator || IsAdminCentral)
            {
                InfoPanel.Visible = true;
                ShowURNButton.Visible = true;
                DeletePatientButton.Visible = true;
            }
            else if (IsSurgeon || IsDataCollector)
            {
                InfoPanel.Visible = false;
                ShowURNButton.Visible = false;
                DeletePatientButton.Visible = false;
            }

            HideAndShowMedicareDetails();

            if (sessionData.PatientId != 0)
            {
                SurgeonAndSite.SiteOptionEnabled = false;
                SurgeonAndSite.SurgonOptionEnabled = false;
            }
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "reload", "<script type='text/javascript'>applyCollapsibleStyle();</script>", false);
        }

        /// <summary>
        /// Hide or show Medicare details controls
        /// </summary>
        public void HideAndShowMedicareDetails()
        {
            // checked -show disabled background colour
            if (PatientAddressNotKnown.Checked)
            {
                PatientStateId.CssClass = "disabledDropDownList";
            }
            else
            {
                PatientStateId.CssClass = "";
            }

            if (PatientCountryId.SelectedValue == Constants.COUNTRY_CODE_FOR_NEWZEALAND.ToString())
            {
                DisplayForAustralia.Visible = false;
                DisplayForNewZealLand.Visible = true;
                StateAddressRow.Visible = false;
                AboriginalRow.Visible = false;
                PatientIndigenousRow.Visible = true;
                PatientMedicareNo.Text = "";
                PatientMedicareNoUnknown.Checked = false;
                PatientDVANumber.Text = string.Empty;
                PatientDVANumberUnknown.Checked = false;
                PatientStateId.SelectedValue = null;
                PatientAboriginalStatusId.SelectedValue = null;
            }
            else
            {
                DisplayForAustralia.Visible = true;
                DisplayForNewZealLand.Visible = false;
                StateAddressRow.Visible = true;
                AboriginalRow.Visible = true;
                PatientIndigenousRow.Visible = false;
                PatientNHINumber.Text = string.Empty;
                PatientNHIUnknown.Checked = false;
            }
        }

        /// <summary>
        /// Hide or show Admin Information Panel
        /// </summary>
        /// <param name="isNewPatient">flag indicating whether a new patient is getting added</param>
        public void HideOrShowAdminInfo(bool isNewPatient)
        {
            if (IsAdministrator || IsAdminCentral)
            {
                //This will enable the statement date field for editing if the user is an admin
                DateExplanatoryStatementSent.Enabled = (DateExplanatoryStatementReturned.Checked);

                InfoPanel.Visible = !isNewPatient;
            }
            else
            {
                InfoPanel.Visible = false;
                DateExplanatoryStatementSent.Enabled = false;
            }
        }
        #endregion ShowHide or EnableDisable

        #region InitData
        // Initial setup for Surgeon site controls
        private void InitSurgeonSiteList()
        {
            SurgeonAndSite.ChangeSiteLabelText("Consent Site *");
            SurgeonAndSite.ChangeSurgeonLabelText("On-going Care Surgeon *");

            SurgeonAndSite.MakeSiteTooltipImageVisible(true);
            SurgeonAndSite.ChangeSiteTooltipText("<b>Consent Site:</b> This is a Mandatory field. If you are a data collector you will be unable to change this field.  If you are a surgeon, please select the site where this surgery was performed from the dropdown menu. The list should contain all the sites that are registered for you with the BSR and are currently undertaking bariatric procedures at this site. Please contact the BSR at med-bsr@monash.edu or 03-9903 0722 if you have any concerns regarding this list.");
            SurgeonAndSite.MakeSurgeonTooltipImageVisible(true);
            SurgeonAndSite.ChangeSurgeonTooltipText("<b>On-going Care Surgeon:</b> This is a Mandatory field. If you are are a surgeon, you will not be able to change this field.  If you are a data collector, please select the surgeon who performed this surgery from the dropdown menu. The list should contain all the surgeons who are registered at this site with the BSR and are currently undertaking bariatric procedures at this site. Please contact the BSR at med-bsr@monash.edu or 03-9903 0722 if you have any concerns regarding this list.");

            SurgeonAndSite.AddEmptyItemInSurgeonList = false;
            SurgeonAndSite.AddEmptyItemInSurgeonList = false;
            SurgeonAndSite.SetSurgeonLabelWidth(260);
            SurgeonAndSite.ConfigureSurgeonValidator(true, "PatientDataValidationGroup", null);
            SurgeonAndSite.EnableSiteDropDownEvenIfItHasJustOneValue = false;
            SurgeonAndSite.URN = PatientURN;
        }

        // Initial data load for the page
        private void InitData()
        {
            SessionData sessionData = GetSessionData();
            Dictionary<System.Web.UI.Control, Object> controlMapping = new Dictionary<System.Web.UI.Control, Object>();

            tbl_Patient patient = null;
            tbl_FollowUp followUp = null;
            aspnet_Users aspUser = null;
            tbl_User applicationUser = null;
            tbl_URN patientURN = null;

            bool isNewPatient = false;

            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                patient = patientRepository.tbl_PatientRepository.Get(x => x.PatId == sessionData.PatientId).FirstOrDefault();
                if (patient != null && sessionData.PatientId > 0)
                {
                    followUp = patientRepository.tbl_FollowUpRepository.Get(x => x.PatientId == sessionData.PatientId && (x.FUVal == null || x.FUVal == 0 || x.FUVal == 1 || x.FUVal == 2)).OrderByDescending(x => x.FUDate).FirstOrDefault();
                    if (IsSurgeon)
                    {
                        if (!string.IsNullOrEmpty(User.Identity.Name))
                        {
                            aspUser = patientRepository.aspnet_UsersRepository.Get(y => y.UserName.Equals(User.Identity.Name)).FirstOrDefault();
                            if (aspUser != null) { applicationUser = patientRepository.tbl_UserRepository.Get(x => x.UId == aspUser.UserId).FirstOrDefault(); }
                        }
                    }
                }

                //new patient - doesn't have any data
                if (patient == null)
                {
                    isNewPatient = true;
                    patient = new tbl_Patient();
                    patientURN = new tbl_URN();
                    //Get the values from session and empty the sessionData
                    if (sessionData != null)
                    {
                        string sessionMedicare = sessionData.PatientMedicare == null ? string.Empty : sessionData.PatientMedicare.ToString();
                        string medicareNo = sessionMedicare.Length >= 10 ? sessionMedicare.Substring(0, 10) : sessionMedicare;
                        string medicareRefNo = sessionMedicare.Length > 10 ? sessionMedicare.Substring(10, 1) : string.Empty;

                        controlMapping.Add(PatientGivenName, sessionData.PatientGivenName);
                        controlMapping.Add(PatientFamilyName, sessionData.PatientFamilyName);
                        controlMapping.Add(PatientMedicareNo, medicareNo);
                        controlMapping.Add(PatientMedicareNoRef, medicareRefNo);
                        controlMapping.Add(PatientGenderId, sessionData.PatientGender);
                        controlMapping.Add(PatientDOB, sessionData.PatientDateOfBirth);
                        controlMapping.Add(PatientDVANumber, sessionData.PatientDVN);
                        controlMapping.Add(PatientNHINumber, sessionData.PatientNHI);
                        controlMapping.Add(PatientURN, sessionData.PatientURNNumber);
                        SurgeonAndSite.SetDefaultTextForGivenSiteID((int)sessionData.PatientSiteId);

                        if (IsSurgeon || IsDataCollector)
                        {
                            SurgeonAndSite.SiteOptionEnabled = false;
                            int? countryId = patientRepository.PatientRepository.Get_CountryId((int)sessionData.PatientSiteId);
                            if (countryId != null)
                            {
                                controlMapping.Add(PatientCountryId, countryId.ToString());
                            }
                        }
                        else
                        {
                            controlMapping.Add(PatientCountryId, sessionData.PatientCountry);
                        }
                       
                        sessionData.PatientMedicare = null;
                        sessionData.PatientGender = null;
                        sessionData.PatientDateOfBirth = null;
                        sessionData.PatientDVN = null;
                        sessionData.PatientCountry = null;
                        sessionData.PatientNHI = null;
                        sessionData.PatientSiteId = 0;

                        if (IsAdminCentral || IsAdministrator)
                        {
                            sessionData.PatientURNNumber = null;
                        }

                        if (!(IsSurgeon || IsDataCollector))
                        {
                            sessionData.PatientFamilyName = null;
                            sessionData.PatientGivenName = null;
                        }
                        sessionData.PatientId = 0;
                        controlMapping.Add(PatientIdPanel, sessionData.PatientId == 0 ? string.Empty : patient.PatId.ToString());
                        SaveSessionData(sessionData);
                    }
                }
                else //Existing patient
                {
                    string medicareNo = string.Empty;
                    string medicareRefNo = string.Empty;

                    if (patient.NoMcareNo != null || patient.NoMcareNo == false)
                    {
                        medicareNo = (patient.McareNo != null && patient.McareNo.Length >= 10) ? patient.McareNo.Substring(0, 10) : patient.McareNo;
                        medicareRefNo = (patient.McareNo != null && patient.McareNo.Length > 10) ? patient.McareNo.Substring(10, 1) : string.Empty;
                    }

                    controlMapping.Add(PatientIdPanel, sessionData.PatientId == 0 ? string.Empty : patient.PatId.ToString());
                    controlMapping.Add(PatientIHI, patient.IHI);
                    controlMapping.Add(PatientTitleId, patient.TitleId);
                    controlMapping.Add(PatientDOB, patient.DOB);
                    controlMapping.Add(PatientGivenName, patient.FName);
                    controlMapping.Add(PatientFamilyName, patient.LastName);
                    controlMapping.Add(PatientMedicareNo, medicareNo);
                    controlMapping.Add(PatientMedicareNoRef, medicareRefNo);
                    controlMapping.Add(PatientGenderId, patient.GenderId);
                    controlMapping.Add(PatientCountryId, patient.CountryId);
                    controlMapping.Add(PatientDVANumber, patient.DvaNo);
                    controlMapping.Add(PatientNHINumber, patient.NhiNo);

                    if (patient.DOB != null)
                    {
                        if (CalculateAge((DateTime)patient.DOB) < 18)
                        {
                            controlMapping.Add(AgeLessThan18Label, Properties.Resource2.Lessthan18);
                        }
                        else
                        {
                            AgeLessThan18Label.Text = string.Empty;
                        }
                    }
                    else { AgeLessThan18Label.Text = string.Empty; }

                    patientURN = patientRepository.tbl_URNRepository.Get(x => (x.PatientID == patient.PatId) && (x.HospitalID == patient.PriSiteId)).FirstOrDefault();
                    if (patientURN != null) { controlMapping.Add(PatientURN, patientURN.URNo == null ? string.Empty : patientURN.URNo); }

                    SurgeonAndSite.SetDefaultTextForGivenSiteID(patient.PriSiteId == null ? 0 : (int)patient.PriSiteId);
                    if (patient.PriSiteId != null && (IsDataCollector || IsSurgeon))
                    {
                        sessionData.PatientSiteId = Convert.ToInt32(patient.PriSiteId);
                        SaveSessionData(sessionData);
                    }
                }
            }

            controlMapping.Add(DateExplanatoryStatementSent, patient.DateESSent);
            controlMapping.Add(DateExplanatoryStatementReturned, patient.Undel);
            controlMapping.Add(PatientDOBUnknown, patient.DOBNotKnown);
            controlMapping.Add(PatientMedicareNoUnknown, patient.NoMcareNo);
            controlMapping.Add(PatientDVANumberUnknown, patient.NoDvaNo);
            controlMapping.Add(PatientNHIUnknown, patient.NoNhiNo);
            controlMapping.Add(PatientStreetAddress, patient.Addr);
            controlMapping.Add(PatientSuburbAddress, patient.Sub);
            controlMapping.Add(PatientStateId, patient.StateId);
            controlMapping.Add(PatientAddressPostcode, patient.Pcode);
            controlMapping.Add(PatientPostcodeNotKnown, patient.NoPcode);
            controlMapping.Add(PatientAddressNotKnown, patient.AddrNotKnown);
            controlMapping.Add(PatientHomePhoneUnknown, patient.NoHomePh);
            controlMapping.Add(PatientMobileUnknown, patient.NoMobPh);
            controlMapping.Add(HealthStatusId, patient.HStatId == null ? 0 : patient.HStatId);
            controlMapping.Add(DeathRelatedToPrimaryProcedure, patient.DeathRelSurgId == null ? 0 : patient.DeathRelSurgId);
            controlMapping.Add(CauseOfDeath, patient.CauseOfDeath);
            controlMapping.Add(PatientDateOfDeath, patient.DateDeath);
            controlMapping.Add(DateOfDeathKnown, patient.DateDeathNotKnown);
            controlMapping.Add(PatientAboriginalStatusId, patient.AborStatusId);
            controlMapping.Add(PatientIndigenousStatusId, patient.IndiStatusId);

            if (applicationUser != null && !IsSurgeon)
            {
                SurgeonAndSite.SetDefaultTextForGivenSurgeonID(applicationUser.UserId);
            }
            else
            {
                SurgeonAndSite.SetDefaultTextForGivenSurgeonID(patient.PriSurgId == null ? 0 : (int)patient.PriSurgId);
            }

            if (followUp != null)
            {
                if (followUp.LTFU == true && patient.OptOffStatId == 4)
                {
                    //Verify LTFU option exists in the Opt off dropdownlist
                    if (OptOffStatusId.Items.FindByValue("4") == null)
                    {
                        using (UnitOfWork lookupRepository = new UnitOfWork())
                        {
                            Helper.BindCollectionToControl(OptOffStatusId, lookupRepository.Get_tlkp_OptOffStatus(true, true), "Id", "Description");
                        }
                    }

                    //Disabling if LTFU
                    controlMapping.Add(OptOffStatusId, 4);
                    OptOffStatusId.Enabled = false;
                }
                else
                {
                    //Unconsented
                    controlMapping.Add(OptOffStatusId, patient.OptOffStatId == null ? 3 : patient.OptOffStatId);
                    OptOffStatusId.Enabled = true;
                }
            }
            else if (patient.Undel == true || DateExplanatoryStatementReturned.Checked == true)
            {
                //Explanatory statement is undelivered
                controlMapping.Add(OptOffStatusId, 3);
            }
            else if (patient.OptOffStatId == 4)
            {
                //If Optoff status Id set to LTFU in the data - will not be needed but incase for an exception scenario
                if (OptOffStatusId.Items.FindByValue("4") == null)
                {
                    using (UnitOfWork lookupRepository = new UnitOfWork())
                    {
                        Helper.BindCollectionToControl(OptOffStatusId, lookupRepository.Get_tlkp_OptOffStatus(true, true), "Id", "Description");
                    }
                }

                controlMapping.Add(OptOffStatusId, 4);
                //Disabling if LTFU
                OptOffStatusId.Enabled = false;
            }
            else
            {
                //Unconsented
                controlMapping.Add(OptOffStatusId, patient.OptOffStatId == null ? 3 : patient.OptOffStatId);
                OptOffStatusId.Enabled = true;
            }

            //Opt Off Status - other than Partial Opt Off
            if (patient.OptOffStatId != 2)
            {
                controlMapping.Add(PatientHomePhone, patient.HomePh);
                controlMapping.Add(PatientMobile, patient.MobPh);
            }
            else if (patient.OptOffStatId == 2)
            {
                //Partial Opt Off
                controlMapping.Add(PatientHomePhone, null);
                controlMapping.Add(PatientMobile, null);
            }

            controlMapping.Add(OptOffDate, patient.OptOffDate);
            auditForm.ModifiedBy = patient.LastUpdatedBy;
            if (patient.LastUpdatedDateTime != null)
            {
                auditForm.ModifiedDateTime = patient.LastUpdatedDateTime;
            }

            PopulateControl(controlMapping);
            OptOffChanged();
            HideOrShowAdminInfo(isNewPatient);

            string onloadScript = "HealthStatusId_SelectedIndexChanged(true); ";
            onloadScript += "PatientOptOffChanged(); ";
            onloadScript += "DateOfDeathKnown_ChekedChanged(); ";

            Page.ClientScript.RegisterStartupScript(this.GetType(), "Scripts", onloadScript, true);
        }

        /// <summary>
        /// Calculates Age
        /// </summary>
        /// <param name="dateOfBirth">Birthdate</param>
        /// <returns>Returns age as per thr birthdate pass in the parameter</returns>
        public int CalculateAge(DateTime dateOfBirth)
        {
            DateTime now = DateTime.Now;
            int age = now.Year - dateOfBirth.Year;
            if (now.Date < dateOfBirth.AddYears(age)) { age--; }

            return age;
        }
        #endregion InitData

        #region SaveData
        /// <summary>
        /// Save Patient data entered in the form to the database
        /// </summary>  
        /// <returns>Returns the flag indicating whether the save operation is successful or fail</returns>
        protected bool SaveData()
        {
            SessionData sessionData = GetSessionData();
            Boolean isSaveSuccessful = false;

            try
            {
                tbl_Patient patient = new tbl_Patient();

                if (sessionData.PatientId != 0)
                {
                    patient.PatId = sessionData.PatientId;
                }

                patient.CreatedBy = UserName;
                patient.CreatedDateTime = System.DateTime.Now;
                patient.LastUpdatedBy = UserName;
                patient.LastUpdatedDateTime = System.DateTime.Now;

                patient.FName = Helper.ToNullable(PatientGivenName.Text.Trim());
                patient.LastName = Helper.ToNullable(PatientFamilyName.Text.Trim());
                patient.TitleId = Helper.ToNullable<System.Int32>(PatientTitleId.SelectedValue);
                patient.DOB = PatientDOB.SelectedDate;
                patient.DOBNotKnown = PatientDOBUnknown.Checked;
                patient.GenderId = Helper.ToNullable<System.Int32>(PatientGenderId.SelectedValue);
                patient.IHI = Helper.ToNullable(PatientIHI.Text);
                patient.Addr = Helper.ToNullable(PatientStreetAddress.Text);
                patient.AddrNotKnown = (PatientAddressNotKnown.Checked);
                patient.Sub = Helper.ToNullable(PatientSuburbAddress.Text);
                patient.Pcode = Helper.ToNullable(PatientAddressPostcode.Text);
                patient.NoPcode = (PatientPostcodeNotKnown.Checked);
                patient.CountryId = Helper.ToNullable<System.Int32>(PatientCountryId.SelectedValue);
                patient.HomePh = Helper.ToNullable(PatientHomePhone.Text);
                patient.MobPh = Helper.ToNullable(PatientMobile.Text);
                patient.NoHomePh = (PatientHomePhoneUnknown.Checked);
                patient.NoMobPh = (PatientMobileUnknown.Checked);

                patient.HStatId = Helper.ToNullable<System.Int32>(HealthStatusId.SelectedValue);
                patient.CauseOfDeath = Helper.ToNullable(CauseOfDeath.Text);
                patient.DateDeath = PatientDateOfDeath.SelectedDate;
                patient.DateDeathNotKnown = DateOfDeathKnown.Checked;

                patient.PriSurgId = Helper.ToNullable<System.Int32>(SurgeonAndSite.GetSelectedIdFromSurgeonList().ToString());
                patient.PriSiteId = Helper.ToNullable<System.Int32>(SurgeonAndSite.GetSelectedIdFromSiteList().ToString());
                patient.Undel = DateExplanatoryStatementReturned.Checked;

                patient.IndiStatusId = Helper.ToNullable<System.Int32>(PatientIndigenousStatusId.SelectedValue);
                patient.NhiNo = Helper.ToNullable(PatientNHINumber.Text);
                patient.NoNhiNo = (PatientNHIUnknown.Checked);
                patient.AborStatusId = Helper.ToNullable<System.Int32>(PatientAboriginalStatusId.SelectedValue);
                patient.McareNo = Helper.ToNullable(PatientMedicareNo.Text) + Helper.ToNullable(PatientMedicareNoRef.Text);
                patient.NoMcareNo = (PatientMedicareNoUnknown.Checked);
                patient.StateId = Helper.ToNullable<System.Int32>(PatientStateId.SelectedValue);
                patient.DvaNo = Helper.ToNullable(PatientDVANumber.Text);
                patient.NoDvaNo = (PatientDVANumberUnknown.Checked);

                patient.DeathRelSurgId = Helper.ToNullable<System.Int32>(DeathRelatedToPrimaryProcedure.SelectedValue);
                patient.DateESSent = DateExplanatoryStatementSent.SelectedDate;

                patient.OptOffDate = OptOffDate.SelectedDate;
                patient.OptOffStatId = Helper.ToNullable<System.Int32>(OptOffStatusId.SelectedValue);

                patient = PatientHandler.SavePatientDetails(patient, PatientURN.Text);

                //If surgeon login just store the siteid_patdemo
                if (IsSurgeon || IsDataCollector)
                {
                    sessionData.PatientSiteId = Convert.ToInt32(patient.PriSiteId);
                }

                //If Admin login just store the Site Id value
                if (IsAdministrator || IsAdminCentral)
                {
                    sessionData.SiteId = Convert.ToInt32(patient.PriSiteId);
                }

                sessionData.PatientId = patient.PatId;
                sessionData.PatientURNNumber = PatientURN.Text;
                sessionData.PanelNewPatient = false;
                SaveSessionData(sessionData);

                isSaveSuccessful = true;
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "PatientDataValidationGroup");
                isSaveSuccessful = false;
            }
            return isSaveSuccessful;
        }
        #endregion SaveData

        #region LoadLookup
        /// <summary>
        /// Loading dropdown values from database tables
        /// </summary>
        protected void LoadLookup()
        {
            SessionData sessionData = GetSessionData();
            using (UnitOfWork lookupRepository = new UnitOfWork())
            {
                Helper.BindCollectionToControl(PatientTitleId, lookupRepository.Get_tlkp_Title(true), "Id", "Description");
                Helper.BindCollectionToControl(DeathRelatedToPrimaryProcedure, lookupRepository.Get_tlkp_DeathRelatedToSurgery(true), "Id", "Description");// bl.Get_tlkp_YesNo(false), "Id", "Description");
                Helper.BindCollectionToControl(PatientGenderId, lookupRepository.Get_tlkp_Gender(true), "Id", "Description");
                Helper.BindCollectionToControl(HealthStatusId, lookupRepository.Get_tlkp_HealthStatus(true), "Id", "Description");
                Helper.BindCollectionToControl(OptOffStatusId, lookupRepository.Get_tlkp_OptOffStatus(true, false), "Id", "Description");
                Helper.BindCollectionToControl(PatientStateId, lookupRepository.PatientRepository.GetStateListForPatient(true), "Id", "Description");
                Helper.BindCollectionToControl(PatientCountryId, lookupRepository.PatientRepository.GetCountryListForPatient(true), "Id", "Description");
                //For Australia patients
                Helper.BindCollectionToControl(PatientAboriginalStatusId, lookupRepository.Get_tlkp_AboriginalStatus(true), "Id", "Description");
                //For Newzealand patients
                Helper.BindCollectionToControl(PatientIndigenousStatusId, lookupRepository.Get_tlkp_IndigenousStatus(true), "Id", "Description");
                PatientDOB.MaxDate = System.DateTime.Now;
                PatientDateOfDeath.MaxDate = System.DateTime.Now;
                OptOffDate.MaxDate = System.DateTime.Now;
                DateExplanatoryStatementSent.MaxDate = System.DateTime.Now;
            }
        }
        #endregion LoadLookup

        #region Events
        /// <summary>
        /// Get IHI detail
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">event Argument</param>
        protected void GetIHIClicked(object sender, EventArgs e)
        {
            FeatureNotActiveLabel.Visible = true;
        }

        /// Save Patient details
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">Event Argument</param>
        protected void SaveButtonClicked(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (OptOffStatusId.SelectedValue.Equals("1") || OptOffStatusId.SelectedValue.Equals("2"))
                {
                    ExecuteOptOff();
                    _formSaved = true;
                }
                else
                {
                    _formSaved = SaveData();
                }

                if (_formSaved)
                {
                    InitData();

                    ShowingFormSavedMessage();
                    EnableDisableControls();
                    if (IsDataCollector || IsSurgeon)
                    {
                        Response.Redirect(Properties.Resource2.SurgeonHome);
                    }
                    else
                    {
                        SessionData sessionData = GetSessionData();
                        if (sessionData.IsRedirectedFromCallScreen)
                        {
                            Response.Redirect(Properties.Resource2.CallCenterWorkList, false);
                        }
                        else
                        {
                            Response.Redirect(Properties.Resource2.OperationDetailsPath, false);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Performs the opt off operation
        /// </summary>
        private void ExecuteOptOff()
        {
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                SessionData sessionData = GetSessionData();
                patientRepository.PatientRepository.Update_OptOffDetails(patientRepository,
                                                                         sessionData.PatientId.ToString(),
                                                                         OptOffStatusId.SelectedValue,
                                                                         (DateTime)OptOffDate.SelectedDate,
                                                                         DateExplanatoryStatementReturned.Checked);
                modifiedStatus.Value = "F";
                InitSurgeonSiteList();
                SaveReferrerForBackButton();
                LoadLookup();
                InitData();
                SetAutoPopulate();

                EnableDisableControls();
                ShowingFormSavedMessage();
                SurgeonAndSite.EnableSiteDropDownEvenIfItHasJustOneValue = false;
            }
        }

        /// <summary>
        /// Redirect to previous page
        /// </summary>
        /// <param name="sender">Sender of the event</param>
        /// <param name="e">Event Argument</param>
        protected void BackButtonClicked(object sender, EventArgs e)
        {
            if (IsSurgeon || IsDataCollector)
            {
                Response.Redirect(Properties.Resource2.SurgeonHome);
            }
            else
            {
                SessionData sessionData;
                sessionData = GetDefaultSessionData();
                //If sessiondata has some value
                if (sessionData != null)
                {
                    if (sessionData.IsRedirectedFromCallScreen)
                    {
                        // As it is redirected from Call Center Worklist, redirecting it back to Call Center Worklist
                        Response.Redirect(Properties.Resource2.CallCenterWorkList);
                    }
                    else
                    {
                        if (sessionData.PatientId != 0)
                        {
                            //If it is not a new record
                            Response.Redirect(Properties.Resource2.PatientHomePath);
                        }
                        else
                        {
                            //Don't have nay existing patient id
                            Response.Redirect(Properties.Resource2.PatientSearchPath);
                        }
                    }
                }
                else
                {
                    //Don't have any session data - Redirect to search
                    Response.Redirect(Properties.Resource2.PatientSearchPath);
                }
            }
        }

        // Display Patient Saved information
        private void ShowingFormSavedMessage()
        {
            ((Label)FormSavedMessageLabel).Visible = _formSaved;
            if (_formSaved)
            {
                ((Label)FormSavedMessageLabel).Text = "Data has been saved - " + DateTime.Now.ToString();
                _formSaved = false;
            }
        }

        /// <summary>
        /// Hide or Show Medicare details controls as per country selected
        /// </summary>
        /// <param name="sender">Sender of the Event</param>
        /// <param name="e">Event Argument</param>
        protected void CountrySelectionChanged(object sender, EventArgs e)
        {
            HideAndShowMedicareDetails();
        }

        /// <summary>
        /// Enable/Disable some of the Patient details controls as per Patient Opt Off status selection
        /// </summary>
        /// <param name="sender">Sender of the event</param>
        /// <param name="e">Event Argument</param>
        protected void ddlPatient_OptOffStatusId_SelectedIndexChanged(object sender, EventArgs e)
        {
            OptOffChanged();
        }

        // Enabling or Disabling controls for patient details which should be removed if patient selected Opt Off
        private void OptOffChanged()
        {
            PatientOptOffStatusWarningLabel.Text = string.Empty;
            if (OptOffStatusId.SelectedValue == "0" || OptOffStatusId.SelectedValue == "" || OptOffStatusId.SelectedValue == "4")
            {
                PatientOptOffPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                OptOffDate.SelectedDate = null;
                if (!PatientHomePhoneUnknown.Checked) { PatientHomePhone.Enabled = true; }
                if (!PatientMobileUnknown.Checked) { PatientMobile.Enabled = true; }
            }
            else if (OptOffStatusId.SelectedValue == "3")
            {
                PatientOptOffPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            }
            else if (OptOffStatusId.SelectedValue == "2")
            {
                PatientOptOffPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                PatientOptOffStatusWarningLabel.Text = "Warning: Do not phone (Partial Opt Off)";
                PatientOptOffPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                PatientHomePhone.Enabled = false;
                PatientHomePhone.Text = string.Empty;
                PatientHomePhoneUnknown.Enabled = true;
                PatientHomePhoneUnknown.Checked = true;
                PatientMobile.Enabled = false;
                PatientMobile.Text = string.Empty;
                PatientMobileUnknown.Enabled = true;
                PatientMobileUnknown.Checked = true;
            }
            else if (OptOffStatusId.SelectedValue == "1")
            {
                PatientOptOffPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                PatientOptOffStatusWarningLabel.Text = "Warning: Patient will be deleted";
            }
            if (OptOffStatusId.SelectedValue == "1") { InfoPanel.Enabled = false; }
        }

        /// <summary>
        ///  Process patient details as per the Explanatory Statement Return selection
        /// </summary>
        /// <param name="sender">Sender of the Event</param>
        /// <param name="e">Event Argument</param>
        protected void ExplanatoryStatementReturnedUndeliverableChecked(object sender, EventArgs e)
        {
            using (UnitOfWork bl = new UnitOfWork())
            {
                if (DateExplanatoryStatementReturned.Checked)
                {
                    OptOffStatusId.SelectedValue = "3";
                    Dictionary<System.Web.UI.Control, Object> controlMapping = new Dictionary<System.Web.UI.Control, Object>();
                    controlMapping.Add(OptOffStatusId, 3);
                    PopulateControl(controlMapping);
                    OptOffDate.SelectedDate = DateTime.Now;

                    //This will enable the statement date field for editing if the user is an admin
                    if (IsAdministrator || IsAdminCentral)
                    {
                        DateExplanatoryStatementSent.Enabled = true;
                        //Add this line if the date should be auto set to current date in the UI
                        //DateExplanatoryStatementSent.SelectedDate = GetLocalDateTime(DateTime.Now);
                    }
                }
                else
                {
                    Helper.BindCollectionToControl(OptOffStatusId, bl.Get_tlkp_OptOffStatus(true, false), "Id", "Description");
                    DateExplanatoryStatementSent.Enabled = false;
                }
                OptOffChanged();
            }
        }
        #endregion Events

        #region CustomValidation
        /// <summary>
        /// Validating Patient URN Details
        /// </summary>
        protected void ValidatePatientURN(object source, ServerValidateEventArgs args)
        {
            if (string.IsNullOrEmpty(PatientURN.Text) || !CheckIfUrNoValid(SurgeonAndSite.GetSelectedIdFromSiteList().ToString(), PatientURN.Text))
            {
                if (string.IsNullOrEmpty(PatientURN.Text)) { CustomValidatorPatientURN.ErrorMessage = "Hospital UR Number is a required field"; } else { CustomValidatorPatientURN.ErrorMessage = "Hospital UR Number already exists for another patient"; }

                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Family Name
        /// </summary>
        protected void ValidatePatientFamilyName(object source, ServerValidateEventArgs args)
        {
            if (string.IsNullOrEmpty(PatientFamilyName.Text))
            {
                CustomValidatorFamilyName.ErrorMessage = "Family name is a required field";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Given Name
        /// </summary>
        protected void ValidatePatientGivenName(object source, ServerValidateEventArgs args)
        {
            if (string.IsNullOrEmpty(PatientGivenName.Text))
            {
                CustomValidatorGivenName.ErrorMessage = "Given name is a required field";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Date of Birth
        /// </summary>
        protected void ValidatePatientBirthdate(object source, ServerValidateEventArgs args)
        {
            if (PatientDOB.SelectedDate == null && PatientDOBUnknown.Checked == false)
            {
                CustomValidatorBirthdate.ErrorMessage = "DOB is a required field";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Gender
        /// </summary>
        protected void ValidatePatientGender(object source, ServerValidateEventArgs args)
        {
            if (PatientGenderId.SelectedIndex == 0)
            {
                CustomValidatorPatientGender.ErrorMessage = "Gender is a required field";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Country
        /// </summary>
        protected void ValidatePatientCountry(object source, ServerValidateEventArgs args)
        {
            if (PatientCountryId.SelectedIndex == 0)
            {
                CustomValidatorCountry.ErrorMessage = "Country is a required field";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Aboriginal Status
        /// </summary>
        protected void ValidatePatientAboriginalStatus(object source, ServerValidateEventArgs args)
        {
            if (PatientAboriginalStatusId.SelectedIndex == 0)
            {
                CustomValidatorPatientAboriginal.ErrorMessage = "Indigenous status is a required field";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Health Status
        /// </summary>
        protected void HealthStatusValidation(object source, ServerValidateEventArgs args)
        {
            if (HealthStatusId.SelectedIndex == 0)
            {
                CustomValidatorHealthStatus.ErrorMessage = "Vital status is a required field";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Opt Off Status
        /// </summary>
        protected void OptOffStatusValidation(object source, ServerValidateEventArgs args)
        {
            if (IsAdminCentral || IsAdministrator)
            {
                if (OptOffStatusId.SelectedIndex == 0)
                {
                    CustomValidatorOptOffStatus.ErrorMessage = "Opt off status is a required field";
                    args.IsValid = false;
                }
                else
                {
                    args.IsValid = true;
                }
            }
        }

        /// <summary>
        /// Validating Patient Medicare Number
        /// </summary>
        protected void ValidatePatientMedicareNumber(object source, ServerValidateEventArgs args)
        {
            if ((string.IsNullOrEmpty(PatientMedicareNo.Text) || string.IsNullOrEmpty(PatientMedicareNoRef.Text)) && PatientMedicareNoUnknown.Checked == false)
            {
                CustomValidatorMedicareNumber.ErrorMessage = "Medicare No. and Medicare Ref No. are required fields, please fill or select 'No Medicare Number'";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient DVA Number
        /// </summary>
        protected void ValidatePatientDVANumber(object source, ServerValidateEventArgs args)
        {
            if (string.IsNullOrEmpty(PatientDVANumber.Text) && PatientDVANumberUnknown.Checked == false)
            {
                CustomValidatorPatientDVANumber.ErrorMessage = "DVA No. is a required field. Please complete DVA No. or Select 'No DVA Number'";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient NHI Number
        /// </summary>
        protected void ValidatePatientNHINumber(object source, ServerValidateEventArgs args)
        {
            if (string.IsNullOrEmpty(PatientNHINumber.Text) && PatientNHIUnknown.Checked == false)
            {
                CustomValidatorPatientNHINumber.ErrorMessage = "NHI No. is a required field. Please complete NHI No. or Select 'No NHI Number'";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Street Address
        /// </summary>
        protected void ValidatePatientStreetAddress(object source, ServerValidateEventArgs args)
        {
            if (string.IsNullOrEmpty(PatientStreetAddress.Text) && PatientAddressNotKnown.Checked == false)
            {
                CustomValidatorStreetAddress.ErrorMessage = "Street address is a required field. Please complete Street address or select 'Address Not Known'";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Suburb Address
        /// </summary>
        protected void ValidateSuburbAddress(object source, ServerValidateEventArgs args)
        {
            if (string.IsNullOrEmpty(PatientSuburbAddress.Text) && PatientAddressNotKnown.Checked == false)
            {
                CustomValidatorSuburbAddress.ErrorMessage = "Suburb is a required field";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Postcode Address
        /// </summary>
        protected void ValidatePatientPostCode(object source, ServerValidateEventArgs args)
        {
            if (((string.IsNullOrEmpty(PatientAddressPostcode.Text) && PatientAddressNotKnown.Checked == false && PatientPostcodeNotKnown.Checked == false)) ||
                ((string.IsNullOrEmpty(PatientAddressPostcode.Text) && PatientAddressNotKnown.Checked == false && PatientPostcodeNotKnown.Checked == true)))
            {
                if (PatientCountryId.SelectedValue == null)
                {
                    CustomValidatorPostCode.ErrorMessage = "Postcode is a required field. Please complete Postcode or select 'No Postcode'";
                    args.IsValid = false;
                }
                else { args.IsValid = true; }
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient State Address
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void ValidatePatientState(object source, ServerValidateEventArgs args)
        {
            if (PatientStateId.SelectedIndex == 0 && PatientAddressNotKnown.Checked == false)
            {
                CustomValidatorAddressState.ErrorMessage = "State /Territory is a required field";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Home Phone Number
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void ValidatePatientHomePhone(object source, ServerValidateEventArgs args)
        {
            if ((string.IsNullOrEmpty(PatientHomePhone.Text) && PatientHomePhoneUnknown.Checked == false))
            {
                CustomValidatorPatientHomePhone.ErrorMessage = "Home Phone Number is a required field. Please complete Home Phone Number or select  'No Home Phone Number'";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Mobile Number
        /// </summary>
        protected void ValidatePatientMobile(object source, ServerValidateEventArgs args)
        {
            if ((string.IsNullOrEmpty(PatientMobile.Text) && PatientMobileUnknown.Checked == false))
            {
                CustomValidatorPatientMobile.ErrorMessage = "Mobile Phone Number is a required field. Please complete Mobile Phone Number or select 'No Mobile Phone Number'";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validating Patient Date of Death
        /// </summary>
        protected void ValidatePatientDateOfDeath(object source, ServerValidateEventArgs args)
        {
            if ((DateOfDeathKnown.Checked == false) && (HealthStatusId.SelectedValue == "1"))
            {
                if (PatientDateOfDeath.SelectedDate.HasValue)
                {
                    DateTime? latestOperationDate = GetMaxOperationDate();
                    if (PatientDateOfDeath.SelectedDate > DateTime.Today)
                    {
                        CustomValidatorPatientDateOfDeath.ErrorMessage = "Date of Death is out of range. Please check Date of Death";
                        args.IsValid = false;
                        return;
                    }
                    else if (latestOperationDate != null && PatientDateOfDeath.SelectedDate < latestOperationDate)
                    {
                        CustomValidatorPatientDateOfDeath.ErrorMessage = "An operation has been recorded for this patient after the Date of Death. Please check Date of Death";
                        args.IsValid = false;
                        return;
                    }
                    else
                    {
                        args.IsValid = true;
                        return;
                    }
                }
                else
                {
                    CustomValidatorPatientDateOfDeath.ErrorMessage = "Date of Death is a required field. Please complete Date of Death or select 'Date of Death Not Known'";
                    args.IsValid = false; ;
                }
            }
            else
            {
                args.IsValid = true;
                return;
            }
        }


        protected void ValidateRelatedDeath(object source, ServerValidateEventArgs args)
        {
            args.IsValid = true;
            if (HealthStatusId.SelectedValue != "0")
            {
                if (string.IsNullOrEmpty(DeathRelatedToPrimaryProcedure.SelectedValue))
                {
                    DeathRelatedValidator.ErrorMessage = "Death Related to Bariatric Procedure is a mandatory field";
                    args.IsValid = false;
                }
            }
        }

        // Get Latest Operation Date
        private DateTime? GetMaxOperationDate()
        {
            SessionData sessiondata = GetSessionData();
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                DateTime? MaxOpDate = patientRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == sessiondata.PatientId).Max(y => y.OpDate);
                return MaxOpDate;
            }
        }

        protected void ESSDateValidation(object source, ServerValidateEventArgs args)
        {
            args.IsValid = true;
            if (DateExplanatoryStatementReturned.Checked)
            {
                if (DateExplanatoryStatementSent.SelectedDate == null)
                {
                    args.IsValid = false;
                    CustomValidatorESSDate.ErrorMessage = "The date that the Explanatory Statement was sent needs to be provided";
                }
                else if (DateTime.Compare((DateTime)DateExplanatoryStatementSent.SelectedDate, DateTime.Now.Date) > 0)
                {
                    args.IsValid = false;
                    CustomValidatorESSDate.ErrorMessage = "The date that the Explanatory Statement was sent can not be in the future";
                }
            }
        }

        /// <summary>
        /// Validating Patient Opt Off Date
        /// </summary>
        protected void ValidatePatientOptOffDate(object source, ServerValidateEventArgs args)
        {
            if ((OptOffStatusId.SelectedValue == "1" || OptOffStatusId.SelectedValue == "2") && OptOffDate.SelectedDate == null)
            {
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }
        #endregion CustomValidation

        //#region CustomValidators Prerender
        ///// <summary>
        ///// Event Handler for Heath Status Id control's PreRender event
        ///// </summary>
        ///// <param name="sender">Sender of the event</param>
        ///// <param name="e">Event Arguments</param>
        //protected void ddlPatient_HealthStatusId_PreRender(object sender, EventArgs e)
        //{
        //    String clientVisibleCriteria = String.Empty;
        //    clientVisibleCriteria = "document.getElementById('" + HealthStatusId.ClientID + "').value == '1'";
        //    CDMSValidation.EnablePanelInjectJS(clientVisibleCriteria, DeathControlsPanel, (DropDownList)HealthStatusId);
        //}
        //#endregion CustomValidators Prerender

        /// <summary>
        /// Validate if UR Number is valid for the patient is valid of not
        /// </summary>
        /// <param name="hospitalID">Hospital Id</param>
        /// <param name="urNo">Patient UR Number</param>
        /// <returns>Returns falg indicating whether UR Number for Patient is valid or Invalid</returns>
        public bool CheckIfUrNoValid(string hospitalID, string urNo)
        {
            bool isURNValid = false;
            SessionData sessionData;
            sessionData = GetDefaultSessionData();
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                int PatID = patientRepository.PatientRepository.GetPatientId(hospitalID == string.Empty ? -1 : Convert.ToInt32(hospitalID), urNo);
                if (PatID < 1)
                    isURNValid = true;
                else
                {
                    isURNValid = false;
                    if (sessionData.PatientId != null && sessionData.PatientId == PatID) { isURNValid = true; }
                }
            }
            return isURNValid;
        }

        /// <summary>
        /// Validating Surgeon details
        /// </summary>
        protected void ValidateSurgeon(object source, ServerValidateEventArgs args)
        {
            int? surgeonId = SurgeonAndSite.GetSelectedIdFromSurgeonList();
            if (surgeonId != null && surgeonId != -1)
            {
                //If surgeon is not active throw error
                using (UnitOfWork surgeonRepository = new UnitOfWork())
                {
                    if (!surgeonRepository.IsSurgeonActive(surgeonId)) { args.IsValid = false; } else { args.IsValid = true; }
                }
            }
        }

        /// <summary>
        /// Deleting patient from the data repository
        /// </summary>
        /// <param name="sender">Sender of the Event</param>
        /// <param name="e">Event Arguments</param>
        protected void DeletePatientClicked(object sender, EventArgs e)
        {
            try
            {
                SessionData sessionData;
                sessionData = GetDefaultSessionData();
                string errorMessage = string.Empty;
                int? patientID = -1;
                bool isPatientDeleted = false;

                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    if (sessionData.PatientId != null)
                    {
                        patientID = sessionData.PatientId;
                        isPatientDeleted = patientRepository.PatientRepository.DeletePatient(patientID, out errorMessage);
                        if (isPatientDeleted)
                        {
                            sessionData.ResetPatientData();
                            SaveSessionData(sessionData);
                            Response.Redirect(Properties.Resource2.PatientSearchPath);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
            }
        }
    }
}