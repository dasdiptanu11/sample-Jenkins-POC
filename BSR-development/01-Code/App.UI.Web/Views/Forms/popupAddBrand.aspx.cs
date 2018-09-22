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
    public partial class popupAddBrand : BasePage
    {
        #region "Loading page and lookUps"
        /// <summary>
        /// Loads Add Brand screen and set focus on Device Type DropDown list
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLookUp();
                DeviceType.Focus();
            }
        }

        /// <summary>
        /// Loads Device Type
        /// </summary>
        public void LoadLookUp()
        {
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                Helper.BindCollectionToControl(DeviceType, deviceDetails.Get_tlkp_DeviceType(true), "Id", "Description");
                Helper.BindCollectionToControl(Manufacturer, deviceDetails.Get_DeviceManufacturersWithActiveFlagSet(true), "Id", "Description");
            }
        }

        #endregion "Loading page and lookUps"
        /// <summary>
        /// Saves Device Brand details to DB
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Add_Click(object sender, EventArgs e)
        {

            ClearAllMessagesAndErrors();
            SessionData sessionData = GetSessionData();

            bool insert = false;
            tbl_DeviceBrand items;
            int manufacturerId = Manufacturer.SelectedItem == null ? -1 : Convert.ToInt32(Manufacturer.SelectedItem.Value);
            int typeId = DeviceType.SelectedItem == null ? -1 : Convert.ToInt32(DeviceType.SelectedItem.Value);

            if (Page.IsValid == true)
            {

                using (UnitOfWork DeviceDetails = new UnitOfWork())
                {
                    items = DeviceDetails.tbl_DeviceBrandRepository.Get().Where(x => (x.Description.ToString().ToUpper().Trim() == BrandName.Text.Trim().ToUpper() && x.TypeID == typeId)).FirstOrDefault();
                    if (items == null)
                    {
                        insert = true;
                    }
                    else
                    {
                        insert = false;
                    }
                }

                if (insert == true)
                {
                    using (UnitOfWork deviceDetails = new UnitOfWork())
                    {
                        tbl_DeviceBrand deviceBrandTable = new tbl_DeviceBrand();
                        deviceBrandTable.TypeID = Helper.ToNullable<System.Int32>(DeviceType.SelectedValue);
                        deviceBrandTable.Description = BrandName.Text.Trim();
                        deviceBrandTable.ManufacturerId = Helper.ToNullable<System.Int32>(Manufacturer.SelectedValue);
                        deviceBrandTable.IsActive = 1;
                        deviceBrandTable.CreateBy = UserName;
                        deviceBrandTable.CreateDateTime = DateTime.Now;
                        deviceDetails.tbl_DeviceBrandRepository.Insert(deviceBrandTable);
                        deviceDetails.Save();
                        sessionData.AddedSuccessMessage = "Brand '" + BrandName.Text.TrimEnd() + "' added";
                        SaveSessionData(sessionData);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "MyFunc1", "CloseWindow('add');", true);
                    }
                    UpdateUnknowDeviceList(BrandName.Text);
                }
                else
                {
                    ShowError("Brand exists in catalog");
                    BrandName.Focus();
                }

            }
        }
        /// <summary>
        /// Add new brand Devices
        /// </summary>
        /// <param name="newBrand">Device Brand Name</param>
        public void UpdateUnknowDeviceList(string newBrand)
        {
            IEnumerable<tbl_PatientOperationDeviceDtls> devicesWithUnknownBrand = null;
            tbl_DeviceBrand brandDetails = new tbl_DeviceBrand();
            try
            {
                using (UnitOfWork deviceDetails = new UnitOfWork())
                {
                    brandDetails = deviceDetails.tbl_DeviceBrandRepository.Get(x => x.Description == newBrand).FirstOrDefault();

                    devicesWithUnknownBrand = deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Get(x => x.DevOthBrand == newBrand);
                    foreach (tbl_PatientOperationDeviceDtls unknownDevice in devicesWithUnknownBrand)
                    {
                        unknownDevice.DevOthBrand = "";
                        unknownDevice.DevBrand = brandDetails.Id;
                        deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Update(unknownDevice);
                        deviceDetails.Save();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError(ex.Message);
            }
        }

        #region "Display Errors/Messages"
        /// <summary>
        /// Clears all messages and errors
        /// </summary>
        protected void ClearAllMessagesAndErrors()
        {
            NotifyMessage.Text = "";
        }
        /// <summary>
        /// shows error message
        /// </summary>
        /// <param name="errorMessage">message</param>
        public void ShowError(string errorMessage)
        {
            DisplayCustomMessageInValidationSummary(errorMessage, "BrandDataValidationGroup");
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
            form1.Controls.Add(customValidatorControl);
        }
        /// <summary>
        /// Display general messages
        /// </summary>
        /// <param name="message">Message</param>
        public void ShowMessage(string message)
        {
            NotifyMessage.ForeColor = System.Drawing.Color.Black;
            NotifyMessage.Text = message;
        }

        #endregion "Display Errors/Messages"

    }
}