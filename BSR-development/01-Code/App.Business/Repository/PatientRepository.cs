using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Data.Objects.SqlClient;
using System.Linq;
using System.Reflection;
using System.Web.Security;

namespace App.Business
{
    public class PatientRepository : GenericRepository<tbl_Patient>
    {
        // Entity Framework context to the database
        private BusinessEntities _contextObject;

        /// <summary>
        /// Constructor method - Initializes database context
        /// </summary>
        /// <param name="context">Database Context</param>
        public PatientRepository(BusinessEntities context)
            : base(context)
        {
            ((IObjectContextAdapter)context).ObjectContext.CommandTimeout = 120;
            this._contextObject = context;
        }

        /// <summary>
        /// Get State list for the Patient
        /// </summary>
        /// <param name="withEmptyItem">Flag to add an empty item</param>
        /// <returns>List of Lookup Item of State for Patient</returns>
        public List<LookupItem> GetStateListForPatient(bool withEmptyItem)
        {
            List<LookupItem> items;
            using (UnitOfWork unitOfWork = new UnitOfWork())
            {
                items = (from lookup in unitOfWork.tlkp_StateRepository.Get()
                         where (lookup.Id != 9)
                         select new LookupItem()
                         {
                             Id = lookup.Id.ToString(),
                             Description = lookup.Description
                         }
                         ).ToList<LookupItem>();
            }
            if (withEmptyItem)
            {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }
            return items;
        }

        /// <summary>
        /// Get Country List for Patient
        /// </summary>
        /// <param name="withEmptyItem">Flag to add an empty item</param>
        /// <returns>List of Lookup Item of Country for Patient</returns>
        public List<LookupItem> GetCountryListForPatient(bool withEmptyItem)
        {
            List<LookupItem> items;
            using (UnitOfWork unitOfWork = new UnitOfWork())
            {
                items = (from lookup in unitOfWork.tlkp_CountryRepository.Get()
                         where (lookup.Id != 9)
                         select new LookupItem()
                         {
                             Id = lookup.Id.ToString(),
                             Description = lookup.Description
                         }
                         ).ToList<LookupItem>();
            }
            if (withEmptyItem)
            {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }
            return items;
        }

        /// <summary>
        /// Get Patient List By Patient Given name and Date of Birth
        /// </summary>
        /// <param name="givenName">Patient Given Name</param>
        /// <param name="dateOfBirth">Patient Date of Birth</param>
        /// <returns>Returns List of Patient which satisfy the criteria</returns>
        public IEnumerable<MatchedPatientItem> GetPatientListByGNameDOB(string givenName, DateTime dateOfBirth)
        {
            MatchedPatientItem defaultItem = new MatchedPatientItem();
            defaultItem.PatientId = 0;
            defaultItem.PatientName = "New (unrelated) Patient";
            defaultItem.Gender = string.Empty;
            defaultItem.DOB = string.Empty;
            defaultItem.MedicareNo = string.Empty;
            defaultItem.IHI = string.Empty;
            defaultItem.Street = string.Empty;
            defaultItem.Suburb = string.Empty;
            defaultItem.State = string.Empty;
            defaultItem.Postcode = string.Empty;

            var patientList = (from patient in _contextObject.tbl_Patient
                               where patient.FName.ToUpper() == givenName.ToUpper() && patient.DOB == dateOfBirth
                               select new MatchedPatientItem()
                               {
                                   PatientId = patient.PatId,
                                   PatientName = patient.FName + " - " + patient.LastName,
                                   Gender = patient.tlkp_Gender.Description,
                                   DOB = SqlFunctions.StringConvert((decimal?)SqlFunctions.DatePart("dd", patient.DOB)).Trim() + "/" +
                                         SqlFunctions.StringConvert((decimal?)SqlFunctions.DatePart("MM", patient.DOB)).Trim() + "/" +
                                         SqlFunctions.StringConvert((decimal?)SqlFunctions.DatePart("yyyy", patient.DOB)).Trim(),
                                   MedicareNo = patient.McareNo,
                                   IHI = patient.IHI,
                                   Street = patient.Addr,
                                   Suburb = patient.Sub,
                                   State = patient.tlkp_State.Description,
                                   Postcode = patient.Pcode
                               }).ToList<MatchedPatientItem>();

            patientList.Add(defaultItem);
            return patientList;
        }

        /// <summary>
        /// Get patients who are opted off
        /// Condition: Get the latest operation date and optOffstatId is not null and 0
        /// </summary>
        /// <param name="patients">Patients</param>
        /// <param name="LTFUStatusId">LTFU Status Id</param>
        /// <param name="fullOptOffStatusId">Full Opt Off Status ID</param>
        /// <param name="partialOptOffStatusId">Partial Opt Off Status Id</param>
        /// <returns> Patient Opt Off List</returns>
        public IEnumerable<PatientOptOffListItem> GetPatientOptOffList(ref Int32 patients, ref Int32 LTFUStatusId, ref Int32 fullOptOffStatusId, ref Int32 partialOptOffStatusId)
        {
            patients = (from patientsTable in _contextObject.tbl_Patient
                        select patientsTable).ToList().Count();

            LTFUStatusId = (from patientsTable in _contextObject.tbl_Patient
                            let patientOperation = _contextObject.tbl_PatientOperation.Where(x => x.PatientId == patientsTable.PatId).OrderByDescending(x => x.OpDate).FirstOrDefault()
                            where (patientsTable.OptOffStatId == 4) && (patientsTable.OptOffStatId != null)
                            select patientsTable).ToList().Count();

            fullOptOffStatusId = (from patientsTable in _contextObject.tbl_Patient
                                  let patientOperations = _contextObject.tbl_PatientOperation.Where(x => x.PatientId == patientsTable.PatId).OrderByDescending(x => x.OpDate).FirstOrDefault()
                                  where (patientsTable.OptOffStatId == 1) && (patientsTable.OptOffStatId != null)
                                  select patientsTable).ToList().Count();

            partialOptOffStatusId = (from patientsTable in _contextObject.tbl_Patient
                                     let patientOperations = _contextObject.tbl_PatientOperation.Where(x => x.PatientId == patientsTable.PatId).OrderByDescending(x => x.OpDate).FirstOrDefault()
                                     where (patientsTable.OptOffStatId == 2) && (patientsTable.OptOffStatId != null)
                                     select patientsTable).ToList().Count();

            IEnumerable<PatientOptOffListItem> patientOptOffList = null;
            patientOptOffList = (from patientsTable in _contextObject.tbl_Patient
                                 let patientOperations = _contextObject.tbl_PatientOperation.Where(x => x.PatientId == patientsTable.PatId).OrderByDescending(x => x.OpDate).FirstOrDefault()
                                 where patientsTable.OptOffStatId != null && (patientsTable.OptOffStatId == 1 || patientsTable.OptOffStatId == 2)
                                 select new PatientOptOffListItem()
                                 {
                                     PatientId = patientsTable.PatId,
                                     LastName = patientsTable.LastName,
                                     FirstName = patientsTable.FName,
                                     OperationDate = (DateTime)patientOperations.OpDate,
                                     OperationOffDate = (DateTime)patientsTable.OptOffDate,
                                     OperationOffStatus = (patientsTable.OptOffStatId != null) ? (int)patientsTable.OptOffStatId : -1
                                 }).OrderBy(p => p.PatientId).ToList<PatientOptOffListItem>();
            return patientOptOffList;
        }

