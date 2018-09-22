using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.Business;
using log4net;
using System.Configuration;
using System.Web.Security;

namespace App.UI.Web
{
    public partial class Setup : System.Web.UI.Page
    {
        /// <summary>
        /// creating and assigning roles 
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            using (UnitOfWork memberDetails = new UnitOfWork())
            {
                //Create Privilege Roles
                memberDetails.MembershipRepository.CreatePrivilegeRoles();
                memberDetails.MembershipRepository.CreatePrivilegeRolesUser();
                //Create Site Roles
                //var sites = uow.tbl_InstituteRepository.Get();
                //foreach (var site in sites)
                //{
                 //   uow.MembershipRepository.CreateSiteRole((int)site.InstID);
                //}

                //Create Super user during the recovery mode
               string recoveryUser = ConfigurationManager.AppSettings[App.UI.Web.Views.Shared.Constants.APP_CONFIG_KEY_RECOVERY_USERNAME];
               string recoveryEmail = ConfigurationManager.AppSettings[App.UI.Web.Views.Shared.Constants.APP_CONFIG_KEY_RECOVERY_EMAIL];
                 if (recoveryUser != null)
                {
                    string superUser = recoveryUser; // from web.config for recovery mode  
                    MembershipUser user = Membership.GetUser(superUser);
                    if (user == null)
                    {
                        MembershipCreateStatus status;
                        Membership.CreateUser(superUser, App.UI.Web.Views.Shared.Constants.RECOVERY_ADMIN_PASSWORD, recoveryEmail, "The answer is yes", "yes", true, out status);

                        user = Membership.GetUser(superUser);
                        if (user != null)
                        {                            if (user.IsLockedOut)
                            {
                                user.UnlockUser();
                            }
                        }
                    }
                    //Assign the essential roles to the super user
                    memberDetails.MembershipRepository.EnableAdminPrivilege(superUser, true, false);
                }

            }

        }
    }
}