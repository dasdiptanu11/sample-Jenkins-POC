using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Security;
using App.Business;
using System.Data.Entity;
using System.Linq.Expressions;
using System.Data.Objects.SqlClient;

namespace App.Business {
    public class DeviceRepository : GenericRepository<tbl_Device> {
        // Entity Framework context to the database
       private BusinessEntities _context;

        /// <summary>
        /// Constructor method - Initializes database context
        /// </summary>
        /// <param name="context">Database Context</param>
        public DeviceRepository(BusinessEntities context)
            : base(context) {
            this._context = context;
        }

        /// <summary>
        /// Get Device Manufacturer list
        /// </summary>
        /// <param name="withEmptyItem">Flag that indicates whether to add an Empty Item in the list</param>
        /// <returns>Returns list of Device Manufcturer</returns>
        public List<LookupItem> GetDeviceManufacturers(bool withEmptyItem) {
            List<LookupItem> items;
            using (UnitOfWork unitOfWork = new UnitOfWork()) {
                items = (from lookup in unitOfWork.tlkp_DeviceManufacturerRepository.Get()
                         select new LookupItem() {
                             Id = lookup.Id.ToString(),
                             Description = lookup.Id + " - " + lookup.Description
                         }
                         ).ToList<LookupItem>();
            }

            if (withEmptyItem) {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }

            return items;
        }

        /// <summary>
        /// Get Device Brand List
        /// </summary>
        /// <param name="deviceType">Device Type</param>
        /// <param name="OnlyActiveValues">Active Values</param>
        /// <param name="withEmptyItem">Flag to add an empty item in the list</param>
        /// <returns>Returns list of Device Brands</returns>
        public List<LookupItem> GetDeviceBrands(int deviceType, int onlyActiveValues, bool withEmptyItem) {
            List<LookupItem> items;
            using (UnitOfWork unitOfWork = new UnitOfWork()) {
                items = (from lookup in unitOfWork.tbl_DeviceBrandRepository.Get()
                         where
                         lookup.IsActive == (onlyActiveValues == -1 ? lookup.IsActive : onlyActiveValues)
                         && lookup.TypeID == (deviceType == -1 ? lookup.TypeID : deviceType)
                         select new LookupItem() {
                             Id = lookup.Id.ToString(),
                             Description = lookup.Description
                         }
                         ).ToList<LookupItem>();
            }

            if (withEmptyItem) {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }

            return items;
        }

        /// <summary>
        /// Get Device Description
        /// </summary>
        /// <param name="deviceId">Device Id</param>
        /// <param name="onlyActiveValues">Active Values</param>
        /// <param name="withEmptyItem">Flag to add an empty item</param>
        /// <returns>Returns list of Device Description</returns>
        public List<LookupItem> GetDeviceDescriptions(int deviceId, int onlyActiveValues, bool withEmptyItem) {
            List<LookupItem> items;
            using (UnitOfWork unitOfWork = new UnitOfWork()) {
                items = (from lookup in unitOfWork.tbl_DeviceRepository.Get()
                         where
                         lookup.IsDeviceActive == (onlyActiveValues == -1 ? lookup.IsDeviceActive : onlyActiveValues)
                         && lookup.DeviceId == (deviceId < 1 ? lookup.DeviceId : deviceId)
                         select new LookupItem() {
                             Id = lookup.DeviceId.ToString(),
                             Description = lookup.DeviceDescription
                         }
                         ).ToList<LookupItem>();
            }

            if (withEmptyItem) {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }

            return items;
        }

        /// <summary>
        /// Gets All Device Types
        /// </summary>
        /// <param name="withEmptyItem">Flag to add an empty item</param>
        /// <returns>Returns list of Device Types</returns>
        public List<LookupItem> Get_tbl_DeviceType(bool withEmptyItem) {
            List<LookupItem> items;
            using (UnitOfWork unitOfWork = new UnitOfWork()) {
                items = (from lookup in unitOfWork.tlkp_DeviceTypeRepository.Get()
                         select new LookupItem() {
                             Id = lookup.Id.ToString(),
                             Description = lookup.Id + " - " + lookup.Description
                         }
                         ).ToList<LookupItem>();
            }

            if (withEmptyItem) {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }

            return items;
        }

