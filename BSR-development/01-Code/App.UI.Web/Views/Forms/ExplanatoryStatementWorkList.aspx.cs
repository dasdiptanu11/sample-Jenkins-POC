using App.Business;
using App.UI.Web.Views.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace App.UI.Web.Views.Forms
{
    public partial class ExplanatoryStatementWorkList : BasePage
    {
        // Flag to determine if export action has to been taken to export the data in pdf file
        bool _isPdfExport = false;

        // Flag to determine if export action has been taken
        bool _isExport = false;

        /// <summary>
        /// Initialize controls of the page
        /// </summary>
        /// <param name="sender">Explanatory Statement Work List page as sender</param>
        /// <param name="e">Event arguments</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            SurgeonAndSite.SetCountryForSites(true, 1);
            if (!IsPostBack)
            {
                SessionData sessionData = GetDefaultSessionData();
                sessionData.PatientIdsForESS = null;
                SurgeonAndSite.AddEmptyItemInSurgeonList = false;
                SurgeonAndSite.AddEmptyItemInSiteList = false;
                SurgeonAndSite.ChangeSiteLabelText("Consent Site");
                SurgeonAndSite.ChangeSurgeonLabelText("Surgeon");
                LoadLookup();
            }
        }

        // Loading Dropdown values/options from the database
        private void LoadLookup()
        {
            using (UnitOfWork lookupRepository = new UnitOfWork())
            {
                Helper.BindCollectionToControl(County, lookupRepository.Get_tlkp_Country(false), "Id", "Description");
                County.SelectedValue = Constants.COUNTRY_CODE_FOR_AUSTRALIA.ToString();
                County.DataBind();
            }
        }

        #region Grid Operations
        /// <summary>
        /// Assigning data source for the Patient ESSWL List grid
        /// </summary>
        /// <param name="sender">ESSWL Patient List grid as sender</param>
        /// <param name="e">Grid Need Data Source event argument</param>
        protected void PatientESSWLListGrid_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            int surgeonId = SurgeonAndSite.GetSelectedIdFromSurgeonList() == 0 ? -1 : SurgeonAndSite.GetSelectedIdFromSurgeonList();
            int siteID = SurgeonAndSite.GetSelectedIdFromSiteList() == 0 ? -1 : SurgeonAndSite.GetSelectedIdFromSiteList();
            int countryID = Convert.ToInt16(County.SelectedItem.Value);

            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                PatientESSWLListGrid.DataSource = patientRepository.PatientRepository.GetPatientESSWorkList(countryID, surgeonId, siteID);
            }
        }

        /// <summary>
        /// Configuring grid for the export options
        /// </summary>
        /// <param name="sender">ESSWL Patient List grid as sender</param>
        /// <param name="e">Grid Command event argument</param>
        protected void PatientESSWLListGrid_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid patientListGrid = (RadGrid)sender;
            try
            {
                switch (e.CommandName)
                {
                    case "ExportToPdf":
                        _isExport = true;
                        _isPdfExport = true;
                        patientListGrid.ExportSettings.OpenInNewWindow = true;
                        patientListGrid.ExportSettings.ExportOnlyData = true;
                        patientListGrid.ExportSettings.IgnorePaging = true;
                        //Set Page Size - Landscape
                        patientListGrid.ExportSettings.Pdf.PageHeight = Unit.Parse("210mm");
                        patientListGrid.ExportSettings.Pdf.PageWidth = Unit.Parse("297mm");
                        patientListGrid.MasterTableView.GetColumn("Select").Visible = false;
                        break;

                    case "ExportToExcel":
                        _isExport = true;
                        patientListGrid.ExportSettings.OpenInNewWindow = true;
                        patientListGrid.ExportSettings.ExportOnlyData = true;
                        patientListGrid.ExportSettings.IgnorePaging = true;
                        patientListGrid.MasterTableView.GetColumn("Select").Visible = false;
                        break;

                    default:
                        break;
                }
            }
            catch (Exception ex)
            {
                MessageLabel.ForeColor = System.Drawing.Color.Red;
                MessageLabel.Text = ex.Message.TrimEnd();
                MessageLabel.ForeColor = System.Drawing.Color.Black;
            }
        }

        /// <summary>
        /// Formatting the grid cell for the export to excel option
        /// </summary>
        /// <param name="sender">ESSWL Patient List grid as sender</param>
        /// <param name="e">Excel Export Cell Formatting event argument</param>
        protected void PatientESSWLListGrid_ExcelExportCellFormatting(object sender, ExcelExportCellFormattingEventArgs e)
        {
            GridHeaderItem headerItem = (GridHeaderItem)PatientESSWLListGrid.MasterTableView.GetItems(GridItemType.Header)[0];
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

        /// <summary>
        /// Formatting the cells in the Patient ESSWL data grid
        /// </summary>
        /// <param name="sender">ESSWL Patient List grid as sender</param>
        /// <param name="e">Grid Item event argument</param>
        protected void PatientESSWLListGrid_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridHeaderItem && _isPdfExport)
            {
                foreach (TableCell cell in e.Item.Cells)
                {
                    cell.Style["border"] = "thin solid black";
                    cell.Style["background-color"] = "#cccccc";
                }
            }

            if (e.Item is GridDataItem && _isPdfExport)
            {
                foreach (TableCell cell in e.Item.Cells)
                {
                    cell.Style["border"] = "thin solid black";
                }
            }

            if (e.Item is GridFilteringItem && _isPdfExport)
            {
                GridFilteringItem filterItem = (GridFilteringItem)PatientESSWLListGrid.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
                foreach (TableCell cell in filterItem.Cells)
                {
                    cell.Text = string.Empty;
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
                string pageName = "Explanatory Statement Work List";
                ((Button)(e.Item as GridCommandItem).FindControl("ExportToExcelButton")).Attributes.Add("onclick", "return ConfirmDownload(" + excelButtonID + ",'" + pageName + "')");
                ((Button)(e.Item as GridCommandItem).FindControl("ExportToPdfButton")).Attributes.Add("onclick", "return ConfirmDownload(" + pdfButtonID + ",'" + pageName + "')");
            }
        }

        /// <summary>
        /// Setting up the header to be displayed in the PDF file to be exported
        /// </summary>
        /// <param name="sender">ESSWL Patient List grid as sender</param>
        /// <param name="e">Grid PDF exporting event argument</param>
        protected void PatientESSWLListGrid_PdfExporting(object sender, GridPdfExportingArgs e)
        {
            string headerContent = string.Empty;
            headerContent = @"<div><img alt='' src='~/Images/monash_logo.png' style='width:60px;height:60px;vertical-align:middle;' />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style=' font-size:18px;padding-left:250px; font-weight:bolder;'> Explanatory Statement Work List</span></div>";
            e.RawHTML = headerContent + e.RawHTML;
        }
        #endregion Grid Operations

        #region Mark as Sent
        /// <summary>
        /// Marking the Explanatory Statement as sent for the patient
        /// </summary>
        /// <param name="sender">Mark as Sent button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void MarkAsSentClicked(object sender, EventArgs e)
        {
            AddRemovePatientID();
            tbl_Patient patient;
            SessionData sessionData = GetDefaultSessionData();
            List<string> patientIdsForESS = (List<string>)sessionData.PatientIdsForESS;
            int patientId = 0;
            if (patientIdsForESS != null)
            {
                for (int i = 0; i < patientIdsForESS.Count; i++)
                {
                    int.TryParse(patientIdsForESS[i].ToString(), out patientId);
                    if (patientId != 0)
                    {
                        using (UnitOfWork patientRepository = new UnitOfWork())
                        {
                            patient = patientRepository.tbl_PatientRepository.Get(x => x.PatId == patientId).FirstOrDefault();
                            patient.DateESSent = System.DateTime.Now;
                            patientRepository.tbl_PatientRepository.Update(patient);
                            patientRepository.Save();
                        }
                    }
                }
            }

            sessionData.PatientIdsForESS = null;
            PatientESSWLListGrid.Rebind();
        }
        #endregion Mark as Sent

        #region ForMarkAsSent_ManagingUserSelection
        /// <summary>
        /// Resetting selected Patient ids as page in the grid has changed
        /// </summary>
        /// <param name="sender">ESSWL Patient List grid as sender</param>
        /// <param name="e">Grid Page changed event argument</param>
        protected void PatientESSWLListGrid_PageIndexChanged(object sender, GridPageChangedEventArgs e)
        {
            AddRemovePatientID();
        }

        // Adding or removing patient ids in the list of patient
        private void AddRemovePatientID()
        {
            foreach (GridDataItem item in PatientESSWLListGrid.Items)
            {
                int PatientID = Convert.ToInt32(item.GetDataKeyValue("PatientId"));
                CheckBox checkColumn = item.FindControl("SelectColumn") as CheckBox;
                if (checkColumn.Checked)
                {
                    AddPatientIDFromSelectedList(PatientID);
                }
                else
                {
                    RemovePatientIDFromSelectedList(PatientID);
                }
            }
        }

        /// <summary>
        /// Prerender event handler for ESSWL Patient List grid
        /// </summary>
        /// <param name="sender">ESSWL Patient List grid as sender</param>
        /// <param name="e">Event Argument</param>
        protected void PatientESSWLListGrid_PreRender(object sender, EventArgs e)
        {
            SessionData sessionData = GetDefaultSessionData();
            bool allTicked = false;
            if (sessionData.PatientIdsForESS != null)
            {
                List<string> patientIdsForESS = (List<string>)sessionData.PatientIdsForESS;
                allTicked = true;
                foreach (GridDataItem item in PatientESSWLListGrid.MasterTableView.Items)
                {
                    CheckBox checkBoxColumn = item.FindControl("SelectColumn") as CheckBox;
                    string patientId = item.GetDataKeyValue("PatientId").ToString();
                    if (checkBoxColumn != null)
                    {
                        if (patientIdsForESS.Contains(patientId))
                        {
                            checkBoxColumn.Checked = true;
                        }
                        else
                        {
                            checkBoxColumn.Checked = false;
                            allTicked = false;
                        }
                    }
                }

                if (allTicked)
                {
                    GridHeaderItem HeaderRow = PatientESSWLListGrid.MasterTableView.GetItems(GridItemType.Header) == null
                                                    ? null : (GridHeaderItem)(PatientESSWLListGrid.MasterTableView.GetItems(GridItemType.Header)[0]);
                    CheckBox checkColumn = HeaderRow.FindControl("SelectAll") as CheckBox;
                    if (checkColumn != null)
                    { checkColumn.Checked = allTicked; }
                }
            }

            SaveSessionData(sessionData);
        }

        // Removing Patient Id from the mail patient id list
        private void RemovePatientIDFromSelectedList(int patientID)
        {
            SessionData sessionData = GetDefaultSessionData();
            if (sessionData.PatientIdsForESS != null)
            {
                List<string> patientIdsForESS = (List<string>)sessionData.PatientIdsForESS;
                if (patientIdsForESS.Contains(patientID.ToString()))
                {
                    patientIdsForESS.Remove(patientID.ToString());
                }

                sessionData.PatientIdsForESS = patientIdsForESS;
            }

            SaveSessionData(sessionData);
        }

        // Add Patient Id into main patient id list
        private void AddPatientIDFromSelectedList(int patientID)
        {
            SessionData sessionData = GetDefaultSessionData();
            List<string> patientIdsForESS;
            if (sessionData.PatientIdsForESS != null)
            { patientIdsForESS = (List<string>)sessionData.PatientIdsForESS; }
            else
            { patientIdsForESS = new List<string>(); }

            if (!patientIdsForESS.Contains(patientID.ToString()))
            {
                patientIdsForESS.Add(patientID.ToString());
            }

            sessionData.PatientIdsForESS = patientIdsForESS;
            SaveSessionData(sessionData);
        }
        #endregion ForMarkAsSent_ManagingUserSelection

        #region Selecting_All
        /// <summary>
        /// Selecting or Deselecting all the checkbox in the Patient list grid
        /// </summary>
        /// <param name="sender">Select All checkbox as sender</param>
        /// <param name="e">Event Argument</param>
        protected void SelectAll_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox headerItem = (CheckBox)sender;
            if (headerItem != null)
            {
                ChangeSelectedStatusForSelectColumn(headerItem.Checked);
            }
        }

        /// <summary>
        /// Selecting or Unselecting checkboxes in each row of the ESSWL Patient List grid
        /// </summary>
        /// <param name="isChecked">A flag to determine whether to select or deselect all checkboxes in the Grid</param>
        protected void ChangeSelectedStatusForSelectColumn(Boolean isChecked)
        {
            try
            {
                foreach (GridDataItem item in PatientESSWLListGrid.MasterTableView.Items)
                {
                    int patientID = Convert.ToInt32(item.GetDataKeyValue("PatientId"));
                    CheckBox checkBoxColumn = item.FindControl("SelectColumn") as CheckBox;
                    checkBoxColumn.Checked = isChecked;
                    if (isChecked)
                    { AddPatientIDFromSelectedList(patientID); }
                    else
                    { RemovePatientIDFromSelectedList(patientID); }
                }
            }
            catch (Exception ex)
            {
            }
        }
        #endregion Selecting_All

        /// <summary>
        /// Clearing filter applied for Patient grid data
        /// </summary>
        /// <param name="sender">Clear Filter button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void ClearFilter(object sender, EventArgs e)
        {
            ListItem selectedCountry = County.Items.FindByValue(Constants.COUNTRY_CODE_FOR_AUSTRALIA.ToString());
            SurgeonAndSite.SetDefaultTextForGivenSiteIndex(-1);
            County.SelectedValue = Constants.COUNTRY_CODE_FOR_AUSTRALIA.ToString();
            County.Items.FindByValue(Constants.COUNTRY_CODE_FOR_AUSTRALIA.ToString()).Selected = true;
            County.DataBind();
            PatientESSWLListGrid.Rebind();
        }

        /// <summary>
        /// Applying filter for the Patient list data
        /// </summary>
        /// <param name="sender">Search button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void ApplyFilter(object sender, EventArgs e)
        {
            if (SurgeonAndSite.GetSelectedItemFromSiteList() != null || SurgeonAndSite.GetSelectedItemFromSurgeonList() != null)
            {
                PatientESSWLListGrid.Rebind();
            }
        }
    }
}