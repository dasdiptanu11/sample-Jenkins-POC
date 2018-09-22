using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using App.Business;

namespace App.UI.Web.Views.Shared
{
    public class SessionData
    {
        /// <summary>
        /// Constructor method for the class - setting default values
        /// </summary>
        public SessionData()
        {
            DeviceId = -1;
            PatientCallScreenSelectedCountry = 1;
            PatientCallScreenSelectedStateId = -1;
        }

        /// <summary>
        /// Gets or sets Search filter for device search
        /// </summary>
        public String[] PatientDeviceSearchFilter { get; set; }

        /// <summary>
        /// Gets or sets User Id
        /// </summary>
        public string UserId { get; set; }

        /// <summary>
        /// Gets or set Add New Device flag
        /// </summary>
        public int AddNewDevice { get; set; }

        /// <summary>
        /// Gets or sets Device Id
        /// </summary>
        public int DeviceId { get; set; }

        /// <summary>
        /// Gets or sets Patient Operation ID
        /// </summary>
        public int PatientOperationId { get; set; }

        /// <summary>
        /// Gets or sets Follow up Period Id
        /// </summary>
        public int FollowUpPeriodId { get; set; }

        /// <summary>
        /// Gets or sets Follow Up Id
        /// </summary>
        public int FollowUpId { get; set; }

        /// <summary>
        /// Gets or sets Success Message for an item saved
        /// </summary>
        public string AddedSuccessMessage { get; set; }

        /// <summary>
        /// Gets or sets Patient Operation Unknown device id
        /// </summary>
        public int PatientOperationUnknownDeviceID { get; set; }

        /// <summary>
        /// Gets or sets Client Registered Id
        /// </summary>
        public int ClientRegisteredId { get; set; }

        /// <summary>
        /// Gets or sets Site ID
        /// This is SiteID that the site entered
        /// </summary>
        public int SiteId { get; set; }

        /// <summary>
        /// Gets or sets Patient URN
        /// </summary>
        public string PatientURN { get; set; }

        /// <summary>
        /// Gets or sets Surgeon Id
        /// </summary>
        public int SurgeonId { get; set; }

        /// <summary>
        /// Gets or set Site Id Sequence
        /// Site Actual Generated Key, use this
        /// </summary>
        public int SiteIdSequence { get; set; }

        /// <summary>
        /// Gets or sets Client Timezone Offset value
        /// </summary>
        public int ClientTimezoneOffset { get; set; }

        /// <summary>
        /// Gets or sets LAN Code
        /// </summary>
        public int LanCode { get; set; }

        /// <summary>
        /// Gets or sets Patient Id
        /// </summary>
        public int PatientId { get; set; }

        /// <summary>
        /// Gets or sets Study Id
        /// </summary>
        public int StudyID { get; set; }

        /// <summary>
        /// Gets or sets Month value
        /// </summary>
        public int Month { get; set; }

        /// <summary>
        /// Gets or set Opt Off Date
        /// </summary>
        public DateTime? OptOffDate { get; set; }


        /// <summary>
        /// Gets or sets flag which is used to check whether or not Demographic Redirected Values 
        /// </summary>
        public Boolean PanelNewPatient { get; set; }

        /// <summary>
        /// Gets or sets Diagno
        /// </summary>
        public int? DiagnosisID { get; set; }

        /// <summary>
        /// Gets or sets List of Patient ids of LTFS
        /// </summary>
        public List<string> PatientIdsForLTFU { get; set; }

        /// <summary>
        /// Gets or sets Patient Ids for ESS
        /// </summary>
        public List<string> PatientIdsForESS { get; set; }

        /// <summary>
        /// Gets or sets Flag to notify Search
        /// </summary>
        public bool NotifyingSearch { get; set; }

        /// <summary>
        /// Gets or sets Flag to determine Treaement Search
        /// </summary>
        public bool TreatmentSearch { get; set; }

        /// <summary>
        /// Gets or set Previous Page Operation ID
        /// </summary>
        public string PreviousPageOperation { get; set; }

        /// <summary>
        /// Gets or sets Previous Patient Page
        /// </summary>
        public string PreviousPagePatient { get; set; }

        /// <summary>
        /// Gets or sets Patient Given Name
        /// </summary>
        public string PatientGivenName { get; set; }

        /// <summary>
        /// Gets or sets Patient Site Id
        /// </summary>
        public int PatientSiteId { get; set; }

        /// <summary>
        /// Gets or sets Patient Family Name
        /// </summary>
        public string PatientFamilyName { get; set; }

        /// <summary>
        /// Gets or sets Patient Medicare
        /// </summary>
        public string PatientMedicare { get; set; }

        /// <summary>
        /// Gets or sets Patient DVN
        /// </summary>
        public string PatientDVN { get; set; }

        /// <summary>
        /// Gets or sets Patient NHI
        /// </summary>
        public string PatientNHI { get; set; }

        /// <summary>
        /// Gets or sets Patient Country
        /// </summary>
        public string PatientCountry { get; set; }

        /// <summary>
        /// Gets or sets Patient Gender
        /// </summary>
        public string PatientGender { get; set; }