        /// <summary>
        /// Get all the Device List
        /// </summary>
        /// <returns>Return list of devices</returns>
        public IEnumerable<DeviceList> GetDeviceList() {
            IEnumerable<DeviceList> deviceList = null;

            deviceList = (from device in _context.tbl_Device
                          join deviceBrand in _context.tbl_DeviceBrand on device.DeviceBrandId equals deviceBrand.Id
                          join deviceType in _context.tlkp_DeviceType on deviceBrand.TypeID equals deviceType.Id
                          join deviceManufacturer in _context.tlkp_DeviceManufacturer on deviceBrand.ManufacturerId equals deviceManufacturer.Id
                          select new DeviceList() {
                              DeviceId = device.DeviceId,
                              DeviceDescription = device.DeviceDescription,
                              IsDeviceActive = device.IsDeviceActive == null ? true : (device.IsDeviceActive == 1 ? true : false),
                              DeviceTypeId = deviceType.Id,
                              DeviceTypeDescription = deviceType.Description,
                              DeviceBrandId = device.DeviceBrandId,
                              DeviceBrandDescription = deviceBrand.Description,
                              IsBrandActive = deviceBrand.IsActive == null ? 1 : (int)deviceBrand.IsActive,
                              DeviceModel = device.DeviceModel,
                              DeviceManufacturerId = deviceBrand.ManufacturerId,
                              DeviceManufacturerDescription = deviceManufacturer.Description,
                              IsManufacturerActive = deviceManufacturer.IsActive == null ? 1 : (int)deviceManufacturer.IsActive,
                          }).OrderBy(p => p.DeviceTypeDescription).ToList<DeviceList>();


            return deviceList;
        }

        /// <summary>
        /// Gets Brand and Manufacturer List
        /// </summary>
        /// <param name="brand">Brand Name to filter</param>
        /// <param name="manufacturer">Manufacturer name to Filter</param>
        /// <returns>Returns list of Brand Manufacturer List</returns>
        public IEnumerable<Brand_ManufactureList> GetBrandAndManfacturerList(string brand, string manufacturer) {
            IEnumerable<Brand_ManufactureList> manufacturerList = null;

            manufacturerList = (from deviceBrand in _context.tbl_DeviceBrand
                                join deviceManufacturer in _context.tlkp_DeviceManufacturer on deviceBrand.ManufacturerId equals deviceManufacturer.Id
                                where deviceBrand.Description == (string.IsNullOrEmpty(brand) ? deviceBrand.Description : brand)
                                  && deviceManufacturer.Description == (string.IsNullOrEmpty(manufacturer) ? deviceManufacturer.Description : manufacturer)
                                select new Brand_ManufactureList() {
                                    DeviceBrandId = deviceBrand.Id,
                                    DeviceBrandDescription = deviceBrand.Description,
                                    DeviceManufacturerId = deviceBrand.ManufacturerId,
                                    DeviceManufacturerDescription = deviceManufacturer.Description
                                }).OrderBy(p => p.DeviceBrandId).ToList<Brand_ManufactureList>();

            return manufacturerList;
        }

        /// <summary>
        /// Gets Operation Device Models
        /// </summary>
        /// <param name="withEmptyItem">Flag to add an empty item</param>
        /// <returns>Returns List of Device Models</returns>
        public List<LookupItem> GetDeviceModels(bool withEmptyItem) {
            List<LookupItem> items;
            using (UnitOfWork unitOfWork = new UnitOfWork()) {
                items = (from lookup in unitOfWork.tbl_DeviceRepository.Get()
                         select new LookupItem() {
                             Id = lookup.DeviceId.ToString(),
                             Description = lookup.DeviceModel
                         }
                         ).ToList<LookupItem>();
            }

            if (withEmptyItem) {
                items.Insert(0, new LookupItem() { Id = null, Description = null });
            }

            return items;
        }

        /// <summary>
        /// Gets Patient Devices List
        /// </summary>
        /// <param name="deviceTypeId">Device Type Id</param>
        /// <param name="deviceBrandId">Device Brand</param>
        /// <param name="deviceModel">Device Model</param>
        /// <param name="deviceManufacturer">Device Manufacturer</param>
        /// <param name="deviceLotNo">Device Lot Number</param>
        /// <param name="deviceDescription">Device Description</param>
        /// <param name="userName">User Name</param>
        /// <returns>Returns list of Patient Device List</returns>
        public IEnumerable<PatientDeviceListItem> GetPatientsAndDeviceDetails(int deviceTypeId, int deviceBrandId, string deviceModel,
              string deviceManufacturer, string deviceLotNo, string deviceDescription, string userName) {
            IMembershipRepository membershipRepository = new MembershipRepository();

            Boolean isUserAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN) || Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
            int[] siteIds = membershipRepository.GetSiteIdsForUser(userName);

