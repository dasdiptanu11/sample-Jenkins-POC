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

namespace App.UI.Web.Views.Forms
{
    public partial class Site : BasePage
    {
        // Boolean flag that indicates that data is saved in database
        private Boolean _formSaved;

        // Gets or sets Site Status
        private static int? _siteStatus;

        /// <summary>
        /// Initialize page controls
        /// </summary>
        /// <param name="sender">Site Page as sender</param>
        /// <param name="e">Event Argument</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            CancelButton.PostBackUrl = Properties.Resource.ManageInstitute;
            TurnTextBoxAutoCompleteOff();
            if (!IsPostBack)
            {
                LoadLookup();
                InitData();
            }

            ShowHidePanel();
            ShowingFormSavedMessage();
        }

        /// <summary>
        /// Setting Page Title
        /// </summary>
        public void SetPageTitle()
        {
            Header.Title = "Edit Site";
        }

        #region Button
        /// <summary>
        /// Save Site data in database
        /// </summary>
        /// <param name="sender">Save Button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void SaveClicked(object sender, EventArgs e)
        {
            if (Page.IsValid == true)
            {
                _formSaved = SaveData();
                if (_formSaved)
                {
                    InitData();
                }

                ShowingFormSavedMessage();
            }
        }

        // Display Data saved message
        private void ShowingFormSavedMessage()
        {
            ((Label)FormSavedMessage).Visible = _formSaved;
            if (_formSaved)
            {
                ((Label)FormSavedMessage).Text = "Data has been saved - " + DateTime.Now.ToString();
                _formSaved = false;
            }
        }
        #endregion

        #region InitData
        // Initializing controls for Site related data
        private void InitData()
        {
            SessionData sessionData = GetSessionData();
            bool isNew = false;
            using (UnitOfWork siteRepository = new UnitOfWork())
            {
                tbl_Site site = siteRepository.tbl_SiteRepository.Get(x => x.SiteId == sessionData.SiteId).FirstOrDefault();
                Dictionary<System.Web.UI.Control, Object> controlMapping = new Dictionary<System.Web.UI.Control, Object>();
                if (site == null)
                {
                    site = new tbl_Site();
                    isNew = true;
                }

                _siteStatus = null;
                _siteStatus = site.SiteStatusId;
                controlMapping.Add(SiteId, site.SiteId);
                controlMapping.Add(SiteHPIO, site.HPIO);
                controlMapping.Add(SiteName, site.SiteName);
                controlMapping.Add(SitePrimaryContact, site.SitePrimaryContact);
                controlMapping.Add(SitePhone1, site.SitePh1);
                controlMapping.Add(SiteSecondaryContact, site.SiteSecondaryContact);
                controlMapping.Add(SitePhone2, site.SitePh2);
                controlMapping.Add(SiteAddress, site.SiteAddr);
                controlMapping.Add(SiteSuburb, site.SiteSuburb);
                controlMapping.Add(SiteStateId, site.SiteStateId);
                controlMapping.Add(SitePostCode, site.SitePcode);
                controlMapping.Add(SiteTypeId, site.SiteTypeId);
                //set default value = 1 active
                controlMapping.Add(SiteStatusId, site.SiteStatusId == null ? 1 : site.SiteStatusId);
                //set default value = 1 active
                controlMapping.Add(SiteCountryId, site.SiteCountryId == null ? 1 : site.SiteCountryId);
                ModifyPostcodeControlsStatus(site.SiteCountryId == null ? "1" : site.SiteCountryId.ToString());
                controlMapping.Add(PatientEAD, site.EAD);

                auditForm.ModifiedBy = site.LastUpdatedBy;
                auditForm.ModifiedDateTime = site.LastUpdatedDateTime;
                PopulateControl(controlMapping);
            }

            if (isNew) { SiteId.Text = string.Empty; }
            auditForm.ModifiedDateTime = System.DateTime.Now;
            auditForm.ModifiedBy = UserName;
        }
        #endregion

