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
    public partial class popupAddUnknownDevice : BasePage
    {
        /// <summary>
        /// Loads Add Unknown Device screen which is not in the DB and set focus on Device Type DropDown list
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
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
            int patientOperationUnknownDeviceID = sessionData != null ? (int)(sessionData.PatientOperationUnknownDeviceID) : -1;
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                DeviceType.Items.Clear();
                Brand.Items.Clear();
                Helper.BindCollectionToControl(DeviceType, deviceDetails.Get_tlkp_DeviceType(true), "Id", "Description");
                DeviceType.DataBind();
            }

            using (UnitOfWork deviceList = new UnitOfWork())
            {
                PatientUnknownDeviceListItem patientUnknowDevice = deviceList.DeviceRepository.GetUnknownDeviceDetails(UserName).
                    Where(x => x.PatientOperationDeviceID == patientOperationUnknownDeviceID).FirstOrDefault();
                DeviceType.SelectedValue = DeviceType.Items.FindByText(patientUnknowDevice.DeviceTypeDescrition.ToString()).Value;
                Helper.BindCollectionToControl(Brand, deviceList.DeviceRepository.GetDeviceBrands((int)patientUnknowDevice.DeviceTypeId, 1, true), "Id", "Description");
                Brand.DataBind();
                Brand.SelectedValue = Brand.Items.FindByText(patientUnknowDevice.DeviceBrandDescrition.ToString()).Value;
                Description.Text = patientUnknowDevice.DeviceDescrition;
                Model.Text = patientUnknowDevice.DeviceModel;
                Manufacturer.Text = patientUnknowDevice.ManufacturerDescrition;
            }

        }

        protected void DeviceType_SelectedIndexChanged(object sender, EventArgs e)
        {
            int deviceTypeId = DeviceType.SelectedItem == null || DeviceType.SelectedItem.Value == "" ? -1 : Convert.ToInt32(DeviceType.SelectedItem.Value);

            if (deviceTypeId >= 0)
            {
                using (UnitOfWork deviceDetails = new UnitOfWork())
                {
                    Helper.BindCollectionToControl(Brand, deviceDetails.DeviceRepository.GetDeviceBrands(deviceTypeId, 1, true), "Id", "Description");

                }
            }
            else
            {
                Brand.Items.Clear();
                Brand.DataBind();
            }

            Manufacturer.Text = "";

        }

        protected void Brand_SelectedIndexChanged(object sender, EventArgs e)
        {
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                if (!string.IsNullOrEmpty(Brand.SelectedItem.Value))
                    Manufacturer.Text = deviceDetails.GetManufacturersWithOther(false, Brand.SelectedItem.Value, false).FirstOrDefault().Description;
                else
                    Manufacturer.Text = "";
            }
        }
        /// <summary>
        /// Update Device details to DB
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Update_Click(object sender, EventArgs e)
        {
            int deviceBrandId = Convert.ToInt32(Brand.SelectedItem.Value);
            string deviceModel = Model.Text;
            string deviceDescription = Description.Text;

            SessionData sessionData = GetSessionData();
            int patientOperationUnknownDeviceId = (int)(sessionData.PatientOperationUnknownDeviceID);
            try
            {
                using (UnitOfWork deviceList = new UnitOfWork())
                {
                    tbl_Device deviceDetails = deviceList.tbl_DeviceRepository.Get(q => (q.DeviceBrandId == deviceBrandId)
                        && (q.DeviceModel == deviceModel)
                        && (q.DeviceDescription == deviceDescription)).FirstOrDefault();

                    if (deviceDetails != null)
                    {
                        DisplayCustomMessageInValidationSummary("Device exists in catalog with Id " + deviceDetails.DeviceId, "DeviceDataValidationGroup");
                    }
                    else
                    {

                        tbl_DeviceBrand brandTable = deviceList.tbl_DeviceBrandRepository.Get(x => x.Id == deviceBrandId).FirstOrDefault();

                        tbl_PatientOperationDeviceDtls patientOperationDevice = deviceList.tbl_PatientOperationDeviceDtlsRepository.Get(x => x.PatientOperationDevId == patientOperationUnknownDeviceId).FirstOrDefault();
                        patientOperationDevice.DevType = Convert.ToInt32(DeviceType.SelectedItem.Value);
                        patientOperationDevice.DevBrand = Convert.ToInt32(Brand.SelectedItem.Value);
                        patientOperationDevice.DevOthBrand = "";
                        patientOperationDevice.DevOthDesc = Description.Text;
                        patientOperationDevice.DevOthMode = Model.Text;
                        patientOperationDevice.DevManuf = brandTable.ManufacturerId;
                        patientOperationDevice.IgnoreDevice = 1;
                        deviceList.tbl_PatientOperationDeviceDtlsRepository.Update(patientOperationDevice);
                        deviceList.Save();
                        sessionData.AddedSuccessMessage = "Unknown Device Type - '" + DeviceType.SelectedItem.Text.TrimEnd() + "', brand - '" + Brand.SelectedItem.Text.TrimEnd() + "', model - '"
                            + Model.Text.TrimEnd() + "' ignored";
                        SaveSessionData(sessionData);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "MyFunc1", "CloseWindow();", true);
                    }

                }
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "DeviceDataValidationGroup");
            }

        }
        /// <summary>
        /// Add Device details to DB
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Add_Click(object sender, EventArgs e)
        {
            int deviceBrandId = Convert.ToInt32(Brand.SelectedItem.Value);
            int deviceTypeId = Convert.ToInt32(DeviceType.SelectedItem.Value);
            string deviceModel = Model.Text;
            string deviceDescription = Description.Text;
            tbl_Device deviceDetails = null;

            SessionData sessionData = GetSessionData();
            int patientOperationUnknownDeviceID = (int)(sessionData.PatientOperationUnknownDeviceID);
            try
            {
                using (UnitOfWork deviceList = new UnitOfWork())
                {
                    deviceDetails = deviceList.tbl_DeviceRepository.Get(q => (q.DeviceBrandId == deviceBrandId)
                       && (q.DeviceModel == deviceModel)
                       && (q.DeviceDescription == deviceDescription)).FirstOrDefault();
                }

                if (deviceDetails != null)
                {
                    DisplayCustomMessageInValidationSummary("Device is already in catalog ", "DeviceDataValidationGroup");
                }
                else
                {
                    using (UnitOfWork deviceList = new UnitOfWork())
                    {
                        //Create device in tbl_Device
                        tbl_Device newDevice = new tbl_Device();
                        newDevice.DeviceBrandId = deviceBrandId;
                        newDevice.DeviceDescription = deviceDescription;
                        newDevice.DeviceModel = deviceModel;
                        newDevice.IsDeviceActive = 1;
                        deviceList.tbl_DeviceRepository.Insert(newDevice);
                        deviceList.Save();

                    }

                    using (UnitOfWork unknownDeviceList = new UnitOfWork())
                    {
                        tbl_PatientOperationDeviceDtls patientOperationDevice = unknownDeviceList.tbl_PatientOperationDeviceDtlsRepository.Get(x => x.PatientOperationDevId == patientOperationUnknownDeviceID).FirstOrDefault();
                        patientOperationDevice.PatientOperationDevId = patientOperationUnknownDeviceID;
                        patientOperationDevice.DevBrand = deviceBrandId;
                        patientOperationDevice.DevType = deviceTypeId;
                        patientOperationDevice.DevOthDesc = "";
                        patientOperationDevice.DevOthMode = "";
                        patientOperationDevice.DevOthBrand = "";
                        //Update Device ID into tbl_PatientOperationDeviceDtls
                        deviceDetails = unknownDeviceList.tbl_DeviceRepository.Get(q => (q.DeviceBrandId == deviceBrandId)
                                                                   && (q.DeviceModel == deviceModel)
                                                                   && (q.DeviceDescription == deviceDescription)).FirstOrDefault();
                        patientOperationDevice.DevId = deviceDetails.DeviceId;
                        unknownDeviceList.tbl_PatientOperationDeviceDtlsRepository.Update(patientOperationDevice);
                        unknownDeviceList.Save();
                    }

                    sessionData.AddedSuccessMessage = "Unknown Device Type - '" + DeviceType.SelectedItem.Text.TrimEnd() + "', brand - '" + Brand.SelectedItem.Text.TrimEnd() + "', model - '"
                        + Model.Text.TrimEnd() + "' added";
                    SaveSessionData(sessionData);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "MyFunc1", "CloseWindow();", true);
                }
            }

            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "DeviceDataValidationGroup");
            }

        }
        /// <summary>
        /// Displays Validation summary 
        /// </summary>
        /// <param name="message">Error message</param>
        /// <param name="validationGroup">Validation Group</param>
        protected void DisplayCustomMessageInValidationSummary(string message, string validationGroup = null)
        {
            CustomValidator customValidatorControl = new CustomValidator();
            customValidatorControl.IsValid = false;
            customValidatorControl.ErrorMessage = message;
            customValidatorControl.Text = "*";
            customValidatorControl.ValidationGroup = validationGroup;
            customValidatorControl.Visible = false;
            customValidatorControl.CssClass = "failureNotification";
            AddUnknownDevicesForm.Controls.Add(customValidatorControl);
        }



    }
}