using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business {
    /// <summary>
    /// Contains Patient Opertation List properties
    /// </summary>
    public class PatientOperationListItem {

        /// <summary>
        /// Patient Id
        /// </summary>
        public int PatientId { get; set; }

        /// <summary>
        /// Patient OperationId
        /// </summary>
        public int PatientOperationId { get; set; }

        /// <summary>
        /// Operation Date
        /// </summary>
        public DateTime? OperationDate { get; set; }

        /// <summary>
        /// Operation Status
        /// </summary>
        public String OperationStatus { get; set; }

        /// <summary>
        /// Operation Type
        /// </summary>
        public String OperationType { get; set; }

        /// <summary>
        /// Operation Weight
        /// </summary>
        public decimal? OperationWeight { get; set; }

        /// <summary>
        /// Operation Site
        /// </summary>
        public string OperationSite { get; set; }

        /// <summary>
        /// Site ID
        /// </summary>
        public int? SiteID { get; set; }

        /// <summary>
        /// Operation Surgeon
        /// </summary>
        public string OperationSurgeon { get; set; }

        /// <summary>
        /// Diabetes Status
        /// </summary>
        public string DiabetesStatus { get; set; }

        /// <summary>
        /// Diabetes Treatment
        /// </summary>
        public string DiabetesTreatment { get; set; }

        /// <summary>
        /// Start Weight
        /// </summary>
        public decimal StartWeight { get; set; }

        /// <summary>
        /// Height
        /// </summary>
        public decimal Height { get; set; }

        /// <summary>
        /// OperationStat
        /// </summary>
        public int? OperationStat { get; set; }

        /// <summary>
        /// ProcAban
        /// </summary>
        public bool? ProcAban { get; set; }
        //public bool IsSurg { get; set; }

    }

}
