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
    public partial class PatientUnknownDeviceList : BasePage
    {
        // Flag to determine if export action has been taken
        bool _isExport = false;

        // Flag to determine if export action has to been taken to export the data in pdf file
        bool _isPdfExport = false;

        /// <summary>
        /// Initializing page controls
        /// </summary>
        /// <param name="sender">Patient Unknown Device List page as sender</param>
        /// <param name="e">Page Load event argument</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            SessionData sessionData;
            AddBrandButton.Attributes.Add("onclick", "genericPopup('popupAddBrand.aspx','500','350','Add Brand')");
            AddManufacturerButton.Attributes.Add("onclick", "genericPopup('popupAddManufacturer.aspx','450','300','Add Manufacturer')");
            if (Session[Constants.SESSION_DATA_KEY] != null)
            {
                sessionData = GetSessionData();
            }
            else
            {
                sessionData = new SessionData();
            }

            string message = sessionData.AddedSuccessMessage == null ? string.Empty : (string)sessionData.AddedSuccessMessage;
            SuccessMessage.Text = message;
            if (!string.IsNullOrEmpty(message))
            { SuccessMessage.Visible = true; }
            else
            { SuccessMessage.Visible = false; }

            sessionData.AddedSuccessMessage = string.Empty;
            SaveSessionData(sessionData);
        }

        /// <summary>
        /// Method to validate whether brand and manufacturer for the device is correct
        /// </summary>
        /// <param name="e">Grid Command event argument</param>
        /// <returns>Flag indicating whether or not Brand and Manufacturer of the device is valid</returns>
        public bool AreBrandAndManufacturerValid(GridCommandEventArgs e)
        {
            string errorMessage = string.Empty;
            bool isBrandAndManufacturerValid = false;
            int brandId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["DeviceBrandId"]);
            int manufacturerId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ManufacturerId"]);

            string manufacturer = "Manufacturer - '" + e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ManufacturerDescrition"].ToString() + "'";
            string brand = "Brand - '" + e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["DeviceBrandDescrition"].ToString() + "'";

            if (brandId != -1 && manufacturerId != -1)
            {
                isBrandAndManufacturerValid = true;
            }
            else
            {
                errorMessage = "Device can not be edited - Add ";
                if (manufacturerId == -1) { errorMessage = errorMessage + manufacturer; }
                if (manufacturerId == -1 && brandId == -1) { errorMessage = errorMessage + " and "; }
                if (brandId == -1) { errorMessage = errorMessage + brand; }
                errorMessage = errorMessage + " to edit this device";
            }

            ErrorMessage.Text = errorMessage;
            return isBrandAndManufacturerValid;
        }

        /// <summary>
        /// Load Unknown Device grid with data
        /// </summary>
        /// <param name="source">Patient Unknown Device List grid as sender</param>
        /// <param name="e">Need Data Source event argument</param>
        protected void PatientUnknownDeviceGrid_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
        {
            PatientUnknownDeviceGrid.ExportSettings.FileName = "UnknownDeviceList" + DateTime.Now.ToString();
            using (UnitOfWork deviceRepository = new UnitOfWork())
            {
                PatientUnknownDeviceGrid.DataSource = deviceRepository.DeviceRepository.GetUnknownDeviceDetails(UserName);
            }
        }

        /// <summary>
        /// Handling grid command
        /// </summary>
        /// <param name="sender">Patient Unknown device list grid as sender</param>
        /// <param name="e">Grid Command event arguments</param>
        protected void PatientUnknownDeviceGrid_ItemCommand(object sender, GridCommandEventArgs e)
        {
            SessionData sessionData = new SessionData();
            RadGrid patientUnknownDeviceListGrid = (RadGrid)sender;
            try
            {
                switch (e.CommandName)
                {
                    case "EditDevice":
                        ErrorMessage.Text = string.Empty;
                        sessionData.PatientOperationUnknownDeviceID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientOperationDeviceID"]);
                        if (AreBrandAndManufacturerValid(e))
                        {
                            ErrorMessage.Text = string.Empty;
                            SaveSessionData(sessionData);
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "MyFunc1", "genericPopup('popupAddUnknownDevice.aspx','500','500','Edit Device')", true);
                        }
                        break;

                    case "EditOperation":
                        sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientOperationId"]);
                        sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                        sessionData.SiteId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientSiteId"]);
                        SaveSessionData(sessionData);
                        Response.Redirect(Properties.Resource2.OperationDetailsPath + "?LoadOperationDetails=1", false);
                        break;

                    case "ExportToPdf":
                        _isExport = true;
                        _isPdfExport = true;
                        patientUnknownDeviceListGrid.ExportSettings.OpenInNewWindow = true;
                        patientUnknownDeviceListGrid.ExportSettings.ExportOnlyData = true;
                        patientUnknownDeviceListGrid.ExportSettings.IgnorePaging = true;
                        patientUnknownDeviceListGrid.MasterTableView.Style["font-size"] = "8pt";
                        patientUnknownDeviceListGrid.MasterTableView.GetColumn("Select").Visible = false;
                        patientUnknownDeviceListGrid.MasterTableView.GetColumn("PatientId").Visible = false;
                        patientUnknownDeviceListGrid.MasterTableView.GetColumn("PatientId1").Visible = true;
                        break;

                    case "ExportToExcel":
                        _isExport = true;
                        patientUnknownDeviceListGrid.ExportSettings.OpenInNewWindow = true;
                        patientUnknownDeviceListGrid.ExportSettings.ExportOnlyData = true;
                        patientUnknownDeviceListGrid.ExportSettings.IgnorePaging = true;
                        patientUnknownDeviceListGrid.MasterTableView.GetColumn("Select").Visible = false;
                        patientUnknownDeviceListGrid.MasterTableView.GetColumn("PatientId").Visible = false;
                        patientUnknownDeviceListGrid.MasterTableView.GetColumn("PatientId1").Visible = true;
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
        /// Formatting grid cells for displaying data
        /// </summary>
        /// <param name="sender">Patient Unknown Device List grid as sender</param>
        /// <param name="e">Grid Item event argument</param>
        protected void PatientUnknownDeviceGrid_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataItem = (GridDataItem)e.Item;
                Control selectBoxControl = dataItem.FindControl("Select");
                CheckBox selectBox = selectBoxControl as CheckBox;
                if (selectBox != null)
                { selectBox.Attributes.Add("OnClick", "javascript: checkedClmn('0')"); }
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
                GridFilteringItem filterItem = (GridFilteringItem)PatientUnknownDeviceGrid.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
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
        /// Formatting grid columns for export to excel file format
        /// </summary>
        /// <param name="sender">Patient Unknown Device List grid as sender</param>
        /// <param name="e">Excel Export Cell Formatting event arguments</param>
        protected void PatientUnknownDeviceGrid_ExcelExportCellFormatting(object sender, ExcelExportCellFormattingEventArgs e)
        {
            GridHeaderItem headerItem = (GridHeaderItem)PatientUnknownDeviceGrid.MasterTableView.GetItems(GridItemType.Header)[0];
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
    }
}