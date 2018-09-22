using log4net;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web.Security;

namespace App.Business {
    public class MembershipRepository : IMembershipRepository {
        // Logger object to log
        private static readonly ILog _logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        #region IMembershipRepository Members
        /// <summary>
        /// Creates a new User Account
        /// </summary>
        /// <param name="userId">User Id</param>
        /// <param name="userName">User Name</param>
        /// <param name="password">Password</param>
        /// <param name="email">Email Id</param>
        /// <param name="systemNotification">System Notification</param>
        /// <param name="isActive">Is Active Flag</param>
        /// <param name="privilegeRoleName">Privilege Role Name</param>
        /// <param name="siteRoleNames">Site Role Name</param>
        /// <param name="emailTemplatePath">Template path for Email to be sent</param>
        /// <param name="userWorkPhone">User Work Phone</param>
        /// <param name="userMobile">User Mobile</param>
        /// <param name="lastSavedBy">Last Saved By</param>
        /// <param name="lastSavedDate">Last Saved Date</param>
        public void CreateNewUser(string userId,
            string userName,
            string password,
            string email,
            bool systemNotification,
            bool isActive,
            string privilegeRoleName,
            string[] siteRoleNames,
            string emailTemplatePath,
            string userWorkPhone,
            string userMobile,
            string lastSavedBy,
            string lastSavedDate) {
            MembershipCreateStatus status;
            Membership.CreateUser(userId, password, email, "The answer is yes", "yes", isActive, out status);

            if (status == MembershipCreateStatus.Success) {
                DateTime lastSecurityQuestionChangedDate;
                MembershipUser memberUser = Membership.GetUser(userId);
                lastSecurityQuestionChangedDate = memberUser.CreationDate;

                UpdateUser(userId,
                    userName,
                    email,
                    systemNotification,
                    isActive,
                    true,
                    privilegeRoleName,
                    siteRoleNames,
                    emailTemplatePath,
                    userWorkPhone,
                    userMobile,
                    lastSavedBy,
                    lastSavedDate,
                    lastSecurityQuestionChangedDate);
            } else {
                throw new ApplicationException(status.ToString());
            }

        }

        /// <summary>
        /// Update an existing user details
        /// </summary>
        /// <param name="userId">User Id</param>
        /// <param name="userName">User Name</param>
        /// <param name="email">Email Id</param>
        /// <param name="systemNotification">System Notification</param>
        /// <param name="isActive">Is Active Flag</param>
        /// <param name="unlock">Unlock Flag</param>
        /// <param name="privilegeRoleName">Privilege Role Name</param>
        /// <param name="siteRoleNames">Site Role Names</param>
        /// <param name="emailTemplatePath">Template Path for the email to be sent</param>
        /// <param name="userWorkPhone">User Work Phone number</param>
        /// <param name="userMobile">User Mobile Number</param>
        /// <param name="lastSavedBy">Last Saved By</param>
        /// <param name="lastSavedDate">Last Saved Date</param>
        /// <param name="lastSecurityQuestionChangedDate">Last Security Question Changed Date</param>
        public void UpdateUser(
            string userId,
            string userName,
            string email,
            bool systemNotification,
            bool isActive,
            bool unlock,
            string privilegeRoleName,
            string[] siteRoleNames,
            string emailTemplatePath,
            string userWorkPhone,
            string userMobile,
            string lastSavedBy,
            string lastSavedDate,
            DateTime lastSecurityQuestionChangedDate) {
            MembershipUser memberUser = Membership.GetUser(userId);
            if (memberUser != null) {
                memberUser.Email = email;
                memberUser.IsApproved = isActive;
                Membership.UpdateUser(memberUser);

                UserProfile userProfile = new UserProfile(userId);
                userProfile.FullName = userName;
                userProfile.SystemNotification = systemNotification;
                userProfile.Disabled = false;
                userProfile.UserWorkPhone = userWorkPhone;
                userProfile.UserMobile = userMobile;
                userProfile.LastSavedBy = lastSavedBy;
                userProfile.LastSavedDate = lastSavedDate;
                userProfile.LastSecurityQuestionChangedDate = lastSecurityQuestionChangedDate;
                userProfile.Save();

                if (memberUser.IsLockedOut && unlock) {
                    memberUser.UnlockUser();
                }

                foreach (UserRole pr in GetUserRoles()) {
                    if (pr.RoleName.Equals(privilegeRoleName)) {
                        AddUserToRole(userId, privilegeRoleName);
                    } else {
                        RemoveUserFromRole(userId, pr.RoleName);
                    }
                }

                foreach (string siteRole in Roles.GetAllRoles()) {
                    // A valid site role
                    if (siteRole.StartsWith(BusinessConstants.SITE_ROLE_PREFIX)) {
                        if (siteRoleNames.Contains(siteRole)) {
                            // Give access to user
                            AddUserToRole(userId, siteRole);
                        } else {
                            // Remove access from user 
                            RemoveUserFromRole(userId, siteRole);
                        }
                    }
                }
            }
        }


