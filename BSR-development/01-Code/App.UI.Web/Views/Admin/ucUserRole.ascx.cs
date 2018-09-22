using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.UI.Web.Views.Shared;
using App.Business;

namespace App.UI.Web.Views.Admin
{
    public partial class ucUserRole : BaseUserControl
    {
        /// <summary>
        /// Sets list of Site Roles Available
        /// </summary>
        public IEnumerable<SiteInfo> SiteRolesList
        {
            set
            {
                SitesList.DataSource = value;
                SitesList.DataTextField = "SiteName";
                SitesList.DataValueField = "SiteRole";
                SitesList.DataBind();
            }
        }

        /// <summary>
        /// Gets or sets flag that indicates whether it is an Admin or not
        /// </summary>
        public bool IsAdmin
        {
            get
            {
                return Admin.Checked;
            }
            set
            {
                Admin.Checked = value;
            }
        }

        /// <summary>
        /// Gets or sets Selected Site Roles
        /// </summary>
        public string[] SelectedRoles
        {
            get
            {
                List<string> selectedRoles = new List<string>();
                foreach (ListItem item in SitesList.Items)
                {
                    if (item.Selected)
                    {
                        selectedRoles.Add(item.Value);
                    }
                }

                return selectedRoles.ToArray();
            }
            set
            {
                foreach (ListItem item in SitesList.Items)
                {
                    if (value.Contains(item.Value))
                    {
                        item.Selected = true;
                    }
                    else
                    {
                        item.Selected = false;
                    }
                }
            }
        }
    }
}