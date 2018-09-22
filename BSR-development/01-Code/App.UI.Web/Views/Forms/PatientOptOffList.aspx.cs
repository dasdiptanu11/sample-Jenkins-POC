using App.Business;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using App.UI.Web.Views.Shared;

namespace App.UI.Web.Views.Forms
{
    public partial class PatientOptOffList : BasePage
    {
        // Flag to determine if export action has been taken
        bool _isExport = false;

        // Flag to determine if export action has to been taken to export the data in pdf file
        bool _isPdfExport = false;

        // Total Patient Count
        int _patientsCount = 0;

        // Count of Patient with LTFU
        int _patientWithLtfuCount = 0;

        // Count of patients with Full Opt Of
        int _patientWithFullOptOffCount = 0;

        // Count of patients with Partial Opt Off
        int _patientWithPartialOptOffCount = 0;

        #region GridEvents
        /// <summary>
        /// Load grid with Patient data
        /// </summary>
        /// <param name="source">Patient Opt Off List grid as sender</param>
        /// <param name="e">Need Data Source event argument</param>
        protected void PatientOptOffGrid_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
        {
            PatientOptOffGrid.ExportSettings.FileName += DateTime.Now.ToString();
            LoadSiteGrid();
        }

        // Load data for the patient in the grid and gets count patient with different status
        private void LoadSiteGrid()
        {
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                PatientOptOffGrid.DataSource = patientRepository.PatientRepository.GetPatientOptOffList(
                                                                                                            ref _patientsCount,
                                                                                                            ref _patientWithLtfuCount,
                                                                                                            ref _patientWithFullOptOffCount,
                                                                                                            ref _patientWithPartialOptOffCount);
                PatientFullOptOffDisplay.Text = _patientWithFullOptOffCount.ToString();
                PatientLTFUDisplay.Text = _patientWithLtfuCount.ToString();
                PatientsCountDisplay.Text = _patientsCount.ToString();
                PatientPartialOptOffDisplay.Text = _patientWithPartialOptOffCount.ToString();
            }
        }

        /// <summary>
        /// Get the Opt Off message for the Opt Off Status
        /// </summary>
        /// <param name="optOffStatusId">Opt Off Status Id</param>
        /// <returns>returns Opt Off message as per the status id passed</returns>
        public string optOffmessage(int optOffStatusId)
        {
            string result = string.Empty;
            switch (optOffStatusId)
            {
                case 0:
                    result = "No";
                    break;
                case 1:
                    result = "Full";
                    break;
                case 2:
                    result = "Partial";
                    break;
                case 4:
                    result = "LTFU";
                    break;
            }

            return result;
        }

        /// <summary>
        /// Handling grid commands
        /// </summary>
        /// <param name="sender">Opt Off Patient List grid</param>
        /// <param name="e">Item Command event arguments</param>
        protected void PatientOptOffGrid_ItemCommand(object sender, GridCommandEventArgs e)
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
                        if (e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationOffDate"] != null)
                        {
                            sessionData.OptOffDate = (DateTime)(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationOffDate"]);
                        }
                        SaveSessionData(sessionData);
                        ScriptManager.RegisterStartupScript(
                                                            this,
                                                            this.GetType(),
                                                            "MyFunc1",
                                                            "genericPopup('popupOptOffPatient.aspx','500','300','Edit Patient Opt Off Status','add_close(RefreshPage)');",
                                                            true);
                        break;

                    case "RowClick":
                        break;

                    case "ExportToPdf":
                        _isExport = true;
                        _isPdfExport = true;
                        patientListGrid.ExportSettings.OpenInNewWindow = true;
                        patientListGrid.ExportSettings.ExportOnlyData = true;
                        patientListGrid.ExportSettings.IgnorePaging = true;
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
        /// Formatting grid cells
        /// </summary>
        /// <param name="sender">Opt Off Patient List grid as sender</param>
        /// <param name="e">Item Created event arguments</param>
        protected void PatientOptOffGrid_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                LinkButton editLink = (LinkButton)e.Item.FindControl("EditPatientLink");
                int patientOptOffStatus = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationOffStatus"]);
                if (patientOptOffStatus == 1)
                {
                    editLink.Enabled = false;
                }
            }

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
                GridFilteringItem filterItem = (GridFilteringItem)PatientOptOffGrid.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
                foreach (TableCell cell in filterItem.Cells)
                {
                    cell.Text = "";
                }
            }

            if (e.Item is GridDataItem && _isPdfExport)
            {
                foreach (TableCell cell in e.Item.Cells)
                {
                    cell.Style["border"] = "thin solid black";
                }
            }

            if (e.Item is GridCommandItem)
            {
                var exportToExcelButton = (e.Item as GridCommandItem).FindControl("ExportToExcelButton") as Button;
                var exportToPdfButton = (e.Item as GridCommandItem).FindControl("ExportToPdfButton") as Button;
                if (exportToPdfButton != null) { ScriptManager.GetCurrent(Page).RegisterPostBackControl(exportToExcelButton); }
                if (exportToExcelButton != null) { ScriptManager.GetCurrent(Page).RegisterPostBackControl(exportToPdfButton); }
                string excelButtonID = ((Button)(e.Item as GridCommandItem).FindControl("ExportToExcelButton")).ClientID.ToString();
                string pdfButtonID = ((Button)(e.Item as GridCommandItem).FindControl("ExportToPdfButton")).ClientID.ToString();
                string pageName = "Patient List";
                ((Button)(e.Item as GridCommandItem).FindControl("ExportToExcelButton")).Attributes.Add("onclick", "return ConfirmDownload(" + excelButtonID + ",'" + pageName + "')");
                ((Button)(e.Item as GridCommandItem).FindControl("ExportToPdfButton")).Attributes.Add("onclick", "return ConfirmDownload(" + pdfButtonID + ",'" + pageName + "')");
            }
        }

        /// <summary>
        /// Formatting cells for Export to Excel file format
        /// </summary>
        /// <param name="sender">Opt Off Patient List grid as sender</param>
        /// <param name="e">Excel Export Cell Formatting Event Argument</param>
        protected void PatientOptOffGrid_ExcelExportCellFormatting(object sender, ExcelExportCellFormattingEventArgs e)
        {
            GridHeaderItem headerItem = (GridHeaderItem)PatientOptOffGrid.MasterTableView.GetItems(GridItemType.Header)[0];
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
        }
        #endregion GridEvents
    }
}