        /// <summary>
        ///  Get all membership users 
        /// </summary>
        /// <returns>Returns the collection of all membership users</returns>
        public IEnumerable<MembershipUserRecord> GetAllUsers() {
            List<MembershipUserRecord> userList = new List<MembershipUserRecord>();
            using (UnitOfWork userRepository = new UnitOfWork()) {

                foreach (MembershipUser user in Membership.GetAllUsers()) {
                    UserProfile userProfile = new UserProfile(user.UserName);
                    UserRole userPrivilegeRole = GetUserPrivilegeRole(user.UserName);
                    string userPrivilegeRoleName = userPrivilegeRole != null ? userPrivilegeRole.RoleDescription : "";
                    DateTime? lastLoginDate = user.CreationDate == user.LastLoginDate ? (DateTime?)null : user.LastLoginDate;

                    Guid userId = new Guid(user.ProviderUserKey.ToString());
                    String fullName = String.Empty;
                    tbl_User userDetails = userRepository.tbl_UserRepository.Get(x => x.UId == userId).FirstOrDefault();
                    if (userDetails != null) {
                        fullName = userDetails.FName + " " + userDetails.LastName;
                    }

                    userList.Add(new MembershipUserRecord { UserName = user.UserName, FullName = fullName, Email = user.Email, CreationDate = user.CreationDate, LastLoginDate = lastLoginDate, IsLocked = user.IsLockedOut, IsActive = user.IsApproved, IsDisabled = userProfile.Disabled, UserPrivilegeRole = userPrivilegeRoleName });
                }
            }

            return userList;
        }

        /// <summary>
        /// Get  the User Privilege Role of the User
        /// </summary>
        /// <param name="userId">User Id</param>
        /// <returns>Returns User Role</returns>
        public UserRole GetUserPrivilegeRole(string userId) {
            UserRole userPrivilegeRole = null;

            foreach (UserRole userRole in GetUserRoles()) {
                if (Roles.IsUserInRole(userId, userRole.RoleName)) {
                    userPrivilegeRole = userRole;
                    break;
                }
            }

            return userPrivilegeRole;
        }

        /// <summary>
        /// Checks whether the username exists or not 
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns flag indicating whether user id is valid or not</returns>
        public bool IsValidUserId(string userName) {
            MembershipUser user = Membership.GetUser(userName);
            if (user != null) {
                return false;
            } else {
                return true;
            }
        }

        /// <summary>
        /// Get User Id from User Name
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns User Id of the User</returns>
        public string GetUserId(string userName) {
            MembershipUser user = Membership.GetUser(userName);
            if (user != null) {
                return user.ProviderUserKey.ToString();
            } else {
                return string.Empty;
            }
        }

