using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using Telerik.Web.UI;
using App.UI.Web.Views.Shared;
using App.Business;

namespace App.UI.Web.Views.Admin
{
    public partial class ListUsers : BasePage
    {
        /// <summary>
        /// Setting postback url for Create Account button
        /// </summary>
        /// <param name="sender">User List page as sender</param>
        /// <param name="e">Event Argument</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            CreateAccountButton.PostBackUrl = Constants.URL_CREATE_USER_ACCOUNT;
        }

        #region Grid Events
        /// <summary>
        /// Loading User List Grid with the data
        /// </summary>
        /// <param name="source">User List grid as source</param>
        /// <param name="e">Grid Need Data Source event argument</param>
        protected void UsersListGrid_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
        {
            using (UnitOfWork userRepository = new UnitOfWork())
            {
                UsersListGrid.DataSource = userRepository.MembershipRepository.GetAllUsers();
            }
        }

        /// <summary>
        /// Enable or Disable edit button as per the user role
        /// </summary>
        /// <param name="sender">User List grid as sender</param>
        /// <param name="gridItem">Grid Item event argument</param>
        protected void UsersListGrid_ItemCreated(object sender, GridItemEventArgs gridItem)
        {
            if (gridItem.Item is GridDataItem)
            {
                HyperLink editLink = (HyperLink)gridItem.Item.FindControl("ManageUserLink");
                string userName = gridItem.Item.OwnerTableView.DataKeyValues[gridItem.Item.ItemIndex]["UserName"].ToString();
                string role = gridItem.Item.OwnerTableView.DataKeyValues[gridItem.Item.ItemIndex]["UserPrivilegeRole"].ToString();
                if ((role.ToUpper() == "ADMIN REGISTRY") && IsAdminCentral)
                {
                    editLink.Enabled = false;
                }
                else
                {
                    editLink.Enabled = true;
                    editLink.Attributes["href"] = "CreateAccount.aspx?" + Constants.QUERY_PARAM_USER_ID + "=" + userName;
                }
            }
        }

        /// <summary>
        /// Removing filter options from User List Grid
        /// </summary>
        /// <param name="sender">User List grid as sender</param>
        /// <param name="e">Event Argument</param>
        protected void UsersListGrid_Init(object sender, EventArgs e)
        {
            RestrictRadGridFilterOptions(UsersListGrid);
        }
        #endregion
    }
}
