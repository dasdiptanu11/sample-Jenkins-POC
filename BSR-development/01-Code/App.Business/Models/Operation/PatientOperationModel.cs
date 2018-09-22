using System;

namespace App.Business
{
    public class PatientOperationModel
    {
        public int OpId { get; set; }
        public int PatientId { get; set; }
        public int? Hosp { get; set; }
        public int? Surg { get; set; }
        public DateTime? OpDate { get; set; }
        public bool? ProcAban { get; set; }
        public string OpAge { get; set; }
        public int? OpStat { get; set; }
        public int? OpType { get; set; }
        public string OthPriType { get; set; }
        public int? OpRevType { get; set; }
        public string OthRevType { get; set; }
        public int? LstBarProc { get; set; }
        public decimal? Ht { get; set; }
        public bool? HtNtKnown { get; set; }
        public decimal? StWt { get; set; }
        public bool? StWtNtKnown { get; set; }
        public decimal? StBMI { get; set; }
        public decimal? OpWt { get; set; }
        public bool? SameOpWt { get; set; }
        public bool? OpWtNtKnown { get; set; }
        public decimal? OpBMI { get; set; }
        public int? DiabStat { get; set; }
        public int? DiabRx { get; set; }
        public int? RenalTx { get; set; }
        public int? LiverTx { get; set; }
        public int? Time { get; set; }
        public string OthInfoOp { get; set; }
        public int? OpVal { get; set; }
        public string LastUpdatedBy { get; set; }
        public DateTime? LastUpdatedDateTime { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public int? FurtherInfoSlip { get; set; }
        public int? FurtherInfoPort { get; set; }
        public string ReasonOther { get; set; }
        public int? OpEvent { get; set; }
        public DateTime? AdmissionDate { get; set; }
        public DateTime? DischargeDate { get; set; }
        public int? OpBowelObsID { get; set; }
        public int? OpTypeBulkLoad { get; set; }
    }
}