        /// <summary>
        /// Enable or Disable Admin privilege for the user
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="isAdmin">Flag indicating Admin privilege</param>
        /// <param name="isStateAdmin">Flag indicating Admin privilege for the state</param>
        public void EnableAdminPrivilege(string userName, bool isAdmin, bool isStateAdmin) {
            string adminRoleName = BusinessConstants.ROLE_NAME_ADMIN;

            //Admin Add/Remove 
            if (isAdmin) {
                if (!isStateAdmin) {
                    if (!Roles.IsUserInRole(userName, adminRoleName)) {
                        Roles.AddUserToRole(userName, adminRoleName);
                    }
                }
            } else {
                if (Roles.IsUserInRole(userName, adminRoleName)) {
                    Roles.RemoveUserFromRole(userName, adminRoleName);
                }
            }
        }

        /// <summary>
        /// Resetting Password for the User and send an email for temporary password
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="userFullName">User Full Name</param>
        /// <param name="emailTemplatePath">Template Path for the Email to be sent</param>
        /// <returns>Returns Flag indicating whether user password is successfully reset</returns>
        public bool ResetPassword(string userName, string userFullName, string emailTemplatePath) {
            _logger.Debug("IN ResetPassword");

            string errorLog = string.Empty;
            bool overallStatus = true;

            try {
                MembershipProvider membershipProvider = (MembershipProvider)Membership.Providers["ResetPasswordByAdmin"];
                MembershipUser memberUser = membershipProvider.GetUser(userName, false);
                string newPassword = memberUser.ResetPassword();

                UserProfile userProfile = new UserProfile(memberUser.UserName);
                userProfile.PasswordReset = true;
                userProfile.Save();

                SmtpClient mailClient = new SmtpClient();
                TextReader reader = new StreamReader(emailTemplatePath);
                string bodyTemplate = reader.ReadToEnd();

                MailMessage mailMessage = new MailMessage();
                mailMessage.To.Add(memberUser.Email);
                mailMessage.Subject = "Bariatric Surgery Registry (BSR): New Password";

                string emailContent = bodyTemplate;
                emailContent = emailContent.Replace("<%UserName%>", userName);
                emailContent = emailContent.Replace("<%UserFullName%>", userFullName);
                emailContent = emailContent.Replace("<%Password%>", newPassword);
                emailContent = emailContent.Replace("<%PROJECT_NAME%>", ConfigurationManager.AppSettings["PROJECT_NAME"].ToString());
                emailContent = emailContent.Replace("<%PROJECT_URL%>", ConfigurationManager.AppSettings["PROJECT_URL"].ToString());
                mailMessage.Body = emailContent;

                errorLog = string.Empty;
                errorLog += mailMessage.From.Address + "\r\n";
                errorLog += memberUser.Email + "\r\n";
                errorLog += mailMessage.Subject + "\r\n";

                mailClient.Send(mailMessage);
            } catch (Exception ex) {
                _logger.Error(ex.Message.ToString());
                _logger.Error(ex.StackTrace + errorLog);
                overallStatus = false;
            }

            _logger.Debug("OUT Reset Password");
            return overallStatus;
        }

        /// <summary>
        /// Add User to Specific Role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="roleName">Role in which user needs to be added</param>
        public void AddUserToRole(string userName, string roleName) {
            if (!Roles.IsUserInRole(userName, roleName)) {
                Roles.AddUserToRole(userName, roleName);
            }
        }

        /// <summary>
        /// Removing User from a User Role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="roleName">Role in which user needs to be removed</param>
        public void RemoveUserFromRole(string userName, string roleName) {
            if (Roles.IsUserInRole(userName, roleName)) {
                Roles.RemoveUserFromRole(userName, roleName);
            }
        }

