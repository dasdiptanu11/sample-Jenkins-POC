using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business
{
    /// <summary>
    /// Contains LTFU patients list properties
    /// </summary>
        public class PatientLTFUListItem
        {

            /// <summary>
            /// Patient Id
            /// </summary>
            public int PatientId { get; set; }

            /// <summary>
            /// Given Name
            /// </summary>
            public string GivenName { get; set; }

            /// <summary>
            /// Family Name
            /// </summary>
            public string FamilyName { get; set; }

            /// <summary>
            /// First Operation Date
            /// </summary>
            public Nullable<System.DateTime> FirstOperationDate { get; set; }

            /// <summary>
            /// Last Operation Date
            /// </summary>
            public Nullable<System.DateTime> LastOperationDate { get; set; }

            /// <summary>
            /// Last FollowUp Date
            /// </summary>
            public string LastFollowUpDate { get; set; }

            /// <summary>
            /// Actuall FollowUp Date
            /// </summary>
            public DateTime ActualFollowUpDate { get; set; }

        }
   
}
