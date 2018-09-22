using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business {
    /// <summary>
    /// Contains patient using Device propeties
    /// </summary>
    public class PatientUsingDevice {

        /// <summary>
        /// URNo
        /// </summary>
        public String URNo { get; set; }

        /// <summary>
        /// Patient Id
        /// </summary>
        public int PatientId { get; set; }

        /// <summary>
        /// Patient Name
        /// </summary>
        public String PatientName { get; set; }

        /// <summary>
        /// Patient PrimarySite
        /// </summary>
        public String PatientPrimarySite { get; set; }

        /// <summary>
        /// Patient Address
        /// </summary>
        public String PatientAddress { get; set; }

        /// <summary>
        /// Patient Telephone
        /// </summary>
        public String PatientTelephone { get; set; }

        /// <summary>
        /// Patient MedicareNo
        /// </summary>
        public String PatientMedicareNo { get; set; }

        /// <summary>
        /// Patient NHINo
        /// </summary>
        public String PatientNHINo { get; set; }

        /// <summary>
        /// Patient IHI
        /// </summary>
        public String PatientIHI { get; set; }

        /// <summary>
        /// Patient DOB
        /// </summary>
        public DateTime? PatientDOB { get; set; }

        /// <summary>
        /// Patient OperationId
        /// </summary>
        public int PatientOperationId { get; set; }

        /// <summary>
        /// Patient OperationDevId
        /// </summary>
        public int PatientOperationDevId { get; set; }

        /// <summary>
        /// Lot No
        /// </summary>
        public String LotNo { get; set; }

        /// <summary>
        /// Parent PatientOperation DevId
        /// </summary>
        public int? ParentPatientOperationDevId { get; set; }

        /// <summary>
        /// Operation Date
        /// </summary>
        public DateTime? OperationDate { get; set; }

        /// <summary>
        /// Surgeon Name
        /// </summary>
        public String SurgeonName { get; set; }

        /// <summary>
        /// Surgeon Email
        /// </summary>
        public String SurgeonEmail { get; set; }
    }
   
}