        /// <summary>
        /// Creating a new Site Role
        /// </summary>
        /// <param name="siteRoleName">Site Role Name</param>
        /// <returns>Returns flag indicating whether add Site Role is successful or not </returns>
        public bool CreateSiteRole(string siteRoleName) {
            try {
                if (!Roles.RoleExists(siteRoleName)) {
                    Roles.CreateRole(siteRoleName);
                }
            } catch {
                return false;
            }

            return true;
        }

        /// <summary>
        /// Get all the Site Role which is assigned to User
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns Array of Site Roles of the User</returns>
        public string[] GetSiteRolesForUser(string userName) {
            string[] allUserRoles = Roles.GetRolesForUser(userName);
            List<string> siteRoles = new List<string>();

            foreach (string role in allUserRoles) {
                if (role.StartsWith(BusinessConstants.SITE_ROLE_PREFIX)) {
                    siteRoles.Add(role);
                }
            }

            return siteRoles.ToArray();
        }

        /// <summary>
        /// Get the Site Id for a user
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns an array Site Ids for the User</returns>
        public int[] GetSiteIdsForUser(string userName) {
            List<int> siteIds = new List<int>();
            string[] roles = null;
            roles = Roles.GetRolesForUser(userName);

            foreach (string role in roles) {
                if (role.StartsWith(BusinessConstants.SITE_ROLE_PREFIX)) {
                    try {
                        int siteId = Int32.Parse(role.Substring(BusinessConstants.SITE_ROLE_PREFIX.Length));
                        siteIds.Add(siteId);
                    } catch {
                    }
                }

                if (role.StartsWith(BusinessConstants.SITE_NZ_ROLE_PREFIX)) {
                    try {
                        int siteId = Int32.Parse(role.Substring(BusinessConstants.SITE_NZ_ROLE_PREFIX.Length));
                        siteIds.Add(siteId);
                    } catch {
                    }
                }
            }

            return siteIds.ToArray();
        }

        /// <summary>
        /// Get all the users in a specific role
        /// </summary>
        /// <param name="roleName">Role Name</param>
        /// <returns>Returns an array of User Names for a Role Name</returns>
        public string[] GetUsersInRole(string roleName) {
            if (Roles.RoleExists(roleName)) {
                return Roles.GetUsersInRole(roleName);
            }

            return null;
        }

        /// <summary>
        /// Get All User Roles
        /// </summary>
        /// <returns>Returns all the User Roles in the system</returns>
        public IEnumerable<UserRole> GetUserRoles() {
            List<UserRole> list = new List<UserRole>();
            list.Add(new UserRole() { RoleName = BusinessConstants.ROLE_NAME_SURGEON, RoleDescription = "Surgeon" });
            list.Add(new UserRole() { RoleName = BusinessConstants.ROLE_NAME_DATACOLLECTOR, RoleDescription = "Data Collector" });
            list.Add(new UserRole() { RoleName = BusinessConstants.ROLE_NAME_ADMIN, RoleDescription = "Admin Registry" });
            list.Add(new UserRole() { RoleName = BusinessConstants.ROLE_NAME_ADMINCENTRAL, RoleDescription = "Admin Central" });

            return list;
        }

        /// <summary>
        /// Get All User Role in the System
        /// </summary>
        /// <param name="withEmptyItem">Flag to add an empty item</param>
        /// <param name="isAdminCentral">Flag to include central admin role</param>
        /// <returns>Returns Lookup Items list of User Role</returns>
        public List<LookupItem> GetUserRolesMaster(bool withEmptyItem, bool isAdminCentral) {

            List<LookupItem> items = new List<LookupItem>();

            foreach (UserRole userRole in GetUserRoles()) {
                if (isAdminCentral) {
                    //Admin Central
                    if (userRole.RoleName.ToString().ToUpper() != "ADMINREGISTRY") {
                        items.Add(new LookupItem() { Id = userRole.RoleName.ToString(), Description = userRole.RoleDescription.ToString() });
                    }
                } else {
                    //Admin
                    items.Add(new LookupItem() { Id = userRole.RoleName.ToString(), Description = userRole.RoleDescription.ToString() });
                }
            }

            if (withEmptyItem) {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }

            return items;
        }

