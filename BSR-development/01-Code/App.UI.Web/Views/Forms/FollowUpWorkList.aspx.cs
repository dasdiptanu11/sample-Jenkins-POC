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
using App.UI.Web.Views.Shared;
using Telerik.Web.UI;
using System.Configuration;


namespace App.UI.Web.Views.Forms
{
    public partial class FollowUpWorkList : BasePage
    {
        // Flag to determine if export action has to been taken to export the data in pdf file
        private bool _isPdfExport = false;

        // Flag to determine if export action has been taken
        bool _isExport = false;

        /// <summary>
        /// Initialize the page controls
        /// </summary>
        /// <param name="sender">Follow Up Work List page as sender</param>
        /// <param name="e">Event Arguments</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            TurnTextBoxAutoCompleteOff();
            SurgeonAndSite.SetCountryForSites(true, 1);
            if (!IsPostBack)
            {
                LoadLookup();
                SurgeonAndSite.AddEmptyItemInSurgeonList = false;
                SurgeonAndSite.AddEmptyItemInSiteList = false;
                OperationDateFrom.MaxDate = DateTime.Today;
                OperationDateTo.MaxDate = DateTime.Today;
            }
        }

        #region LoadLookup
        /// <summary>
        /// Loading Dropdown values/options from the database
        /// </summary>
        protected void LoadLookup()
        {
            FollowupWorkListGrid.ExportSettings.FileName = "FollowUpWorkList" + DateTime.Now.ToString();
            OperationStatus.Items.Clear();
            using (UnitOfWork b1 = new UnitOfWork())
            {
                Helper.BindCollectionToControl(OperationStatus, b1.Get_tlkp_OperationStatus(true), "Id", "Description");
                OperationStatus.DataBind();
            }
        }
        #endregion LoadLookup

