using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.Business;
using App.UI.Web.Views.Shared;
using CDMSValidationLogic;
using Telerik.Web.UI;
using System.Text;

namespace App.UI.Web.Views.Admin {
    public partial class CreateAccount : BasePage {
        /// <summary>
        /// Gets or sets Distinct User Site IDs
        /// </summary>
        public List<int> DistinctUserSiteIds { get; set; }

        // Gets or sets Boolean flag to determine whether form has been saved
        private Boolean _formSaved;

        // To determine whether this form is in edit mode or create mode 
        private bool IsEditMode {
            get {
                return EditingUser.Value != string.Empty;
            }
        }

        /// <summary>
        /// To obtain the User ID of the editing user 
        /// </summary>
        private string EditUserID {
            get {
                return EditingUser.Value;
            }
            set {
                EditingUser.Value = value;
            }
        }

        // To obtain the current user id regardless of editing or inserting
        private string UserId {
            get {
                if (IsEditMode) {
                    return EditingUser.Value;
                } else {
                    return UserIdControl.Text;
                }
            }
        }

        /// <summary>
        /// Initialize page controls for operation like create user or edit user
        /// </summary>
        /// <param name="sender">Create Account page as sender</param>
        /// <param name="e">Event Argument</param>
        protected void Page_Load(object sender, EventArgs e) {
            TurnTextBoxAutoCompleteOff();
            MembershipUser memberUser = null;
            if (!IsPostBack) {
                LoadLookup();
                SessionData sessionData;
                if (Session["UId"] != null) {
                    sessionData = GetSessionData();
                } else {
                    sessionData = new SessionData();
                }

                sessionData.UserId = Request.QueryString[Constants.QUERY_PARAM_USER_ID];
                if (sessionData.UserId != null && sessionData.UserId.Length > 0) {
                    memberUser = Membership.GetUser(sessionData.UserId);
                    if (memberUser != null) {
                        EditUserID = memberUser.UserName;
                        InitData(memberUser.UserName);
                    }
                }

                InitMembership(EditUserID);
            }

            ShowHidePanel();
        }

        // Initialize controls for edit user operation
        private void InitMembership(String userName) {
            SessionData sessionData;
            if (Session["UId"] != null) {
                sessionData = GetSessionData();
                userName = sessionData.UserId;
                sessionData.UserId = null;
            }

            MembershipUser memberUser = Membership.GetUser(userName);
            PageHeader.Title = "Add User Account";
            AccountLocked.Visible = IsEditMode;
            ResetPasswordButton.Visible = IsEditMode;
            CancelButton.PostBackUrl = Constants.URL_USER_LIST;

            if (IsEditMode) {
                UserRole userPrivilegeRole = null;
                Guid providerUserKey = (Guid)Membership.GetUser(memberUser.UserName).ProviderUserKey;
                tbl_User user;
                using (UnitOfWork userRepository = new UnitOfWork()) {
                    userPrivilegeRole = userRepository.MembershipRepository.GetUserPrivilegeRole(memberUser.UserName);

                    //Gets site ids for user
                    user = userRepository.tbl_UserRepository.Get(x => x.UId == providerUserKey).FirstOrDefault();
                    if (user == null) {
                        user = new tbl_User();
                    }

                    if (user.tlkp_Title != null && user.tlkp_Title.Description != null && user.LastName != null && user.FName != null) {
                        PageHeader.Title = "Manage Account for " + user.tlkp_Title.Description + " " + user.LastName + " " + user.FName;
                    }

                }

                UserIdControl.Text = EditUserID;
                UserIdControl.Font.Bold = true;
                UserIdControl.Enabled = false;
                AccountActive.Checked = memberUser.IsApproved;
                AccountLocked.Checked = memberUser.IsLockedOut;
                AccountLocked.Enabled = AccountLocked.Checked;
                Email.Text = memberUser.Email;

                if (userPrivilegeRole != null) {
                    UserRole.SelectedValue = UserRole.Items.FindByText(userPrivilegeRole.RoleDescription).Value;
                }
                //hide the checkSite button for Datacollector role
                HideCheckSites();
                string[] roles = Roles.GetRolesForUser(memberUser.UserName);
                List<string> siteRoles = new List<string>();
                foreach (string role in roles) {
                    //If its newzealand roles start with S_N if Australia they start with S_
                    if (role.StartsWith(BusinessConstants.SITE_NZ_ROLE_PREFIX) || role.StartsWith(BusinessConstants.SITE_ROLE_PREFIX)) {
                        siteRoles.Add(role);
                    }
                }

                LoadInstitute();
                using (UnitOfWork userRepository = new UnitOfWork()) {
                    int[] userSiteIds = null;
                    userSiteIds = userRepository.MembershipRepository.GetSiteIdsForUser(memberUser.UserName);
                    //checks the sites which user alread have access to
                    foreach (int Item in userSiteIds) {
                        SitesComboBox.SelectedValue = Item.ToString();
                        SitesComboBox.SelectedItem.Checked = true;
                        SitesCollector.SelectedValue = Item.ToString();
                        SitesCollector.SelectedItem.Checked = true;
                    }
                }
            } else {
                LoadInstitute();
                AccountActive.Checked = true;
            }
        }

