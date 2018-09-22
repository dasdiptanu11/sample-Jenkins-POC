using App.Business;
using System;
using System.Collections.Generic;
using System.Data.Objects.SqlClient;
using System.Linq;


namespace App.UI.Web
{
    public class OperationHandler
    {

        private static Helper _helper = new Helper();
        protected static Helper Helper
        {
            get
            {
                if (_helper == null)
                {
                    _helper = new Helper();
                }
                return _helper;
            }
        }

        // Delete Followup and Complications
        public static void DeleteFollowupAndComplications(UnitOfWork patientRepository, IEnumerable<tbl_FollowUp> listFollowUps)
        {
            foreach (tbl_FollowUp followUp in listFollowUps)
            {
                //Get all annual compliactions delete
                IEnumerable<tbl_PatientComplications> followUpComplications = patientRepository.tbl_PatientComplicationsRepository.Get(x => x.FuId == followUp.FUId);
                foreach (tbl_PatientComplications complication in followUpComplications)
                {
                    patientRepository.tbl_PatientComplicationsRepository.Delete(complication);
                }

                //This will remove the follow up call records to allow for referential integrity rules
                foreach (tbl_FollowUpCall currentCall in patientRepository.tbl_FollowUpCallRepository.Get(x => x.FollowUpId == followUp.FUId))
                {
                    patientRepository.tbl_FollowUpCallRepository.Delete(currentCall);
                }

                patientRepository.Save();

                patientRepository.tbl_FollowUpRepository.Delete(followUp);
                patientRepository.Save();
            }
        }

        // Delete FollowUp Complications for an operation
        public static void DeleteFollowupComplications(UnitOfWork followUpRepository, Int32 operationId)
        {
            IEnumerable<tbl_FollowUp> operationFollowUps = followUpRepository.tbl_FollowUpRepository.Get(x => x.OperationId == operationId && x.FUVal != 2);
            foreach (tbl_FollowUp followUp in operationFollowUps)
            {
                //Get all annual compliactions delete
                IEnumerable<tbl_PatientComplications> followUpComplications = followUpRepository.tbl_PatientComplicationsRepository.Get(x => x.FuId == followUp.FUId);
                foreach (tbl_PatientComplications complication in followUpComplications)
                {
                    followUpRepository.tbl_PatientComplicationsRepository.Delete(complication);
                }
                followUpRepository.Save();
            }
        }

        // Delete Operation Complications
        public static void DeleteOperationComplications(UnitOfWork patientRepository, Int32 operationId)
        {
            IEnumerable<tbl_PatientComplications> operationComplications = patientRepository.tbl_PatientComplicationsRepository.Get(x => x.OpId == operationId && x.FuId == null);
            foreach (tbl_PatientComplications complication in operationComplications)
            {
                patientRepository.tbl_PatientComplicationsRepository.Delete(complication);
            }
            patientRepository.Save();
        }

        // Get Patient Operations Count
        public static int GetOperationsCount(int patientId, bool IsPrimary)
        {
            int count = 0;
            using (UnitOfWork operationRepository = new UnitOfWork())
            {
                IEnumerable<PatientOperationListItem> patientOperations = operationRepository.OperationRepository.GetOperationDetailsForPatientID(patientId, string.Empty);
                if (IsPrimary)
                {
                    foreach (PatientOperationListItem operation in patientOperations)
                    {
                        /*Take only not abandoned operations*/
                        if (operation.OperationStat == 0 && (operation.ProcAban == null || operation.ProcAban == false)) { count++; }
                    }
                }
                else
                {
                    foreach (PatientOperationListItem operation in patientOperations)
                    {
                        if (operation.OperationStat == 1) { count++; }
                    }
                }
            }
            return count;
        }

