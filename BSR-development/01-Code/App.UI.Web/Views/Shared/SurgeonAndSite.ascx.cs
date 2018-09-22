using App.Business;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Security;
using System.Web.UI.WebControls;

namespace App.UI.Web.Views.Shared
{
    /*
     User control with 2 dropdown lists - Surgeon and Site. Value of ddlSurgeon is set in accordance with 
     * value selected in for Site i.e surgeons having access to this sites will be displayed. The drop down also 
     * takes care of country of user in case CountryID is set to anything more than 0 and UseCountryID is set to true.
     */
    public partial class SurgeonAndSite : BaseUserControl
    {
        // Helper class instance
        Helper _helper = new Helper();

        // Flag that indicates whether Site List is Loaded on the screen
        private bool IsSiteListLoaded = false;

        /// <summary>
        /// Flag that indicates whether or not to add empty options in Surgeon list options
        /// </summary>
        /* Set/reset the following values to add an empty item in begining of Surgeon and/or site lists respectively
        * by default, an empty item will be added*/
        public bool AddEmptyItemInSurgeonList = true;

        /// <summary>
        /// Flag that indicates whether or not to add empty item in Site list options
        /// </summary>
        public bool AddEmptyItemInSiteList = true;

        /// <summary>
        /// Flag that indicates whether or not to add all the list in site options
        /// </summary>
        public bool AddAllItemInSiteList = false;
        /// <summary>
        /// Sets flag that indicates whether or not to add all list in site options
        /// </summary>
        public bool AddAllInSiteList
        {
            set
            {
                AddAllItemInSiteList = value;
            }
        }

        /// <summary>
        /// flag to indicates whether or not to enable site options control even if onlt has one option
        /// </summary>
        /* If set to false it will disable selecting from site drop down list if there is just 1 accessible site for corresponding surgeon */
        public bool EnableSiteDropDownEvenIfItHasJustOneValue = true;

        /// <summary>
        /// Textbox control of Patient URN
        /// </summary>
        public static TextBox PatientURNTextControl;

        #region Setting_Sizes_Of_Control
        /// <summary>
        /// Set width of Site label column
        /// </summary>
        public int SurgeonLabelWidth
        {
            set { SiteLabelColumn.Width = value; }
        }

        /// <summary>
        /// Gets or sets Patient URN text control value
        /// </summary>
        public TextBox URN
        {
            set { PatientURNTextControl = value; }
            get { return PatientURNTextControl; }
        }

        /// <summary>
        /// Sets width for the Surgeon label column
        /// </summary>
        public int SiteLabelWidth
        {
            set { SurgeonLabelColumn.Width = value; }
        }

        /// <summary>
        /// Sets Surgeon label vertical alignment
        /// </summary>
        public VerticalAlign SurgeonLabelVerticalAlignment
        {
            set { SurgeonLabelColumn.VerticalAlign = value; }
        }

        /// <summary>
        /// Sets left margin for the Surgeon label
        /// </summary>
        public string SurgeonLabelLeftMargin
        {
            set { SurgeonLabel.Style.Add("margin-left", value.ToString()); }
        }

        /// <summary>
        /// Sets left margin for the Site label
        /// </summary>
        public string SiteLabelWidthLeftMargin
        {
            set { SiteLabel.Style.Add("margin-left", value.ToString()); }
        }

        /// <summary>
        /// Sets left margin for the Surgeon options control
        /// </summary>
        public string SurgeonOptionsLeftMargin
        {
            set { SurgeonOptions.Style.Add("margin-left", value.ToString()); }
        }

        /// <summary>
        /// Sets left margin for Site Options control
        /// </summary>
        public string SiteOptionsLeftMargin
        {
            set { SiteOptions.Style.Add("margin-left", value.ToString()); }
        }

        /// <summary>
        /// Sets background color for Suregon Options control
        /// </summary>
        public string SurgeonOptionsBackgroundColor
        {
            set { SurgeonOptions.Style.Add("background-color", value.ToString()); }
        }

