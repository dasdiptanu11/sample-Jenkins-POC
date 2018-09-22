using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business {


    /// <summary>
    /// Contains Follow Up List properties
    /// </summary>
    public class PatientFollowUpListItem {

        /// <summary>
        /// Patient Id
        /// </summary>
        public int PatientId { get; set; }

        /// <summary>
        /// Surgeon ID
        /// </summary>
        public int SurgeonID { get; set; }

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
        /// Operation Date
        /// </summary>
        public DateTime? OperationDate { get; set; }

        /// <summary>
        /// FollowUp Period
        /// </summary>
        public string FollowUpPeriod { get; set; }

        /// <summary>
        /// FollowUp PeriodInDays
        /// </summary>
        public int? FollowUpPeriodInDays { get; set; }

        /// <summary>
        /// FollowUp Status
        /// </summary>
        public String FollowUpStatus { get; set; }

        /// <summary>
        /// Attempted Calls
        /// </summary>
        public int? AttemptedCalls { get; set; }

        /// <summary>
        /// Operation Status
        /// </summary>
        public int OperationStatus { get; set; }

        /// <summary>
        /// OperationType
        /// </summary>
        public string OperationType { get; set; }

        /// <summary>
        /// SiteID
        /// </summary>
        public int SiteID { get; set; }

        /// <summary>
        /// Surgeon
        /// </summary>
        public string Surgeon { get; set; }

        /// <summary>
        /// FollowUp Number
        /// </summary>
        public int? FollowUpNumber { get; set; }

        /// <summary>
        /// FollowUp Date
        /// </summary>
        public DateTime? FollowUpDate { get; set; }

        /// <summary>
        /// UR No
        /// </summary>
        public String URNo { get; set; }

        /// <summary>
        /// Follow UpID
        /// </summary>
        public int? FollowUpID { get; set; }

        /// <summary>
        /// Operation ID
        /// </summary>
        public int OperationID { get; set; }

        /// <summary>
        /// Primary SurgeonID
        /// </summary>
        public int PrimarySurgeonID { get; set; }

        /// <summary>
        /// Primary Surgeon
        /// </summary>
        public string PrimarySurgeon { get; set; }

        /// <summary>
        /// Site TypeId
        /// </summary>
        public int SiteTypeId { get; set; }
    }
}
