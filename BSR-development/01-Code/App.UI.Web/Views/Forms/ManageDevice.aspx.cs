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
    public partial class ManageDevice : BasePage
    {
        bool isPdfExport = false;
        bool isExport = false;

        /// <summary>
        /// it handles pop ups for Devices,Brand,Manufacturer
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            // width, height
            AddBrand.Attributes.Add("onclick", "genericPopup('popupAddBrand.aspx','500','350','Add Brand')");
            AddManufacturer.Attributes.Add("onclick", "genericPopup('popupAddManufacturer.aspx','450','300','Add Manufacturer')");
            AddDevice.Attributes.Add("onclick", "genericPopup('popupAddDevice.aspx?&IsAdd=true','500','500','Add Device')");


            SessionData sessionData;

            if (!IsPostBack)
            {
                if (Session[Constants.SESSION_DATA_KEY] != null)
                {
                    sessionData = GetSessionData();
                }
                else
                {
                    sessionData = new SessionData();
                }

                string message = sessionData.AddedSuccessMessage == null ? "" : (string)sessionData.AddedSuccessMessage;
                sessionData.DeviceId = -1;
                sessionData.AddNewDevice = 1;
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
            }
        }




        #region Functions_For_DeviceGrid

        /// <summary>
        /// Set data source to Device Grid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void DeviceGrid_DataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            DeviceGrid.ExportSettings.FileName = "DeviceList" + DateTime.Now.ToString();
            using (UnitOfWork devicesDetails = new UnitOfWork())
            {
                DeviceGrid.DataSource = devicesDetails.DeviceRepository.GetDeviceList();
            }
        }
        /// <summary>
        /// it perform action on the displayed data of a grid which has the device list.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void DeviceGrid_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridEditableItem editedItem = e.Item as GridEditableItem;
            RadGrid deviceGrid = (RadGrid)sender;
            try
            {
                switch (e.CommandName)
                {

                    case "EditDevice":
                        SessionData sessionData_Device = new SessionData();
                        sessionData_Device.DeviceId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["DeviceId"]);
                        sessionData_Device.AddNewDevice = 0;
                        SaveSessionData(sessionData_Device);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "MyFunc1",
                             "genericPopup('popupAddDevice.aspx','500','500','Edit Device');", true);
                        break;

                    case "RowClick":

                        break;

                    case "ExportToPdf":
                        isExport = true;
                        isPdfExport = true;
                        deviceGrid.ExportSettings.OpenInNewWindow = true;
                        deviceGrid.ExportSettings.ExportOnlyData = true;
                        deviceGrid.ExportSettings.IgnorePaging = true;
                        //Set Page Size - Landscape
                        deviceGrid.ExportSettings.Pdf.PageHeight = Unit.Parse("210mm");
                        deviceGrid.ExportSettings.Pdf.PageWidth = Unit.Parse("297mm");
                        deviceGrid.MasterTableView.GetColumn("DeviceId").Visible = false;
                        deviceGrid.MasterTableView.GetColumn("EditLink").Visible = false;
                        //rg.MasterTableView.GetColumn("DeleteColumn").Visible = false;


                        break;

                    case "ExportToExcel":
                        isExport = true;
                        deviceGrid.ExportSettings.OpenInNewWindow = true;
                        deviceGrid.ExportSettings.ExportOnlyData = true;
                        deviceGrid.ExportSettings.IgnorePaging = true;
                        deviceGrid.MasterTableView.GetColumn("DeviceId").Visible = false;
                        deviceGrid.MasterTableView.GetColumn("EditLink").Visible = false;
                        // rg.MasterTableView.GetColumn("DeleteColumn").Visible = false;
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
        /// Formatting rows of a device grid for display
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void DeviceEdit_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridHeaderItem && isPdfExport)
            {
                foreach (TableCell cell in e.Item.Cells)
                {
                    cell.Style["border"] = "thin solid black";
                    cell.Style["background-color"] = "#cccccc";
                }
            }
            if (e.Item is GridFilteringItem && isPdfExport)
            {
                GridFilteringItem filterItem = (GridFilteringItem)DeviceGrid.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
                foreach (TableCell cell in filterItem.Cells)
                {
                    cell.Text = "";
                }
            }
            if (e.Item is GridDataItem && isPdfExport)
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
                string ExcelButtonID = ((Button)(e.Item as GridCommandItem).FindControl("ExportToExcelButton")).ClientID.ToString();
                string PdfButtonID = ((Button)(e.Item as GridCommandItem).FindControl("ExportToPdfButton")).ClientID.ToString();
                // string PageName = "Device List";
            }

        }
        /// <summary>
        /// Cells formatting of exported excel 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void DeviceGrid_ExcelExportCellFormatting(object sender, ExcelExportCellFormattingEventArgs e)
        {
            GridHeaderItem headerItem = (GridHeaderItem)DeviceGrid.MasterTableView.GetItems(GridItemType.Header)[0];
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

        #region Functions_To_AddnDeletenModify_DeviceTable

        /// <summary>
        /// Delete Devices
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Device_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            DeviceErrorMsg.Items.Clear();
            GridEditableItem item = e.Item as GridEditableItem;

            var dataKeyValue = Convert.ToInt32(item.GetDataKeyValue("DeviceId").ToString());

            try
            {
                using (UnitOfWork devicesDetails = new UnitOfWork())
                {
                    tbl_Device tblDevice = devicesDetails.tbl_DeviceRepository.Get(q => q.DeviceId == dataKeyValue).SingleOrDefault();
                    devicesDetails.tbl_DeviceRepository.Delete(tblDevice);

                    devicesDetails.Save();
                }
            }
            catch (Exception ex)
            {
                DeviceErrorMsg.Items.Add("This Device can not be deleted - It has been used.");
            }
        }

        #endregion


        #endregion


    }
}


