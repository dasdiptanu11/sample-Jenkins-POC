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
    public partial class popupAddManufacturer : BasePage
    {
        /// <summary>
        /// Loads Add Manufacturer screen
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Manufacturer.Focus();
            }
        }
        /// <summary>
        /// Add new Manufacturer Details
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Add_Click(object sender, EventArgs e)
        {
            bool insert = false;
            List<LookupItem> items;

            ClearAllMessagesAndErrors();
            if (Page.IsValid == true)
            {

                using (UnitOfWork deviceDetails = new UnitOfWork())
                {
                    SessionData sessionData = GetSessionData();
                    items = deviceDetails.GetDeviceManufacturerForGivenDescription(Manufacturer.Text.Trim());
                    if (items == null)
                    {
                        insert = true;
                    }
                    else if (items.Count == 0)
                    {
                        insert = true;
                    }

                    if (insert == true)
                    {
                        tlkp_DeviceManufacturer deviceManufacturerTable = new tlkp_DeviceManufacturer();
                        deviceManufacturerTable.Description = Manufacturer.Text.Trim();
                        deviceManufacturerTable.IsActive = 1;
                        deviceDetails.tlkp_DeviceManufacturerRepository.Insert(deviceManufacturerTable);
                        deviceDetails.Save();
                        sessionData.AddedSuccessMessage = "Manufactuer '" + Manufacturer.Text.TrimEnd() + "' added";
                        SaveSessionData(sessionData);
                        UpdateUnknowDeviceList(Manufacturer.Text);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "MyFunc1", "CloseWindow('add');", true);
                    }
                    else
                    {
                        ShowError("Manufacturer exists in catalog");
                        Manufacturer.Focus();
                    }


                }
            }
        }

        /// <summary>
        /// Add new Manufacturer Details
        /// </summary>
        /// <param name="NewBrand">Manufacturer Name</param>
        public void UpdateUnknowDeviceList(string newManufacturer)
        {
            IEnumerable<tbl_PatientOperationDeviceDtls> devicesWithUnknownManufacturer = null;
            tlkp_DeviceManufacturer manufacturerDetails = new tlkp_DeviceManufacturer();
            newManufacturer = newManufacturer.ToString().ToUpper().Trim();

            try
            {
                using (UnitOfWork deviceDetails = new UnitOfWork())
                {
                    manufacturerDetails = deviceDetails.tlkp_DeviceManufacturerRepository.Get(x => x.Description.ToUpper().Trim() == newManufacturer).FirstOrDefault();

                    devicesWithUnknownManufacturer = deviceDetails.tbl_PatientOperationDeviceDtlsRepository.Get(x => x.DevOthManuf.ToUpper().Trim() == newManufacturer);
                    foreach (tbl_PatientOperationDeviceDtls unknownDevice in devicesWithUnknownManufacturer)
                    {
                        unknownDevice.DevOthManuf = "";
                        unknownDevice.DevManuf = manufacturerDetails.Id;
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


        #region "Display Error/Messages"

        protected void ClearAllMessagesAndErrors()
        {
            NotifyMessage.Text = "";
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
        /// <summary>
        /// shows error message
        /// </summary>
        /// <param name="errorMessage">message</param>
        public void ShowError(string errorMessage)
        {
            DisplayCustomMessageInValidationSummary(errorMessage, "ManufacturerValidationGroup");
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

        #endregion "Display Error/Messages"

    }
}