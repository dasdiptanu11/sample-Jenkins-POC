using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business {
    /// <summary>
    /// Contains Patient UnknownDevice ListItem properties
    /// </summary>
    public class PatientUnknownDeviceListItem {

        /// <summary>
        /// Patient Operation Id
        /// </summary>
        public int PatientOperationId { get; set; }

        /// <summary>
        /// Patient Operation DeviceID
        /// </summary>
        public int PatientOperationDeviceID { get; set; }

        /// <summary>
        /// PatientUR
        /// </summary>
        public string PatientUR { get; set; }

        /// <summary>
        /// Patient Id
        /// </summary>
        public int PatientId { get; set; }

        /// <summary>
        /// PPatient SiteId
        /// </summary>

        public int? PatientSiteId { get; set; }

        /// <summary>
        /// Device Id
        /// </summary>

        public int? DeviceId { get; set; }

        /// <summary>
        /// Device Descrition
        /// </summary>
        public String DeviceDescrition { get; set; }

        /// <summary>
        /// Device Model
        /// </summary>
        public String DeviceModel { get; set; }

        /// <summary>
        /// Lot No
        /// </summary>
        public String LotNo { get; set; }

        /// <summary>
        /// Device Type Descrition
        /// </summary>
        public String DeviceTypeDescrition { get; set; }

        /// <summary>
        /// Device TypeId
        /// </summary>
        public int? DeviceTypeId { get; set; }

        /// <summary>
        /// Device BrandDescrition
        /// </summary>
        public String DeviceBrandDescrition { get; set; }

        /// <summary>
        /// Device BrandId
        /// </summary>
        public int? DeviceBrandId { get; set; }

        /// <summary>
        /// Manufacturer Descrition
        /// </summary>
        public String ManufacturerDescrition { get; set; }

        /// <summary>
        /// Manufacturer Id
        /// </summary>
        public int? ManufacturerId { get; set; }

        /// <summary>
        /// Operation Date
        /// </summary>
        public DateTime? OperationDate { get; set; }
    }
}
