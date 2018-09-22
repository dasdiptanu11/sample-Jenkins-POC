using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business {
    /// <summary>
    /// MatchedPatientItem properties
    /// </summary>
    public class MatchedPatientItem : tbl_Patient {

        /// <summary>
        /// PatientId
        /// </summary>
        public int PatientId { get; set; }

        /// <summary>
        /// PatientName
        /// </summary>
        public String PatientName { get; set; }

        /// <summary>
        /// Gender
        /// </summary>
        public String Gender { get; set; }

        /// <summary>
        /// DOB
        /// </summary>
        public String DOB { get; set; }

        /// <summary>
        /// MedicareNo
        /// </summary>
        public String MedicareNo { get; set; }

        /// <summary>
        /// Street
        /// </summary>
        public String Street { get; set; }

        /// <summary>
        /// Suburb
        /// </summary>
        public String Suburb { get; set; }

        /// <summary>
        /// State
        /// </summary>
        public String State { get; set; }

        /// <summary>
        /// Postcode
        /// </summary>
        public String Postcode { get; set; }

    }
}