        #region SaveData
        /// <summary>
        /// Saving Site data in the database
        /// </summary>
        /// <returns>Returns flag indicating whether data is saved in database</returns>
        protected bool SaveData()
        {
            SessionData sessionData = GetSessionData();
            Boolean isNew = false;
            Boolean isFormSaved = false;
            try
            {
                using (UnitOfWork siteRepository = new UnitOfWork())
                {
                    tbl_Site site = siteRepository.tbl_SiteRepository.Get(x => x.SiteId == sessionData.SiteId).FirstOrDefault();

                    if (site == null)
                    {
                        site = new tbl_Site();
                        isNew = true;
                    }

                    site.HPIO = Helper.ToNullable(SiteHPIO.Text);
                    site.SiteName = Helper.ToNullable(SiteName.Text);
                    site.SitePrimaryContact = Helper.ToNullable(SitePrimaryContact.Text);
                    site.SitePh1 = Helper.ToNullable(SitePhone1.Text);
                    site.SiteSecondaryContact = Helper.ToNullable(SiteSecondaryContact.Text);
                    site.SitePh2 = Helper.ToNullable(SitePhone2.Text);
                    site.SiteAddr = Helper.ToNullable(SiteAddress.Text);
                    site.SiteSuburb = Helper.ToNullable(SiteSuburb.Text);
                    site.SiteStateId = Helper.ToNullable<System.Int32>(SiteStateId.SelectedValue);
                    site.SitePcode = Helper.ToNullable(SitePostCode.Text);
                    site.SiteCountryId = Helper.ToNullable<System.Int32>(SiteCountryId.SelectedValue);
                    site.SiteTypeId = Helper.ToNullable<System.Int32>(SiteTypeId.SelectedValue);
                    site.SiteStatusId = Helper.ToNullable<System.Int32>(SiteStatusId.SelectedValue);
                    site.EAD = PatientEAD.SelectedDate;
                    site.LastUpdatedBy = UserName;
                    site.LastUpdatedDateTime = System.DateTime.Now;

                    if (isNew)
                    {
                        site.CreatedBy = UserName;
                        site.CreatedByDateTime = System.DateTime.Now;
                        siteRepository.tbl_SiteRepository.Insert(site);
                    }
                    else
                    {
                        site.LastUpdatedBy = UserName;
                        site.LastUpdatedDateTime = System.DateTime.Now;
                        siteRepository.tbl_SiteRepository.Update(site);
                    }

                    siteRepository.Save();
                    UpdateSiteRoleName(siteRepository, site);
                    //adds a role if it is not exist - Checks internally
                    siteRepository.MembershipRepository.CreateSiteRole(site.SiteRoleName);
                    sessionData.SiteId = site.SiteId;
                    SaveSessionData(sessionData);
                }

                isFormSaved = true;
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "SiteDataValidationGroup");
                isFormSaved = false;
            }

