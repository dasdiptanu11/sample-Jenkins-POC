using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.Business;
using App.UI.Web.Views.Shared;
using Telerik.Web.UI;

namespace App.UI.Web.Views
{
    public partial class SearchControl : System.Web.UI.UserControl
    {
        /// <summary>
        /// List of Surgeon
        /// </summary>
        public List<int?> Surgeons;

        /// <summary>
        /// List of Sites
        /// </summary>
        public List<int?> Sites;

        /// <summary>
        /// List of Roles
        /// </summary>
        public string[] Roles;

        // Helper instance
        Helper _helper = new Helper();

        /// <summary>
        /// Page Load event handler for the page
        /// </summary>
        /// <param name="sender">Search Control page as sender</param>
        /// <param name="e">Event Argument</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLookup();
            }
        }

        #region LoadLookup
        /// <summary>
        /// Loading Lookup/Dropdown options
        /// </summary>
        protected void LoadLookup()
        {
            using (UnitOfWork membershipRepository = new UnitOfWork())
            {
                bool isSiteSpecific = false;
                List<string> siteRoles = new List<string>();
                if (Roles != null)
                {
                    foreach (string role in Roles)
                    {
                        if (role.StartsWith(BusinessConstants.SITE_ROLE_PREFIX))
                        {
                            siteRoles.Add(role);
                            isSiteSpecific = true;
                        }
                    }

                    foreach (string role in Roles)
                    {
                        if (role == BusinessConstants.ROLE_NAME_ADMIN)
                        {
                            isSiteSpecific = false;
                        }
                    }
                }

                _helper.BindCollectionToControl(SurgeonSelection, membershipRepository.MembershipRepository.GetSurgeonUserListLookup().OrderBy(c => c.Description), "Id", "Description");
                _helper.BindCollectionToControl(SiteSelection, membershipRepository.Get_tbl_Site_Name(false).OrderBy(c => c.Description), "Id", "Description");
                ResetFilters();
            }
        }
        #endregion LoadLookup

        #region private methods
        /// <summary>
        /// setting checked/unchecked for all the combobox items
        /// </summary>
        /// <param name="radComboBoxList">ComboBox for which values to selected/deselected</param>
        /// <param name="selected">Flag to determine whether to select or deselect the value of the combobox item</param>
        public void Set(RadComboBox radComboBoxList, bool selected)
        {
            foreach (RadComboBoxItem comboBoxItem in radComboBoxList.Items)
            {
                comboBoxItem.Checked = selected;
            }
        }

        /// <summary>
        /// Resetting all combobox and set combobox item to be checked
        /// </summary>
        public void ResetFilters()
        {
            Set(SurgeonSelection, true);
            Set(SiteSelection, true);
        }
        #endregion
    }
}