using System;
using System.Web.Profile;

namespace App.Business {
    /// <summary>
    /// contains user profile fields and proerties
    /// </summary>
    public class UserProfile {
        ProfileBase profileBase = null;

        public UserProfile(string username) {
            profileBase = ProfileBase.Create(username);
        }
        /// <summary>
        /// save base profile
        /// </summary>
        public void Save() {
            if (profileBase != null) {
                profileBase.Save();
            }
        }
        /// <summary>
        /// get and set full name
        /// </summary>
        public string FullName {
            get {
                return (string)profileBase.GetPropertyValue("FullName");
            }
            set {
                profileBase.SetPropertyValue("FullName", value);
            }
        }
        /// <summary>
        /// get and set SystemNotification
        /// </summary>
        public bool SystemNotification {
            get {
                return (bool)profileBase.GetPropertyValue("SystemNotification");
            }
            set {
                profileBase.SetPropertyValue("SystemNotification", value);
            }
        }
        /// <summary>
        /// get and set disabled profile base
        /// </summary>
        public bool Disabled {
            get {
                return (bool)profileBase.GetPropertyValue("Disabled");
            }
            set {
                profileBase.SetPropertyValue("Disabled", value);
            }

        }
        /// <summary>
        /// get and set PasswordReset value
        /// </summary>
        public bool PasswordReset {
            get {
                return (bool)profileBase.GetPropertyValue("PasswordReset");
            }
            set {
                profileBase.SetPropertyValue("PasswordReset", value);
            }
        }
        /// <summary>
        /// get and set UserWorkPhone
        /// </summary>
        public string UserWorkPhone {
            get {
                return (string)profileBase.GetPropertyValue("UserWkPh");
            }
            set {
                profileBase.SetPropertyValue("UserWkPh", value);
            }
        }
        /// <summary>
        /// get and set UserMobile
        /// </summary>
        public string UserMobile {
            get {
                return (string)profileBase.GetPropertyValue("UserMob");
            }
            set {
                profileBase.SetPropertyValue("UserMob", value);
            }
        }
        /// <summary>
        /// get and set Last SavedBy
        /// </summary>
        public string LastSavedBy {
            get {
                return (string)profileBase.GetPropertyValue("LastSavedBy");
            }
            set {
                profileBase.SetPropertyValue("LastSavedBy", value);
            }
        }
        /// <summary>
        /// get and set Last Saved Date
        /// </summary>
        public string LastSavedDate {
            get {
                return (string)profileBase.GetPropertyValue("LastSavedDate");
            }
            set {
                profileBase.SetPropertyValue("LastSavedDate", value);
            }
        }
        /// <summary>
        /// get and set Last SecurityQuestion ChangedDate
        /// </summary>
        public DateTime LastSecurityQuestionChangedDate {
            get {
                return (DateTime)profileBase.GetPropertyValue("LastSecurityQuestionChangedDate");
            }
            set {
                profileBase.SetPropertyValue("LastSecurityQuestionChangedDate", value);
            }
        }

    }
}
