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
    public partial class PatientList : BasePage
    {
        // Flag to determine if export action has been taken
        bool _isExport = false;

        // Flag to determine if export action has to been taken to export the data in pdf file
        bool _isPdfExport = false;

        /// <summary>
        /// Hiding Create Patient button
        /// </summary>
        /// <param name="sender">Patient List page as sender</param>
        /// <param name="e">Page Load event arguments</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsSurgeon)
            {
                CreatePatientButton.Visible = false;
            }
        }

        #region Grid Patient List
        /// <summary>
        /// Load Patient List grid with the patint's data
        /// </summary>
        /// <param name="source">Patient Grid control as Source</param>
        /// <param name="e">Need Data Source event arguments</param>
        protected void PatientListGrid_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
        {
            PatientListGrid.ExportSettings.FileName += DateTime.Now.ToString();
            LoadGrid();
        }

        // Load Patients data into Grid.
        private void LoadGrid()
        {
            SessionData sessionData;
            if (IsSurgeon)
            {
                sessionData = GetSessionData();
            }
            else
            {
                sessionData = GetDefaultSessionData();
            }
        }

        /// <summary>
        /// Handling Patient List grid commands
        /// </summary>
        /// <param name="sender">Patient Grid as a Sender</param>
        /// <param name="e">Grid Command event argument</param>
        protected void PatientListGrid_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridEditableItem editedItem = e.Item as GridEditableItem;
            RadGrid patientListGrid = (RadGrid)sender;
            try
            {
                SessionData sessionData = GetSessionData();
                switch (e.CommandName)
                {
                    case "EditPatient":
                        sessionData.ResetPatientData();
                        sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                        SaveSessionData(sessionData);
                        Response.Redirect(Properties.Resource2.PatientHomePath, false);
                        break;

                    case "RowClick":
                        break;

                    case "ExportToPdf":
                        _isExport = true;
                        _isPdfExport = true;
                        patientListGrid.ExportSettings.OpenInNewWindow = true;
                        patientListGrid.ExportSettings.ExportOnlyData = true;
                        patientListGrid.ExportSettings.IgnorePaging = true;
                        //Hide/show collumns when exporting
                        patientListGrid.MasterTableView.GetColumn("EditPatient").Visible = false;
                        patientListGrid.MasterTableView.GetColumn("PatientId").Visible = true;
                        //Set Page Size - Landscape
                        patientListGrid.ExportSettings.Pdf.PageHeight = Unit.Parse("210mm");
                        patientListGrid.ExportSettings.Pdf.PageWidth = Unit.Parse("297mm");
                        break;

                    case "ExportToExcel":
                        _isExport = true;
                        patientListGrid.ExportSettings.OpenInNewWindow = true;
                        patientListGrid.ExportSettings.ExportOnlyData = true;
                        patientListGrid.ExportSettings.IgnorePaging = true;
                        //Hide/show collumns when exporting
                        patientListGrid.MasterTableView.GetColumn("EditPatient").Visible = false;
                        patientListGrid.MasterTableView.GetColumn("PatientId").Visible = true;
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
        /// Redirecting to Add Patient screen
        /// </summary>
        /// <param name="sender">Create Patient button as a sender</param>
        /// <param name="e">Click event argument</param>
        protected void CreatePatientClicked(object sender, EventArgs e)
        {
            SessionData sessionData = GetDefaultSessionData();
            sessionData.PatientId = 0;
            sessionData.PanelNewPatient = false;
            SaveSessionData(sessionData);
            Response.Redirect(Properties.Resource.PatientPagePath, false);
        }

        /// <summary>
        /// Restricint Patient List grid filter options
        /// </summary>
        /// <param name="sender">Patient List grid as a sender</param>
        /// <param name="e">Initialize Event argument</param>
        protected void rgPatientList_Init(object sender, EventArgs e)
        {
            RestrictRadGridFilterOptions(PatientListGrid);
        }

        /// <summary>
        /// Formatting grid to show the short date in datetime column
        /// </summary>
        /// <param name="sender">Patient List as a sender</param>
        /// <param name="e">Grid Item event argument</param>
        protected void PatientListGrid_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataItem = e.Item as GridDataItem;
                if (_isExport)
                {
                    if (dataItem["DOB"].Text != "&nbsp;")
                    {
                        DateTime vDOB = Convert.ToDateTime(dataItem["DOB"].Text.ToString());
                        dataItem["DOB"].Text = vDOB.ToShortDateString();
                    }
                }
            }
        }

        /// <summary>
        /// Formatting the grid cells for export options
        /// </summary>
        /// <param name="sender">Patient List grid as a sender</param>
        /// <param name="e">Grid Item event handler</param>
        protected void PatientListGrid_ItemCreated(object sender, GridItemEventArgs e)
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
                GridFilteringItem filterItem = (GridFilteringItem)PatientListGrid.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
                foreach (TableCell cell in filterItem.Cells)
                {
                    cell.Text = string.Empty;
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
                if (exportToPdfButton != null) { ScriptManager.GetCurrent(Page).RegisterPostBackControl(exportToExcelButton); }
                if (exportToExcelButton != null) { ScriptManager.GetCurrent(Page).RegisterPostBackControl(exportToPdfButton); }
            }
        }

        /// <summary>
        /// Formatting cells for export to excel file format
        /// </summary>
        /// <param name="sender">Patient List grid as a sender</param>
        /// <param name="e">Excel export cell formatting event arguments</param>
        protected void PatientListGrid_ExcelExportCellFormatting(object sender, ExcelExportCellFormattingEventArgs e)
        {
            GridHeaderItem headerItem = (GridHeaderItem)PatientListGrid.MasterTableView.GetItems(GridItemType.Header)[0];
            foreach (TableCell cell in headerItem.Cells)
            {
                cell.Style["border"] = "thin solid black";
                cell.Style["background-color"] = "#cccccc";
            }

            GridFilteringItem filterItem = (GridFilteringItem)PatientListGrid.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
            foreach (TableCell cell in filterItem.Cells)
            {
                cell.Style["border"] = "thin solid black";
                cell.Text = "";
            }

            GridDataItem item = e.Cell.Parent as GridDataItem;
            foreach (TableCell cell in item.Cells)
            {
                cell.Style["border"] = "thin solid black";
                cell.Style["text-align"] = "left";
            }
        }
        #endregion

        /// <summary>
        /// Redirecting page to previous page
        /// </summary>
        /// <param name="sender">Back Button as sender</param>
        /// <param name="e">Click event argument</param>
        protected void BackButtonClicked(object sender, EventArgs e)
        {
            Response.Redirect(Properties.Resource2.PatientSearchPath);
        }
    }
}