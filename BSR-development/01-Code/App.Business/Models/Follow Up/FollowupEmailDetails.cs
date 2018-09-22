using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business {
    /// <summary>
    /// Contains FollowUp Email propetties
    /// </summary>
    public class FollowUpEmailDetails {

        /// <summary>
        /// FollowUp Id
        /// </summary>
        public int FollowUpId { get; set; }

        /// <summary>
        /// Patient Title
        /// </summary>
        public string PatientTitle { get; set; }

        /// <summary>
        /// Patient FirstName
        /// </summary>
        public string PatientFirstName { get; set; }

        /// <summary>
        /// Patient LastName
        /// </summary>
        public string PatientLastName { get; set; }

        /// <summary>
        /// Surgeon Name
        /// </summary>
        public string SurgeonName { get; set; }

        /// <summary>
        /// Surgeon EmailAddress
        /// </summary>
        public string SurgeonEmailAddress { get; set; }

        /// <summary>
        /// FollowUp PeriodDescrition
        /// </summary>
        public string FollowUpPeriodDescrition { get; set; }

        /// <summary>
        /// Operation Id
        /// </summary>
        public int OperationId { get; set; }

        /// <summary>
        /// PatientID
        /// </summary>
        public int PatientID { get; set; }

        /// <summary>
        /// Gender
        /// </summary>
        public string Gender { get; set; }

        /// <summary>
        /// Operation Date
        /// </summary>
        public DateTime? OperationDate { get; set; }

        /// <summary>
        /// UR No
        /// </summary>
        public string URNo { get; set; }

        /// <summary>
        /// Operation Type
        /// </summary>
        public string OperationType { get; set; }

        /// <summary>
        /// Revision Operation Type
        /// </summary>
        public string RevisionOpType { get; set; }

        /// <summary>
        /// Date Of Birth
        /// </summary>
        public DateTime? DateOfBirth { get; set; }

        /// <summary>
        /// State
        /// </summary>
        public string State { get; set; }

    }
}
