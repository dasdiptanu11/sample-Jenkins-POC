using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace App.Business {
    /// <summary>
    /// Contains patient Device List Properties
    /// </summary>
    public class PatientDeviceListItem : tbl_PatientOperation {
        /// <summary>
        /// UR No
        /// </summary>
        public String URNo { get; set; }

        /// <summary>
        /// Patient OperationId
        /// </summary>
        public int PatientOperationId { get; set; }

        /// <summary>
        /// Patient Id
        /// </summary>
        public int PatientId { get; set; }

        /// <summary>
        /// Operation Date
        /// </summary>
        public DateTime? OperationDate { get; set; }
        /// <summary>
        /// Device Type
        /// </summary>
        public String DeviceType { get; set; }

        /// <summary>
        /// Device Brand
        /// </summary>
        public String DeviceBrand { get; set; }

        /// <summary>
        /// Device Model
        /// </summary>
        public String DeviceModel { get; set; }

        /// <summary>
        /// Device Manufacturer
        /// </summary>
        public String DeviceManufacturer { get; set; }

        /// <summary>
        /// Lot No
        /// </summary>
        public String LotNo { get; set; }

        /// <summary>
        /// Device Description
        /// </summary>
        public String DeviceDescription { get; set; }

        /// <summary>
        /// Patient OperationDevId
        /// </summary>
        public int PatientOperationDevId { get; set; }

        /// <summary>
        /// Parent Patient OperationDevId
        /// </summary>
        public int? ParentPatientOperationDevId { get; set; }
    }

}