        #region InitData
        /// <summary>
        /// Initialize method to initialize controls with the values
        /// </summary>
        /// <param name="userName">User Name for which data needs to be shown</param>
        protected void InitData(String userName) {
            Guid providerUserKey = (Guid)Membership.GetUser(userName).ProviderUserKey;
            tbl_User user;
            using (UnitOfWork userRepository = new UnitOfWork()) {
                user = userRepository.tbl_UserRepository.Get(x => x.UId == providerUserKey).FirstOrDefault();
            }

            if (user == null) {
                user = new tbl_User();
            }

            Dictionary<Control, Object> controlMapping = new Dictionary<Control, Object>();
            controlMapping.Add(UserTitle, user.TitleId);
            controlMapping.Add(UserGivenName, user.FName);
            controlMapping.Add(UserFamilyName, user.LastName);

            if (user.CountryId != null) {
                controlMapping.Add(UserCountry, user.CountryId);
            } else {
                controlMapping.Add(UserCountry, 1);
            }

            auditForm.ModifiedBy = user.LastUpdatedBy;
            if (user.LastUpdatedDateTime != null) {
                auditForm.ModifiedDateTime = user.LastUpdatedDateTime;
            }

            PopulateControl(controlMapping);

        }
        //hides checkSite button for datacollector role
        private void HideCheckSites() {
            if (UserRole.SelectedValue == "DATACOLLECTOR") {
                SitesComboBox.Visible = false;
                //showCheckedSites.Visible = false;
            } else if (UserRole.SelectedValue == "SURGEON")
                SitesCollector.Visible = false;

        }
        #endregion

        #region LoadLookup
        /// <summary>
        /// Loading lookup/dropdown control options from database
        /// </summary>
        protected void LoadLookup() {
            using (UnitOfWork lookupRepository = new UnitOfWork()) {
                Helper.BindCollectionToControl(UserTitle, lookupRepository.Get_tlkp_Title(true), "Id", "Description");
                Helper.BindCollectionToControl(UserCountry, lookupRepository.Get_tlkp_Country(false), "Id", "Description");

                if (IsAdministrator) {
                    // Load aspnet_PersonalizationAllUsers valeus
                    Helper.BindCollectionToControl(UserRole, lookupRepository.MembershipRepository.GetUserRolesMaster(true, false), "Id", "Description");
                } else {
                    // Do not load admin
                    Helper.BindCollectionToControl(UserRole, lookupRepository.MembershipRepository.GetUserRolesMaster(true, true), "Id", "Description");
                }
            }
        }

        //Creating a blank options for combobox control
        //private RadComboBoxItem GetBlankItem()
        //{
        //    return new RadComboBoxItem("--SELECT SITE--", "-1");
        //}