        /// <summary>
        /// Get Patient Id using Site and Patient URN
        /// </summary>
        /// <param name="siteId">Site Id</param>
        /// <param name="patientURN">Patient URN</param>
        /// <returns></returns>
        public Int32 GetPatientId(int siteId, string patientURN)
        {
            Int32 patientId = -1;
            using (UnitOfWork unitOfWork = new UnitOfWork())
            {
                patientId = (from patientURNTable in _contextObject.tbl_URN
                             where patientURNTable.HospitalID == siteId && patientURNTable.URNo == patientURN
                             select patientURNTable.PatientID).FirstOrDefault();
            }
            return patientId;
        }

        /// <summary>
        /// Gets Country Id from Site Id
        /// </summary>
        /// <param name="siteId">Site Id</param>
        /// <returns>Country Id in which the Site is located</returns>
        public int? Get_CountryId(int siteId)
        {
            int? countryId = -1;
            using (UnitOfWork unitOfWork = new UnitOfWork())
            {
                countryId = (from site in _contextObject.tbl_Site
                             where site.SiteId == siteId
                             select site.SiteCountryId).FirstOrDefault();
            }
            return countryId;
        }

        /// <summary>
        /// Updating Legacy flag for the Patient
        /// </summary>
        /// <param name="unitOfWork">Unit Of Work instance</param>
        /// <param name="patientId">Patient Id</param>
        /// <param name="legacy">Legacy Value</param>
        public void UpdateLegacyFlag(UnitOfWork unitOfWork, int patientId, int? legacy)
        {
            if (patientId > 0)
            {
                //Update the Legacy flag
                tbl_Patient patientDetails = unitOfWork.tbl_PatientRepository.Get(x => x.PatId == patientId).ToList().Single();
                if (patientDetails != null)
                {
                    if (patientDetails.Legacy != legacy)
                    {
                        patientDetails.Legacy = legacy;
                        unitOfWork.tbl_PatientRepository.Update(patientDetails);
                        unitOfWork.Save();
                    }
                }
            }
        }

        /// <summary>
        /// Check Legacy Flag for the Patient
        /// </summary>
        /// <param name="unitOfWork">Unit Of Work instance</param>
        /// <param name="patientId">Patient Id</param>
        /// <returns>Returns Legacy Flag value for the Patient</returns>
        public int? CheckLegacyFlag(UnitOfWork unitOfWork, int patientId)
        {
            if (patientId > 0)
            {
                //Update the Legacy flag
                tbl_Patient patientDetails = unitOfWork.tbl_PatientRepository.Get(x => x.PatId == patientId).ToList().Single();
                if (patientDetails != null)
                {
                    return patientDetails.Legacy;
                }
            }
            return null;
        }

        /// <summary>
        /// Update Opt Off details for a Patient
        /// </summary>
        /// <param name="unitOfWork">Unit of Work instance</param>
        /// <param name="patientId">Patient Id</param>
        /// <param name="optOffStatusId">Opt Off Status Id</param>
        /// <param name="optOffDate">Opt Off Date</param>
        /// <param name="essUndelivered">Flag to determine ESS Undeliverd</param>
        public void Update_OptOffDetails(UnitOfWork unitOfWork, string patientId, string optOffStatusId, DateTime? optOffDate = null, bool essUndelivered = false)
        {
            if (!string.IsNullOrEmpty(patientId))
            {
                int patientIdConverted = Convert.ToInt32(patientId);
                // Remove all data from Patient table except patient Surname, Given name, DOB and Date Expl Statement sent
                tbl_Patient patient = unitOfWork.tbl_PatientRepository.Get(x => x.PatId == patientIdConverted).ToList().Single();

                List<Int32> patientOperationRemove = null;
                List<Int32> patientFollowUpRemove = null;

                List<Int32> patientOperationDeviceRemove = null;
                List<Int32> patientFollowUpComplicationsRemove = null;
                List<Int32> patientFollowupCallsRemove = null;

                patientOperationRemove = (from patientOperation in _contextObject.tbl_PatientOperation
                                          where patientOperation.PatientId == patientIdConverted
                                          select patientOperation.OpId).ToList();

                patientFollowUpRemove = (from followUp in _contextObject.tbl_FollowUp
                                         where followUp.PatientId == patientIdConverted
                                         select followUp.FUId).ToList();

                patientFollowupCallsRemove = (from followupcalls in _contextObject.tbl_FollowUpCall
                                              where patientFollowUpRemove.Contains(followupcalls.FollowUpId.Value)
                                              select followupcalls.Id).ToList();




                if (patientOperationRemove != null && patientOperationRemove.Count > 0)
                {
                    patientOperationDeviceRemove = (from PatientOperationDeviceDtls in _contextObject.tbl_PatientOperationDeviceDtls
                                                    where PatientOperationDeviceDtls.PatientOperationId == PatientOperationDeviceDtls.tbl_PatientOperation.OpId
                                                    && PatientOperationDeviceDtls.tbl_PatientOperation.PatientId == patientIdConverted
                                                    select PatientOperationDeviceDtls.PatientOperationDevId).ToList();
                }

                if (patientFollowUpRemove != null && patientFollowUpRemove.Count > 0)
                {
                    patientFollowUpComplicationsRemove = (from patientComplications in _contextObject.tbl_PatientComplications
                                                          where patientComplications.FuId == patientComplications.tbl_FollowUp.FUId
                                                          && patientComplications.tbl_FollowUp.PatientId == patientIdConverted
                                                          select patientComplications.Id).ToList();
                }

                patient.OptOffDate = optOffDate;
                if (!string.IsNullOrEmpty(optOffStatusId))
                {
                    patient.OptOffStatId = Convert.ToInt32(optOffStatusId);
                }
                else
                {
                    patient.OptOffStatId = null;
                }

                if (optOffStatusId == "1")
                {
                    PropertyInfo[] patientProperties = patient.GetType().GetProperties();
                    for (int i = 0; i < patientProperties.Count(); i++)
                    {
                        PropertyInfo patientProperty = patientProperties[i];
                        if (patientProperty.PropertyType == typeof(string) || patientProperty.PropertyType == typeof(decimal?)
                            || patientProperty.PropertyType == typeof(bool?) || patientProperty.PropertyType == typeof(int?)
                            || patientProperty.PropertyType == typeof(DateTime?))
                        {
                            //Retail patientid, diagid, diagdt, created and modified details
                            if (patientProperty.Name != "LastName" && patientProperty.Name != "FName" && patientProperty.Name != "DOB" && patientProperty.Name != "DateESSent"
                                && patientProperty.Name != "CreatedBy" && patientProperty.Name != "CreatedDate" && patientProperty.Name != "LastSavedDate"
                                && patientProperty.Name != "LastSavedBy" && patientProperty.Name != "OptOffDate" && patientProperty.Name != "OptOffStatId" &&
                                patientProperty.Name != "PriSiteId" && patientProperty.Name != "CountryId")
                            {
                                if (patientProperty.PropertyType == typeof(string))
                                {
                                    patientProperty.SetValue(patient, string.Empty);
                                }
                                else
                                {
                                    patientProperty.SetValue(patient, null);
                                }
                            }
                        }
                    }

                    if (patientOperationDeviceRemove != null && patientOperationDeviceRemove.Count > 0)
                    {
                        for (int i = 0; i < patientOperationDeviceRemove.Count; i++)
                        {
                            unitOfWork.tbl_PatientOperationDeviceDtlsRepository.Delete(patientOperationDeviceRemove[i]);
                        }
                    }

                    if (patientFollowUpComplicationsRemove != null && patientFollowUpComplicationsRemove.Count > 0)
                    {
                        for (int i = 0; i < patientFollowUpComplicationsRemove.Count; i++)
                        {
                            unitOfWork.tbl_PatientComplicationsRepository.Delete(patientFollowUpComplicationsRemove[i]);
                        }
                    }

                    //Remove the followup calls associated with the patient
                    if (patientFollowupCallsRemove != null && patientFollowupCallsRemove.Count > 0)
                    {
                        foreach (int Id in patientFollowupCallsRemove)
                        {
                            unitOfWork.tbl_FollowUpCallRepository.Delete(Id);
                        }
                    }


                    if (patientOperationRemove != null && patientOperationRemove.Count > 0)
                    {
                        for (int i = 0; i < patientOperationRemove.Count; i++)
                        {
                            unitOfWork.tbl_PatientOperationRepository.Delete(patientOperationRemove[i]);
                        }
                    }

                    if (patientFollowUpRemove != null && patientFollowUpRemove.Count > 0)
                    {
                        for (int i = 0; i < patientFollowUpRemove.Count; i++)
                        {
                            unitOfWork.tbl_FollowUpRepository.Delete(patientFollowUpRemove[i]);
                        }
                    }
                }
                else if (optOffStatusId == "2")
                {
                    //DO NOT display patient on Follow Up Worklist AND/OR Missing Data Worklist
                    patient.HomePh = null;
                    patient.NoHomePh = true;
                    patient.MobPh = null;
                    patient.NoMobPh = true;
                }

                if (optOffStatusId == "3")
                {
                    patient.Undel = essUndelivered;
                    //DO NOT display patient on Follow Up Worklist AND/OR Missing Data Worklist
                }

                if (patient != null)
                {
                    unitOfWork.tbl_PatientRepository.Update(patient);
                }
                unitOfWork.Save();
            }
        }

