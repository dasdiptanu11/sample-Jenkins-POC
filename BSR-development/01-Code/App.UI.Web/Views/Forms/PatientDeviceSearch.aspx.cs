using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.UI.Web.Views.Shared;
using App.Business;
using CDMSValidationLogic;
using System.Web.Security;
using Telerik.Web.UI;


namespace App.UI.Web.Views.Forms
{
    public partial class PatientDeviceSearch : BasePage
    {
        bool _isExport = false;
        bool _isPdfExport = false;
        /// <summary>
        /// Loads the Search Device Panel which has sveral controls related to Device
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            TurnTextBoxAutoCompleteOff();
            if (!IsPostBack)
            {
                LoadLookup();
            }
        }

        #region Device Search

        //Loads all Devices control for look up
        private void LoadLookup()
        {
            using (UnitOfWork countries = new UnitOfWork())
            {
                Helper.BindCollectionToControl(CountryList, countries.MembershipRepository.GetCountryList(false), "Id", "Description");
                Helper.BindCollectionToControl(DeviceTypeList, countries.Get_tlkp_DeviceType(true), "Id", "Description");
                DeviceTypeList.DataBind();
                CountryList.DataBind();
                DeviceTypeList.Focus();

                ListItem listItem = CountryList.Items.FindByValue("1");
                if (listItem != null)
                    CountryList.SelectedValue = listItem.Value;

            }
        }
        /// <summary>
        /// Perform Seach operation and bind data to Grid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Search_Click(object sender, EventArgs e)
        {
            PatientDeviceListPanel.Visible = true;
            PatientDeviceGrid.Rebind();
        }
        /// <summary>
        /// Clears all control load up data
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Clear_Click(object sender, EventArgs e)
        {
            ErrorMessagesList.Items.Clear();
            DeviceTypeList.SelectedIndex = 0;
            CountryList.SelectedIndex = 0;
            DeviceTypeList.Focus();
            DeviceDescription.Items.Clear();
            DeviceModel.Items.Clear();
            DeviceBrand.Items.Clear();
            DeviceBrand.Enabled = false;
            DeviceDescription.Enabled = false;
            DeviceModel.Enabled = false;
            Manufacturer.Text = "";
            LotNo.Text = "";
            PatientDeviceListPanel.Visible = false;
        }

        #endregion

        #region Patient_Device_Search