            IEnumerable<PatientDeviceListItem> patientDeviceList = null;

            patientDeviceList = (from patientOperation in _context.tbl_PatientOperation
                                 join patientURN in _context.tbl_URN on patientOperation.PatientId equals patientURN.PatientID
                                 join operationDetails in _context.tbl_PatientOperationDeviceDtls on patientOperation.OpId equals operationDetails.PatientOperationId
                                 join device in _context.tbl_Device on operationDetails.DevId equals device.DeviceId
                                 join deviceBrand in _context.tbl_DeviceBrand on device.DeviceBrandId equals deviceBrand.Id
                                 join deviceType in _context.tlkp_DeviceType on deviceBrand.TypeID equals deviceType.Id
                                 join deviceManufacturerTable in _context.tlkp_DeviceManufacturer on deviceBrand.ManufacturerId equals deviceManufacturerTable.Id
                                 where
                                  patientOperation.Hosp == patientURN.HospitalID
                                  && deviceBrand.TypeID == (deviceTypeId == -1 ? deviceBrand.TypeID : deviceTypeId)
                                  && device.DeviceBrandId == (deviceBrandId == -1 ? device.DeviceBrandId : deviceBrandId)
                                  && device.DeviceModel == (string.IsNullOrEmpty(deviceModel) ? device.DeviceModel : deviceModel)
                                  && deviceManufacturerTable.Description == (string.IsNullOrEmpty(deviceManufacturer) ? deviceManufacturerTable.Description : deviceManufacturer)
                                  && operationDetails.DevLotNo == (string.IsNullOrEmpty(deviceLotNo) ? operationDetails.DevLotNo : deviceLotNo)
                                  && device.DeviceDescription == (string.IsNullOrEmpty(deviceDescription) ? device.DeviceDescription : deviceDescription)
                                 select new PatientDeviceListItem() {
                                     URNo = patientURN.URNo,
                                     PatientId = patientOperation.PatientId,
                                     PatientOperationId = patientOperation.OpId,
                                     OperationDate = (DateTime)patientOperation.OpDate,
                                     DeviceType = deviceType.Description,
                                     DeviceManufacturer = deviceManufacturerTable.Description,
                                     DeviceBrand = deviceBrand.Description,
                                     DeviceModel = device.DeviceModel,
                                     DeviceDescription = device.DeviceDescription,
                                     LotNo = operationDetails.DevLotNo,
                                 }).OrderBy(p => p.PatientOperationId).ThenByDescending(po => po.OperationDate).ToList<PatientDeviceListItem>();

            return patientDeviceList;
        }

