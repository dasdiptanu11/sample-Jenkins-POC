using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business
{
    /// <summary>
    /// Contains Patient SearchFilter properties
    /// </summary>
    public class PatientSearchFilter : tbl_Patient
    {
        /// <summary>
        /// Given Name
        /// </summary>
        public String GivenName { get; set; }

        /// <summary>
        /// Family Name
        /// </summary>
        public String FamilyName { get; set; }

        /// <summary>
        /// Recent FormerName
        /// </summary>
        public String RecentFormerName { get; set; }
     //   public String FormerName { get; set; }

        /// <summary>
        /// Date Of Birth
        /// </summary>
        public DateTime? DateOfBirth { get; set; }
        //public String MedicareNo { get; set; }
        //public DateTime? OperationDate { get; set; }

        //public String Surgeon { get; set; }
        //public String Site { get; set; }
        //public String Consent { get; set; }
    }
}