        /// <summary>
        /// Creates all the privilege roles 
        /// </summary>
        public void CreatePrivilegeRoles() {
            string[] initialRoles = { 
                BusinessConstants.ROLE_NAME_SURGEON,
                BusinessConstants.ROLE_NAME_DATACOLLECTOR,
                BusinessConstants.ROLE_NAME_ADMIN, 
                BusinessConstants.ROLE_NAME_ADMINCENTRAL
            };

            foreach (string role in initialRoles) {
                if (!Roles.RoleExists(role)) {
                    Roles.CreateRole(role);
                }
            }
        }

        /// <summary>
        /// Creates all the privilege roles 
        /// </summary>
        public void CreatePrivilegeRolesUser() {
            string[] initialRoles = { 
                BusinessConstants.ROLE_NAME_SURGEON,
                BusinessConstants.ROLE_NAME_DATACOLLECTOR,
                BusinessConstants.ROLE_NAME_ADMIN, 
                BusinessConstants.ROLE_NAME_ADMINCENTRAL
            };

            foreach (string role in initialRoles) {
                if (Roles.RoleExists(role)) {
                    string userId = role.ToString().ToLower();
                    string password = userId + "123@";
                    string email = "douglas.wong@monash.edu";
                    bool isActive = true;
                    MembershipCreateStatus status;
                    MembershipUser memUser = Membership.GetUser(userId);
                    if (memUser == null) {
                        Membership.CreateUser(userId, password, email, "The answer is yes", "yes", isActive, out status);
                    }

                    if (memUser != null) {
                        AddUserToRole(userId, role);
                    }
                }
            }
        }

        /// <summary>
        /// Check whether this user is an ADMIN (either Nationwide or Statewide)
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns flag indicating whether user is admin</returns>
        public bool IsAdministrator(string userName) {
            return Roles.IsUserInRole(userName, BusinessConstants.ROLE_NAME_ADMIN);
        }

        /// <summary>
        /// Check whether this user is an ADMIN (Statewide)
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns a flag indicating whether a user is state admin</returns>
        public bool IsStateAdministrator(string userName) {
            // return Roles.IsUserInRole(username, BusinessConstants.ROLE_NAME_STATEADMIN);
            return false;
        }

        /// <summary>
        /// Check if user has admin central role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Flag indicating whether user has admin central role</returns>
        public bool IsAdminCentral(string userName) {
            return Roles.IsUserInRole(userName, BusinessConstants.ROLE_NAME_ADMINCENTRAL);
        }

        /// <summary>
        /// Check if user has Data Collector Role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns flag indicating whether user has data collector role</returns>
        public bool IsDataCollector(string userName) {
            return Roles.IsUserInRole(userName, BusinessConstants.ROLE_NAME_DATACOLLECTOR);
        }

        /// <summary>
        /// Check if user has Follow up Staff role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns a flag indicating whether a user has Followup Staff role</returns>
        public bool IsFollowUpStaff(string userName) {
            // return Roles.IsUserInRole(username, BusinessConstants.ROLE_NAME_FOLLOWUP);
            return false;
        }

        /// <summary>
        /// Check if user has Surgeon Role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns a flag indicating whether a user has Surgeon role</returns>
        public bool IsSurgeon(string userName) {
            return Roles.IsUserInRole(userName, BusinessConstants.ROLE_NAME_SURGEON);
        }

