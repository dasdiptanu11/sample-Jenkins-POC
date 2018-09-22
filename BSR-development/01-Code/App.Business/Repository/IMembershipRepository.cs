using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Security;

namespace App.Business
{
    public interface IMembershipRepository
    {
        /// <summary>
        /// Creating new user in the system
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
        void CreateNewUser(string userId,
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
            string lastSavedDate);

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
        void UpdateUser(string userId,
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
            DateTime lastSecurityQuestionChangedDate);

        /// <summary>
        /// Get All the Users details
        /// </summary>
        /// <returns>Returns All User Detail</returns>
        IEnumerable<MembershipUserRecord> GetAllUsers();

        /// <summary>
        /// Get  the User Privilege Role of the User
        /// </summary>
        /// <param name="userId">User Id</param>
        /// <returns>Returns User Role</returns>
        UserRole GetUserPrivilegeRole(string userId);

        /// <summary>
        /// Check Whether User Id is valid or not
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns flag indicating whether user id is valid or not</returns>
        bool IsValidUserId(string userName);

        /// <summary>
        /// Enable or Disable Admin privilege for the user
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="isAdmin">Flag indicating Admin privilege</param>
        /// <param name="isStateAdmin">Flag indicating Admin privilege for the state</param>
        void EnableAdminPrivilege(string userName, bool isAdmin, bool isStateAdmin);

        /// <summary>
        /// Resetting Password for the User and send an email for temporary password
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="userFullName">User Full Name</param>
        /// <param name="emailTemplatePath">Template Path for the Email to be sent</param>
        /// <returns>Returns Flag indicating whether user password is successfully reset</returns>
        bool ResetPassword(string userName, string userFullName, string emailTemplatePath);

        /// <summary>
        /// Add User to Specific Role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="roleName">Role in which user needs to be added</param>
        void AddUserToRole(string userName, string roleName);

        /// <summary>
        /// Removing User from a User Role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="roleName">Role in which user needs to be removed</param>
        void RemoveUserFromRole(string userName, string roleName);

        /// <summary>
        /// Creating a new Site Role
        /// </summary>
        /// <param name="siteRoleName">Site Role Name</param>
        /// <returns>Returns flag indicating whether add Site Role has been successful </returns>
        bool CreateSiteRole(string siteRoleName);

        /// <summary>
        /// Get all the Site Role which is assigned to User
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns Array of Site Roles of the User</returns>
        string[] GetSiteRolesForUser(string userName);

        /// <summary>
        /// Get the Site Id for a user
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns an array Site Ids for the User</returns>
        int[] GetSiteIdsForUser(string userName);

        /// <summary>
        /// Get all the users in a specific role
        /// </summary>
        /// <param name="roleName">Role Name</param>
        /// <returns>Returns an array of User Names for a Role Name</returns>
        string[] GetUsersInRole(string roleName);

        /// <summary>
        /// Get All User Role in the System
        /// </summary>
        /// <param name="withEmptyItem">Flag to add an empty item</param>
        /// <param name="isAdminCentral">Flag to include central admin role</param>
        /// <returns>Returns Lookup Items list of User Role</returns>
        List<LookupItem> GetUserRolesMaster(bool withEmptyItem, bool isAdminCentral);

        /// <summary>
        /// Get All User Roles
        /// </summary>
        /// <returns>Returns all the User Roles in the system</returns>
        IEnumerable<UserRole> GetUserRoles();

        /// <summary>
        /// Create All Privilege Roles in the System
        /// </summary>
        void CreatePrivilegeRoles();

        /// <summary>
        /// Create All Privilege Roles Uses in the System
        /// </summary>
        void CreatePrivilegeRolesUser();

        /// <summary>
        /// Check if user has admin role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns flag indicating whether user is admin</returns>
        bool IsAdministrator(string userName);

        /// <summary>
        /// Check if user has admin central role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Flag indicating whether user has admin central role</returns>
        bool IsAdminCentral(string userName);

        /// <summary>
        /// Check if user has state administrator role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns a flag indicating whether a user is state admin</returns>
        bool IsStateAdministrator(string userName);

        /// <summary>
        /// Check if user has Data Collector Role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns flag indicating whether user has data collector role</returns>
        bool IsDataCollector(string userName);

        /// <summary>
        /// Check if user has Follow up Staff role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns a flag indicating whether a user has Followup Staff role</returns>
        bool IsFollowUpStaff(string userName);

        /// <summary>
        /// Check if user has Surgeon Role
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns a flag indicating whether a user has Surgeon role</returns>
        bool IsSurgeon(string userName);

        /// <summary>
        /// Get User Id of the User
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns User Id for the user</returns>
        string GetUserId(string userName);

        /// <summary>
        /// Get Surgeon Users list
        /// </summary>
        /// <returns>List of Users who has Surgeon User Role</returns>
        List<LookupItem> GetSurgeonUserListLookup();

        /// <summary>
        /// Get Site list for the User
        /// </summary>
        /// <param name="patientUserName">Patient User Name</param>
        /// <returns>Returns List of Sites</returns>
        List<LookupItem> GetSiteLookupByUser(string patientUserName);

        /// <summary>
        /// Get Suregron users for USer's site
        /// </summary>
        /// <param name="patientUserName">Patient User Name</param>
        /// <param name="value">Value flag</param>
        /// <param name="sitefilter">Site Filter</param>
        /// <returns>Returns list of Surgeons for User's site</returns>
        List<LookupItem> GetSurgeonListLookupByUserSite(string patientUserName, Boolean value, string sitefilter);

        /// <summary>
        /// Get the list of states in Australia
        /// </summary>
        /// <param name="withEmptyItem">Flag to add an empty item</param>
        /// <returns>Returns list of States in Australia</returns>
        List<LookupItem> GetAustraliaStateList(bool withEmptyItem);

        /// <summary>
        /// Get List of Country
        /// </summary>
        /// <param name="withEmptyItem">Flag to add an empty item</param>
        /// <returns>Returns List of Country</returns>
        List<LookupItem> GetCountryList(bool withEmptyItem);
    }
}


