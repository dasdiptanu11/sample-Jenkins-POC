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
    
    public partial class tbl_HistoryLogin
    {
        public int ID { get; set; }
        public string Username { get; set; }
        public Nullable<System.DateTime> AttemptDateTime { get; set; }
        public string Status { get; set; }
        public string IpAddress { get; set; }
        public string UserAgent { get; set; }
    }
}