        /// <summary>
        /// Gets the list of Patients using a Device
        /// </summary>
        /// <param name="countryId">Patient Country Id</param>
        /// <param name="deviceTypeId">Patient Device Type Id</param>
        /// <param name="deviceBrandId">Patient Device Brand Id</param>
        /// <param name="deviceModel">Patient Device Model</param>
        /// <param name="deviceManufacturer">Patient Device Manufacturer</param>
        /// <param name="deviceLotNo">Patient Device Lot Number</param>
        /// <param name="deviceDescription">Patient Device Description</param>
        /// <param name="userName">User Name</param>
        /// <returns>Returns Patient Using Device List</returns>
        public IEnumerable<PatientUsingDevice> GetPatientListWithDevice(int countryId, int deviceTypeId, int deviceBrandId, string deviceModel,
                    string deviceManufacturer, string deviceLotNo, string deviceDescription, string userName) {

            IEnumerable<PatientUsingDevice> patientDeviceList = null;

            patientDeviceList = (from operationDetail in _context.tbl_PatientOperationDeviceDtls
                                 join device in _context.tbl_Device on operationDetail.DevId equals device.DeviceId
                                 join deviceBrand in _context.tbl_DeviceBrand on device.DeviceBrandId equals deviceBrand.Id
                                 join deviceType in _context.tlkp_DeviceType on deviceBrand.TypeID equals deviceType.Id
                                 join deviceManufacturerTable in _context.tlkp_DeviceManufacturer on deviceBrand.ManufacturerId equals deviceManufacturerTable.Id
                                 join patientOperation in _context.tbl_PatientOperation on operationDetail.PatientOperationId equals patientOperation.OpId
                                 join patient in _context.tbl_Patient on patientOperation.PatientId equals patient.PatId
                                 join patientState in _context.tlkp_State on patient.StateId equals patientState.Id into temp2
                                 from state in temp2.DefaultIfEmpty()
                                 join patientTitle in _context.tlkp_Title on patient.TitleId equals patientTitle.Id into temp1
                                 from title in temp1.DefaultIfEmpty()
                                 join patientURN in _context.tbl_URN on patientOperation.PatientId equals patientURN.PatientID
                                 join site in _context.tbl_Site on patient.PriSiteId equals site.SiteId
                                 join user in _context.tbl_User on patient.PriSurgId equals user.UserId
                                 join userTitle in _context.tlkp_Title on user.TitleId equals userTitle.Id
                                 join aspUser in _context.aspnet_Membership on user.UId equals aspUser.UserId
                                 where
                                  patientOperation.Hosp == patientURN.HospitalID
                                  && patient.CountryId == countryId
                                  && deviceBrand.TypeID == (deviceTypeId == -1 ? deviceBrand.TypeID : deviceTypeId)
                                  && device.DeviceBrandId == (deviceBrandId == -1 ? device.DeviceBrandId : deviceBrandId)
                                  && device.DeviceModel == (deviceModel == "" ? device.DeviceModel : deviceModel)
                                  && deviceManufacturerTable.Description == (deviceManufacturer == "" ? deviceManufacturerTable.Description : deviceManufacturer)
                                  && operationDetail.DevLotNo == (deviceLotNo == "" ? operationDetail.DevLotNo : deviceLotNo)
                                  && device.DeviceDescription == (deviceDescription == "" ? device.DeviceDescription : deviceDescription)
                                 select new PatientUsingDevice() {
                                     URNo = patientURN.URNo,
                                     PatientId = patientOperation.PatientId,
                                     PatientName = (title.Description == null ? "" : title.Description) + " " + patient.FName + " " + patient.LastName,
                                     PatientAddress = (patient.AddrNotKnown == null ? (patient.Addr + (patient.Sub == "" ? "" : "," + patient.Sub) + (state.Description == null ? "" : "," + state.Description))
                                                        :
                                                        (patient.AddrNotKnown == true ? "" : (patient.Addr + (patient.Sub == "" ? "" : "," + patient.Sub) + (state.Description == null ? "" : "," + state.Description)))),
                                     PatientTelephone = (patient.MobPh == null ? (patient.HomePh == null ? "" : patient.HomePh) : patient.MobPh),
                                     PatientPrimarySite = site.SiteName,
                                     PatientOperationId = patientOperation.OpId,
                                     OperationDate = (DateTime)patientOperation.OpDate,
                                     SurgeonName = title.Description + " " + user.FName + " " + user.LastName,
                                     SurgeonEmail = aspUser.Email,
                                     LotNo = operationDetail.DevLotNo,
                                     PatientMedicareNo = patient.McareNo == null ? "" : patient.McareNo,
                                     PatientNHINo = patient.NhiNo == null ? "" : patient.NhiNo,
                                     PatientIHI = patient.IHI == null ? "" : patient.IHI,
                                     PatientDOB = patient.DOB

                                 }).OrderBy(p => p.PatientOperationId).ThenByDescending(po => po.OperationDate).ToList<PatientUsingDevice>();

            return patientDeviceList;
        }

        /// <summary>
        /// Gets Patient Unknown Device details
        /// </summary>
        /// <param name="userName">User Name</param>
        /// <returns>Returns list of Patient Unknown Devices</returns>
        public IEnumerable<PatientUnknownDeviceListItem> GetUnknownDeviceDetails(string userName) {
            IMembershipRepository membershipReppsitory = new MembershipRepository();
            Boolean isUserAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN) || Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
            int[] siteIds = membershipReppsitory.GetSiteIdsForUser(userName);

            IEnumerable<PatientUnknownDeviceListItem> patientUnknowDeviceList = null;