        /// <summary>
        /// Get Surgeon Users list
        /// </summary>
        /// <returns>List of Users who has Surgeon User Role</returns>
        public List<LookupItem> GetSurgeonUserListLookup() {
            using (UnitOfWork userRepository = new UnitOfWork()) {
                MembershipUserCollection userList = new MembershipUserCollection();

                foreach (string userName in Roles.GetUsersInRole(BusinessConstants.ROLE_NAME_SURGEON)) {
                    userList.Add(Membership.GetUser(userName));
                }

                //ToDo: Check for UID
                //var surgeon = (from usr in userlist.Cast<MembershipUser>()
                //               join tbluser in bl.tbl_UserRepository.Get() on usr.ProviderUserKey equals tbluser.UId
                //               select new LookupItem() { Id = tbluser.UserId.ToString(), Description = tbluser.UserLastName + " " + tbluser.UserFName }
                //             ).ToList<LookupItem>();

                //return surgeon;

                // ToDo: Written to make this work temporary - To be deleted
                var surgeon = new List<LookupItem>();
                return surgeon;
            }

        }

        /// <summary>
        /// Get Surgeon users for User's site
        /// </summary>
        /// <param name="patientUserName">Patient User Name</param>
        /// <param name="value">Value flag</param>
        /// <param name="sitefilter">Site Filter</param>
        /// <returns>Returns list of Surgeons for User's site</returns>
        public List<LookupItem> GetSurgeonListLookupByUserSite(string patientUserName, Boolean withEmptyItem, string siteFilter = null) {
            Boolean siteFilterExist = (siteFilter != null && siteFilter != String.Empty);
            Boolean isUserAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN) || Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
            //Boolean IsSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));
            List<LookupItem> surgeonList = new List<LookupItem>();

            using (UnitOfWork unitOfWork = new UnitOfWork()) {
                // UserSiteRoleName  = get all site belong to current user
                string[] userSiteRoleName = unitOfWork.MembershipRepository.GetSiteRolesForUser(patientUserName); //viewer
                //List<String> EmptyArray = new List<string>();

                MembershipUserCollection userList = new MembershipUserCollection();

                // get all surgeon
                foreach (string userName in Roles.GetUsersInRole(BusinessConstants.ROLE_NAME_SURGEON)) {
                    String[] surgeonSite = unitOfWork.MembershipRepository.GetSiteRolesForUser(userName);
                    Boolean surgeonSiteInUserSiteRole = false;

                    foreach (String siteRole in userSiteRoleName) {
                        if (surgeonSite.Contains(siteRole)) {
                            // data manager , add only if surgeon exist in site
                            surgeonSiteInUserSiteRole = true;
                        }
                    }

                    //if site filter exist, then check for siterole = prefix+filter, else just check surgeon site contain site role
                    if (siteFilterExist) {
                        if (surgeonSite.Contains(BusinessConstants.SITE_ROLE_PREFIX + siteFilter)) {
                            userList.Add(Membership.GetUser(userName));
                        }

                        if (surgeonSite.Contains(BusinessConstants.SITE_NZ_ROLE_PREFIX + siteFilter)) {
                            userList.Add(Membership.GetUser(userName));
                        }
                    } else if (surgeonSiteInUserSiteRole || isUserAdmin) {
                        //admin add all
                        userList.Add(Membership.GetUser(userName));
                    }
                }

                if (siteFilterExist) {
                    //ToDo: Check for UID
                    //surgeonList = (from usr in userlist.Cast<MembershipUser>()
                    //               join tbluser in bl.tbl_UserRepository.Get() on usr.ProviderUserKey equals tbluser.UId
                    //               select new LookupItem() { Id = tbluser.UserId.ToString(), Description = tbluser.UserFamilyName + " , " + tbluser.UserGivenName + " [" + siteFilter + "-" + tbluser.UserId.ToString() + "]" }
                    //               ).ToList<LookupItem>();

                } else {
                    //ToDo: Check for UID
                    //                   surgeonList = (from usr in userlist.Cast<MembershipUser>()
                    //                                  join tbluser in bl.tbl_UserRepository.Get() on usr.ProviderUserKey equals tbluser.UId
                    //                                  select new LookupItem() { Id = tbluser.UserId.ToString(), Description = tbluser.UserFamilyName + " , " + tbluser.UserGivenName + " [" + tbluser.UserId.ToString() + "]" }
                    //                                  ).ToList<LookupItem>();
                }

                if (withEmptyItem) {
                    surgeonList.Insert(0, new LookupItem() { Id = null, Description = null });
                }

                return surgeonList;
            }

