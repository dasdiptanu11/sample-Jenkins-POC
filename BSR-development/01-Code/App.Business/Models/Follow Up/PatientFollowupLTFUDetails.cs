using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business {
    /// <summary>
    /// Contains Patient FollowUpLTFU Properties
    /// </summary>
    public class PatientFollowUpLTFUDetails {

        /// <summary>
        /// FollowUp Id
        /// </summary>
        public int FollowUpId { get; set; }

        /// <summary>
        /// Lost To FollowUp
        /// </summary>
        public bool? LostToFollowUp { get; set; }

        /// <summary>
        /// Follow UpDate
        /// </summary>
        public DateTime? FollowUpDate { get; set; }
    }
}
