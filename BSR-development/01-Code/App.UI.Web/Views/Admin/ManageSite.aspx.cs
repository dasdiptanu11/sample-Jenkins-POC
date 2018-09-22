using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using App.Business;
using App.UI.Web.Views.Shared;


namespace App.UI.Web.Views.Forms
{
    public partial class ManageSite : BasePage
    {
        #region Grid Events
        /// <summary>
        /// Loading data in the Manage Site Grid
        /// </summary>
        /// <param name="source">Manage Site grid as sender</param>
        /// <param name="e">Grid Need Data Source event argument</param>
        protected void ManageSiteGrid_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
        {
            ManageSiteGrid.ExportSettings.FileName += DateTime.Now.ToString();
            LoadSiteGrid();
        }

        // Loading data in the Sites Grid
        private void LoadSiteGrid()
        {
            using (UnitOfWork siteRepository = new UnitOfWork())
            {
                ManageSiteGrid.DataSource = siteRepository.tbl_SiteRepository.Get(null, null, "tlkp_SiteType,tlkp_State, tlkp_SiteStatus");
            }
        }

        /// <summary>
        /// Edit command for a row in the Manage Site Grid
        /// </summary>
        /// <param name="sender">Manage Site grid as sender</param>
        /// <param name="e">Event Argument</param>
        protected void ManageSiteGrid_ItemCommand(object sender, GridCommandEventArgs e)
        {
            try
            {
                RadGrid manageSiteGrid = (RadGrid)sender;
                SessionData sessionData = GetSessionData();
                GridEditableItem editedItem = e.Item as GridEditableItem;
                switch (e.CommandName)
                {
                    case "EditSite":
                        sessionData.SiteId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["SiteId"]);
                        SaveSessionData(sessionData);
                        Response.Redirect(Properties.Resource.InstituteEditPath, false);
                        break;

                    default:
                        break;
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// Adding filtering in Manage Site Grid
        /// </summary>
        /// <param name="sender">Manage Site grid as sender</param>
        /// <param name="e">Event Argument</param>
        protected void ManageSiteGrid_PreRender(object sender, EventArgs e)
        {
            for (int columnCount = 1; columnCount < ManageSiteGrid.Columns.Count; columnCount++)
            {
                ManageSiteGrid.Columns[columnCount].CurrentFilterFunction = Telerik.Web.UI.GridKnownFunction.Contains;
            }
        }
        #endregion

        #region Button click
        /// <summary>
        /// Redirecting to Create Site Page
        /// </summary>
        /// <param name="sender">Create Site button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void CreateSiteClicked(object sender, EventArgs e)
        {
            SessionData sessionData = GetSessionData();
            sessionData.SiteId = -1;
            SaveSessionData(sessionData);
            Response.Redirect(Properties.Resource.InstituteEditPath, false);
        }
        #endregion
    }
}