        /// <summary>
        /// Retrieves the last Primary operation for a patient, that is not abandoned 
        /// </summary>
        /// <param name="patientId">The id of the patient to search</param>
        /// <returns>The first primary operation in order of operation date</returns>
        public static PatientOperationListItem GetPrimaryOperation(int patientId)
        {
            using (UnitOfWork CurrentUnitofWork = new UnitOfWork())
            {
                return CurrentUnitofWork.OperationRepository.GetPrimaryOperationDetailsForPatientID(patientId).Where(x => x.OperationStatus == null || x.OperationStatus == "0").OrderBy(x => x.OperationDate).FirstOrDefault();
            }
        }

        public static void ConsentedPatientFollowupUpdate(int SavePatientId)
        {
            using (UnitOfWork CurrentUnitofWork = new UnitOfWork())
            {
                IEnumerable<PatientOperationListItem> Operations = CurrentUnitofWork.OperationRepository.GetOperationDetailsForPatientID(SavePatientId).Where(x => x.OperationStat != null && ((int)x.OperationStat == 0 && !(bool)x.ProcAban));
                foreach (PatientOperationListItem currentOperation in Operations)
                {
                    OperationSaveFollowups(currentOperation.PatientOperationId);
                }
            }
        }

        /// <summary>
        /// Handles the update and creation of followups for the operation
        /// </summary>
        /// <param name="SaveOperationId">Id of the operation being updated</param>
        /// <param name="isNewOperation">Optional flag to indicate if the operation is new</param>
        /// <param name="OperationDateChanged">Optional flag to indicate if the date of the operation has changed since last update</param>
        /// <param name="OperationStatusChanged">Optional flag to indicate if the Operation status has changed since the last update</param>
        /// <param name="ProcedureAbandonedChanged">Optional flag to indicate if the procedure abandoned state has changed since the last update</param>
        /// <returns></returns>
        public static bool OperationSaveFollowups(int SaveOperationId, bool isNewOperation = false, bool OperationDateChanged = false, bool OperationStatusChanged = false, bool ProcedureAbandonedChanged = false)
        {
            string UserName = System.Web.HttpContext.Current.User.Identity.Name;
            using (UnitOfWork CurrentUnitofWork = new UnitOfWork())
            {
                //Get the details of the operation
                tbl_PatientOperation CurrentOperation = CurrentUnitofWork.OperationRepository.GetByID(SaveOperationId);

                int CurrentPatientId = CurrentOperation.PatientId;

                //Determine the Primary Operation
                PatientOperationListItem PrimaryOperation = CurrentUnitofWork.OperationRepository.GetPrimaryOperationDetailsForPatientID(CurrentPatientId).Where(x => (int)x.OperationStat == 0 && !(bool)x.ProcAban).FirstOrDefault();
                if (PrimaryOperation == null)
                {
                    PrimaryOperation = new PatientOperationListItem();
                }

                if (OperationDateChanged)
                {
                    //Get all followups that are not done and not due update follow up date
                    IEnumerable<tbl_FollowUp> followUps = CurrentUnitofWork.tbl_FollowUpRepository.Get(x => x.OperationId == SaveOperationId && (x.FUVal == 4 || x.FUVal == 0));
                    OperationHandler.DeleteFollowupAndComplications(CurrentUnitofWork, followUps);
                }

                //When proc aban is changed from Yes to No then it must be checked to enable follow ups that are invalid
                if (!isNewOperation && ProcedureAbandonedChanged)
                {
                    CurrentUnitofWork.PatientRepository.UpdatePatientFollowups(CurrentPatientId, "Patient procedure unabandoned");
                }

                if (CurrentOperation.OpStat == 1)
                {
                    //If changed from primary to revision
                    if (OperationStatusChanged)
                    {
                        //Get all annual followups and delete
                        IEnumerable<tbl_FollowUp> followUps = CurrentUnitofWork.tbl_FollowUpRepository.Get(x => x.OperationId == SaveOperationId && x.FUPeriodId > 0);
                        OperationHandler.DeleteFollowupAndComplications(CurrentUnitofWork, followUps);
                    }

                    if (PrimaryOperation != null && PrimaryOperation.OperationDate != null)
                    {
                        DateTime? operationDateFromUI = CurrentOperation.OpDate;
                        if (operationDateFromUI != null)
                        {
                            //Followup Logic - save reopstatus
                            //1st year  0- 15months
                            tbl_FollowUp followUps = CurrentUnitofWork.tbl_FollowUpRepository.Get(x => x.PatientId == CurrentPatientId && x.FUPeriodId == 1 && operationDateFromUI < SqlFunctions.DateAdd("month", 3, x.FUDate) && operationDateFromUI > SqlFunctions.DateAdd("month", -15, x.FUDate)).FirstOrDefault();
                            if (followUps == null)
                            {
                                //2nd - 10yr - 2ndYear fupdate + 3 months  - 2ndyear fupdate - 9 months
                                followUps = CurrentUnitofWork.tbl_FollowUpRepository.Get(x => x.PatientId == CurrentPatientId && x.FUPeriodId > 1 && operationDateFromUI < SqlFunctions.DateAdd("month", 3, x.FUDate) && operationDateFromUI > SqlFunctions.DateAdd("month", -9, x.FUDate)).FirstOrDefault();
                            }

                            if (followUps != null)
                            {
                                followUps.ReOpStatId = 1;
                                CurrentUnitofWork.tbl_FollowUpRepository.Update(followUps);
                                CurrentUnitofWork.Save();
                            }
                        }
                    }
                }

                //Create followup for an operation
                CurrentUnitofWork.FollowUpRepository.CreateOpFollowup(SaveOperationId, null);

                //If user selects ProcAban in the first instance and submits the form, followup fuval  will be 3
                //Later if they modifies PROCABAN to false - FUVAL is not changing, inorder to modify the FUVAL- we need to keep the following code
                if (!(bool)CurrentOperation.ProcAban)
                {
                    tbl_FollowUp currentFollowups = CurrentUnitofWork.tbl_FollowUpRepository.Get(x => x.OperationId == SaveOperationId).FirstOrDefault();
                    if (currentFollowups != null)
                    {
                        if (currentFollowups.FUVal == 3)
                        {
                            currentFollowups.FUVal = 0;
                            currentFollowups.LastUpdatedBy = UserName;
                            currentFollowups.LastUpdatedDateTime = System.DateTime.Now;
                            CurrentUnitofWork.tbl_FollowUpRepository.Update(currentFollowups);
                            CurrentUnitofWork.Save();
                        }
                    }
                }

                //Less than 90 days
                //Update previous followup - with FUVAL =5 and other details
                tbl_FollowUp previousFollowup = CurrentUnitofWork.OperationRepository.GetPreviousFollowup(CurrentOperation.PatientId, (DateTime)CurrentOperation.OpDate);
                bool HasPreviousFollowUp = (previousFollowup != null);

                if (HasPreviousFollowUp)
                {
                    double calculatedDays = ((DateTime)CurrentOperation.OpDate - (DateTime)previousFollowup.tbl_PatientOperation.OpDate).TotalDays;

                    //Following rules are changing based on client requirements email - 27/04/2016
                    //If Previous followup is completed/ Not Applicable - send complications
                    //If Previous followup is not completed - send the following
                    if (calculatedDays < 90)
                    {
                        if (CurrentOperation.OpEvent != null)
                        {
                            previousFollowup.LastUpdatedBy = UserName;
                            previousFollowup.LastUpdatedDateTime = System.DateTime.Now;
                            previousFollowup.FUVal = 5;
                            previousFollowup.FUDate = CurrentOperation.OpDate;

                            switch (CurrentOperation.OpEvent)
                            {
                                case 1: //Planned and reviosion operation is less than 90 days, SEND just FUVAL=5   
                                    previousFollowup.SEId1 = null;
                                    previousFollowup.FurtherInfoPort = null;
                                    previousFollowup.FurtherInfoSlip = null;
                                    previousFollowup.ReasonOther = null;
                                    CurrentUnitofWork.tbl_FollowUpRepository.Update(previousFollowup);

                                    OperationHandler.DeleteOperationComplications(CurrentUnitofWork, Convert.ToInt32(previousFollowup.OperationId));
                                    OperationHandler.DeleteFollowupComplications(CurrentUnitofWork, Convert.ToInt32(previousFollowup.OperationId));
                                    break;

                                case 2: //Unplanned and reviosion operation is less than 90 days, SEND SEID1 =1, FUVAL=5 and Complications
                                    previousFollowup.SEId1 = true;
                                    previousFollowup.FurtherInfoPort = CurrentOperation.FurtherInfoPort;
                                    previousFollowup.FurtherInfoSlip = CurrentOperation.FurtherInfoSlip;
                                    previousFollowup.ReasonOther = CurrentOperation.ReasonOther;
                                    CurrentUnitofWork.tbl_FollowUpRepository.Update(previousFollowup);
                                    break;
                            }
                        }
                    }
                }
                CurrentUnitofWork.Save(); 
                return true;
            }
        }

