using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.UI.Web.Views.Shared;
using App.Business;

namespace App.UI.Web.Views.Forms
{
    public partial class popupAddDevice : BasePage
    {

        #region "Loading Page and lookUps"

        /// <summary>
        /// Loads Add Device screen and set focus on Device Type DropDown list
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["IsAdd"] != null)
                {
                    SessionData sessionData = GetSessionData();
                    if (sessionData != null)
                    {
                        sessionData.DeviceId = -1;
                        sessionData.AddNewDevice = 1;
                    }
                    SaveSessionData(sessionData);
                }
                LoadLookupDevice();
                DeviceType.Focus();
            }
        }
        /// <summary>
        /// Loads Device Type
        /// </summary>
        protected void LoadLookupDevice()
        {
            SessionData sessionData = GetSessionData();
            int deviceId = sessionData != null ? (int)(sessionData.DeviceId) : -1;
            int addNewDevice = sessionData != null ? (int)(sessionData.AddNewDevice) : 1;
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                DeviceType.Items.Clear();
                BrandName.Items.Clear();
                Helper.BindCollectionToControl(DeviceType, deviceDetails.Get_tlkp_DeviceType(true), "Id", "Description");
                DeviceStatus.Checked = true;
            }

            if (deviceId != -1 && addNewDevice != 1) //Edit the device
            {

                using (UnitOfWork deviceList = new UnitOfWork())
                {
                    DeviceList DeviceTable = deviceList.DeviceRepository.GetDeviceList().Where(q => q.DeviceId == deviceId).FirstOrDefault();
                    Dictionary<System.Web.UI.Control, Object> controlMapping = new Dictionary<System.Web.UI.Control, Object>();
                    if (DeviceTable != null)
                    {

                        ListItem listItemDeviceType = DeviceType.Items.FindByValue(DeviceTable.DeviceTypeId.ToString());
                        if (listItemDeviceType != null)
                        {
                            DeviceType.SelectedValue = listItemDeviceType.Value;
                        }
                        else
                        {
                            DeviceType.SelectedItem.Text = DeviceTable.DeviceTypeDescription;
                        }
                        Helper.BindCollectionToControl(BrandName, deviceList.DeviceRepository.GetDeviceBrands((int)DeviceTable.DeviceTypeId, 1, true), "Id", "Description");
                        if (DeviceTable.IsBrandActive == 0)
                        {
                            ListItem listItemBrand_Inactive = new ListItem(DeviceTable.DeviceBrandDescription, DeviceTable.DeviceBrandId.ToString());
                            BrandName.Items.Add(listItemBrand_Inactive);
                        }
                        ListItem listItemBrand = BrandName.Items.FindByValue(DeviceTable.DeviceBrandId.ToString());
                        if (listItemBrand != null)
                        {
                            BrandName.SelectedValue = listItemBrand.Value;
                        }
                        else
                        {
                            BrandName.SelectedItem.Text = DeviceTable.DeviceBrandDescription;
                        }
                        Description.Text = DeviceTable.DeviceDescription;
                        Model.Text = DeviceTable.DeviceModel;
                        Manufacturer.Text = DeviceTable.DeviceManufacturerDescription;
                        DeviceStatus.Checked = DeviceTable.IsDeviceActive;

                    }
                    else
                    {
                        ShowButtonForAddMode();
                    }
                }
                ShowButtonForEditMode();
            }
            else
            {
                ShowButtonForAddMode();
            }

        }

        #region "Show and hide button in accordance to mode - Edit or Add device"
        /// <summary>
        /// show or hide button for add mode
        /// </summary>
        public void ShowButtonForAddMode()
        {
            contentHeader.Title = "Add Device";
            Add.Visible = true;
            Add.Enabled = true;
            Update.Visible = false;
            Update.Enabled = false;
        }
        /// <summary>
        /// show or hide button for Edit mode
        /// </summary>
        public void ShowButtonForEditMode()
        {
            contentHeader.Title = "Edit Device";
            Add.Visible = false;
            Add.Enabled = false;
            Update.Visible = true;
            Update.Enabled = true;

        }

        #endregion "Show and hide button in accordance to mode - Edit or Add device"

        #endregion "Loading Page and lookUps"

        #region "Clearing fields/Showing errors and messages"

        /// <summary>
        /// To clear control data
        /// </summary>
        public void ClearFields()
        {
            DeviceType.SelectedIndex = 0;
            BrandName.SelectedIndex = 0;
            Model.Text = "";
            Manufacturer.Text = "";
            Description.Text = "";
        }

        /// <summary>
        /// Clears Messages and Errors of validation summary
        /// </summary>
        protected void ClearAllMessagesAndErrors()
        {
            NotifyMessage.Text = "";
            ErrorNotification.Items.Clear();
        }
        /// <summary>
        ///  Display messages in a label
        /// </summary>
        /// <param name="message">Message which is use to be notified</param>
        public void ShowMessage(string message)
        {

            NotifyMessage.ForeColor = System.Drawing.Color.Black;
            NotifyMessage.Text = message;

        }
        /// <summary>
        /// Displays Validation summary 
        /// </summary>
        /// <param name="message">Error message</param>
        /// <param name="validationGroup">Validation Group</param>
        protected void DisplayCustomMessageInValidationSummary(string message, string validationGroup = null)
        {
            CustomValidator customValidator = new CustomValidator();
            customValidator.IsValid = false;
            customValidator.ErrorMessage = message;
            customValidator.Text = "*";
            customValidator.ValidationGroup = validationGroup;
            customValidator.Visible = false;
            customValidator.CssClass = "failureNotification";
            form1.Controls.Add(customValidator);
        }

        #endregion "Clearing fields/Showing errors and messages"

        #region "Changing values of textboxes with change in selected values in ddl"
        /// <summary>
        /// Selects other related details on SelectedIndexChanged event of DeviceType control
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void DeviceType_SelectedIndexChanged(object sender, EventArgs e)
        {

            int deviceTypeId = DeviceType.SelectedItem == null || DeviceType.SelectedItem.Value == "" ? -1 : Convert.ToInt32(DeviceType.SelectedItem.Value);
            if (deviceTypeId >= 0)
            {
                using (UnitOfWork DeviceDetails = new UnitOfWork())
                {
                    Helper.BindCollectionToControl(BrandName, DeviceDetails.DeviceRepository.GetDeviceBrands(deviceTypeId, 1, true), "Id", "Description");

                }
            }
            else
            {
                BrandName.Items.Clear();
                BrandName.DataBind();
            }
            Manufacturer.Text = "";
        }
        /// <summary>
        /// Selects other related details on SelectedIndexChanged event of BrandName control
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void BrandName_SelectedIndexChanged(object sender, EventArgs e)
        {
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                if (!string.IsNullOrEmpty(BrandName.SelectedItem.Value))
                    Manufacturer.Text = deviceDetails.GetManufacturersWithOther(false, BrandName.SelectedItem.Value, false).FirstOrDefault().Description;
                else
                    Manufacturer.Text = "";
            }
        }

        #endregion "Changing values of textboxes with change in selected values in ddl"
        /// <summary>
        /// Update Device details to DB
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Update_Click(object sender, EventArgs e)
        {

            bool update = false;
            SessionData sessionData = GetSessionData();
            int deviceId = (int)(sessionData.DeviceId);
            int deviceTypeId = Convert.ToInt32(DeviceType.SelectedValue);
            int deviceBrandId = Convert.ToInt32(BrandName.SelectedValue);
            string deviceModel = Model.Text;
            string deviceDescription = Description.Text;

            ClearAllMessagesAndErrors();

            try
            {
                using (UnitOfWork deviceList = new UnitOfWork())
                {
                    tbl_Device deviceInvalid = deviceList.tbl_DeviceRepository.Get(q => (q.DeviceId != deviceId && q.DeviceModel == deviceModel &&
                                                                                  q.DeviceBrandId == deviceBrandId)).FirstOrDefault();

                    if (deviceInvalid != null)
                    {
                        update = false;
                    }
                    else
                    {
                        update = true;
                    }
                    if (update == true)
                    {
                        tbl_Device deviceTable = new tbl_Device();
                        deviceTable.DeviceId = deviceId;
                        deviceTable.DeviceBrandId = deviceBrandId;
                        deviceTable.DeviceModel = Model.Text;
                        deviceTable.DeviceDescription = Description.Text;
                        deviceTable.LastUpdatedBy = UserName;
                        deviceTable.LastUpdatedDateTime = System.DateTime.Now;
                        deviceTable.IsDeviceActive = DeviceStatus.Checked == true ? 1 : 0;
                        deviceList.tbl_DeviceRepository.Update(deviceTable);
                        deviceList.Save();
                        sessionData.AddedSuccessMessage = "Device Type - '" + DeviceType.SelectedItem.Text.TrimEnd() + "', Brand - '" + BrandName.SelectedItem.Text.TrimEnd() + "', Model - '" + Model.Text.TrimEnd() + "' updated";
                        SaveSessionData(sessionData);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "MyFunc1", "CloseWindow('add');", true);
                    }
                    else
                    {
                        DisplayCustomMessageInValidationSummary("Device exists in catalog", "DeviceDataValidationGroup");
                    }

                }
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "DeviceDataValidationGroup");
            }

        }
        /// <summary>
        /// Save Device details to DB
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Add_Click(object sender, EventArgs e)
        {
            ClearAllMessagesAndErrors();
            bool insert = false;
            int brandId = Convert.ToInt32(BrandName.SelectedItem.Value);
            int deviceTypeId = Convert.ToInt32(DeviceType.SelectedItem.Value);
            SessionData sessionData = GetSessionData();

            try
            {

                using (UnitOfWork deviceList = new UnitOfWork())
                {
                    tbl_Device deviceInvalid = deviceList.tbl_DeviceRepository.Get(q => (q.DeviceModel == Model.Text &&
                                                                               q.DeviceBrandId == brandId)).FirstOrDefault();

                    if (deviceInvalid != null)
                    {
                        insert = false;
                    }
                    else
                    {
                        insert = true;
                    }

                }

                if (insert)
                {
                    using (UnitOfWork deviceDetails = new UnitOfWork())
                    {
                        tbl_Device dataItems = new tbl_Device();

                        dataItems.DeviceBrandId = Convert.ToInt32(BrandName.SelectedValue);
                        dataItems.DeviceDescription = Description.Text;
                        dataItems.DeviceModel = Model.Text;
                        dataItems.CreatedBy = UserName;
                        dataItems.CreatedDateTime = System.DateTime.Now;
                        dataItems.IsDeviceActive = DeviceStatus.Checked == true ? 1 : 0;
                        deviceDetails.tbl_DeviceRepository.Insert(dataItems);
                        deviceDetails.Save();
                        sessionData.AddedSuccessMessage = "Device Type - '" + DeviceType.SelectedItem.Text.TrimEnd() + "', Brand - '" + BrandName.SelectedItem.Text.TrimEnd() + "', Model - '" + Model.Text.TrimEnd() + "' added";
                        SaveSessionData(sessionData);
                        UpdateUnknowDeviceList(Convert.ToInt32(BrandName.SelectedValue), Description.Text, Model.Text);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "MyFunc1", "CloseWindow('add');", true);
                        ClearFields();
                    }
                }
                else
                {
                    DisplayCustomMessageInValidationSummary("Device exists in repository", "DeviceDataValidationGroup");
                }
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "DeviceDataValidationGroup");
            }
        }
        /// <summary>
        /// Add new brand Devices
        /// </summary>
        /// <param name="brandId">Id of the Device Brand</param>
        /// <param name="deviceDescrition">short Device description</param>
        /// <param name="deviceModel">Model Name of the Device</param>
        public void UpdateUnknowDeviceList(int brandId, string deviceDescrition, string deviceModel)
        {
            IEnumerable<tbl_PatientOperationDeviceDtls> unknownDevicesUsedInOperations = null;
            DeviceList newDevice = new DeviceList();
            try
            {
                using (UnitOfWork deviceDetails = new UnitOfWork())
                {
                    newDevice = deviceDetails.DeviceRepository.GetDeviceList().Where(x => x.DeviceBrandId == brandId && x.DeviceDescription == deviceDescrition && x.DeviceModel == deviceModel).FirstOrDefault();

                    unknownDevicesUsedInOperations = deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Get(x => x.DevBrand == newDevice.DeviceBrandId
                                        && x.DevOthDesc == deviceDescrition
                                        && x.DevOthMode == deviceModel);
                    foreach (tbl_PatientOperationDeviceDtls unknownDevice in unknownDevicesUsedInOperations)
                    {

                        unknownDevice.DevId = newDevice.DeviceId;
                        unknownDevice.DevOthManuf = "";
                        unknownDevice.DevOthMode = "";
                        unknownDevice.DevOthDesc = "";
                        unknownDevice.DevOthBrand = "";
                        unknownDevice.DevBrand = newDevice.DeviceBrandId;
                        unknownDevice.DevManuf = newDevice.DeviceManufacturerId;
                        deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Update(unknownDevice);
                        deviceDetails.Save();
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "DeviceDataValidationGroup");
            }
        }



    }
}