        /// <summary>
        /// Search Patient on the basis of search criteria
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="patientURNNumber">Patient URN Number</param>
        /// <param name="givenName">Patient Given Name</param>
        /// <param name="familyName">Patient Family Name</param>
        /// <param name="dateOfBirth">Patient Date of Birth</param>
        /// <param name="gender">Patient Gender</param>
        /// <param name="medicare">Patient Medicare</param>
        /// <param name="country">Patient Country</param>
        /// <param name="patientDVANumber">Patient DVA Number</param>
        /// <param name="patientNHINumber">Patient NHI Number</param>
        /// <returns>Returns list of Patients satusfying search conditions</returns>
        public IEnumerable<PatientSearchListItem> GetPatientList(string userName,
            string patientURNNumber,
            string givenName,
            string familyName,
            DateTime? dateOfBirth,
            int? gender,
            string medicare,
            int? country,
            string patientDVANumber,
            string patientNHINumber)
        {
            Boolean isUserAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN) || Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
            IMembershipRepository membershipRepository = new MembershipRepository();
            int[] siteIds = membershipRepository.GetSiteIdsForUser(userName);

            IEnumerable<PatientSearchListItem> patientSearchList = null;

            patientSearchList = (from patients in _contextObject.tbl_Patient
                                 join genderMaster in _contextObject.tlkp_Gender on patients.GenderId equals genderMaster.Id into pj
                                 from genderMaster in pj.DefaultIfEmpty()
                                 join countryMaster in _contextObject.tlkp_Country on patients.CountryId equals countryMaster.Id
                                 join siteMaster in _contextObject.tbl_Site on patients.PriSiteId equals siteMaster.SiteId
                                 join patientURN in _contextObject.tbl_URN on patients.PatId equals patientURN.PatientID

                                 where
                                 patients.OptOffStatId == 0
                                 && (patientURNNumber != "" ? patientURN.URNo.ToUpper().Contains(patientURNNumber) : "" == "")
                                 && (givenName != "" ? patients.FName.ToUpper().Contains(givenName) : "" == "")
                                 && (familyName != "" ? patients.LastName.ToUpper().Contains(familyName) : "" == "")
                                 && (dateOfBirth != null ? patients.DOB == dateOfBirth : "" == "")
                                 && (patients.GenderId == null ? "" == "" : patients.GenderId == (gender != null ? gender : patients.GenderId))
                                 && (medicare != "" ? patients.McareNo.ToUpper().Contains(medicare) : "" == "")
                                 && patients.CountryId == (country != null ? country : patients.CountryId)
                                 && (patientDVANumber != "" ? patients.DvaNo.ToUpper().Contains(patientDVANumber) : "" == "")
                                 && (patientNHINumber != "" ? patients.NhiNo.ToUpper().Contains(patientNHINumber) : "" == "")
                                 select new PatientSearchListItem()
                                 {
                                     PatientId = patients.PatId,
                                     FamilyName = patients.LastName,
                                     GivenName = patients.FName,
                                     DOB = (DateTime)patients.DOB,
                                     Gender = (patients.tlkp_Gender != null) ? patients.tlkp_Gender.Description : string.Empty,
                                     Suburb = patients.Sub,
                                     Postcode = patients.Pcode,
                                     Medicare = patients.McareNo,
                                     DVANo = patients.DvaNo,
                                     NHI = patients.NhiNo,
                                     URN = patientURN.URNo,
                                     Site = siteMaster.SiteName,
                                     Country = countryMaster.Description
                                 }).Distinct().ToList<PatientSearchListItem>();

            return patientSearchList;
        }

