using System;
using System.Collections.Generic;
using System.Linq;


namespace App.Business {
    public partial class UnitOfWork : IDisposable {
        //private BusinessEntities context = new BusinessEntities();

        private PatientRepository _patientRepository;
        private DeviceRepository _deviceRepository;
        private OperationRepository _operationRepository;
        private FollowUpRepository _followUpRepository;

        private IMembershipRepository _membershipRepository;


        public IMembershipRepository MembershipRepository {
            get {

                if (this._membershipRepository == null) {
                    this._membershipRepository = new MembershipRepository();
                }
                return _membershipRepository;
            }
        }

        public PatientRepository PatientRepository {
            get {

                if (this._patientRepository == null) {
                    this._patientRepository = new PatientRepository(context);
                }
                return _patientRepository;
            }
        }

        public DeviceRepository DeviceRepository {
            get {
                if (this._deviceRepository == null) {
                    this._deviceRepository = new DeviceRepository(context);
                }
                return _deviceRepository;
            }
        }

        public OperationRepository OperationRepository {
            get {
                if (this._operationRepository == null) {
                    this._operationRepository = new OperationRepository(context);
                }
                return _operationRepository;
            }
        }

        public FollowUpRepository FollowUpRepository {
            get {
                if (this._followUpRepository == null) {
                    this._followUpRepository = new FollowUpRepository(context);
                }
                return _followUpRepository;
            }
        }
        /// <summary>
        /// Gets site details
        /// </summary>
        /// <param name="withEmptyItem">Boolean flag represent first row of the list is empty or not</param>
        /// <returns>site details list</returns>
        public List<LookupItem> Get_tbl_Site_Name(bool withEmptyItem) {
            List<LookupItem> items;
            using (UnitOfWork siteDetails = new UnitOfWork()) {
                items = (from lookup in siteDetails.tbl_SiteRepository.Get(orderBy: x => x.OrderBy(q => q.SiteName))
                         select new LookupItem() { Id = lookup.SiteId.ToString(), Description = lookup.SiteId + " " + lookup.SiteName }
                         ).ToList<LookupItem>();

                if (withEmptyItem) {
                    items.Insert(0, new LookupItem() { Id = null, Description = null });
                }
            }

            return items;
        }










    }
}