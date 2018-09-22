using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business
{
    /// <summary>
    /// Class Model to store the details of the Patient Call Work List data items
    /// </summary>
    public class PatientCallListItem
    {
        /// <summary>
        /// Patient Id
        /// </summary>
        public int PatientId { get; set; }

        /// <summary>
        /// Follow Up Id
        /// </summary>
        public int FollowUpId { get; set; }

        /// <summary>
        /// Patient's Family Name
        /// </summary>
        public string FamilyName { get; set; }

        /// <summary>
        /// Patient's Given Name
        /// </summary>
        public string GivenName { get; set; }

        /// <summary>
        /// Patient's Home Phone number
        /// </summary>
        public string HomePhone { get; set; }

        /// <summary>
        /// Patient's Mobile Phone number
        /// </summary>
        public string Mobile { get; set; }

        /// <summary>
        /// Patient's Date of Birth
        /// </summary>
        public DateTime? BirthDate { get; set; }

        /// <summary>
        /// Patient's Date of Birth in string
        /// </summary>
        public string StringBirthDate
        {
            get { return BirthDate.HasValue ? BirthDate.Value.ToString("dd/MM/yyyy") : "-"; }
        }

        /// <summary>
        /// Patient's Home Postcode
        /// </summary>
        public string PostCode { get; set; }

        /// <summary>
        /// Patient's Primary Site Id
        /// </summary>
        public int? SiteId { get; set; }

        /// <summary>
        /// Patient's Primary Site
        /// </summary>
        public string SiteName { get; set; }

        /// <summary>
        /// Patient's Primary Surgeon Id
        /// </summary>
        public int? SurgeonId { get; set; }

        /// <summary>
        /// Patient's Primary Surgeon
        /// </summary>
        public string SurgeonName { get; set; }

        /// <summary>
        /// Patient's Operation Date
        /// </summary>
        public DateTime? OperationDate { get; set; }

        /// <summary>
        /// Patient's Operation Procedure Type Id
        /// </summary>
        public int? ProcedureId { get; set; }

        /// <summary>
        /// Patient's Operation Procedure Type
        /// </summary>
        public string ProcedureType { get; set; }

        /// <summary>
        /// Operation Followup Period Id
        /// </summary>
        public int? FollowUpPeriodId { get; set; }

        /// <summary>
        /// Operation Followup Period
        /// </summary>
        public string FollowUpPeriod { get; set; }

        /// <summary>
        /// Followup Due Date
        /// </summary>
        public DateTime? FollowUpDate { get; set; }

        /// <summary>
        /// FollowUp Call Details Id
        /// </summary>
        public int? FollowUpCallDetailsId { get; set; }

        /// <summary>
        /// Followup Call One Id
        /// </summary>
        public int? CallOneId { get; set; }

        /// <summary>
        /// FollowUp Call One result
        /// </summary>
        public string CallOneResult { get; set; }

        /// <summary>
        /// Followup Call Two
        /// </summary>
        public int? CallTwoId { get; set; }

        /// <summary>
        /// FollowUp Call Two result
        /// </summary>
        public string CallTwoResult { get; set; }

        /// <summary>
        /// FollowUp Call Three
        /// </summary>
        public int? CallThreeId { get; set; }

        /// <summary>
        /// FollowUp Call Three result
        /// </summary>
        public string CallThreeResult { get; set; }

        /// <summary>
        /// FollowUp Call Four
        /// </summary>
        public int? CallFourId { get; set; }

        /// <summary>
        /// FollowUp Call Four result
        /// </summary>
        public string CallFourResult { get; set; }

        /// <summary>
        /// Followup Call Five
        /// </summary>
        public int? CallFiveId { get; set; }

        /// <summary>
        /// FollowUp Call Five result
        /// </summary>
        public string CallFiveResult { get; set; }

        /// <summary>
        /// Patient Opt Off Status Id
        /// </summary>
        public int? PatientOptOffStatus { get; set; }

        /// <summary>
        /// Last Update By
        /// </summary>
        public string LastUpdatedBy { get; set; }

        /// <summary>
        /// Last Updated Date Time
        /// </summary>
        public DateTime? LastUpdatedDateTime { get; set; }

        /// <summary>
        /// Assigned To
        /// </summary>
        public int? AssignedTo { get; set; }

        /// <summary>
        /// Followup Notes
        /// </summary>
        public string FollowUpNotes { get; set; }

        /// <summary>
        /// Last Call Details entered
        /// </summary>
        public string LastConfirmedCall { get; set; }

        /// <summary>
        /// Patient State Id
        /// </summary>
        public int? StateId { get; set; }

        /// <summary>
        /// Patient State Id in string
        /// </summary>
        public string StringStateId
        {
            get { return StateId.HasValue ? StateId.Value.ToString() : "-"; }
        }

        /// <summary>
        /// Patient State
        /// </summary>
        public string State { get; set; }
    }
}