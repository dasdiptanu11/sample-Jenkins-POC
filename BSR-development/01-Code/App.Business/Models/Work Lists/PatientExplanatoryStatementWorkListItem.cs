using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business
{
    /// <summary>
    /// Contains Patient Explanatory Statement WorkListItem Properties
    /// </summary>
    public class PatientExplanatoryStatementWorkListItem
    {

        /// <summary>
        /// Patient Id
        /// </summary>
        public int PatientId { get; set; }

        /// <summary>
        /// Primary Surgeon
        /// </summary>
        public string PrimarySurgeon { get; set; }

        /// <summary>
        /// Primary Hospital
        /// </summary>
        public string PrimaryHospital { get; set; }

        /// <summary>
        /// Operation Date
        /// </summary>
        public Nullable<System.DateTime> OperationDate { get; set; }

        /// <summary>
        /// Operation Age
        /// </summary>
        public string OperationAge { get; set; }

        /// <summary>
        /// Title
        /// </summary>
        public string Title { get; set; }

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
        /// Street
        /// </summary>
        public string Street { get; set; }

        /// <summary>
        /// Suburb
        /// </summary>
        public string Suburb { get; set; }

        /// <summary>
        /// State
        /// </summary>
        public string State { get; set; }

        /// <summary>
        /// Post code
        /// </summary>
        public string Postcode { get; set; }
    }

    
      

    
}
