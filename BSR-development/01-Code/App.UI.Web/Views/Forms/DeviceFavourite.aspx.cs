using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using App.Business;
using Telerik.Web.UI;
using System.Configuration;
using App.UI.Web.Views.Shared;

namespace App.UI.Web.Views.Forms
{
    public partial class DeviceFavourite : BasePage
    {
        bool _isPdfExport = false;
        bool _isExport = false;
        /// <summary>
        /// it handles redirection to "Add Favourite" page
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            AddFavourite.Click += new EventHandler(AddFavouriteClick_isAdd);
            SessionData sessionData;
            if (!IsPostBack)
            {
                //check if User is admin or not
                int pageSize = FavouriteDeviceListGrid.PageSize;
                Boolean _isAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN));
                Boolean _isAdminCentral = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
                Boolean _isSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));
                Boolean _isDataCollector = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_DATACOLLECTOR));

                string userName = string.Empty;
                //Get Session Data
                if (Session[Constants.SESSION_DATA_KEY] != null)
                {
                    sessionData = GetSessionData();
                }
                else
                {
                    sessionData = new SessionData();
                }
                sessionData.FavDeviceId = -1;
                string message = sessionData.AddedSuccessMessage == null ? "" : (string)sessionData.AddedSuccessMessage;
                if (message != "")
                {
                    NotifyMessage.Text = message;
                    NotifyMessage.Visible = true;
                }
                else
                {
                    NotifyMessage.Visible = false;
                }
                sessionData.AddedSuccessMessage = "";
                SaveSessionData(sessionData);

                if (_isAdmin || _isAdminCentral)
                {
                    adminNotification.Style.Add(HtmlTextWriterStyle.Display, "block");
                    ShowFavPanel.Visible = true;
                    LoadLookupCountry();
                    LoadLookupSurgeon();
                }
                else if (_isSurgeon || _isDataCollector)
                {
                    //If surgeon/Data collector Logged in
                    adminNotification.Style.Add(HtmlTextWriterStyle.Display, "none");
                    userName = Session["username"].ToString();
                    using (UnitOfWork deviceRepository = new UnitOfWork())
                    {
                        FavouriteDeviceListGrid.DataSource = deviceRepository.DeviceRepository.GetFavouriteDeviceDetails(0, 0, false, userName);
                        FavouriteDeviceListGrid.DataBind();
                    }
                }
            }

        }
        #region Button Click
        /// <summary>
        /// Redirect to AddFavDevice page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void AddFavouriteClick_isAdd(object sender, EventArgs e)
        {
            Response.Redirect("AddFavDevice.aspx?&IsAdd=true");
        }
        /// <summary>
        /// Re-populate grid for selected country and surgeon combination
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void showFavouriteClick(object sender, EventArgs e)
        {
            if (Page.IsValid == true && Surgeon_DropDown.SelectedValue != "" && Country_DropDown.SelectedValue != "")
            {
                int Id = Convert.ToInt32(Surgeon_DropDown.SelectedValue.Trim());
                int countryId = Convert.ToInt32(Country_DropDown.SelectedValue.Trim());
                using (UnitOfWork deviceRepository = new UnitOfWork())
                {
                    FavouriteDeviceListGrid.DataSource = deviceRepository.DeviceRepository.GetFavouriteDeviceDetails(Id, countryId, true, null);
                    FavouriteDeviceListGrid.DataBind();
                }
            }
        }
        #endregion
        #region Functions_For_FavouriteDeviceListGrid
        /// <summary>
        /// Getting data for the Favourite Device List grid
        /// </summary>
        /// <param name="sender">Favourite Device List as sender</param>
        /// <param name="e">Grid Need Data Source event argument</param>
        protected void FavouriteDeviceListGrid_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            FavouriteDeviceListGrid.ExportSettings.FileName = "FavouriteDeviceList" + DateTime.Now.ToString();
            int Id = 0;
            int countryId = 0;
            string userName = Session["username"].ToString();

            if ((Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN)) || (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL)))
            {
                int.TryParse(Surgeon_DropDown.SelectedValue.Trim(), out Id);
                countryId = Convert.ToInt32(Country_DropDown.SelectedValue.Trim());

                using (UnitOfWork deviceRepository = new UnitOfWork())
                {
                    FavouriteDeviceListGrid.DataSource = deviceRepository.DeviceRepository.GetFavouriteDeviceDetails(Id, countryId, true, null);
                }
            }
            else
            {
                using (UnitOfWork deviceRepository = new UnitOfWork())
                {
                    FavouriteDeviceListGrid.DataSource = deviceRepository.DeviceRepository.GetFavouriteDeviceDetails(0, 0, false, userName);
                }
            }
        }
        /// <summary>
        /// it perform action on the displayed data of a grid which has the favourite device list.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void FavouriteDeviceListGrid_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridEditableItem editedItem = e.Item as GridEditableItem;
            RadGrid FavouriteDeviceListGrid = (RadGrid)sender;
            try
            {
                switch (e.CommandName)
                {
                    case "EditDevice":
                        SessionData sessionDataFavDevice = new SessionData();
                        if (e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ParentFavDevId"] != null)
                        {
                            sessionDataFavDevice.FavDeviceId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ParentFavDevId"]);
                        }
                        else
                            sessionDataFavDevice.FavDeviceId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FavDevId"]);
                        SaveSessionData(sessionDataFavDevice);
                        Response.Redirect("~/Views/Forms/AddFavDevice.aspx");
                        break;
                    case "RowClick":
                        break;
                    case "ExportToPdf":
                        _isExport = true;
                        _isPdfExport = true;
                        FavouriteDeviceListGrid.ExportSettings.OpenInNewWindow = true;
                        FavouriteDeviceListGrid.ExportSettings.ExportOnlyData = true;
                        FavouriteDeviceListGrid.ExportSettings.IgnorePaging = true;
                        FavouriteDeviceListGrid.ExportSettings.FileName = "FavouriteDeviceList" + DateTime.Now.ToString();
                        //Set Page Size - Landscape
                        FavouriteDeviceListGrid.ExportSettings.Pdf.PageHeight = Unit.Parse("210mm");
                        FavouriteDeviceListGrid.ExportSettings.Pdf.PageWidth = Unit.Parse("297mm");
                        FavouriteDeviceListGrid.MasterTableView.GetColumn("FavDevId").Visible = false;
                        FavouriteDeviceListGrid.MasterTableView.GetColumn("EditLink").Visible = false;
                        break;
                    case "ExportToExcel":
                        _isExport = true;
                        FavouriteDeviceListGrid.ExportSettings.OpenInNewWindow = true;
                        FavouriteDeviceListGrid.ExportSettings.ExportOnlyData = true;
                        FavouriteDeviceListGrid.ExportSettings.IgnorePaging = true;
                        FavouriteDeviceListGrid.ExportSettings.FileName = "FavouriteDeviceList" + DateTime.Now.ToString();
                        FavouriteDeviceListGrid.MasterTableView.GetColumn("FavDevId").Visible = false;
                        FavouriteDeviceListGrid.MasterTableView.GetColumn("EditLink").Visible = false;
                        break;

                    default:
                        break;

                }
            }
            catch (Exception ex)
            {
                NotifyMessage.ForeColor = System.Drawing.Color.Red;
                NotifyMessage.Text = ex.Message.TrimEnd();
                NotifyMessage.ForeColor = System.Drawing.Color.Black;
            }
        }
        /// <summary>
        /// Formatting rows of a favourite device grid for display
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void FavouriteDeviceListEdit_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridHeaderItem && _isPdfExport)
            {
                foreach (TableCell cell in e.Item.Cells)
                {
                    cell.Style["border"] = "thin solid black";
                    cell.Style["background-color"] = "#cccccc";
                }
            }
            if (e.Item is GridFilteringItem && _isPdfExport)
            {
                GridFilteringItem filterItem = (GridFilteringItem)FavouriteDeviceListGrid.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
                foreach (TableCell cell in filterItem.Cells)
                {
                    cell.Text = "";
                }
            }
            if (e.Item is GridDataItem && _isPdfExport)
            {
                foreach (TableCell cell in e.Item.Cells)
                    cell.Style["border"] = "thin solid black";
            }
            if (e.Item is GridCommandItem)
            {
                var exportToExcelButton = (e.Item as GridCommandItem).FindControl("ExportToExcelButton") as Button;
                var exportToPdfButton = (e.Item as GridCommandItem).FindControl("ExportToPdfButton") as Button;

                if (exportToExcelButton != null)
                {
                    ScriptManager.GetCurrent(Page).RegisterPostBackControl(exportToExcelButton);
                }
                if (exportToPdfButton != null)
                {
                    ScriptManager.GetCurrent(Page).RegisterPostBackControl(exportToPdfButton);
                }

                string ExcelButtonID = ((Button)(e.Item as GridCommandItem).FindControl("ExportToExcelButton")).ClientID.ToString();
                string PdfButtonID = ((Button)(e.Item as GridCommandItem).FindControl("ExportToPdfButton")).ClientID.ToString();

                FavouriteDeviceListGrid.ExportSettings.FileName = "FavouriteDeviceList" + DateTime.Now.ToString();
            }
        }
        /// <summary>
        /// Cells formatting of exported excel 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void FavouriteDeviceListGrid_ExcelExportCellFormatting(object sender, ExcelExportCellFormattingEventArgs e)
        {
            GridHeaderItem headerItem = (GridHeaderItem)FavouriteDeviceListGrid.MasterTableView.GetItems(GridItemType.Header)[0];
            foreach (TableCell cell in headerItem.Cells)
            {
                cell.Style["border"] = "thin solid black";
                cell.Style["background-color"] = "#cccccc";
            }


            GridDataItem item = e.Cell.Parent as GridDataItem;
            foreach (TableCell cell in item.Cells)
            {
                cell.Style["border"] = "thin solid black";
                cell.Style["text-align"] = "left";
            }
            FavouriteDeviceListGrid.ExportSettings.FileName = "FavouriteDeviceList" + DateTime.Now.ToString();
        }
        #endregion

        #region selected Index change methods
        /// <summary>
        /// Loads Surgeon options from selected country
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void Country_SelectedIndexChanged(object sender, EventArgs e)
        {
            int siteCountryId = Convert.ToInt32(Country_DropDown.SelectedValue);
            using (UnitOfWork country = new UnitOfWork())
            {
                Surgeon_DropDown.Items.Clear();
                Helper.BindCollectionToControl(Surgeon_DropDown, country.Get_SurgeonForSites(siteCountryId), "Id", "Description");
                LoadLookupSurgeon();
                int SurgID = 0;
                int.TryParse(Surgeon_DropDown.SelectedValue.Trim(), out SurgID);
                FavouriteDeviceListGrid.DataSource = country.DeviceRepository.GetFavouriteDeviceDetails(SurgID, siteCountryId, true, null);
                FavouriteDeviceListGrid.DataBind();
            }
        }
        #endregion
        #region Load Lookups
        /// <summary>
        /// Loads Country Dropdown options
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        protected bool LoadLookupCountry()
        {
            using (UnitOfWork unit = new UnitOfWork())
            {
                Helper.BindCollectionToControl(Country_DropDown, unit.Get_tlkp_Country(false), "Id", "Description");
                if (!IsPostBack)
                {
                    Country_DropDown.SelectedIndex = 0;
                }
                return true;
            }

        }
        /// <summary>
        /// Loads Surgeons order by created date desc
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        protected bool LoadLookupSurgeon()
        {
            int siteCountryId = Convert.ToInt32(Country_DropDown.SelectedValue);
            using (UnitOfWork country = new UnitOfWork())
            {
                Helper.BindCollectionToControl(Surgeon_DropDown, country.Get_SurgeonForSites(siteCountryId), "Id", "Description");
            }
            if (Surgeon_DropDown.Items.Count > 0)
            {
                Surgeon_DropDown.SelectedIndex = 0;
            }
            return true;
        }
        #endregion

    }
}