using System;

namespace App.Business {
    /// <summary>
    /// Contains Site list properties
    /// </summary>
    public class SiteListItem : SiteInfo {
        /// <summary>
        /// Site StateName
        /// </summary>
        public String SiteStateName { get; set; }

        /// <summary>
        /// Site StateId
        /// </summary>
        public int SiteStateId { get; set; }
    }

}
