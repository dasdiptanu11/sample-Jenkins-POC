using System;

namespace App.Business {
    /// <summary>
    /// Contains Patient OperationDetailsListItem properties
    /// </summary>
    public class PatientOperationDetailsListItem {

        /// <summary>
        /// PatientId
        /// </summary>
        public int PatientId { get; set; }

        /// <summary>
        /// Family Name
        /// </summary>
        public string FamilyName { get; set; }

        /// <summary>
        /// Given Name
        /// </summary>
        public string GivenName { get; set; }

        /// <summary>
        /// Gender
        /// </summary>
        public string Gender { get; set; }

        /// <summary>
        /// Date Of Birth
        /// </summary>
        public DateTime? DateOfBirth { get; set; }

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
        public decimal OperationWeight { get; set; }

        /// <summary>
        /// Operation Site
        /// </summary>
        public string OperationSite { get; set; }

        /// <summary>
        /// Operation Surgeon
        /// </summary>
        public string OperationSurgeon { get; set; }
    }
}
