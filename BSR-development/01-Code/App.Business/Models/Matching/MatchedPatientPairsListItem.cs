using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business {
    /// <summary>
    /// Contains Matched Patient Pairs properties
    /// </summary>
    public class MatchedPatientPairsListItem {

        /// <summary>
        /// Patient Id1
        /// </summary>
        public int PatientId1 { get; set; }

        /// <summary>
        /// Patient URN1
        /// </summary>
        public String PatientURN1 { get; set; }

        /// <summary>
        /// Patient FirstName1
        /// </summary>
        public String PatientFirstName1 { get; set; }

        /// <summary>
        /// Patient LastName1
        /// </summary>
        public String PatientLastName1 { get; set; }

        /// <summary>
        /// Gender ID1
        /// </summary>
        public int? GenderID1 { get; set; }

        /// <summary>
        /// Gender1
        /// </summary>
        public String Gender1 { get; set; }

        /// <summary>
        /// Date Of Birth1
        /// </summary>
        public DateTime? DOB1 { get; set; }

        /// <summary>
        /// Medicare No1
        /// </summary>
        public String MedicareNo1 { get; set; }

        /// <summary>
        /// Dva No1
        /// </summary>
        public String DvaNo1 { get; set; }

        /// <summary>
        /// IHI No1
        /// </summary>
        public String IHI1 { get; set; }

        /// <summary>
        /// Nhi No1
        /// </summary>
        public String NhiNo1 { get; set; }

        /// <summary>
        /// Address1
        /// </summary>
        public String Addr1 { get; set; }

        /// <summary>
        /// Street1
        /// </summary>
        public String Street1 { get; set; }

        /// <summary>
        /// Suburb1
        /// </summary>
        public String Suburb1 { get; set; }

        /// <summary>
        /// State1
        /// </summary>
        public String State1 { get; set; }

        /// <summary>
        /// Postcode1
        /// </summary>
        public String Postcode1 { get; set; }

        /// <summary>
        /// Country1
        /// </summary>
        public String Country1 { get; set; }

        /// <summary>
        /// Primary Site1
        /// </summary>
        public String PriSite1 { get; set; }

        /// <summary>
        /// Primary Surgeon1
        /// </summary>
        public String PriSurg1 { get; set; }

        /// <summary>
        /// Primary Operation Surgeon1
        /// </summary>
        public String PriOpSurg1 { get; set; }

        /// <summary>
        /// Operation URN
        /// </summary>
        public String PriOpURN1 { get; set; }

        /// <summary>
        /// Identifier
        /// </summary>
        public String Identifier { get; set; }

        /// <summary>
        /// Identifier No
        /// </summary>
        public String IdentifierNo { get; set; }

        /// <summary>
        /// Patient Id2
        /// </summary>
        public int PatientId2 { get; set; }

        /// <summary>
        /// Patient URN2
        /// </summary>
        public String PatientURN2 { get; set; }

        /// <summary>
        /// Patient FirstName2
        /// </summary>
        public String PatientFirstName2 { get; set; }

        /// <summary>
        /// Patient LastName2
        /// </summary>
        public String PatientLastName2 { get; set; }

        /// <summary>
        /// Gender ID2
        /// </summary>
        public int? GenderID2 { get; set; }

        /// <summary>
        /// Gender2
        /// </summary>
        public String Gender2 { get; set; }

        /// <summary>
        /// DateOfBirth2
        /// </summary>

        public DateTime? DOB2 { get; set; }

        /// <summary>
        /// MedicareNo2
        /// </summary>
        public String MedicareNo2 { get; set; }

        /// <summary>
        /// Dva No2
        /// </summary>
        public String DvaNo2 { get; set; }

        /// <summary>
        /// IHI No2
        /// </summary>
        public String IHI2 { get; set; }

        /// <summary>
        /// Nhi No2
        /// </summary>
        public String NhiNo2 { get; set; }

        /// <summary>
        /// Address2
        /// </summary>
        public String Addr2 { get; set; }

        /// <summary>
        /// Street2
        /// </summary>
        public String Street2 { get; set; }

        /// <summary>
        /// Suburb2
        /// </summary>
        public String Suburb2 { get; set; }

        /// <summary>
        /// State2
        /// </summary>
        public String State2 { get; set; }

        /// <summary>
        /// Postcode2
        /// </summary>
        public String Postcode2 { get; set; }

        /// <summary>
        /// Country2
        /// </summary>
        public String Country2 { get; set; }

        /// <summary>
        /// Primary Surgeon1
        /// </summary>
        public String PriSite2 { get; set; }

        /// <summary>
        /// Primary Surgeon2
        /// </summary>
        public String PriSurg2 { get; set; }

        /// <summary>
        /// Primary Operation Surgeon2
        /// </summary>
        public String PriOpSurg2 { get; set; }

        /// <summary>
        /// Operation URN2
        /// </summary>
        public String PriOpURN2 { get; set; }

        /// <summary>
        /// Operation Type1
        /// </summary>

        public String OpType1 { get; set; }

        /// <summary>
        /// Operation Type2
        /// </summary>
        public String OpType2 { get; set; }

        /// <summary>
        /// Operation Site1
        /// </summary>
        public String OpSite1 { get; set; }

        /// <summary>
        /// Operation Site2
        /// </summary>
        public String OpSite2 { get; set; }

        /// <summary>
        /// Operation Date1
        /// </summary>
        public DateTime? opDate1 { get; set; }

        /// <summary>
        /// Operation Date2
        /// </summary>
        public DateTime? opDate2 { get; set; }

        /// <summary>
        /// Home Phone1
        /// </summary>
        public String HomePh1 { get; set; }

        /// <summary>
        /// Home Phone2
        /// </summary>
        public String HomePh2 { get; set; }

        /// <summary>
        /// Mobile Phone1
        /// </summary>
        public String MobPh1 { get; set; }

        /// <summary>
        /// Mobile Phone2
        /// </summary>
        public String MobPh2 { get; set; }

        /// <summary>
        /// Indigenous Status1
        /// </summary>
        public String IndigenousSts1 { get; set; }

        /// <summary>
        /// Indigenous Status2
        /// </summary>
        public String IndigenousSts2 { get; set; }

        /// <summary>
        /// Health Status1
        /// </summary>
        public String HealthSts1 { get; set; }

        /// <summary>
        /// Health Status2
        /// </summary>
        public String HealthSts2 { get; set; }

        /// <summary>
        /// ProcAbon1
        /// </summary>        
        public int? ProcAbon1 { get; set; }

        /// <summary>
        /// ProcAbon2
        /// </summary>
        public int? ProcAbon2 { get; set; }

        /// <summary>
        /// Title1
        /// </summary>
        public String Title1 { get; set; }

        /// <summary>
        /// Title2
        /// </summary>
        public String Title2 { get; set; }

        /// <summary>
        /// Operation Procedure1
        /// </summary>
        public String OpProc1 { get; set; }

        /// <summary>
        /// Operation Procedure2
        /// </summary>
        public String OpProc2 { get; set; }

        /// <summary>
        /// No Of Matching Patients1
        /// </summary>
        public int NoOfMatchingPatients1 { get; set; }

        /// <summary>
        /// No Of Matching Patients2
        /// </summary>
        public int NoOfMatchingPatients2 { get; set; }

        /// <summary>
        /// Operation Off Status1
        /// </summary>
        public String OptOffSts1 { get; set; }

        /// <summary>
        /// Operation Off Status2
        /// </summary>
        public String OptOffSts2 { get; set; }
    }
}