        /// <summary>
        /// Search Patients with exact match
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="country">Patient Country</param>
        /// <param name="patientURNNumber">Patient URN</param>
        /// <param name="patientMedicare">Patient Medicare</param>
        /// <param name="patientDVANumber">Patient DVA Number</param>
        /// <param name="patientNHINumber">Patient NHI Number</param>
        /// <param name="patientId">Patient Id</param>
        /// <returns>Returns List of Patients with exact match</returns>
        public IEnumerable<PatientSearchListItem> GetPatientListWithExactDetails(string userName,
           int country,
           string patientURNNumber,
           string patientMedicare,
           string patientDVANumber,
           string patientNHINumber,
           string patientId)
        {
            Boolean isUserAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN) || Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
            IMembershipRepository memberRepository = new MembershipRepository();
            int[] siteIds = memberRepository.GetSiteIdsForUser(userName);
            IEnumerable<PatientSearchListItem> patientSearchList = null;
            int patientIdNumber = 0;
            bool isPatientIdAvailable = !string.IsNullOrEmpty(patientId);
            bool isPatientIdNumber = int.TryParse(patientId, out patientIdNumber);

            patientSearchList = (from patients in _contextObject.tbl_Patient
                                 join genderMaster in _contextObject.tlkp_Gender on patients.GenderId equals genderMaster.Id into pj
                                 from genderMaster in pj.DefaultIfEmpty()
                                 join optOffStatus in _contextObject.tlkp_OptOffStatus on patients.OptOffStatId equals optOffStatus.Id
                                 join countryMaster in _contextObject.tlkp_Country on patients.CountryId equals countryMaster.Id
                                 join patientURNMaster in _contextObject.tbl_URN on patients.PatId equals patientURNMaster.PatientID
                                 join siteMaster in _contextObject.tbl_Site on patientURNMaster.HospitalID equals siteMaster.SiteId
                                 where
                                 patients.CountryId == country
                                 && patientURNMaster.URNo == (patientURNNumber == "" ? patientURNMaster.URNo : patientURNNumber)
                                 && (patientDVANumber == "" ? "" == "" : patients.DvaNo == patientDVANumber)
                                 && (patientMedicare == "" ? "" == "" : patients.McareNo == patientMedicare)
                                 && (patientNHINumber == "" ? "" == "" : patients.NhiNo == patientNHINumber)
                                 && (!isPatientIdAvailable ? "" == "" : isPatientIdNumber ? patients.PatId == patientIdNumber : patients.PatId == -1)
                                 select new PatientSearchListItem()
                                 {
                                     PatientId = patients.PatId,
                                     FamilyName = patients.LastName,
                                     GivenName = patients.FName,
                                     DOB = (DateTime)patients.DOB,
                                     Gender = (patients.tlkp_Gender != null) ? patients.tlkp_Gender.Description : "",
                                     Suburb = patients.Sub,
                                     Postcode = patients.Pcode,
                                     Medicare = patients.McareNo,
                                     DVANo = patients.DvaNo,
                                     NHI = patients.NhiNo,
                                     URN = patientURNMaster.URNo,
                                     Site = siteMaster.SiteName,
                                     SiteId = siteMaster.SiteId,
                                     Country = countryMaster.Description,
                                     URId = patientURNMaster.URId,
                                     IHI = patients.IHI == null ? "" : patients.IHI,
                                     Status = (patients.tlkp_OptOffStatus != null) ? patients.tlkp_OptOffStatus.Description : "",
                                     StatusId = patients.OptOffStatId,
                                 }).Distinct().ToList<PatientSearchListItem>();