        /// <summary>
        /// Gets or set Patient URN
        /// </summary>
        public string PatientURNNumber { get; set; }

        /// <summary>
        /// Gets or sets Patient Date Of Birth
        /// </summary>
        public DateTime? PatientDateOfBirth { get; set; }

        /// <summary>
        /// Gets or sets Patient UR Id
        /// </summary>
        public string PatientURId { get; set; }

        /// <summary>
        /// Gets or sets Patient Operation Id
        /// </summary>
        public int PatientOperationDeviceId { get; set; }

        /// <summary>
        /// Gets or sets Operation Type
        /// </summary>
        public string OperationType { get; set; }

        /// <summary>
        /// Gets or sets Last Option Chosen
        /// </summary>
        public string LastOptionChosen { get; set; }

        /// <summary>
        /// Gets or sets Flag that indicates whether Country selection should be considered in Site list
        /// </summary>
        public Boolean ConsiderCountryForSiteList { get; set; }

        /// <summary>
        /// Gets or set Country Id to be considered in Site List
        /// </summary>
        public int? CountryIDForSiteList { get; set; }

        /// <summary>
        /// Gets or sets Admin Given Name
        /// </summary>
        public string AdminGivenName { get; set; }

        /// <summary>
        /// Gets or sets Admin Family Name
        /// </summary>
        public string AdminFamilyName { get; set; }

        /// <summary>
        /// Gets or set Admin URN
        /// </summary>
        public string AdminURN { get; set; }

        /// <summary>
        /// Gets or sets Admin Medicare
        /// </summary>
        public string AdminMedicare { get; set; }

        /// <summary>
        /// Gets or sets Admin DVA
        /// </summary>
        public string AdminDVA { get; set; }

        /// <summary>
        /// Gets or sets Admin NHI
        /// </summary>
        public string AdminNHI { get; set; }

        /// <summary>
        /// Gets or sets Admin Date Of Birth
        /// </summary>
        public DateTime? AdminDateOfBirth { get; set; }

        /// <summary>
        /// Gets or sets Admin Country
        /// </summary>
        public string AdminCountry { get; set; }

        /// <summary>
        /// Resetting Patient Data
        /// </summary>
        public void ResetPatientData()
        {
            PatientId = -1;
            PatientOperationId = -1;

            ClientRegisteredId = -1;
            SiteIdSequence = -1;
        }

        /// <summary>
        /// Gets of sets Country Id parameter in Missing Data Worklist
        /// </summary>
        public int MissingDataWorkListCountryId { get; set; }

        /// <summary>
        /// Gets of sets Site Id parameter in Missing Data Worklist
        /// </summary>
        public int MissingDataWorkListSiteId { get; set; }

        /// <summary>
        /// Gets of sets Surgeon Id parameter in Missing Data Worklist
        /// </summary>
        public int MissingDataWorkListSurgeonId { get; set; }

        /// <summary>
        /// Gets of sets Page size for Missing Data Worklist grid
        /// </summary>
        public int MissingDataWorkListPageSize { get; set; }

        /// <summary>
        /// Gets of sets flag to determine whether to redirect on the Surgeon Dashboard
        /// </summary>
        public bool IsSurgeonDashboardToReturn { get; set; }

        /// <summary>
        /// Gets or sets Patient Followup Call Id
        /// </summary>
        public int PatientFollowUpCallId { get; set; }

        /// <summary>
        /// Gets or sets Patient Followup Call details
        /// </summary>
        public string PatientFollowUpCall { get; set; }

        /// <summary>
        /// Gets or sets Call Result Id
        /// </summary>
        public int CallResultId { get; set; }

        /// <summary>
        /// Flag to determine if all the followup calls are attempted
        /// </summary>
        public bool IsFollowupAllCallAttempted { get; set; }

        /// <summary>
        /// Flag to indicate that page is redirected from Call Screen
        /// </summary>
        public bool IsRedirectedFromCallScreen { get; set; }

        /// <summary>
        /// Selected Country Id when redirect from Call Screen
        /// </summary>
        public int PatientCallScreenSelectedCountry { get; set; }

        /// <summary>
        /// Selected State Id when redirect from Call Screen
        /// </summary>
        public int PatientCallScreenSelectedStateId { get; set; }

        /// <summary>
        /// Filtered Patient Id from Patient Call Worklist
        /// </summary>
        public int PatientCallScreenPatientId { get; set; }

        /// <summary>
        /// Filtered Patient Family Name from Patient Call Worklist
        /// </summary>
        public string PatientCallScreenFamilyName { get; set; }

        /// <summary>
        /// Filtered Given Name from Patient Call Worklist
        /// </summary>
        public string PatientCallScreenGivenName { get; set; }

        /// <summary>
        /// Filtered Phone Number from Patient Call Worklist
        /// </summary>
        public string PatientCallScreenPhone { get; set; }

        /// <summary>
        /// Filtered FollowUp Note from Patient Call Worklist
        /// </summary>
        public string PatientCallScreenNote { get; set; }

        /// <summary>
        /// Gets or sets Favorite device id
        /// </summary>
        public int FavDeviceId { get; set; }
    }
}