            patientUnknowDeviceList = (from patientOperation in _context.tbl_PatientOperation
                                       join patientURN in _context.tbl_URN on patientOperation.PatientId equals patientURN.PatientID
                                       join operationDetails in _context.tbl_PatientOperationDeviceDtls on patientOperation.OpId equals operationDetails.PatientOperationId
                                       join deviceType in _context.tlkp_DeviceType on operationDetails.DevType equals deviceType.Id //into temp2 from dt in temp2.DefaultIfEmpty()
                                       join deviceBrand in _context.tbl_DeviceBrand on operationDetails.DevBrand equals deviceBrand.Id into temp1
                                       from brand in temp1.DefaultIfEmpty()
                                       join deviceManufacturer in _context.tlkp_DeviceManufacturer on operationDetails.DevManuf equals deviceManufacturer.Id into temp3
                                       from manufacturer in temp3.DefaultIfEmpty()
                                       where
                                       patientOperation.Hosp == patientURN.HospitalID
                                       && "" == (operationDetails.DevId == null ? "" : (operationDetails.DevId == -1 ? "" : " -1"))
                                       && (operationDetails.IgnoreDevice == null ? "a" == "a" : operationDetails.IgnoreDevice == 0)
                                       select new PatientUnknownDeviceListItem() {
                                           PatientUR = patientURN.URNo,
                                           PatientId = patientOperation.PatientId,
                                           PatientSiteId = patientOperation.Hosp,
                                           PatientOperationDeviceID = operationDetails.PatientOperationDevId,
                                           PatientOperationId = patientOperation.OpId,
                                           OperationDate = (DateTime)patientOperation.OpDate,
                                           DeviceId = null,
                                           DeviceDescrition = operationDetails.DevOthDesc,
                                           DeviceModel = operationDetails.DevOthMode,
                                           LotNo = operationDetails.DevLotNo,
                                           DeviceTypeDescrition = deviceType.Description,
                                           DeviceTypeId = operationDetails.DevType,
                                           DeviceBrandDescrition = operationDetails.DevBrand == null ? operationDetails.DevOthBrand : brand.Description,
                                           DeviceBrandId = operationDetails.DevBrand == null ? -1 : operationDetails.DevBrand,
                                           ManufacturerDescrition = operationDetails.DevManuf == null ? operationDetails.DevOthManuf : manufacturer.Description,
                                           ManufacturerId = operationDetails.DevManuf == null ? -1 : operationDetails.DevManuf,
                                       }).OrderBy(p => p.PatientOperationId).ThenByDescending(po => po.OperationDate).ToList<PatientUnknownDeviceListItem>();

