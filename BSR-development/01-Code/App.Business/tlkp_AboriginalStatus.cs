//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace App.Business
{
    using System;
    using System.Collections.Generic;
    
    public partial class tlkp_AboriginalStatus
    {
        public tlkp_AboriginalStatus()
        {
            this.tbl_Patient = new HashSet<tbl_Patient>();
        }
    
        public int Id { get; set; }
        public string Description { get; set; }
    
        public virtual ICollection<tbl_Patient> tbl_Patient { get; set; }
    }
}