            return patientSearchList.OrderBy(k => k.FamilyName).ThenBy(k => k.GivenName);
        }

        /// <summary>
        /// Update Patient Followup Details
        /// </summary>
        /// <param name="patientId">Patient Id</param>
        /// <param name="reason">Reason</param>
        public void UpdatePatientFollowups(int patientId, string reason)
        {
            _contextObject.usp_ValidateFollowUpsForPatID(patientId, reason);
        }

        /// <summary>
        /// Gets Patients List for Given details
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="country">Patient Country</param>
        /// <param name="givenName">Patient Given Name</param>
        /// <param name="familyName">Patient Family Name</param>
        /// <param name="dateOfBirthFromParam">Patient From Date of Birth</param>
        /// <param name="dateOfBirthToParam">Patient To Date of Birth</param>
        /// <returns>Returns list of Patients</returns>
        public IEnumerable<PatientSearchListItem> GetPatientListForGivenDetails(
            string userName,
            int country,
            string givenName,
            string familyName,
            DateTime? dateOfBirthFromParam,
            DateTime? dateOfBirthToParam)
        {
            Boolean isUserAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN) || Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
            IMembershipRepository membershipRepository = new MembershipRepository();
            int[] siteIds = membershipRepository.GetSiteIdsForUser(userName);

            IEnumerable<PatientSearchListItem> patientSearchList = null;

            patientSearchList = (from patients in _contextObject.tbl_Patient
                                 join genderMaster in _contextObject.tlkp_Gender on patients.GenderId equals genderMaster.Id into pj
                                 from genderMaster in pj.DefaultIfEmpty()
                                 join optOffStatusMaster in _contextObject.tlkp_OptOffStatus on patients.OptOffStatId equals optOffStatusMaster.Id
                                 join countryMaster in _contextObject.tlkp_Country on patients.CountryId equals countryMaster.Id
                                 join patientURNMaster in _contextObject.tbl_URN on patients.PatId equals patientURNMaster.PatientID
                                 join siteMaster in _contextObject.tbl_Site on patientURNMaster.HospitalID equals siteMaster.SiteId
                                 where
                                 patients.CountryId == country
                                 && (givenName != "" ? patients.FName.ToUpper().StartsWith(givenName) : "" == "")
                                 && (familyName != "" ? patients.LastName.ToUpper().StartsWith(familyName) : "" == "")
                                 && (dateOfBirthFromParam != null ? patients.DOB >= dateOfBirthFromParam : "" == "")
                                 && (dateOfBirthToParam != null ? patients.DOB <= dateOfBirthToParam : "" == "")
                                 select new PatientSearchListItem()
                                 {
                                     PatientId = patients.PatId,
                                     FamilyName = patients.LastName,
                                     GivenName = patients.FName,
                                     DOB = (DateTime)patients.DOB,
                                     Gender = (patients.tlkp_Gender != null) ? patients.tlkp_Gender.Description : "",
                                     Suburb = patients.Sub,
                                     Postcode = patients.Pcode,
                                     Medicare = patients.McareNo,
                                     DVANo = patients.DvaNo,
                                     NHI = patients.NhiNo,
                                     URN = patientURNMaster.URNo,
                                     Site = siteMaster.SiteName,
                                     SiteId = siteMaster.SiteId,
                                     Country = countryMaster.Description,
                                     URId = patientURNMaster.URId,
                                     IHI = patients.IHI == null ? "" : patients.IHI,
                                     Status = (patients.tlkp_OptOffStatus != null) ? patients.tlkp_OptOffStatus.Description : "",
                                     StatusId = patients.OptOffStatId,
                                 }).Distinct().ToList<PatientSearchListItem>();

            return patientSearchList.OrderBy(k => k.FamilyName).ThenBy(k => k.GivenName);
        }

        /// <summary>
        /// Checks if Operation exist
        /// </summary>
        /// <param name="patientId">Patient Id</param>
        /// <param name="patientURN">Patient URN Number</param>
        /// <param name="hospitalId">Hospital Id</param>
        /// <returns>Returns Flag that indicates if Operation exists</returns>
        public bool IsOperationExists(int patientId, string patientURN, int hospitalId)
        {
            bool result = false;
            var operationCount = (from patientOperation in _contextObject.tbl_PatientOperation
                                  join patients in _contextObject.tbl_Patient on patientOperation.PatientId equals patients.PatId
                                  join patientURNMaster in _contextObject.tbl_URN on patients.PatId equals patientURNMaster.PatientID
                                  where patientOperation.Hosp == hospitalId && patientOperation.PatientId == patientId && patientURNMaster.URNo == patientURN
                                  select patientOperation.OpId).Count();

            if (operationCount > 0)
            {
                result = true;
            }
            return result;
        }

        /// <summary>
        /// Get Patient URN for the Patient ID
        /// </summary>
        /// <param name="patientId">Patient Id</param>
        /// <returns>Returns patient urn details</returns>
        public IEnumerable<PatientURN> GetURN(int patientId)
        {

            IEnumerable<PatientURN> patientURNList = null;

            patientURNList = (from patients in _contextObject.tbl_Patient
                              join patientURNMaster in _contextObject.tbl_URN on patients.PatId equals patientURNMaster.PatientID
                              join siteMaster in _contextObject.tbl_Site on patientURNMaster.HospitalID equals siteMaster.SiteId
                              where patients.PatId == patientId
                              select new PatientURN()
                              {
                                  URN = patientURNMaster.URNo,
                                  SiteName = siteMaster.SiteName,
                                  SiteId = siteMaster.SiteId,
                                  URId = patientURNMaster.URId
                              }).Distinct().ToList<PatientURN>();
            return patientURNList;
        }

        /// <summary>
        /// Get Patient Explanatory Statement Work List
        /// </summary>
        /// <param name="countryId">Country Id</param>
        /// <param name="surgeonId">Surgeon Id</param>
        /// <param name="siteId">Site Id</param>
        /// <returns>List of Patient Explanatory Statement Worklist</returns>
        public IEnumerable<PatientExplanatoryStatementWorkListItem> GetPatientESSWorkList(int countryId, int surgeonId, int siteId)
        {
            IEnumerable<PatientExplanatoryStatementWorkListItem> patientSearchList = null;

            //Gets the patients who are alive and don't have an ES sent date
            patientSearchList = (from patients in _contextObject.tbl_Patient
                                 join operations in _contextObject.tbl_PatientOperation on patients.PatId equals operations.PatientId into operationGroup
                                 from patientOperations in operationGroup.DefaultIfEmpty()
                                 from site in _contextObject.tbl_Site.Where(siteInfo => siteInfo.SiteId == patientOperations.Hosp || siteInfo.SiteId == patients.PriSiteId)
                                 from user in _contextObject.tbl_User.Where(userInfo => (userInfo.UserId == patientOperations.Surg) || (userInfo.UserId == patients.PriSurgId))
                                 join title in _contextObject.tlkp_Title on user.TitleId equals title.Id

                                 where patients.HStatId != 1 && patients.DateESSent == null
                                      && patients.CountryId == (countryId > 0 ? countryId : patients.CountryId)
                                      && patients.PriSurgId == (surgeonId > 0 ? surgeonId : patients.PriSurgId)
                                      && patients.PriSiteId == (siteId > 0 ? siteId : patients.PriSiteId)
                                      && patients.OptOffStatId == 3

                                 select new PatientExplanatoryStatementWorkListItem()
                                 {
                                     PatientId = patients.PatId,
                                     PrimarySurgeon = title.Description + " " + user.FName + " " + user.LastName,
                                     PrimaryHospital = site.SiteName,
                                     OperationDate = patientOperations.OpDate,
                                     OperationAge = patientOperations.OpAge,
                                     Title = (patients.TitleId != null) ? patients.tlkp_Title.Description : string.Empty,
                                     FamilyName = patients.LastName,
                                     GivenName = patients.FName,
                                     Gender = (patients.tlkp_Gender != null) ? patients.tlkp_Gender.Description : string.Empty,
                                     Street = patients.Addr,
                                     Suburb = patients.Sub,
                                     State = (patients.StateId != null) ? patients.tlkp_State.Description : string.Empty,
                                     Postcode = patients.Pcode
                                 }).Distinct().ToList<PatientExplanatoryStatementWorkListItem>();
            return patientSearchList;
        }

        /// <summary>
        /// Get List of Patient With LTFU status
        /// </summary>
        /// <returns>Return list of Patient with LTFU Status</returns>
        public IEnumerable<PatientLTFUListItem> GetPatientLTFUList()
        {
            DateTime currentDate = DateTime.Now;

            IEnumerable<PatientLTFUListItem> patientLTFUList = null;
            patientLTFUList = (from patients in _contextObject.tbl_Patient
                               let revisionOperation = _contextObject.tbl_PatientOperation.Where(x => x.PatientId == patients.PatId && x.OpStat != 0 && x.OpVal == 2).OrderByDescending(x => x.OpDate).FirstOrDefault()
                               let primaryOperation = _contextObject.tbl_PatientOperation.Where(x => x.PatientId == patients.PatId && x.OpStat == 0 && x.OpVal == 2).FirstOrDefault()
                               join followUp in _contextObject.tbl_FollowUp on patients.PatId equals followUp.PatientId into tempJoin0
                               from followUp in tempJoin0.DefaultIfEmpty()
                               where patients.OptOffStatId != null && patients.OptOffStatId == 4
                               select new PatientLTFUListItem()
                               {
                                   PatientId = patients.PatId,
                                   FamilyName = patients.LastName,
                                   GivenName = patients.FName,
                                   LastOperationDate = (DateTime)revisionOperation.OpDate,
                                   FirstOperationDate = (DateTime)primaryOperation.OpDate,
                                   LastFollowUpDate = followUp.FUDate == null ? "" :
                                       //Check if single digit - add a 0 in date and month part
                                         (SqlFunctions.StringConvert((decimal?)SqlFunctions.DatePart("dd", followUp.FUDate)).Trim().Length == 2 ?
                                         SqlFunctions.StringConvert((decimal?)SqlFunctions.DatePart("dd", followUp.FUDate)).Trim() :
                                         "0" + SqlFunctions.StringConvert((decimal?)SqlFunctions.DatePart("dd", followUp.FUDate)).Trim())
                                         + "/" +
                                         (SqlFunctions.StringConvert((decimal?)SqlFunctions.DatePart("MM", followUp.FUDate)).Trim().Length == 2 ?
                                         SqlFunctions.StringConvert((decimal?)SqlFunctions.DatePart("MM", followUp.FUDate)).Trim() :
                                         "0" + SqlFunctions.StringConvert((decimal?)SqlFunctions.DatePart("MM", followUp.FUDate)).Trim())
                                         + "/" +
                                         SqlFunctions.StringConvert((decimal?)SqlFunctions.DatePart("yyyy", followUp.FUDate)).Trim(),
                                   ActualFollowUpDate = followUp.FUDate == null ? currentDate : (DateTime)followUp.FUDate
                               }).OrderBy(p => p.PatientId).ToList<PatientLTFUListItem>();

            patientLTFUList = patientLTFUList.GroupBy(x => x.PatientId).Select(g => g.OrderByDescending(c => c.ActualFollowUpDate).FirstOrDefault()).ToList();
            return patientLTFUList;
        }

        /// Get Patient's UR Details
        /// </summary>
        /// <param name="patientURNumber">Patient URN</param>
        /// <param name="siteId">Site Id</param>
        /// <param name="surgeonId">Surgeon Id</param>
        /// <returns>Returns Patient's UR Details</returns>
        public URNItem GetPatientURDetails(string patientURNumber, int siteId, int surgeonId, string givenName, string familyName)
        {
            URNItem patientURNumberDetails;
            patientURNumberDetails = (from patients in _contextObject.tbl_Patient
                                      join patientURNMaster in _contextObject.tbl_URN on patients.PatId equals patientURNMaster.PatientID
                                      where
                                      (patientURNMaster.URNo == patientURNumber
                                      && patientURNMaster.HospitalID == siteId)
                                      || (patients.LastName == familyName
                                          || patients.FName == givenName)
                                      && patientURNMaster.tbl_Patient.PriSurgId == (surgeonId == -1 ? patientURNMaster.tbl_Patient.PriSurgId : surgeonId)
                                      select new URNItem
                                      {
                                          PatientID = patients.PatId,
                                          HospitalID = patientURNMaster.HospitalID,
                                          URId = patientURNMaster.URId,
                                          URNo = patientURNMaster.URNo,
                                          OperationtOffStatusID = patients.OptOffStatId
                                      }).OrderBy(p => p.PatientID).FirstOrDefault();
            return patientURNumberDetails;
        }

        /// <summary>
        /// Get Patient Details with matching Record Number
        /// </summary>
        /// <param name="recordNumber">Record Number</param>
        /// <returns>Patient Details</returns>
        public IEnumerable<MatchedPatientListItem> OneMatchingPatientPair(int recordNumber)
        {
            IEnumerable<MatchedPatientListItem> matchedPatients = null;
            matchedPatients = (from patients in _contextObject.ufn_Matching_Patients(recordNumber)
                               select new MatchedPatientListItem()
                               {
                                   PatientId = patients.PatId,
                                   PatientURN = patients.PatientURN,
                                   PatientFirstName = patients.FName,
                                   PatientLastName = patients.LastName,
                                   GenderID = patients.GenderId,
                                   DateOfBirth = patients.DOB,
                                   MedicareNo = patients.McareNo,
                                   DvaNo = patients.DvaNo,
                                   IHINo = patients.IHI,
                                   NhiNo = patients.NhiNo,
                                   Address = patients.Addr,
                                   Suburb = patients.Sub,
                                   State = patients.Patstate,
                                   Postcode = patients.Pcode,
                                   Country = patients.Country,
                                   PrimarySite = patients.PriSite,
                                   PrimarySurgeon = patients.PriSurg,
                                   Identifier = patients.Identifier,
                                   IdentifierNo = patients.IdentifierNo
                               }).ToList<MatchedPatientListItem>();
            return matchedPatients;
        }

        /// <summary>
        /// Find Matching patients
        /// </summary>
        /// <param name="recordNumber">Record Number</param>
        /// <returns>Returns two rows of patients that match to each other - First row relates to patient and the later one to the matching patients</returns>
        public IEnumerable<MatchedPatientListItem> GetOneMatchingPatientPair(int recordNumber)
        {
            IEnumerable<MatchedPatientListItem> matchedPatients = null;
            matchedPatients = (from patient in _contextObject.ufn_Matching_Patients(recordNumber)
                               select new MatchedPatientListItem()
                               {
                                   PatientId = patient.PatId,
                                   PatientURN = patient.PatientURN,
                                   PatientFirstName = patient.FName,
                                   PatientLastName = patient.LastName,
                                   GenderID = patient.GenderId,
                                   DateOfBirth = patient.DOB,
                                   MedicareNo = patient.McareNo,
                                   DvaNo = patient.DvaNo,
                                   IHINo = patient.IHI,
                                   NhiNo = patient.NhiNo,
                                   Address = patient.Addr,
                                   Suburb = patient.Sub,
                                   State = patient.Patstate,
                                   Postcode = patient.Pcode,
                                   Country = patient.Country,
                                   PrimarySite = patient.PriSite,
                                   PrimarySurgeon = patient.PriSurg,
                                   Identifier = patient.Identifier,
                                   IdentifierNo = patient.IdentifierNo,
                                   Gender = patient.Gender,
                                   OperationType = patient.OperationType,
                                   OperationSite = patient.OperationHospital,
                                   OperationDate = patient.OperationDate,
                                   OperationSurgeon = patient.PriOperationSurg,
                                   OperationURN = patient.PrimaryOpURN,
                                   HomePhone = patient.HomePh,
                                   MobilePhone = patient.MobPh,
                                   IndigenousStatus = patient.IndigenousSts,
                                   HealthStatus = patient.HealthSts,
                                   OperationProcedure = patient.OpProc,
                                   ProcAbon = patient.ProcAban,
                                   Title = patient.Title,
                                   NoOfMatchingPatients = (int)patient.No_of_Matching_Rec,
                                   OperationStatus = patient.OptOffSts
                               }).ToList<MatchedPatientListItem>();
            return matchedPatients;
        }

        /// <summary>
        /// Getting First Matching Patient's Pair
        /// </summary>
        /// <param name="recordNumber">Record Number</param>
        /// <returns>Returns Matching Patients pair</returns>
        public MatchedPatientPairsListItem GetFirstMatchingPatientPair(int recordNumber)
        {
            MatchedPatientPairsListItem matchedPatientsPair = null;
            IEnumerable<MatchedPatientListItem> matchedPatients = null;

            MatchedPatientListItem patient1 = new MatchedPatientListItem();
            MatchedPatientListItem patient2 = new MatchedPatientListItem();

            //Getting MatchingPatientForMerge patient
            matchedPatients = GetOneMatchingPatientPair(recordNumber).OrderBy(x => x.PatientId);
            if ((matchedPatients != null) && (matchedPatients.Count() > 1))
            {
                patient1 = matchedPatients.ElementAt(0);
                patient2 = matchedPatients.ElementAt(1);

                matchedPatientsPair = new MatchedPatientPairsListItem()
                {
                    PatientId1 = patient1.PatientId,
                    PatientURN1 = patient1.PatientURN,
                    PatientFirstName1 = patient1.PatientFirstName,
                    PatientLastName1 = patient1.PatientLastName,
                    GenderID1 = patient1.GenderID,
                    DOB1 = patient1.DateOfBirth,
                    MedicareNo1 = patient1.MedicareNo,
                    DvaNo1 = patient1.DvaNo,
                    IHI1 = patient1.IHINo,
                    NhiNo1 = patient1.NhiNo,
                    Addr1 = patient1.Address,
                    Suburb1 = patient1.Suburb,
                    State1 = patient1.State,
                    Postcode1 = patient1.Postcode,
                    Country1 = patient1.Country,
                    PriSite1 = patient1.PrimarySite,
                    PriSurg1 = patient1.PrimarySurgeon,
                    PriOpSurg1 = patient1.OperationSurgeon,
                    PriOpURN1 = patient1.OperationURN,
                    Identifier = patient1.Identifier,
                    IdentifierNo = patient1.IdentifierNo,
                    PatientId2 = patient2.PatientId,
                    PatientURN2 = patient2.PatientURN,
                    PatientFirstName2 = patient2.PatientFirstName,
                    PatientLastName2 = patient2.PatientLastName,
                    GenderID2 = patient2.GenderID,
                    DOB2 = patient2.DateOfBirth,
                    MedicareNo2 = patient2.MedicareNo,
                    DvaNo2 = patient2.DvaNo,
                    IHI2 = patient2.IHINo,
                    NhiNo2 = patient2.NhiNo,
                    Addr2 = patient2.Address,
                    Suburb2 = patient2.Suburb,
                    State2 = patient2.State,
                    Postcode2 = patient2.Postcode,
                    Country2 = patient2.Country,
                    PriSite2 = patient2.PrimarySite,
                    PriSurg2 = patient2.PrimarySurgeon,
                    PriOpSurg2 = patient2.OperationSurgeon,
                    PriOpURN2 = patient2.OperationURN,
                    Gender1 = patient1.Gender,
                    Gender2 = patient2.Gender,
                    OpType1 = patient1.OperationType,
                    OpType2 = patient2.OperationType,
                    OpSite1 = patient1.OperationSite,
                    OpSite2 = patient2.OperationSite,
                    HomePh1 = patient1.HomePhone,
                    HomePh2 = patient2.HomePhone,
                    MobPh1 = patient1.MobilePhone,
                    MobPh2 = patient2.MobilePhone,
                    IndigenousSts1 = patient1.IndigenousStatus,
                    IndigenousSts2 = patient2.IndigenousStatus,
                    opDate1 = patient1.OperationDate,
                    opDate2 = patient2.OperationDate,
                    HealthSts1 = patient1.HealthStatus,
                    HealthSts2 = patient2.HealthStatus,
                    OpProc1 = patient1.OperationProcedure,
                    OpProc2 = patient2.OperationProcedure,
                    ProcAbon1 = patient1.ProcAbon,
                    ProcAbon2 = patient2.ProcAbon,
                    Title1 = patient1.Title,
                    Title2 = patient2.Title,
                    NoOfMatchingPatients1 = patient1.NoOfMatchingPatients,
                    NoOfMatchingPatients2 = patient2.NoOfMatchingPatients,
                    OptOffSts1 = patient1.OperationStatus,
                    OptOffSts2 = patient2.OperationStatus
                };
            }
            return matchedPatientsPair;
        }

        /// <summary>
        /// Gets All Matching Patients pair in the Database
        /// </summary>
        /// <returns>Returns List of all patients that match to each other - Each row contains Patient1 and Patient2 details </returns>
        public IEnumerable<MatchedPatientPairsListItem> GetAllMatchingPatientPairs()
        {
            IEnumerable<MatchedPatientPairsListItem> matchedPatientsPairs = null;
            matchedPatientsPairs = (from patient in _contextObject.ufn_Matching_Patient_List()
                                    select new MatchedPatientPairsListItem()
                                    {
                                        PatientId1 = patient.OriPatId,
                                        PatientURN1 = patient.OriPatientURN,
                                        PatientFirstName1 = patient.OriFName,
                                        PatientLastName1 = patient.OriLastName,
                                        GenderID1 = patient.OriGenderId,
                                        DOB1 = patient.OriDOB,
                                        MedicareNo1 = patient.OriMcareNo,
                                        DvaNo1 = patient.OriDvaNo,
                                        IHI1 = patient.OriIHI,
                                        NhiNo1 = patient.OriNhiNo,
                                        Addr1 = patient.OriAddr,
                                        Suburb1 = patient.OriSub,
                                        State1 = patient.OriState,
                                        Postcode1 = patient.OriPcode,
                                        Country1 = patient.OriCountry,
                                        PriSite1 = patient.OriPriSite,
                                        PriSurg1 = patient.OriPriSurg,
                                        Identifier = patient.Identifier,
                                        IdentifierNo = patient.IdentifierNo,
                                        PatientId2 = patient.MatchingPatId,
                                        PatientURN2 = patient.MatchingPatientURN,
                                        PatientFirstName2 = patient.MatchingFName,
                                        PatientLastName2 = patient.MatchingLastName,
                                        GenderID2 = patient.MatchingGenderId,
                                        DOB2 = patient.MatchingDOB,
                                        MedicareNo2 = patient.MatchingMcareNo,
                                        DvaNo2 = patient.MatchingDvaNo,
                                        IHI2 = patient.MatchingIHI,
                                        NhiNo2 = patient.MatchingNhiNo,
                                        Addr2 = patient.MatchingAddr,
                                        Suburb2 = patient.MatchingSub,
                                        State2 = patient.MatchingState,
                                        Postcode2 = patient.MatchingPcode,
                                        Country2 = patient.MatchingCountry,
                                        PriSite2 = patient.MatchingPriSite,
                                        PriSurg2 = patient.MatchingPriSurg,
                                        Gender1 = patient.OriGender,
                                        Gender2 = patient.MatchingGender,
                                        OpType1 = patient.OriOperationType,
                                        OpType2 = patient.MatchingOperationType,
                                        OpSite1 = patient.OriHosp,
                                        OpSite2 = patient.MatchingHosp,
                                        HomePh1 = patient.OriHomePh,
                                        HomePh2 = patient.MatchingHomePh,
                                        MobPh1 = patient.OriMobPh,
                                        MobPh2 = patient.MatchingMobPh,
                                        IndigenousSts1 = patient.OriIndigenousSts,
                                        IndigenousSts2 = patient.MatchingIndigenousSts,
                                        opDate1 = patient.OriOpDate,
                                        opDate2 = patient.MatchingOpDate
                                    }).ToList<MatchedPatientPairsListItem>();

            return matchedPatientsPairs;
        }

        /// <summary>
        /// Deleting a Patient details from Database
        /// </summary>
        /// <param name="patientId">Patient Id</param>
        /// <param name="errorMessage">Error Message</param>
        /// <returns></returns>
        public bool DeletePatient(int? patientId, out string errorMessage)
        {
            errorMessage = "";
            bool isSuccess = true;
            try
            {
                var patientDeleted = _contextObject.usp_DeletePatient(patientId);
            }
            catch (Exception ex)
            {
                isSuccess = false;
                errorMessage = ex.Message;
            }
            return isSuccess;
        }

        /// <summary>
        /// Gets Patients List for Given details for surgeons and data collectors
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="givenName">Patient Given Name</param>
        /// <param name="familyName">Patient Family Name</param>
        /// <returns>Returns list of Patients</returns>
        public IEnumerable<PatientSearchListItem> GetPatientsListForGivenDetails(string userName, string givenName, string familyName, int surgeonID, int siteID)
        {
            IMembershipRepository membershipRepository = new MembershipRepository();
            int[] siteIds = membershipRepository.GetSiteIdsForUser(userName);

            IEnumerable<PatientSearchListItem> patientSearchList = null;
            IEnumerable<PatientSearchListItem> patientSearchListNew = null;

            patientSearchList = (from patients in _contextObject.tbl_Patient
                                 join genderMaster in _contextObject.tlkp_Gender on patients.GenderId equals genderMaster.Id into pj
                                 from genderMaster in pj.DefaultIfEmpty()
                                 join optOffStatusMaster in _contextObject.tlkp_OptOffStatus on patients.OptOffStatId equals optOffStatusMaster.Id
                                 join countryMaster in _contextObject.tlkp_Country on patients.CountryId equals countryMaster.Id
                                 join patientURNMaster in _contextObject.tbl_URN on patients.PatId equals patientURNMaster.PatientID
                                 join siteMaster in _contextObject.tbl_Site on patientURNMaster.HospitalID equals siteMaster.SiteId
                                 where
                                 (givenName != "" ? patients.FName.ToUpper().StartsWith(givenName) : "" == "")
                                 && (familyName != "" ? patients.LastName.ToUpper().StartsWith(familyName) : "" == "")
                                 && patients.PriSurgId == (surgeonID == -1 ? patients.PriSurgId : surgeonID) && patientURNMaster.HospitalID == siteID
                                 select new PatientSearchListItem()
                                 {
                                     PatientId = patients.PatId,
                                     FamilyName = patients.LastName,
                                     GivenName = patients.FName,
                                     DOB = (DateTime)patients.DOB,
                                     Gender = (patients.tlkp_Gender != null) ? patients.tlkp_Gender.Description : "",
                                     Suburb = patients.Sub,
                                     Postcode = patients.Pcode,
                                     Medicare = patients.McareNo,
                                     DVANo = patients.DvaNo,
                                     NHI = patients.NhiNo,
                                     URN = patientURNMaster.URNo,
                                     Site = siteMaster.SiteName,
                                     SiteId = siteMaster.SiteId,
                                     Country = countryMaster.Description,
                                     URId = patientURNMaster.URId,
                                     IHI = patients.IHI == null ? "" : patients.IHI,
                                     Status = (patients.tlkp_OptOffStatus != null) ? patients.tlkp_OptOffStatus.Description : "",
                                     StatusId = patients.OptOffStatId,
                                 }).Distinct().ToList<PatientSearchListItem>();

            if (siteIds.Length != 0)
            {
                patientSearchListNew = (from a in patientSearchList
                                        join b in siteIds on a.SiteId equals b
                                        select a).ToList();
            }
            else
            {
                patientSearchListNew = patientSearchList.ToList();
            }

            return patientSearchListNew.OrderBy(k => k.FamilyName).ThenBy(k => k.GivenName);
        }

        /// <summary>
        /// Search Patients with exact match for surgeons and data collectors
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="patientURNNumber">Patient URN</param>
        /// <returns>Returns List of Patients with exact match</returns>
        public IEnumerable<PatientSearchListItem> GetPatientsListWithExactDetails(string userName, int siteID, string patientURNNumber, int surgeonID)
        {
            IMembershipRepository memberRepository = new MembershipRepository();
            int[] siteIds = memberRepository.GetSiteIdsForUser(userName);
            IEnumerable<PatientSearchListItem> patientSearchList = null;

            patientSearchList = (from patients in _contextObject.tbl_Patient
                                 join genderMaster in _contextObject.tlkp_Gender on patients.GenderId equals genderMaster.Id into pj
                                 from genderMaster in pj.DefaultIfEmpty()
                                 join optOffStatus in _contextObject.tlkp_OptOffStatus on patients.OptOffStatId equals optOffStatus.Id
                                 join countryMaster in _contextObject.tlkp_Country on patients.CountryId equals countryMaster.Id
                                 join patientURNMaster in _contextObject.tbl_URN on patients.PatId equals patientURNMaster.PatientID
                                 join siteMaster in _contextObject.tbl_Site on patientURNMaster.HospitalID equals siteMaster.SiteId
                                 where patientURNMaster.URNo == (patientURNNumber == "" ? patientURNMaster.URNo : patientURNNumber) && patientURNMaster.HospitalID == siteID
                                 && patients.PriSurgId == (surgeonID == -1 ? patients.PriSurgId : surgeonID)
                                 select new PatientSearchListItem()
                                 {
                                     PatientId = patients.PatId,
                                     FamilyName = patients.LastName,
                                     GivenName = patients.FName,
                                     DOB = (DateTime)patients.DOB,
                                     Gender = (patients.tlkp_Gender != null) ? patients.tlkp_Gender.Description : "",
                                     Suburb = patients.Sub,
                                     Postcode = patients.Pcode,
                                     Medicare = patients.McareNo,
                                     DVANo = patients.DvaNo,
                                     NHI = patients.NhiNo,
                                     URN = patientURNMaster.URNo,
                                     Site = siteMaster.SiteName,
                                     SiteId = siteMaster.SiteId,
                                     Country = countryMaster.Description,
                                     URId = patientURNMaster.URId,
                                     IHI = patients.IHI == null ? "" : patients.IHI,
                                     Status = (patients.tlkp_OptOffStatus != null) ? patients.tlkp_OptOffStatus.Description : "",
                                     StatusId = patients.OptOffStatId,
                                 }).Distinct().ToList<PatientSearchListItem>();

            return patientSearchList.OrderBy(k => k.FamilyName).ThenBy(k => k.GivenName);
        }
    }
}
