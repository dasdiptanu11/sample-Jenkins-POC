using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business
{
    /// <summary>
    /// Contains Patient OptOffListItem properties
    /// </summary>
    public class PatientOptOffListItem
    {

        /// <summary>
        /// Patient Id
        /// </summary>
        public int PatientId { get; set; }

        /// <summary>
        /// LastName
        /// </summary>
        public string LastName { get; set; }

        /// <summary>
        /// FirstName
        /// </summary>
        public string FirstName { get; set; }

        /// <summary>
        /// Operation Date
        /// </summary>
        public Nullable<System.DateTime> OperationDate { get; set; }

        /// <summary>
        /// Operation OffDate
        /// </summary>
        public Nullable<System.DateTime> OperationOffDate { get; set; }

        /// <summary>
        /// Operation OffStatus
        /// </summary>
          public int OperationOffStatus { get; set; }
        
    }
}
