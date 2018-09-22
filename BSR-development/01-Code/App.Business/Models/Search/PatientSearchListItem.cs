using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business
{
    /// <summary>
    /// Contains Patient SearchList Item properties
    /// </summary>
    public class PatientSearchListItem
    {

        /// <summary>
        /// Patient Id
        /// </summary>
        public int PatientId { get; set; }

        /// <summary>
        /// URN
        /// </summary>
        public String URN { get; set; }

        /// <summary>
        /// Site
        /// </summary>
        public String Site { get; set; }

        /// <summary>
        /// SiteId
        /// </summary>
        public int SiteId { get; set; }

        /// <summary>
        /// Family Name
        /// </summary>
        public String FamilyName { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public String GivenName { get; set; }

        /// <summary>
        /// DOB
        /// </summary>
        public DateTime? DOB { get; set; }

        /// <summary>
        /// Gender
        /// </summary>
        public string Gender { get; set; }

        /// <summary>
        /// Suburb
        /// </summary>
        public string Suburb { get; set; }

        /// <summary>
        /// Postcode
        /// </summary>
        public string Postcode { get; set; }

        /// <summary>
        /// Medicare
        /// </summary>
        public string Medicare { get; set; }

        /// <summary>
        /// DVA No
        /// </summary>
        public string DVANo { get; set; }

        /// <summary>
        /// NHI Number
        /// </summary>
        public string NHI { get; set; }

        /// <summary>
        /// Country
        /// </summary>
        public string Country { get; set; }

        /// <summary>
        /// URId
        /// </summary>
        public int URId { get; set; }

        /// <summary>
        /// IHI
        /// </summary>
        public String IHI { get; set; }

        /// <summary>
        /// Status
        /// </summary>
        public string Status { get; set; }

        /// <summary>
        /// StatusId
        /// </summary>
        public int? StatusId { get; set; }
    }

    /// <summary>
    /// Contains URN item properties
    /// </summary>
    public class URNItem : tbl_URN
    {
        /// <summary>
        /// OperationtOffStatusID
        /// </summary>
        public int? OperationtOffStatusID { get; set; }
    }

    /// <summary>
    /// Contains Patient URN properties
    /// </summary>
    public class PatientURN : tbl_URN
    {

        /// <summary>
        /// URN
        /// </summary>
        public string URN { get; set; }

        /// <summary>
        /// SiteName
        /// </summary>
        public string SiteName { get; set; }

        /// <summary>
        /// SiteId
        /// </summary>
        public int SiteId { get; set; }

        /// <summary>
        /// URId
        /// </summary>
        public int URId { get; set; }
    }

}

