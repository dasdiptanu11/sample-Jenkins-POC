using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business {
    /// <summary>
    /// Contains patient difference details properties
    /// </summary>
    public class PatientDifferenceDetails {

        /// <summary>
        /// Detail Type
        /// </summary>
        public String DetailType { get; set; }

        /// <summary>
        /// Detail Value For Patient1
        /// </summary>
        public String DetailValForPat1 { get; set; }

        /// <summary>
        /// Detail Value For Patient2
        /// </summary>
        public String DetailValForPat2 { get; set; }
    }
}