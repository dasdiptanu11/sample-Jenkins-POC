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
    
    public partial class tbl_PatientOperationDeviceDtls_Audit
    {
        public string Action { get; set; }
        public string AuditUserName { get; set; }
        public System.DateTime AuditDate { get; set; }
        public int PatientOperationDevId { get; set; }
        public Nullable<int> PatientOperationId { get; set; }
        public Nullable<int> ParentPatientOperationDevId { get; set; }
        public Nullable<int> DevType { get; set; }
        public Nullable<int> DevBrand { get; set; }
        public string DevOthBrand { get; set; }
        public string DevOthDesc { get; set; }
        public string DevOthMode { get; set; }
        public Nullable<int> DevManuf { get; set; }
        public string DevOthManuf { get; set; }
        public Nullable<int> DevId { get; set; }
        public string DevLotNo { get; set; }
        public Nullable<int> DevPortMethId { get; set; }
        public Nullable<bool> PriPortRet { get; set; }
        public Nullable<int> ButtressId { get; set; }
        public Nullable<int> IgnoreDevice { get; set; }
    }
}
