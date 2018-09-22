using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business
{
    /// <summary>
    /// Contains Patient FollowUpDetails properties
    /// </summary>
    public class PatientFollowUpDetailsListItem
    {

        /// <summary>
        /// FollowUp Id
        /// </summary>
        public int FollowUpId { get; set; }

        /// <summary>
        /// URNNo
        /// </summary>
        public string URNNo { get; set; }

        /// <summary>
        /// Operation Date
        /// </summary>
        public Nullable<System.DateTime> OperationDate { get; set; }

        /// <summary>
        /// Operation Status
        /// </summary>
        public string OperationStatus { get; set; }

        /// <summary>
        /// Operation Type
        /// </summary>
        public string OperationType { get; set; }

        /// <summary>
        /// FollowUp Period
        /// </summary>
        public string FollowUpPeriod { get; set; }

        /// <summary>
        /// Follow Up Date
        /// </summary>
        public Nullable<System.DateTime> FollowUpDate { get; set; }

        public string FollowUpStatusLabel { get; set; }
    }






}
