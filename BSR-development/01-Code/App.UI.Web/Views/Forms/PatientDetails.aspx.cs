using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.UI.Web.Views.Shared;
using Telerik.Web.UI;
using App.Business;
using eis = Telerik.Web.UI.ExportInfrastructure;

namespace App.UI.Web.Views.Forms
{
    public partial class PatientDetails : BasePage
    {
        /// <summary>
        /// Get the Patient details from database and display on the screen
        /// </summary>
        /// <param name="sender">Page as the sender of the event</param>
        /// <param name="e">Event Argument</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetPatientDetails();
            }
        }

        #region SettingUpInitialData
        /// <summary>
        /// Toggeling visibility for the controls dependent on the country
        /// </summary>
        /// <param name="countryCode">Country Code</param>
        public void HideAndShowDetailsForCountry(int countryCode)
        {
            if (countryCode == Constants.COUNTRY_CODE_FOR_AUSTRALIA)
            {
                PatientPostcodeAndStatePanel.Visible = true;
            }
            else
            {
                PatientPostcodeAndStatePanel.Visible = false;
            }
        }

        /// Get and display patient details from data store
        private void GetPatientDetails()
        {
            SessionData sessionData = GetSessionData();
            int patientId = sessionData.PatientId;
            int countryId;
            Dictionary<System.Web.UI.Control, Object> controlMapping = new Dictionary<System.Web.UI.Control, Object>();
            tbl_Patient patient;

            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                patient = patientRepository.tbl_PatientRepository.Get(x => x.PatId == patientId, null, "tlkp_HealthStatus, tlkp_Country, tlkp_State, tlkp_Gender").FirstOrDefault();
            }

            if (patient != null)
            {
                // Mapping controls with their values
                controlMapping.Add(PatientAddress, patient.Addr);
                controlMapping.Add(PatientAddressSuburb, patient.Sub);
                controlMapping.Add(PatientState, patient.StateId == null ? string.Empty : patient.tlkp_State.Description);
                controlMapping.Add(PatientCountry, patient.CountryId == null ? string.Empty : patient.tlkp_Country.Description);
                controlMapping.Add(PatientPostCode, patient.Pcode);
                controlMapping.Add(PatientHomePhone, patient.HomePh);
                controlMapping.Add(PatientMobile, patient.MobPh);
                controlMapping.Add(PatientVitalStatus, patient.HStatId == null ? string.Empty : patient.tlkp_HealthStatus.Description);

                // Fill the value to the control to display on the page
                PopulateControl(controlMapping);
                countryId = (int)(patient.CountryId == null ? Constants.COUNTRY_CODE_FOR_AUSTRALIA : patient.CountryId);
                HideAndShowDetailsForCountry(countryId);
            }
        }

        // Get Operations details for the patient and show it in the grid
        private void LoadOperationGrid()
        {
            SessionData sessionData = GetSessionData();
            int patientId = sessionData.PatientId;
            IEnumerable<PatientOperationListItem> patientOperationDetails;

            using (UnitOfWork operationRepository = new UnitOfWork())
            {
                //Patient details will be shown only for Admins so always passing Null
                patientOperationDetails = operationRepository.OperationRepository.GetOperationDetailsForPatientID(patientId, null);
                OperationGrid.DataSource = patientOperationDetails;
                LoadPatientSummaryAndFollowUpDetails(patientOperationDetails);
            }
        }

        // Display Patient summary and Followup details 
        private void LoadPatientSummaryAndFollowUpDetails(IEnumerable<PatientOperationListItem> patientOperationDetails)
        {
            SessionData sessionData = GetSessionData();
            int patientId = sessionData.PatientId;
            FollowUpDetails lastFollowUpForPrimary = new FollowUpDetails();
            tbl_Patient patientLTFU = new tbl_Patient();
            Dictionary<System.Web.UI.Control, Object> controlMapping = new Dictionary<System.Web.UI.Control, Object>();
            decimal height = 0;
            decimal startingWeight = 0;
            decimal operationWeight = 0;
            decimal initialWeight = 0;
            decimal initialBMI = 0;
            int primaryOperationId = -1;
            PatientSummary.Visible = true;

            if (patientOperationDetails.Count() > 0)
            {
                PatientOperationListItem primaryOperation = patientOperationDetails
                                                                .Where(x => x.OperationStat == 0 && (x.ProcAban == null || x.ProcAban == false))
                                                                .FirstOrDefault();

                if (primaryOperation != null)
                {
                    operationWeight = primaryOperation.OperationWeight == null ? 0 : (decimal)primaryOperation.OperationWeight;
                    startingWeight = primaryOperation.StartWeight == null ? 0 : (decimal)primaryOperation.StartWeight;
                    height = primaryOperation.Height == null ? 0 : (decimal)primaryOperation.Height;
                    primaryOperationId = primaryOperation.PatientOperationId;
                }
                else
                {
                    operationWeight = 0;
                    startingWeight = 0;
                    height = 0;
                    primaryOperationId = 0;
                }

                Height.Text = height.ToString();
                StartWeight.Text = startingWeight == 0 ? operationWeight.ToString() : startingWeight.ToString();

                initialWeight = startingWeight == 0 ? operationWeight : (startingWeight > operationWeight ? startingWeight : operationWeight);
                initialBMI = CalculateBodyMassIndex(initialWeight, height);

                InitialWeight.Text = initialWeight == 0 ? string.Empty : initialWeight.ToString();
                InitialBMI.Text = initialBMI == 0 ? string.Empty : initialBMI.ToString();

                using (UnitOfWork followUpRepository = new UnitOfWork())
                {
                    lastFollowUpForPrimary = followUpRepository.FollowUpRepository.GetPatientFollowUpAndOperationDetails(patientId, primaryOperationId);
                    patientLTFU = followUpRepository.tbl_PatientRepository.GetByID(patientId);
                }

                if (patientLTFU != null)
                {
                    PatientLossToFollowUp.Text = patientLTFU.OptOffStatId == null ? string.Empty : (patientLTFU.OptOffStatId == 4 ? "Yes" : "No");
                }
                else
                {
                    PatientLossToFollowUp.Text = null;
                }

                if (lastFollowUpForPrimary != null && lastFollowUpForPrimary.FollowUpDate != null)
                {
                    decimal folloupWeight = lastFollowUpForPrimary.FollowUpWieght == null ? 0 : (decimal)lastFollowUpForPrimary.FollowUpWieght;
                    if (folloupWeight > 0 && height > 0)
                    {
                        PatientFollowUpSummary.Visible = true;
                        decimal followupBMI = CalculateBodyMassIndex(folloupWeight, height);
                        decimal patientEwl = CalculateExcessWeightLoss(initialWeight, height, folloupWeight);
                        PatientSummaryLabel.Text = "Patient Summary At " + lastFollowUpForPrimary.FollowUpPeriodDescrition + " Follow Up";
                        FollowupDate.Text = "Date of Follow Up " + string.Format("{0:dd/MM/yyyy}", lastFollowUpForPrimary.FollowUpDate);
                        PatientFollowUpSummary.Visible = true;
                        controlMapping.Add(PatientFollowUpWeight, lastFollowUpForPrimary.FollowUpWieght);
                        controlMapping.Add(PatientFollowUpBMI, followupBMI == 0 ? string.Empty : followupBMI.ToString());
                        controlMapping.Add(PatientWeightLoss, lastFollowUpForPrimary.FollowUpWieght == 0 || initialWeight == 0 ? string.Empty : (initialWeight - lastFollowUpForPrimary.FollowUpWieght).ToString());
                        controlMapping.Add(PatientBMIChange, initialBMI == 0 || followupBMI == 0 ? string.Empty : (initialBMI - followupBMI).ToString());
                        PatientPercentEWLLabel.Text = "% EWL";
                        controlMapping.Add(PatientEWLPercent, patientEwl == 0 ? string.Empty : patientEwl.ToString());
                        PopulateControl(controlMapping);
                    }
                    else
                    {
                        PatientFollowUpSummary.Visible = false;
                    }
                }
                else
                {
                    PatientSummaryLabel.Text = "Patient Summary";
                    FollowupDate.Text = string.Empty;
                    PatientFollowUpSummary.Visible = false;
                }
            }
            else
            {
                PatientSummary.Visible = false;
                InitialBMI.Text = string.Empty;
                InitialWeight.Text = string.Empty;
            }
        }
        #endregion SettingUpInitialData

        #region FuncToManageOperationGrid
        /// <summary>
        /// Load Operation data for the Patient
        /// </summary>
        /// <param name="source">Operation Grid as a source</param>
        /// <param name="e">Grid Data Source Event Handler</param>
        protected void OperationGrid_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
        {
            OperationGrid.ExportSettings.FileName += DateTime.Now.ToString();
            LoadOperationGrid();
        }

        /// <summary>
        /// Handling command buttons of the Operation Grid
        /// </summary>
        /// <param name="sender">Operation Grid as a sender</param>
        /// <param name="e">Grid Command Event Arguments</param>
        protected void OperationGrid_ItemCommand(object sender, GridCommandEventArgs e)
        {
            try
            {
                RadGrid operationGrid = (RadGrid)sender;
                SessionData sessionData = GetSessionData();
                GridEditableItem editedItem = e.Item as GridEditableItem;

                switch (e.CommandName)
                {
                    case "EditOperation":
                        sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientOperationId"]);
                        SaveSessionData(sessionData);
                        Response.Redirect(Properties.Resource2.OperationDetailsPath + "?LoadOperationDetails=1", false);
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
        #endregion FuncForOperationGrid

        /// <summary>
        /// Calculate Excess Weight Loss
        /// </summary>
        /// <param name="initialWeight">Initial Weight of the Patient</param>
        /// <param name="height">Height of the Patient</param>
        /// <param name="currentWeight">Current Weight of the Patient</param>
        /// <returns>Excess Weight Percent</returns>
        public decimal CalculateExcessWeightLoss(decimal initialWeight, decimal height, decimal currentWeight)
        {
            decimal excessWeightLossPercent = 0;
            if (initialWeight == 0 || height == 0 || currentWeight == 0)
            {
                excessWeightLossPercent = 0;
            }
            else
            {
                decimal excessWeight = initialWeight - 25 * (height * height);
                excessWeightLossPercent = excessWeight == 0 ? 0 : (initialWeight - currentWeight) / excessWeight * 100;
            }

            return Math.Round(excessWeightLossPercent, 2);
        }

        /// <summary>
        /// Calculate Body Mass Index
        /// </summary>
        /// <param name="patientWeight">Weight of the Patient</param>
        /// <param name="patientHeight">Height of the Patient</param>
        /// <returns>Returns Body Mass Index value for the Patient</returns>
        public decimal CalculateBodyMassIndex(decimal? patientWeight, decimal? patientHeight)
        {
            decimal height = patientHeight == null ? 0 : (decimal)patientHeight;
            decimal weight = patientWeight == null ? 0 : (decimal)patientWeight;
            if (height == 0)
            { return 0; }
            else
            { return Math.Round((weight / (height * height)), 1); }
        }

        /// <summary>
        /// Redirecting to previous page
        /// </summary>
        /// <param name="sender">Back Button as a sender</param>
        /// <param name="e">Event Argument</param>
        protected void BackButtonClicked(object sender, EventArgs e)
        {
            if (IsSurgeon || IsDataCollector)
            {
                Response.Redirect(Properties.Resource2.SurgeonHome);
            }
            else
            {
                Response.Redirect(Properties.Resource2.PatientSearchPath);
            }
        }
    }
}