            return patientUnknowDeviceList;
        }

        /// <summary>
        /// Get all the Favourite Device List
        /// </summary>
        /// <param name="userId">User Id</param>
        /// <param name="countryId">Country Id</param>
        /// <param name="_isAdmin">Denotes if User is Admin</param>
        /// <param name="userName">UserName of  Non-Admin user</param>
        /// <returns>Return list of devices</returns>
        public List<FavouriteDeviceList> GetFavouriteDeviceDetails(int userId, int countryId, bool _isAdmin, string userName)
        {
            List<FavouriteDeviceList> favouriteDeviceLists;
            if (_isAdmin)
            {
                favouriteDeviceLists = (from favDeviceDetails in _context.tbl_UserFavouriteDeviceDetails
                                        from site in _context.tbl_Site.Where(s => s.SiteId == favDeviceDetails.SiteId).DefaultIfEmpty()
                                        from Opstatus in _context.tlkp_OperationStatus.Where(o => o.Id == favDeviceDetails.OpStatus).DefaultIfEmpty()
                                        from primProcedureTypes in _context.tlkp_Procedure.Where(p => p.Id == favDeviceDetails.OpType).DefaultIfEmpty()
                                        from revProcedureTypes in _context.tlkp_Procedure.Where(p => p.Id == favDeviceDetails.OpRevType).DefaultIfEmpty()
                                        from deviceTypes in _context.tlkp_DeviceType.Where(dT => dT.Id == favDeviceDetails.DevType).DefaultIfEmpty()
                                        from deviceBrands in _context.tbl_DeviceBrand.Where(dB => dB.Id == favDeviceDetails.DevBrand).DefaultIfEmpty()
                                        from device in _context.tbl_Device.Where(d => d.DeviceId == favDeviceDetails.DevId).DefaultIfEmpty()
                                        from deviceManufacturers in _context.tlkp_DeviceManufacturer.Where(dM => dM.Id == favDeviceDetails.DevManuf).DefaultIfEmpty()
                                        from portFixMethods in _context.tlkp_PortFixationMethod.Where(p => p.Id == favDeviceDetails.DevPortMethId).DefaultIfEmpty()
                                        from buttressTypes in _context.tlkp_ButtressType.Where(b => b.Id == favDeviceDetails.ButtTypeID).DefaultIfEmpty()
                                        from user in _context.tbl_User.Where(u => u.UserId == favDeviceDetails.SurgId).DefaultIfEmpty()
                                        where favDeviceDetails.SurgId == userId && favDeviceDetails.CountryId == countryId
                                        orderby favDeviceDetails.LastUpdatedDateTime descending
                                        select new FavouriteDeviceList()
                                        {
                                            FavDevId = favDeviceDetails.FavDevId,
                                            ParentFavDevId = favDeviceDetails.ParentFavDevId,
                                            Procedure = ((primProcedureTypes.Description == null) ? revProcedureTypes.Description : primProcedureTypes.Description),
                                            Type = Opstatus.Description,
                                            Hospital = site.SiteName,
                                            DeviceDetail = deviceBrands.tlkp_DeviceType.Description
                                            + " - " + deviceBrands.Description + " - " + device.DeviceDescription + " - " + device.DeviceModel + " " +
                                            (favDeviceDetails.DevPortMethId != null ? "Port Fixation: " + portFixMethods.Description : (favDeviceDetails.ButtTypeID != null ? "Buttress Type: " + buttressTypes.Description : ""))
                                        }
                                    ).ToList<FavouriteDeviceList>();
            }
            else
            {
                favouriteDeviceLists = (from favDeviceDetails in _context.tbl_UserFavouriteDeviceDetails
                                        from site in _context.tbl_Site.Where(s => s.SiteId == favDeviceDetails.SiteId).DefaultIfEmpty()
                                        from opStatus in _context.tlkp_OperationStatus.Where(o => o.Id == favDeviceDetails.OpStatus).DefaultIfEmpty()
                                        from primProcedureTypes in _context.tlkp_Procedure.Where(p => p.Id == favDeviceDetails.OpType).DefaultIfEmpty()
                                        from revProcedureTypes in _context.tlkp_Procedure.Where(p => p.Id == favDeviceDetails.OpRevType).DefaultIfEmpty()
                                        from deviceTypes in _context.tlkp_DeviceType.Where(dT => dT.Id == favDeviceDetails.DevType).DefaultIfEmpty()
                                        from deviceBrands in _context.tbl_DeviceBrand.Where(dB => dB.Id == favDeviceDetails.DevBrand).DefaultIfEmpty()
                                        from device in _context.tbl_Device.Where(d => d.DeviceId == favDeviceDetails.DevId).DefaultIfEmpty()
                                        from deviceManufacturers in _context.tlkp_DeviceManufacturer.Where(dM => dM.Id == favDeviceDetails.DevManuf).DefaultIfEmpty()
                                        from portFixMethods in _context.tlkp_PortFixationMethod.Where(p => p.Id == favDeviceDetails.DevPortMethId).DefaultIfEmpty()
                                        from buttressTypes in _context.tlkp_ButtressType.Where(b => b.Id == favDeviceDetails.ButtTypeID).DefaultIfEmpty()
                                        from user in _context.tbl_User.Where(u => u.UserId == favDeviceDetails.SurgId).DefaultIfEmpty()
                                        where favDeviceDetails.CreatedBy == userName
                                        orderby favDeviceDetails.LastUpdatedDateTime descending
                                        select new FavouriteDeviceList()
                                        {
                                            FavDevId = favDeviceDetails.FavDevId,
                                            ParentFavDevId = favDeviceDetails.ParentFavDevId,
                                            Procedure = ((primProcedureTypes.Description == null) ? revProcedureTypes.Description : primProcedureTypes.Description),
                                            Type = opStatus.Description,
                                            Hospital = site.SiteName,
                                            DeviceDetail = deviceBrands.tlkp_DeviceType.Description + " - " + deviceBrands.Description + " - " + device.DeviceDescription + " - " + device.DeviceModel + " " +
                                            (favDeviceDetails.DevPortMethId != null ? "Port Fixation: " + portFixMethods.Description : (favDeviceDetails.ButtTypeID != null ? "Buttress Type: " + buttressTypes.Description : ""))
                                        }
                                    ).ToList<FavouriteDeviceList>();
            }

            
            return favouriteDeviceLists;
        }
    }
}