        /// <summary>
        /// Sets backgroun color for Site Options control
        /// </summary>
        public string SiteOptionsBackgroundColor
        {
            set { SiteOptions.Style.Add(" background-color", value.ToString()); }
        }

        /// <summary>
        /// Sets Surgeon options width
        /// </summary>
        public string SurgeonOptionsWidth
        {
            set { SurgeonOptions.Style.Add("width", value.ToString()); }
        }

        /// <summary>
        /// Sets Site options width
        /// </summary>
        public string SiteOptionsWidth
        {
            set { SiteOptions.Style.Add("width", value.ToString()); }
        }

        /// <summary>
        /// Sets width for Site Label
        /// </summary>
        /// <param name="width"></param>
        public void IncreaseSpaceForSiteRow(int width)
        {
            SpaceSiteLabel.Width = width;
        }

        /// <summary>
        /// Sets Cell spacing for the table in which controls are present
        /// </summary>
        public int IncreaseCellSpacing
        {
            set { TableHospitalAndSurgeons.CellSpacing = value; }
        }

        /// <summary>
        /// Sets Cell Padding for the table in which controls are present
        /// </summary>
        public int IncreaseCellPadding
        {
            set { TableHospitalAndSurgeons.CellPadding = value; }
        }

        /// <summary>
        /// Enabling or Disabling mandatory validator for Surgeon control
        /// </summary>
        public bool EnableMandatoryFieldValidatorForSurgeon
        {
            set { CustomValidatorSurgeon.Enabled = value; }
        }

        /// <summary>
        /// Sets Validation Group for Surgeon options control
        /// </summary>
        public string ValidationGroupForSurgeon
        {
            set { CustomValidatorSurgeon.ValidationGroup = value; }
        }

        /// <summary>
        /// Enabling or Disabling mandatory validator for Site control
        /// </summary>
        public bool EnableMandatoryFieldValidatorForSite
        {
            set { CustomValidatorSiteOptions.Enabled = value; }
        }

        /// <summary>
        /// Sets Validation Group for Site options control
        /// </summary>
        public string ValidationGroupForSite
        {
            set { CustomValidatorSiteOptions.ValidationGroup = value; }
        }

        /// <summary>
        /// Sets Error message for Surgeon control
        /// </summary>
        public string ErrorMessageEmptySurgeonString
        {
            set { CustomValidatorSurgeon.ErrorMessage = value; }
        }

        /// <summary>
        /// Sets Error message for Site control
        /// </summary>
        public string ErrorMessageEmptySite
        {
            set { CustomValidatorSiteOptions.ErrorMessage = value; }
        }

        /// <summary>
        /// Enabling or disabling Site options control
        /// </summary>
        public bool SiteOptionEnabled
        {
            set { SiteOptions.Enabled = value; }
        }

        public bool SurgonOptionEnabled {
            set { SurgeonOptions.Enabled = value; }
        }

        /// <summary>
        /// Gets Surgeon Client Id
        /// </summary>
        public string GetSurgeonClientId
        {
            get { return SurgeonOptions.ClientID; }
        }

        #endregion Setting_Sizes_Of_Control

        // Stores the value for Tab Indx on the Page
        private short _tabIndex;
        /// <summary>
        /// Gets or sets Tab Index options for Site and Surgeon control
        /// </summary>
        public short TabIndex
        {
            get
            {
                return _tabIndex;
            }
            set
            {
                _tabIndex = value;
                SiteOptions.TabIndex = (short)(value++);
                SurgeonOptions.TabIndex = (short)(value++);
            }
        }

        /// <summary>
        /// Adding On change event handler for Surgeon options
        /// </summary>
        /// <param name="method">Method to be executed for change event of change</param>
        public void AddClientMethodSurgeon(string method)
        {
            SurgeonOptions.Attributes.Add("onchange", method);
        }

        /// <summary>
        /// Page Load event handler for Page - Initializing controls with values
        /// </summary>
        /// <param name="sender">Surgeon and Site control</param>
        /// <param name="e">Event Argument</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsSiteListLoaded)
            {
                LoadLookup();
            }
        }