        // Creating a Combobox item for Site option
        private RadComboBoxItem GetSiteItem(SiteListItem siteItem) {
            return new RadComboBoxItem(siteItem.SiteName, siteItem.SiteId.ToString());
        }

        // Creating a Combobox item for State Option
        private RadComboBoxItem GetStateItem(SiteListItem stateItem, ref int stateID) {
            RadComboBoxItem stateOptions = new RadComboBoxItem(stateItem.SiteStateName, Convert.ToString(--stateID));
            stateOptions.IsSeparator = true;
            stateOptions.Font.Bold = true;
            return stateOptions;
        }

        /// <summary>
        /// Loading Site and State options
        /// </summary>
        protected void LoadInstitute() {
            using (UnitOfWork instituteRepository = new UnitOfWork()) {
                IEnumerable<SiteListItem> sites = instituteRepository.Get_AllInstituteApproved_WithStateDetails(UserCountry.SelectedValue);
                IEnumerable<int> stateList = sites.Select(x => x.SiteStateId).Distinct();
                int StateID = 0;
                //clear surgeon control
                SitesComboBox.Items.Clear();
                //clear datacollector control
                SitesCollector.Items.Clear();

                if (UserCountry.SelectedValue == "1") {
                    foreach (int state in stateList) {
                        if (state > 0) {
                            IEnumerable<SiteListItem> siteListForState = sites.Where(x => x.SiteStateId == state);
                            SitesComboBox.Items.Add(GetStateItem(siteListForState.FirstOrDefault(), ref StateID));
                            SitesCollector.Items.Add(GetStateItem(siteListForState.FirstOrDefault(), ref StateID));

                            foreach (SiteListItem singleSite in siteListForState) {
                                SitesComboBox.Items.Add(GetSiteItem(singleSite));
                                SitesCollector.Items.Add(GetSiteItem(singleSite));
                            }
                        }
                    }
                } else {
                    foreach (SiteListItem singleSite in sites) {
                        SitesComboBox.Items.Add(GetSiteItem(singleSite));
                        SitesCollector.Items.Add(GetSiteItem(singleSite));
                    }
                }
            }
        }
        #endregion

        #region CustomValidation
        /// <summary>
        /// Custom Validation for User Id
        /// </summary>
        /// <param name="source">User Id control as sender</param>
        /// <param name="validator">Server Validation event argument</param>
        protected void ValidateUserId(object source, ServerValidateEventArgs validator) {
            string userId = validator.Value;

            if (IsEditMode) {
                validator.IsValid = true;
            } else {
                using (UnitOfWork userRepository = new UnitOfWork()) {
                    validator.IsValid = userRepository.MembershipRepository.IsValidUserId(userId);
                }
            }
        }

        /// <summary>
        /// Custom Validation for User Instance Access
        /// </summary>
        /// <param name="source">Site Access control as source</param>
        /// <param name="validator">Server Vaidation event argument</param>
        //protected void ValidateUserInstanceAccess(object source, ServerValidateEventArgs validator)
        //{
        //    if ((SitesComboBox.SelectedIndex == 0) && (Site2.SelectedIndex == 0) && (Site3.SelectedIndex == 0)
        //        && (Site4.SelectedIndex == 0) && (Site5.SelectedIndex == 0) && (UserInstanceAccess.SelectedIndex == 0))
        //    {
        //        validator.IsValid = false;
        //    }
        //    else
        //    {
        //        validator.IsValid = true;
        //    }
        //}
        #endregion

        #region ShowHidePanel
        // Showing or Hiding site controls panel
        private void ShowHidePanel() {
            CDMSValidation.SetControlVisible(SitePanel,
                UserRole.SelectedValue == BusinessConstants.ROLE_NAME_SURGEON || UserRole.SelectedValue == BusinessConstants.ROLE_NAME_DATACOLLECTOR);
        }
        #endregion

