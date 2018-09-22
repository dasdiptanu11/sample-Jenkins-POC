using System;
using System.Linq;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.Objects;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data.Objects.SqlClient;

namespace App.Business
{
    public partial class UnitOfWork
    {
        /// <summary>
        /// Gets user details from backend
        /// </summary>
        /// <param name="withEmptyItem">boolean flag represent first row of the list is empty or not</param>
        /// <returns>user details list</returns>
        public List<LookupItem> Get_tlkp_aspnet_user(bool withEmptyItem)
        {
            // string id
            List<LookupItem> items;
            using (UnitOfWork userDetails = new UnitOfWork())
            {
                items = (from lookup in userDetails.aspnet_UsersRepository.Get(orderBy: x => x.OrderBy(q => q.UserName))
                         select new LookupItem() { Id = lookup.UserName.ToString(), Description = lookup.UserName }
                         ).ToList<LookupItem>();

                if (withEmptyItem)
                {
                    items.Insert(0, new LookupItem() { Id = null, Description = null });
                }
            }


            return items;
        }

        /// <summary>
        /// Get Surgeon details from backend
        /// </summary>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <param name="withAllItem">Boolean flag represent first row of the list is having 'All' word</param>
        /// <param name="userName"></param>
        /// <returns>Surgeon details list</returns>
        public List<LookupItem> Get_tlkp_aspnet_user_Surgeon(bool withEmptyItem, bool withAllItem, string userName = "")
        {
            // string id
            List<LookupItem> items;
            List<LookupItem> clinicians;
            Boolean IsSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));


