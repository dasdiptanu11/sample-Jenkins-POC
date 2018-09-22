using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace App.Business {
    /// <summary>
    /// Contains Existing Procedures Properties
    /// </summary>
    public class ExistingProcedures {
        /// <summary>
        /// Patien tId
        /// </summary>
        public int? PatientId { get; set; }

        /// <summary>
        /// Patient UR
        /// </summary>
        public String PatientUR { get; set; }

        /// <summary>
        /// Patient Operation Id
        /// </summary>
        public int? PatientOperationId { get; set; }

        /// <summary>
        /// Operation Date
        /// </summary>
        public String OperationDate { get; set; }

        //public int? BreastId { get; set; }

        /// <summary>
        /// Breast
        /// </summary>
        public String Breast { get; set; }
        //public int? OperationTypeId { get; set; }

        /// <summary>
        /// Operation Type
        /// </summary>
        public String OperationType { get; set; }

        /// <summary>
        /// Device Operation
        /// </summary>
        public String DeviceOperation { get; set; }
        //public int? SiteIdSeq { get; set; }

        /// <summary>
        /// Site
        /// </summary>
        public String Site { get; set; }
        //public int? UserId { get; set; }

        /// <summary>
        /// Revision Type Id
        /// </summary>
        public String User { get; set; }
        //public int? RevisionTypeId { get; set; }

        /// <summary>
        /// Revision Type
        /// </summary>
        public String RevisionType { get; set; }

        /// <summary>
        /// Discharge Date
        /// </summary>
        public String DischargeDate { get; set; }

        /// <summary>
        /// Membership UserId
        /// </summary>
        public String MembershipUserId { get; set; }

    }
}
