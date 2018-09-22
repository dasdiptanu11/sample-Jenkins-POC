using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.UI.Web.Views.Shared;
using App.Business;
using CDMSValidationLogic;
using Telerik.Web.UI;

namespace App.UI.Web.Views.Forms
{
    public partial class PatientLTFUList : BasePage
    {
        // Flag to determine if export action has been taken
        bool _isExport = false;

        // Flag to determine if export action has to been taken to export the data in pdf file
        bool _isPdfExport = false;

        #region Event handler for Patient LTFU Grid
        /// <summary>
        /// Loading grid with the patient data
        /// </summary>
        /// <param name="sender">Patient LTFU List grid as sender</param>
        /// <param name="e">Need Data Source event argument</param>
        protected void PatientLTFUGrid_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            PatientLTFUGrid.ExportSettings.FileName = "LTFUPatientList" + DateTime.Now.ToString();
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                PatientLTFUGrid.DataSource = patientRepository.PatientRepository.GetPatientLTFUList();
            }
        }

        /// <summary>
        /// Formatting and Initilizing grid controls
        /// </summary>
        /// <param name="sender">Patient LTFU grid as sender</param>
        /// <param name="e">Grid Item Event Argument</param>
        protected void PatientLTFUGrid_ItemCreated(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataItem = (GridDataItem)e.Item;
                CheckBox checkbox = (CheckBox)dataItem.FindControl("SelectColumn");
                int index = dataItem.ItemIndex;
                if (checkbox != null)
                { checkbox.Attributes.Add("OnClick", "javascript: checkedColumn('" + index + "')"); }
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
                GridFilteringItem filterItem = (GridFilteringItem)PatientLTFUGrid.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
                foreach (TableCell cell in filterItem.Cells)
                {
                    cell.Text = string.Empty;
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
                string pageName = "Patient LTFU List";
                ((Button)(e.Item as GridCommandItem).FindControl("ExportToExcelButton")).Attributes.Add("onclick", "return ConfirmDownload(" + excelButtonID + ",'" + pageName + "')");
                ((Button)(e.Item as GridCommandItem).FindControl("ExportToPdfButton")).Attributes.Add("onclick", "return ConfirmDownload(" + pdfButtonID + ",'" + pageName + "')");
            }
        }

        /// <summary>
        /// Handling grid command button actions
        /// </summary>
        /// <param name="sender">Patient LTFU List grid as sender</param>
        /// <param name="e">Grid Command event argument</param>
        protected void PatientLTFUGrid_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            GridEditableItem editedItem = e.Item as GridEditableItem;
            RadGrid patientLTFUGrid = (RadGrid)sender;
            try
            {
                switch (e.CommandName)
                {

                    case "EditPatient":
                        SessionData sessionData = new SessionData();
                        sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                        SaveSessionData(sessionData);
                        Response.Redirect(Properties.Resource2.PatientHomePath, false);
                        break;

                    case "RowClick":
                        break;

                    case "ExportToPdf":
                        _isExport = true;
                        _isPdfExport = true;
                        patientLTFUGrid.ExportSettings.OpenInNewWindow = true;
                        patientLTFUGrid.ExportSettings.ExportOnlyData = true;
                        patientLTFUGrid.ExportSettings.IgnorePaging = true;
                        patientLTFUGrid.ExportSettings.Pdf.PageHeight = Unit.Parse("210mm");
                        patientLTFUGrid.ExportSettings.Pdf.PageWidth = Unit.Parse("297mm");
                        patientLTFUGrid.MasterTableView.GetColumn("PatientId").Visible = false;
                        patientLTFUGrid.MasterTableView.GetColumn("PatientId1").Visible = true;
                        patientLTFUGrid.MasterTableView.GetColumn("SelectColumn").Visible = false;

                        patientLTFUGrid.MasterTableView.GetColumn("PatientId1").HeaderStyle.Width = Unit.Pixel(50);
                        patientLTFUGrid.MasterTableView.GetColumn("FamilyName").HeaderStyle.Width = Unit.Pixel(120);
                        patientLTFUGrid.MasterTableView.GetColumn("GivenName").HeaderStyle.Width = Unit.Pixel(150);
                        patientLTFUGrid.MasterTableView.GetColumn("FirstOperationDate").HeaderStyle.Width = Unit.Pixel(100);
                        patientLTFUGrid.MasterTableView.GetColumn("LastOperationDate").HeaderStyle.Width = Unit.Pixel(100);
                        break;

                    case "ExportToExcel":
                        _isExport = true;
                        patientLTFUGrid.ExportSettings.OpenInNewWindow = true;
                        patientLTFUGrid.ExportSettings.ExportOnlyData = true;
                        patientLTFUGrid.ExportSettings.IgnorePaging = true;
                        patientLTFUGrid.MasterTableView.GetColumn("PatientId").Visible = false;
                        patientLTFUGrid.MasterTableView.GetColumn("PatientId1").Visible = true;
                        patientLTFUGrid.MasterTableView.GetColumn("SelectColumn").Visible = false;

                        patientLTFUGrid.MasterTableView.GetColumn("PatientId1").HeaderStyle.Width = Unit.Pixel(50);
                        patientLTFUGrid.MasterTableView.GetColumn("FamilyName").HeaderStyle.Width = Unit.Pixel(120);
                        patientLTFUGrid.MasterTableView.GetColumn("GivenName").HeaderStyle.Width = Unit.Pixel(150);
                        patientLTFUGrid.MasterTableView.GetColumn("FirstOperationDate").HeaderStyle.Width = Unit.Pixel(100);
                        patientLTFUGrid.MasterTableView.GetColumn("LastOperationDate").HeaderStyle.Width = Unit.Pixel(100);
                        break;

                    default:
                        break;
                }
            }
            catch (Exception ex)
            {
                ErrorMessage.Text = (ex.Message);
            }
        }

        /// <summary>
        /// Formatting grid cells for Export to Excel file format
        /// </summary>
        /// <param name="sender">Patient LTFU List grid as sender</param>
        /// <param name="e">Excel Export Cell Formatting event argument</param>
        protected void PatientLTFUGrid_ExcelExportCellFormatting(object sender, Telerik.Web.UI.ExcelExportCellFormattingEventArgs e)
        {
            GridHeaderItem headerItem = (GridHeaderItem)PatientLTFUGrid.MasterTableView.GetItems(GridItemType.Header)[0];
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
        #endregion Event handler for Patient LTFU Grid

        #region ForMarkAsSent_ManagingUserSelection
        /// <summary>
        /// Check and Uncheck the checkbox in th grid row while changing the grid page
        /// </summary>
        /// <param name="sender">Patient LTFU List grid as sender</param>
        /// <param name="e">Grid Page Index Changed event argument</param>
        protected void PatientLTFUGrid_PageIndexChanged(object sender, GridPageChangedEventArgs e)
        {
            ErrorMessage.Text = string.Empty;
            foreach (GridDataItem item in PatientLTFUGrid.Items)
            {
                int patientID = Convert.ToInt32(item.GetDataKeyValue("PatientId"));
                CheckBox checkColumn = item.FindControl("SelectColumn") as CheckBox;
                if (checkColumn.Checked)
                {
                    AddPatientIDFromSelectedList(patientID);
                }
                else
                {
                    RemovePatientIDFromSelectedList(patientID);
                }
            }
        }

        /// <summary>
        /// Check or Uncheck the checkbox in the grid row while loading the grid data
        /// </summary>
        /// <param name="sender">Patient LTFU List grid as sender</param>
        /// <param name="e">Event Argument</param>
        protected void PatientLTFUGrid_PreRender(object sender, EventArgs e)
        {
            SessionData sessionData = GetDefaultSessionData();
            if (sessionData.PatientIdsForLTFU != null)
            {
                List<string> patientIdsForLTFU = (List<string>)sessionData.PatientIdsForLTFU;

                foreach (GridDataItem item in PatientLTFUGrid.MasterTableView.Items)
                {
                    CheckBox checkColumn = item.FindControl("SelectColumn") as CheckBox;
                    string patientId = item.GetDataKeyValue("PatientId").ToString();
                    if (checkColumn != null)
                    {
                        if (patientIdsForLTFU.Contains(patientId))
                        {
                            checkColumn.Checked = true;
                        }
                        else
                        {
                            checkColumn.Checked = false;
                        }
                    }
                }
            }

            SaveSessionData(sessionData);
        }

        // Remove Patient id from Patient LTFU list
        private void RemovePatientIDFromSelectedList(int patientID)
        {
            SessionData sessionData = GetDefaultSessionData();
            if (sessionData.PatientIdsForLTFU != null)
            {
                List<string> patientIdsForLTFU = (List<string>)sessionData.PatientIdsForLTFU;
                if (patientIdsForLTFU.Contains(patientID.ToString()))
                {
                    patientIdsForLTFU.Remove(patientID.ToString());
                }

                sessionData.PatientIdsForLTFU = patientIdsForLTFU;
            }

            SaveSessionData(sessionData);
        }

        // Adding Patient Id in Patient LTFU List
        private void AddPatientIDFromSelectedList(int patientID)
        {
            SessionData sessionData = GetDefaultSessionData();
            List<string> patientIdsForLTFU;
            if (sessionData.PatientIdsForLTFU != null)
            { patientIdsForLTFU = (List<string>)sessionData.PatientIdsForLTFU; }
            else
            { patientIdsForLTFU = new List<string>(); }

            if (!patientIdsForLTFU.Contains(patientID.ToString()))
            {
                patientIdsForLTFU.Add(patientID.ToString());
            }

            sessionData.PatientIdsForLTFU = patientIdsForLTFU;
            SaveSessionData(sessionData);
        }
        #endregion ForMarkAsSent_ManagingUserSelection

        /// <summary>
        /// Removed patient from LTFU list
        /// </summary>
        /// <param name="sender">Check Uncheck LTFU Status button as sender</param>
        /// <param name="e">Event Arguments</param>
        protected void UncheckLTFUStatusButtonClicked(object sender, EventArgs e)
        {
            SessionData sessionData = GetDefaultSessionData();
            List<string> patientIdsForLTFU = (List<string>)sessionData.PatientIdsForLTFU;
            ErrorMessage.Text = "";
            try
            {
                if (patientIdsForLTFU == null)
                {
                    patientIdsForLTFU = new List<string>();
                }

                //Check if something has been unchecked/or checked on this page
                foreach (GridDataItem item in PatientLTFUGrid.Items)
                {
                    int patientID = Convert.ToInt32(item.GetDataKeyValue("PatientId"));
                    CheckBox checkColumn = item.FindControl("SelectColumn") as CheckBox;
                    if (checkColumn.Checked)
                    {
                        if (!patientIdsForLTFU.Contains(patientID.ToString()))
                        {
                            patientIdsForLTFU.Add(patientID.ToString());
                        }
                    }
                    else
                    {
                        if (patientIdsForLTFU.Contains(patientID.ToString()))
                        {
                            patientIdsForLTFU.Remove(patientID.ToString());
                        }
                    }
                }

                sessionData.PatientIdsForLTFU = patientIdsForLTFU;
                SaveSessionData(sessionData);

                if (patientIdsForLTFU != null && patientIdsForLTFU.Count() > 0)
                {
                    //Take PatientID list again  
                    sessionData = GetDefaultSessionData();
                    if (sessionData.PatientIdsForLTFU != null)
                    {
                        patientIdsForLTFU = (List<string>)sessionData.PatientIdsForLTFU;
                        foreach (string PatientID in patientIdsForLTFU)
                        {
                            int patientID = Convert.ToInt32(PatientID);
                            //Get Patient rec 
                            using (UnitOfWork patientRepository = new UnitOfWork())
                            {
                                tbl_Patient patient = patientRepository.tbl_PatientRepository.Get(x => x.PatId == patientID).FirstOrDefault();
                                patient.OptOffStatId = Constants.OPTOFF_CODE_FOR_CONSENTED;
                                patient.LastUpdatedBy = UserName;
                                patient.LastUpdatedDateTime = System.DateTime.Now;
                                patientRepository.tbl_PatientRepository.Update(patient);
                                //Added code to start follow up routine when patient is found
                                patientRepository.PatientRepository.UpdatePatientFollowups(patientID, "Patient LTFU status changed");
                                patientRepository.Save();
                            }

                            //Update tbl_followUp
                            using (UnitOfWork followUpRepository = new UnitOfWork())
                            {
                                IEnumerable<tbl_FollowUp> followUpdateItems = followUpRepository.tbl_FollowUpRepository.Get(x => x.PatientId == patientID && x.LTFU == true);
                                foreach (tbl_FollowUp followUpRec in followUpdateItems)
                                {
                                    followUpRec.LTFU = false;
                                    followUpRec.LTFUDate = null;
                                    followUpRec.LastUpdatedBy = UserName;
                                    followUpRec.LastUpdatedDateTime = System.DateTime.Now;
                                    followUpRepository.tbl_FollowUpRepository.Update(followUpRec);
                                    followUpRepository.Save();
                                }
                            }
                        }

                        sessionData.PatientIdsForLTFU = null;
                        SaveSessionData(sessionData);
                        PatientLTFUGrid.Rebind();
                    }
                    else
                    {
                        ErrorMessage.Text = "Patient(s) for unchecking LTFU status not selected";
                    }
                }
                else
                {
                    ErrorMessage.Text = "Patient(s) for unchecking LTFU status not selected";
                }
            }
            catch (Exception ex)
            {
                ErrorMessage.Text = ex.Message.Trim();
            }
        }
    }
}