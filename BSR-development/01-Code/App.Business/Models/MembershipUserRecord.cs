using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace App.Business
{
    /// <summary>
    /// Contains MembershipUser Record properties
    /// </summary>
    public class MembershipUserRecord
    {

        /// <summary>
        /// Full Name
        /// </summary>
        public string FullName { get; set; }

        /// <summary>
        /// Full Name
        /// </summary>
        public string UserName { get; set; }

        /// <summary>
        /// Full Name
        /// </summary>
        public string Email { get; set; }

        /// <summary>
        /// Full Name
        /// </summary>
        public DateTime CreationDate { get; set; }

        /// <summary>
        /// Last Login Date
        /// </summary>
        public DateTime? LastLoginDate { get; set; }

        /// <summary>
        /// Is Locked
        /// </summary>
        public bool IsLocked { get; set; }

        /// <summary>
        /// Is Active
        /// </summary>
        public bool IsActive { get; set; }

        /// <summary>
        /// Is Disabled
        /// </summary>
        public bool IsDisabled { get; set; }

        /// <summary>
        /// User Privilege Role
        /// </summary>
        public string UserPrivilegeRole { get; set; }

    }
}