        /// <summary>
        /// Call LoadPatientOperationList method on OnNeedDataSource event of the Telerik component Grid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void PatientDeviceGrid_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            PatientDeviceGrid.ExportSettings.FileName = "PatientDeviceList" + DateTime.Now.ToString();
            LoadPatientOperationList();
        }
        /// <summary>
        /// Loads Patient Operation List
        /// </summary>
        protected void LoadPatientOperationList()
        {

            int countryID = Convert.ToInt32(CountryList.SelectedItem.Value);
            int typeID = (DeviceTypeList.SelectedItem == null || DeviceTypeList.SelectedItem.Value == "") ? -1 : Convert.ToInt32(DeviceTypeList.SelectedItem.Value);
            int brandID = (DeviceBrand.SelectedItem == null || DeviceBrand.SelectedItem.Value == "") ? -1 : Convert.ToInt32(DeviceBrand.SelectedItem.Value);
            string description = (DeviceDescription.SelectedItem == null || DeviceDescription.SelectedItem.Value == "") ? "" : DeviceDescription.SelectedItem.Text;
            string model = (DeviceModel.SelectedItem == null || DeviceModel.SelectedItem.Value == "") ? "" : DeviceModel.SelectedItem.Text;
            string manufacturerName = Manufacturer.Text;
            ErrorMessagesList.Items.Clear();
            using (UnitOfWork PatientDetails = new UnitOfWork())
            {
                PatientDeviceGrid.DataSource = PatientDetails.DeviceRepository.GetPatientListWithDevice(countryID, typeID, brandID, model, manufacturerName, LotNo.Text,
                         description, UserName);

            }
            if (countryID == Constants.COUNTRY_CODE_FOR_AUSTRALIA)
            {
                PatientDeviceGrid.MasterTableView.GetColumn("PatientMedicareNo").Visible = true;
                PatientDeviceGrid.MasterTableView.GetColumn("PatientNHINo").Visible = false;
            }
            else
            {
                PatientDeviceGrid.MasterTableView.GetColumn("PatientMedicareNo").Visible = false;
                PatientDeviceGrid.MasterTableView.GetColumn("PatientNHINo").Visible = true;
            }
        }

        #endregion Patient_Device_Search

        /// <summary>
        /// Export Patient List for Device Type to PDF
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void PatientDeviceGrid_PdfExporting(object sender, GridPdfExportingArgs e)
        {
            string newHTML = string.Empty;
            string addHTML = string.Empty;
            string message = "Patients List for Device type - '" + DeviceTypeList.SelectedItem.Text + "', brand - '" + DeviceBrand.SelectedItem.Text + "', model - '" + DeviceModel.SelectedItem.Text +
                                      "', description - '" + DeviceDescription.SelectedItem.Text + "' and manufacturer - '" + Manufacturer.Text + "'";
            string header = "<div width=\"100%\" style=\"text-align:centre;font-size:10px;font-family:Verdana;\">" + message + "</div>";

            string date = "<div width=\"25%\" style=\"text-align:left;font-size:9px;font-family:Verdana;\">Date:" + DateTime.Today.ToShortDateString() + "</div>";

            newHTML = e.RawHTML;
            // addHTML = @"<img alt='' src='~\Images\Monash_Logo.jpg'/>";
            // newHTML = addHTML + strHeader + newHTML + strFooter;
            newHTML = header + date + newHTML;
            e.RawHTML = newHTML;
        }


        #region PatientDeviceGrid_EventsAndCommands

        /// <summary>
        /// Perform various operations on loaded data in a Device Grid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void PatientDeviceGrid_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            GridEditableItem editedItem = e.Item as GridEditableItem;
            RadGrid patientGrid = (RadGrid)sender;
            try
            {
                SessionData sessionData = GetSessionData();
                switch (e.CommandName)
                {
                    case "EditPatient":
                        sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientOperationId"]);
                        sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                        SaveSessionData(sessionData);
                        Response.Redirect(Properties.Resource2.OperationPagePath, false);
                        break;
                    case "RowClick":

                        break;

                    case "ExportToPdf":
                        _isExport = true;
                        _isPdfExport = true;
                        patientGrid.ExportSettings.OpenInNewWindow = true;
                        patientGrid.ExportSettings.ExportOnlyData = true;
                        patientGrid.ExportSettings.IgnorePaging = true;
                        PatientDeviceGrid.MasterTableView.Style["font-size"] = "7pt";
                        patientGrid.ExportSettings.Pdf.PageHeight = Unit.Parse("210mm");
                        patientGrid.ExportSettings.Pdf.PageWidth = Unit.Parse("297mm");

                        PatientDeviceGrid.MasterTableView.GetColumn("UR_No").HeaderStyle.Width = Unit.Pixel(20);
                        PatientDeviceGrid.MasterTableView.GetColumn("PatientPrimarySite").HeaderStyle.Width = Unit.Pixel(70);
                        PatientDeviceGrid.MasterTableView.GetColumn("PatientPrimarySite").ItemStyle.Wrap = true;

                        PatientDeviceGrid.MasterTableView.GetColumn("PatientName").HeaderStyle.Width = Unit.Pixel(80);
                        PatientDeviceGrid.MasterTableView.GetColumn("PatientName").ItemStyle.Wrap = true;

                        PatientDeviceGrid.MasterTableView.GetColumn("DOB").HeaderStyle.Width = Unit.Pixel(50);
                        PatientDeviceGrid.MasterTableView.GetColumn("PatientIHI").HeaderStyle.Width = Unit.Pixel(50);
                        PatientDeviceGrid.MasterTableView.GetColumn("PatientAddress").HeaderStyle.Width = Unit.Pixel(150);
                        PatientDeviceGrid.MasterTableView.GetColumn("PatientAddress").ItemStyle.Wrap = true;

                        PatientDeviceGrid.MasterTableView.GetColumn("PatientTelephone").HeaderStyle.Width = Unit.Pixel(70);
                        PatientDeviceGrid.MasterTableView.GetColumn("OperationDate").HeaderStyle.Width = Unit.Pixel(50);
                        PatientDeviceGrid.MasterTableView.GetColumn("SurgeonName").HeaderStyle.Width = Unit.Pixel(80);
                        PatientDeviceGrid.MasterTableView.GetColumn("SurgeonEmail").HeaderStyle.Width = Unit.Pixel(100);
                        PatientDeviceGrid.MasterTableView.GetColumn("SurgeonEmail").ItemStyle.Wrap = true;
                        PatientDeviceGrid.MasterTableView.GetColumn("LotNo").HeaderStyle.Width = Unit.Pixel(50);
                        if (Convert.ToInt32(CountryList.SelectedItem.Value) == Constants.COUNTRY_CODE_FOR_AUSTRALIA)
                        {
                            PatientDeviceGrid.MasterTableView.GetColumn("PatientMedicareNo").Visible = true;
                            PatientDeviceGrid.MasterTableView.GetColumn("PatientMedicareNo").HeaderStyle.Width = Unit.Pixel(50);
                            PatientDeviceGrid.MasterTableView.GetColumn("PatientNHINo").Visible = false;
                        }
                        else
                        {
                            PatientDeviceGrid.MasterTableView.GetColumn("PatientMedicareNo").Visible = false;
                            PatientDeviceGrid.MasterTableView.GetColumn("PatientNHINo").Visible = true;
                            PatientDeviceGrid.MasterTableView.GetColumn("PatientNHINo").HeaderStyle.Width = Unit.Pixel(50);
                        }

                        patientGrid.MasterTableView.GetColumn("PatientId").Visible = false;
                        patientGrid.MasterTableView.GetColumn("PatientOperationId").Visible = false;
                        patientGrid.MasterTableView.GetColumn("PatientAddress").Visible = true;
                        patientGrid.MasterTableView.GetColumn("PatientTelephone").Visible = true;
                        patientGrid.MasterTableView.GetColumn("SurgeonEmail").Visible = true;
                        patientGrid.MasterTableView.GetColumn("LotNo").Visible = true;

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
        /// Formatting rows of a device grid for display
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void PatientDeviceGrid_ItemCreated(object sender, GridItemEventArgs e)
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
                    cell.Style["border"] = "thin solid black";
            }
            if (e.Item is GridCommandItem)
            {
                var exportToPdfButton = (e.Item as GridCommandItem).FindControl("ExportToPdfButton") as Button;
                if (exportToPdfButton != null) { ScriptManager.GetCurrent(Page).RegisterPostBackControl(exportToPdfButton); }
                string pdfButtonId = ((Button)(e.Item as GridCommandItem).FindControl("ExportToPdfButton")).ClientID.ToString();
                string pageName = "Patient Device List";
                ((Button)(e.Item as GridCommandItem).FindControl("ExportToPdfButton")).Attributes.Add("onclick", "return ConfirmDownload(" + pdfButtonId + ",'" + pageName + "')");
            }
        }

        /// <summary>
        /// Binding OperationDate item for exported list
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void PatientDeviceGrid_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataItem = e.Item as GridDataItem;
                if (_isExport)
                {
                    if (dataItem["OperationDate"].Text != "&nbsp;")
                    {
                        DateTime operationDate = Convert.ToDateTime(dataItem["OperationDate"].Text.ToString());
                        dataItem["OperationDate"].Text = operationDate.ToShortDateString();
                    }
                }
            }
        }


        #endregion radgrdPatientDeviceList_EventsAndCommands

        #region Events_For_Index_Changed
        /// <summary>
        /// Binds or Clear Control data on SelectedIndexChanged event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void DeviceTypeList_SelectedIndexChanged(object sender, EventArgs e)
        {
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                Helper.BindCollectionToControl(DeviceBrand, deviceDetails.DeviceRepository.GetDeviceBrands(DeviceTypeList.SelectedItem == null || DeviceTypeList.SelectedItem.Value == "" ? -1 : Convert.ToInt32(DeviceTypeList.SelectedItem.Value), 1, true), "Id", "Description");
                DeviceBrand.DataBind();
            }
            if (DeviceTypeList.SelectedItem == null || DeviceTypeList.SelectedItem.Value == "")
            {
                DeviceBrand.Enabled = false;
                DeviceTypeList.Focus();
            }
            else
            {
                DeviceBrand.Enabled = true;
                DeviceBrand.Focus();
            }

            DeviceDescription.Items.Clear();
            DeviceModel.Items.Clear();
            Manufacturer.Text = "";
            DeviceDescription.Enabled = false;
            DeviceModel.Enabled = false;
            PatientDeviceListPanel.Visible = false;

        }
        /// <summary>
        /// Binds or Clear Control data on SelectedIndexChanged event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void DeviceBrand_SelectedIndexChanged(object sender, EventArgs e)
        {
            int brandId = DeviceBrand.SelectedItem.Value == null || DeviceBrand.SelectedItem.Value == "" ? -1 : Convert.ToInt32(DeviceBrand.SelectedItem.Value);
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                if (!string.IsNullOrEmpty(DeviceBrand.SelectedItem.Value))
                    Manufacturer.Text = deviceDetails.GetManufacturersWithOther(false, DeviceBrand.SelectedItem.Value, false).FirstOrDefault().Description;
                else
                    Manufacturer.Text = "";
                DeviceDescription.Items.Clear();
                DeviceModel.Items.Clear();
                Helper.BindCollectionToControl(DeviceDescription, deviceDetails.tbl_DeviceRepository.Get(x => x.DeviceBrandId == brandId), "DeviceId", "DeviceDescription");
                Helper.BindCollectionToControl(DeviceModel, deviceDetails.tbl_DeviceRepository.Get(x => x.DeviceBrandId == brandId), "DeviceId", "DeviceModel");
                DeviceDescription.DataBind();
                DeviceModel.DataBind();
            }
            DeviceDescription.Enabled = true;
            DeviceModel.Enabled = true;
            DeviceDescription.Focus();
            PatientDeviceListPanel.Visible = false;
        }

        /// <summary>
        /// Binds or Clear Control data on SelectedIndexChanged event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void DeviceDescription_SelectedIndexChanged(object sender, EventArgs e)
        {
            string deviceId = DeviceDescription.SelectedItem.Value == null ? "" : DeviceDescription.SelectedItem.Value;

            ListItem listItem = DeviceModel.Items.FindByValue(deviceId);
            if (listItem != null)
                DeviceModel.SelectedValue = listItem.Value;
            PatientDeviceListPanel.Visible = false;
        }
        /// <summary>
        /// Binds or Clear Control data on SelectedIndexChanged event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void DeviceModel_SelectedIndexChanged(object sender, EventArgs e)
        {
            string deviceId = DeviceModel.SelectedItem.Value == null ? "" : DeviceModel.SelectedItem.Value;

            ListItem listItem = DeviceDescription.Items.FindByValue(deviceId);
            if (listItem != null)
                DeviceDescription.SelectedValue = listItem.Value;
            PatientDeviceListPanel.Visible = false;
        }

        #endregion Events_For_Index_Changed


    }
}