        #region LoadLookup
        /// <summary>
        /// Page Initialize event handler
        /// </summary>
        /// <param name="sender">Surgeon Site contol</param>
        /// <param name="e">Event Arguments</param>
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!IsSiteListLoaded)
            {
                LoadLookup();
            }
        }

        /// <summary>
        /// Page PreInitialize event handler
        /// </summary>
        /// <param name="sender">Surgeon and Site control</param>
        /// <param name="e">Event Arguments</param>
        protected void Page_Preinit(object sender, EventArgs e)
        {
            if (!IsSiteListLoaded)
            {
                LoadLookup();
            }
        }

        /// <summary>
        /// Setting Country for the Site
        /// </summary>
        /// <param name="patientUserControlId">Patient User Conytol Id</param>
        /// <param name="patientCountryId">Patient Country Id</param>
        public void SetCountryForSites(bool patientUserControlId, int patientCountryId)
        {
            SessionData sessionData = GetSessionData();
            sessionData.ConsiderCountryForSiteList = patientUserControlId;
            sessionData.CountryIDForSiteList = patientCountryId;
            SaveSessionData(sessionData);
        }

        /// <summary>
        /// Loading Lookup values for controls
        /// </summary>
        public void LoadLookup()
        {
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                SessionData sessionData = GetSessionData();
                int countryId = -1;
                SiteOptions.Items.Clear();
                SurgeonOptions.Items.Clear();
                tbl_PatientOperation patientOperation = null;
                tbl_Patient patient = null;
                if (sessionData.PatientOperationId != null)
                {
                    patientOperation = patientRepository
                        .tbl_PatientOperationRepository
                        .Get(x => x.PatientId == sessionData.PatientId && x.OpId == sessionData.PatientOperationId).FirstOrDefault();
                }

                //If Primary Site and Surgeon of Demographics are different to Primary Operation Site and Surgeon of Operation 
                //If it is Primary Operation - Use Primary Site and Surgeon details of Demographics instead of Operation
                string userNameValue = string.Empty;
                if (patientOperation != null)
                {
                    if (patientOperation.OpStat == 0)
                    {
                        patient = patientRepository.tbl_PatientRepository.Get(x => x.PatId == sessionData.PatientId).FirstOrDefault();
                        if (patient != null)
                        {
                            userNameValue = patientRepository.Get_Username(sessionData.PatientId);
                        }
                    }
                }

                if (AddAllItemInSiteList == true)
                {
                    Boolean isSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));
                    Boolean isDataCollector = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_DATACOLLECTOR));
                    List<LookupItem> hospitalList = new List<LookupItem>();
                    if (!String.IsNullOrEmpty(userNameValue) && !isDataCollector)
                    {
                        hospitalList = patientRepository.Get_HospitalList(userNameValue, countryId, false, false);
                    }
                    else
                    {
                        hospitalList = patientRepository.Get_HospitalList(UserName, countryId, false, false);
                    }

                    if (!isSurgeon && !isDataCollector)
                    { hospitalList.Insert(0, new LookupItem() { Id = "0", Description = "All" }); }

                    _helper.BindCollectionToControl(SiteOptions, hospitalList, "Id", "Description");
                }
                else
                {
                    if (!String.IsNullOrEmpty(userNameValue))
                    {
                        _helper.BindCollectionToControl(SiteOptions, patientRepository.Get_HospitalList(userNameValue, countryId, AddEmptyItemInSiteList, false), "Id", "Description");
                    }
                    else
                    {
                        _helper.BindCollectionToControl(SiteOptions, patientRepository.Get_HospitalList(UserName, countryId, AddEmptyItemInSiteList, false), "Id", "Description");
                    }
                }

                SiteOptions.DataBind();
                IsSiteListLoaded = true;
                if (SiteOptions.Items.Count > 0)
                {
                    if (AddEmptyItemInSiteList == false && AddEmptyItemInSurgeonList == false)
                    {
                        LoadSurgeonListForSite(Convert.ToInt32(SiteOptions.Items[0].Value));
                    }

                    if (AddAllItemInSiteList == true)
                    {
                        LoadSurgeonListForSite(Convert.ToInt32(SiteOptions.Items[0].Value));
                    }
                }
            }
        }

        #endregion LoadLookup

        /// <summary>
        /// Loading Surgeon list for a site
        /// </summary>
        /// <param name="siteId">Site id for which you Surgeons list is needed</param>
        /*This function needs UserName and not UserID to work!*/
        public void LoadSurgeonListForSite(int siteId)
        {
            Boolean isDataCollector = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_DATACOLLECTOR));
            Boolean isSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));
            if ((isDataCollector || isSurgeon) && siteId == 0)
            {
                siteId = Convert.ToInt32(SiteOptions.Items[0].Value);
            }
            using (UnitOfWork surgeonRepository = new UnitOfWork())
            {
                if (SurgeonOptions.Items.FindByText("") != null && SiteOptions.SelectedItem.Text.Equals("all", StringComparison.OrdinalIgnoreCase))
                {
                    SurgeonOptions.SelectedValue = string.Empty;
                }

                SurgeonOptions.Items.Clear();
                if (siteId > 0)
                {
                    _helper.BindCollectionToControl(SurgeonOptions, surgeonRepository.Get_SurgeonsForSites(siteId, AddEmptyItemInSiteList, UserName), "Id", "Description");
                }

                if (AddAllItemInSiteList == true && siteId == 0)
                {
                    if (!isSurgeon)
                    { SurgeonOptions.SelectedValue = "0"; }
                    _helper.BindCollectionToControl(SurgeonOptions, surgeonRepository.Get_tlkp_aspnet_user_Surgeon(false, true, UserName), "Id", "Description");
                }
            }

            SurgeonOptions.Enabled = true;
        }

        #region Setting_VisualProperties_Of_SurgeonAndSiteLists
        /// <summary>
        /// Changing label text for Surgeon Label
        /// </summary>
        /// <param name="surgeonLabelText">Text that needs to be displayed in Surgeon label</param>
        public void ChangeSurgeonLabelText(string surgeonLabelText)
        {
            SurgeonLabel.Text = surgeonLabelText;
        }

        /// <summary>
        /// Showing/Hiding Surgeon tooltip image
        /// </summary>
        /// <param name="isVisible">Flag that indicates whether to show or hide Surgeon tooltip</param>
        public void MakeSurgeonTooltipImageVisible(bool isVisible)
        {
            SurgeonOptionsInformationImage.Visible = isVisible;
        }

        /// <summary>
        /// Changing tooltip text for the Surgeon options
        /// </summary>
        /// <param name="surgeonTooltipText">Tooltip  text</param>
        public void ChangeSurgeonTooltipText(string surgeonTooltipText)
        {
            SurgeonOptionsInformationLabel.Text = surgeonTooltipText;
        }

        /// <summary>
        /// Changing Site label text
        /// </summary>
        /// <param name="siteLabelText">Site Label text</param>
        public void ChangeSiteLabelText(string siteLabelText)
        {

            SiteLabel.Text = siteLabelText;
        }

        /// <summary>
        /// Showing or hiding Site tool tip image
        /// </summary>
        /// <param name="isVisible">Flag that indicates whether to hide or show tooltip image for Site</param>
        public void MakeSiteTooltipImageVisible(bool isVisible)
        {
            SiteOptionsInformationImage.Visible = isVisible;
        }

        /// <summary>
        /// Changing Site Tooltip text
        /// </summary>
        /// <param name="siteTooltipText">Tooltip Text</param>
        public void ChangeSiteTooltipText(string siteTooltipText)
        {
            SiteOptionsInformationLabel.Text = siteTooltipText;
        }

        /// <summary>
        /// change label width for Surgeon label - incase adjustments required in U 
        /// </summary>
        /// <param name="surgeonLabelWidth">Surgeon Label width</param>
        public void SetSurgeonLabelWidth(int surgeonLabelWidth)
        {
            SurgeonLabel.Width = surgeonLabelWidth;
        }

        /// <summary>
        /// change label width for Site label - incase adjustments required in UI
        /// </summary>
        /// <param name="siteLabelWidth">Site Label Width</param>
        public void SetSiteLabelWidth(int siteLabelWidth)
        {
            SiteLabel.Width = siteLabelWidth;
        }
        #endregion Setting_VisualProperties_Of_SurgeonAndSiteLists


        #region Setting_Text_For_DropDownLists

        /// <summary>
        /// Sets dropdown text as selected text for Surgeon dropdownList
        /// </summary>
        /// <param name="surgeonName">Surgeon Name to select</param>
        /// <returns>Flag that indicates whether setting surgeon name is successful or not</returns>
        public bool SetDefaultValueForSurgeon(string surgeonName)
        {
            bool result = false;
            if (surgeonName != null)
            {
                ListItem listItem = SurgeonOptions.Items.FindByText(surgeonName);
                if (listItem != null)
                {
                    SurgeonOptions.SelectedValue = listItem.Value;
                    result = true;
                }
            }

            return result;
        }

        /// <summary>
        /// Sets dropdown text as selected text for Site dropdownList
        /// </summary>
        /// <param name="siteName">Site name to select</param>
        /// <returns>returns true if Text found in list</returns>
        public bool SetDefaultValueForSite(string siteName)
        {
            bool result = false;
            if (siteName != null)
            {
                ListItem listItem = SiteOptions.Items.FindByText(siteName);
                if (listItem != null)
                {
                    SiteOptions.SelectedValue = listItem.Value;
                    LoadSurgeonListForSite(Convert.ToInt32(SiteOptions.SelectedValue));
                    result = true;
                }
            }

            return result;
        }

        /// <summary>
        /// Sets dropdown text based on SiteID
        /// </summary>
        /// <param name="siteId">Site Id to select</param>
        /// <returns>returns true if Id found in list</returns>
        public bool SetDefaultTextForGivenSiteID(int? siteId)
        {
            bool result = false;
            if (siteId > 0)
            {
                ListItem listItem = SiteOptions.Items.FindByValue(siteId.ToString());
                if (listItem != null)
                {
                    SiteOptions.SelectedValue = listItem.Value;
                    LoadSurgeonListForSite(Convert.ToInt32(SiteOptions.SelectedValue));
                    result = true;
                }
            }

            return result;
        }

        /// <summary>
        /// Sets dropdown text based on SurgeonId
        /// </summary>
        /// <param name="surgeonId">Surgeon Id to select</param>
        /// <returns>returns true if Id found in list</returns>
        public bool SetDefaultTextForGivenSurgeonID(int? surgeonId)
        {
            bool result = false;
            if (surgeonId > 0)
            {
                ListItem listItem = SurgeonOptions.Items.FindByValue(surgeonId.ToString());

                if (listItem != null)
                {
                    SurgeonOptions.SelectedValue = listItem.Value;
                    result = true;
                }
                else
                {
                    //If surgeon is not existing in the site add it and display
                    using (UnitOfWork surgeonRepository = new UnitOfWork())
                    {
                        string name = surgeonRepository.GetSurgeonById(surgeonId);
                        SurgeonOptions.Items.Add(new ListItem(name, surgeonId.ToString()));
                        SurgeonOptions.SelectedValue = surgeonId.ToString();
                    }
                }
            }

            return result;
        }

        /// <summary>
        /// Sets Site Name for selected site index
        /// </summary>
        /// <param name="siteOptionIndex">Site index from the list</param>
        /// <returns>Returns flag indicating if the Site is selected</returns>
        public bool SetDefaultTextForGivenSiteIndex(int siteOptionIndex)
        {
            bool result = false;
            if (siteOptionIndex >= SiteOptions.Items.Count || siteOptionIndex <= -1)
            {
                SiteOptions.SelectedIndex = -1;
            }
            else
            {
                SiteOptions.SelectedIndex = siteOptionIndex;
            }

            LoadSurgeonListForSite(Convert.ToInt32(SiteOptions.SelectedIndex));
            return result;
        }

        #endregion Setting_Text_For_DropDownLists

        #region Getting_SelectedDataItems_From_DropDownLists
        /// <summary>
        /// Get the selected Surgeon from the options
        /// </summary>
        /// <returns>Surgeon List Item</returns>
        public ListItem GetSelectedItemFromSurgeonList()
        {
            return SurgeonOptions.SelectedItem;
        }

        /// <summary>
        /// Get the selected Site from the options
        /// </summary>
        /// <returns>Site List Item</returns>
        public ListItem GetSelectedItemFromSiteList()
        {
            return SiteOptions.SelectedItem;
        }

        /// <summary>
        /// Get selected Surgeon Id
        /// </summary>
        /// <returns>Surgeon Id</returns>
        public int GetSelectedIdFromSurgeonList()
        {
            int surgeonId = -1;
            if (SurgeonOptions.SelectedIndex > -1 && SurgeonOptions.Items[SurgeonOptions.SelectedIndex].Value != string.Empty)
            {
                surgeonId = Convert.ToInt32(SurgeonOptions.Items[SurgeonOptions.SelectedIndex].Value);
            }

            return surgeonId;
        }

        /// <summary>
        /// Get selected Site Id
        /// </summary>
        /// <returns>Site Id</returns>
        public int GetSelectedIdFromSiteList()
        {
            int siteId = -1;
            if (SiteOptions.SelectedIndex != null && SiteOptions.SelectedIndex > -1 && SiteOptions.Items[SiteOptions.SelectedIndex].Value != "")
            {
                siteId = Convert.ToInt32(SiteOptions.Items[SiteOptions.SelectedIndex].Value);
            }

            return siteId;
        }

        /// <summary>
        /// Get selected Surgeon text
        /// </summary>
        /// <returns>Surgeon Text</returns>
        public string GetSelectedTextFromSurgeonList()
        {
            string Surgeon = string.Empty;
            if (SurgeonOptions.SelectedIndex > -1)
            {
                Surgeon = SurgeonOptions.Items[SurgeonOptions.SelectedIndex].Text;
            }

            return Surgeon;
        }

        /// <summary>
        /// Get selected Site Text
        /// </summary>
        /// <returns>Site Text</returns>
        public string GetSelectedTextFromSiteList()
        {
            string site = string.Empty;
            if (SiteOptions.SelectedIndex > -1)
            {
                site = SiteOptions.Items[SiteOptions.SelectedIndex].Text;
            }

            return site;
        }
        #endregion Getting_SelectedDataItems_From_DropDownLists

        #region Setting_Behavioural_Properties_Of_SurgeonAndSiteLists
        /// <summary>
        /// Enables/Disables the validator, configures the text and validation group for Surgeon list
        /// </summary>
        /// <param name="isEnableMandatoryFieldValidator">Flag to determins to enable/disable the validator</param>
        /// <param name="validationGroup">Validation Group</param>
        /// <param name="errorMessage">Error Message</param>
        public void ConfigureSurgeonValidator(bool isEnableMandatoryFieldValidator, string validationGroup, string errorMessage = null)
        {
            CustomValidatorSurgeon.Enabled = isEnableMandatoryFieldValidator;
            CustomValidatorSurgeon.ValidationGroup = validationGroup;
            CustomValidatorSurgeon.ErrorMessage = errorMessage == null ? CustomValidatorSurgeon.ErrorMessage : errorMessage;
        }

        /// <summary>
        /// Enables/Disables the validator, configures the text and validation group for Site list
        /// </summary>
        /// <param name="isEnableMandatoryFieldValidator">Flag to determins to enable/disable the validator</param>
        /// <param name="validationGroup">Validation Group</param>
        /// <param name="errorMessage">Error Message</param>
        public void ConfigureSiteValidator(bool isEnableMandatoryFioeldValidator, string validationGroup, string errorMessage)
        {
            CustomValidatorSiteOptions.Enabled = isEnableMandatoryFioeldValidator;
            CustomValidatorSiteOptions.ValidationGroup = validationGroup;
            CustomValidatorSiteOptions.ErrorMessage = errorMessage;
        }
        #endregion Setting_Behavioural_Properties_Of_SurgeonAndSiteLists

        /// <summary>
        /// Surgeons are loaded in accordance with site selected
        /// </summary>
        /// <param name="sender">Site Options as sender</param>
        /// <param name="e">Event Arguments</param>
        protected void SiteOptions_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (SiteOptions.Items.Count > 0)
            {
                LoadSurgeonListForSite(Convert.ToInt32(SiteOptions.Items[SiteOptions.SelectedIndex].Value == string.Empty ? "0" : SiteOptions.Items[SiteOptions.SelectedIndex].Value));
                if (URN != null)
                {
                    GetURNBySiteID();
                }
            }
        }

        // Get Patient URN by Site Id
        private bool GetURNBySiteID()
        {
            SessionData sessionData = GetSessionData();

            if (this.Parent.Parent.FindControl("PatientUpdatePanel") != null)
            {
                TextBox patientURNTextbox = this.Parent.Parent.FindControl("PatientUpdatePanel").FindControl("PatientURN") as TextBox;
                if (SiteOptions.SelectedValue != string.Empty)
                {
                    int siteId = Convert.ToInt32(SiteOptions.SelectedValue);
                    using (UnitOfWork patientRepository = new UnitOfWork())
                    {
                        if (sessionData.PatientId != 0)
                        {
                            tbl_URN patientURNDetails = patientRepository.tbl_URNRepository.Get(x => x.PatientID == sessionData.PatientId && x.tbl_Site.SiteId == siteId).FirstOrDefault();
                            if (patientURNDetails != null)
                            {
                                sessionData.PatientURId = patientURNDetails.URId.ToString();
                                //Refresh text box 
                                if (patientURNTextbox != null) { patientURNTextbox.Text = patientURNDetails.URNo; }
                                return true;
                            }
                        }
                        else if (sessionData.PatientId == 0)
                        {
                            //New patient just return true will leave the value as it is.
                            return true;
                        }
                    }
                }

                sessionData.PatientURId = string.Empty;
                patientURNTextbox.Text = string.Empty;
            }

            if (this.Parent.Parent.FindControl("PatientOperationUpdatePanel") != null)
            {
                TextBox hospitalMRNumberTextBox = this.Parent.Parent.FindControl("PatientOperationUpdatePanel").FindControl("HospitalMRNumber") as TextBox;
                if (SiteOptions.SelectedValue != string.Empty)
                {
                    int siteId = Convert.ToInt32(SiteOptions.SelectedValue);
                    using (UnitOfWork bl = new UnitOfWork())
                    {
                        if (sessionData.PatientId != 0)
                        {
                            tbl_URN patientURNDetails = bl.tbl_URNRepository.Get(x => x.PatientID == sessionData.PatientId && x.tbl_Site.SiteId == siteId).FirstOrDefault();
                            if (patientURNDetails != null)
                            {
                                //Refresh text box 
                                if (hospitalMRNumberTextBox != null) { hospitalMRNumberTextBox.Text = patientURNDetails.URNo; }
                                return true;
                            }
                        }
                        else if (sessionData.PatientId == 0)
                        {
                            //New patient just return true will leave the value as it is.
                            return true;
                        }
                    }
                }

                hospitalMRNumberTextBox.Text = string.Empty;
            }

            return false;
        }

        /// <summary>
        /// Validate Site Options
        /// </summary>
        /// <param name="source">Site Options as sender</param>
        /// <param name="args">Validate Event Argument</param>
        protected void ValidateSiteOptions(object source, ServerValidateEventArgs args)
        {
            if (string.IsNullOrEmpty(SiteOptions.Text) || string.IsNullOrWhiteSpace(SiteOptions.Text))
            { args.IsValid = false; }
            else
            { args.IsValid = true; }
        }

        protected void ValidateSurgeonOptions(object source, ServerValidateEventArgs args)
        {
            if (string.IsNullOrEmpty(SurgeonOptions.Text) || string.IsNullOrWhiteSpace(SurgeonOptions.Text))
            { args.IsValid = false; }
            else
            { args.IsValid = true; }
        }
    }
}