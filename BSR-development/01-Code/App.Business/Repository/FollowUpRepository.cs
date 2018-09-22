using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Security;

namespace App.Business {
    public class FollowUpRepository : GenericRepository<tbl_FollowUp> {
        // Entity Framework context to the database
        private BusinessEntities _context;

        /// <summary>
        /// Constructor method - Initializes database context
        /// </summary>
        /// <param name="context">Database Context</param>
        public FollowUpRepository(BusinessEntities context)
            : base(context) {
            this._context = context;
        }

        /// <summary>
        /// Get Patient Follow up Details
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="surgeonId">Surgeon Id</param>
        /// <param name="siteId">Site Id</param>
        /// <param name="operationDateFrom">Operation Date From</param>
        /// <param name="operationDateTo">Operation Date To</param>
        /// <param name="operationStatusID">Operation Status Id</param>
        /// <param name="patientId">Patient Id</param>
        /// <returns>Returns list of all Follow up for a patient</returns>
        public IEnumerable<PatientFollowUpListItem> GetPatientFollowUpDetails(
            string userName,
            int surgeonId,
            int siteId,
            DateTime? operationDateFrom,
            DateTime? operationDateTo,
            int operationStatusID,
            int patientId) {
            Boolean isUserAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN));
            Boolean isSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));
            Boolean isDataCollector = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_DATACOLLECTOR));

            IMembershipRepository membershipRepository = new MembershipRepository();
            int[] siteIds = membershipRepository.GetSiteIdsForUser(userName);
            int operationsValidatedAndSubmitted = 2;

            DateTime? operationDateFromParam = operationDateFrom == null ? Convert.ToDateTime("01/01/1940") : operationDateFrom;
            DateTime? operationDateToParam = operationDateTo == null ? Convert.ToDateTime("01/01/1940") : operationDateTo;

            IEnumerable<PatientFollowUpListItem> patientsOperationsAndFollowUpDetails = null;
            patientsOperationsAndFollowUpDetails = (from patient in _context.ufn_FollowUp_WorkList(surgeonId, siteId, operationDateFromParam, operationDateToParam, patientId, operationsValidatedAndSubmitted)
                                                    select new PatientFollowUpListItem() {
                                                        PatientId = patient.patID,
                                                        SurgeonID = patient.SurgeonID,
                                                        SiteID = patient.HospID,
                                                        FamilyName = patient.LName,
                                                        GivenName = patient.FName,
                                                        Gender = patient.Gender,
                                                        DateOfBirth = patient.DOBNotKnown == 1 ? null : patient.DOB,
                                                        OperationDate = patient.OperationDate,
                                                        OperationStatus = (int)patient.OperationStatus,
                                                        OperationType = patient.OperationType,
                                                        FollowUpPeriodInDays = patient.FollowUpPeriodInDays,
                                                        FollowUpPeriod = patient.FollowUpPeriod,
                                                        FollowUpNumber = patient.FollowUpNumber,
                                                        FollowUpStatus = patient.FollowUpStatus,
                                                        AttemptedCalls = patient.AttemptedCalls,
                                                        URNo = patient.URNo,
                                                        Surgeon = patient.Surgeon,
                                                        FollowUpID = patient.FollowUpID,
                                                        OperationID = patient.OperationID,
                                                        PrimarySurgeonID = patient.PrimarySurgeonID,
                                                        PrimarySurgeon = patient.PrimarySurgeon,
                                                        SiteTypeId = patient.SiteTypeID
                                                    }).ToList<PatientFollowUpListItem>();

            if (operationStatusID > -1) {
                patientsOperationsAndFollowUpDetails = patientsOperationsAndFollowUpDetails.Where(x => x.OperationStatus == operationStatusID);
            }

            if (!isUserAdmin) {
                patientsOperationsAndFollowUpDetails = patientsOperationsAndFollowUpDetails.Where(x => siteIds.Contains(x.SiteID));
            }

            if (isSurgeon) {
                patientsOperationsAndFollowUpDetails = patientsOperationsAndFollowUpDetails.Where(x => x.Surgeon.ToLower() == (x.SiteTypeId == 1 ? x.Surgeon.ToLower() : userName.ToLower()));
            }

            patientsOperationsAndFollowUpDetails = patientsOperationsAndFollowUpDetails.OrderByDescending(x => x.OperationDate);

            return patientsOperationsAndFollowUpDetails;
        }

        /// <summary>
        /// Get All Patient Follow Up details
        /// </summary>
        /// <param name="patientId">Patient Id</param>
        /// <returns>Returns list of Followup details for a patient</returns>
        public IEnumerable<PatientFollowUpDetailsListItem> GetPatientFollowUpDetailsList(int patientId) {
            IEnumerable<PatientFollowUpDetailsListItem> patientFollowUpDetailsList = null;
            //var updateFollowUpsAsInvalidOrValid = _context.usp_UpdateFollowUpsAsInvalidOrValid();

            patientFollowUpDetailsList = (from patients in _context.tbl_Patient
                                          join followUps in _context.tbl_FollowUp on patients.PatId equals followUps.PatientId
                                          from operations in _context.tbl_PatientOperation.Where(x => x.PatientId == patients.PatId && x.OpId == followUps.OperationId)
                                          from patientURN in _context.tbl_URN.Where(x => x.PatientID == patients.PatId && x.HospitalID == operations.Hosp)
                                          join procedure1 in _context.tlkp_Procedure on operations.OpType equals procedure1.Id into tempJoin0
                                          from procedure1 in tempJoin0.DefaultIfEmpty()
                                          join procedure2 in _context.tlkp_Procedure on operations.OpRevType equals procedure2.Id into tempJoin1
                                          from procedure2 in tempJoin1.DefaultIfEmpty()
                                          from FollowUpLabel in _context.tlkp_FollowUp_FUVal.Where(x=> x.Id == followUps.FUVal)
                                          where patients.PatId == patientId && followUps.FUDate.HasValue && (followUps.FUVal == 0 || followUps.FUVal == 1 || followUps.FUVal == 2 || followUps.FUVal == 5)
                                          select new PatientFollowUpDetailsListItem() {
                                              FollowUpId = followUps.FUId,
                                              URNNo = patientURN.URNo,
                                              OperationDate = operations.OpDate,
                                              OperationStatus = operations.OpStat == null ? string.Empty : operations.tlkp_OperationStatus.Description,
                                              OperationType = operations.OpStat == null ? string.Empty : (operations.OpStat == 0 ? operations.tlkp_Procedure2.Description : operations.tlkp_Procedure1.Description), //(o.OpType == 0 ? p0.Description : p1.Description) -- not working
                                              FollowUpPeriod = followUps.FUPeriodId == null ? string.Empty : followUps.tlkp_FollowUpPeriod.Description,
                                              FollowUpDate = followUps.FUDate,
                                              FollowUpStatusLabel = FollowUpLabel.Description == null ? string.Empty : FollowUpLabel.Description
                                              
                                          }).OrderBy(f => f.FollowUpId).Distinct().ToList<PatientFollowUpDetailsListItem>();

            return patientFollowUpDetailsList;
        }

        /// <summary>
        /// Get Patient last Followup Details for an Operation
        /// </summary>
        /// <param name="patientId">Patient Id</param>
        /// <param name="operationId">Operation Id</param>
        /// <returns>Returns last Followup details for an operation</returns>
        public FollowUpDetails GetPatientFollowUpAndOperationDetails(int patientId, int operationId) {
            FollowUpDetails patientOperationFollowUps = null;

            // Fetching Last followUp for operation
            patientOperationFollowUps = (from followUps in _context.tbl_FollowUp
                                         join operations in _context.tbl_PatientOperation on followUps.OperationId equals operations.OpId
                                         where operations.PatientId == patientId && operations.OpId == operationId && followUps.FUVal == 2
                                         select new FollowUpDetails() {
                                             FollowUpId = followUps.FUId,
                                             OperationDate = operations.OpDate,
                                             OperationStatus = operations.OpStat,
                                             FollowUpPeriodDescrition = followUps.FUPeriodId == null ? string.Empty : followUps.tlkp_FollowUpPeriod.Description,
                                             FollowUpDate = followUps.FUDate,
                                             FollowUpPeriodID = followUps.FUPeriodId == null ? 0 : followUps.FUPeriodId,
                                             OperationId = operations.OpId,
                                             OperationWieght = operations.OpWt == null ? 0 : operations.OpWt,
                                             StandardWieght = operations.StWt == null ? 0 : operations.StWt,
                                             FollowUpWieght = followUps.FUWt,
                                             LostToFollowUp = followUps.LTFU,
                                         }).OrderByDescending(x => x.FollowUpPeriodID).FirstOrDefault();

            return patientOperationFollowUps;
        }

        /// <summary>
        /// Gets Patient's LTFU Followup details
        /// </summary>
        /// <param name="patientId">Patient Id</param>
        /// <returns></returns>
        public PatientFollowUpLTFUDetails GetPatientFollowUpLTFUDetails(int patientId) {
            PatientFollowUpLTFUDetails patientLTFUDetails = null;
            patientLTFUDetails = (from folloups in _context.tbl_FollowUp
                                  where folloups.PatientId == patientId && folloups.LTFU == true
                                  select new PatientFollowUpLTFUDetails() {
                                      FollowUpId = folloups.FUId,
                                      LostToFollowUp = folloups.LTFU,
                                      FollowUpDate = folloups.FUDate,
                                  }).FirstOrDefault();

            return patientLTFUDetails;
        }

        /// <summary>
        /// Gets Missing data worklist details
        /// </summary>
        /// <param name="countryId">Patient Country Id</param>
        /// <param name="surgeonId">Patient Surgeon Id</param>
        /// <param name="siteId">Patient Site Id</param>
        /// <param name="operationDateFrom">Patient Operation Date From</param>
        /// <param name="operationDateTo">Patient Operation Date To</param>
        /// <param name="operationStatus">Patient Operation Status</param>
        /// <param name="isAdmin">Flag to determine if Admin user is logged in</param>
        /// <returns>Returns list of Missing Data WorkList details</returns>
        public IEnumerable<MissingDataListItem> GetMissingDataWorkList(int countryId, int surgeonId, int siteId, DateTime? operationDateFrom, DateTime? operationDateTo, int operationStatus, bool isAdmin) {
            IEnumerable<MissingDataListItem> missingDataDetails = null;
            missingDataDetails = (from missingDataWorklist in _context.ufn_Missing_DataList(countryId, operationStatus, surgeonId, siteId, operationDateFrom, operationDateTo)
                                  join patientURN in _context.tbl_URN on missingDataWorklist.Patient_ID equals patientURN.PatientID
                                  join site in _context.tbl_Site on missingDataWorklist.Hospital equals site.SiteName
                                  where patientURN.HospitalID == site.SiteId
                                  select new MissingDataListItem() {
                                      PatientId = missingDataWorklist.Patient_ID,
                                      URNo = patientURN.URNo,
                                      FamilyName = missingDataWorklist.Patient_LastName,
                                      GivenName = missingDataWorklist.Patient_FName,
                                      Gender = missingDataWorklist.Patient_Gender,
                                      OperationDate = missingDataWorklist.Operation_Date,
                                      OperationId = missingDataWorklist.OperationID,
                                      Surgeon = missingDataWorklist.Surgeon,
                                      Site = missingDataWorklist.Hospital,
                                      SiteId = site.SiteId,
                                      Day30FU = missingDataWorklist.Day_30 == "z_Complete" ? "Completed" : missingDataWorklist.Day_30,
                                      Year1FU = missingDataWorklist.Year_1 == "z_Complete" ? "Completed" : missingDataWorklist.Year_1,
                                      Year2FU = missingDataWorklist.Year_2 == "z_Complete" ? "Completed" : missingDataWorklist.Year_2,
                                      Year3FU = missingDataWorklist.Year_3 == "z_Complete" ? "Completed" : missingDataWorklist.Year_3,
                                      Year4FU = missingDataWorklist.Year_4 == "z_Complete" ? "Completed" : missingDataWorklist.Year_4,
                                      Year5FU = missingDataWorklist.Year_5 == "z_Complete" ? "Completed" : missingDataWorklist.Year_5,
                                      Year6FU = missingDataWorklist.Year_6 == "z_Complete" ? "Completed" : missingDataWorklist.Year_6,
                                      Year7FU = missingDataWorklist.Year_7 == "z_Complete" ? "Completed" : missingDataWorklist.Year_7,
                                      Year8FU = missingDataWorklist.Year_8 == "z_Complete" ? "Completed" : missingDataWorklist.Year_8,
                                      Year9FU = missingDataWorklist.Year_9 == "z_Complete" ? "Completed" : missingDataWorklist.Year_9,
                                      Year10FU = missingDataWorklist.Year_10 == "z_Complete" ? "Completed" : missingDataWorklist.Year_10,
                                      OpFormCompleted = missingDataWorklist.Op_Form_Status
                                  }).ToList<MissingDataListItem>();

            if (isAdmin) {
                missingDataDetails = missingDataDetails.Where(x => (x.Day30FU == "Incomplete" || x.Day30FU == "Incomplete - WIP") ||
                                                                   (x.Year1FU == "Incomplete" || x.Year1FU == "Incomplete - WIP") ||
                                                                   (x.Year2FU == "Incomplete" || x.Year2FU == "Incomplete - WIP") ||
                                                                   (x.Year3FU == "Incomplete" || x.Year3FU == "Incomplete - WIP") ||
                                                                   (x.Year4FU == "Incomplete" || x.Year4FU == "Incomplete - WIP") ||
                                                                   (x.Year5FU == "Incomplete" || x.Year5FU == "Incomplete - WIP") ||
                                                                   (x.Year6FU == "Incomplete" || x.Year6FU == "Incomplete - WIP") ||
                                                                   (x.Year7FU == "Incomplete" || x.Year7FU == "Incomplete - WIP") ||
                                                                   (x.Year8FU == "Incomplete" || x.Year8FU == "Incomplete - WIP") ||
                                                                   (x.Year9FU == "Incomplete" || x.Year9FU == "Incomplete - WIP") ||
                                                                   (x.Year10FU == "Incomplete" || x.Year10FU == "Incomplete - WIP") ||
                                                                   (x.OpFormCompleted == "Incomplete" || x.OpFormCompleted == "Incomplete - WIP"));
            } else {
                missingDataDetails = missingDataDetails.Where(x => x.Day30FU == "Incomplete" || x.Year1FU == "Incomplete" || x.Year2FU == "Incomplete" || x.Year3FU == "Incomplete"
                                             || x.Year4FU == "Incomplete" || x.Year5FU == "Incomplete" || x.Year6FU == "Incomplete" || x.Year7FU == "Incomplete" || x.Year8FU == "Incomplete"
                                             || x.Year9FU == "Incomplete" || x.Year10FU == "Incomplete" || x.OpFormCompleted == "Incomplete");
            }
            return missingDataDetails.OrderBy(k => k.FamilyName).ThenBy(k => k.GivenName);
        }

        /// <summary>
        /// Get Pending Followup Details
        /// </summary>
        /// <returns>Returns list of Pending Followup Email Details</returns>
        public IEnumerable<FollowUpEmailDetails> GetPendingFollowUpDetails() {
            IEnumerable<FollowUpEmailDetails> patientsAndSurgeonFollowUpDetails = null;
            patientsAndSurgeonFollowUpDetails = (from pendingFollowup in _context.usp_CreateFollowUpsAlerts()
                                                 join operation in _context.tbl_PatientOperation on pendingFollowup.OperationID equals operation.OpId
                                                 join patient in _context.tbl_Patient on operation.PatientId equals patient.PatId
                                                 join patientURN in _context.tbl_URN on operation.PatientId equals patientURN.PatientID
                                                 join site in _context.tbl_Site on patientURN.HospitalID equals site.SiteId
                                                 where patientURN.HospitalID == operation.Hosp // && o.Surg == 155 && p.SurgeonEmailAdd == "praveen.baswa@monash.edu" //testing in staging //&& o.Surg == 18 //For testing with the specific surgeon praveen.baswa@monash.edu
                                                 select new FollowUpEmailDetails() {
                                                     FollowUpId = pendingFollowup.FollowID,
                                                     SurgeonName = pendingFollowup.SurgeonName,
                                                     SurgeonEmailAddress = pendingFollowup.SurgeonEmailAdd,
                                                     FollowUpPeriodDescrition = pendingFollowup.FU_Period,
                                                     PatientTitle = patient.tlkp_Title.Description,
                                                     PatientFirstName = patient.FName,
                                                     PatientLastName = patient.LastName,
                                                     URNo = patientURN.URNo,
                                                     OperationId = pendingFollowup.OperationID,
                                                     OperationDate = operation.OpDate,
                                                     PatientID = operation.PatientId,
                                                     Gender = patient.GenderId == null ? string.Empty : patient.tlkp_Gender.Description,
                                                     OperationType = operation.OpType == null ? string.Empty : operation.tlkp_Procedure2.Description,
                                                     RevisionOpType = operation.OpRevType == null ? string.Empty : operation.tlkp_Procedure1.Description,
                                                     DateOfBirth = patient.DOB,
                                                     State = site.SiteStateId == null ? string.Empty : site.tlkp_State.Description
                                                 }).ToList<FollowUpEmailDetails>();

            return patientsAndSurgeonFollowUpDetails;
        }

        /// <summary>
        /// Creates new Followups for the operation or patient
        /// </summary>
        /// <param name="operationId">Operation Id</param>
        /// <param name="patientId">Patient Id</param>
        public void CreateOpFollowup(int? operationId, int? patientId) {
            _context.Database.ExecuteSqlCommand(string.Format("exec usp_CreateOpFollowUp {0}, {1}", operationId==null ? "-1" : operationId.ToString(), patientId==null ? "-1" : patientId.ToString()));
        }

        /// <summary>
        /// Gets the Patient Call Screen data
        /// </summary>
        /// <param name="countryId">Country Id</param>
        /// <param name="stateId">State Id</param>
        /// <param name="userId">Logged in user id</param>
        /// <returns>List Patient Call Records</returns>
        public IEnumerable<PatientCallListItem> GetPatientCallWorkList(int countryId, int stateId, int userId) {
            IEnumerable<PatientCallListItem> patientFollowUpCallList = null;

            patientFollowUpCallList = (from patientFollowUpCallDetails in _context.usp_Patient_CallWorkList(countryId, stateId)
                                       select new PatientCallListItem() {
                                           PatientId = patientFollowUpCallDetails.PatientId ?? 0,
                                           FollowUpId = patientFollowUpCallDetails.FollowUpId ?? 0,
                                           FamilyName = patientFollowUpCallDetails.FamilyName,
                                           GivenName = patientFollowUpCallDetails.GivenName,
                                           HomePhone = patientFollowUpCallDetails.HomePhone,
                                           Mobile = patientFollowUpCallDetails.Mobile,
                                           BirthDate = patientFollowUpCallDetails.BirthDate,
                                           PostCode = patientFollowUpCallDetails.PostCode,
                                           SiteId = patientFollowUpCallDetails.SiteId,
                                           SiteName = patientFollowUpCallDetails.Site,
                                           SurgeonId = patientFollowUpCallDetails.SurgeonId,
                                           SurgeonName = patientFollowUpCallDetails.Surgeon,
                                           OperationDate = patientFollowUpCallDetails.OperationDate,
                                           ProcedureId = patientFollowUpCallDetails.ProcedureId,
                                           ProcedureType = patientFollowUpCallDetails.Procedure,
                                           FollowUpPeriodId = patientFollowUpCallDetails.FollowUpPeriodId,
                                           FollowUpPeriod = patientFollowUpCallDetails.FollowUpPeriod,
                                           FollowUpDate = patientFollowUpCallDetails.FollowUpDueDate,
                                           FollowUpCallDetailsId = patientFollowUpCallDetails.FollowUpCallId ?? 0,
                                           CallOneId = patientFollowUpCallDetails.CallOneId ?? 0,
                                           CallOneResult = patientFollowUpCallDetails.CallOneResult,
                                           CallTwoId = patientFollowUpCallDetails.CallTwoId ?? 0,
                                           CallTwoResult = patientFollowUpCallDetails.CallTwoResult,
                                           CallThreeId = patientFollowUpCallDetails.CallThreeId ?? 0,
                                           CallThreeResult = patientFollowUpCallDetails.CallThreeResult,
                                           CallFourId = patientFollowUpCallDetails.CallFourId ?? 0,
                                           CallFourResult = patientFollowUpCallDetails.CallFourResult,
                                           CallFiveId = patientFollowUpCallDetails.CallFiveId ?? 0,
                                           CallFiveResult = patientFollowUpCallDetails.CallFiveResult,
                                           LastUpdatedBy = patientFollowUpCallDetails.LastUpdateBy,
                                           LastUpdatedDateTime = patientFollowUpCallDetails.LastUpdateDateTime,
                                           AssignedTo = patientFollowUpCallDetails.AssignedTo ?? -1,
                                           FollowUpNotes = string.IsNullOrEmpty(patientFollowUpCallDetails.FollowUpInfo) ? "-" : patientFollowUpCallDetails.FollowUpInfo,
                                           StateId = patientFollowUpCallDetails.StateId,
                                           State = String.IsNullOrEmpty(patientFollowUpCallDetails.StateName) ? "-" : patientFollowUpCallDetails.StateName
                                       }
                                       ).ToList<PatientCallListItem>();

            //This will sort the followups into the correct order: by call attempts DESC, followup date DESC. This is here if the sorting can no longer be maintained in the 
            //stored procedure ufn_Patient_CallWorkList

            //patientFollowUpCallList = patientFollowUpCallList
            //        .OrderByDescending(x => x.CallFiveId ?? 0)
            //        .ThenByDescending(x => x.CallFourId ?? 0)
            //        .ThenByDescending(x => x.CallThreeId ?? 0)
            //        .ThenByDescending(x => x.CallTwoId ?? 0)
            //        .ThenByDescending(x => x.CallOneId ?? 0)
            //        .ThenByDescending(x => x.FollowUpDate);

            foreach (var item in patientFollowUpCallList) {
                string lastConfirmedCall = string.Empty;

                if (item.CallFiveId.Value != 0) {
                    lastConfirmedCall = "5";
                } else if (item.CallFourId.Value != 0) {
                    lastConfirmedCall = "4";
                } else if (item.CallThreeId.Value != 0) {
                    lastConfirmedCall = "3";
                } else if (item.CallTwoId.Value != 0) {
                    lastConfirmedCall = "2";
                } else if (item.CallOneId.Value != 0) {
                    lastConfirmedCall = "1";
                } else {
                    lastConfirmedCall = string.Empty;
                }
                
                item.LastConfirmedCall = lastConfirmedCall;
            }


            //This section rebuilds the data set to regroup the results by patient id
            List<PatientCallListItem> returnData = new List<PatientCallListItem>();
            bool Finished = false;
            int counter = 0;

            while (!Finished) {
                //Retrieve the item to check, skipping by the number of records already checked
                PatientCallListItem searchPatient = patientFollowUpCallList.Skip(counter).FirstOrDefault() as PatientCallListItem;

                //check to see if there is no data left
                if (searchPatient != null) {
                    //Check to see if the item has already been entered into the result set by a previous execution
                    if (!returnData.Contains<PatientCallListItem>(searchPatient)) {
                        //As the item has not been added, it is safe to assume that this patient has not been processed
                        //Here we find all the records for that patient and add them to the result set
                        returnData.AddRange(patientFollowUpCallList.AsQueryable().Where<PatientCallListItem>(x => x.PatientId == searchPatient.PatientId));
                    }

                    //Increment the counter to move to the next item
                    counter++;
                } else {
                    //Set the flag to exit the loop
                    Finished = true;
                }
            }

            return returnData;
        }
    }
}