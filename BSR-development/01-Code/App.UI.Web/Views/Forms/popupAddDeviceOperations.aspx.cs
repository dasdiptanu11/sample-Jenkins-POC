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
    public partial class AddDeviceOperations : BasePage
    {
        /// <summary>
        /// Loads Up Add Devices screen in operation details Page
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["IsAdd"] != null)
            {
                SessionData sessionData = GetSessionData();
                sessionData.PatientOperationDeviceId = 0;
            }
            //ShowHidePanel();
            if (!IsPostBack)
            {
                SessionData sessionData = GetSessionData();
                if (sessionData.PatientOperationDeviceId == 0)
                {
                    LoadLookupDevice(true);
                    DisableDeviceControls();

                }
                else
                {
                    AddDevices.Text = "Update";
                    contentHeader.Title = "Edit Device";
                    LoadLookupDevice(true);
                    InitData();
                }
            }
            ShowHidePanel();
        }



        #region Load Lookups
        /// <summary>
        /// Loads Device type
        /// </summary>
        /// <param name="isNew"> IsDevice type New or already present in the system</param>
        /// <returns></returns>
        protected bool LoadLookupDevice(bool isNew)
        {
            SessionData sessionData = GetSessionData();
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                Helper.BindCollectionToControl(DeviceType, deviceDetails.Get_tlkp_DeviceType(true), "Id", "Description");
                foreach (RadComboBoxItem items in DeviceType.Items)
                {
                    if (items.Value == "2")
                    {
                        DeviceType.Items.Remove(items);
                        break;
                    }
                }
                //Helper.BindCollectionToControl(DeviceType, bl.Get_tlkp_DeviceType(true), "Id", "Description");
                Helper.BindCollectionToControl(Buttress, deviceDetails.GetYesNo(false), "Id", "Description");
                Helper.BindCollectionToControl(PortFixMethod, deviceDetails.Get_tlkp_PortFixationMethod_NoId(true), "Id", "Description");
                if (!isNew)
                {
                    Helper.BindCollectionToControl(BrandName, deviceDetails.GetBrandNamesWithOther(true, null), "Id", "Description");
                    Helper.BindCollectionToControl(Description, deviceDetails.GetDeviceDescriptionWithOther(true, null), "Id", "Description");
                    Helper.BindCollectionToControl(Model, deviceDetails.GetModelWithOther(true, null, true), "Id", "Description");
                    Helper.BindCollectionToControl(Manufacturer, deviceDetails.GetManufacturersWithOther(true, null, true), "Id", "Description");

                }
                else
                {
                    BrandName.Items.Clear();
                    Description.Items.Clear();
                    Model.Items.Clear();
                    Manufacturer.Items.Clear();
                    PortFixMethod.SelectedValue = "";
                    SerialNoLotNo.Text = "";
                    OtherBrandName.Text = "";
                    OtherModel.Text = "";
                    //Buttress.SelectedValue = "";
                }
            }
            return true;
        }
        /// <summary>
        /// Load Port Fix Device Type
        /// </summary>
        /// <param name="isNew">Is Device type New or already present in the system</param>
        /// <returns></returns>
        protected bool LoadLookupDevicePortFix(bool isNew)
        {
            SessionData sessionData = GetSessionData();
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                if (!isNew)
                {
                    Helper.BindCollectionToControl(PortFixDescription, deviceDetails.GetDeviceDescriptionWithOther(true, null), "Id", "Description");
                    Helper.BindCollectionToControl(PortFixModel, deviceDetails.GetModelWithOther(true, null, true), "Id", "Description");
                    Helper.BindCollectionToControl(PortFixManufacturer, deviceDetails.GetManufacturersWithOther(true, null, true), "Id", "Description");
                    PortFixDescription.Enabled = true;
                    PortFixModel.Enabled = true;
                    PortFixManufacturer.Enabled = true;
                }
                //pases acces porta s selected device
                Helper.BindCollectionToControl(PortFixBrandName, deviceDetails.GetBrandNamesWithOther(true, "2"), "Id", "Description");
                PortFixBrandName.Enabled = true;

            }
            return true;
        }
        #endregion

        #region InitData
        //Initializing Device data
        private void InitData()
        {
            SessionData sessionData = GetSessionData();
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                tbl_PatientOperationDeviceDtls dataItems = deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Get(x => x.PatientOperationDevId == sessionData.PatientOperationDeviceId).FirstOrDefault();
                if (dataItems != null)
                {
                    Dictionary<System.Web.UI.Control, Object> controlMapping = new Dictionary<System.Web.UI.Control, Object>();
                    //Load the parent device details
                    InitDeviceDetailsParent(deviceDetails, dataItems, controlMapping);
                    //If device type is access port or Gastricband
                    if (dataItems.DevType == 1 || dataItems.DevType == 0)
                    {
                        //Get the child details from table
                        tbl_PatientOperationDeviceDtls dataItemsPF = deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Get(x => x.ParentPatientOperationDevId == sessionData.PatientOperationDeviceId).FirstOrDefault();
                        if (dataItemsPF != null)
                        {
                            //Load look up for device port
                            LoadLookupDevicePortFix(false);
                            //Show the panel
                            AccessPortPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                            //Load the child device details
                            InitDeviceDetailsChild(deviceDetails, dataItemsPF, controlMapping);
                        }
                    }
                    //Stapling device
                    else if (dataItems.DevType == 3)
                    {
                        controlMapping.Add(Buttress, dataItems.ButtressId);
                    }
                    PopulateControl(controlMapping);
                    //Show hide panel based on device type
                    ShowHideChildDevice(DeviceType.SelectedValue);
                }
            }
        }
        //initializing child device details 
        private void InitDeviceDetailsChild(UnitOfWork deviceDetails, tbl_PatientOperationDeviceDtls dataItems, Dictionary<System.Web.UI.Control, Object> controlMapping)
        {
            if (dataItems.DevId != null)
            {
                tbl_Device deviceDataItems = deviceDetails.tbl_DeviceRepository.Get(x => x.DeviceId == dataItems.DevId).FirstOrDefault();
                if (deviceDataItems != null)
                {
                    controlMapping.Add(PortFixBrandName, deviceDataItems.DeviceBrandId);
                    LoadDescManuFromBrand(deviceDataItems.DeviceBrandId.ToString(), PortFixOtherDescPanel, PortFixOtherModelPanel, PortFixOtherBrandPanel, PortFixOtherBrandName, PortFixOtherDesc, PortFixManufacturer, PortFixDescription, PortFixModel);
                    //
                    controlMapping.Add(PortFixDescription, deviceDataItems.DeviceId);
                    LoadModelFromDesc(deviceDataItems.DeviceId.ToString(), PortFixOtherDescPanel, PortFixOtherModelPanel, PortFixOtherDesc, PortFixModel);
                    //
                    controlMapping.Add(PortFixModel, deviceDataItems.DeviceId);
                    //
                    PortFixOtherModelPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    PortFixOtherBrandPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    PortFixOtherDescPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
            }
            else
            {
                //If other model is not null then model is other
                if (!string.IsNullOrEmpty(dataItems.DevOthMode))
                {
                    controlMapping.Add(PortFixModel, "-1");
                    controlMapping.Add(PortFixOtherModel, dataItems.DevOthMode);
                    PortFixOtherModelPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                }
                else
                    PortFixOtherModelPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                //If other model is not null then Desc is other
                if (!string.IsNullOrEmpty(dataItems.DevOthDesc))
                {
                    controlMapping.Add(PortFixDescription, "-1");
                    controlMapping.Add(PortFixOtherDesc, dataItems.DevOthDesc);
                    PortFixOtherDescPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                }
                else
                    PortFixOtherDescPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                //If other brand is not null then brand is other
                if (!string.IsNullOrEmpty(dataItems.DevOthBrand))
                {
                    controlMapping.Add(PortFixBrandName, "-1");
                    controlMapping.Add(PortFixOtherBrandName, dataItems.DevOthBrand);
                    PortFixOtherBrandPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                }
                else
                {
                    controlMapping.Add(PortFixBrandName, dataItems.DevBrand);
                    PortFixOtherBrandPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
            }
            //
            controlMapping.Add(PortFixSerialNoLotNo, dataItems.DevLotNo);
            //If other Manu is not null then Manu is other
            if (!string.IsNullOrEmpty(dataItems.DevOthManuf))
            {
                controlMapping.Add(PortFixManufacturer, "-1");
                controlMapping.Add(PortFixOtherManufacturer, dataItems.DevOthManuf);
                PortFixManufacturerPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
            }
            else
            {
                controlMapping.Add(PortFixManufacturer, dataItems.DevManuf);
                PortFixManufacturerPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            }
        }

        //initializing parent device details 
        private void InitDeviceDetailsParent(UnitOfWork deviceDetails, tbl_PatientOperationDeviceDtls dataItems, Dictionary<System.Web.UI.Control, Object> controlMapping)
        {
            if (dataItems.DevId != null)
            {
                tbl_Device deviceDataItems = deviceDetails.tbl_DeviceRepository.Get(x => x.DeviceId == dataItems.DevId).FirstOrDefault();
                if (deviceDataItems != null)
                {
                    controlMapping.Add(DeviceType, dataItems.DevType);
                    LoadBrandFromDevice(dataItems.DevType.ToString());
                    //
                    controlMapping.Add(BrandName, deviceDataItems.DeviceBrandId);
                    LoadDescManuFromBrand(deviceDataItems.DeviceBrandId.ToString(), OtherDescPanel, OtherModelPanel, OtherBrandPanel, OtherBrandName, OtherDescription, Manufacturer, Description, Model);
                    //
                    controlMapping.Add(Description, deviceDataItems.DeviceId);
                    LoadModelFromDesc(deviceDataItems.DeviceId.ToString(), OtherDescPanel, OtherModelPanel, OtherDescription, Model);
                    //
                    controlMapping.Add(Model, deviceDataItems.DeviceId);
                    //
                    OtherModelPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    OtherBrandPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    OtherDescPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
            }
            else
            {
                controlMapping.Add(DeviceType, dataItems.DevType);
                LoadBrandFromDevice(dataItems.DevType.ToString());
                //
                //If other brand is not null then brand is other
                if (!string.IsNullOrEmpty(dataItems.DevOthBrand))
                {
                    controlMapping.Add(BrandName, "-1");
                    LoadDescManuFromBrand("-1", OtherDescPanel, OtherModelPanel, OtherBrandPanel, OtherBrandName, OtherDescription, Manufacturer, Description, Model);
                    controlMapping.Add(OtherBrandName, dataItems.DevOthBrand);
                    OtherBrandPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                }
                else
                {
                    controlMapping.Add(BrandName, dataItems.DevBrand);
                    LoadDescManuFromBrand(dataItems.DevBrand.ToString(), OtherDescPanel, OtherModelPanel, OtherBrandPanel, OtherBrandName, OtherDescription, Manufacturer, Description, Model);
                    OtherBrandPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
                //If other model is not null then Desc is other
                if (!string.IsNullOrEmpty(dataItems.DevOthDesc))
                {
                    controlMapping.Add(Description, "-1");
                    LoadModelFromDesc("-1", OtherDescPanel, OtherModelPanel, OtherDescription, Model);
                    controlMapping.Add(OtherDescription, dataItems.DevOthDesc);
                    OtherDescPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                }
                else
                    OtherDescPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                //If other model is not null then model is other
                if (!string.IsNullOrEmpty(dataItems.DevOthMode))
                {
                    controlMapping.Add(Model, "-1");
                    controlMapping.Add(OtherModel, dataItems.DevOthMode);
                    OtherModelPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                }
                else
                    OtherModelPanel.Style.Add(HtmlTextWriterStyle.Display, "none");

            }

            controlMapping.Add(SerialNoLotNo, dataItems.DevLotNo);
            controlMapping.Add(PortFixMethod, dataItems.DevPortMethId);
            controlMapping.Add(ChkPrimPortRet, dataItems.PriPortRet);
            //If other Manu is not null then Manu is other
            if (!string.IsNullOrEmpty(dataItems.DevOthManuf))
            {
                controlMapping.Add(Manufacturer, "-1");
                controlMapping.Add(OtherManufacturer, dataItems.DevOthManuf);
                OtherManfacturerPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
            }
            else
            {
                OtherManfacturerPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                controlMapping.Add(Manufacturer, dataItems.DevManuf);
            }
        }
        #endregion

        #region Save
        /// <summary>
        /// saving data on click event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        protected void Submit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid == true)
            {
                bool formJustSaved = SaveData();
                if (formJustSaved)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "MyFunc1", "CloseWindow('saved');", true);
                }
            }
        }
        /// <summary>
        /// saving devices data related to patient Id
        /// </summary>
        /// <returns>save data flag</returns>
        protected bool SaveData()
        {
            Boolean returnValue = false;
            try
            {
                using (UnitOfWork deviceDetails = new UnitOfWork())
                {
                    SessionData sessionData = GetSessionData();
                    Boolean isNew = false;
                    tbl_PatientOperationDeviceDtls dataItems = deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Get(x => x.PatientOperationId == sessionData.PatientOperationId && x.PatientOperationDevId == sessionData.PatientOperationDeviceId).FirstOrDefault();
                    if (dataItems == null)
                    {
                        dataItems = new tbl_PatientOperationDeviceDtls();
                        isNew = true;
                    }
                    dataItems.PatientOperationId = sessionData.PatientOperationId;
                    dataItems.DevType = Helper.ToNullable<System.Int32>(DeviceType.SelectedValue);
                    dataItems.DevLotNo = SerialNoLotNo.Text;
                    if (OtherBrandName.Text.Trim() == "")
                    {
                        dataItems.DevBrand = Helper.ToNullable<System.Int32>(BrandName.SelectedValue);
                    }
                    else
                    {
                        dataItems.DevOthBrand = OtherBrandName.Text;
                    }
                    if (OtherModel.Text.Trim() == "")
                    {
                        dataItems.DevId = Helper.ToNullable<System.Int32>(Model.SelectedValue);
                    }
                    else
                    {
                        dataItems.DevOthMode = OtherModel.Text;
                    }
                    //
                    if (OtherManufacturer.Text.Trim() == "")
                    {
                        dataItems.DevManuf = Helper.ToNullable<System.Int32>(Manufacturer.SelectedValue);
                    }
                    else
                    {
                        dataItems.DevOthManuf = OtherManufacturer.Text;
                    }
                    //
                    dataItems.DevOthDesc = OtherDescription.Text;
                    if (DeviceType.SelectedValue == "3")
                    {
                        dataItems.ButtressId = Helper.ToNullable<System.Int32>(Buttress.SelectedValue);
                    }
                    else if (DeviceType.SelectedValue == "1" || DeviceType.SelectedValue == "0")
                    {
                        dataItems.DevPortMethId = Helper.ToNullable<System.Int32>(PortFixMethod.SelectedValue);
                        dataItems.PriPortRet = ChkPrimPortRet.Checked;
                    }
                    //dataItems.PriPortRet = Helper.ToNullable<System.Int32>(Model.SelectedValue);
                    //dataItems.ButtressId = Helper.ToNullable<System.Int32>(Model.SelectedValue);
                    if (isNew)
                    {
                        deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Insert(dataItems);
                    }
                    else
                    {
                        deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Update(dataItems);
                    }
                    //
                    deviceDetails.Save();
                    //

                    sessionData.PatientOperationDeviceId = dataItems.PatientOperationDevId;
                    SaveSessionData(sessionData);
                    //

                }
                //If device is access port and port fixation
                if ((DeviceType.SelectedValue == "1" || DeviceType.SelectedValue == "0") && PortFixMethod.SelectedValue == "1")
                {
                    SaveChildDevice();
                }
                else
                {
                    CheckIfChildExistsAndDelete();
                }


                returnValue = true;
                //BindDeviceGrid();
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "SurgeryDataValidationGroup");
                returnValue = false;
            }

            return returnValue;
        }

        /// <summary>
        /// saving child devices data related to patient Id
        /// </summary>
        /// <returns>child device flag</returns>
        protected bool SaveChildDevice()
        {
            Boolean returnValue = false;
            try
            {
                using (UnitOfWork deviceDetails = new UnitOfWork())
                {
                    SessionData sessionData = GetSessionData();
                    Boolean isNew = false;
                    tbl_PatientOperationDeviceDtls dataItems = deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Get(x => x.ParentPatientOperationDevId == sessionData.PatientOperationDeviceId).SingleOrDefault();
                    if (dataItems == null)
                    {
                        dataItems = new tbl_PatientOperationDeviceDtls();
                        isNew = true;
                    }
                    dataItems.PatientOperationId = sessionData.PatientOperationId;
                    dataItems.ParentPatientOperationDevId = sessionData.PatientOperationDeviceId;
                    dataItems.DevLotNo = PortFixSerialNoLotNo.Text;
                    //Defaulting to Port fixation
                    dataItems.DevType = Helper.ToNullable<System.Int32>(PortFixMethod.SelectedValue);
                    if (PortFixOtherBrandName.Text.Trim() == "")
                    {
                        dataItems.DevBrand = Helper.ToNullable<System.Int32>(PortFixBrandName.SelectedValue);
                    }
                    else
                    {
                        dataItems.DevOthBrand = PortFixOtherBrandName.Text;
                    }
                    //
                    if (PortFixOtherModel.Text.Trim() == "")
                    {
                        dataItems.DevId = Helper.ToNullable<System.Int32>(PortFixModel.SelectedValue);
                    }
                    else
                    {
                        dataItems.DevOthMode = PortFixOtherModel.Text;
                    }
                    //
                    if (PortFixOtherManufacturer.Text.Trim() == "")
                    {
                        dataItems.DevManuf = Helper.ToNullable<System.Int32>(PortFixManufacturer.SelectedValue);
                    }
                    else
                    {
                        dataItems.DevOthManuf = PortFixOtherManufacturer.Text;
                    }
                    //
                    dataItems.DevOthDesc = PortFixOtherDesc.Text;
                    if (isNew)
                    {
                        deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Insert(dataItems);
                    }
                    else
                    {
                        deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Update(dataItems);
                    }
                    //
                    deviceDetails.Save();
                }
                returnValue = true;
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "SurgeryDataValidationGroup");
                returnValue = false;
            }
            return returnValue;
        }
        /// <summary>
        /// checks if child exist or not
        /// </summary>
        /// <returns>if child Exists and Delete</returns>
        protected bool CheckIfChildExistsAndDelete()
        {
            Boolean returnValue = false;
            try
            {
                using (UnitOfWork deviceDetails = new UnitOfWork())
                {
                    SessionData sessionData = GetSessionData();
                    tbl_PatientOperationDeviceDtls dataItems = deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Get(x => x.ParentPatientOperationDevId == sessionData.PatientOperationDeviceId).SingleOrDefault();
                    if (dataItems != null)
                    {
                        deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Delete(dataItems);
                        deviceDetails.Save();
                    }
                }
                returnValue = true;
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "SurgeryDataValidationGroup");
                returnValue = false;
            }
            return returnValue;
        }

        #endregion

        #region ShowHidePanel
        //show or hides panel
        private void ShowHidePanel()
        {
            CDMSValidation.SetControlVisible(OtherBrandPanel, BrandName.SelectedValue == "-1");
            CDMSValidation.SetControlVisible(OtherDescPanel, Description.SelectedValue == "-1");
            CDMSValidation.SetControlVisible(OtherManfacturerPanel, Manufacturer.SelectedValue == "-1");
            CDMSValidation.SetControlVisible(OtherModelPanel, Model.SelectedValue == "-1");
            CDMSValidation.SetControlVisible(PortFixOtherModelPanel, PortFixModel.SelectedValue == "-1");
            CDMSValidation.SetControlVisible(PortFixManufacturerPanel, PortFixManufacturer.SelectedValue == "-1");
        }
        #endregion

        #region Mislleneous
        /// <summary>
        /// Displays buttons for Add devices Mode
        /// </summary>
        public void ShowButtonForAddMode()
        {
            contentHeader.Title = "Add Device";
            AddDevices.Visible = true;
            AddDevices.Enabled = true;
        }

        //Disabling Device controls
        private void DisableDeviceControls()
        {
            BrandName.Enabled = false;
            Manufacturer.Enabled = false;
            Description.Enabled = false;
            Model.Enabled = false;
            PortFixBrandName.Enabled = false;
            PortFixManufacturer.Enabled = false;
            PortFixDescription.Enabled = false;
            PortFixModel.Enabled = false;
        }

        /// <summary>
        /// Displays buttons for Edit devices Mode
        /// </summary>
        public void ShowButtonForEditMode()
        {
            contentHeader.Title = "Edit Device";
            AddDevices.Visible = false;
            AddDevices.Enabled = false;
        }

        /// <summary>
        /// clears messages and errors
        /// </summary>
        protected void ClearAllMessagesAndErrors()
        {
            NotifyMessage.Text = "";
            //blstDeviceErrorMsg.Items.Clear();
        }
        /// <summary>
        /// Display Messages
        /// </summary>
        /// <param name="message">message which is to be displayed</param>
        public void ShowMessage(string message)
        {

            NotifyMessage.ForeColor = System.Drawing.Color.Black;
            NotifyMessage.Text = message;

        }

        //clears Device Control
        private void ClearAllPrtDeviceControls()
        {
            PortFixBrandName.Items.Clear();
            PortFixDescription.Items.Clear();
            PortFixModel.Items.Clear();
            PortFixManufacturer.Items.Clear();
            PortFixSerialNoLotNo.Text = "";
            PortFixOtherBrandName.Text = "";
            PortFixOtherModel.Text = "";
            AccessPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
        }

        //show and hide child devices panel
        private void ShowHideChildDevice(string deviceTypeId)
        {
            //PortFixMethod.SelectedValue = "";
            //Access Port or Gastricband
            if (deviceTypeId == "1" || deviceTypeId == "0")
            {
                PrimaryPortPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                PortFixPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                ButtressPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            }
            //Stapling Device
            else if (deviceTypeId == "3")
            {
                ClearAllPrtDeviceControls();
                PrimaryPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                PortFixPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                ButtressPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
            }
            else
            {
                ClearAllPrtDeviceControls();
                PrimaryPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                PortFixPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                ButtressPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            }
        }
        #endregion


        #region selected Index change methods
        /// <summary>
        /// changing display on SelectedIndexChanged event of PortFixMethod 
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void PortFixMethod_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (PortFixMethod.SelectedValue == "1" || PortFixMethod.SelectedValue == "0")
            {
                AccessPortPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                LoadLookupDevicePortFix(true);
            }
            else
            {
                ClearAllPrtDeviceControls();
                AccessPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            }
        }

        /// <summary>
        /// it calls LoadDescManuFromBrand function on event change
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void PortFixBrandName_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            LoadDescManuFromBrand(PortFixBrandName.SelectedValue, PortFixOtherDescPanel, PortFixOtherModelPanel, PortFixOtherBrandPanel, PortFixOtherBrandName, PortFixOtherDesc, PortFixManufacturer, PortFixDescription, PortFixModel);
        }

        /// <summary>
        /// it calls LoadModelFromDesc function on event change
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>

        protected void PortFixDescription_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadModelFromDesc(PortFixDescription.SelectedValue, PortFixOtherDescPanel, PortFixOtherModelPanel, PortFixOtherDesc, PortFixModel);
        }

        //private void LoadPFModelFromDesc(string SelectedValue)
        //{
        //    using (UnitOfWork bl = new UnitOfWork())
        //    {
        //        if (SelectedValue != "")
        //        {
        //            //If description is not other then model cannot be other so dont add other option in dropdown
        //            if (SelectedValue != "-1")
        //                Helper.BindCollectionToControl(PortFixModel, bl.GetModelWithOther(true, SelectedValue, false), "Id", "Description");
        //            else
        //                Helper.BindCollectionToControl(PortFixModel, bl.GetModelWithOther(true, SelectedValue, true), "Id", "Description");
        //        }
        //        else
        //        {
        //            Helper.BindCollectionToControl(PortFixModel, bl.GetModelWithOther(true, null, false), "Id", "Description");
        //        }
        //    }
        //    if (SelectedValue == "-1")
        //        PortFixOtherDescPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
        //    else
        //    {
        //        PortFixOtherDescPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
        //        PortFixOtherDesc.Text = "";
        //    }
        //}

        /// <summary>
        /// it calls LoadBrandFromDevice  on event change
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void DeviceType_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            PortFixMethod.SelectedValue = "";
            LoadBrandFromDevice(DeviceType.SelectedValue);
            ShowHidePanel();
        }

        //loads brand from devices
        private void LoadBrandFromDevice(string selectedValue)
        {
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                if (selectedValue != "")
                {

                    Helper.BindCollectionToControl(BrandName, deviceDetails.GetBrandNamesWithOther(true, selectedValue), "Id", "Description");
                    BrandName.Enabled = true;
                    if (BrandName.Items.Count == 2)
                        BrandName.Items[1].Selected = true;
                    //
                    if (selectedValue == "6" && BrandName.Items[1] != null)
                    {
                        SerialNoLotNo.Text = "Existing Device";
                        BrandName.Items[1].Selected = true;
                        LoadDescManuFromBrand(BrandName.SelectedValue, OtherDescPanel, OtherModelPanel, OtherBrandPanel, OtherBrandName, OtherDescription, Manufacturer, Description, Model);
                    }
                    else
                        SerialNoLotNo.Text = "";
                }
                else
                {
                    BrandName.Enabled = false;
                    BrandName.Items.Clear();
                    //Helper.BindCollectionToControl(BrandName, bl.GetBrandNamesWithOther(true, null), "Id", "Description");
                }
            }
            if (selectedValue != "6")
            {
                Description.Items.Clear();
                Description.Enabled = false;
                Manufacturer.Items.Clear();
                Manufacturer.Enabled = false;
                Model.Items.Clear();
                Model.Enabled = false;
                ShowHideChildDevice(selectedValue);
            }
        }

        /// <summary>
        /// it calls LoadDescManuFromBrand function on event change
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void BrandName_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            LoadDescManuFromBrand(BrandName.SelectedValue, OtherDescPanel, OtherModelPanel, OtherBrandPanel, OtherBrandName, OtherDescription, Manufacturer, Description, Model);
        }

        //private void LoadPFDescManuFromBrand(string SelectedValue)
        //{
        //    using (UnitOfWork bl = new UnitOfWork())
        //    {
        //        if (SelectedValue != "")
        //        {
        //            Helper.BindCollectionToControl(PortFixDescription, bl.GetDeviceDescriptionWithOther(true, SelectedValue), "Id", "Description");
        //            if (SelectedValue == "-1")
        //                Helper.BindCollectionToControl(PortFixManufacturer, bl.GetManufacturersWithOther(true, null, true), "Id", "Description");
        //            else
        //                Helper.BindCollectionToControl(PortFixManufacturer, bl.GetManufacturersWithOther(true, SelectedValue, true), "Id", "Description");
        //        }
        //        else
        //        {
        //            Helper.BindCollectionToControl(PortFixDescription, bl.GetDeviceDescriptionWithOther(true, null), "Id", "Description");
        //            Helper.BindCollectionToControl(PortFixManufacturer, bl.GetManufacturersWithOther(true, null, false), "Id", "Description");
        //        }
        //        //
        //        PortFixModel.Items.Clear();
        //        //
        //        if (SelectedValue == "-1")
        //            PortFixOtherBrandPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
        //        else
        //        {
        //            PortFixOtherBrandPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
        //            PortFixOtherBrandName.Text = "";
        //        }
        //    }
        //}

        //Loads Device details
        private void LoadDescManuFromBrand(string selectedValue, Panel otherDescription, Panel otherModel, Panel otherBrand, TextBox otherBrandName, TextBox desription, RadComboBox manufacturerBox, RadComboBox desriptionBox, RadComboBox modelBox)
        {
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                otherDescription.Style.Add(HtmlTextWriterStyle.Display, "none");
                otherModel.Style.Add(HtmlTextWriterStyle.Display, "none");
                modelBox.Items.Clear();
                modelBox.Enabled = false;
                if (selectedValue != "")
                {
                    manufacturerBox.Enabled = true;
                    desriptionBox.Enabled = true;
                    Helper.BindCollectionToControl(desriptionBox, deviceDetails.GetDeviceDescriptionWithOther(true, selectedValue), "Id", "Description");
                    if (selectedValue == "-1")
                        Helper.BindCollectionToControl(manufacturerBox, deviceDetails.GetManufacturersWithOther(true, null, true), "Id", "Description");
                    else
                    {
                        Helper.BindCollectionToControl(manufacturerBox, deviceDetails.GetManufacturersWithOther(true, selectedValue, false), "Id", "Description");
                    }
                    if (manufacturerBox.Items.Count == 2)
                        manufacturerBox.Items[1].Selected = true;
                    if (desriptionBox.Items.Count == 2)
                    {
                        desriptionBox.Items[1].Selected = true;
                        if (selectedValue == "-1")
                        {
                            otherDescription.Style.Add(HtmlTextWriterStyle.Display, "block");

                        }
                        LoadModelFromDesc(desriptionBox.SelectedValue, otherDescription, otherModel, desription, modelBox);
                    }
                    if (DeviceType.SelectedValue == "6" && desriptionBox.Items[1] != null)
                    {
                        desriptionBox.Items[1].Selected = true;
                        LoadModelFromDesc(desriptionBox.SelectedValue, otherDescription, otherModel, desription, modelBox);
                    }

                }
                else
                {
                    manufacturerBox.Enabled = false;
                    desriptionBox.Enabled = false;
                    desriptionBox.Items.Clear();
                    desriptionBox.Items.Clear();
                    modelBox.Items.Clear();
                    //Helper.BindCollectionToControl(p_rdDesc, bl.GetDeviceDescriptionWithOther(true, null), "Id", "Description");
                    //Helper.BindCollectionToControl(rdManu, bl.GetManufacturersWithOther(true, null, false), "Id", "Description");
                }

            }
            if (selectedValue == "-1")
            {
                otherBrand.Style.Add(HtmlTextWriterStyle.Display, "block");
            }
            else
            {
                otherBrand.Style.Add(HtmlTextWriterStyle.Display, "none");
                otherBrandName.Text = "";
            }
        }

        /// <summary>
        /// it call LoadModelFromDesc function on event change
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void Description_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            LoadModelFromDesc(Description.SelectedValue, OtherDescPanel, OtherModelPanel, OtherDescription, Model);
        }
        //Loads  device model details
        private void LoadModelFromDesc(string selectedValue, Panel otherDescription, Panel otherModel, TextBox otherDesc, RadComboBox modelBox)
        {
            using (UnitOfWork modelDetails = new UnitOfWork())
            {
                otherModel.Style.Add(HtmlTextWriterStyle.Display, "none");
                if (selectedValue != "")
                {
                    modelBox.Enabled = true;
                    //If description is not other then model cannot be other so dont add other option in dropdown
                    if (selectedValue != "-1")
                        Helper.BindCollectionToControl(modelBox, modelDetails.GetModelWithOther(true, selectedValue, false), "Id", "Description");
                    else
                        Helper.BindCollectionToControl(modelBox, modelDetails.GetModelWithOther(true, selectedValue, true), "Id", "Description");
                    if (modelBox.Items.Count == 2)
                    {
                        modelBox.Items[1].Selected = true;
                        if (selectedValue == "-1")
                            otherModel.Style.Add(HtmlTextWriterStyle.Display, "block");
                    }
                }
                else
                {
                    modelBox.Enabled = false;
                    modelBox.Items.Clear();
                    //Helper.BindCollectionToControl(p_rdModel, bl.GetModelWithOther(true, null, true), "Id", "Description");
                }

            }
            if (selectedValue == "-1")
            {
                otherDescription.Style.Add(HtmlTextWriterStyle.Display, "block");
            }
            else
            {
                otherDescription.Style.Add(HtmlTextWriterStyle.Display, "none");
                otherDesc.Text = "";
            }
        }
        #endregion

        #region Custom Validation methods

        /// <summary>
        /// Device type server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void DeviceType_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (DeviceType.SelectedValue == "")
                args.IsValid = false;
            else
                args.IsValid = true;
        }

        /// <summary>
        /// BrandName server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void BrandName_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (BrandName.SelectedValue == "")
                args.IsValid = false;
            else
                args.IsValid = true;
        }

        /// <summary>
        /// Description server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void Desc_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (Description.SelectedValue == "")
                args.IsValid = false;
            else
                args.IsValid = true;
        }

        /// <summary>
        /// Model server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void Model_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (Model.SelectedValue == "")
                args.IsValid = false;
            else
                args.IsValid = true;
        }

        /// <summary>
        /// Manufacturer server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void Manufacturer_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (Manufacturer.SelectedValue == "")
                args.IsValid = false;
            else
                args.IsValid = true;
        }

        /// <summary>
        /// SerialNoLotNo server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void SerialLot_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (SerialNoLotNo.Text.Trim() == "")
                args.IsValid = false;
            else
                args.IsValid = true;
        }


        /// <summary>
        /// BrandName server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
       protected void OtherBrandName_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (BrandName.SelectedValue == "-1" && OtherBrandName.Text.Trim() == "")
                args.IsValid = false;
            else
                args.IsValid = true;
        }


       /// <summary>
       /// Model server validation
       /// </summary>
       /// <param name="source">object points to original control</param>
       /// <param name="args">Provides data for the ServerValidate event </param>

        protected void OtherModel_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (Model.SelectedValue == "-1" && OtherModel.Text.Trim() == "")
                args.IsValid = false;
            else
                args.IsValid = true;
        }

        /// <summary>
        /// Buttress server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>

        protected void Butress_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (DeviceType.SelectedValue == "3")
            {
                if (Buttress.SelectedValue == "")
                    args.IsValid = false;
                else
                    args.IsValid = true;
            }
        }

        /// <summary>
        /// PortFixMethod server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void PrtFixMethod_ServerValidate(object source, ServerValidateEventArgs args)
        {
            //if (DeviceType.SelectedValue == "1")
            //{
            //    if (PortFixMethod.SelectedValue == "")
            //        args.IsValid = false;
            //    else
            //        args.IsValid = true;
            //}
        }

        /// <summary>
        /// DPortFixBrandName server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void PFBrandName_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if ((DeviceType.SelectedValue == "1" || DeviceType.SelectedValue == "0") && PortFixMethod.SelectedValue == "1")
            {
                if (PortFixBrandName.SelectedValue == "")
                    args.IsValid = false;
                else
                    args.IsValid = true;
            }
        }

        /// <summary>
        /// PortFixBrandName server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void PFOtherBrandName_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if ((DeviceType.SelectedValue == "1" || DeviceType.SelectedValue == "0") && PortFixMethod.SelectedValue == "1")
            {
                if (PortFixBrandName.SelectedValue == "-1" && PortFixOtherBrandName.Text.Trim() == "")
                    args.IsValid = false;
                else
                    args.IsValid = true;
            }
        }

        /// <summary>
        /// PortFixDescription server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void PFDesc_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if ((DeviceType.SelectedValue == "1" || DeviceType.SelectedValue == "0") && PortFixMethod.SelectedValue == "1")
            {
                if (PortFixDescription.SelectedValue == "")
                    args.IsValid = false;
                else
                    args.IsValid = true;
            }
        }

        /// <summary>
        /// PortFixModel server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void PFModel_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if ((DeviceType.SelectedValue == "1" || DeviceType.SelectedValue == "0") && PortFixMethod.SelectedValue == "1")
            {
                if (PortFixModel.SelectedValue == "")
                    args.IsValid = false;
                else
                    args.IsValid = true;
            }
        }

        /// <summary>
        /// PortFixModel server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void PFOtherModel_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if ((DeviceType.SelectedValue == "1" || DeviceType.SelectedValue == "0") && PortFixMethod.SelectedValue == "1")
            {
                if (PortFixModel.SelectedValue == "-1" && PortFixOtherModel.Text.Trim() == "")
                    args.IsValid = false;
                else
                    args.IsValid = true;
            }
        }

        /// <summary>
        /// PortFixManufacturer server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void PFManufacturer_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if ((DeviceType.SelectedValue == "1" || DeviceType.SelectedValue == "0") && PortFixMethod.SelectedValue == "1")
            {
                if (PortFixManufacturer.SelectedValue == "")
                    args.IsValid = false;
                else
                    args.IsValid = true;
            }
        }

        /// <summary>
        /// PortFixSerialNoLotNo server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void PFSerialNoLotNo_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if ((DeviceType.SelectedValue == "1" || DeviceType.SelectedValue == "0") && PortFixMethod.SelectedValue == "1")
            {
                if (PortFixSerialNoLotNo.Text.Trim() == "")
                    args.IsValid = false;
                else
                    args.IsValid = true;
            }
        }

        /// <summary>
        /// PortFixDescription server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void PFDescOther_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if ((DeviceType.SelectedValue == "1" || DeviceType.SelectedValue == "0") && PortFixMethod.SelectedValue == "1")
            {
                if (PortFixDescription.SelectedValue == "-1" && PortFixOtherDesc.Text.Trim() == "")
                    args.IsValid = false;
                else
                    args.IsValid = true;
            }
        }

        /// <summary>
        /// OtherManufacturer server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void PFOtherManufacturer_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if ((DeviceType.SelectedValue == "1" || DeviceType.SelectedValue == "0") && PortFixMethod.SelectedValue == "1")
            {
                if (PortFixManufacturer.SelectedValue == "-1" && PortFixOtherManufacturer.Text.Trim() == "")
                    args.IsValid = false;
                else
                    args.IsValid = true;
            }
        }


        /// <summary>
        /// OtherDescription server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>

        protected void OtherDesc_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (Description.SelectedValue == "-1" && OtherDescription.Text.Trim() == "")
            {
                cvOtherDesc.ErrorMessage = "Other Description is a required field";
                args.IsValid = false;
            }
            else
                args.IsValid = true;
        }

        /// <summary>
        /// OtherManufacturer server validation
        /// </summary>
        /// <param name="source">object points to original control</param>
        /// <param name="args">Provides data for the ServerValidate event </param>
        protected void OtherManufacturer_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (Manufacturer.SelectedValue == "-1" && OtherManufacturer.Text.Trim() == "")
                args.IsValid = false;
            else
                args.IsValid = true;
        }

        //protected void cvserlotnum_ServerValidate(object source, ServerValidateEventArgs args)
        //{
        //    if (SerialNoLotNo.Text == "")
        //        args.IsValid = false;
        //    else
        //        args.IsValid = true;
        //}

        #endregion

    }
}
