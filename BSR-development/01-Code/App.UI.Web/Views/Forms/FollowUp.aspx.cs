using App.Business;
using App.UI.Web.Views.Shared;
using CDMSValidationLogic;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace App.UI.Web.Views.Forms {
    public partial class FollowUp : BasePage {
        // Flag to determine data has been saved
        private Boolean _formSaved;

        // gets or sets height of the patient
        private static decimal? _height = null;

        /// <summary>
        /// Gets or sets Operation Status Id
        /// </summary>
        //private static int? OpStat = 0;

        // Gets or set Reoperation or Sentinel event flag
        bool _isSelected = false;

        // Gets or sets flag to determine if followup reason is selected or not
        bool _isReasonIdSelected = false;

        // Gets or sets flag to determin if other reason is seleted
        bool _isOtherReasonSelected = false;

        // Gets or sets flag to determine Prolapse or Slip is selected as followup reaso
        bool _isProlapseOrSlipSelected = false;

        // Gets or sets flag to determine whether Port is selected as followup reason
        bool _isPortSelected = false;

        // flag to determine whether Bowel Obstruction - operative is selected
        bool _isOperativeBowelObstructSelected = false;

        // Gets or sets Operation Type Id
        private static int? _procedureType;

        #region Pageload
        /// <summary>
        /// Initialize all controls on the page and intial values in the control
        /// </summary>
        /// <param name="sender">Followup page as sender</param>
        /// <param name="e">Event Arguments</param>
        protected void Page_Load(object sender, EventArgs e) {
            SessionData sessionData = GetSessionData();
            if (sessionData.PatientId == 0) {
                Response.Redirect(Properties.Resource2.PatientSearchPath, false);
            } else {
                //Will come only from admin related forms like folloup worklist ,patient details etc
                if (!IsPostBack && Request.QueryString["LoadFUP"] == null) { HideFUP(); }

                if (Request.QueryString["LoadFUP"] != null && Request.QueryString["LoadFUP"] == "1") {
                    sessionData.FollowUpId = 0;
                    ClearQueryString();
                }

                if (!Page.IsPostBack) {
                    LoadLookup();
                    InitData();
                    InitSurgeonSiteList();
                    SurgeonAndSite.EnableSiteDropDownEvenIfItHasJustOneValue = false;
                }

                AdminSurgeonFeatures();
                ShowHidePanel();
                ShowHideControls();
                ShowingFormSavedMessage();

                HasIncompleteFollowups();

                FollowUpPatientWeight.Attributes.Add("onchange", "CalculateBMI('" + _height + "')");
                FollowUpSentinelEvent.Attributes.Add("onclick", "ShowReason_Sentinel()");
                FollowUpReOperation.Attributes.Add("onchange", "ShowReason_Reoperation()");
                FollowUpReason.Attributes.Add("onclick", "ReasonCheckBoxHandler()");
            }
        }
        #endregion Pageload

        // Removing values from query string
        private void ClearQueryString() {
            PropertyInfo queryString = typeof(System.Collections.Specialized.NameValueCollection).GetProperty("IsReadOnly", BindingFlags.Instance | BindingFlags.NonPublic);
            // make collection editable
            queryString.SetValue(this.Request.QueryString, false, null);
            // remove
            this.Request.QueryString.Remove("LoadFUP");
        }

        #region InitData
        // Initialize data method to get all the data for patient and show
        private void InitData() {
            SessionData sessionData = GetSessionData();
            int followUpId = sessionData.FollowUpId;
            Dictionary<System.Web.UI.Control, Object> controlMapping = new Dictionary<System.Web.UI.Control, Object>();
            tbl_FollowUp followUp = null;
            tbl_Patient patient;
            tbl_PatientOperation patientOperation;
            tbl_Site siteData;
            tbl_URN patientUrnData = null;
            PatientFollowUpLTFUDetails patientFollowupLTFUDetails;
            int followUpPeriodId;

            using (UnitOfWork dataRepository = new UnitOfWork()) {
                #region get follow up and operation details
                //Selected existing followup value
                if (followUpId != 0) {
                    //Data item to hold follow up details
                    followUp = dataRepository.tbl_FollowUpRepository.Get(x => x.FUId == followUpId).FirstOrDefault();
                }

                if (followUp != null) {
                    //Data item to hold operation details
                    patientOperation = dataRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == sessionData.PatientId && x.OpId == followUp.OperationId).FirstOrDefault();
                    followUpPeriodId = (int)followUp.FUPeriodId;
                } else {
                    //Data item to hold follow up details
                    followUp = dataRepository.tbl_FollowUpRepository.Get(x => x.PatientId == sessionData.PatientId && x.OperationId == sessionData.PatientOperationId && x.FUPeriodId == sessionData.FollowUpPeriodId).FirstOrDefault(); //sessionData.PatientId
                    //Data item to hold operation details
                    patientOperation = dataRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == sessionData.PatientId && x.OpId == sessionData.PatientOperationId).FirstOrDefault();
                    followUpPeriodId = (int)sessionData.FollowUpPeriodId;
                }
                #endregion

                #region patient, Urn , LTFu details
                //Patient details
                patient = dataRepository.tbl_PatientRepository.Get(x => x.PatId == sessionData.PatientId).FirstOrDefault();
                if (!IsSurgeon || patientOperation.OpStat == 0) {
                    //Patient Urn details
                    patientUrnData = dataRepository.tbl_URNRepository.Get(x => x.PatientID == patient.PatId && x.HospitalID == patient.PriSiteId).FirstOrDefault();
                    //Saving primary site details in session variable for Operation 
                    sessionData.SiteId = patient.PriSiteId == null ? -1 : (int)patient.PriSiteId;
                    sessionData.SurgeonId = patient.PriSurgId == null ? -1 : (int)patient.PriSurgId;
                    sessionData.PatientURNNumber = patientUrnData.URNo;
                }

                //Patient LTFU details
                patientFollowupLTFUDetails = dataRepository.FollowUpRepository.GetPatientFollowUpLTFUDetails(sessionData.PatientId);
                if (patientFollowupLTFUDetails != null) {
                    if (patientFollowupLTFUDetails.FollowUpDate.HasValue) {
                        if (patientFollowupLTFUDetails.FollowUpDate < System.DateTime.Now) {
                            if (IsAdminCentral || IsAdministrator) {
                                LostToFollowUp.Checked = true;
                            }

                            if (IsDataCollector || IsSurgeon) {
                                RecommendedLostToFollowUp.Checked = true;
                            }
                        }
                    }
                }

                if (patientOperation != null) {
                    siteData = dataRepository.tbl_SiteRepository.Get(x => x.SiteId == patientOperation.Hosp).FirstOrDefault();
                } else {
                    siteData = null;
                }

                #endregion

                #region assign details from patient, URN
                //Patient Contact Details
                if (patient != null) {
                    controlMapping.Add(Address, patient.Addr);
                    controlMapping.Add(HomePhoneNumber, patient.HomePh);
                    controlMapping.Add(SuburbAddress, patient.Sub);
                    controlMapping.Add(MobileNumber, patient.MobPh);
                    controlMapping.Add(CountryId, patient.CountryId);
                    if (patient.CountryId == 1) {
                        AustraliaPanel.Visible = true;
                        controlMapping.Add(PostCode, patient.Pcode);
                        controlMapping.Add(StateId, patient.StateId);
                    } else {
                        AustraliaPanel.Visible = false;
                    }

                    controlMapping.Add(FollowUpVitalStatus, patient.HStatId == null ? 0 : patient.HStatId);
                    controlMapping.Add(FollowUpDateOfDeath, patient.DateDeath);
                    controlMapping.Add(DateofDeathUnknown, patient.DateDeathNotKnown);
                    controlMapping.Add(FollowUpCauseOfDeath, patient.CauseOfDeath);
                    controlMapping.Add(DeathRelatedToPrimaryProcedure, patient.DeathRelSurgId);
                }

                if (IsSurgeon && patientOperation.OpStat != 0) {
                    controlMapping.Add(HospitalMRNumber, sessionData.PatientURN);
                }
                    //tbl_URN
                else if (patientUrnData != null) {
                    controlMapping.Add(HospitalMRNumber, patientUrnData.URNo);
                }
                #endregion

                #region assign surgeon details
                //Surgeon and Institution
                if (patientOperation != null) {
                    controlMapping.Add(OperationId, patientOperation.OpId);
                    controlMapping.Add(OperationDate, patientOperation.OpDate);
                    //add Diabetes Status and Diabetes Treatment
                    int? diabetesStatusId = patientOperation.DiabStat;
                    int? diabetesTreatmentId = patientOperation.DiabRx;
                    if (followUpPeriodId != 0) {
                        DiabetesStatus.Visible = true;
                        DiabetesTreatment.Visible = true;
                        DiabetesStatusLabel.Visible = true;
                        DiabetesTreatmentLabel.Visible = true;
                        if (diabetesStatusId != null) {
                            ListItem item = DiabetesStatus.Items.FindByValue(diabetesStatusId.ToString());
                            if (item != null) {
                                DiabetesStatus.SelectedValue = item.Value;
                            }
                        }
                        if (diabetesTreatmentId != null) {
                            ListItem item = DiabetesTreatment.Items.FindByValue(diabetesTreatmentId.ToString());
                            if (item != null) {
                                DiabetesTreatment.SelectedValue = item.Value;
                            }
                        }
                    } else {
                        DiabetesStatus.Visible = false;
                        DiabetesTreatment.Visible = false;
                        DiabetesStatusLabel.Visible = false;
                        DiabetesTreatmentLabel.Visible = false;
                    }

                    if (patientOperation.OpStat == 0) {
                        ListItem listItem = OperationType.Items.FindByValue(patientOperation.OpType.ToString());
                        if (listItem != null) {
                            OperationType.SelectedValue = listItem.Value;
                        }

                        if (patient != null) {
                            SurgeonAndSite.SetDefaultTextForGivenSiteID(patient.PriSiteId == null ? 0 : (int)patient.PriSiteId);
                            SurgeonAndSite.SetDefaultTextForGivenSurgeonID(patient.PriSurgId == null ? 0 : (int)patient.PriSurgId);
                        }
                    } else {
                        ListItem listItem = OperationType.Items.FindByValue(patientOperation.OpRevType.ToString());
                        if (listItem != null) {
                            OperationType.SelectedValue = listItem.Value;
                        }

                        SurgeonAndSite.SetDefaultTextForGivenSiteID(sessionData.SiteId == null ? 0 : (int)sessionData.SiteId);
                        SurgeonAndSite.SetDefaultTextForGivenSurgeonID(sessionData.SurgeonId == null ? 0 : (int)sessionData.SurgeonId);
                    }

                    if (patientOperation.Ht != null) {
                        _height = patientOperation.Ht;
                    }

                    FollowUpDate.MinDate = (DateTime)patientOperation.OpDate;
                    if (patientOperation.OpStat != null) {
                        //If Primary
                        if (patientOperation.OpStat == 0) { _procedureType = patientOperation.OpType; } else { _procedureType = patientOperation.OpRevType; }

                        LoadReason();
                    }

                    if (followUpPeriodId != 0) {
                        YearTo10YearsPanel.Visible = true;
                    } else {
                        YearTo10YearsPanel.Visible = false;
                    }
                }
                #endregion

                if (followUp == null && sessionData.FollowUpPeriodId != -1) {
                    controlMapping.Add(FollowupPeriod, sessionData.FollowUpPeriodId);
                }

                #region assign FUP details
                //Follow Up Details
                if (followUp != null) {
                    controlMapping.Add(PatientFollowupId, followUp.FUId == 0 ? string.Empty : followUp.FUId.ToString());
                    controlMapping.Add(FollowUpDate, followUp.FUDate);
                    if (followUp.FUDate == null) {
                        FollowUpDate.SelectedDate = System.DateTime.Now;
                    }

                    controlMapping.Add(FollowupPeriod, followUp.FUPeriodId);
                    controlMapping.Add(LostToFollowUp, followUp.LTFU);
                    controlMapping.Add(FollowUpLTFUDate, followUp.LTFUDate);
                    controlMapping.Add(FollowUpPatientWeight, followUp.FUWt);
                    controlMapping.Add(FollowUpBMI, followUp.FUBMI);
                    controlMapping.Add(FollowUpSelfReportedWeight, followUp.SelfRptWt);
                    controlMapping.Add(FollowupPatientWeightUnknown, followUp.PatientFollowUpNotKnown); // Weight - required to change 
                    controlMapping.Add(FollowUpDiabetesStatus, followUp.DiabStatId);
                    controlMapping.Add(FollowUpDiabetesTreatment, followUp.DiabRxId);
                    //If revision exists default Reoperation to Yes and it is not 30 day fup
                    if (DoesRevisionExist_1year(followUp.FUDate) && followUp.FUPeriodId != 0) {
                        controlMapping.Add(FollowUpReOperation, 1);
                        FollowUpReOperation.Enabled = false;
                    } else {
                        controlMapping.Add(FollowUpReOperation, followUp.ReOpStatId);
                        FollowUpReOperation.Enabled = true;
                    }

                    controlMapping.Add(Comments, followUp.Othinfo);
                    controlMapping.Add(RecommendedLostToFollowUp, followUp.BSR_to_Follow_Up);

                    //Load Sentinel Events from Followup - if values exists
                    if (followUp != null) {
                        //Existing
                        if (followUp.SEId1 == true) { FollowUpSentinelEvent.Items[0].Selected = true; } else { FollowUpSentinelEvent.Items[0].Selected = false; }

                        if (followUp.SEId2 == true) { FollowUpSentinelEvent.Items[1].Selected = true; } else { FollowUpSentinelEvent.Items[1].Selected = false; }

                        if (followUp.SEId3 == true) { FollowUpSentinelEvent.Items[2].Selected = true; } else { FollowUpSentinelEvent.Items[2].Selected = false; }
                    }

                    if (followUp.FUId != 0) {
                        //Get Complications using Followup
                        List<tbl_PatientComplications> patientComplications = dataRepository.tbl_PatientComplicationsRepository.Get(x => x.FuId == followUp.FUId).ToList();
                        foreach (tbl_PatientComplications complication in patientComplications) {
                            //If Item is selected add to the list
                            if (complication.ComplicationId != null) {
                                ListItem selectedItem = FollowUpReason.Items.FindByValue(complication.ComplicationId.ToString());
                                if (selectedItem != null) { selectedItem.Selected = true; }

                                if (complication.ComplicationId == 1) {
                                    FurtherInformationSlipPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                                } else if (complication.ComplicationId == 8) {
                                    PortPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                                } else if (complication.ComplicationId == 27) {
                                    OtherReasonPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                                } else if (complication.ComplicationId == 44) {
                                    BowelObstructionOperative.Style.Add(HtmlTextWriterStyle.Display, "block");
                                }
                            }
                        }

                        controlMapping.Add(FurtherInfoSlip, followUp.FurtherInfoSlip);
                        controlMapping.Add(FurtherInfoPort, followUp.FurtherInfoPort);
                        controlMapping.Add(FollowUpOther, followUp.ReasonOther);
                        controlMapping.Add(BowelObstructionOptions, followUp.OpBowelObsID);
                    }

                    auditForm.ModifiedBy = followUp.LastUpdatedBy;
                    if (followUp.LastUpdatedDateTime != null) {
                        auditForm.ModifiedDateTime = followUp.LastUpdatedDateTime;
                    }
                    
                }
                #endregion
            }

            PopulateControl(controlMapping);
            SetTitleandDefaultValues(sessionData);
        }

        // Uncheck all reasons from the list control
        private void UncheckAllReasons() {
            foreach (ListItem listItem in FollowUpReason.Items) {
                if (listItem.Selected) { listItem.Selected = false; }
            }
        }

        // Set Titles of the controls and default values
        private void SetTitleandDefaultValues(SessionData sessionData) {
            if ((IsAdminCentral || IsAdministrator) && sessionData.FollowUpId == 0) {
                Header.Title = "Perioperative/Annual Follow-Up Form";
            } else {
                if ((sessionData.FollowUpPeriodId != null || sessionData.FollowUpPeriodId != -1)) {
                    if (FollowupPeriod.SelectedValue == "0") {
                        Header.Title = string.Format("Perioperative Follow-Up Form");
                    }

                    if (FollowupPeriod.SelectedValue != "0") {
                        Header.Title = string.Format("Year {0} Follow-Up Form", FollowupPeriod.SelectedValue);
                    }
                }
            }

            FollowUpLTFUDate.MaxDate = System.DateTime.Now;
            FollowUpDateOfDeath.MaxDate = System.DateTime.Now;
        }

        // Initiate Surgeon Site List control
        private void InitSurgeonSiteList() {
            SurgeonAndSite.ChangeSiteLabelText("Hospital *");
            SurgeonAndSite.ChangeSurgeonLabelText("Surgeon *");
            SurgeonAndSite.AddEmptyItemInSurgeonList = false;
            SurgeonAndSite.SetSurgeonLabelWidth(250);
            SurgeonAndSite.ConfigureSurgeonValidator(true, "PatientDataValidationGroup", null);
            SurgeonAndSite.EnableSiteDropDownEvenIfItHasJustOneValue = false;
        }
        #endregion InitData

        #region LoadLookup
        /// <summary>
        /// Loading all lookup(dropdown control) options from database
        /// </summary>
        protected void LoadLookup() {
            using (UnitOfWork lookupRepository = new UnitOfWork()) {
                Helper.BindCollectionToControl(StateId, lookupRepository.Get_tlkp_State(true), "Id", "Description");
                Helper.BindCollectionToControl(CountryId, lookupRepository.Get_tlkp_Country(false), "Id", "Description");
                Helper.BindCollectionToControl(OperationType, lookupRepository.Get_tlkp_Procedure(false), "Id", "Description");

                Helper.BindCollectionToControl(FollowupPeriod, lookupRepository.Get_tlkp_FollowUpPeriod(true), "Id", "Description");
                Helper.BindCollectionToControl(FollowUpDiabetesStatus, lookupRepository.Get_tlkp_YesNoNotStated(true), "Id", "Description");

                Helper.BindCollectionToControl(FollowUpReOperation, lookupRepository.Get_tlkp_YesNo(true), "Id", "Description");
                Helper.BindCollectionToControl(FollowUpVitalStatus, lookupRepository.Get_tlkp_HealthStatus(true), "Id", "Description");
                Helper.BindCollectionToControl(DeathRelatedToPrimaryProcedure, lookupRepository.Get_tlkp_DeathRelatedToSurgery(true), "Id", "Description");
                Helper.BindCollectionToControl(FollowUpSentinelEvent, lookupRepository.Get_tlkp_SentinelEvent(false), "Id", "Description");
                Helper.BindCollectionToControl(FollowUpDiabetesTreatment, lookupRepository.Get_tlkp_DiabetesTreatment(false), "Id", "Description");
                Helper.BindCollectionToControl(FurtherInfoSlip, lookupRepository.Get_tlkp_ReasonSlip(true), "Id", "Description");
                Helper.BindCollectionToControl(FurtherInfoPort, lookupRepository.Get_tlkp_ReasonPort(true), "Id", "Description");
                Helper.BindCollectionToControl(DiabetesTreatment, lookupRepository.Get_tlkp_DiabetesTreatment(true), "Id", "Description");
                Helper.BindCollectionToControl(DiabetesStatus, lookupRepository.Get_tlkp_YesNoNotStated(true), "Id", "Description");

                Helper.BindCollectionToControl(BowelObstructionOptions, lookupRepository.Get_tlkp_ReasonBowelObstructionOperative(true), "Id", "Description");
            }
        }
        #endregion LoadLookup

        // Load Reason options from database to Dropdown control
        private void LoadReason() {
            using (UnitOfWork reasonRepository = new UnitOfWork()) {
                Helper.BindCollectionToControl(FollowUpReason, reasonRepository.GetReoperationReason(_procedureType), "Id", "Description");
            }
        }

        #region CustomValidation
        /// <summary>
        /// Validation for Diabetes treatment selection
        /// </summary>
        /// <param name="source">Diabetes treatment list</param>
        /// <param name="args">Event arguments</param>
        protected void ValidateDiabetesTreatment(object source, ServerValidateEventArgs args) {
            if (string.IsNullOrEmpty(FollowUpDiabetesTreatment.SelectedValue) && FollowUpDiabetesStatus.SelectedValue == "1") {
                args.IsValid = false;
                CustomValidatorDiabetesTreatment.ErrorMessage = "Diabetes treatment is a required field";
            } else {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validation for Lost to Followup date selection
        /// </summary>
        /// <param name="source">Followup LTFU Data control</param>
        /// <param name="args">Validation event arguments</param>
        protected void ValidateLostToFollowupDate(object source, ServerValidateEventArgs args) {
            if (IsAdminCentral || IsAdministrator) {
                if (LostToFollowUp.Checked && FollowUpLTFUDate.SelectedDate.HasValue) {
                    args.IsValid = true;
                } else {
                    args.IsValid = false;
                    CustomValidatorLosttoFollowupDate.ErrorMessage = "LTFU date is a required field";
                }
            }
        }

        /// <summary>
        /// Validation for Followup date
        /// </summary>
        /// <param name="source">Followup Date control</param>
        /// <param name="args">Validation event Argument</param>
        protected void ValidateFollowupDate(object source, ServerValidateEventArgs args) {
            if (FollowUpDate.SelectedDate.HasValue) {
                if (FollowUpDate.SelectedDate > DateTime.Today) {
                    CustomValidatorFollowupDate.ErrorMessage = "Follow-up date cannot be a future date. Please check Follow-up date";
                    args.IsValid = false;
                    return;
                } else if (FollowupPeriod.SelectedValue == "0" && OperationDate.SelectedDate.HasValue &&
                      (FollowUpDate.SelectedDate < OperationDate.SelectedDate.Value.AddDays(20)
                      || FollowUpDate.SelectedDate > OperationDate.SelectedDate.Value.AddMonths(3))) {
                    //All 30 day follow up must be between 20 to 62 days from Op date. 
                    CustomValidatorFollowupDate.ErrorMessage = "Follow-up date must be between 20 days to 3 months from the Operation date. Please check Follow-up date";
                    args.IsValid = false;
                    return;
                } else if (FollowupPeriod.SelectedValue != "" && FollowupPeriod.SelectedValue != "0" && OperationDate.SelectedDate.HasValue
                      && (FollowUpDate.SelectedDate < GetFromDate() || FollowUpDate.SelectedDate > GetToDate())) {
                    CustomValidatorFollowupDate.ErrorMessage = "Follow-up date must be between 3 months to 15 months from the follow up due date. Please check Follow-up date";
                    args.IsValid = false;
                    return;
                } else {
                    args.IsValid = true;
                    return;
                }
            } else {
                CustomValidatorFollowupDate.ErrorMessage = "Follow-up date is a required field";
                args.IsValid = false;
            }
        }

        // Calculate To Date automatically on the basis of From Date on the basis of Period selected
        private DateTime? GetToDate() {
            int period = Convert.ToInt32(FollowupPeriod.SelectedValue);
            DateTime toDate = OperationDate.SelectedDate.Value.AddYears(period).AddMonths(3);
            return toDate;
        }

        /// <summary>
        /// Calculates From Date Automatically on the basis of Period selected
        /// </summary>
        /// <returns></returns>
        private DateTime? GetFromDate() {
            int period = Convert.ToInt32(FollowupPeriod.SelectedValue);
            DateTime fromDate = OperationDate.SelectedDate.Value.AddYears(period).AddMonths(-9);
            return fromDate;
        }

        /// <summary>
        /// Validation for Followup Reason selection
        /// </summary>
        /// <param name="source">Followup Reason Selection control</param>
        /// <param name="args">Validation Event Arguments</param>
        protected void ValidateFollowupReason(object source, ServerValidateEventArgs args) {
            //Verify Sentinel Event is checked or not
            for (int i = 0; i < FollowUpSentinelEvent.Items.Count; i++) {
                if (FollowUpSentinelEvent.Items[i].Selected) {
                    _isSelected = true;
                }
            }

            //Verify ReOperation Selected or not
            if (FollowUpReOperation.SelectedIndex == 2 && FollowupPeriod.SelectedValue != "0") {
                _isSelected = true;
            }

            if (_isSelected == true) {
                //Follow Up Reason
                for (int j = 0; j < FollowUpReason.Items.Count; j++) {
                    if (FollowUpReason.Items[j].Selected) {
                        _isReasonIdSelected = true;
                        if (FollowUpReason.Items[j].Value == "27") {
                            _isOtherReasonSelected = true;
                        }

                        if (FollowUpReason.Items[j].Value == "1") {
                            _isProlapseOrSlipSelected = true;
                        }

                        if (FollowUpReason.Items[j].Value == "8") {
                            _isPortSelected = true;
                        }
                        if (FollowUpReason.Items[j].Value == "44") {
                            _isOperativeBowelObstructSelected = true;
                        }
                    }
                }

                //Reason is a required field
                if (_isReasonIdSelected == false) {
                    CustomValidatorFollowupReason.ErrorMessage = "Reason is a required field";
                    args.IsValid = false;
                    return;
                } else {
                    args.IsValid = true;
                }
            }
        }

        /// <summary>
        /// Validation for Prolapse details required
        /// </summary>
        /// <param name="source">Further Information selection</param>
        /// <param name="args">Validation event arguments</param>
        protected void ValidateFurtherInformationSlip(object source, ServerValidateEventArgs args) {
            if (_isProlapseOrSlipSelected == true && FurtherInfoSlip.SelectedIndex == 0) {
                CustomValidatorFurtherInformationSlip.ErrorMessage = "Further information (Prolapse/Slip) is a required field";
                args.IsValid = false;
                return;
            } else {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validation for Port Details required
        /// </summary>
        /// <param name="source">Further Information Port selection</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateFurtherInformationPort(object source, ServerValidateEventArgs args) {
            if (_isPortSelected == true && FurtherInfoPort.SelectedIndex == 0) {
                CustomValidatorFurtherInformationPort.ErrorMessage = "Further information (Port) is a required field";
                args.IsValid = false;
                return;
            } else {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validation for other reason required control
        /// </summary>
        /// <param name="source">Follow up Other information control</param>
        /// <param name="args">Validation event arguments</param>
        protected void ValidateFollowupOtherReason(object source, ServerValidateEventArgs args) {
            if (_isOtherReasonSelected == true && string.IsNullOrEmpty(FollowUpOther.Text)) {
                CustomValidatorFollowupOtherReason.ErrorMessage = "Other reason is a required field";
                args.IsValid = false;
                return;
            } else {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Validation for Period selection control
        /// </summary>
        /// <param name="source">Followup Period control</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateFollowupPeriod(object source, ServerValidateEventArgs args) {
            if (FollowupPeriod.SelectedIndex == 0) {
                CustomValidatorFollowPeriod.ErrorMessage = "Follow-up period is a required field";
                args.IsValid = false;
                return;
            } else {
                args.IsValid = true;
            }
        }

        protected void ValidateRelatedDeath(object source, ServerValidateEventArgs args) {
            args.IsValid = true;
            if (FollowUpVitalStatus.SelectedValue != "0") {
                if (string.IsNullOrEmpty(DeathRelatedToPrimaryProcedure.SelectedValue)) {
                    DeathRelatedValidator.ErrorMessage = "Death Related to Bariatric Procedure is a mandatory field";
                    args.IsValid = false;
                }
            }
        }


        /// <summary>
        /// Validation for Followup Date of Death control
        /// </summary>
        /// <param name="source">Folloup Date of Death control</param>
        /// <param name="args">Validation event arguments</param>
        protected void ValidateDateOfDeath(object source, ServerValidateEventArgs args) {
            if (FollowUpVitalStatus.SelectedValue != "0") {
                if (DateofDeathUnknown.Checked == true) {
                    args.IsValid = true;
                } else {
                    if (FollowUpDateOfDeath.SelectedDate.HasValue) {
                        DateTime? maxOperationDate = GetMaxOperationDate();
                        if (FollowUpDateOfDeath.SelectedDate > DateTime.Today) {
                            CustomValidatorDateofDeath.ErrorMessage = "Date of Death is out of range. Please check Date of Death";
                            args.IsValid = false;
                            return;
                        } else if (maxOperationDate != null && FollowUpDateOfDeath.SelectedDate < maxOperationDate) {
                            CustomValidatorDateofDeath.ErrorMessage = "An operation has been recorded for this patient after the Date of Death. Please check Date of Death";
                            args.IsValid = false;
                            return;
                        } else {
                            args.IsValid = true;
                            return;
                        }
                    } else {
                        CustomValidatorDateofDeath.ErrorMessage = "Date of Death is a required field";
                        args.IsValid = false;
                    }
                }
            }
        }

        /// Get the details of last operation performed
        private DateTime? GetMaxOperationDate() {
            SessionData sessiondata = GetSessionData();
            using (UnitOfWork patientOperationRepository = new UnitOfWork()) {
                DateTime? maxOperationDate = patientOperationRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == sessiondata.PatientId).Max(y => y.OpDate);
                return maxOperationDate;
            }
        }

        /// <summary>
        /// Validation for Diabetes status selection control
        /// </summary>
        /// <param name="source">Folloup Diabetes Status control</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateFollowupDiabetesStatus(object source, ServerValidateEventArgs args) {
            args.IsValid = true;
            if (!LostToFollowUp.Checked) {
                if (FollowUpDiabetesStatus.SelectedIndex == 0 && FollowupPeriod.SelectedValue != "0") {
                    CustomValidatorFollowupDiabetesStatus.ErrorMessage = "Diabetes status is a required field";
                    args.IsValid = false;
                }
            }
        }

        /// <summary>
        /// Validation for Folloup Revision Operation
        /// </summary>
        /// <param name="source">Followup Revision selection control</param>
        /// <param name="args">Validation event argument</param>
        protected void ValidateFollowupReoperation(object source, ServerValidateEventArgs args) {
            args.IsValid = true;
            if (!LostToFollowUp.Checked) {
                if (FollowUpReOperation.SelectedIndex == 0 && FollowupPeriod.SelectedValue != "0") {
                    CustomValidatorFollowupReopeation.ErrorMessage = "Re-operation is a required field";
                    args.IsValid = false;
                }
            }
        }

        /// <summary>
        /// Validation for Followup Patient Weight control
        /// </summary>
        /// <param name="source">Followup Weight control</param>
        /// <param name="args">Validation event arguments</param>
        protected void ValidateFollowupPatientWeight(object source, ServerValidateEventArgs args) {
            if ((!(string.IsNullOrEmpty(FollowUpPatientWeight.Text)))
                && (FollowupPatientWeightUnknown.Checked == false)
                && ((LostToFollowUp.Checked == false) || (RecommendedLostToFollowUp.Checked == false))) {
                decimal patientWeight = 0;
                if (decimal.TryParse(FollowUpPatientWeight.Text, out patientWeight)) {
                    if ((patientWeight < 35) || (patientWeight > 600)) {
                        FollowUpPatientWeightWarning.Text = "Patient weight (kg) is out of range (35kg - 600kg). Please review and amend";
                        args.IsValid = false;
                    } else if ((patientWeight > 200) && (patientWeight < 600)) {
                        FollowUpPatientWeightWarning.Text = "A weight of over 200kg  has been entered. Please confirm this is correct";
                        args.IsValid = true;
                    } else {
                        args.IsValid = true;
                    }
                } else { CustomValidatorFollowUpPatientWeight.ErrorMessage = "Patient weight (kg) is a required field"; args.IsValid = false; }

            } else if ((LostToFollowUp.Checked == true) || (RecommendedLostToFollowUp.Checked == true)) { args.IsValid = true; } else if (FollowupPatientWeightUnknown.Checked) { args.IsValid = true; } else { CustomValidatorFollowUpPatientWeight.ErrorMessage = "Patient weight (kg) is a required field"; args.IsValid = false; }
        }

        protected void ValidateBowelObstruction(object source, ServerValidateEventArgs args) {
            if (_isOperativeBowelObstructSelected && BowelObstructionOptions.SelectedIndex == 0) {
                CustomValidatorBowelObstructionOperative.ErrorMessage = "Bowel Obstruction Further Detail is a required field";
                args.IsValid = false;
            } else {
                args.IsValid = true;
            }
            return;
        }
        #endregion

        #region Events
        /// <summary>
        /// Saving data of Followup
        /// </summary>
        /// <param name="sender">Save Button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void SaveClicked(object sender, EventArgs e) {
            _formSaved = SaveData(true);
            if (_formSaved) {
                LoadLookup();
                InitData();
                ShowingFormSavedMessage();
                ShowHideControls();

                RedirectBack();
            }
        }

        /// <summary>
        /// Redirect to previous page
        /// </summary>
        /// <param name="sender">Back button as sender</param>
        /// <param name="e">Event argument</param>
        protected void BackClicked(object sender, EventArgs e) {
            RedirectBack(true);
        }

        /// <summary>
        /// Submit followup data for validation
        /// </summary>
        /// <param name="sender">Submit button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void SubmitButtonClicked(object sender, System.EventArgs e) {
            if (Page.IsValid == true) {
                _formSaved = SaveData(false);
                if (_formSaved) {
                    FollowUpFormPanel.Visible = false;
                    ButtonsPanel.Visible = false;
                    //auditForm.Visible = false;
                    ShowingFormSavedMessage(true);
                    RedirectBack();
                }
            }
        }

        // Redirect page to the previous page
        private void RedirectBack(bool CancelCalled = false) {
            SessionData sessionData = GetSessionData();
            String previousPage = sessionData.PreviousPagePatient;

            if (sessionData.IsSurgeonDashboardToReturn) {
                Response.Redirect(Properties.Resource2.SurgeonHome);
            } else {

                //Check if there are any followups remaining in an incomplete state
                //before redirecting
                if (CancelCalled || !HasIncompleteFollowups()) {
                    if (sessionData.IsRedirectedFromCallScreen) {
                        Response.Redirect(Properties.Resource2.CallCenterWorkList);
                    } else {
                        Response.Redirect(Properties.Resource2.MissingDataWorkList);
                    }
                } else {
                    FollowUpGrid.Rebind();
                }
            }
        }

        private bool HasIncompleteFollowups() {
            SessionData sessionData = GetSessionData();
            using (UnitOfWork reasonRepository = new UnitOfWork()) {
                if (FollowUpGrid.Visible) {
                    if (reasonRepository.tbl_FollowUpRepository.Get(x => x.PatientId == sessionData.PatientId && (x.FUVal == 0 || x.FUVal == 1)).Count() > 0) {
                        NotificationMessage.Visible = true;
                        NotificationMessage.Text = "Please complete all follow ups";
                        return true;
                    }
                }
            }
            return false;
        }


        // Display Save message on the screen
        private void ShowingFormSavedMessage(bool isSubmit = false) {
            if (IsAdminCentral || IsAdministrator) {
                ((Label)SuccessNotification).Visible = _formSaved;
                ((Label)NotificationMessage).Visible = false;
            }

            if (IsSurgeon || IsDataCollector) {
                ((Label)SuccessNotification).Visible = false;
                ((Label)NotificationMessage).Visible = false;
            }

            if (isSubmit == true) {
                ((Label)SuccessNotification).Visible = false;
                ((Label)NotificationMessage).Visible = _formSaved;
            }

            if (_formSaved) {
                if ((IsAdminCentral || IsAdministrator) && (isSubmit == false)) { ((Label)SuccessNotification).Text = "Data has been saved - " + DateTime.Now.ToString(); }

                if (IsAdminCentral || IsAdministrator || isSubmit == true) { ((Label)NotificationMessage).Text = "Data has been validated - " + DateTime.Now.ToString(); }

                _formSaved = false;
            }
        }
        #endregion

        #region ShowHideControls
        // Show and hide controls as per the logged in user
        private void ShowHideControls() {
            if (IsAdministrator || IsAdminCentral) {
                FollowUpGrid.Visible = true;
            } else {
                FollowUpGrid.Visible = false;
            }

            if (FollowupPeriod.SelectedValue == "0") {
                Panel30Days.Style.Add(HtmlTextWriterStyle.Display, "block");
                YearTo10YearsPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            } else {
                Panel30Days.Style.Add(HtmlTextWriterStyle.Display, "none");
                YearTo10YearsPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
            }
        }

        // Check if any reason is selected or not
        private bool IsReasonSelected(string Id) {
            foreach (ListItem listItem in FollowUpReason.Items) {
                if (listItem.Value == Id && listItem.Selected) { return true; }
            }

            return false;
        }

        // Show or hide panels of controls
        private void ShowHidePanel() {
            if (IsAdminCentral || IsAdministrator) {
                CDMSValidation.SetControlVisible(LostToFollowupPanel, RecommendedLostToFollowUp.Checked);
                CDMSValidation.SetControlVisible(RecommendedLTFUReasonPanel, RecommendedLostToFollowUp.Checked);
            } else {
                CDMSValidation.SetControlVisible(FollowupOptionsPanel, !(RecommendedLostToFollowUp.Checked));
                LostToFollowupPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                LostToFollowupDatePanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            }

            CDMSValidation.SetControlVisible(LostToFollowupDatePanel, LostToFollowUp.Checked);
            FollowUpBMI.Enabled = false;
            CDMSValidation.SetControlVisible(DiabetesTreatmentPanel, FollowUpDiabetesStatus.SelectedValue == "1" && FollowupPeriod.SelectedValue != "0");
            CDMSValidation.SetControlVisible(DeathPanel, FollowUpVitalStatus.SelectedValue == "1");

            bool showReason = FollowUpSentinelEvent.SelectedValue == "1" || FollowUpSentinelEvent.SelectedValue == "2" || FollowUpSentinelEvent.SelectedValue == "3" || FollowUpReOperation.SelectedValue == "1";
            bool showSlipPanel = IsReasonSelected("1");
            bool showPanelPort = IsReasonSelected("8");
            bool showPanelOther = IsReasonSelected("27");
            bool showBowelOperation = IsReasonSelected("44");

            CDMSValidation.SetControlVisible(FurtherInformationSlipPanel, showSlipPanel && showReason);
            CDMSValidation.SetControlVisible(PortPanel, showPanelPort && showReason);
            CDMSValidation.SetControlVisible(OtherReasonPanel, showPanelOther && showReason);
            CDMSValidation.SetControlVisible(FurtherInformationPanel, (showPanelOther || showPanelPort || showSlipPanel || showBowelOperation) && showReason);
            CDMSValidation.SetControlVisible(BowelObstructionOperative, showBowelOperation);

            //CDMSValidation - is not working for checkboxlist
            if (showReason) {
                FollowupReasonPanel.Style.Add(HtmlTextWriterStyle.Display, "display");
            } else {
                UncheckAllReasons();
                FollowupReasonPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            }
        }

        // Hiding Folloup forms and other controls
        private void HideFUP() {
            FollowUpFormPanel.Visible = false;
            ButtonsPanel.Visible = false;
            auditForm.Visible = false;
        }

        // Showing or Hiding Save button as per the User role of logged in user
        private void AdminSurgeonFeatures() {
            if (IsSurgeon || IsDataCollector) {
                SaveButton.Visible = false;
            } else {
                if (GetValidateValue() == 2) { SaveButton.Visible = false; } else { SaveButton.Visible = true; }
            }
        }

        // Validating whether Save button should be available or not for user
        private int GetValidateValue() {
            int validateValue = 0;
            SessionData sessionData = GetSessionData();
            if (sessionData.FollowUpId != null && sessionData.FollowUpId != 0) {
                using (UnitOfWork followupRepository = new UnitOfWork()) {
                    int followUpId = sessionData.FollowUpId;
                    tbl_FollowUp followUp = followupRepository.tbl_FollowUpRepository.Get(x => x.FUId == followUpId).FirstOrDefault();
                    if (followUp != null) {
                        if (followUp.FUVal != null) {
                            validateValue = ((int)followUp.FUVal);
                        }
                    }
                }
            }

            return validateValue;
        }
        #endregion

        #region SaveData
        /// <summary>
        /// Calculate Body Mass Index of the patient
        /// </summary>
        /// <param name="weight">Patient Weight</param>
        /// <param name="patientHeight">Patient Height</param>
        /// <returns>Returns BMI for the patient</returns>
        public decimal CalculateBMI(decimal? patientWeight, decimal? patientHeight) {
            decimal height = patientHeight == null ? 0 : (decimal)patientHeight;
            decimal weight = patientWeight == null ? 0 : (decimal)patientWeight;
            if (height == 0) { return 0; } else { return Math.Round((weight / (height * height)), 1); }
        }

        /// <summary>
        /// Save the data in the database
        /// </summary>
        /// <param name="isSave">Flag that determine whether or not to save the data in the database</param>
        /// <returns>Returns a flag indicating whether data is saved in the db or not</returns>
        protected bool SaveData(bool isSave = false) {
            SessionData sessionData = GetSessionData();
            Boolean isNew = false;
            Boolean isDataSaved = false;

            try {
                tbl_FollowUp followUp;
                bool isLTFUAlreadyRecommended = false;
                tbl_Patient patient;
                tbl_PatientOperation patientOperation;
                List<tbl_PatientComplications> followUpComplications = new List<tbl_PatientComplications>();//Followup Complications
                List<tbl_PatientComplications> operatationComplications = new List<tbl_PatientComplications>();//Operation Complications
                int followUpId;
                decimal Height = 0;
                decimal weight = 0;

                using (UnitOfWork dataRepository = new UnitOfWork()) {
                    #region Get followup details
                    if (sessionData.FollowUpId != null && sessionData.FollowUpId != 0) {
                        followUpId = sessionData.FollowUpId;
                        //follow up data item
                        followUp = dataRepository.tbl_FollowUpRepository.Get(x => x.FUId == followUpId).FirstOrDefault();
                        //Operation data Item
                        patientOperation = dataRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == sessionData.PatientId && x.OpId == followUp.OperationId).FirstOrDefault();
                        operatationComplications = dataRepository.tbl_PatientComplicationsRepository.Get(x => x.OpId == followUp.OperationId).ToList();
                        if (operatationComplications == null) {
                            followUpComplications = dataRepository.tbl_PatientComplicationsRepository.Get(x => x.FuId == followUpId).ToList();
                        }
                    } else {
                        //follow up data item
                        followUp = dataRepository.tbl_FollowUpRepository.Get(x => x.PatientId == sessionData.PatientId && x.OperationId == sessionData.PatientOperationId && x.FUPeriodId == sessionData.FollowUpPeriodId).FirstOrDefault(); //sessionData.PatientId
                        //Operation data Item
                        patientOperation = dataRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == sessionData.PatientId && x.OpId == sessionData.PatientOperationId).FirstOrDefault();
                        operatationComplications = dataRepository.tbl_PatientComplicationsRepository.Get(x => x.OpId == sessionData.PatientOperationId).ToList();
                        if (operatationComplications == null) {
                            if (followUp != null && followUp.FUId != null) { followUpComplications = dataRepository.tbl_PatientComplicationsRepository.Get(x => x.FuId == followUp.FUId).ToList(); }
                        }

                    }
                    #endregion

                    //If null create new
                    if (followUp == null) {
                        followUp = new tbl_FollowUp();
                        isNew = true;
                    } else {
                        isLTFUAlreadyRecommended = followUp.BSR_to_Follow_Up == null ? false : Convert.ToBoolean(followUp.BSR_to_Follow_Up);
                    }

                    #region Get Operation details and site details
                    patient = dataRepository.tbl_PatientRepository.Get(x => x.PatId == sessionData.PatientId).FirstOrDefault();
                    //Get operation id and site details from operation data item
                    if (patientOperation != null && patientOperation.OpId != null) {
                        followUp.OperationId = patientOperation.OpId;
                        Height = patientOperation.Ht == null ? 0 : Convert.ToDecimal(patientOperation.Ht);
                    }
                    #endregion

                    #region Update follow up table
                    //Update follow up details to follow up table
                    followUp.PatientId = sessionData.PatientId;
                    followUp.FUDate = FollowUpDate.SelectedDate;
                    followUp.FUPeriodId = Helper.ToNullable<System.Int32>(FollowupPeriod.SelectedValue);
                    followUp.LTFU = (LostToFollowUp.Checked);
                    followUp.LTFUDate = FollowUpLTFUDate.SelectedDate;
                    followUp.FUWt = Helper.ToNullable<System.Decimal>(FollowUpPatientWeight.Text);
                    weight = FollowUpPatientWeight.Text == string.Empty ? 0 : Convert.ToDecimal(FollowUpPatientWeight.Text);
                    followUp.FUBMI = CalculateBMI(weight, Height);
                    followUp.SelfRptWt = (FollowUpSelfReportedWeight.Checked);
                    followUp.PatientFollowUpNotKnown = (FollowupPatientWeightUnknown.Checked);

                    if (FollowUpSentinelEvent.Items[0].Selected == true) {
                        followUp.SEId1 = FollowUpSentinelEvent.Items[0].Selected;
                    } else {
                        followUp.SEId1 = null;
                    }

                    if (FollowUpSentinelEvent.Items[1].Selected == true) {
                        followUp.SEId2 = FollowUpSentinelEvent.Items[1].Selected;
                    } else {
                        followUp.SEId2 = null;
                    }

                    if (FollowUpSentinelEvent.Items[2].Selected == true) {
                        followUp.SEId3 = FollowUpSentinelEvent.Items[2].Selected;
                    } else {
                        followUp.SEId3 = null;
                    }

                    followUp.DiabStatId = Helper.ToNullable<System.Int32>(FollowUpDiabetesStatus.SelectedValue);
                    followUp.DiabRxId = Helper.ToNullable<System.Int32>(FollowUpDiabetesTreatment.SelectedValue);
                    followUp.ReOpStatId = Helper.ToNullable<System.Int32>(FollowUpReOperation.SelectedValue);
                    followUp.Othinfo = Comments.Text;
                    followUp.BSR_to_Follow_Up = RecommendedLostToFollowUp.Checked;
                    #endregion


                    if (isSave == true) {
                        followUp.FUVal = 1;
                    } else {
                        //As only the admin apparently gets the save button on the screen, can't have the submit triggering
                        //the complete if not an admin
                        if (!(IsAdministrator || IsAdminCentral) && RecommendedLostToFollowUp.Checked) {
                            followUp.FUVal = 1;
                        } else {
                            followUp.FUVal = 2;
                        }
                    }

                    if (isNew) {
                        followUp.CreatedBy = UserName;
                        followUp.CreatedDateTime = System.DateTime.Now;
                        followUp.LastUpdatedBy = UserName;
                        followUp.LastUpdatedDateTime = System.DateTime.Now;
                        dataRepository.tbl_FollowUpRepository.Insert(followUp);
                    } else {
                        followUp.LastUpdatedBy = UserName;
                        followUp.LastUpdatedDateTime = System.DateTime.Now;
                        dataRepository.tbl_FollowUpRepository.Update(followUp);
                    }

                    followUp.FurtherInfoSlip = null;
                    followUp.FurtherInfoPort = null;

                    if (followUp.SEId1 == true || followUp.SEId2 == true || followUp.SEId3 == true || followUp.ReOpStatId == 1 || followUp.FUVal == 2) {
                        List<tbl_PatientComplications> followupComplications = dataRepository.tbl_PatientComplicationsRepository.Get(x => x.FuId == followUp.FUId).ToList<tbl_PatientComplications>();
                        foreach (ListItem item in FollowUpReason.Items) {
                            bool updateExtraInfo = false;

                            var z = followupComplications.FirstOrDefault(x => x.ComplicationId.ToString() == item.Value);
                            if (z != null) {
                                if (!item.Selected) {
                                    dataRepository.tbl_PatientComplicationsRepository.Delete(z);
                                } else {
                                    updateExtraInfo = true;
                                }

                            } else {
                                if (item.Selected) {
                                    tbl_PatientComplications patientComplication = new tbl_PatientComplications();
                                    patientComplication.FuId = followUp.FUId;
                                    patientComplication.ComplicationId = Helper.ToNullable<System.Int32>(item.Value);
                                    dataRepository.tbl_PatientComplicationsRepository.Insert(patientComplication);
                                    updateExtraInfo = true;
                                }
                            }
                            if (updateExtraInfo) {
                                switch (item.Value) {
                                    case "1":
                                        followUp.FurtherInfoSlip = Helper.ToNullable<System.Int32>(FurtherInfoSlip.SelectedValue);
                                        break;
                                    case "8":
                                        followUp.FurtherInfoPort = Helper.ToNullable<System.Int32>(FurtherInfoPort.SelectedValue);
                                        break;
                                    case "27":
                                        followUp.ReasonOther = FollowUpOther.Text;
                                        break;
                                    case "44":
                                        followUp.OpBowelObsID = Helper.ToNullable<System.Int32>(BowelObstructionOptions.SelectedValue);
                                        break;
                                }
                            }
                        }
                    }

                    #region Update patient table
                    //Details from Follow up form that is updated to patient table
                    if (patient != null) {
                        patient.DateDeath = FollowUpDateOfDeath.SelectedDate;
                        patient.DateDeathNotKnown = (DateofDeathUnknown.Checked);
                        patient.CauseOfDeath = FollowUpCauseOfDeath.Text;
                        patient.DeathRelSurgId = Helper.ToNullable<System.Int32>(DeathRelatedToPrimaryProcedure.SelectedValue);
                        if (LostToFollowUp.Checked) {
                            //Setting Opt Off Statue as LTFU which is 4
                            patient.OptOffStatId = 4;
                            patient.OptOffDate = DateTime.Now;
                        }

                        patient.HStatId = (FollowUpVitalStatus.SelectedValue == null || FollowUpVitalStatus.SelectedValue == string.Empty) ? 0 : Helper.ToNullable<System.Int32>(FollowUpVitalStatus.SelectedValue);

                        if (patient.HStatId == 0) {
                            patient.DeathRelSurgId = null;
                        } else {
                            if (string.IsNullOrEmpty(DeathRelatedToPrimaryProcedure.SelectedValue)) {
                                patient.DeathRelSurgId = 0;
                                return false;
                            } else {
                                patient.DeathRelSurgId = Helper.ToNullable<System.Int32>(DeathRelatedToPrimaryProcedure.SelectedValue);
                            }
                        }

                        dataRepository.tbl_PatientRepository.Update(patient);
                    }


                    //MB:159: Set the call to be answered if the followup has been completed
                    if (sessionData.IsRedirectedFromCallScreen && followUp.FUVal == 2 && !(bool)followUp.LTFU) {
                        tbl_FollowUpCall CurrentCall = dataRepository.tbl_FollowUpCallRepository.Get(x => x.FollowUpId == sessionData.FollowUpId).FirstOrDefault();
                        if (CurrentCall != null) {
                            if (CurrentCall.CallOne == null || CurrentCall.CallOne == 0) {
                                CurrentCall.CallOne = 4;
                            } else if (CurrentCall.CallTwo == null || CurrentCall.CallTwo == 0) {
                                CurrentCall.CallTwo = 4;
                            } else if (CurrentCall.CallThree == null || CurrentCall.CallThree == 0) {
                                CurrentCall.CallThree = 4;
                            } else if (CurrentCall.CallFour == null || CurrentCall.CallFour == 0) {
                                CurrentCall.CallFour = 4;
                            } else if (CurrentCall.CallFive == null || CurrentCall.CallFive == 0) {
                                CurrentCall.CallFive = 4;
                            }
                            dataRepository.tbl_FollowUpCallRepository.Update(CurrentCall);
                        }
                    }


                    dataRepository.Save();
                    #endregion

                    #region Send email
                    //Send mail to administrator - if there are no reoperations recorded for this patient in the system & First time they submit the Followup Id
                    if (FollowUpReOperation.SelectedValue == "1"
                        && sessionData.FollowUpId == 0
                        && ConfigurationManager.AppSettings["SENDMAIL"].ToString().ToUpper() == "TRUE") {
                        //Check if revision exists
                        bool revisionExists = DoesRevisionExist_1year(FollowUpDate.SelectedDate);
                        //If Revision does not exist and reoperation is selected as "Yes"
                        if (revisionExists == false && patient != null) {
                            sendReOperationEmailToAdmin(patient.FName, patient.LastName, patient.DOB != null ? patient.DOB.Value.ToString("dd/MM/yyyy") : string.Empty, (followUp.FUDate == null ? DateTime.Today : (DateTime)followUp.FUDate), followUp.FUId);
                        }
                    }

                    //Send mail to administrator - if recommended LTFU is set for the first time 
                    if (isLTFUAlreadyRecommended == false
                        && followUp.BSR_to_Follow_Up == true
                        && ConfigurationManager.AppSettings["SENDMAIL"].ToString().ToUpper() == "TRUE") {
                        SendRecommendedLTFUEmailToAdmin(patient.FName, patient.LastName, patient.DOB != null ? patient.DOB.Value.ToString("dd/MM/yyyy") : string.Empty, followUp.FUId);
                    }
                    #endregion

                    if ((sessionData.FollowUpId != null) && (isSave == false)) {
                        sessionData.FollowUpId = 0;
                    } else if (isSave == true) {
                        sessionData.FollowUpId = followUp.FUId;
                    }
                    //resetting session details 
                    sessionData.PatientOperationId = -1;
                    sessionData.FollowUpPeriodId = -1;
                    SaveSessionData(sessionData);
                }
                isDataSaved = true;
            } catch (Exception ex) {
                DisplayCustomMessageInValidationSummary(ex.Message.ToString(), "FollowUpDataValidationGroup");
                isDataSaved = false;
            }
            return isDataSaved;
        }

        // Check if Revision exist in 1 year time period
        private bool DoesRevisionExist_1year(DateTime? followupDate) {
            DateTime? fupDate;
            using (UnitOfWork patientOperationRepository = new UnitOfWork()) {
                if (followupDate == null) {
                    fupDate = DateTime.Now;
                } else {
                    fupDate = followupDate;
                }

                if (fupDate != null) {
                    SessionData sessionData = GetSessionData();
                    DateTime lastYearDate = fupDate.Value.AddYears(-1);
                    tbl_PatientOperation pto_dataItems = patientOperationRepository.tbl_PatientOperationRepository.Get(x => x.PatientId == sessionData.PatientId && x.OpDate < fupDate && x.OpDate > lastYearDate && x.OpStat == 1).FirstOrDefault();
                    if (pto_dataItems == null) { return false; } else { return true; }
                }
            }
            return false;
        }

        #region Email

        // Sending a mail to admin regarding recommended LTFU
        private void SendRecommendedLTFUEmailToAdmin(string firstName, string lastName, string birthDate, int followUpId) {
            string errorMessage = string.Empty;
            try {
                System.Net.Mail.MailMessage emailMessage = new System.Net.Mail.MailMessage();
                emailMessage.To.Clear();
                emailMessage.To.Add(new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["LTFU_EMAIL"].ToString()));
                emailMessage.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["EMAIL_PROJECT"].ToString());
                emailMessage.To.Add("jigyasa.sharma@monash.edu");
                emailMessage.Subject = ConfigurationManager.AppSettings["PROJECT_NAME"].ToString() + ": " + Properties.Resource2.RecordReoperationDetails;
                emailMessage.IsBodyHtml = false;

                //Open a file for reading
                String fileName = Server.MapPath(Constants.URL_EMAIL_TEMPLATE_RECOMMENDED_LTFU);
                StreamReader fileStreamReader = File.OpenText(fileName);

                //Now, read the entire file into a string
                String emailMessageBodyContents = fileStreamReader.ReadToEnd();
                fileStreamReader.Close();
                fileStreamReader.Dispose();
                emailMessage.Body = emailMessageBodyContents;
                emailMessage.Body = emailMessage.Body.Replace("<%PatientFirstName%>", firstName);
                emailMessage.Body = emailMessage.Body.Replace("<%PatientLastName%>", lastName);
                emailMessage.Body = emailMessage.Body.Replace("<%DOB%>", birthDate);
                emailMessage.Body = emailMessage.Body.Replace("<%FollowupID%>", followUpId.ToString());

                System.Net.Mail.SmtpClient mailClient = new System.Net.Mail.SmtpClient();
                // need to be true for some server to receive email
                mailClient.UseDefaultCredentials = true;
                mailClient.Send(emailMessage);
            } catch (Exception ex) {
                errorMessage = ex.Message.ToString();
                logger.Error(ex.Message.ToString());
                logger.Error(ex.StackTrace);
            }
        }

        // Sending a mail to admin regarding Operation
        private void sendReOperationEmailToAdmin(string firstName, string lastName, string birthDate, DateTime followUpDueDate, int followUpId) {
            string errorMessage = string.Empty;
            try {
                System.Net.Mail.MailMessage emailMessage = new System.Net.Mail.MailMessage();
                emailMessage.To.Clear();
                emailMessage.To.Add(new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["EMAIL_PROJECT"].ToString()));
                emailMessage.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["EMAIL_PROJECT"].ToString());
                emailMessage.Subject = ConfigurationManager.AppSettings["PROJECT_NAME"].ToString() + ": " + Properties.Resource2.RecordReoperationDetails;
                emailMessage.IsBodyHtml = false;

                //Open a file for reading
                String fileName = Server.MapPath(Constants.URL_EMAIL_TEMPLATE_REOPERATION_NOTFOUND);
                StreamReader fileStreamReader = File.OpenText(fileName);

                //Now, read the entire file into a string
                String emailMessageBodyContents = fileStreamReader.ReadToEnd();
                fileStreamReader.Close();
                fileStreamReader.Dispose();
                emailMessage.Body = emailMessageBodyContents;
                emailMessage.Body = emailMessage.Body.Replace("<%PatientFirstName%>", firstName);
                emailMessage.Body = emailMessage.Body.Replace("<%PatientLastName%>", lastName);
                emailMessage.Body = emailMessage.Body.Replace("<%DOB%>", birthDate);
                emailMessage.Body = emailMessage.Body.Replace("<%PastDate%>", followUpDueDate.AddYears(-1).ToString("dd/MM/yyyy"));
                emailMessage.Body = emailMessage.Body.Replace("<%CurrentDate%>", followUpDueDate.ToString("dd/MM/yyyy"));
                emailMessage.Body = emailMessage.Body.Replace("<%FollowupID%>", followUpId.ToString());

                System.Net.Mail.SmtpClient mailClient = new System.Net.Mail.SmtpClient();
                // need to be true for some server to receive email
                mailClient.UseDefaultCredentials = true;
                mailClient.Send(emailMessage);
            } catch (Exception ex) {
                errorMessage = ex.Message.ToString();
                logger.Error(ex.Message.ToString());
                logger.Error(ex.StackTrace);
            }
        }
        #endregion

        #endregion

        #region GridEvents
        /// <summary>
        /// Load data in the Followup Grid
        /// </summary>
        /// <param name="sender">Followup Grid as sender</param>
        /// <param name="e">event arguments</param>
        protected void FollowUpGrid_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e) {
            using (UnitOfWork followupRepository = new UnitOfWork()) {
                SessionData sessionData = GetSessionData();
                FollowUpGrid.DataSource = followupRepository.FollowUpRepository.GetPatientFollowUpDetailsList(sessionData.PatientId);
                if (!(IsAdministrator || IsAdminCentral)) {
                    (FollowUpGrid.MasterTableView.GetColumn("FUStatusLabel") as GridBoundColumn).Display = false;
                }
            }
        }

        /// <summary>
        /// Handling Grid commands
        /// </summary>
        /// <param name="sender">Followup Grid as sender</param>
        /// <param name="e">Grim Command event arguments</param>
        protected void FollowUpGrid_ItemCommand(object sender, GridCommandEventArgs e) {
            switch (e.CommandName) {
                case "Select":
                    SessionData sessionData = GetSessionData();
                    sessionData.FollowUpId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FollowUpID"]);
                    FollowUpFormPanel.Visible = true;
                    ButtonsPanel.Visible = true;
                    auditForm.Visible = true;
                    NotificationMessage.Visible = false;
                    InitData();
                    ShowHideControls();
                    ShowHidePanel();
                    AdminSurgeonFeatures();
                    break;

                default:
                    break;
            }
        }
        #endregion GridEvents

        #region CustomValidators Prerender
        /// <summary>
        /// Prerender event handler for Followup Grid - Recommended Lost to FollowUp
        /// </summary>
        /// <param name="sender">Followup Grid as sender</param>
        /// <param name="e">Event argument</param>
        protected void RecommendedLostToFollowUp_PreRender(object sender, System.EventArgs e) {
            SessionData sessionData = GetSessionData();
            String clientVisibleCriteria = String.Empty;
            String clientVisibleCriteria1 = String.Empty;
            String clientVisibleCriteria2 = String.Empty;
            String javaScriptToInject = String.Empty;

            if (sessionData.FollowUpId == 0 || sessionData.FollowUpId == null) { javaScriptToInject += "document.getElementById('" + FollowUpVitalStatus.ClientID + "').value = 0;"; }

            javaScriptToInject += "document.getElementById('" + FollowUpBMI.ClientID + "').disabled = true;";
            clientVisibleCriteria1 = "document.getElementById('" + RecommendedLostToFollowUp.ClientID + "').checked == true";
            javaScriptToInject += CDMSValidation.EnablePanelInjectJS(clientVisibleCriteria1, RecommendedLTFUReasonPanel, (CheckBox)RecommendedLostToFollowUp);

            if (IsAdministrator || IsAdminCentral) {
                clientVisibleCriteria2 = "document.getElementById('" + RecommendedLostToFollowUp.ClientID + "').checked == true";
                javaScriptToInject += CDMSValidation.EnablePanelInjectJS(clientVisibleCriteria2, LostToFollowupPanel, (CheckBox)RecommendedLostToFollowUp);
            } else {
                clientVisibleCriteria = "document.getElementById('" + RecommendedLostToFollowUp.ClientID + "').checked == false";
                CDMSValidation.EnablePanelInjectJS(clientVisibleCriteria, FollowupOptionsPanel, (CheckBox)RecommendedLostToFollowUp, javaScriptToInject);
            }
        }

        /// <summary>
        /// Prerender event handler for Followup Grid - Lost to Followup
        /// </summary>
        /// <param name="sender">Followup Grid as sender</param>
        /// <param name="e">Event Argument</param>
        protected void LostToFollowUp_PreRender(object sender, System.EventArgs e) {
            if (IsAdminCentral || IsAdministrator) {
                String ClientVisibleCriteria1 = String.Empty;
                String javaScriptToInject = String.Empty;

                ClientVisibleCriteria1 = "document.getElementById('" + LostToFollowUp.ClientID + "').checked == true";
                javaScriptToInject = CDMSValidation.EnablePanelInjectJS(ClientVisibleCriteria1, LostToFollowupDatePanel, (CheckBox)LostToFollowUp);
            }
        }

        /// <summary>
        /// Prerender event handler for Followup Grid - Vital Status
        /// </summary>
        /// <param name="sender">Followup Grid as sender</param>
        /// <param name="e">Event Argument</param>
        protected void FollowUpVitalStatus_PreRender(object sender, System.EventArgs e) {
            String ClientVisibleCriteria = String.Empty;
            ClientVisibleCriteria = "document.getElementById('" + FollowUpVitalStatus.ClientID + "').value == '1'";
            CDMSValidation.EnablePanelInjectJS(ClientVisibleCriteria, DeathPanel, (DropDownList)FollowUpVitalStatus);
        }

        /// <summary>
        /// Prerender event handler for Followup Grid - Diabetes Status
        /// </summary>
        /// <param name="sender">Follow Grid as sender</param>
        /// <param name="e">Event argument</param>
        protected void FollowUpDiabetesStatus_PreRender(object sender, System.EventArgs e) {
            String ClientVisibleCriteria = String.Empty;
            ClientVisibleCriteria = "document.getElementById('" + FollowUpDiabetesStatus.ClientID + "').value == '1'";
            CDMSValidation.EnablePanelInjectJS(ClientVisibleCriteria, DiabetesTreatmentPanel, (DropDownList)FollowUpDiabetesStatus);
        }
        #endregion CustomValidators Prerender
    }
}