        #region PreRenderSection
        /// <summary>
        /// Checks on Site Accessibility
        /// </summary>
        /// <param name="sender">User Country control as sender </param>
        /// <param name="e">Evet Argument</param>
        protected void CountryPreRender(object sender, EventArgs e) {
            //if (IsEditMode && !Page.IsPostBack)
            //{
            //    SiteAccessibility();
            //}
        }
        #endregion

        /// <summary>
        /// Selected Index Changed event handler for User Country control
        /// </summary>
        /// <param name="sender">User Country control as sender</param>
        /// <param name="e">Event Argument</param>
        protected void CountrySelectionChange(object sender, EventArgs e) {
            LoadInstitute();
            //GetSelectedSiteIds and put in temp before LoadInstitute();
            // string[] siteIds = GetSelectedSiteIds();
        }

        /// <summary>
        /// Saves user data in the database
        /// </summary>
        /// <param name="sender">Save Button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void SaveClicked(object sender, EventArgs e) {
            if (Page.IsValid == true) {
                if (IsSiteSelectionModified() == false) {
                    SaveUserData();
                } else {
                    string radalertscript = "<script language='javascript'>function f(){callConfirm(); Sys.Application.remove_load(f);}; Sys.Application.add_load(f);</script>";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "radalert", radalertscript);
                }
            }
        }

        // Processing Save User data
        private void SaveUserData() {
            _formSaved = SaveData(UserId);
            if (_formSaved) {
                InitData(UserId);
                InitMembership(UserId);
            }

            // SiteAccessibility();
            ShowHidePanel();
            ShowingFormSavedMessage();
        }
        /// <summary>
        /// Check whether Site selection has been modified for the user
        /// </summary>
        /// <returns>Returns a boolean flag which indicates whether Site Selection has been modified</returns>
        protected bool IsSiteSelectionModified() {
            bool result = false;
            List<int> oldUserSiteIds = new List<int>();
            List<int> newUserSiteIds = new List<int>();
            List<int> differentUserSiteIds = new List<int>();
            if (UserId != null) {
                SessionData sessionData;
                sessionData = GetSessionData();
                MembershipUser memberUser = Membership.GetUser(UserId);
                if (memberUser != null) {
                    using (UnitOfWork userRepository = new UnitOfWork()) {
                        //Gets site ids for user
                        oldUserSiteIds = userRepository.MembershipRepository.GetSiteIdsForUser(memberUser.UserName).ToList();
                    }
                    //looping through each checked item and accessing its value.
                    foreach (RadComboBoxItem checkeditem in SitesComboBox.CheckedItems) {
                        newUserSiteIds.Add(Convert.ToInt32(checkeditem.Value));
                    }
                    DistinctUserSiteIds = oldUserSiteIds.Except(newUserSiteIds).ToList();
                    using (UnitOfWork patientRepository = new UnitOfWork()) {
                        tbl_Patient patient;
                        Guid memberUserId = (Guid)memberUser.ProviderUserKey;
                        tbl_User user = patientRepository.tbl_UserRepository.Get(x => x.UId == memberUserId).FirstOrDefault();
                        int siteId;
                        if (user != null) {
                            for (int index = 0; index < differentUserSiteIds.Count(); index++) {
                                siteId = differentUserSiteIds[index];
                                patient = patientRepository.tbl_PatientRepository.Get(x => x.PriSiteId == siteId && x.PriSurgId == user.UserId).FirstOrDefault();
                                if (patient != null) {
                                    result = true;
                                    break;
                                }
                            }
                        }

                    }

                }
            }
            return result;

        }
        /// <summary>
        /// Processing Save User action
        /// </summary>
        /// <param name="sender">Sender is Ajac controls</param>
        /// <param name="e">Ajax Request event argument</param>
        protected void RadAjaxManager1_AjaxRequest(object sender, AjaxRequestEventArgs e) {
            if (e.Argument.ToString() == "ok") {
                SaveUserData();
            }
        }

        #region SaveData
        // Saving User data into the database
        private Boolean SaveData(String userName) {
            Boolean operationStatus = false;
            String fullName = UserGivenName.Text.ToString() + " " + UserFamilyName.Text.ToString();
            string errorMessage = string.Empty;
            bool isValidemail = true;

            try {
                string userId = UserIdControl.Text;
                string email = Email.Text;
                bool isActive = AccountActive.Checked;
                bool isUnlock = !AccountLocked.Checked;
                string password = Membership.GeneratePassword(Membership.MinRequiredPasswordLength, Membership.MinRequiredNonAlphanumericCharacters);
                string lastSavedBy = User.Identity.Name;
                string lastSavedDate = System.DateTime.Now.ToString();
                DateTime lastSecurityQuestionChangedDate;
                string privilegeRoleName = UserRole.SelectedValue;
                //capturing checked in site role names from teleric combobox
                string[] siteRoleNames = GetSelectedSiteRoleNames();
                string emailTemplatePath = Server.MapPath(Constants.URL_EMAIL_TEMPLATE_NEW_USER_ACCOUNT);

                using (UnitOfWork userRepository = new UnitOfWork()) {
                    if (IsEditMode) {
                        PageHeader.Title = "Manage Account for " + userName;

                        //For updating from "CreateAccount.aspx" page, lastSecurityQuestionChangedDate = existing value from userProfile (no change)
                        UserProfile userProfile = new UserProfile(userId);
                        MembershipUser memberUser = Membership.GetUser(userId);
                        memberUser.Email = email;
                        memberUser.IsApproved = isActive;
                        if (memberUser.IsLockedOut && isUnlock) {
                            memberUser.UnlockUser();
                        }

                        Membership.UpdateUser(memberUser);
                        lastSecurityQuestionChangedDate = userProfile.LastSecurityQuestionChangedDate.ToShortDateString() == "1/01/0001" ? memberUser.CreationDate : userProfile.LastSecurityQuestionChangedDate;
                        CreateRole(userId, privilegeRoleName, userRepository, siteRoleNames);
                    } else {
                        //For inserting from "CreateAccount.aspx" page, lastSecurityQuestionChangedDate = username CreateDate
                        MembershipCreateStatus status;
                        Membership.CreateUser(userId, password, email, "The answer is yes", "yes", isActive, out status);
                        if (status != MembershipCreateStatus.Success) {
                            string createUserError = String.Empty;
                            createUserError = MembershipCreateStatusError(status, createUserError);
                        }

                        CreateRole(userId, privilegeRoleName, userRepository, siteRoleNames);
                        if (SendPasswordEmail(userId, password, fullName, out errorMessage)) {
                            isValidemail = true;
                            ShowingFormSavedMessage();
                            SessionData sessionData = GetSessionData();
                            sessionData.UserId = userId;
                            EditingUser.Value = userId;
                        } else {
                            //if it comes to this part, the user profile has been created on DB already 
                            //BUT it is because the details (including auto-gernerated password) was not sent successfully, so delete it from the system 
                            isValidemail = false;
                            Membership.DeleteUser(userId);
                            DisplayCustomMessageInValidationSummary("Email error: " + errorMessage + ".  Please verify email with user.  User account is NOT created.", "UserDataValidationGroup");
                            return false;
                        }
                    }
                }

                if (isValidemail) {
                    SaveDataDB(userName);
                }

                operationStatus = true;
            } catch (Exception ex) {
                if (!string.IsNullOrEmpty(errorMessage)) {
                    DisplayCustomMessageInValidationSummary(ex.Message, "UserDataValidationGroup");
                }

                operationStatus = false;
            }
            return operationStatus;
        }

        // Adding or Removing site roles to User instance
        private static void CreateRole(string userId, string privilegeRoleName, UnitOfWork userRepository, string[] siteRoleNames) {
            foreach (UserRole userRole in userRepository.MembershipRepository.GetUserRoles()) {
                if (userRole.RoleName.Equals(privilegeRoleName)) {
                    userRepository.MembershipRepository.AddUserToRole(userId, privilegeRoleName);
                } else {
                    userRepository.MembershipRepository.RemoveUserFromRole(userId, userRole.RoleName);
                }
            }

            foreach (string siteRole in Roles.GetAllRoles()) {
                if (siteRole.StartsWith(BusinessConstants.SITE_ROLE_PREFIX) || siteRole.StartsWith(BusinessConstants.SITE_NZ_ROLE_PREFIX)) {
                    if (siteRoleNames.Contains(siteRole)) {
                        // Give access to user
                        userRepository.MembershipRepository.AddUserToRole(userId, siteRole);
                    } else {
                        // Remove access from user
                        userRepository.MembershipRepository.RemoveUserFromRole(userId, siteRole);
                    }
                }
            }
        }

        // Displaying Error message while trying to Create User
        private string MembershipCreateStatusError(MembershipCreateStatus createUserStatus, string createUserError) {
            switch (createUserStatus) {
                case MembershipCreateStatus.DuplicateUserName:
                    createUserError = "Username already exists. Please enter a different user name";
                    break;

                case MembershipCreateStatus.DuplicateEmail:
                    createUserError = "A username for that e-mail address already exists. Please enter a different e-mail address";
                    break;

                case MembershipCreateStatus.InvalidPassword:
                    createUserError = "The password provided is invalid. Please enter a valid password value";
                    break;

                case MembershipCreateStatus.InvalidEmail:
                    createUserError = "The e-mail address provided is invalid. Please check the value and try again";
                    break;

                case MembershipCreateStatus.InvalidAnswer:
                    createUserError = "The password retrieval answer provided is invalid. Please check the value and try again";
                    break;

                case MembershipCreateStatus.InvalidQuestion:
                    createUserError = "The password retrieval question provided is invalid. Please check the value and try again";
                    break;

                case MembershipCreateStatus.InvalidUserName:
                    createUserError = "The user name provided is invalid. Please check the value and try again";
                    break;

                case MembershipCreateStatus.ProviderError:
                    createUserError = "The authentication provider returned an error. Please verify your entry and try again. If the problem persists, please contact your system administrator";
                    break;

                case MembershipCreateStatus.UserRejected:
                    createUserError = "The user creation request has been canceled. Please verify your entry and try again. If the problem persists, please contact your system administrator";
                    break;

                default:
                    createUserError = "An unknown error occurred. Please verify your entry and try again. If the problem persists, please contact your system administrator";
                    break;
            }

            DisplayCustomMessageInValidationSummary(createUserError, "UserDataValidationGroup");
            return createUserError;
        }

        /// <summary>
        /// Saving data in the database 
        /// </summary>
        /// <param name="userName"></param>
        private void SaveDataDB(String userName) {
            tbl_User user;
            using (UnitOfWork userRepository = new UnitOfWork()) {
                Guid providerUserKey = (Guid)Membership.GetUser(userName).ProviderUserKey; ;
                user = userRepository.tbl_UserRepository.Get(x => x.UId == providerUserKey).FirstOrDefault();
                Boolean isNewRecord = false;
                if (user == null) {
                    user = new tbl_User();
                    isNewRecord = true;
                    user.UId = providerUserKey;
                }

                string familyName, givenName = string.Empty;
                familyName = UserFamilyName.Text.ToString().TrimStart(' ');
                familyName = familyName.TrimEnd(' ');
                givenName = UserGivenName.Text.ToString().TrimStart(' ');
                givenName = givenName.TrimEnd(' ');

                if (AccountActive.Checked) { user.AccountStatusActive = 1; } else { user.AccountStatusActive = 0; }

                if (AccountLocked.Checked) { user.AccountStatusLocked = 1; } else { user.AccountStatusLocked = 0; }

                user.TitleId = Helper.ToNullable<System.Int32>(UserTitle.SelectedValue);
                user.FName = Helper.ToNullable(givenName);
                user.LastName = Helper.ToNullable(familyName);
                user.CountryId = Helper.ToNullable<Int32>(UserCountry.SelectedValue);
                user.HPI_I = Helper.ToNullable<System.Int32>(UserHPII.Text);
                user.LastUpdatedDateTime = DateTime.Now;

                MembershipUser userInfo = Membership.GetUser();
                if (userInfo != null) {
                    user.LastUpdatedBy = userInfo.UserName;
                }

                if (isNewRecord == true) {
                    user.CreatedDateTime = DateTime.Now;
                    user.CreatedBy = userInfo.UserName;
                    userRepository.tbl_UserRepository.Insert(user);
                } else {
                    userRepository.tbl_UserRepository.Update(user);
                }

                userRepository.Save();
            }
        }
        #endregion

        // Sending Password Email to user
        private Boolean SendPasswordEmail(string username, string password, string userFullName, out string errorMessage, Boolean noNotificationEmail = false) {
            errorMessage = string.Empty;
            Boolean operationStatus = false;
            MembershipUser memberUser = Membership.GetUser(username);

            if (memberUser != null) {
                try {
                    System.Net.Mail.MailMessage emailMessage = new System.Net.Mail.MailMessage();
                    emailMessage.To.Clear();
                    emailMessage.To.Add(new System.Net.Mail.MailAddress(memberUser.Email.ToString()));
                    emailMessage.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["RECOVERY_EMAIL"].ToString());

                    emailMessage.Subject = ConfigurationManager.AppSettings["PROJECT_NAME"].ToString() + ": " + Properties.Resource.AccountRequestEmailSubject;
                    emailMessage.IsBodyHtml = false;

                    //'Open a file for reading
                    String fileName = Server.MapPath(Constants.URL_EMAIL_TEMPLATE_NEW_USER_ACCOUNT);
                    StreamReader fileContent = File.OpenText(fileName);

                    //'Now, read the entire file into a string
                    String emailMessageBodyContents = fileContent.ReadToEnd();
                    fileContent.Close();
                    fileContent.Dispose();
                    emailMessage.Body = emailMessageBodyContents;
                    emailMessage.Body = emailMessage.Body.Replace("<%UserFullName%>", userFullName);
                    emailMessage.Body = emailMessage.Body.Replace("<%Password%>", password);
                    emailMessage.Body = emailMessage.Body.Replace("<%UserName%>", username);
                    emailMessage.Body = emailMessage.Body.Replace("<%PROJECT_NAME%>", ConfigurationManager.AppSettings["PROJECT_NAME"].ToString());
                    emailMessage.Body = emailMessage.Body.Replace(@"<%PROJECT_URL%>", ConfigurationManager.AppSettings["PROJECT_URL"].ToString());
                    System.Net.Mail.SmtpClient mailClient = new System.Net.Mail.SmtpClient();
                    // need to be true for some server to receive email
                    mailClient.UseDefaultCredentials = true;
                    mailClient.Send(emailMessage);
                    operationStatus = true;
                } catch (Exception ex) {
                    operationStatus = false;
                    errorMessage = ex.Message.ToString();
                    logger.Error(ex.Message.ToString());
                    logger.Error(ex.StackTrace);
                }
            }

            return operationStatus;
        }

        /// <summary>
        /// Resetting User Password
        /// </summary>
        /// <param name="sender">Reset Password button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void ResetPasswordClicked(object sender, EventArgs e) {
            MembershipUser memberUser = Membership.GetUser(UserIdControl.Text);

            if (memberUser.IsLockedOut) {
                memberUser.UnlockUser();
            }

            using (UnitOfWork userRepository = new UnitOfWork()) {
                String fullname = UserGivenName.Text.ToString() + " " + UserFamilyName.Text.ToString();
                if (userRepository.MembershipRepository.ResetPassword(UserIdControl.Text, fullname, Server.MapPath(Constants.URL_EMAIL_TEMPLATE_PASSWORD_RECOVERY))) {
                    FormSavedMessage.Visible = true;
                    FormSavedMessage.Text = "User password has been successfully reset and emailed";
                } else {
                    FormSavedMessage.Visible = false;
                    DisplayCustomMessageInValidationSummary("Error occurred while resetting user password");
                }
            }
        }
        //Get roles from SitesComboBox component
        private string[] GetSelectedSiteRoleNames() {
            List<string> selectedRoles = new List<string>();
            string rolePrefix = string.Empty;
            if (UserCountry.SelectedValue == "2") { rolePrefix = App.Business.BusinessConstants.SITE_NZ_ROLE_PREFIX; } else { rolePrefix = App.Business.BusinessConstants.SITE_ROLE_PREFIX; }
            //check for selected SitesCollector item
            if (UserRole.SelectedValue == "DATACOLLECTOR") {
                RadComboBoxItem selectedItem = SitesCollector.SelectedItem;
                selectedRoles.Add(rolePrefix + selectedItem.Value);
            } else {
                foreach (RadComboBoxItem checkeditem in SitesComboBox.CheckedItems) {
                    selectedRoles.Add(rolePrefix + checkeditem.Value);
                    string _value = checkeditem.Value;
                }
            }

            return selectedRoles.ToArray();

        }
        /// <summary>
        /// Text Change event handler for the User Name
        /// </summary>
        /// <param name="sender">User Name control as sender</param>
        /// <param name="e">Event handler for Chnage </param>
        protected void UserNameChanged(object sender, EventArgs e) {
            if (Membership.GetUser(UserIdControl.Text) != null) {
                UserAvailabilityMessage.Text = "Username already exists";
                UserAvailabilityImage.ImageUrl = "../../Images/taken.gif";
                UserAvailabilityImage.Visible = true;
            } else {
                UserAvailabilityMessage.Text = "Username available!";
                UserAvailabilityImage.ImageUrl = "../../Images/available.gif";
                UserAvailabilityImage.Visible = true;
            }
        }

        //protected void btnSaveDraft_Click(object sender, EventArgs e)
        //{
        //    FormSaved = SaveData(UserId);
        //    if (FormSaved)
        //    {
        //        InitData(UserId);
        //        InitMembership(UserId);

        //    }

        //    ShowHidePanel();
        //    ShowingFormSavedMessage();
        //}

        //protected void btnSaveDraft_PreRender(object sender, EventArgs e)
        //{
        //    if (IsAdministrator)
        //    {
        //        ((Button)sender).Enabled = true;
        //    }
        //    else
        //    {
        //        ((Button)sender).Enabled = false;
        //    }

        //    ((Button)sender).Enabled = true;
        //}

        // Display form saved successfully message
        private void ShowingFormSavedMessage() {
            ((Label)FormSavedMessage).Visible = _formSaved;
            if (_formSaved) {
                ((Label)FormSavedMessage).Text = "Data has been saved - " + DateTime.Now;
                _formSaved = false;
            }
        }

        //protected void btnGetHPI_Click(object sender, EventArgs e)
        //{
        //    //FeatureNotActiveLabel.Visible = true;    
        //}


        /// <summary>
        /// Changing site accessibility as per the user role selection changes
        /// </summary>
        /// <param name="sender">User  Role dropdown control as sender</param>
        /// <param name="e">Event Handler</param>
        protected void UserRoleSelectionChange(object sender, EventArgs e) {
            SiteAccessibility();
        }

        // Showing and Hiding Add site button as per the selected User Role
        private void SiteAccessibility() {
            if (UserRole.SelectedValue == "DATACOLLECTOR") {
                SitesCollector.Visible = true;
                SitesComboBox.Visible = false;

            } else if (UserRole.SelectedValue == "SURGEON") {
                SitesCollector.Visible = false;
                SitesComboBox.Visible = true;

            }
        }


    }
}