            using (UnitOfWork userDetails = new UnitOfWork())
            {
                clinicians = (from lookup in userDetails.vw_aspnet_UsersRepository.Get(orderBy: x => x.OrderBy(q => q.UserName))
                              join uir in userDetails.vw_aspnet_UsersInRolesRepository.Get() on lookup.UserId equals uir.UserId
                              join uir_r in userDetails.vw_aspnet_RolesRepository.Get() on uir.RoleId equals uir_r.RoleId
                              where uir_r.RoleName == "SURGEON"
                              select new LookupItem() { Id = lookup.UserId.ToString(), Description = lookup.UserName }
                         ).ToList<LookupItem>();
                if (IsSurgeon && !(string.IsNullOrEmpty(userName)))
                {
                    items = (from lookup in userDetails.aspnet_UsersRepository.Get(orderBy: x => x.OrderBy(q => q.UserName))
                             join u in userDetails.tbl_UserRepository.Get() on lookup.UserId equals u.UId
                             join t in userDetails.tlkp_TitleRepository.Get() on u.TitleId equals t.Id
                             where ((from c in clinicians
                                     select c.Description).Contains(lookup.UserName)) && (lookup.UserName == userName)
                             select new LookupItem()
                             {
                                 Id = u.UserId.ToString(),
                                 //Description = t.Description.TrimEnd() + " " + u.FName + " " + u.LastName 
                                 Description = u.LastName + ", " + u.FName
                             }
                            ).OrderBy(x => x.Description).ToList<LookupItem>();
                }
                else
                {
                    items = (from lookup in userDetails.aspnet_UsersRepository.Get(orderBy: x => x.OrderBy(q => q.UserName))
                             join u in userDetails.tbl_UserRepository.Get() on lookup.UserId equals u.UId
                             join t in userDetails.tlkp_TitleRepository.Get() on u.TitleId equals t.Id
                             where (from c in clinicians
                                    select c.Description).Contains(lookup.UserName)
                             select new LookupItem()
                             {
                                 Id = u.UserId.ToString(),
                                 //Description = t.Description.TrimEnd() + " " + u.FName + " " + u.LastName 
                                 Description = u.LastName + ", " + u.FName
                             }
                                             ).OrderBy(x => x.Description).ToList<LookupItem>();
                }



                if (withAllItem && !IsSurgeon)
                {
                    items.Insert(0, new LookupItem() { Id = "0", Description = "All" });
                }

                if (withEmptyItem)
                {
                    items.Insert(0, new LookupItem() { Id = null, Description = null });
                }

            }
            return items;
        }

        /// <summary>
        /// Gets siteDetails from backend
        /// </summary>
        /// <param name="withEmptyItem">boolean flag represent first row of the list is empty or not</param>
        /// <param name="countryId">Id of the country</param>
        /// <param name="stateId">state Id</param>
        /// <returns>site details list</returns>
        public List<LookupItem> Get_tbl_Institute_AllInstituteApproved(bool withEmptyItem, string countryId = "", string stateId = "") //withSelectAllOptions
        {
            string siteRoleFilter = string.Empty;
            int siteActive = 1;

            if (stateId == null || countryId == null)
                return null;

            List<LookupItem> items;
            using (UnitOfWork siteDetails = new UnitOfWork())
            {
                if (stateId != "")
                {
                    items = (from lookup in siteDetails.tbl_SiteRepository.Get()
                             where lookup.SiteCountryId == Convert.ToInt32(countryId) && lookup.SiteStateId == Convert.ToInt32(stateId) && lookup.SiteStatusId == siteActive
                             select new LookupItem() { Id = lookup.SiteId.ToString(), Description = lookup.SiteName }
                             ).ToList<LookupItem>();
                }
                else
                {
                    items = (from lookup in siteDetails.tbl_SiteRepository.Get()
                             where lookup.SiteCountryId == Convert.ToInt32(countryId) && lookup.SiteStateId == siteActive
                             select new LookupItem() { Id = lookup.SiteId.ToString(), Description = lookup.SiteName }
                            ).ToList<LookupItem>();
                }
                if (withEmptyItem)
                {
                    items.Insert(0, new LookupItem() { Id = null, Description = null });
                }
            }


            return items;
        }

        /// <summary>
        /// Gets patient details from backend
        /// </summary>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <param name="givenName">patient name</param>
        /// <param name="dateOfBirth"> date of birth of patient</param>
        /// <param name="medicareNo">medicare number of the patient</param>
        /// <returns>patient details list</returns>
        public List<LookupItem> Get_tbl_Patient_CheckExisting(bool withEmptyItem, string givenName, DateTime dateOfBirth, string medicareNo)
        {

            List<LookupItem> items;
            using (UnitOfWork patientDetails = new UnitOfWork())
            {
                items = (from lookup in patientDetails.tbl_PatientRepository.Get(orderBy: x => x.OrderBy(q => q.FName)).Where(c => c.FName == givenName && c.DOB == dateOfBirth && c.McareNo == medicareNo)
                         select new LookupItem() { Id = lookup.PatId.ToString(), Description = lookup.FName + " " + lookup.LastName + " " + lookup.McareNo }
                         ).ToList<LookupItem>();

                if (withEmptyItem)
                {
                    items.Insert(0, new LookupItem() { Id = null, Description = null });
                }
            }

            return items;
        }

        /// <summary>
        /// Gets sites from backend
        /// </summary>
        /// <param name="userName">Surgeon Name</param>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <returns>site details list</returns>
        public List<LookupItem> Get_tlkp_aspnet_Surgeon_Sites(string userName, bool withEmptyItem)
        {
            // string id
            List<LookupItem> sites;
            using (UnitOfWork userDetails = new UnitOfWork())
            {
                sites = (from lookup in userDetails.vw_aspnet_UsersRepository.Get(orderBy: x => x.OrderBy(q => q.UserName))
                         join uir in userDetails.vw_aspnet_UsersInRolesRepository.Get() on lookup.UserId equals uir.UserId
                         join uir_r in userDetails.vw_aspnet_RolesRepository.Get() on uir.RoleId equals uir_r.RoleId
                         join ur_sites in userDetails.tbl_SiteRepository.Get() on uir_r.RoleName equals ur_sites.SiteRoleName
                         where uir_r.RoleName.StartsWith("S_") && lookup.UserName == userName
                         select new LookupItem() { Id = ur_sites.SiteId.ToString(), Description = ur_sites.SiteName }
                         ).ToList<LookupItem>();
                //foreach (var site in Sites)
                //{
                //    if (site.Description.IndexOf("S_") != -1)
                //    {
                //        site.Description = site.Description.Split('_')[1].ToString();
                //    }
                //}
                //List<LookupItem>  items = (from lookup in bl.tbl_SiteRepository.Get()
                //                           where (from c in Sites
                //                select c.Description).Equals(lookup.SiteId)
                //         select new LookupItem() { Id = lookup.SiteId.ToString(), Description = lookup.SiteName }
                //         ).ToList<LookupItem>();

                if (withEmptyItem)
                {
                    sites.Insert(0, new LookupItem() { Id = null, Description = null });
                }
            }
            return sites;
        }

        /// <summary>
        /// Gets Device manufacturer details from backend
        /// </summary>
        /// <param name="manufacturerDescription">manufacturer description</param>
        /// <returns>device details list</returns>
        public List<LookupItem> GetDeviceManufacturerForGivenDescription(string manufacturerDescription)
        {
            List<LookupItem> items;
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                items = (from lookup in deviceDetails.tlkp_DeviceManufacturerRepository.Get(x => x.Description.Trim().ToLower() == manufacturerDescription.Trim().ToLower())
                         select new LookupItem() { Id = Convert.ToString(lookup.Id), Description = lookup.Description }
                         ).ToList<LookupItem>();
            }
            return items;

        }

        /// <summary>
        /// Gets Device description
        /// </summary>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <param name="brandId">device brand id</param>
        /// <returns>device details list</returns>
        public List<LookupItem> GetDeviceDescriptionWithOther(bool withEmptyItem, string brandId)
        {
            List<LookupItem> items;
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                if (brandId == null)
                {
                    items = (from lookup in deviceDetails.tbl_DeviceRepository.Get()
                             select new LookupItem() { Id = lookup.DeviceId.ToString(), Description = lookup.DeviceDescription }
                             ).ToList<LookupItem>();
                }
                else
                {
                    items = (from lookup in deviceDetails.tbl_DeviceRepository.Get()
                             where lookup.DeviceBrandId.ToString() == brandId
                             select new LookupItem() { Id = lookup.DeviceId.ToString(), Description = lookup.DeviceDescription }
                            ).ToList<LookupItem>();
                }
            }
            items.Insert(items.Count, new LookupItem() { Id = "-1", Description = "Other" });
            if (withEmptyItem)
            {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }
            return items;

        }

        /// <summary>
        /// Gets reoperation reason from backend
        /// </summary>
        /// <param name="procedureType">procedure Id</param>
        /// <returns>Reoperation reason list</returns>
        public List<LookupItem> GetReoperationReason(int? procedureType)
        {
            List<LookupItem> items;
            using (UnitOfWork reoperationRepository = new UnitOfWork())
            {
                items = (from lookup in reoperationRepository.tbl_ComplicationsRepository.Get()
                         join reason in reoperationRepository.tlkp_ComplicationsRepository.Get() on lookup.ComplicationId equals reason.Id
                         where lookup.ProcedureId == procedureType
                         select new LookupItem() { Id = reason.Id.ToString(), Description = reason.Description }
                         ).ToList<LookupItem>();
            }
            return items;
        }

        /// <summary>
        /// Gets primary procedure from backend
        /// </summary>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <returns>primary procedure details list</returns>
        public List<LookupItem> GetPrimaryProcedure(bool withEmptyItem)
        {
            List<LookupItem> items;
            using (UnitOfWork procedureDetails = new UnitOfWork())
            {
                items = (from lookup in procedureDetails.tlkp_ProcedureRepository.Get()
                         where !(lookup.Id >= 10 && lookup.Id <= 18)
                         select new LookupItem() { Id = lookup.Id.ToString(), Description = lookup.Description }
                         ).ToList<LookupItem>();
            }
            if (withEmptyItem)
            {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }
            return items;
        }

        /// <summary>
        /// Gets primary procedure with 'All' from backend
        /// </summary>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <returns>primary procedure details list</returns>
        public List<LookupItem> GetPrimaryProcedureWithAll(bool withEmptyItem)
        {
            List<LookupItem> items;
            using (UnitOfWork procedureDetails = new UnitOfWork())
            {
                items = (from lookup in procedureDetails.tlkp_ProcedureRepository.Get()
                         where !(lookup.Id >= 10 && lookup.Id <= 18)
                         select new LookupItem() { Id = lookup.Id.ToString(), Description = lookup.Description }
                         ).ToList<LookupItem>();
            }
            items.Insert(0, new LookupItem() { Id = "0", Description = "All" });
            if (withEmptyItem)
            {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }
            return items;
        }

        /// <summary>
        /// Gets 'Yes' and 'No' confirmation
        /// </summary>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <returns>yesno repository list</returns>
        public List<LookupItem> GetYesNo(bool withEmptyItem)
        {
            List<LookupItem> items;
            using (UnitOfWork repository = new UnitOfWork())
            {
                items = (from lookup in repository.tlkp_YesNoRepository.Get()
                         orderby lookup.Id descending
                         select new LookupItem() { Id = lookup.Id.ToString(), Description = lookup.Description }
                         ).ToList<LookupItem>();
            }
            if (withEmptyItem)
            {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }
            return items;
        }

        /// <summary>
        /// Gets Brand description 
        /// </summary>
        /// <param name="brandDescription">brand description</param>
        /// <returns>brand details list</returns>
        public List<LookupItem> GetBrandForGivenDescription(string brandDescription)
        {
            List<LookupItem> items;
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                items = (from lookup in deviceDetails.tbl_DeviceBrandRepository.Get(x => x.Description == brandDescription)
                         select new LookupItem() { Id = Convert.ToString(lookup.Id), Description = lookup.Description }
                         ).ToList<LookupItem>();
            }
            return items;

        }

        /// <summary>
        /// Gets brand name
        /// </summary>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <param name="deviceType">device type</param>
        /// <returns>brand details list</returns>
        public List<LookupItem> GetBrandNamesWithOther(bool withEmptyItem, string deviceType)
        {
            List<LookupItem> items;
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                if (deviceType == null)
                {
                    items = (from lookup in deviceDetails.tbl_DeviceBrandRepository.Get()
                             select new LookupItem() { Id = Convert.ToString(lookup.Id), Description = lookup.Description }
                             ).ToList<LookupItem>();
                }
                else
                {
                    items = (from lookup in deviceDetails.tbl_DeviceBrandRepository.Get()
                             where lookup.TypeID.ToString() == deviceType
                             select new LookupItem() { Id = Convert.ToString(lookup.Id), Description = lookup.Description }
                             ).ToList<LookupItem>();
                }
            }
            items.Insert(items.Count, new LookupItem() { Id = "-1", Description = "Other" });
            if (withEmptyItem)
            {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }
            return items;
        }

        /// <summary>
        /// Gets manufacturer details
        /// </summary>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <param name="brandId">brand Id</param>
        /// <param name="withOther">Boolean flag represent first row of the list is having 'Other' word</param>
        /// <returns>manufacturer details list</returns>
        public List<LookupItem> GetManufacturersWithOther(bool withEmptyItem, string brandId, bool withOther)
        {
            List<LookupItem> items;
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                if (brandId == null)
                {
                    items = (from lookup in deviceDetails.tlkp_DeviceManufacturerRepository.Get()
                             select new LookupItem() { Id = Convert.ToString(lookup.Id), Description = lookup.Description }
                             ).ToList<LookupItem>();
                }
                else
                {
                    items = (from lookup in deviceDetails.tbl_DeviceBrandRepository.Get()
                             join dev in deviceDetails.tlkp_DeviceManufacturerRepository.Get() on lookup.ManufacturerId equals dev.Id
                             where lookup.Id.ToString() == brandId
                             select new LookupItem() { Id = Convert.ToString(dev.Id), Description = dev.Description }
                             ).ToList<LookupItem>();
                }
            }
            if (withOther)
            {
                items.Insert(items.Count, new LookupItem() { Id = "-1", Description = "Other" });
            }
            if (withEmptyItem)
            {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }
            return items;
        }

        /// <summary>
        /// Gets device model details
        /// </summary>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <param name="description">device description</param>
        /// <param name="withOtherItem">Boolean flag represent first row of the list is having 'Other' word</param>
        /// <returns>device model details list</returns>
        public List<LookupItem> GetModelWithOther(bool withEmptyItem, string description, bool withOtherItem)
        {
            List<LookupItem> items;
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                if (description == null)
                {
                    items = (from lookup in deviceDetails.tbl_DeviceRepository.Get()
                             where lookup.IsDeviceActive.ToString() == "1"
                             select new LookupItem() { Id = Convert.ToString(lookup.DeviceId), Description = lookup.DeviceModel }
                             ).ToList<LookupItem>();
                }
                else
                {
                    items = (from lookup in deviceDetails.tbl_DeviceRepository.Get()
                             where lookup.DeviceId.ToString() == description && lookup.IsDeviceActive.ToString() == "1"
                             select new LookupItem() { Id = Convert.ToString(lookup.DeviceId), Description = lookup.DeviceModel }
                           ).ToList<LookupItem>();
                }
            }
            if (withOtherItem)
            {
                items.Insert(items.Count, new LookupItem() { Id = "-1", Description = "Other" });
            }
            if (withEmptyItem)
            {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }
            return items;
        }

        /// <summary>
        /// Gets surgeon details
        /// </summary>
        /// <param name="surgeonId">Surgeon Id</param>
        /// <returns>Surgeon details list</returns>
        public string GetSurgeonById(int? surgeonId)
        {
            var surgeon = "";
            using (UnitOfWork userDetails = new UnitOfWork())
            {
                surgeon = (from u in userDetails.tbl_UserRepository.Get()
                           where u.UserId == surgeonId
                           select u.FName + " " + u.LastName).Single();
            }
            return surgeon;
        }

        /// <summary>
        /// Gets active surgeon details
        /// </summary>
        /// <param name="surgeonId">surgeon Id</param>
        /// <returns>Is surgeon is active or not</returns>
        public bool IsSurgeonActive(int? surgeonId)
        {
            int? active;
            using (UnitOfWork userDetails = new UnitOfWork())
            {
                active = (from u in userDetails.tbl_UserRepository.Get()
                          where u.UserId == surgeonId
                          select u.AccountStatusActive).Single();
            }
            if (active == 1)
                return true;
            else
                return false;

        }

        /// <summary>
        /// Gets surgeons details respective of sites
        /// </summary>
        /// <param name="siteId">site Id</param>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <param name="userName">surgeon name</param>
        /// <returns>Surgeons list</returns>
        public List<LookupItem> Get_SurgeonsForSites(int siteId, bool withEmptyItem, string userName = "")
        {
            List<LookupItem> surgeons;
            Boolean isSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));

            using (UnitOfWork userDetails = new UnitOfWork())
            {
                if (isSurgeon && !(string.IsNullOrEmpty(userName)))
                {
                    surgeons = (from lookup in userDetails.vw_aspnet_UsersRepository.Get(orderBy: x => x.OrderBy(q => q.UserName))
                                join u in userDetails.tbl_UserRepository.Get() on lookup.UserId equals u.UId
                                join t in userDetails.tlkp_TitleRepository.Get() on u.TitleId equals t.Id
                                join uir in userDetails.vw_aspnet_UsersInRolesRepository.Get() on lookup.UserId equals uir.UserId
                                join surgeon in userDetails.vw_aspnet_RolesRepository.Get() on uir.RoleId equals surgeon.RoleId
                                join uir2 in userDetails.vw_aspnet_UsersInRolesRepository.Get() on lookup.UserId equals uir2.UserId
                                join hosp in userDetails.vw_aspnet_RolesRepository.Get() on uir2.RoleId equals hosp.RoleId
                                join ts in userDetails.tbl_SiteRepository.Get() on hosp.RoleName equals ts.SiteRoleName
                                where surgeon.RoleName == "SURGEON" && ts.SiteId == siteId && u.AccountStatusActive == 1 && lookup.UserName.Trim().ToLower() == userName.Trim().ToLower()
                                select new LookupItem()
                                {
                                    Id = u.UserId.ToString(),
                                    //Description = t.Description.TrimEnd() + " " + u.FName + " " + u.LastName 
                                    Description = u.LastName + ", " + u.FName
                                }
                         ).OrderBy(x => x.Description).ToList<LookupItem>();
                }
                else
                {
                    surgeons = (from lookup in userDetails.vw_aspnet_UsersRepository.Get(orderBy: x => x.OrderBy(q => q.UserName))
                                join u in userDetails.tbl_UserRepository.Get() on lookup.UserId equals u.UId
                                join t in userDetails.tlkp_TitleRepository.Get() on u.TitleId equals t.Id
                                join uir in userDetails.vw_aspnet_UsersInRolesRepository.Get() on lookup.UserId equals uir.UserId
                                join surgeon in userDetails.vw_aspnet_RolesRepository.Get() on uir.RoleId equals surgeon.RoleId
                                join uir2 in userDetails.vw_aspnet_UsersInRolesRepository.Get() on lookup.UserId equals uir2.UserId
                                join hosp in userDetails.vw_aspnet_RolesRepository.Get() on uir2.RoleId equals hosp.RoleId
                                join ts in userDetails.tbl_SiteRepository.Get() on hosp.RoleName equals ts.SiteRoleName
                                where surgeon.RoleName == "SURGEON" && ts.SiteId == siteId && u.AccountStatusActive == 1
                                select new LookupItem()
                                {
                                    Id = u.UserId.ToString(),
                                    //Description = t.Description.TrimEnd() + " " + u.FName + " " + u.LastName 
                                    Description = u.LastName + ", " + u.FName
                                }
                         ).OrderBy(x => x.Description).ToList<LookupItem>();

                    if (withEmptyItem)
                    {
                        surgeons.Insert(0, new LookupItem() { Id = null, Description = null });
                    }
                }
            }
            return surgeons;
        }

        /// <summary>
        /// Gets patient name
        /// </summary>
        /// <param name="patientId">patient Id</param>
        /// <returns>patient name</returns>
        public string Get_Username(int patientId)
        {
            string patientName = "";
            using (UnitOfWork userDetails = new UnitOfWork())
            {
                patientName = (from asp_u in context.aspnet_Users
                               join u in context.tbl_User on asp_u.UserId equals u.UId
                               join p in context.tbl_Patient on u.UserId equals p.PriSurgId
                               where p.PatId == patientId
                               select asp_u.UserName).Single();
            }

            return patientName;
        }

        /// <summary>
        /// Gets Hospital List
        /// </summary>
        /// <param name="username">user name </param>
        /// <param name="countryID">country Id</param>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <param name="withAllItem">Boolean flag represent first row of the list is having 'All' word</param>
        /// <returns>hospital list</returns>
        public List<LookupItem> Get_HospitalList(string username, int countryID, bool withEmptyItem, bool withAllItem)
        {
            List<LookupItem> sites;
            Boolean isUserAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN) || Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
            IMembershipRepository memberRepository = new MembershipRepository();
            int[] siteIds = memberRepository.GetSiteIdsForUser(username);
            Boolean isSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));

            using (UnitOfWork siteDetails = new UnitOfWork())
            {
                sites = (from lookup in siteDetails.tbl_SiteRepository.Get()
                         where (siteIds.Contains(lookup.SiteId) || isUserAdmin == true
                          && lookup.SiteCountryId == (countryID > 0 ? countryID : lookup.SiteCountryId)) && lookup.SiteStatusId == 1
                         orderby lookup.SiteName
                         select new LookupItem() { Id = lookup.SiteId.ToString(), Description = lookup.SiteName }
                         ).ToList<LookupItem>();


                if (withEmptyItem)
                {
                    sites.Insert(0, new LookupItem() { Id = null, Description = null });
                }

                if (withAllItem && !isSurgeon)
                {
                    sites.Insert(0, new LookupItem() { Id = "-1", Description = "All" });
                }

            }
            return sites;
        }

        /// <summary>
        /// Gets all approved institutes with state details
        /// </summary>
        /// <param name="countryId">country Id</param>
        /// <returns>Site list</returns>
        public IEnumerable<SiteListItem> Get_AllInstituteApproved_WithStateDetails(string countryId)
        {
            IEnumerable<SiteListItem> siteList = null;
            int siteActive = 1;
            int countryID = Convert.ToInt32(countryId);

            using (UnitOfWork siteDetails = new UnitOfWork())
            {
                if (countryID == 1)
                {
                    siteList = (from s in context.tbl_Site
                                join sl in context.tlkp_State on s.SiteStateId equals sl.Id
                                where s.SiteCountryId == countryID && s.SiteStatusId == siteActive
                                select new SiteListItem()
                                {
                                    SiteId = s.SiteId,
                                    SiteName = s.SiteName,
                                    SiteStateId = s.SiteStateId == null ? -1 : (int)s.SiteStateId,
                                    SiteStateName = sl.Description
                                }).ToList<SiteListItem>();
                }
                else
                {
                    siteList = (from s in context.tbl_Site
                                where s.SiteCountryId == countryID && s.SiteStatusId == siteActive
                                select new SiteListItem()
                                {
                                    SiteId = s.SiteId,
                                    SiteName = s.SiteName,
                                    SiteStateId = s.SiteStateId == null ? -1 : (int)s.SiteStateId,
                                    SiteStateName = ""
                                }).ToList<SiteListItem>();
                }

            }

            return siteList;
        }

        /// <summary>
        /// Gets operatons status 
        /// </summary>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <param name="isLTFU">is patient is Lost to follow up</param>
        /// <returns>Operation details list</returns>
        public List<LookupItem> Get_tlkp_OptOffStatus(bool withEmptyItem, bool isLTFU)
        {

            List<LookupItem> items;
            using (UnitOfWork repository = new UnitOfWork())
            {
                if (isLTFU)
                {
                    items = (from lookup in repository.tlkp_OptOffStatusRepository.Get(orderBy: x => x.OrderBy(q => q.Id))
                             select new LookupItem() { Id = lookup.Id.ToString(), Description = lookup.Description }
                             ).ToList<LookupItem>();
                }
                else
                {
                    items = (from lookup in repository.tlkp_OptOffStatusRepository.Get(orderBy: x => x.OrderBy(q => q.Id))
                             where lookup.Id != 4
                             select new LookupItem() { Id = lookup.Id.ToString(), Description = lookup.Description }
                                            ).ToList<LookupItem>();
                }
                if (withEmptyItem)
                {
                    items.Insert(0, new LookupItem() { Id = null, Description = null });
                }
            }


            return items;
        }

        /// <summary>
        /// Gets device manufacturer with active flagset details
        /// </summary>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <returns>device details</returns>
        public List<LookupItem> Get_DeviceManufacturersWithActiveFlagSet(bool withEmptyItem)
        {
            List<LookupItem> items;
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                items = (from lookup in deviceDetails.tlkp_DeviceManufacturerRepository.Get(orderBy: x => x.OrderBy(q => q.Id)).Where(x => x.IsActive == 1)
                         select new LookupItem() { Id = lookup.Id.ToString(), Description = lookup.Description }
                         ).ToList<LookupItem>();

                if (withEmptyItem)
                {
                    items.Insert(0, new LookupItem() { Id = null, Description = null });
                }
            }


            return items;
        }
        /// <summary>
        /// Gets Surgeon based on Site Id
        /// </summary>
        /// <param name="siteCountryId">Represents the Country Id selected from dropdown</param>
        /// <returns>Surgeon details</returns>
        public List<LookupItem> Get_SurgeonForSites(int siteCountryId)
        {
            List<LookupItem> items;
            using (UnitOfWork countryDetails = new UnitOfWork())
            {
                items = (from favDevice in context.tbl_UserFavouriteDeviceDetails
                         join user in context.tbl_User on favDevice.SurgId equals user.UserId
                         where favDevice.CountryId == siteCountryId
                         select new 
                         {
                             Id = SqlFunctions.StringConvert((double)user.UserId),
                             Description = user.LastName + ", " + user.FName
                         }).Distinct().Select(x =>
                         new LookupItem()
                         {
                             Id = x.Id,
                             Description = x.Description
                         }).OrderByDescending(x=> x.Description).ToList<LookupItem>();
            }
            return items;
        }
        /// <summary>
        /// Gets Surgeon based on Country Id
        /// </summary>
        /// <param name="siteCountryId">Represents the Country Id selected from dropdown</param>
        /// <returns>Surgeon details</returns>
        public List<LookupItem> Get_SurgeonForCountry(int countryId, bool withEmptyItem, string userName)
        {
            List<LookupItem> items;
            Boolean isSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));
            Boolean isDataCollector = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_DATACOLLECTOR));
            using (UnitOfWork country = new UnitOfWork())
            {
                if (userName != "")
                {
                    IMembershipRepository memberRepository = new MembershipRepository();
                    int[] siteIds = memberRepository.GetSiteIdsForUser(userName);
                    if (isSurgeon)
                    {
                        items = (from lookup in country.vw_aspnet_UsersRepository.Get(orderBy: x => x.OrderBy(q => q.UserName))
                                 join u in country.tbl_UserRepository.Get() on lookup.UserId equals u.UId
                                 join t in country.tlkp_TitleRepository.Get() on u.TitleId equals t.Id
                                 join uir in country.vw_aspnet_UsersInRolesRepository.Get() on lookup.UserId equals uir.UserId
                                 join surgeon in country.vw_aspnet_RolesRepository.Get() on uir.RoleId equals surgeon.RoleId
                                 join uir2 in country.vw_aspnet_UsersInRolesRepository.Get() on lookup.UserId equals uir2.UserId
                                 join hosp in country.vw_aspnet_RolesRepository.Get() on uir2.RoleId equals hosp.RoleId
                                 join ts in country.tbl_SiteRepository.Get() on hosp.RoleName equals ts.SiteRoleName
                                 where siteIds.Contains(ts.SiteId) && surgeon.RoleName == "SURGEON" && u.AccountStatusActive == 1 && lookup.UserName.Trim().ToLower() == userName.Trim().ToLower()
                                 orderby u.LastName descending
                                 select new 
                                 {
                                     Id = u.UserId.ToString(),
                                     Description = u.LastName + ", " + u.FName
                                 }).Distinct().Select(x =>
                                  new LookupItem()
                                  {
                                      Id = x.Id,
                                      Description = x.Description
                                  })
                                 .OrderByDescending(x => x.Description).ToList<LookupItem>();
                    }
                    else
                    {
                        items = (from lookup in country.vw_aspnet_UsersRepository.Get(orderBy: x => x.OrderBy(q => q.UserName))
                                 join u in country.tbl_UserRepository.Get() on lookup.UserId equals u.UId
                                 join t in country.tlkp_TitleRepository.Get() on u.TitleId equals t.Id
                                 join uir in country.vw_aspnet_UsersInRolesRepository.Get() on lookup.UserId equals uir.UserId
                                 join surgeon in country.vw_aspnet_RolesRepository.Get() on uir.RoleId equals surgeon.RoleId
                                 join uir2 in country.vw_aspnet_UsersInRolesRepository.Get() on lookup.UserId equals uir2.UserId
                                 join hosp in country.vw_aspnet_RolesRepository.Get() on uir2.RoleId equals hosp.RoleId
                                 join ts in country.tbl_SiteRepository.Get() on hosp.RoleName equals ts.SiteRoleName
                                 where siteIds.Contains(ts.SiteId) && surgeon.RoleName == "SURGEON" && u.AccountStatusActive == 1
                                 orderby u.LastName descending
                                 select new LookupItem()
                                 {
                                     Id = u.UserId.ToString(),
                                     Description = u.LastName + ", " + u.FName
                                 }).OrderByDescending(x => x.Description).ToList<LookupItem>();
                    }
                }
                else
                {
                    items = (from lookup in country.tbl_UserRepository.Get()
                             join uir in country.vw_aspnet_UsersInRolesRepository.Get() on lookup.UId equals uir.UserId
                             join surgeon in country.vw_aspnet_RolesRepository.Get() on uir.RoleId equals surgeon.RoleId
                             where surgeon.RoleName == "SURGEON" && lookup.AccountStatusActive == 1 && lookup.CountryId == countryId
                             orderby lookup.LastName descending
                             select new LookupItem()
                             {
                                 Id = lookup.UserId.ToString(),
                                 Description = lookup.LastName + ", " + lookup.FName
                             }).OrderByDescending(x => x.Description).ToList<LookupItem>();
                    
                }
                if (withEmptyItem)
                {
                    items.Insert(0, new LookupItem() { Id = null, Description = null });
                }
            }
            return items;
        }
        /// <summary>
        /// Gets Site based on Country Id
        /// </summary>
        /// <param name="siteCountryId">Represents the Country Id selected from dropdown</param>
        /// <returns>Site details</returns>
        public List<LookupItem> Get_Site_Name(string username, int countryID, bool withEmptyItem, bool withAllItem)
        {
            List<LookupItem> sites;
            Boolean isUserAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN) || Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
            IMembershipRepository memberRepository = new MembershipRepository();
            int[] siteIds = memberRepository.GetSiteIdsForUser(username);
            Boolean isSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));

            using (UnitOfWork siteDetails = new UnitOfWork())
            {
                sites = (from lookup in siteDetails.tbl_SiteRepository.Get()
                         where (siteIds.Contains(lookup.SiteId)
                          && lookup.SiteCountryId == (countryID > 0 ? countryID : lookup.SiteCountryId)) && lookup.SiteStatusId == 1
                         orderby lookup.SiteName
                         select new LookupItem() { Id = lookup.SiteId.ToString(), Description = lookup.SiteName }
                         ).ToList<LookupItem>();


                if (withEmptyItem)
                {
                    sites.Insert(0, new LookupItem() { Id = null, Description = null });
                }

                if (withAllItem && !isSurgeon)
                {
                    sites.Insert(0, new LookupItem() { Id = "-1", Description = "All" });
                }

            }
            return sites;
        }
        /// <summary>
        /// Gets Country based on username
        /// </summary>
        /// <param name="userName">Represents the UserName</param>
        /// <returns>Country List</returns>
        public List<LookupItem> Get_Country(string userName)
        {
            List<LookupItem> countries;
            IMembershipRepository memberRepository = new MembershipRepository();
            int[] siteIds = memberRepository.GetSiteIdsForUser(userName);

            using (UnitOfWork country = new UnitOfWork())
            {
                countries = (from lookup in country.tbl_SiteRepository.Get()
                             join cntry in country.tlkp_CountryRepository.Get() on lookup.SiteCountryId equals cntry.Id
                             where (siteIds.Contains(lookup.SiteId))
                             select new
                             {
                                 Id = cntry.Id.ToString(),
                                 Description = cntry.Description
                             }).Distinct().Select(x =>
                             new LookupItem()
                             {
                                 Id = x.Id,
                                 Description = x.Description
                             }).ToList<LookupItem>();
            }

            return countries;
        }
        /// <summary>
        /// Gets Procedure List for Fav Device
        /// </summary>
        /// <param name="userName">Represents the UserName</param>
        /// <returns>Procedure List</returns>
        public List<LookupItem> Get_ProceduresList()
        {
            int[] typeIDs = { 1,3,4,5 };
            List<LookupItem> items;
            using (UnitOfWork procedure = new UnitOfWork())
            {
                items = (from lookup in procedure.tlkp_ProcedureRepository.Get()
                         where typeIDs.Contains(lookup.Id)
                         select new LookupItem()
                         {
                             Id = lookup.Id.ToString(),//SqlFunctions.StringConvert((double)lookup.Id),
                             Description = lookup.Description
                         }).ToList<LookupItem>();
            }

            return items;
        }
        /// <summary>
        /// Gets username from Id
        /// </summary>
        /// <param name="userId">Represents the UserId</param>
        /// <returns>UserName</returns>
        public string Get_Surgeon_UserName(int userId)
        {
            using (UnitOfWork user = new UnitOfWork())
            {
                var userName = (from aspnetuser in user.vw_aspnet_UsersRepository.Get()
                                join usr in user.tbl_UserRepository.Get() on aspnetuser.UserId equals usr.UId
                                where usr.UserId == userId
                                select aspnetuser.UserName);
                return userName.FirstOrDefault().ToString();
            }
        }
        /// <summary>
        /// Gets buttress type
        /// </summary>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <param name="deviceType">device type</param>
        /// <returns>Buttress Type list</returns>
        public List<LookupItem> GetButtressTypeWithOther(bool withEmptyItem, string buttressTypeId)
        {
            List<LookupItem> items;
            using (UnitOfWork deviceDetails = new UnitOfWork())
            {
                if (buttressTypeId == null)
                {
                    items = (from lookup in deviceDetails.tlkp_ButtressTypeRepository.Get()
                             where lookup.IsActive == 1
                             select new LookupItem() { Id = Convert.ToString(lookup.Id), Description = lookup.Description }
                             ).ToList<LookupItem>();
                }
                else
                {
                    items = (from lookup in deviceDetails.tlkp_ButtressTypeRepository.Get()
                             where lookup.Id.ToString() == buttressTypeId
                             select new LookupItem() { Id = Convert.ToString(lookup.Id), Description = lookup.Description }
                             ).ToList<LookupItem>();
                }
                if (withEmptyItem)
                {
                    items.Insert(0, new LookupItem() { Id = null, Description = null });
                }
                return items;
            }
        }
    }

}



