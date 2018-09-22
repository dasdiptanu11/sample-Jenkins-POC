using App.Business;
using App.UI.Web.Views.Shared;
using CDMSValidationLogic;
using System;
using System.Collections.Generic;
using System.Data.Objects.SqlClient;
using System.Linq;
using System.Reflection;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace App.UI.Web.Views.Forms
{
    public partial class OperationDetails : BasePage
    {
        // Flag that determines whether form has been saved
        private Boolean _formSaved;

        // Flag to determines whether operation is primary operation
        private static Boolean _hasPrimary;

        // Gets or sets Primary Operation Id
        private static int _primaryOperationId;

        // Gets or sets Flag to determine whether user has added new device for operation
        private static Boolean _isAdded;

        // Gets or sets flag to determinw whether procedure has been abandoned
        private static Boolean? _isProcedureAbandoned;

        // Gets or sets Date of the Primary Operation
        private static DateTime? _dateOfPrimaryOperation;

        // Gets or sets Patient's Height while primary operation
        private static decimal? _primaryHeight;

        // Gets or sets flag to determine whether ReOperation or Sentinel event is selected
        bool _isSelected = false;

        // Gets or sets flag to determine whether Reason is selected or not
        bool _isFollowUpReasonSelected = false;

        // Gets or sets flag to determine whether Other Reason is selected
        bool _isOtherReasonSelected = false;

        // flag to determine whether Bowel Obstruction - operative is selected
        bool _isOperativeBowelObstructSelected = false;

        // Gets or sets flag to determine whether Prolapse or Slip is selected
        bool _isProlapseOrSlipSelected = false;

        // Gets or sets flag to determine whether Port is selected or not
        bool _isPortSelected = false;

        // Gets or sets Session Data to store the data and use it in multiple pages
        SessionData _sessionData;

        /// <summary>
        /// Initializing all controls
        /// </summary>
        /// <param name="sender">Operation Details page as sender</param>
        /// <param name="e">Event Argument</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            _sessionData = GetSessionData();
            if (_sessionData.SiteId == 0) { _sessionData = new SessionData(); }

            if (_sessionData.PatientId == 0) { Response.Redirect(Properties.Resource2.PatientSearchPath, false); }
            else
            {
                TurnTextBoxAutoCompleteOff();
                OperationDate.MaxDate = DateTime.Now;
                if (!Page.IsPostBack)
                {
                    OperationGrid.DataBind();
                    _hasPrimary = false;
                    _isProcedureAbandoned = null;
                    _dateOfPrimaryOperation = null;
                    _primaryOperationId = 0;
                    _primaryHeight = null;
                    _isAdded = false;

                    if (_sessionData.PatientOperationId == null || _sessionData.PatientOperationId == -1 || _sessionData.PatientOperationId == 0) { SetDefaultSite(); }

                    if (_sessionData.PatientId != null && _sessionData.PatientId > 0)
                    {
                        using (UnitOfWork patientRepository = new UnitOfWork())
                        {
                            tbl_Patient patient = patientRepository.tbl_PatientRepository.GetByID(_sessionData.PatientId);
                            if (patient.DOB != null)
                            {
                                ViewState.Add("ptDOBMonth", patient.DOB.Value.Month);
                                ViewState.Add("ptDOBYear", patient.DOB.Value.Year);
                            }
                        }
                    }
                }

                AdminSurgeonFeatures();
                ShowHidePanel();
                BindDeviceGrid();
                InitSurgeonSiteList();
                if (IsPostBack)
                {
                    ShowHideBasedOnOpStat(OperationStatus.SelectedValue);
                    ShowProcedurePanels(OperationStatus.SelectedValue);
                }

                PrimaryProcedure.Attributes.Add("onclick", "ShowOtherPrim()");
                SecondaryProcedure.Attributes.Add("onclick", "ShowOtherSec()");
                WarningLabel.Text = string.Empty;

                PatientHeight.Attributes.Add("onchange", "CheckIfOutOfRange('" + PatientHeight.ClientID + "')");
                HeightUnknown.Attributes.Add("onclick", "EnableDisable('" + PatientHeight.ClientID + "','" + HeightUnknown.ClientID + "')");
                PatientStartWeight.Attributes.Add("onchange", "CalculateBMI('" + PatientStartWeight.ClientID + "','" + PatientStartBMI.ClientID + "','" + StartWeightWarning.ClientID + "','" + StartBMIWarning.ClientID + "')");
                PatientStartWeightUnknown.Attributes.Add("onclick", "EnableDisableStWt('" + PatientStartWeight.ClientID + "','" + PatientStartWeightUnknown.ClientID + "','" + SameAsOperationWeight.ClientID + "','" + PatientStartBMI.ClientID + "')");
                PatientWeight.Attributes.Add("onchange", "CalculateBMI('" + PatientWeight.ClientID + "','" + OperationBMI.ClientID + "','" + OperationWeightWarning.ClientID + "','" + OperationBMIWarning.ClientID + "')");
                PatientWeightUnknown.Attributes.Add("onclick", "EnableDisableOpWtNotKnown('" + PatientWeight.ClientID + "','" + PatientWeightUnknown.ClientID + "','" + SameAsOperationWeight.ClientID + "','" + PatientStartBMI.ClientID + "','" + OperationBMI.ClientID + "')");
                SameAsOperationWeight.Attributes.Add("onclick", "EnableDisableOpWt('" + SameAsOperationWeight.ClientID + "','" + PatientWeightUnknown.ClientID + "','" + PatientStartWeightUnknown.ClientID + "')");
                AddDeviceButton.Attributes.Add("onclick", "genericPopup('popupAddDeviceOperations.aspx','500','500','Add Device','A')");
                LastFollowupReason.Attributes.Add("onclick", "ReasonCheckBoxHandler()");

                ShowingFormSavedMessage();
                //Will come only from admin related forms like fup worklist ,pt details etc
                if (Request.QueryString["LoadOperationDetails"] != null)
                {
                    LoadSelectedOperation();
                    ClearQueryString();
                }

                //Comes from surgeon login
                if (!IsPostBack && _sessionData.OperationType == Constants.ADD_REVISION || _sessionData.OperationType == Constants.ADD_PRIMARY)
                {
                    AddOperations();
                    _sessionData.OperationType = null;
                    AddOperationButton.Visible = false;
                }
            }
        }

        /// <summary>
        /// Load Reason in the dropdown control from database
        /// </summary>
        /// <param name="procedureId">Procedure Id</param>
        public void LoadReason(string procedureId)
        {
            if (!(string.IsNullOrEmpty(procedureId)))
            {
                using (UnitOfWork lookupRepository = new UnitOfWork())
                {
                    Helper.BindCollectionToControl(LastFollowupReason, lookupRepository.GetReoperationReason(Convert.ToInt32(procedureId)), "Id", "Description");
                }
            }
            else
            {
                Helper.BindCollectionToControl(LastFollowupReason, new List<ListItem>(), "Id", "Description");
            }
        }

        // Clearing parameters from Query string
        private void ClearQueryString()
        {
            PropertyInfo queryString = typeof(System.Collections.Specialized.NameValueCollection).GetProperty("IsReadOnly", BindingFlags.Instance | BindingFlags.NonPublic);
            // make collection editable
            queryString.SetValue(this.Request.QueryString, false, null);
            this.Request.QueryString.Remove("LoadOperationDetails");
        }

        /// <summary>
        /// Load Selected Operation Details
        /// </summary>
        public void LoadSelectedOperation()
        {
            if (_sessionData.PatientOperationId != 0)
            {
                LoadOperationDetails();
            }
        }

        // Showing and Hiding some control as per the Logged in user's user role
        private void AdminSurgeonFeatures()
        {
            if (IsSurgeon || IsDataCollector)
            {
                SaveButton.Visible = false;
                CommentPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                AdmissionDischargeFields.Visible = false;
            }
            else
            {
                if (GetValidateValue() == 2) { SaveButton.Visible = false; } else { SaveButton.Visible = true; }

                CommentPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                AdmissionDischargeFields.Visible = true;
            }
        }

        // Validating whether Save button available for the current logged in user
        private int GetValidateValue()
        {
            int validateValue = 0;
            SessionData sessionData = GetSessionData();
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                tbl_PatientOperation patientOperation = patientRepository.tbl_PatientOperationRepository.Get(x => x.OpId == sessionData.PatientOperationId).FirstOrDefault();
                if (patientOperation != null)
                {
                    if (patientOperation.OpVal != null)
                    {
                        validateValue = ((int)patientOperation.OpVal);
                    }
                }
            }

            return validateValue;
        }

        // Showing and Hiding panels according to patient operation details
        private void ShowHidePanel()
        {
            CDMSValidation.SetControlVisible(OtherDetailsPanel, PrimaryProcedure.SelectedValue == "9");
            CDMSValidation.SetControlVisible(OtherRevisionPanel, SecondaryProcedure.SelectedValue == "9");
            SetOperationDetailsinGlobal(_sessionData.PatientId, "");
            int? legacy = CheckLegacyFlag();
            CDMSValidation.SetControlVisible(LastBariatricProcedurePanel, legacy == 1 || legacy == null);
            CDMSValidation.SetControlVisible(DiabetesTreatmentPanel, DiabetesStatus.SelectedValue == "1");
            if (legacy == 1)
            {
                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    int patientOperationCount = patientRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == _sessionData.PatientId && x.ProcAban == false).Count();
                    tbl_PatientOperation patientOperation = patientRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == _sessionData.PatientId && x.ProcAban == false).OrderBy(x => x.OpDate).FirstOrDefault();

                    if (patientOperationCount == 0)
                    {
                        OperationEventPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    }
                    else if (patientOperation.OpId == _sessionData.PatientOperationId)
                    {
                        OperationEventPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    }
                    else
                    {
                        OperationEventPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                    }
                }
            }
            else
            {
                OperationEventPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
            }

            CDMSValidation.SetControlVisible(FollowupReasonPanel, OperationEvent.SelectedValue == "2");
            bool showReason = OperationEvent.SelectedValue == "2";
            bool showSlipPanel = IsReasonSelected("1");
            bool shownPortPanel = IsReasonSelected("8");
            bool showOtherPanel = IsReasonSelected("27");
            bool showBowelOperation = IsReasonSelected("44");
            CDMSValidation.SetControlVisible(FurtherInformationSlipPanel, showSlipPanel && showReason);
            CDMSValidation.SetControlVisible(FollowupPortPanel, shownPortPanel && showReason);
            CDMSValidation.SetControlVisible(OtherReasonPanel, showOtherPanel && showReason);
            CDMSValidation.SetControlVisible(FurtherInformationPanel, (showOtherPanel || shownPortPanel || showSlipPanel || showBowelOperation) && showReason);
            CDMSValidation.SetControlVisible(BowelObstructionOperative, showBowelOperation);
        }

        /// <summary>
        /// Operation Details submited
        /// </summary>
        /// <param name="sender">Submit button as sender</param>
        /// <param name="e">Event argument</param>
        protected void SubmitClicked(object sender, EventArgs e)
        {
            Submit();
        }

        // Submitting operation details to save in the database
        private void Submit()
        {
            Page.Validate("PatientOperationDataValidationGroup_Device");
            if (Page.IsValid == true)
            {
                _formSaved = SaveData(true);
                _isAdded = false;
                if (_formSaved)
                {
                    InitData();
                }

                ShowingFormSavedMessage(true);
            }
            else { OperationPanel.Focus(); }
        }

        /// <summary>
        /// Validation Operation details entered
        /// </summary>
        /// <param name="sender">Draft Save Button  as sender</param>
        /// <param name="e">Event argument</param>
        protected void SaveDraftClicked(object sender, EventArgs e)
        {
            Page.Validate("PatientPriOperationDataValidationGroup");
            if (Page.IsValid == true)
            {
                _formSaved = SaveData(false);
                if (_formSaved)
                {
                    InitData();
                }
                ShowingFormSavedMessage(false);
            }
            else { OperationPanel.Focus(); }
        }

        #region ShowingFormSavedMessage
        // Showing message for form save
        private void ShowingFormSavedMessage(bool isSubmit = false)
        {
            ((Label)FormSavedMessage).Visible = _formSaved;
            if (_formSaved)
            {
                if (IsAdminCentral || IsAdministrator)
                {
                    if (isSubmit == false)
                    {
                        ((Label)FormSavedMessage).Text = "Data has been saved - " + DateTime.Now.ToString();
                    }
                    else
                    {
                        ((Label)FormSavedMessage).Text = "Data has been validated - " + DateTime.Now.ToString();
                    }
                }

                _formSaved = false;

                if (IsDataCollector || IsSurgeon) { Response.Redirect(Properties.Resource2.SurgeonHome); }
            }
        }
        #endregion

        #region SaveData


        /// <summary>
        /// Saving data in the Database
        /// </summary>
        /// <param name="validate">Flag to determine validation</param>
        /// <returns>Returns flag indicating whether data save operation is successful or not</returns>
        protected bool SaveData(bool validate)
        {
            Boolean isOperationSuccessful = false;

            try
            {
                tbl_PatientOperation patientOperation = new tbl_PatientOperation();
                int? operationStatus = patientOperation.OpStat;
                int? importedOperationStatus;
                int? opVal;

                patientOperation.With(operationDetails =>
                {
                    if (_sessionData.PatientOperationId != 0)
                    {
                        operationDetails.OpId = _sessionData.PatientOperationId;
                    }

                    operationDetails.PatientId = _sessionData.PatientId;
                    operationDetails.Surg = Helper.ToNullable<System.Int32>(SurgeonAndSite.GetSelectedItemFromSurgeonList().Value);
                    operationDetails.Hosp = Helper.ToNullable<System.Int32>(SurgeonAndSite.GetSelectedItemFromSiteList().Value);
                    operationDetails.OpDate = OperationDate.SelectedDate;
                    operationDetails.OpStat = Helper.ToNullable<System.Int32>(OperationStatus.SelectedValue);
                    operationDetails.Ht = Helper.ToNullable<System.Decimal>(PatientHeight.Text);
                    operationDetails.HtNtKnown = HeightUnknown.Checked;
                    operationDetails.OpWt = Helper.ToNullable<System.Decimal>(PatientWeight.Text);
                    operationDetails.OpWtNtKnown = PatientWeightUnknown.Checked;
                    operationDetails.DiabStat = Helper.ToNullable<System.Int32>(DiabetesStatus.SelectedValue);
                    operationDetails.DiabRx = Helper.ToNullable<System.Int32>(DiabetesTreatment.SelectedValue);
                    operationDetails.LiverTx = Helper.ToNullable<System.Int32>(LiverTransplant.SelectedValue);
                    operationDetails.RenalTx = Helper.ToNullable<System.Int32>(RenalTransplant.SelectedValue);
                    operationDetails.OthInfoOp = Comments.Text;
                    operationDetails.ProcAban = AbandonedProcedure.Checked;
                    operationDetails.CreatedBy = UserName;
                    operationDetails.CreatedDateTime = System.DateTime.Now;
                    operationDetails.LastUpdatedBy = UserName;
                    operationDetails.LastUpdatedDateTime = System.DateTime.Now;
                    operationDetails.AdmissionDate = Helper.ToNullable<System.DateTime>(AdmissionDate.Text);
                    operationDetails.DischargeDate = Helper.ToNullable<System.DateTime>(DischargeDate.Text);
                    using (UnitOfWork patientRepository = new UnitOfWork())
                    {
                        importedOperationStatus = patientRepository.tlkp_ProcedureRepository.Get(x => x.Description == ImportedOperationStatus.Text).Select(b => b.Id).FirstOrDefault();
                    }
                    if (importedOperationStatus == 0)
                        operationDetails.OpTypeBulkLoad = null;
                    else
                        operationDetails.OpTypeBulkLoad = importedOperationStatus;

                    if (validate)
                    {
                        operationDetails.OpVal = 2;
                    }
                    else
                    {
                        using (UnitOfWork patientRepository = new UnitOfWork())
                        {
                            opVal = patientRepository.tbl_PatientOperationRepository.Get(x => x.OpId == _sessionData.PatientOperationId).Select(b => b.OpVal).FirstOrDefault();
                        }
                        operationDetails.OpVal = opVal;
                    }

                    if (!(string.IsNullOrEmpty(OperationEvent.SelectedValue)))
                    {
                        operationDetails.OpEvent = Convert.ToInt32(OperationEvent.SelectedValue);
                    }

                    operationDetails.OpType = Helper.ToNullable<System.Int32>(PrimaryProcedure.SelectedValue);
                    operationDetails.OthPriType = OtherProcedureSpecify.Text;
                    operationDetails.StWt = Helper.ToNullable<System.Decimal>(PatientStartWeight.Text);
                    operationDetails.StWtNtKnown = PatientStartWeightUnknown.Checked;
                    operationDetails.SameOpWt = SameAsOperationWeight.Checked;

                    operationDetails.OpRevType = Helper.ToNullable<System.Int32>(SecondaryProcedure.SelectedValue);
                    operationDetails.OthRevType = OtherSecondarySpecify.Text;
                    operationDetails.LstBarProc = Helper.ToNullable<System.Int32>(LastBariatricProcedure.SelectedValue);
                });

                foreach (ListItem selectedItem in LastFollowupReason.Items)
                {
                    //If Item is selected add to the list
                    if (selectedItem.Selected)
                    {
                        switch (selectedItem.Value)
                        {
                            case "1":
                                patientOperation.FurtherInfoSlip = Helper.ToNullable<System.Int32>(FurtherInfoSlip.SelectedValue);
                                break;
                            case "8":
                                patientOperation.FurtherInfoPort = Helper.ToNullable<System.Int32>(FurtherInfoPort.SelectedValue);
                                break;
                            case "27":
                                patientOperation.ReasonOther = OtherReasonSpecify.Text;
                                break;
                            case "44":
                                patientOperation.OpBowelObsID = Helper.ToNullable<System.Int32>(BowelObstructionOptions.SelectedValue);
                                break;
                        }
                    }
                }

                patientOperation = OperationHandler.SaveOperation(patientOperation, Helper.ToNullable(HospitalMRNumber.Text));

                Dictionary<string, bool> Reasons = LastFollowupReason.Items.Cast<ListItem>().ToDictionary(i => i.Value, i => i.Selected);
                OperationHandler.OperationSaveComplications(patientOperation.OpId, Reasons, OperationEvent.SelectedValue);

                _sessionData.PatientOperationId = patientOperation.OpId;
                SaveSessionData(_sessionData);

                isOperationSuccessful = true;
                BindOperationsGrid();
                OperationGrid.DataBind();
                AdminSurgeonFeatures();
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "PatientOperationDataValidationGroup");
                isOperationSuccessful = false;
            }

            return isOperationSuccessful;
        }

        // Removing Operation from last year
        private void RemoveReOpIDInAnnualFollowUps(int operationId)
        {
            try
            {
                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    tbl_PatientOperation operation = patientRepository.tbl_PatientOperationRepository.Get(x => x.OpId == operationId).FirstOrDefault();
                    if (operation != null && operation.OpDate != null)
                    {
                        List<tbl_FollowUp> followUpList = patientRepository.tbl_FollowUpRepository.Get(x => x.FUDate != null && x.FUDate >= operation.OpDate && x.FUVal == 2 && x.PatientId == operation.PatientId && x.OperationId != operationId && x.FUPeriodId > 0 && x.ReOpStatId != null && x.ReOpStatId == 1).ToList<tbl_FollowUp>();
                        foreach (tbl_FollowUp followUp in followUpList)
                        {
                            DateTime followUpLastYearDate = Convert.ToDateTime(followUp.FUDate);
                            followUpLastYearDate = followUpLastYearDate.AddYears(-1);
                            if (followUpLastYearDate <= operation.OpDate && followUp.FUDate > operation.OpDate)
                            {
                                followUp.ReOpStatId = 0;
                                patientRepository.tbl_FollowUpRepository.Update(followUp);
                            }
                        }

                        patientRepository.Save();
                    }
                }
            }
            catch (Exception ex)
            {
            }
        }

        // Check whether annual FollowUp is completed
        private bool CheckIfAnnualFollowUpIsCompleted()
        {
            try
            {
                using (UnitOfWork followUpRepository = new UnitOfWork())
                {
                    List<tbl_FollowUp> followUps = followUpRepository
                                                                .tbl_FollowUpRepository
                                                                .Get(x => x.OperationId == _sessionData.PatientOperationId && x.FUPeriodId > 0).ToList();
                    foreach (tbl_FollowUp followUp in followUps)
                    {
                        if (followUp.FUVal == 1 || followUp.FUVal == 2) { return true; }
                    }
                }
                return false;
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "PatientOperationDataValidationGroup");
            }
            return false;
        }

        // Check Legacy Flag for Patient
        private int? CheckLegacyFlag()
        {
            try
            {
                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    return patientRepository.PatientRepository.CheckLegacyFlag(patientRepository, _sessionData.PatientId);
                }
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "PatientOperationDataValidationGroup");
            }
            return null;
        }


        /// <summary>
        /// Deleting Operation for the patient
        /// </summary>
        protected void DeletePatientOperation()
        {
            try
            {
                RemoveReOpIDInAnnualFollowUps(_sessionData.PatientOperationId);
                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    tbl_PatientOperation patientOperation = patientRepository
                                                                .tbl_PatientOperationRepository
                                                                .Get(x => x.OpId == _sessionData.PatientOperationId).SingleOrDefault();
                    if (patientOperation != null)
                    {
                        patientRepository.tbl_PatientOperationRepository.Delete(patientOperation);
                        patientRepository.Save();
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "PatientOperationDataValidationGroup");
            }
        }

        /// <summary>
        /// Deleting Patient Operation Devices
        /// </summary>
        protected void DeletePatientDevice()
        {
            try
            {
                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    tbl_PatientOperationDeviceDtls patientOperationDevice = patientRepository.tbl_PatientOperationDeviceDtlsRepository.Get(x => x.PatientOperationDevId == _sessionData.PatientOperationDeviceId).SingleOrDefault();
                    if (patientOperationDevice != null)
                    {
                        if (!patientRepository.OperationRepository.IsDeviceRequiredForProcedure(_sessionData.PatientOperationId))
                        {
                            patientRepository.tbl_PatientOperationDeviceDtlsRepository.Delete(patientOperationDevice);
                            patientRepository.Save();
                        }
                        else if (!patientRepository.OperationRepository.IsSingleOperationDevice(_sessionData.PatientOperationId, _sessionData.PatientOperationDeviceId))
                        {
                            patientRepository.tbl_PatientOperationDeviceDtlsRepository.Delete(patientOperationDevice);
                            patientRepository.Save();
                        }
                        else
                        {
                            WarningLabel.Text = "At least one device needs to exist for this operation before you can delete.";
                        }
                    }
                }
                CheckIfChildExistsAndDelete();
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "PatientOperationDataValidationGroup");
            }
        }

        /// <summary>
        /// Deleting Patient Operation Details
        /// </summary>
        protected void CheckIfChildExistsAndDelete()
        {
            try
            {
                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    SessionData sessionData = GetSessionData();
                    tbl_PatientOperationDeviceDtls patientOperationDevice = patientRepository.tbl_PatientOperationDeviceDtlsRepository.Get(x => x.ParentPatientOperationDevId == sessionData.PatientOperationDeviceId).SingleOrDefault();
                    if (patientOperationDevice != null)
                    {
                        patientRepository.tbl_PatientOperationDeviceDtlsRepository.Delete(patientOperationDevice);
                        patientRepository.Save();
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "PatientOperationDataValidationGroup");
            }
        }
        #endregion

        /// <summary>
        /// Loading Dropdown values/options from the database
        /// </summary>
        protected void LoadLookup()
        {
            SessionData sessionData = GetSessionData();
            using (UnitOfWork lookupRepository = new UnitOfWork())
            {
                Helper.BindCollectionToControl(OperationStatus, lookupRepository.Get_tlkp_OperationStatus(true), "Id", "Description");
                Helper.BindCollectionToControl(DiabetesStatus, lookupRepository.Get_tlkp_YesNoNotStated(true), "Id", "Description");
                Helper.BindCollectionToControl(DiabetesTreatment, lookupRepository.Get_tlkp_DiabetesTreatment(false), "Id", "Description");
                Helper.BindCollectionToControl(PrimaryProcedure, lookupRepository.GetPrimaryProcedure(false), "Id", "Description");
                Helper.BindCollectionToControl(SecondaryProcedure, lookupRepository.Get_tlkp_Procedure(false), "Id", "Description");
                Helper.BindCollectionToControl(LastBariatricProcedure, lookupRepository.GetPrimaryProcedure(true), "Id", "Description");
                Helper.BindCollectionToControl(RenalTransplant, lookupRepository.GetYesNo(false), "Id", "Description");
                Helper.BindCollectionToControl(LiverTransplant, lookupRepository.GetYesNo(false), "Id", "Description");
                Helper.BindCollectionToControl(FurtherInfoSlip, lookupRepository.Get_tlkp_ReasonSlip(true), "Id", "Description");
                Helper.BindCollectionToControl(FurtherInfoPort, lookupRepository.Get_tlkp_ReasonPort(true), "Id", "Description");
                Helper.BindCollectionToControl(BowelObstructionOptions, lookupRepository.Get_tlkp_ReasonBowelObstructionOperative(true), "Id", "Description");
            }
        }

        // Initialize Surgeon and Site List control
        private void InitSurgeonSiteList()
        {
            SurgeonAndSite.AddEmptyItemInSurgeonList = false;
            SurgeonAndSite.AddEmptyItemInSurgeonList = false;
            SurgeonAndSite.SetSurgeonLabelWidth(260);
            SurgeonAndSite.ConfigureSurgeonValidator(true, "PatientOperationDataValidationGroup", null);
            SurgeonAndSite.EnableSiteDropDownEvenIfItHasJustOneValue = false;
            SurgeonAndSite.ChangeSurgeonLabelText("Surgeon");
            SurgeonAndSite.ChangeSiteLabelText("Site");
            int? primarySurgery = GetPrimarySurgeonForPatient();
            string method = "CheckPrimarySurgeon('" + primarySurgery.ToString() + "','" + SurgeonAndSite.GetSurgeonClientId + "')";
            SurgeonAndSite.AddClientMethodSurgeon(method);

            SurgeonAndSite.URN = HospitalMRNumber;
            HospitalMRNumber.Text = SurgeonAndSite.URN.Text;
        }

        // Setting default Operation Site/Location
        private void SetDefaultSite()
        {
            SessionData sessionData = GetSessionData();
            if (IsAdminCentral || IsAdministrator)
            {
                SurgeonAndSite.SiteOptionEnabled = true;
            }
            else
            {
                SurgeonAndSite.SiteOptionEnabled = false;
            }

            string userId;
            int? surgeonId = null;
            int? siteId;
            using (UnitOfWork operationRepository = new UnitOfWork())
            {
                if (IsSurgeon || IsDataCollector)
                {
                    userId = GetUserId(UserName);
                    if (IsSurgeon)
                    {
                        surgeonId = Convert.ToInt32(operationRepository.OperationRepository.GetSurgeonId(UserName));
                    }

                    siteId = sessionData.SiteId;
                    if (siteId != null) { SurgeonAndSite.SetDefaultTextForGivenSiteID(siteId); }
                }
                else
                {
                    var lastop = operationRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == sessionData.PatientId).OrderByDescending(po => po.OpDate).FirstOrDefault();
                    if (lastop != null)
                    {
                        SurgeonAndSite.SetDefaultTextForGivenSiteID(Convert.ToInt32(lastop.Hosp));
                        surgeonId = Convert.ToInt32(lastop.Surg);
                    }
                    else
                    {
                        SurgeonAndSite.SetDefaultTextForGivenSiteID(sessionData.SiteId);
                        surgeonId = GetPrimarySurgeonForPatient();
                    }
                }
            }
            if (surgeonId != null) { SurgeonAndSite.SetDefaultTextForGivenSurgeonID(surgeonId); }
        }

        // Get Primary Surgeon details for the Patient
        private int? GetPrimarySurgeonForPatient()
        {
            SessionData sessionData = GetSessionData();
            if (sessionData.PatientId != 0)
            {
                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    if (sessionData.PatientOperationId != null)
                    {
                        tbl_Patient patient = patientRepository.tbl_PatientRepository.Get(x => x.PatId == sessionData.PatientId).FirstOrDefault();
                        return patient.PriSurgId;
                    }
                    else
                    {
                        tbl_PatientOperation patient = patientRepository.tbl_PatientOperationRepository.Get(x => x.OpId == sessionData.PatientOperationId).FirstOrDefault();
                        return patient.Surg;
                    }
                }
            }
            return 0;
        }

        #region InitData
        // Initialize All the controls on the page
        private void InitData()
        {
            string importedOperationStatus;
            SessionData sessionData = GetSessionData();
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                _isProcedureAbandoned = null;
                tbl_PatientOperation patientOperation = patientRepository.tbl_PatientOperationRepository.Get(x => x.OpId == sessionData.PatientOperationId).FirstOrDefault();
                if (patientOperation != null)
                {
                    Dictionary<System.Web.UI.Control, Object> controlMapping = new Dictionary<System.Web.UI.Control, Object>();
                    controlMapping.Add(HospitalMRNumber, GetUrNum(patientOperation.Hosp));
                    controlMapping.Add(OperationId, patientOperation.OpId);
                    SurgeonAndSite.SetDefaultTextForGivenSiteID(patientOperation.Hosp == null ? 0 : (int)patientOperation.Hosp);
                    SurgeonAndSite.SetDefaultTextForGivenSurgeonID(patientOperation.Surg == null ? 0 : (int)patientOperation.Surg);
                    if (IsAdminCentral || IsAdministrator)
                    {
                        SurgeonAndSite.SiteOptionEnabled = true;
                        HospitalMRNumber.Enabled = true;
                    }
                    else
                    {
                        SurgeonAndSite.SiteOptionEnabled = false;
                        HospitalMRNumber.Enabled = false;
                    }

                    controlMapping.Add(OperationDate, patientOperation.OpDate);
                    controlMapping.Add(AgeAtOperation, patientOperation.OpAge);
                    controlMapping.Add(OperationStatus, patientOperation.OpStat);
                    controlMapping.Add(PrimaryProcedure, patientOperation.OpType);
                    controlMapping.Add(LastBariatricProcedure, patientOperation.LstBarProc);
                    controlMapping.Add(OtherProcedureSpecify, patientOperation.OthPriType);
                    controlMapping.Add(SecondaryProcedure, patientOperation.OpRevType);
                    controlMapping.Add(OtherSecondarySpecify, patientOperation.OthRevType);
                    controlMapping.Add(PatientHeight, patientOperation.Ht);
                    controlMapping.Add(HeightUnknown, patientOperation.HtNtKnown);
                    controlMapping.Add(PatientStartWeight, patientOperation.StWt);
                    controlMapping.Add(PatientStartWeightUnknown, patientOperation.StWtNtKnown);
                    controlMapping.Add(SameAsOperationWeight, patientOperation.SameOpWt);
                    controlMapping.Add(PatientWeightUnknown, patientOperation.OpWtNtKnown);
                    controlMapping.Add(PatientWeight, patientOperation.OpWt);
                    controlMapping.Add(PatientStartBMI, patientOperation.StBMI);
                    controlMapping.Add(OperationBMI, patientOperation.OpBMI);
                    controlMapping.Add(DiabetesStatus, patientOperation.DiabStat);
                    controlMapping.Add(DiabetesTreatment, patientOperation.DiabRx);
                    controlMapping.Add(Comments, patientOperation.OthInfoOp);
                    controlMapping.Add(LiverTransplant, patientOperation.LiverTx);
                    controlMapping.Add(RenalTransplant, patientOperation.RenalTx);
                    controlMapping.Add(AbandonedProcedure, patientOperation.ProcAban);

                    importedOperationStatus = patientRepository.tlkp_ProcedureRepository.Get(x => x.Id == patientOperation.OpTypeBulkLoad).Select(b => b.Description).FirstOrDefault();
                    controlMapping.Add(ImportedOperationStatus, importedOperationStatus);

                    if (AdmissionDate.Enabled && patientOperation.AdmissionDate != null)
                    {
                        AdmissionDate.Text = ((DateTime)patientOperation.AdmissionDate).ToString("dd/MM/yyyy");
                    }

                    if (DischargeDate.Enabled && patientOperation.DischargeDate != null)
                    {
                        DischargeDate.Text = ((DateTime)patientOperation.DischargeDate).ToString("dd/MM/yyyy");
                    }

                    if (patientOperation.HtNtKnown == true) { PatientHeight.Enabled = false; } else { PatientHeight.Enabled = true; }

                    if (patientOperation.OpWtNtKnown == true) { PatientWeight.Enabled = false; } else { PatientWeight.Enabled = true; }

                    if (patientOperation.StWtNtKnown == true) { PatientStartWeight.Enabled = false; } else { PatientStartWeight.Enabled = true; }

                    if (patientOperation.SameOpWt == true)
                    {
                        PatientWeightUnknown.Enabled = false;
                        PatientWeightUnknown.Checked = false;
                        PatientStartWeightUnknown.Enabled = false;
                        PatientStartWeightUnknown.Checked = false;
                    }
                    else
                    {
                        PatientWeightUnknown.Enabled = true;
                        PatientStartWeightUnknown.Enabled = true;
                    }

                    if (patientOperation.OpStat != null)
                    {
                        ShowProcedurePanels(patientOperation.OpStat.ToString());
                        ShowHideBasedOnOpStat(patientOperation.OpStat.ToString());
                    }
                    if (patientOperation.OpType != null && patientOperation.OpType == 9) { OtherDetailsPanel.Style.Add(HtmlTextWriterStyle.Display, "block"); } else { OtherDetailsPanel.Style.Add(HtmlTextWriterStyle.Display, "none"); }

                    if (patientOperation.OpRevType != null && patientOperation.OpRevType == 9) { OtherRevisionPanel.Style.Add(HtmlTextWriterStyle.Display, "block"); } else { OtherRevisionPanel.Style.Add(HtmlTextWriterStyle.Display, "none"); }

                    controlMapping.Add(OperationEvent, patientOperation.OpEvent);

                    List<Int32> patientComplications = null;
                    tbl_PatientOperation previousOperation = patientRepository.OperationRepository.GetPreviousOperation(patientOperation.PatientId, (DateTime)patientOperation.OpDate);
                    if (previousOperation != null)
                    {
                        if (previousOperation.OpStat != null && previousOperation.OpStat == 0)
                        {
                            LoadReason(previousOperation.OpType.ToString());
                        }
                        else if (previousOperation.OpStat != null && previousOperation.OpStat == 1)
                        {
                            LoadReason(previousOperation.OpRevType.ToString());
                        }

                        patientComplications = patientRepository.OperationRepository.GetPatientComplications(previousOperation.OpId);
                    }

                    if (patientComplications != null)
                    {
                        for (int j = 0; j < patientComplications.Count; j++)
                        {
                            for (int i = 0; i < LastFollowupReason.Items.Count; i++)
                            {
                                if (patientComplications[j].ToString() == LastFollowupReason.Items[i].Value)
                                {
                                    LastFollowupReason.Items[i].Selected = true;
                                }
                            }
                        }
                    }

                    controlMapping.Add(FurtherInfoSlip, patientOperation.FurtherInfoSlip);
                    controlMapping.Add(FurtherInfoPort, patientOperation.FurtherInfoPort);
                    controlMapping.Add(OtherReasonSpecify, patientOperation.ReasonOther);
                    controlMapping.Add(BowelObstructionOptions, patientOperation.OpBowelObsID);

                    if (CheckLegacyFlag() == 1) { LastBariatricProcedurePanel.Style.Add(HtmlTextWriterStyle.Display, "block"); } else { LastBariatricProcedurePanel.Style.Add(HtmlTextWriterStyle.Display, "none"); }

                    int patientOperationCount = patientRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == _sessionData.PatientId && x.ProcAban == false).Count();
                    tbl_PatientOperation operationDetails = patientRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == _sessionData.PatientId).OrderBy(x => x.OpDate).FirstOrDefault();
                    OperationStatus.Attributes.Add("onchange", "ShowHideOperation('" + _hasPrimary + "','" + _primaryOperationId + "','" + _sessionData.PatientOperationId + "','" + patientOperationCount + "','" + operationDetails.OpId + "')");
                    PopulateControl(controlMapping);

                    auditForm.ModifiedBy = patientOperation.LastUpdatedBy;
                    if (patientOperation.LastUpdatedDateTime != null)
                    {
                        auditForm.ModifiedDateTime = patientOperation.LastUpdatedDateTime;
                    }

                    string FupDone = "NO";
                    if (CheckIfAnnualFollowUpIsCompleted()) { FupDone = "YES"; }
                    SaveButton.Attributes.Add("onclick", "return ShowMessage('" + OperationStatus.SelectedValue + "','" + OperationStatus.ClientID + "','" +
                        OperationDate.SelectedDate + "','" + OperationDate.ClientID + "','" + FupDone + "')");
                    SubmitButton.Attributes.Add("onclick", "return ShowMessage('" + OperationStatus.SelectedValue + "','" + OperationStatus.ClientID + "','" +
                       OperationDate.SelectedDate + "','" + OperationDate.ClientID + "','" + FupDone + "')");
                }
            }
        }

        // Show or Hide based on Operation Status
        private void ShowHideBasedOnOpStat(string operationStatusId)
        {
            if (operationStatusId == "0")
            {
                //If primary show start weight , diabetes
                PatientStartWeightPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
            }
            else
            {
                //do not show revision
                PatientStartWeightPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            }
        }

        // Get Hospital URN Number
        private string GetUrNum(int? HospitalId)
        {
            SessionData sessionData = GetSessionData();
            if (_sessionData.PatientId != null && HospitalId != null)
            {
                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    tbl_URN urnDetails = patientRepository.tbl_URNRepository.Get(x => x.PatientID == sessionData.PatientId).Where(k => k.HospitalID == HospitalId).FirstOrDefault();
                    if (urnDetails != null)
                    {
                        return urnDetails.URNo;
                    }
                }
            }

            return string.Empty;
        }

        // Show or Hide Panels of Procedure
        private void ShowProcedurePanels(string operationStatusId)
        {
            if (operationStatusId == "0")
            {
                PrimaryProcedurePanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                RevisionProcedurePanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            }
            else if (operationStatusId == "1")
            {
                PrimaryProcedurePanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                RevisionProcedurePanel.Style.Add(HtmlTextWriterStyle.Display, "block");
            }
            else
            {
                PrimaryProcedurePanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                RevisionProcedurePanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            }
        }
        #endregion

        /// <summary>
        /// Prerender event handler for Diabetes Status
        /// </summary>
        /// <param name="sender">Diabetes Status as sender</param>
        /// <param name="e">event argument</param>
        protected void DiabetesStatus_PreRender(object sender, EventArgs e)
        {
            String clientVisibleCriteria = String.Empty;
            clientVisibleCriteria = "document.getElementById('" + DiabetesStatus.ClientID + "').value == '1'";
            CDMSValidation.EnablePanelInjectJS(clientVisibleCriteria, DiabetesTreatmentPanel, (DropDownList)DiabetesStatus);
        }

        /// <summary>
        /// Load Operation data in the Grid
        /// </summary>
        /// <param name="sender">Operation List grid as Sender</param>
        /// <param name="e">event argument</param>
        protected void OperationGrid_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            BindOperationsGrid();
        }

        // Bind patient's operation details in the grid
        private void BindOperationsGrid()
        {
            OperationGrid.DataSource = GetAllOperationDetails();
        }

        // Get Patient's operation details
        private IEnumerable<PatientOperationListItem> GetAllOperationDetails()
        {
            SessionData sessionData = GetSessionData();
            int patientId = sessionData.PatientId;
            string userId;
            string surgeonId = string.Empty;
            using (UnitOfWork operationRepository = new UnitOfWork())
            {
                if (IsSurgeon)
                {
                    userId = GetUserId(UserName);
                    surgeonId = operationRepository.OperationRepository.GetSurgeonId(UserName);
                }

                IEnumerable<PatientOperationListItem> patientOperations = operationRepository.OperationRepository.GetOperationDetailsForPatientID(patientId, surgeonId);
                _hasPrimary = false;
                _dateOfPrimaryOperation = null;
                SetOperationDetailsinGlobal(patientId, surgeonId);
                return patientOperations;
            }
        }

        // Get the Opration details to set in the other private member
        private static void SetOperationDetailsinGlobal(int patientId, string surgeonId)
        {
            if (patientId != 0)
            {
                IEnumerable<PatientOperationListItem> patientOperations = new List<PatientOperationListItem>();
                PatientOperationListItem patientPrimaryOperation = OperationHandler.GetPrimaryOperation(patientId);
                using (UnitOfWork operationRepository = new UnitOfWork())
                {
                    patientOperations = operationRepository.OperationRepository.GetOperationDetailsForPatientID(patientId, surgeonId);
                }

                foreach (PatientOperationListItem a in patientOperations)
                {
                    if (a.OperationStat == 0 && a.ProcAban != true)
                    {
                        _hasPrimary = true;
                    }
                }

                if (patientPrimaryOperation != null)
                {
                    if (patientPrimaryOperation.OperationStat == 0 && patientPrimaryOperation.ProcAban != true)
                    {
                        _dateOfPrimaryOperation = patientPrimaryOperation.OperationDate;
                        _primaryHeight = patientPrimaryOperation.Height;
                        _primaryOperationId = patientPrimaryOperation.PatientOperationId;
                    }
                }
            }
        }

        /// <summary>
        /// Click event handler for Add Operation
        /// </summary>
        /// <param name="sender">Add Operation button as sender</param>
        /// <param name="e">event argument</param>
        protected void AddOperationClicked(object sender, EventArgs e)
        {
            AddOperations();
        }

        // Initalize controls for add new operation details
        private void AddOperations()
        {
            _sessionData.PatientOperationId = 0;
            SaveSessionData(_sessionData);
            OperationPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
            LoadLookup();
            ClearAllOperationsControls();
            //rbopevent is not clearing
            OperationEvent.SelectedValue = null;
            //Clear reasons - if any selected
            ClearReasonValues();
            ShowHidePanel();
            GetAllOperationDetails();
            SetDefaultOpDetails();
            BindDeviceGrid();
            AdminSurgeonFeatures();
            SetDefaultSite();
            _isAdded = false;
            EnableTextBoxes();
            LiverTransplant.SelectedValue = "0";
            RenalTransplant.SelectedValue = "0";
            OperationStatus.Attributes.Add("onchange", "ShowHideOperation('" + _hasPrimary + "','" + _primaryOperationId + "','" + _sessionData.PatientOperationId + "')");
        }

        // Clearing Reason selection from control
        private void ClearReasonValues()
        {
            //check last Followup Reason
            for (int index = 0; index < LastFollowupReason.Items.Count; index++)
            {
                if (LastFollowupReason.Items[index].Selected)
                {
                    LastFollowupReason.Items[index].Selected = false;
                    if (LastFollowupReason.Items[index].Value == "27")
                    {
                        LastFollowupReason.Items[index].Selected = false;
                    }

                    if (LastFollowupReason.Items[index].Value == "1")
                    {
                        LastFollowupReason.Items[index].Selected = false;
                    }

                    if (LastFollowupReason.Items[index].Value == "8")
                    {
                        LastFollowupReason.Items[index].Selected = false;
                    }
                }
            }
        }

        // Enable Patient height and weight textboxes
        private void EnableTextBoxes()
        {
            PatientStartWeight.Enabled = true;
            PatientWeight.Enabled = true;
            PatientHeight.Enabled = true;
        }

        // Set Default values in the controls for operation
        private void SetDefaultOpDetails()
        {
            //Set UR number from pat search or sugeon home page as default (not editable)
            HospitalMRNumber.Text = _sessionData.PatientURNNumber;
            if (IsAdminCentral || IsAdministrator)
            {
                HospitalMRNumber.Enabled = true;
            }
            else
            {
                HospitalMRNumber.Enabled = false;
            }

            //Set default operation type
            if (_sessionData.OperationType == Constants.ADD_PRIMARY) { OperationStatus.SelectedValue = "0"; }
            else if (_sessionData.OperationType == Constants.ADD_REVISION) { OperationStatus.SelectedValue = "1"; }
            else
            {
                //For Admins
                //If no primary exists && Has no revision 
                if (!_hasPrimary && OperationHandler.GetOperationsCount(_sessionData.PatientId, false) == 0)
                {
                    OperationStatus.SelectedValue = "0";
                }
                else
                {
                    OperationStatus.SelectedValue = "1";
                }
            }

            if (_primaryHeight != null && _primaryHeight != 0) { PatientHeight.Text = _primaryHeight.ToString(); }

            ShowHideBasedOnOpStat(OperationStatus.SelectedValue);
            ShowProcedurePanels(OperationStatus.SelectedValue);
        }

        /// <summary>
        /// Handled Operation Grid commands
        /// </summary>
        /// <param name="sender">Operation List grid as sender</param>
        /// <param name="e">Grid Command Event Argument</param>
        protected void OperationGrid_ItemCommand(object sender, GridCommandEventArgs e)
        {
            try
            {
                switch (e.CommandName)
                {
                    case "EditOperation":
                        _sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientOperationId"]);
                        SaveSessionData(_sessionData);
                        LoadOperationDetails();
                        break;
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        // Loading Operation details in the private variables and show opeation details
        private void LoadOperationDetails()
        {
            OperationPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
            LoadLookup();
            SetOperationDetailsinGlobal(_sessionData.PatientId, "");
            InitData();
            InitSurgeonSiteList();
            ShowHidePanel();
            BindDeviceGrid();
            AdminSurgeonFeatures();
        }

        /// <summary>
        /// Handled Device Grid command
        /// </summary>
        /// <param name="sender">Device List grid as sender</param>
        /// <param name="e">event argument</param>
        protected void DeviceGrid_ItemCommand(object sender, GridCommandEventArgs e)
        {
            try
            {
                switch (e.CommandName)
                {
                    case "EditDevice":
                        if (e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ParentPatientOperationDevId"] != null) { _sessionData.PatientOperationDeviceId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ParentPatientOperationDevId"]); } else { _sessionData.PatientOperationDeviceId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientOperationDevId"]); }

                        _sessionData.AddNewDevice = 0;
                        SaveSessionData(_sessionData);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "MyFunc1",
                                    "genericPopup('popupAddDeviceOperations.aspx','500','500','Edit Device','E');", true);
                        break;

                    case "Delete":
                        if (e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ParentPatientOperationDevId"] == null)
                        {
                            _sessionData.PatientOperationDeviceId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientOperationDevId"]);
                            DeletePatientDevice();
                            BindDeviceGrid();
                        }
                        break;
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// Bind Device Grid with the device data
        /// </summary>
        protected void BindDeviceGrid()
        {
            int operationId = _sessionData.PatientOperationId;
            if (_sessionData.PatientOperationId != 0 && _sessionData.PatientOperationId != -1)
            {
                using (UnitOfWork operationRepository = new UnitOfWork())
                {
                    IEnumerable<PatientDeviceListItem> deviceList = operationRepository.OperationRepository.GetDeviceListForOperation(operationId);
                    DeviceGrid.DataSource = deviceList;
                    DeviceGrid.DataBind();
                    if (deviceList.Count() == 0)
                    {
                        DeviceGrid.Style.Add(HtmlTextWriterStyle.Display, "none");
                        NoDeviceLabel.Style.Add(HtmlTextWriterStyle.Display, "block");
                    }
                    else
                    {
                        DeviceGrid.Style.Add(HtmlTextWriterStyle.Display, "block");
                        NoDeviceLabel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    }
                }
            }
            else
            {
                DeviceGrid.DataSource = null;
                DeviceGrid.DataBind();
                DeviceGrid.Style.Add(HtmlTextWriterStyle.Display, "none");
                NoDeviceLabel.Style.Add(HtmlTextWriterStyle.Display, "block");
            }
        }

        /// <summary>
        /// Adding a new device for the operation
        /// </summary>
        /// <param name="sender">Add Device button as sender</param>
        /// <param name="e">event argument</param>
        protected void AddDeviceClicked(object sender, EventArgs e)
        {
            if (Page.IsValid == true)
            {
                if (_sessionData.PatientOperationId == 0) { _isAdded = true; }

                SaveData(false);
                _sessionData.PatientOperationDeviceId = 0;
                SaveSessionData(_sessionData);
            }
            else { }
        }

        // Clearing all operation related controls
        private void ClearAllOperationsControls()
        {
            ClearControls(OperationPanel);
        }

        /// Clearing all controls from the panel
        private void ClearControls(Panel panel)
        {
            foreach (Control control in panel.Controls)
            {
                if (control.GetType() == typeof(TextBox))
                {
                    ((TextBox)control).Text = string.Empty;
                }

                if (control.GetType() == typeof(CheckBox))
                {
                    ((CheckBox)control).Checked = false;
                    ((CheckBox)control).Enabled = true;
                }
                else if (control.GetType() == typeof(RadTextBox))
                {
                    ((RadTextBox)control).Text = string.Empty;
                }
                else if (control.GetType() == typeof(RadNumericTextBox))
                {
                    ((RadNumericTextBox)control).Text = string.Empty;
                }
                else if (control.GetType() == typeof(DropDownList))
                {
                    ((DropDownList)control).SelectedValue = string.Empty;
                }
                else if (control.GetType() == typeof(RadDatePicker))
                {
                    ((RadDatePicker)control).SelectedDate = null;
                }
                else if (control.GetType() == typeof(RadioButtonList))
                {
                    ((RadioButtonList)control).ClearSelection();
                }
                else if (control.GetType() == typeof(CheckBoxList))
                {
                    ((CheckBoxList)control).ClearSelection();
                }
                if (control.GetType() == typeof(Panel))
                {
                    //recurssive call to clear controls in child panel
                    ClearControls((Panel)control);
                }
            }
        }

        /// <summary>
        /// Vailation for Primary Procedure control
        /// </summary>
        /// <param name="source">Priamry Procedure as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidatePrimaryProcedure(object source, ServerValidateEventArgs args)
        {
            if (OperationStatus.SelectedValue == "0" && PrimaryProcedure.SelectedValue == string.Empty)
            {
                CustomValidatorPrimaryProcedure.ErrorMessage = "Primary procedure is a required field";
                args.IsValid = false;
            }
        }

        /// <summary>
        /// Post processing of the device grid once data is loaded
        /// </summary>
        /// <param name="sender">Device List grid as sender</param>
        /// <param name="e">event argument</param>
        protected void DeviceGrid_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = (GridDataItem)e.Item;
                (item["EditDevice"].Controls[0] as LinkButton).Text = "Edit";
            }
        }

        /// <summary>
        /// Preprocessing of the Device Grid - Hiding delete button if logged in user has no permission
        /// </summary>
        /// <param name="sender">Device List as sender</param>
        /// <param name="e">event argument</param>
        protected void DeviceGrid_PreRender(object sender, EventArgs e)
        {
            if (IsAdminCentral || IsAdministrator)
            {
                DeviceGrid.MasterTableView.GetColumn("Delete").Display = true;
            }
            else
            {
                DeviceGrid.MasterTableView.GetColumn("Delete").Display = false;
            }
        }

        #region Validation

        /// <summary>
        /// Validation for diabetes Status
        /// </summary>
        /// <param name="source">Diabetes Status control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateDiabetesStatus(object source, ServerValidateEventArgs args)
        {
            if (DiabetesStatus.SelectedValue != string.Empty)
            {
                args.IsValid = true;
            }
            else
            {
                args.IsValid = false;
            }
        }

        /// <summary>
        /// Validation for Renal Transplant control
        /// </summary>
        /// <param name="source">Renal Transplat control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateRenalTransplant(object source, ServerValidateEventArgs args)
        {
            if (RenalTransplant.SelectedValue != string.Empty)
            {
                args.IsValid = true;
            }
            else
            {
                args.IsValid = false;
            }
        }

        /// <summary>
        /// Validation for Liver Transplant control
        /// </summary>
        /// <param name="source">Liver Transplant control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateLiverTransplant(object source, ServerValidateEventArgs args)
        {
            if (LiverTransplant.SelectedValue != string.Empty)
            {
                args.IsValid = true;
            }
            else
            {
                args.IsValid = false;
            }
        }

        /// <summary>
        /// Validation for Operation Status
        /// </summary>
        /// <param name="source">Operation Status control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidatePrimaryOperationStatus(object source, ServerValidateEventArgs args)
        {
            // commented code to check validation of operation status
            //if (OperationStatus.SelectedValue == string.Empty) {
            //    args.IsValid = false;
            //    CustomValidatorPrimaryOperationStatus.ErrorMessage = "Operation Status is a required field";
            //} else {
            if (_sessionData.PatientOperationId == 0 && _hasPrimary == true && OperationStatus.SelectedValue == "0")
            {
                CustomValidatorPrimaryOperationStatus.ErrorMessage = "A primary operation is already recorded for this patient";
                args.IsValid = false;
            }

            if (OperationHandler.GetOperationsCount(_sessionData.PatientId, true) == 1 && _hasPrimary == true && _primaryOperationId != _sessionData.PatientOperationId && OperationStatus.SelectedValue == "0")
            {
                CustomValidatorPrimaryOperationStatus.ErrorMessage = "A primary operation is already recorded for this patient";
                args.IsValid = false;
            }

            //This is done to avoid the scenario where admin creates one primary with proc aban checked. Creates another primary that is valid. Tries to uncheck the first primary with proc aban checked.
            //If unchecking is allowed this will result in two primaries for one patient. Hence this validation is done to avoid it.
            if (_isProcedureAbandoned != null && _isProcedureAbandoned != AbandonedProcedure.Checked
                && OperationStatus.SelectedValue == "0" && OperationHandler.GetOperationsCount(_sessionData.PatientId, true) > 1 && _hasPrimary)
            {
                CustomValidatorPrimaryOperationStatus.ErrorMessage = "Cannot change procedure abandoned as another Primary exists for this patient";
                args.IsValid = false;
            }
            //}
        }

        /// <summary>
        /// Validation for Bariatric Procedure control
        /// </summary>
        /// <param name="source">Bariatric Procedure control as soruce</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateLastBariatricProcedure(object source, ServerValidateEventArgs args)
        {
            if (LastBariatricProcedure.SelectedValue == string.Empty && !_hasPrimary && OperationStatus.SelectedValue == "1")
            {
                args.IsValid = false;
                CustomValidatorLastBariatricProcedure.ErrorMessage = "Last bariatric procedure is a required field";
            }
        }

        /// <summary>
        /// Validation for Operation Status control
        /// </summary>
        /// <param name="source">Operation Status control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateOperationStatus(object source, ServerValidateEventArgs args)
        {
            // commented code to check validation of operation status
            //if (OperationStatus.SelectedValue == string.Empty) {
            //    args.IsValid = false;
            //    CustomValidatorOperationStatus.ErrorMessage = "Operation Status is a required field";
            //} else {
            if (_sessionData.PatientOperationId == 0 && _hasPrimary == true && OperationStatus.SelectedValue == "0")
            {
                CustomValidatorOperationStatus.ErrorMessage = "A primary operation is already recorded for this patient";
                args.IsValid = false;
            }

            if (OperationHandler.GetOperationsCount(_sessionData.PatientId, true) == 1 && _hasPrimary == true && _primaryOperationId != _sessionData.PatientOperationId && OperationStatus.SelectedValue == "0")
            {
                CustomValidatorOperationStatus.ErrorMessage = "A primary operation is already recorded for this patient";
                args.IsValid = false;
            }

            //This is done to avoid the scenario where admin creates one primary with proc aban checked. Creates another primary that is valid. Tries to uncheck the first primary with proc aban checked.
            //If unchecking is allowed this will result in two primaries for one patient. Hence this validation is done to avoid it.
            if (_isProcedureAbandoned != null && _isProcedureAbandoned != AbandonedProcedure.Checked
                && OperationStatus.SelectedValue == "0" && OperationHandler.GetOperationsCount(_sessionData.PatientId, true) > 1 && _hasPrimary)
            {
                CustomValidatorOperationStatus.ErrorMessage = "Cannot change procedure abandoned as another Primary exists for this patient";
                args.IsValid = false;
            }
            //}
        }

        /// <summary>
        /// Validation for Operation Date control
        /// </summary>
        /// <param name="source">Operation Date control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateOperationDate(object source, ServerValidateEventArgs args)
        {
            if (OperationDate.SelectedDate == null)
            {
                args.IsValid = false;
                CustomValidatorOperationDate.ErrorMessage = "Operation date is a required field";
            }
            else
            {
                DateTime? DeathDate = GetPatientDeathDate();
                if (DeathDate == null) { args.IsValid = true; }
                else
                {
                    if (OperationDate.SelectedDate > DeathDate)
                    {
                        CustomValidatorOperationDate.ErrorMessage = "Operation date is after date of death";
                        args.IsValid = false;
                    }
                }

                DateTime? siteEthicalApprovalDate = GetSiteEthicalApprovalDate();
                if (siteEthicalApprovalDate == null) { args.IsValid = true; }
                else
                {
                    if (OperationDate.SelectedDate < siteEthicalApprovalDate)
                    {
                        CustomValidatorOperationDate.ErrorMessage = "Operation date is less than ethics approval date";
                        args.IsValid = false;
                    }
                }

                //For Revision operation check if primary operation date is after revision 
                if (OperationStatus.SelectedValue == "1" && _dateOfPrimaryOperation != null && OperationDate.SelectedDate != null)
                {
                    //If date of primary is after than date of revision
                    if (_dateOfPrimaryOperation > OperationDate.SelectedDate)
                    {
                        CustomValidatorOperationDate.ErrorMessage = "Revision operation date cannot be before Primary operation date";
                        args.IsValid = false;
                    }
                }

                /* For primary operation check if primary operation date is after revision  - This case will not happen as we cannot add primary after revision
                   If rules change uncomment*/
                if (OperationStatus.SelectedValue == "0" && OperationDate.SelectedDate != null)
                {
                    if (CheckifPrimaryisBeforeRevision())
                    {
                        CustomValidatorOperationDate.ErrorMessage = "A Revision operation has been recorded before this Primary operation";
                        args.IsValid = false;
                    }
                }
            }
        }

        /// <summary>
        /// Validation for Add Device control
        /// </summary>
        /// <param name="source">Add Device button as source</param>
        /// <param name="args">validation event argument</param>
        protected void ValidateAddDevice(object source, ServerValidateEventArgs args)
        {
            if (Page.IsValid == true)
            {
                args.IsValid = true;

                List<int> deviceRequiredProcedures = new List<int>();
                //get list of procedure id which doesn't require device
                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    deviceRequiredProcedures = patientRepository.OperationRepository.GetIsRequiredDeviceProcedureList();
                }

                //Convert both primary and secondary to integers to make a simpler form of checking
                int PrimarySelected = -1;
                int SecondarySelected = -1;

                if (!string.IsNullOrEmpty(PrimaryProcedure.SelectedValue))
                {
                    PrimarySelected = int.Parse(PrimaryProcedure.SelectedValue);
                }

                if (!string.IsNullOrEmpty(SecondaryProcedure.SelectedValue))
                {
                    SecondarySelected = int.Parse(SecondaryProcedure.SelectedValue);
                }

                //If the procedure is abandoned, any of these are checked, and there isn't a device then it fails validation
                if (PrimarySelected == -1)
                {
                    if (!(AbandonedProcedure.Checked || deviceRequiredProcedures.Contains(SecondarySelected)) && DeviceGrid.Items.Count == 0)
                    {
                        args.IsValid = false;
                    }
                    else
                    {
                        args.IsValid = true;
                    }
                }
                if (SecondarySelected == -1)
                {
                    if (!(AbandonedProcedure.Checked || deviceRequiredProcedures.Contains(PrimarySelected)) && DeviceGrid.Items.Count == 0)
                    {
                        args.IsValid = false;
                    }
                    else
                    {
                        args.IsValid = true;
                    }
                }
            }
            else
            {
            }
        }

        /// <summary>
        /// Validation for other Revision control
        /// </summary>
        /// <param name="source">Other as sender</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateOtherRevisionProcedure(object source, ServerValidateEventArgs args)
        {
            //Revision
            if (OperationStatus.SelectedValue == "1")
            {
                //Other
                if (SecondaryProcedure.SelectedValue == "9" && OtherSecondarySpecify.Text.Trim() == string.Empty) { args.IsValid = false; } else { args.IsValid = true; }
            }
        }

        /// <summary>
        /// Check if URN number is valid for hospital or not
        /// </summary>
        /// <param name="hospitalID">Hospital Id</param>
        /// <param name="urNumber">URN Number</param>
        /// <returns>Returns flag determines whether URN number is valid for Hospital or not</returns>
        public bool CheckIfUrNoValid(string hospitalID, string urNumber)
        {
            bool isPatientUrnValid = false;
            SessionData sessionData;
            sessionData = GetDefaultSessionData();
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                int patientId = patientRepository.PatientRepository.GetPatientId(hospitalID == string.Empty ? -1 : Convert.ToInt32(hospitalID), urNumber);
                if (patientId < 1) { isPatientUrnValid = true; }
                else
                {
                    isPatientUrnValid = false;
                    if (sessionData.PatientId != null && sessionData.PatientId == patientId) { isPatientUrnValid = true; }
                }
            }
            return isPatientUrnValid;
        }

        /// <summary>
        /// Validation for Hospital MRNumber 
        /// </summary>
        /// <param name="source">Hospital MR Number as source</param>
        /// <param name="args">validation event argument</param>
        protected void ValidateHospitalMRNumber(object source, ServerValidateEventArgs args)
        {
            if (string.IsNullOrEmpty(HospitalMRNumber.Text) || !CheckIfUrNoValid(SurgeonAndSite.GetSelectedIdFromSiteList().ToString(), HospitalMRNumber.Text))
            {
                if (string.IsNullOrEmpty(HospitalMRNumber.Text)) { CustomValidatorHospitalMRNumber.ErrorMessage = "Hospital UR Number is a required field"; } else { CustomValidatorHospitalMRNumber.ErrorMessage = "Hospital UR Number already exists for another patient"; }

                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validation for Other Primary Procedure
        /// </summary>
        /// <param name="source">Other Primary Procedure as source</param>
        /// <param name="args">Valiation event argument</param>
        protected void ValidateOtherProcedure(object source, ServerValidateEventArgs args)
        {
            //Primary
            if (OperationStatus.SelectedValue == "0")
            {
                //Other
                if (PrimaryProcedure.SelectedValue == "9" && OtherProcedureSpecify.Text.Trim() == string.Empty) { args.IsValid = false; } else { args.IsValid = true; }
            }
        }

        /// <summary>
        /// Validation for Secondary Procedure control
        /// </summary>
        /// <param name="source">Secondary Procedure as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateSecondaryProcedure(object source, ServerValidateEventArgs args)
        {
            if (OperationStatus.SelectedValue == "1" && SecondaryProcedure.SelectedValue == string.Empty)
            {
                CustomValidatorSecondaryProcedure.ErrorMessage = "Revision procedure is a required field";
                args.IsValid = false;
            }
        }

        /// <summary>
        /// Validation for Height control
        /// </summary>
        /// <param name="source">Height control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidatePatientHeight(object source, ServerValidateEventArgs args)
        {
            if (PatientHeight.Text == string.Empty && HeightUnknown.Checked == false) { args.IsValid = false; } else { args.IsValid = true; }
        }

        /// <summary>
        /// Validation for Weight control
        /// </summary>
        /// <param name="source">Weight control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void VaildatePatientStartWeight(object source, ServerValidateEventArgs args)
        {
            //If primary
            if (OperationStatus.SelectedValue == "0")
            {
                if (PatientStartWeight.Text == string.Empty && PatientStartWeightUnknown.Checked == false && SameAsOperationWeight.Checked == false) { args.IsValid = false; } else { args.IsValid = true; }

                if (PatientStartWeight.Text != string.Empty)
                {
                    Decimal patientWeight = Convert.ToDecimal(PatientStartWeight.Text);
                    if ((patientWeight < 35) || (patientWeight > 600))
                    {
                        CustomValidatorPatientStartWeight.ErrorMessage = "Patient weight (kg) is out of range (35kg - 600kg). Please review and amend";
                        PatientStartWeight.Enabled = true;
                        args.IsValid = false;
                    }
                }
            }
        }

        /// <summary>
        /// Validation for Operation Weight control
        /// </summary>
        /// <param name="source">Operation Control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidatePatientOperationWeight(object source, ServerValidateEventArgs args)
        {
            if (PatientWeight.Text == string.Empty && PatientWeightUnknown.Checked == false) { args.IsValid = false; } else { args.IsValid = true; }

            if (SameAsOperationWeight.Checked) { CustomValidatorPatientOperationWeight.ErrorMessage = "Patient Op weight is a required field"; } else { CustomValidatorPatientOperationWeight.ErrorMessage = "Patient Op weight is a required field. Please complete Patient Op weight or Select 'Patient Op weight not known'"; }

            if (PatientWeight.Text != string.Empty)
            {
                Decimal patientWeight = Convert.ToDecimal(PatientWeight.Text);
                if ((patientWeight < 35) || (patientWeight > 600))
                {
                    CustomValidatorPatientOperationWeight.ErrorMessage = "Patient weight (kg) is out of range (35kg - 600kg). Please review and amend";
                    PatientWeight.Enabled = true;
                    args.IsValid = false;
                }
            }
        }

        /// <summary>
        /// Validation for Diabetes Treatment control
        /// </summary>
        /// <param name="source">Diabetes Treatment control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateDiabetesTreatment(object source, ServerValidateEventArgs args)
        {
            if (DiabetesStatus.SelectedValue == "1" && DiabetesTreatment.SelectedValue == string.Empty) { args.IsValid = false; } else { args.IsValid = true; }
        }

        /// <summary>
        /// Validation for Operation Classification control
        /// </summary>
        /// <param name="source">Operation Classification control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateOperationEvent(object source, ServerValidateEventArgs args)
        {
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                int patientOperationCount = patientRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == _sessionData.PatientId && x.ProcAban == false).Count();
                tbl_PatientOperation patientOperation = patientRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == _sessionData.PatientId && x.ProcAban == false).OrderBy(x => x.OpDate).FirstOrDefault();

                if (patientOperationCount == 0)
                {
                    OperationEventPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
                else if (patientOperation.OpId == _sessionData.PatientOperationId)
                {
                    OperationEventPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
                else
                {
                    OperationEventPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                }
            }

            if (RevisionProcedurePanel.Style["display"].ToUpper() != "none".ToUpper() && OperationEventPanel.Style["display"].ToUpper() != "none".ToUpper())
            {
                if (OperationEvent.SelectedValue == string.Empty || OperationEvent.SelectedValue == null) { args.IsValid = false; } else { args.IsValid = true; }
            }
        }

        /// <summary>
        /// Validation for Followup Reason control
        /// </summary>
        /// <param name="source">Followup Reason control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateFollowupReason(object source, ServerValidateEventArgs args)
        {
            //Verify ReOperation Selected or not
            if (OperationEvent.SelectedValue == "2")
            {
                _isSelected = true;
            }

            //Verify ReOperation Selected or not
            if (_isSelected == true)
            {
                //Check LAst Followup Reason
                for (int j = 0; j < LastFollowupReason.Items.Count; j++)
                {
                    if (LastFollowupReason.Items[j].Selected)
                    {
                        _isFollowUpReasonSelected = true;
                        if (LastFollowupReason.Items[j].Value == "27")
                        {
                            _isOtherReasonSelected = true;
                        }

                        if (LastFollowupReason.Items[j].Value == "1")
                        {
                            _isProlapseOrSlipSelected = true;
                        }

                        if (LastFollowupReason.Items[j].Value == "8")
                        {
                            _isPortSelected = true;
                        }

                        if (LastFollowupReason.Items[j].Value == "44")
                        {
                            _isOperativeBowelObstructSelected = true;
                        }
                    }
                }

                //If there are no previous operations exist - there is no validation required on this field 
                if (LastFollowupReason.Items.Count == 0)
                {
                    _isFollowUpReasonSelected = true;
                }
            }

            //Reason is a required field
            if (_isFollowUpReasonSelected == false)
            {
                CustomValidatorFollowupReason.ErrorMessage = "Reason is a required field";
                args.IsValid = false;
                return;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validation for Further Info Slip control
        /// </summary>
        /// <param name="source">Further Info Slip control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateFollowupSlip(object source, ServerValidateEventArgs args)
        {
            if (_isProlapseOrSlipSelected == true && FurtherInfoSlip.SelectedIndex == 0)
            {
                CustomValidatorFollowupSlip.ErrorMessage = "Further information (Prolapse/Slip) is a required field";
                args.IsValid = false;
                return;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validation for Further Infor Port control
        /// </summary>
        /// <param name="source">Further Info Port control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateFurtherInformationPort(object source, ServerValidateEventArgs args)
        {
            if (_isPortSelected == true && FurtherInfoPort.SelectedIndex == 0)
            {
                CustomValidatorFurtherInformationPort.ErrorMessage = "Further information (Port) is a required field";
                args.IsValid = false;
                return;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validation for FollowUp Other control
        /// </summary>
        /// <param name="source">Folloup Other control as source</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateOtherReason(object source, ServerValidateEventArgs args)
        {
            if (_isOtherReasonSelected == true && string.IsNullOrEmpty(OtherReasonSpecify.Text))
            {
                CustomValidatorOtherReason.ErrorMessage = "Other reason is a required field";
                args.IsValid = false;
                return;
            }
            else
            {
                args.IsValid = true;
            }
        }

        protected void ValidateBowelObstruction(object source, ServerValidateEventArgs args)
        {
            if (_isOperativeBowelObstructSelected && BowelObstructionOptions.SelectedIndex == 0)
            {
                CustomValidatorBowelObstructionOperative.ErrorMessage = "Bowel Obstruction Further Detail is a required field";
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
            return;
        }
        #endregion

        /// <summary>
        /// Item Data Bound event handler for Operation List grid
        /// </summary>
        /// <param name="sender">Operation List grid as sender</param>
        /// <param name="e">event argument</param>
        protected void OperationGrid_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = (GridDataItem)e.Item;
                if (IsSurgeon || IsDataCollector)
                {
                    (item["EditOperation"].Controls[0] as LinkButton).Enabled = false;
                }
            }
        }

        /// <summary>
        /// Prerender event handler for Operation List grid
        /// </summary>
        /// <param name="sender">Operation List grid as sender</param>
        /// <param name="e">event argument</param>
        protected void OperationGrid_PreRender(object sender, EventArgs e)
        {
            if (IsAdminCentral || IsAdministrator)
            {
                OperationGrid.MasterTableView.GetColumn("Delete").Display = true;
            }
            else
            {
                OperationGrid.MasterTableView.GetColumn("Delete").Display = false;
            }
        }

        /// <summary>
        /// Canceling the process for add new operation and device and redirect to previous page
        /// </summary>
        /// <param name="sender">Cancle button as sender</param>
        /// <param name="e">event argument</param>
        protected void CancelClicked(object sender, EventArgs e)
        {
            if (_isAdded && (IsSurgeon || IsDataCollector))
            {
                DeletePatientDevice();
                DeletePatientOperation();
            }
            RedirectBack();
        }

        // Redirect to the other page of the application
        private void RedirectBack()
        {
            if (IsSurgeon) { Response.Redirect(Properties.Resource2.SurgeonHome); } else { Response.Redirect(Properties.Resource2.PatientHomePath); }
        }

        /// <summary>
        /// Validating whether any revision operation is recorded before primary operation
        /// </summary>
        /// <returns>Returns flag indicating whether any revision operation is recorded after primary operation</returns>
        private bool CheckifPrimaryisBeforeRevision()
        {
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                DateTime? firstRevisionOperation = patientRepository
                                                            .tbl_PatientOperationRepository
                                                            .Get(x => x.PatientId == _sessionData.PatientId && x.OpStat == 1).Min(y => y.OpDate);
                if (firstRevisionOperation != null)
                {
                    //If primary operation date is before the min revision date
                    if (firstRevisionOperation < OperationDate.SelectedDate) { return true; }
                }
                return false;
            }
        }

        // Get Patient Death Date 
        private DateTime? GetPatientDeathDate()
        {
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                tbl_Patient patient = patientRepository.tbl_PatientRepository.Get(x => x.PatId == _sessionData.PatientId).FirstOrDefault();
                if (patient != null)
                {
                    return patient.DateDeath;
                }
            }
            return null;
        }

        // Get Site/Location Ethical Approval Date
        private DateTime? GetSiteEthicalApprovalDate()
        {
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                tbl_Patient patient = patientRepository.tbl_PatientRepository.Get(x => x.PatId == _sessionData.PatientId).FirstOrDefault();
                if (patient != null)
                {
                    tbl_Site site = patientRepository.tbl_SiteRepository.Get(x => x.SiteId == patient.PriSiteId).FirstOrDefault();
                    if (site != null)
                    {
                        return site.EAD;
                    }
                }
            }
            return null;
        }

        /// <summary>
        /// Deleting an operation 
        /// </summary>
        /// <param name="sender">Operation List grid as Sender</param>
        /// <param name="e">Event Argument</param>
        protected void OperationGrid_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            GridDataItem dataItem = (GridDataItem)e.Item;
            String PatientOperationId = dataItem.GetDataKeyValue("PatientOperationId").ToString();
            //Get all followups that are not done and not due update follow up date

            DeleteOperation(PatientOperationId);
            OperationGrid.DataSource = GetAllOperationDetails();
            OperationGrid.DataBind();
        }

        /// <summary>
        /// Delete Operation from database
        /// </summary>
        /// <param name="patientOperationId">Patient Operation Id which needs to be deleted</param>
        protected void DeleteOperation(string patientOperationId)
        {
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                int operationId = Convert.ToInt32(patientOperationId);
                //Delete followup specific complications and followup
                IEnumerable<tbl_FollowUp> followups = patientRepository.tbl_FollowUpRepository.Get(x => x.OperationId == operationId);
                OperationHandler.DeleteFollowupAndComplications(patientRepository, followups);

                IEnumerable<tbl_PatientOperationDeviceDtls> patientOperationDevices = patientRepository.tbl_PatientOperationDeviceDtlsRepository.Get(x => x.PatientOperationId == operationId);
                foreach (tbl_PatientOperationDeviceDtls operationDevice in patientOperationDevices)
                {
                    patientRepository.tbl_PatientOperationDeviceDtlsRepository.Delete(operationDevice);
                    patientRepository.Save();
                }

                if (patientOperationId != string.Empty)
                {
                    //Delete Operation specific complications
                    OperationHandler.DeleteOperationComplications(patientRepository, operationId);
                    //If it is a revision operation and has reopstat set in the existing primary operation
                    RemoveReOpIDInAnnualFollowUps(operationId);
                    tbl_PatientOperation patientOperation = patientRepository.tbl_PatientOperationRepository.Get(x => x.OpId == operationId).FirstOrDefault();
                    if (patientOperation != null)
                    {
                        patientRepository.tbl_PatientOperationRepository.Delete(patientOperation);
                        patientRepository.Save();
                    }
                }

                tbl_PatientOperation patientPrimaryOperation = patientRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == _sessionData.PatientId && x.OpStat != null && x.OpStat == 0 && x.ProcAban == false).FirstOrDefault();
                if (patientPrimaryOperation == null)
                {
                    OperationHandler.UpdateLegacyFlag(1, _sessionData.PatientId);
                }
                else
                {
                    OperationHandler.UpdateLegacyFlag(0, _sessionData.PatientId);
                }
            }
        }

        // Checking whether reason is selected or not
        private bool IsReasonSelected(string Id)
        {
            foreach (ListItem listItem in LastFollowupReason.Items)
            {
                if (listItem.Value == Id && listItem.Selected) { return true; }
            }

            return false;
        }

        /// <summary>
        /// Selected Index Changed event handler for Secondary Procedure control
        /// </summary>
        /// <param name="sender">Secondary Procedure control as sender</param>
        /// <param name="e">Event argument</param>
        protected void SecondaryProcedure_SelectedIndexChanged(object sender, EventArgs e)
        {
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                SessionData sessionData = GetSessionData();

                //TODO -- VErify
                int patientOperationCount = patientRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == _sessionData.PatientId && x.ProcAban == false).Count();
                tbl_PatientOperation patientOperation = patientRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == _sessionData.PatientId && x.ProcAban == false).OrderBy(x => x.OpDate).FirstOrDefault();

                if (patientOperationCount == 0)
                {
                    OperationEventPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
                else if (patientOperation.OpId == _sessionData.PatientOperationId)
                {
                    OperationEventPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
                else
                {
                    OperationEventPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                }

                tbl_PatientOperation operationDetails = patientRepository.tbl_PatientOperationRepository.Get(x => x.OpId == sessionData.PatientOperationId).FirstOrDefault();
                if (operationDetails != null)
                {
                    tbl_PatientOperation previousOperation = patientRepository.OperationRepository.GetPreviousOperation(operationDetails.PatientId, (DateTime)operationDetails.OpDate);
                    if (previousOperation != null)
                    {
                        if (previousOperation.OpStat != null && previousOperation.OpStat == 0)
                        {
                            LoadReason(previousOperation.OpType.ToString());
                        }
                        else if (previousOperation.OpStat != null && previousOperation.OpStat == 1)
                        {
                            LoadReason(previousOperation.OpRevType.ToString());
                        }
                    }
                }
                else
                {
                    tbl_PatientOperation previousOperation = patientRepository.OperationRepository.Get(x => x.PatientId == sessionData.PatientId).OrderByDescending(x => x.OpDate).FirstOrDefault();
                    if (previousOperation != null)
                    {
                        if (previousOperation.OpStat != null && previousOperation.OpStat == 0)
                        {
                            LoadReason(previousOperation.OpType.ToString());
                        }
                        else if (previousOperation.OpStat != null && previousOperation.OpStat == 1)
                        {
                            LoadReason(previousOperation.OpRevType.ToString());
                        }
                    }
                }
            }
        }
    }
}