        #region RadGrid_LoadingData
        /// <summary>
        /// Loading data in the Followup Work List grid
        /// </summary>
        /// <param name="sender">Followup Work List grid as sender</param>
        /// <param name="e">Grid Need Data Source event argument</param>
        protected void FollowupWorkListGrid_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            FollowupWorkListGrid.ExportSettings.FileName = "FollowUpWorkList" + DateTime.Now.ToString();
            LoadFollowUpGrid();
        }

        // Get followup data from the database and display it in the grid
        private void LoadFollowUpGrid()
        {
            int surgeonId = SurgeonAndSite.GetSelectedIdFromSurgeonList() == 0 ? -1 : SurgeonAndSite.GetSelectedIdFromSurgeonList();
            int siteID = SurgeonAndSite.GetSelectedIdFromSiteList() == 0 ? -1 : SurgeonAndSite.GetSelectedIdFromSiteList();
            int operationStatus = (OperationStatus.SelectedItem == null || OperationStatus.SelectedItem.Value == string.Empty)
                                        ? -1 : Convert.ToInt32(OperationStatus.SelectedItem.Value);

            using (UnitOfWork followupRepository = new UnitOfWork())
            {
                FollowupWorkListGrid.DataSource = followupRepository.FollowUpRepository.GetPatientFollowUpDetails(
                                                                                                        UserName,
                                                                                                        surgeonId,
                                                                                                        siteID,
                                                                                                        OperationDateFrom.SelectedDate,
                                                                                                        OperationDateTo.SelectedDate,
                                                                                                        operationStatus,
                                                                                                        -1);
            }
        }

        /// <summary>
        /// Formatting the data once loaded in the grid for some of the columns
        /// </summary>
        /// <param name="sender">Followup Work List grid as sender</param>
        /// <param name="gridItem">Grid Item Event Arguments</param>
        protected void FollowupWorkListGrid_ItemDataBound(object sender, GridItemEventArgs gridItem)
        {
            if (gridItem.Item is GridDataItem)
            {
                foreach (TableCell cell in gridItem.Item.Cells)
                {
                    if (cell.Text.ToLower().Trim() == "overdue")
                    { cell.ForeColor = System.Drawing.Color.Red; }
                    else
                    { cell.ForeColor = System.Drawing.Color.Black; }
                }
            }
        }
        #endregion RadGrid_LoadingData

        #region RadGrid_CreatingCellsAndCommandButtons
        /// <summary>
        /// Formatting the grid cells
        /// </summary>
        /// <param name="sender">Followup Work List grid as sender</param>
        /// <param name="gridItem">Grid Item event argument</param>
        protected void FollowupWorkListGrid_ItemCreated(object sender, GridItemEventArgs gridItem)
        {
            TurnTextBoxAutoCompleteOff();
            if (gridItem.Item is GridHeaderItem && _isPdfExport)
            {
                foreach (TableCell cell in gridItem.Item.Cells)
                {
                    cell.Style["border"] = "thin solid black";
                    cell.Style["background-color"] = "#cccccc";
                }
            }

            if (gridItem.Item is GridDataItem && _isPdfExport)
            {
                foreach (TableCell cell in gridItem.Item.Cells)
                { cell.Style["border"] = "thin solid black"; }
            }

            if (gridItem.Item is GridFilteringItem && _isPdfExport)
            {
                GridFilteringItem filterItem = (GridFilteringItem)FollowupWorkListGrid.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
                foreach (TableCell cell in filterItem.Cells)
                {
                    cell.Text = string.Empty;
                }
            }

            if (gridItem.Item is GridCommandItem)
            {
                var exportToExcelButton = (gridItem.Item as GridCommandItem).FindControl("ExportToExcelButton") as Button;
                var exportToPdfButton = (gridItem.Item as GridCommandItem).FindControl("ExportToPdfButton") as Button;
                if (exportToPdfButton != null) { ScriptManager.GetCurrent(Page).RegisterPostBackControl(exportToExcelButton); }
                if (exportToExcelButton != null) { ScriptManager.GetCurrent(Page).RegisterPostBackControl(exportToPdfButton); }
                string excelButtonID = ((Button)(gridItem.Item as GridCommandItem).FindControl("ExportToExcelButton")).ClientID.ToString();
                string pdfButtonID = ((Button)(gridItem.Item as GridCommandItem).FindControl("ExportToPdfButton")).ClientID.ToString();
                string pageName = "Follow Up Work List";
                ((Button)(gridItem.Item as GridCommandItem).FindControl("ExportToExcelButton")).Attributes.Add("onclick", "return ConfirmDownload(" + excelButtonID + ",'" + pageName + "')");
                ((Button)(gridItem.Item as GridCommandItem).FindControl("ExportToPdfButton")).Attributes.Add("onclick", "return ConfirmDownload(" + pdfButtonID + ",'" + pageName + "')");

            }

            //This changes color to red if value of cell is "overdue"
            if (gridItem.Item is GridDataItem)
            {
                TextBox txtFollowUpStatus = gridItem.Item.FindControl("FollowUpStatus") as TextBox;
                if (txtFollowUpStatus != null)
                {
                    if (txtFollowUpStatus.Text.ToLower().Trim() == "overdue")
                    { txtFollowUpStatus.ForeColor = System.Drawing.Color.Red; }
                    else
                    { txtFollowUpStatus.ForeColor = System.Drawing.Color.Black; }
                }
            }
        }

        /// <summary>
        /// Processing grid and data for the exporting the data into a file
        /// </summary>
        /// <param name="sender">Followp Work List grid as sender</param>
        /// <param name="e">Grid Command event argument</param>
        protected void FollowupWorkListGrid_ItemCommand(object sender, GridCommandEventArgs e)
        {
            _isPdfExport = false;
            RadGrid followupWorkListGrid = (RadGrid)sender;
            switch (e.CommandName)
            {
                case RadGrid.ExportToExcelCommandName:
                    _isExport = true;
                    followupWorkListGrid.ExportSettings.OpenInNewWindow = true;
                    followupWorkListGrid.ExportSettings.ExportOnlyData = true;
                    followupWorkListGrid.ExportSettings.IgnorePaging = true;
                    FollowupWorkListGrid.MasterTableView.GetColumn("PatientId").Display = true;
                    FollowupWorkListGrid.MasterTableView.GetColumn("lnkPatId").Display = false;
                    followupWorkListGrid.MasterTableView.GetColumn("OperationID").Display = false;
                    followupWorkListGrid.MasterTableView.GetColumn("FollowUpID").Display = false;
                    FollowupWorkListGrid.MasterTableView.GetColumn("PatientId").HeaderStyle.Width = Unit.Pixel(60);
                    FollowupWorkListGrid.MasterTableView.GetColumn("FamilyName").HeaderStyle.Width = Unit.Pixel(80);
                    FollowupWorkListGrid.MasterTableView.GetColumn("GivenName").HeaderStyle.Width = Unit.Pixel(80);
                    FollowupWorkListGrid.MasterTableView.GetColumn("OperationDate").HeaderStyle.Width = Unit.Pixel(75);
                    FollowupWorkListGrid.MasterTableView.GetColumn("OperationDate").HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                    FollowupWorkListGrid.MasterTableView.GetColumn("FollowUpPeriod").HeaderStyle.Width = Unit.Pixel(70);
                    FollowupWorkListGrid.MasterTableView.GetColumn("FollowUpStatus").HeaderStyle.Width = Unit.Pixel(70);
                    FollowupWorkListGrid.MasterTableView.GetColumn("AttemptedCalls").HeaderStyle.Width = Unit.Pixel(60);
                    break;

                case RadGrid.ExportToPdfCommandName:
                    FollowupWorkListGrid.MasterTableView.AllowFilteringByColumn = true;
                    if (!FollowupWorkListGrid.ExportSettings.IgnorePaging)
                    {
                        FollowupWorkListGrid.Rebind();
                    }

                    _isPdfExport = true;
                    FollowupWorkListGrid.MasterTableView.Style["font-size"] = "8pt";
                    FollowupWorkListGrid.MasterTableView.GetColumn("PatientId").Display = true;
                    FollowupWorkListGrid.MasterTableView.GetColumn("lnkPatId").Display = false;
                    followupWorkListGrid.MasterTableView.GetColumn("OperationID").Display = false;
                    followupWorkListGrid.MasterTableView.GetColumn("FollowUpID").Display = false;
                    FollowupWorkListGrid.MasterTableView.GetColumn("PatientId").HeaderStyle.Width = Unit.Pixel(40);
                    FollowupWorkListGrid.MasterTableView.GetColumn("FamilyName").HeaderStyle.Width = Unit.Pixel(80);
                    FollowupWorkListGrid.MasterTableView.GetColumn("GivenName").HeaderStyle.Width = Unit.Pixel(80);
                    FollowupWorkListGrid.MasterTableView.GetColumn("OperationDate").HeaderStyle.Width = Unit.Pixel(70);
                    FollowupWorkListGrid.MasterTableView.GetColumn("FollowUpPeriod").HeaderStyle.Width = Unit.Pixel(40);
                    FollowupWorkListGrid.MasterTableView.GetColumn("FollowUpStatus").HeaderStyle.Width = Unit.Pixel(70);
                    FollowupWorkListGrid.MasterTableView.GetColumn("AttemptedCalls").HeaderStyle.Width = Unit.Pixel(70);
                    break;

                case "EditFollowUpDetails":
                    SessionData sessionData = GetSessionData();
                    sessionData.ResetPatientData();
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationID"]);
                    sessionData.FollowUpPeriodId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FollowUpID"]);
                    SaveSessionData(sessionData);
                    Response.Redirect(Properties.Resource.FollowUpPagePath + "?LoadFUP=1", false);
                    break;

                default:
                    break;
            }

        }
        #endregion RadGrid_CreatingCellsAndCommandButtons

        #region ButtonClicksForShowingFollowUpWorkList
        /// <summary>
        /// Applying the filter as per the user selection for followup grid
        /// </summary>
        /// <param name="sender">Apply Filter button as sender</param>
        /// <param name="e">Event argument</param>
        protected void ApplyFilter(object sender, EventArgs e)
        {
            FollowUpWorkListErrorMessages.Items.Clear();
            if (SurgeonAndSite.GetSelectedItemFromSiteList() != null
                || SurgeonAndSite.GetSelectedItemFromSurgeonList() != null
                || OperationDateFrom.SelectedDate != null
                || OperationDateTo.SelectedDate != null
                || OperationStatus.SelectedItem != null)
            {
                FollowupWorkListGrid.CurrentPageIndex = 0;
                FollowupWorkListGrid.Rebind();
            }
            else
            {
                FollowUpWorkListErrorMessages.Items.Add("Please enter at least one condition to search");
            }
        }

        /// <summary>
        /// Clearing search filter for the followup worklist data in the grid
        /// </summary>
        /// <param name="sender">Clear Filter button as sender</param>
        /// <param name="e">Event argument</param>
        protected void ClearFilter(object sender, EventArgs e)
        {
            FollowupWorkListGrid.CurrentPageIndex = 0;
            SurgeonAndSite.SetDefaultTextForGivenSiteIndex(-1);
            OperationStatus.SelectedIndex = -1;
            OperationDateFrom.SelectedDate = null;
            OperationDateTo.SelectedDate = null;
            FollowupWorkListGrid.Rebind();
        }
        #endregion

        #region RadGrid_ExportingToExcel
        /// <summary>
        /// Formatting Cell for Excel data export options
        /// </summary>
        /// <param name="sender">Followup Work List grid as sender</param>
        /// <param name="e">Event Argument</param>
        protected void FollowupWorkListGrid_ExcelExportCellFormatting(object sender, ExcelExportCellFormattingEventArgs e)
        {
            GridCommandItem commandItem = (GridCommandItem)FollowupWorkListGrid.MasterTableView.GetItems(GridItemType.CommandItem)[0];
            foreach (TableCell cell in commandItem.Cells)
            {
                cell.Text = string.Empty;
            }

            GridHeaderItem headerItem = (GridHeaderItem)FollowupWorkListGrid.MasterTableView.GetItems(GridItemType.Header)[0];
            foreach (TableCell cell in headerItem.Cells)
            {
                cell.Style["border"] = "thin solid black";
                cell.Style["background-color"] = "#cccccc";
            }

            if (FollowupWorkListGrid.MasterTableView.GetItems(GridItemType.FilteringItem).Count() > 0)
            {
                GridFilteringItem filterItem = (GridFilteringItem)FollowupWorkListGrid.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
                foreach (TableCell cell in filterItem.Cells)
                {
                    cell.Text = string.Empty;
                }

                GridDataItem item = e.Cell.Parent as GridDataItem;
                item.Style["border"] = "thin solid black";
                item.Style["text-align"] = "left";
            }

            if (e.FormattedColumn.UniqueName == "DOB")
            {
                e.Cell.Style["mso-number-format"] = @"dd\/mm\/yyyy";
            }

            if (e.FormattedColumn.UniqueName == "OperationDate")
            {
                e.Cell.Style["mso-number-format"] = @"dd\/mm\/yyyy";
            }
        }
        #endregion RadGrid_ExportingToExcel

        /// <summary>
        /// Formatting data for exporting data in PDF file format
        /// </summary>
        /// <param name="sender">Followup Work List grid as sender</param>
        /// <param name="e">Grid PDF Exporting event argument</param>
        protected void FollowupWorkListGrid_PdfExporting(object sender, GridPdfExportingArgs e)
        {
            string headerContent = string.Empty;
            headerContent = @"<div><img alt='' src='~/Images/monash_logo.png' style='width:60px;height:60px;vertical-align:middle;' />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style=' font-size:18px;padding-left:250px; font-weight:bolder;'> Follow Up Work List</span></div>";
            e.RawHTML = headerContent + e.RawHTML;
        }
    }
}