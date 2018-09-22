using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Security;


namespace App.Business
{
    public class OperationRepository : GenericRepository<tbl_PatientOperation>
    {
        // Entity Framework context to the database
        private BusinessEntities _contextObject;

        /// <summary>
        /// Constructor method - Initializes database context
        /// </summary>
        /// <param name="context">Database Context</param>
        public OperationRepository(BusinessEntities context)
            : base(context)
        {
            this._contextObject = context;
        }

        /// <summary>
        /// Get Surgeon Operation List by Site
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <param name="withEmptyItem">Flag to add an empty item</param>
        /// <returns>Returns List of Lookup for Surgeon User Operations for Site</returns>
        public List<LookupItem> GetSurgeonUserOperationListLookupByUserSite(string userName, Boolean withEmptyItem)
        {
            Boolean isUserAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN) || Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
            Boolean isSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));
            List<LookupItem> surgeonList = new List<LookupItem>();

            using (UnitOfWork membershipRepository = new UnitOfWork())
            {

                string[] userSiteRoleName = membershipRepository.MembershipRepository.GetSiteRolesForUser(userName); //viewer
                MembershipUserCollection userList = new MembershipUserCollection();
                if (isSurgeon)
                {
                    userList.Add(Membership.GetUser(userName));
                }
                else
                {
                    foreach (string userRoleName in Roles.GetUsersInRole(BusinessConstants.ROLE_NAME_SURGEON))
                    {
                        String[] surgeonSite = membershipRepository.MembershipRepository.GetSiteRolesForUser(userRoleName);
                        Boolean surgeonSiteInUserSiteRole = false;

                        foreach (String siteRole in userSiteRoleName)
                        {
                            if (surgeonSite.Contains(siteRole))
                            {
                                surgeonSiteInUserSiteRole = true;
                            }
                        }

                        if (surgeonSiteInUserSiteRole || isUserAdmin)
                        {
                            userList.Add(Membership.GetUser(userRoleName));
                        }
                    }
                }

                if (withEmptyItem && !isSurgeon)
                {
                    surgeonList.Insert(0, new LookupItem() { Id = null, Description = null });
                }

                return surgeonList;
            }
        }

        /// <summary>
        /// Get User Id of the Surgeon User Name
        /// </summary>
        /// <param name="surgeonUserName">User Name</param>
        /// <returns>Returns User Id for the Surgeon User Name passed</returns>
        public string GetSurgeonId(string surgeonUserName)
        {
            var userId = (from user in _contextObject.tbl_User
                          join member in _contextObject.aspnet_Users on user.UId equals member.UserId
                          where member.UserName.ToLower() == surgeonUserName.ToLower()
                          select user.UserId).SingleOrDefault();

            return userId.ToString();
        }

        /// <summary>
        /// Get Site Id 
        /// </summary>
        /// <param name="patientId">Patient Id</param>
        /// <param name="surgeonId">Surgeon Id</param>
        /// <param name="patientURN">Patient URN</param>
        /// <returns>Returns Site ID</returns>
        public int? GetSiteId(int patientId, int? surgeonId, string patientURN)
        {
            var siteId = (from patientURNTable in _contextObject.tbl_URN
                          where patientURNTable.URNo == patientURN
                          select patientURNTable.HospitalID).FirstOrDefault();

            return siteId;
        }

        /// <summary>
        /// Check if Device is a single operation device
        /// </summary>
        /// <param name="operationId">Operation ID</param>
        /// <param name="deviceId">Device Id</param>
        /// <returns>Returns flag indicating if its single Operation Device</returns>
        public bool IsSingleOperationDevice(int operationId, int deviceId)
        {
            bool result = false;
            var devicesCount = (from patientOperationDevice in _contextObject.tbl_PatientOperationDeviceDtls
                                join patientOperation in _contextObject.tbl_PatientOperation on patientOperationDevice.PatientOperationId equals patientOperation.OpId
                                where patientOperationDevice.PatientOperationId == operationId && patientOperation.OpVal == 2
                                select patientOperationDevice.PatientOperationDevId).Count();

            if (devicesCount == 1)
            {
                result = true;
            }
            else if (devicesCount == 2)
            {
                var childDeviceCount = (from pod in _contextObject.tbl_PatientOperationDeviceDtls
                                        where pod.ParentPatientOperationDevId == deviceId
                                        select pod.PatientOperationDevId).Count();

                if (childDeviceCount == 1)
                {
                    result = true;
                }
            }
            return result;
        }

        /// <summary>
        /// Get Patient Complications for an operation
        /// </summary>
        /// <param name="operationId">Operation Id</param>
        /// <returns>Returns Patient Complications</returns>
        public List<Int32> GetPatientComplications(int operationId)
        {
            List<Int32> patientComplicationsList = null;
            patientComplicationsList = (from patientComplications in _contextObject.tbl_PatientComplications
                                        where patientComplications.OpId == operationId
                                        select (int)patientComplications.ComplicationId).ToList();

            return patientComplicationsList;
        }

        /// <summary>
        /// Get Previous Followup for Patient
        /// </summary>
        /// <param name="PatientId">Patient Id</param>
        /// <param name="OpDate">Operation Date/param>
        /// <returns>Return Previous Followup Details</returns>
        public tbl_FollowUp GetPreviousFollowup(int patientId, DateTime operationDate)
        {
            tbl_FollowUp previousFollowup = null;
            previousFollowup = (from followUp in _contextObject.tbl_FollowUp
                                where followUp.PatientId == patientId && followUp.tbl_PatientOperation.OpDate < operationDate && followUp.FUPeriodId == 0
                                && (followUp.tbl_PatientOperation.ProcAban == false || followUp.tbl_PatientOperation.ProcAban == null)
                                orderby followUp.tbl_PatientOperation.OpDate descending
                                select followUp).FirstOrDefault();

            return previousFollowup;
        }

        /// <summary>
        /// Get Previous Operation for the Patient
        /// </summary>
        /// <param name="patientId">Patient Id</param>
        /// <param name="operationDate">Operation Date</param>
        /// <returns>Returns previous Patient Operations</returns>
        public tbl_PatientOperation GetPreviousOperation(int patientId, DateTime operationDate)
        {
            tbl_PatientOperation previousOperation = null;
            previousOperation = (from operation in _contextObject.tbl_PatientOperation
                                 where operation.PatientId == patientId && operation.OpDate < operationDate
                                         && (operation.ProcAban == false || operation.ProcAban == null)
                                 orderby operation.OpDate descending
                                 select operation).FirstOrDefault();

            return previousOperation;
        }

        /// <summary>
        /// Get Primary Operation Details for the Patient
        /// </summary>
        /// <param name="patientId">Patient Id</param>
        /// <returns>Returns Previous Operation details for Patient</returns>
        public IEnumerable<PatientOperationListItem> GetPrimaryOperationDetailsForPatientID(int patientId)
        {
            IEnumerable<PatientOperationListItem> patientOperationList = null;
            patientOperationList = (from patientOperation in _contextObject.tbl_PatientOperation
                                    join site in _contextObject.tbl_Site on patientOperation.Hosp equals site.SiteId
                                    join user in _contextObject.tbl_User on patientOperation.Surg equals user.UserId
                                    join procedure0 in _contextObject.tlkp_Procedure on patientOperation.OpType equals procedure0.Id into tempJoin0
                                    from procedure0 in tempJoin0.DefaultIfEmpty()
                                    join procedure1 in _contextObject.tlkp_Procedure on patientOperation.OpRevType equals procedure1.Id into tempJoin1
                                    from procedure1 in tempJoin1.DefaultIfEmpty()
                                    orderby patientOperation.OpDate descending

                                    where
                                    patientOperation.PatientId == patientId &&
                                    patientOperation.OpStat == 0
                                    select new PatientOperationListItem()
                                    {
                                        PatientId = patientOperation.PatientId,
                                        PatientOperationId = patientOperation.OpId,
                                        OperationDate = patientOperation.OpDate == null ? patientOperation.OpDate : (DateTime)patientOperation.OpDate,
                                        OperationType = (patientOperation.OpStat == 0) ? procedure0.Description : procedure1.Description,
                                        OperationStat = patientOperation.OpStat,
                                        Height = patientOperation.Ht == null ? 0 : (decimal)patientOperation.Ht,
                                        StartWeight = patientOperation.StWt == null ? 0 : (decimal)patientOperation.StWt,
                                        OperationSite = site.SiteName,
                                        DiabetesStatus = (patientOperation.tlkp_YesNoNotStated != null) ? patientOperation.tlkp_YesNoNotStated.Description : "",
                                        ProcAban = patientOperation.ProcAban == null ? false : patientOperation.ProcAban
                                    }).OrderBy(p => p.PatientId)
                                        .ThenByDescending(po => po.OperationDate).ToList<PatientOperationListItem>();

            return patientOperationList;
        }

        /// <summary>
        /// Get Revision Operation Details for the Patient
        /// </summary>
        /// <param name="patientId">Patient Id</param>
        /// <returns>Returns List of Revision operations for the patient</returns>
        public IEnumerable<PatientOperationListItem> GetRevisionOperationDetailsForPatientID(int patientId)
        {
            IEnumerable<PatientOperationListItem> patientOperationList = null;
            patientOperationList = (from patientOperation in _contextObject.tbl_PatientOperation
                                    join site in _contextObject.tbl_Site on patientOperation.Hosp equals site.SiteId
                                    join user in _contextObject.tbl_User on patientOperation.Surg equals user.UserId
                                    join procedure0 in _contextObject.tlkp_Procedure on patientOperation.OpType equals procedure0.Id into tempJoin0
                                    from procedure0 in tempJoin0.DefaultIfEmpty()
                                    join procedure1 in _contextObject.tlkp_Procedure on patientOperation.OpRevType equals procedure1.Id into tempJoin1
                                    from procedure1 in tempJoin1.DefaultIfEmpty()
                                    orderby patientOperation.OpDate descending
                                    where
                                    patientOperation.PatientId == patientId &&
                                    patientOperation.OpStat != 0
                                    select new PatientOperationListItem()
                                    {
                                        PatientId = patientOperation.PatientId,
                                        PatientOperationId = patientOperation.OpId,
                                        OperationDate = patientOperation.OpDate == null ? patientOperation.OpDate : (DateTime)patientOperation.OpDate,
                                        OperationType = (patientOperation.OpStat == 0) ? procedure0.Description : procedure1.Description,
                                        OperationStat = patientOperation.OpStat,
                                        Height = patientOperation.Ht == null ? 0 : (decimal)patientOperation.Ht,
                                        StartWeight = patientOperation.StWt == null ? 0 : (decimal)patientOperation.StWt,
                                        OperationSite = site.SiteName,
                                        DiabetesStatus = (patientOperation.tlkp_YesNoNotStated != null) ? patientOperation.tlkp_YesNoNotStated.Description : "",
                                        ProcAban = patientOperation.ProcAban == null ? false : patientOperation.ProcAban
                                    }).OrderBy(p => p.PatientId)
                                        .ThenByDescending(po => po.OperationDate).ToList<PatientOperationListItem>();
            return patientOperationList;
        }

        /// <summary>
        /// Get All Operation details for a Patient
        /// </summary>
        /// <param name="patientId">Patient Id</param>
        /// <param name="surgeonId">Surgeon Id</param>
        /// <returns>Returns list of All Operation for a Patient</returns>
        public IEnumerable<PatientOperationListItem> GetOperationDetailsForPatientID(int patientId, string surgeonId = "")
        {
            IEnumerable<PatientOperationListItem> patientOperationList = null;
            if (!string.IsNullOrEmpty(surgeonId))
            {
                int SurID = Convert.ToInt32(surgeonId);
                patientOperationList = (from patientOperation in _contextObject.tbl_PatientOperation
                                        join site in _contextObject.tbl_Site on patientOperation.Hosp equals site.SiteId
                                        join user in _contextObject.tbl_User on patientOperation.Surg equals user.UserId
                                        join title in _contextObject.tlkp_Title on user.TitleId equals title.Id
                                        join procedure0 in _contextObject.tlkp_Procedure on patientOperation.OpType equals procedure0.Id into tempJoin0
                                        from procedure0 in tempJoin0.DefaultIfEmpty()
                                        join procedure1 in _contextObject.tlkp_Procedure on patientOperation.OpRevType equals procedure1.Id into tempJoin1
                                        from procedure1 in tempJoin1.DefaultIfEmpty()
                                        orderby patientOperation.OpDate descending
                                        where
                                        patientOperation.Surg == SurID &&
                                        patientOperation.PatientId == patientId
                                        select new PatientOperationListItem()
                                        {
                                            PatientId = patientOperation.PatientId,
                                            PatientOperationId = patientOperation.OpId,
                                            OperationDate = patientOperation.OpDate == null ? patientOperation.OpDate : (DateTime)patientOperation.OpDate,
                                            OperationStatus = (patientOperation.tlkp_OperationStatus != null) ? patientOperation.tlkp_OperationStatus.Description : string.Empty,
                                            OperationType = (patientOperation.OpStat == 0) ? procedure0.Description : procedure1.Description,
                                            OperationStat = patientOperation.OpStat,
                                            OperationWeight = patientOperation.OpWt == null ? patientOperation.OpWt : (decimal)patientOperation.OpWt,
                                            Height = patientOperation.Ht == null ? 0 : (decimal)patientOperation.Ht,
                                            StartWeight = patientOperation.StWt == null ? 0 : (decimal)patientOperation.StWt.Value,
                                            OperationSite = site.SiteName,
                                            OperationSurgeon = title.Description + " " + user.FName + " " + user.LastName,
                                            DiabetesStatus = (patientOperation.tlkp_YesNoNotStated != null) ? patientOperation.tlkp_YesNoNotStated.Description : string.Empty,
                                            DiabetesTreatment = (patientOperation.tlkp_DiabetesTreatment != null) ? patientOperation.tlkp_DiabetesTreatment.Description : string.Empty,
                                            ProcAban = patientOperation.ProcAban,
                                            SiteID = patientOperation.Hosp
                                        }).OrderBy(p => p.PatientId)
                                   .ThenByDescending(po => po.OperationDate).ToList<PatientOperationListItem>();
            }
            else
            {
                patientOperationList = (from patientOperation in _contextObject.tbl_PatientOperation
                                        join site in _contextObject.tbl_Site on patientOperation.Hosp equals site.SiteId
                                        join user in _contextObject.tbl_User on patientOperation.Surg equals user.UserId
                                        join title in _contextObject.tlkp_Title on user.TitleId equals title.Id
                                        join procedure0 in _contextObject.tlkp_Procedure on patientOperation.OpType equals procedure0.Id into tempJoin0
                                        from procedure0 in tempJoin0.DefaultIfEmpty()
                                        join procedure1 in _contextObject.tlkp_Procedure on patientOperation.OpRevType equals procedure1.Id into tempJoin1
                                        from procedure1 in tempJoin1.DefaultIfEmpty()
                                        orderby patientOperation.OpDate descending
                                        where
                                        patientOperation.PatientId == patientId
                                        select new PatientOperationListItem()
                                        {
                                            PatientId = patientOperation.PatientId,
                                            PatientOperationId = patientOperation.OpId,
                                            OperationDate = patientOperation.OpDate == null ? patientOperation.OpDate : (DateTime)patientOperation.OpDate,
                                            OperationStatus = (patientOperation.tlkp_OperationStatus != null) ? patientOperation.tlkp_OperationStatus.Description : string.Empty,
                                            OperationType = (patientOperation.OpStat == 0) ? procedure0.Description : procedure1.Description,
                                            OperationStat = patientOperation.OpStat,
                                            OperationWeight = patientOperation.OpWt == null ? patientOperation.OpWt : (decimal)patientOperation.OpWt,
                                            Height = patientOperation.Ht == null ? 0 : (decimal)patientOperation.Ht,
                                            StartWeight = patientOperation.StWt == null ? 0 : (decimal)patientOperation.StWt,
                                            OperationSite = site.SiteName,
                                            OperationSurgeon = title.Description + " " + user.FName + " " + user.LastName,
                                            DiabetesStatus = (patientOperation.tlkp_YesNoNotStated != null) ? patientOperation.tlkp_YesNoNotStated.Description : string.Empty,
                                            DiabetesTreatment = (patientOperation.tlkp_DiabetesTreatment != null) ? patientOperation.tlkp_DiabetesTreatment.Description : string.Empty,
                                            ProcAban = patientOperation.ProcAban
                                        }).OrderBy(p => p.PatientId)
                                        .ThenByDescending(po => po.OperationDate).ToList<PatientOperationListItem>();
            }
            return patientOperationList;
        }

        /// <summary>
        /// Get All Device List for an Operation
        /// </summary>
        /// <param name="operationid">Patient Operation Id</param>
        /// <returns>Returns List of Devices for an Operation</returns>
        public IEnumerable<PatientDeviceListItem> GetDeviceListForOperation(int operationid)
        {
            IEnumerable<PatientDeviceListItem> patientOperationList = null;

            patientOperationList = (from patientOperation in _contextObject.tbl_PatientOperationDeviceDtls
                                    join site in _contextObject.tbl_Device on patientOperation.DevId equals site.DeviceId
                                    join user in _contextObject.tbl_DeviceBrand on site.DeviceBrandId equals user.Id
                                    where
                                    patientOperation.PatientOperationId == operationid
                                    select new PatientDeviceListItem()
                                    {
                                        PatientOperationDevId = patientOperation.PatientOperationDevId,
                                        DeviceType = (user.tlkp_DeviceType != null) ? user.tlkp_DeviceType.Description : string.Empty,
                                        DeviceBrand = (site.tbl_DeviceBrand != null) ? site.tbl_DeviceBrand.Description : string.Empty,
                                        DeviceModel = site.DeviceModel,
                                        LotNo = patientOperation.DevLotNo,
                                        DeviceDescription = site.DeviceDescription,
                                        DeviceManufacturer = (user.tlkp_DeviceManufacturer != null) ? user.tlkp_DeviceManufacturer.Description : string.Empty,
                                        ParentPatientOperationDevId = patientOperation.ParentPatientOperationDevId
                                    }).Union
                                     (from dev in _contextObject.tbl_PatientOperationDeviceDtls
                                      where
                                      dev.PatientOperationId == operationid &&
                                     dev.DevId == null
                                      select new PatientDeviceListItem()
                                      {
                                          PatientOperationDevId = dev.PatientOperationDevId,
                                          DeviceType = (dev.tlkp_DeviceType != null) ? dev.tlkp_DeviceType.Description : string.Empty,
                                          DeviceBrand = (dev.DevOthBrand == string.Empty || dev.DevOthBrand == null) ? ((dev.tbl_DeviceBrand != null) ? dev.tbl_DeviceBrand.Description : string.Empty) : "Other",
                                          DeviceModel = "Other",
                                          LotNo = dev.DevLotNo,
                                          DeviceDescription = "Other",
                                          DeviceManufacturer = (dev.DevOthManuf == string.Empty || dev.DevOthManuf == null) ? ((dev.tlkp_DeviceManufacturer != null) ? dev.tlkp_DeviceManufacturer.Description : string.Empty) : "Other",
                                          ParentPatientOperationDevId = dev.ParentPatientOperationDevId
                                      }).ToList<PatientDeviceListItem>();
            patientOperationList = patientOperationList.OrderByDescending(p => p.PatientOperationDevId);

            return patientOperationList;
        }

        /// <summary>
        /// Method will give the result as true if both patients have revision operation on same date
        /// </summary>
        /// <param name="patientID1">Patient ID 1 (original Patient)</param>
        /// <param name="patientID2">Patient ID 2 (matched patient)</param>
        /// <returns></returns>
        public bool IsRevisionOperationOnSameDate(int patientID1, int patientID2)
        {
            bool isExists = false;
            List<DateTime?> revOptListPat1 = GetRevisionOperationDetailsForPatientID(patientID1).Select(c => c.OperationDate).ToList();
            List<DateTime?> revOptListPat2 = GetRevisionOperationDetailsForPatientID(patientID2).Select(c => c.OperationDate).ToList();
            List<DateTime?> commonOpDateList = new List<DateTime?>();

            if (revOptListPat1.Count > 0 && revOptListPat2.Count > 0)
                commonOpDateList = revOptListPat1.Intersect(revOptListPat2).ToList();

            if (commonOpDateList.Count > 0)
                isExists = true;
            else
                isExists = false;
            return isExists;
        }

        /// <summary>
        /// Method will give the result as true if one of the revision operation of Patient1 is before Primary opertaion of Patient 2 
        /// </summary>
        /// <param name="patientID1">Patient ID 1 (original Patient)</param>
        /// <param name="patientID2">Patient ID 2 (matched patient)</param>
        /// <returns></returns>
        public bool IsPrimaryOptAndRevOptMatch(int patientID1, int patientID2)
        {
            bool isExists = false;
            int countDate = 0;
            List<DateTime?> revOptListPat1 = GetRevisionOperationDetailsForPatientID(patientID1).Select(c => c.OperationDate).ToList();
            List<DateTime?> primaryOptListPat2 = GetPrimaryOperationDetailsForPatientID(patientID2).Select(c => c.OperationDate).ToList();

            if (revOptListPat1.Count > 0 && primaryOptListPat2.Count > 0)
                foreach (DateTime a in revOptListPat1.ToList())
                {
                    if (primaryOptListPat2.First() != null)
                    {
                        int result = DateTime.Compare(a, (DateTime)primaryOptListPat2.First());
                        if (result < 0)
                            countDate = countDate + 1;
                    }
                }
            if (countDate > 0)
                isExists = true;
            else
                isExists = false;
            return isExists;
        }

        /// <summary>
        /// Method will give the result as true if priamry operation of Patient1 is after any of the Revision opertaion of Patient 2 
        /// </summary>
        /// <param name="patientID1">Patient ID 1 (original Patient)</param>
        /// <param name="patientID2">Patient ID 2 (matched patient)</param>
        /// <returns></returns>
        public bool IsPrimaryOptAfterRevOpt(int patientID1, int patientID2)
        {
            bool isExists = false;
            int countDate = 0;
            List<DateTime?> priOptListPat1 = GetPrimaryOperationDetailsForPatientID(patientID1).Select(c => c.OperationDate).ToList();
            List<DateTime?> revOptListPat2 = GetRevisionOperationDetailsForPatientID(patientID2).Select(c => c.OperationDate).ToList();

            if (priOptListPat1.Count > 0 && revOptListPat2.Count > 0)
                foreach (DateTime a in revOptListPat2.ToList())
                {
                    if (priOptListPat1.First() != null)
                    {
                        int result = DateTime.Compare(a, (DateTime)priOptListPat1.First());
                        if (result < 0)
                            countDate = countDate + 1;
                    }
                }
            if (countDate > 0)
                isExists = true;
            else
                isExists = false;
            return isExists;
        }

        /// <summary>
        /// Method returns true if hospital of both patients is same and if any of the URN is different
        /// </summary>
        /// <param name="patientID1">Patient ID of patient 1</param>
        /// <param name="patientID2">Patient ID of Patient 2</param>
        /// <param name="site">Site name as it is same for both</param>
        /// <returns>bool value</returns>
        public bool IsURNDifferentWithSameHospital(int patientID1, int patientID2, string site)
        {
            bool isDifferent = false;
            List<string> patient1URNList = new List<string>();
            List<string> patient2URNList = new List<string>();
            List<string> commonURNs = new List<string>();
            int siteID = (from a in _contextObject.tbl_Site where a.SiteName == site select a.SiteId).FirstOrDefault();

            patient1URNList = (from urn1 in _contextObject.tbl_URN
                               where urn1.PatientID == patientID1 && urn1.HospitalID == siteID
                               select urn1.URNo).Distinct().ToList();

            patient2URNList = (from urn2 in _contextObject.tbl_URN
                               where urn2.PatientID == patientID2 && urn2.HospitalID == siteID
                               select urn2.URNo).Distinct().ToList();

            commonURNs = patient1URNList.Except(patient2URNList).Union(patient2URNList.Except(patient1URNList)).ToList();

            if (commonURNs.Count > 0)
                isDifferent = true;
            else
                isDifferent = false;
            return isDifferent;
        }

        /// <summary>
        /// This method is used to check if procedure in operation requires device or not
        /// </summary>
        /// <param name="operationId">Operation ID</param>
        /// <returns>It will return false if procedure does not require device</returns>
        public bool IsDeviceRequiredForProcedure(int operationId)
        {
            bool isRequired = false;
            List<int> checkValues = new List<int>();
            checkValues = (from a in _contextObject.tlkp_Procedure where a.IsDeviceRequired == false select a.Id).ToList();
            PatientOperationModel operationDetails = new PatientOperationModel();
            operationDetails = (from a in _contextObject.tbl_PatientOperation
                                where a.OpId == operationId
                                select new PatientOperationModel
                                {
                                    OpType = a.OpType,
                                    OpRevType = a.OpRevType,
                                    ProcAban = a.ProcAban
                                }).FirstOrDefault();
            if (operationDetails != null)
            {
                if (checkValues.Contains(Convert.ToInt32(operationDetails.OpType)) || checkValues.Contains(Convert.ToInt32(operationDetails.OpRevType)) || operationDetails.ProcAban == true)
                    isRequired = false;
                else
                    isRequired = true;
            }
            return isRequired;
        }

        /// <summary>
        /// This method will fetch list of procedure IDs which doesn't require device
        /// </summary>
        /// <returns></returns>
        public List<int> GetIsRequiredDeviceProcedureList()
        {
            List<int> deviceRequiredProcedures = new List<int>();
            deviceRequiredProcedures = (from a in _contextObject.tlkp_Procedure where a.IsDeviceRequired == false select a.Id).ToList();
            return deviceRequiredProcedures.ToList();
        }
    }
}