        /// <summary>
        /// Save/Update the complication records for the operation
        /// </summary>
        /// <param name="SaveOperationId">The id of the operation being updated</param>
        /// <param name="Reasons">The list of possible complication reasons in a dictionary format key=Id of complication, value=selection state </param>
        /// <param name="OperationEvent">Id of Whether the operation was planned or unplanned</param>
        public static void OperationSaveComplications(int SaveOperationId, Dictionary<string, bool> Reasons, string OperationEvent)
        {
            using (UnitOfWork CurrentUnitofWork = new UnitOfWork())
            {
                tbl_PatientOperation patientOperation = CurrentUnitofWork.OperationRepository.GetByID(SaveOperationId);

                tbl_FollowUp previousFollowup = CurrentUnitofWork.OperationRepository.GetPreviousFollowup(patientOperation.PatientId, (DateTime)patientOperation.OpDate);

                bool HasPreviousFollowUp = (previousFollowup != null);
                //Complications
                tbl_PatientOperation previousOperation = CurrentUnitofWork.OperationRepository.GetPreviousOperation(patientOperation.PatientId, (DateTime)patientOperation.OpDate);
                if (previousOperation != null)
                {
                    //Verify if any existing values are in the table based on only operation not on followup - delete  
                    if (Reasons.Count > 0)
                    {
                        List<tbl_PatientComplications> Complications;

                        Complications = CurrentUnitofWork.tbl_PatientComplicationsRepository.Get(x => x.OpId == previousOperation.OpId && (!HasPreviousFollowUp || (HasPreviousFollowUp && x.FuId == null))).ToList<tbl_PatientComplications>();

                        if (Complications != null)
                        {
                            foreach (tbl_PatientComplications complication in Complications)
                            {
                                CurrentUnitofWork.tbl_PatientComplicationsRepository.Delete(complication);
                            }
                        }
                    }

                    if (OperationEvent == "2")
                    {
                        tbl_PatientComplications patientComplications;
                        int complicationValue;
                        double calculatedDays = -1;
                        if (HasPreviousFollowUp)
                        {
                            calculatedDays = ((DateTime)patientOperation.OpDate - (DateTime)previousFollowup.tbl_PatientOperation.OpDate).TotalDays;
                        }

                        foreach (KeyValuePair<string, bool> selectedItem in Reasons)
                        {
                            //If Item is selected add to the list
                            if (selectedItem.Value)
                            {
                                if (!string.IsNullOrEmpty(selectedItem.Key) && previousOperation != null)
                                {
                                    complicationValue = Convert.ToInt32(selectedItem.Key);

                                    if (previousFollowup == null)
                                        patientComplications = CurrentUnitofWork.tbl_PatientComplicationsRepository.Get(x => x.ComplicationId == complicationValue && ((HasPreviousFollowUp && x.OpId == previousOperation.OpId) || (!HasPreviousFollowUp && x.OpId == previousOperation.OpId))).FirstOrDefault();
                                    else
                                        patientComplications = CurrentUnitofWork.tbl_PatientComplicationsRepository.Get(x => x.ComplicationId == complicationValue && ((HasPreviousFollowUp && (x.OpId == previousOperation.OpId || x.FuId == previousFollowup.FUId)) || (!HasPreviousFollowUp && x.OpId == previousOperation.OpId))).FirstOrDefault();

                                    if (patientComplications == null)
                                        patientComplications = new tbl_PatientComplications();

                                    patientComplications.OpId = previousOperation.OpId;
                                    if (HasPreviousFollowUp && (calculatedDays >= 0 && calculatedDays < 90))
                                    {
                                        patientComplications.FuId = previousFollowup.FUId;
                                    }

                                    patientComplications.ComplicationId = Helper.ToNullable<System.Int32>(selectedItem.Key);
                                    if (patientComplications.Id == 0)
                                    {
                                        CurrentUnitofWork.tbl_PatientComplicationsRepository.Insert(patientComplications);
                                    }
                                    else
                                    {
                                        CurrentUnitofWork.tbl_PatientComplicationsRepository.Update(patientComplications);
                                    }
                                }
                            }
                        }
                    }
                    CurrentUnitofWork.Save();
                }
            }
        }

