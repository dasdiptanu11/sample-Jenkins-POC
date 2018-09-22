using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business {
    /// <summary>
    /// Contains FollowUp Details properties
    /// </summary>
    public class FollowUpDetails {

        /// <summary>
        /// Follow Up Id
        /// </summary>
        public int FollowUpId { get; set; }

        /// <summary>
        /// Lost To FollowUp
        /// </summary>
        public bool? LostToFollowUp { get; set; }

        /// <summary>
        /// URN No
        /// </summary>
        public string URNNo { get; set; }

        /// <summary>
        /// Operation Date
        /// </summary>
        public DateTime? OperationDate { get; set; }

        /// <summary>
        /// Operation Status
        /// </summary>
        public int? OperationStatus { get; set; }

        /// <summary>
        /// Operation Type
        /// </summary>
        public string OperationType { get; set; }

        /// <summary>
        /// FollowUp Period Descrition
        /// </summary>
        public string FollowUpPeriodDescrition { get; set; }

        /// <summary>
        /// FollowUp PeriodID
        /// </summary>
        public int? FollowUpPeriodID { get; set; }

        /// <summary>
        /// FollowUp Date
        /// </summary>
        public DateTime? FollowUpDate { get; set; }

        /// <summary>
        /// Operation Id
        /// </summary>
        public int OperationId { get; set; }

        /// <summary>
        /// Operation Wieght
        /// </summary>
        public decimal? OperationWieght { get; set; }

        /// <summary>
        /// Standard Wieght
        /// </summary>
        public decimal? StandardWieght { get; set; }

        /// <summary>
        /// FollowUp Wieght
        /// </summary>
        public decimal? FollowUpWieght { get; set; }
    }
}
