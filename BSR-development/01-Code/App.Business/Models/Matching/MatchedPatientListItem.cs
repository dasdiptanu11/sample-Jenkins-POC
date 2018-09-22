using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business {
    /// <summary>
    /// Contains Matched patient List properties
    /// </summary>
    public class MatchedPatientListItem {

        /// <summary>
        /// PatientId
        /// </summary>
        public int PatientId { get; set; }

        /// <summary>
        /// Patient URN
        /// </summary>
        public String PatientURN { get; set; }

        /// <summary>
        /// Patient FirstName
        /// </summary>
        public String PatientFirstName { get; set; }

        /// <summary>
        /// Patient LastName
        /// </summary>
        public String PatientLastName { get; set; }

        /// <summary>
        /// GenderID
        /// </summary>
        public int? GenderID { get; set; }

        /// <summary>
        /// Date Of Birth
        /// </summary>
        public DateTime? DateOfBirth { get; set; }

        /// <summary>
        /// Medicare No
        /// </summary>
        public String MedicareNo { get; set; }

        /// <summary>
        /// Dva No
        /// </summary>
        public String DvaNo { get; set; }

        /// <summary>
        /// IHINo
        /// </summary>
        public String IHINo { get; set; }

        /// <summary>
        /// Nhi No
        /// </summary>
        public String NhiNo { get; set; }

        /// <summary>
        /// Address
        /// </summary>
        public String Address { get; set; }

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

        /// <summary>
        /// Country
        /// </summary>
        public String Country { get; set; }

        /// <summary>
        /// PrimarySite
        /// </summary>
        public String PrimarySite { get; set; }

        /// <summary>
        /// Primary Surgeon
        /// </summary>
        public String PrimarySurgeon { get; set; }

        /// <summary>
        /// Identifier
        /// </summary>
        public String Identifier { get; set; }

        /// <summary>
        /// IdentifierNo
        /// </summary>
        public String IdentifierNo { get; set; }

        /// <summary>
        /// Gender
        /// </summary>
        public String Gender { get; set; }

        /// <summary>
        /// Operation Type
        /// </summary>
        public String OperationType { get; set; }

        /// <summary>
        /// ProcAbon
        /// </summary>
        public int? ProcAbon { get; set; }

        /// <summary>
        /// Operation Site
        /// </summary>
        public String OperationSite { get; set; }

        /// <summary>
        /// Operation Date
        /// </summary>
        public DateTime? OperationDate { get; set; }

        /// <summary>
        /// Operation Surgeon
        /// </summary>
        public String OperationSurgeon { get; set; }

        /// <summary>
        /// Home Phone
        /// </summary>
        public String HomePhone { get; set; }

        /// <summary>
        /// Mobile Phone
        /// </summary>
        public String MobilePhone { get; set; }

        /// <summary>
        /// Indigenous Status
        /// </summary>
        public String IndigenousStatus { get; set; }

        /// <summary>
        /// Health Status
        /// </summary>
        public String HealthStatus { get; set; }

        /// <summary>
        /// Title
        /// </summary>
        public String Title { get; set; }

        /// <summary>
        /// Operation Procedure
        /// </summary>
        public String OperationProcedure { get; set; }

        /// <summary>
        /// Operation Status
        /// </summary>
        public String OperationStatus { get; set; }

        /// <summary>
        /// Operation URN
        /// </summary>
        public String OperationURN { get; set; }

        /// <summary>
        /// No Of MatchingPatients
        /// </summary>
        public int NoOfMatchingPatients { get; set; }
    }
}