        /// <summary>
        /// Saves the details of the operation and performs required tasks.
        /// </summary>
        /// <param name="RawOperationData">The data to save as part of the operation</param>
        /// <param name="URN">the URN of the patient being saved</param>
        /// <returns>Reference to the operation, containing the stored Id if the operation is new</returns>
        public static tbl_PatientOperation SaveOperation(tbl_PatientOperation RawOperationData, string URN = "", bool deleteIfNull = true)
        {
            using (UnitOfWork CurrentUnitofWork = new UnitOfWork())
            {
                bool isProcedureAbandonedChanged = false;
                bool isNew = false;
                tbl_PatientOperation patientOperation = new tbl_PatientOperation();
                PatientOperationListItem PrimaryOperation = GetPrimaryOperation(RawOperationData.PatientId);

                if (RawOperationData.OpId == 0)
                {
                    isNew = true;
                    patientOperation.CreatedBy = RawOperationData.CreatedBy;
                    patientOperation.CreatedDateTime = System.DateTime.Now;
                }
                else
                    patientOperation = CurrentUnitofWork.OperationRepository.GetByID(RawOperationData.OpId);

                if (patientOperation.ProcAban != null)
                    isProcedureAbandonedChanged = ((bool)patientOperation.ProcAban && !(bool)RawOperationData.ProcAban);

                bool OperationDateChanged = (patientOperation.OpDate != null && patientOperation.OpDate != RawOperationData.OpDate);

                bool OperationStatusChanged = (RawOperationData.OpStat != patientOperation.OpStat);

                //Store all the base information
                patientOperation.With(p =>
                {
                    p.LastUpdatedBy = RawOperationData.LastUpdatedBy;
                    p.LastUpdatedDateTime = System.DateTime.Now;
                    p.OpVal = RawOperationData.OpVal;
                    p.PatientId = RawOperationData.PatientId;
                    p.Surg = RawOperationData.Surg;
                    p.Hosp = RawOperationData.Hosp;
                    p.OpDate = RawOperationData.OpDate;
                    p.OpStat = RawOperationData.OpStat;
                    p.Ht = RawOperationData.Ht;
                    p.HtNtKnown = RawOperationData.HtNtKnown;
                    p.OpWt = RawOperationData.OpWt;
                    p.OpWtNtKnown = RawOperationData.OpWtNtKnown;
                    p.OpBMI = PatientHandler.CalculateBMI(p.OpWt, p.Ht);
                    p.DiabStat = RawOperationData.DiabStat;
                    p.DiabRx = RawOperationData.DiabRx;
                    p.LiverTx = RawOperationData.LiverTx;
                    p.RenalTx = RawOperationData.RenalTx;
                    p.OthInfoOp = RawOperationData.OthInfoOp;
                    p.ProcAban = RawOperationData.ProcAban;
                    p.OpAge = PatientHandler.CalculateAge(RawOperationData.OpDate, p.PatientId);
                    p.OpEvent = RawOperationData.OpEvent;
                    p.OpTypeBulkLoad = RawOperationData.OpTypeBulkLoad;
                    p.AdmissionDate = RawOperationData.AdmissionDate;
                    p.DischargeDate = RawOperationData.DischargeDate;

                    //Store the extra information based on complications selected
                    p.FurtherInfoSlip = RawOperationData.FurtherInfoSlip;
                    p.FurtherInfoPort = RawOperationData.FurtherInfoPort;
                    p.ReasonOther = RawOperationData.ReasonOther;
                    p.OpBowelObsID = RawOperationData.OpBowelObsID;

                    //Determine extra data based on whether it was a Primary or a Revision operation
                    switch (p.OpStat)
                    {
                        case 0: //Primary
                            p.OpType = RawOperationData.OpType;
                            p.OthPriType = RawOperationData.OthPriType;
                            p.StWt = RawOperationData.StWt;
                            p.StWtNtKnown = RawOperationData.StWtNtKnown;
                            p.SameOpWt = RawOperationData.SameOpWt;
                            p.StBMI = (bool)p.SameOpWt ? p.OpBMI : PatientHandler.CalculateBMI(p.StWt, p.Ht);
                            p.OpRevType = null;
                            p.OthRevType = null;
                            p.LstBarProc = null;
                            break;

                        case 1: //Revision
                            p.OpRevType = RawOperationData.OpRevType;
                            p.OthRevType = RawOperationData.OthRevType;
                            p.StWt = null;
                            p.StWtNtKnown = null;
                            p.SameOpWt = null;
                            p.StBMI = null;
                            p.OpType = null;
                            p.OthPriType = null;
                            p.LstBarProc = RawOperationData.LstBarProc;

                            if (PrimaryOperation != null && PrimaryOperation.OperationDate != null)
                            {
                                if (p.OpDate != null)
                                {
                                    //Calculate time
                                    patientOperation.Time = ((Convert.ToDateTime(p.OpDate) - Convert.ToDateTime(PrimaryOperation.OperationDate)).Days / 31);
                                }
                            }
                            break;
                    }
                });

                //Insert/Update the operation into the work unit queue
                if (isNew)
                    CurrentUnitofWork.tbl_PatientOperationRepository.Insert(patientOperation);
                else
                    CurrentUnitofWork.tbl_PatientOperationRepository.Update(patientOperation);

                //Update the URN of the patient
                PatientHandler.UpdatePatientURN(patientOperation.PatientId, (int)patientOperation.Hosp, URN, deleteIfNull);

                //Save the operation to the database
                CurrentUnitofWork.Save();

                //get the operation again in order to update legacy value
                PrimaryOperation = GetPrimaryOperation(RawOperationData.PatientId);

                //Update the legacy flag 
                if (PrimaryOperation == null)
                    UpdateLegacyFlag(1, patientOperation.PatientId);
                else
                    UpdateLegacyFlag(0, patientOperation.PatientId);

                //Save the operation to the database
                CurrentUnitofWork.Save();

                //This will create, updated, delete and generally handle the Follow ups and complications for the operation
                OperationSaveFollowups(patientOperation.OpId, isNew, OperationDateChanged, OperationStatusChanged, isProcedureAbandonedChanged);

                //Return the operation details so that the calling function can access the updated operation id (if it was a new record)
                return patientOperation;
            }
        }

        // Update Legacy flag for Patient
        public static void UpdateLegacyFlag(int? legacyValue, int patientId)
        {
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                patientRepository.PatientRepository.UpdateLegacyFlag(patientRepository, patientId, legacyValue);
            }
        }
    }
}