            return isFormSaved;
        }

        // Updating Site Role Name
        private static void UpdateSiteRoleName(UnitOfWork siteRepository, tbl_Site site)
        {
            //must run after getting the SiteId
            if (site.SiteCountryId == 2)
            {
                site.SiteRoleName = App.Business.BusinessConstants.SITE_NZ_ROLE_PREFIX + site.SiteId.ToString();
            }
            else
            {
                site.SiteRoleName = App.Business.BusinessConstants.SITE_ROLE_PREFIX + site.SiteId.ToString();
            }

            siteRepository.tbl_SiteRepository.Update(site);
            siteRepository.Save();
        }
        #endregion

        #region LoadLookup
        /// <summary>
        /// Loading all Lookup/Dropdown options from the database
        /// </summary>
        protected void LoadLookup()
        {
            using (UnitOfWork lookupRepository = new UnitOfWork())
            {
                Helper.BindCollectionToControl(SiteTypeId, lookupRepository.Get_tlkp_SiteType(true), "Id", "Description");
                Helper.BindCollectionToControl(SiteStateId, lookupRepository.MembershipRepository.GetAustraliaStateList(true), "Id", "Description");
                Helper.BindCollectionToControl(SiteCountryId, lookupRepository.MembershipRepository.GetCountryList(true), "Id", "Description");
                Helper.BindCollectionToControl(SiteStatusId, lookupRepository.Get_tlkp_SiteStatus(true), "Id", "Description");
            }
        }
        #endregion LoadLookup

        #region CustomValidation
        /// <summary>
        /// Validating site name
        /// </summary>
        /// <param name="source">Site Name control as source</param>
        /// <param name="validator">Sever Validation event argument</param>
        protected void ValidateSiteName(object source, ServerValidateEventArgs validator)
        {
            SessionData sessionData = GetSessionData();

            //REDO - Should it allow 2 sites with same name?
            validator.IsValid = true;
            /*using (UnitOfWork bl = new UnitOfWork())
            {
                IEnumerable<tbl_Site> UniqueInstituteName = bl.tbl_SiteRepository.Get(x => (x.SiteName == txtSite_SiteName.Text && x.SiteId != sessionData.SiteId));
                if (UniqueInstituteName.Count() == 0)
                {
                    args.IsValid = true;
                }
                else if (UniqueInstituteName.Count() > 0)
                {
                    ((CustomValidator)source).ErrorMessage = "Site Name '" + txtSite_SiteName.Text + "' already exists.";

                    args.IsValid = false;
                }
                else
                {
                    args.IsValid = true;
                }
            }*/
        }

        /// <summary>
        /// Validating site post code
        /// </summary>
        /// <param name="source">Site Post Code control as source</param>
        /// <param name="validator">Server Validation event argument</param>
        protected void ValidateSitePostCode(object source, ServerValidateEventArgs validator)
        {
            if (SiteCountryId.SelectedValue == "1")
            {
                if (SitePostCode.Text == string.Empty)
                { validator.IsValid = false; }
                else
                { validator.IsValid = true; }
            }
        }

        /// <summary>
        /// Validating Site State
        /// </summary>
        /// <param name="source">Site State control as source</param>
        /// <param name="validator">Server Validation event argument</param>
        protected void ValidateSiteState(object source, ServerValidateEventArgs validator)
        {
            if (SiteCountryId.SelectedValue == "1")
            {
                if (SiteStateId.SelectedValue == string.Empty)
                { validator.IsValid = false; }
                else
                { validator.IsValid = true; }
            }
        }

        /// <summary>
        /// Validating Site Name
        /// </summary>
        /// <param name="source">Site Name control as source</param>
        /// <param name="validator">Server Validation event argument</param>
        protected void ValidateMissingSiteName(object source, ServerValidateEventArgs validator)
        {
            if (SiteName.Text == string.Empty)
            { validator.IsValid = false; }
            else
            { validator.IsValid = true; }
        }

        /// <summary>
        /// Validating Site Street
        /// </summary>
        /// <param name="source">Site Street control as source</param>
        /// <param name="validator">Server Validation event argument</param>
        protected void ValidateMissingSiteStreet(object source, ServerValidateEventArgs validator)
        {
            if (SiteAddress.Text == string.Empty)
            { validator.IsValid = false; }
            else
            { validator.IsValid = true; }
        }

        /// <summary>
        /// Validating Site Suburb
        /// </summary>
        /// <param name="source">Site Suburb control as source</param>
        /// <param name="validator">Server Validation event argument</param>
        protected void ValidatingMissingSiteSuburb(object source, ServerValidateEventArgs validator)
        {
            if (SiteSuburb.Text == string.Empty)
            { validator.IsValid = false; }
            else
            { validator.IsValid = true; }
        }

        /// <summary>
        /// Validating Site Type
        /// </summary>
        /// <param name="source">Site Type control as source</param>
        /// <param name="validator">Server Validation event argument</param>
        protected void ValidateSiteType(object source, ServerValidateEventArgs validator)
        {
            if (SiteTypeId.SelectedValue == string.Empty)
            { validator.IsValid = false; }
            else
            { validator.IsValid = true; }
        }

        /// <summary>
        /// Validting Site Status
        /// </summary>
        /// <param name="source">Site Status control as source</param>
        /// <param name="validator">Server Validation event argument</param>
        protected void ValidateSiteStatus(object source, ServerValidateEventArgs validator)
        {
            if (SiteStatusId.SelectedValue == string.Empty)
            {
                validator.IsValid = false;
                CustomValidatorSiteStatus.ErrorMessage = "Site status is a required field";
            }
            else
            {
                //If partcipating is changed to pending
                if (_siteStatus == 1 && SiteStatusId.SelectedValue == "2")
                {
                    validator.IsValid = false;
                    CustomValidatorSiteStatus.ErrorMessage = "Site status cannot be changed from 'Participating' to 'Pending'";
                }
            }
        }

        /// <summary>
        /// Validating Patient EAD
        /// </summary>
        /// <param name="source">Patient EAD control as source</param>
        /// <param name="validator">Server Validation event argument</param>
        protected void ValidatePatientEAD(object source, ServerValidateEventArgs validator)
        {
            if (PatientEAD.SelectedDate == null)
            {
                CustomValidatePatientEAD.ErrorMessage = "Ethics Approval Date is a required field";
                validator.IsValid = false;
            }
            else
            {
                validator.IsValid = true;
            }
        }
        #endregion

        /// <summary>
        /// Clicked event handler for Get HPI Button
        /// </summary>
        /// <param name="sender">Get HPI button as sender</param>
        /// <param name="e">Event argument</param>
        //protected void btnGetHPI_Click(object sender, EventArgs e)
        //{
        //    FeatureNotActiveLabel.Visible = true;
        //}

        // Update Postcode controls status
        private void ModifyPostcodeControlsStatus(string countryId)
        {
            if (countryId == "1")
            {
                //AUSTRALIA
                CustomValidatorSitePostCode.Enabled = true;
                RegularExpressionPostCode.Enabled = true;
                SitePostCodeLabel.Text = "Postcode *";
            }
            else if (countryId == "2")
            {
                //NEWZEALAND
                CustomValidatorSitePostCode.Enabled = false;
                RegularExpressionPostCode.Enabled = false;
                SitePostCodeLabel.Text = "Postcode";
            }
        }

        /// <summary>
        /// Enable/Disable Postcode control as per the country selection
        /// </summary>
        /// <param name="sender">Country control as sender</param>
        /// <param name="e">Event Argument</param>
        protected void CountrySelectionChanged(object sender, EventArgs e)
        {
            ModifyPostcodeControlsStatus(SiteCountryId.SelectedValue);
        }

        /// <summary>
        /// As per the Country selection deciing whether to show or hide state control
        /// </summary>
        /// <param name="sender">Site Country control as sender</param>
        /// <param name="e">Event Argument</param>
        protected void CountryPreRender(object sender, EventArgs e)
        {
            String clientVisibleCriteria = String.Empty;
            clientVisibleCriteria = "document.getElementById('" + SiteCountryId.ClientID + "').value == '1'";
            CDMSValidation.EnablePanelInjectJS(clientVisibleCriteria, StatePanel, (DropDownList)SiteCountryId);
        }

        /// <summary>
        /// Showing and Hiding State Panel
        /// </summary>
        private void ShowHidePanel()
        {
            CDMSValidation.SetControlVisible(StatePanel, SiteCountryId.SelectedValue == "1");
        }
    }
}