            //if (siteFilterExist)
            //{

            //    if (UserSiteRoleName.Contains(BusinessConstants.SITE_ROLE_PREFIX + siteFilter))
            //    {
            //        UserSiteRoleName = UserSiteRoleName.Where(x => x == BusinessConstants.SITE_ROLE_PREFIX + siteFilter).ToArray();
            //    }
            //    else
            //    {

            //        UserSiteRoleName = EmptyArray.ToArray();
            //    }
            //}
        }

        /// <summary>
        /// Get Site list for the User
        /// </summary>
        /// <param name="patientUserName">Patient User Name</param>
        /// <returns>Returns List of Sites</returns>
        public List<LookupItem> GetSiteLookupByUser(string patientUserName) {
            IMembershipRepository memberRepository = new MembershipRepository();

            Boolean isUserAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN) || Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
            int[] siteIds;
            List<LookupItem> siteList = new List<LookupItem>();
            using (UnitOfWork unitOfWork = new UnitOfWork()) {
                if (isUserAdmin) {
                    siteList = (from site in unitOfWork.tbl_SiteRepository.Get()
                                select new LookupItem() {
                                    Id = site.SiteId.ToString(),
                                    Description = site.SiteId + " - " + site.SiteName + " [" + site.tlkp_State.Description + "]"
                                }).ToList<LookupItem>();
                } else {
                    siteIds = memberRepository.GetSiteIdsForUser(patientUserName);

                    siteList = (from s in unitOfWork.tbl_SiteRepository.Get(null, null, "tlkp_state")
                                where siteIds.Contains(s.SiteId)
                                select new LookupItem() {
                                    Id = s.SiteId.ToString(),
                                    Description = s.SiteId + " - " + s.SiteName + " [" + s.tlkp_State.Description + "]"
                                }).ToList<LookupItem>();
                }
            }

            siteList.Insert(0, new LookupItem() { Id = null, Description = null });
            return siteList;
        }

        /// <summary>
        /// Get the list of states in Australia
        /// </summary>
        /// <param name="withEmptyItem">Flag to add an empty item</param>
        /// <returns>Returns list of States in Australia</returns>
        public List<LookupItem> GetAustraliaStateList(bool withEmptyItem) {
            List<LookupItem> items;
            using (UnitOfWork unitOfWork = new UnitOfWork()) {
                items = (from lookup in unitOfWork.tlkp_StateRepository.Get()
                         where (lookup.Id != 9 && lookup.Id != 10 && lookup.Id != 11)
                         select new LookupItem() {
                             Id = lookup.Id.ToString(),
                             Description = lookup.Description
                         }
                         ).ToList<LookupItem>();
            }

            if (withEmptyItem) {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }

            return items;
        }

        /// <summary>
        /// Get List of Country
        /// </summary>
        /// <param name="withEmptyItem">Flag to add an empty item</param>
        /// <returns>Returns List of Country</returns>
        public List<LookupItem> GetCountryList(bool withEmptyItem) {
            List<LookupItem> items;
            using (UnitOfWork unitOfWork = new UnitOfWork()) {
                items = (from lookup in unitOfWork.tlkp_CountryRepository.Get()
                         where (lookup.Id != 9 && lookup.Id != 10 && lookup.Id != 11)
                         select new LookupItem() {
                             Id = lookup.Id.ToString(),
                             Description = lookup.Description
                         }
                         ).ToList<LookupItem>();
            }

            if (withEmptyItem) {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }

            return items;
        }
        #endregion
    }
}
