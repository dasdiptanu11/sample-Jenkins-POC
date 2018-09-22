using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.Business;
using App.UI.Web.Views.Shared;
using Microsoft.Reporting.WebForms;
using Telerik.Web.UI;


namespace App.UI.Web.Views.Reports
{
    public partial class SurgeonReport : BasePage
    {
        /// <summary>
        /// Loads Surgeon Report page
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            string pageName = "Surgeon Report";
            if (!Page.IsPostBack)
            {
                LoadLookup();
                RunReport.Attributes.Add("onclick", "return ConfirmDownload(" + ((System.Web.UI.Control)(this.RunReport)).ClientID + ",'" + pageName + "')");
            }
        }
        /// <summary>
        /// Loads Surgeon Report page and bind web controls
        /// </summary>
        /// <returns></returns>
        protected bool LoadLookup()
        {
            using (UnitOfWork reportDetails = new UnitOfWork())
            {
                Helper.BindCollectionToControl(Site, reportDetails.Get_HospitalList(UserName, -1, false, true), "Id", "Description");
                Helper.BindCollectionToControl(Surgeon, reportDetails.Get_tlkp_aspnet_user_Surgeon(false, true), "Id", "Description");
                Helper.BindCollectionToControl(PatientGroupReport, reportDetails.Get_tlkp_PatientGroup(true), "Id", "Description");
                PatientGroupReport.Items[0].Text = "All";
                Site.DataBind();
                Surgeon.DataBind();
                //CreateRunForValues();
            }
            return true;
        }
        /// <summary>
        ///  Gets report benchmarks
        /// </summary>
        /// <returns>Report benchmarks</returns>
        protected string GetCriteria()
        {
            string reportCriteria = "(";
            // rptCriteria = rptCriteria + (rdpFrom.SelectedDate == null ? "" : ("From date: " + rdpFrom.SelectedDate.Value.ToShortDateString() + ", "));
            // rptCriteria = rptCriteria + (rdpTo.SelectedDate == null ? "" : ("To date: " + rdpTo.SelectedDate.Value.ToShortDateString() + ", "));
            reportCriteria = reportCriteria + "Site: " + Site.SelectedItem.Text.ToString() + ", ";
            reportCriteria = reportCriteria + "Surgeon: " + Surgeon.SelectedItem.Text.ToString() + ", ";
            reportCriteria = reportCriteria + "Patient Group : " + PatientGroupReport.SelectedItem.Text.ToString();
            reportCriteria = reportCriteria + ")";
            return reportCriteria;
        }
        /// <summary>
        /// Runs a report on the basis of report criteria
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RunReport_Click(object sender, EventArgs e)
        {
            string reportCriteria = GetCriteria();
            string siteId = Site.SelectedItem.Value == null || Site.SelectedItem.Value == "" || Site.SelectedItem.Text == "All" ? "0" : Site.SelectedItem.Value;
            string surgeonId = Surgeon.SelectedItem.Value == null || Surgeon.SelectedItem.Value == "" || Surgeon.SelectedItem.Text == "All" ? "0" : Surgeon.SelectedItem.Value;
            DateTime selectedFromDate = this.rdpFrom.SelectedDate == null ? Convert.ToDateTime("01/01/1940") : this.rdpFrom.SelectedDate.Value;
            DateTime selectedToDate = this.rdpTo.SelectedDate == null ? Convert.ToDateTime("01/01/1940") : this.rdpTo.SelectedDate.Value;
            string patientGroup = PatientGroupReport.SelectedItem.Value == null || PatientGroupReport.SelectedItem.Value == "" || PatientGroupReport.SelectedItem.Text == "All" ? "2" : PatientGroupReport.SelectedItem.Value;

            DateTime fromDate = selectedFromDate;
            DateTime toDate = selectedToDate == Convert.ToDateTime("01/01/1940") ? DateTime.Now : selectedToDate;
            if (selectedFromDate == Convert.ToDateTime("01/01/1940"))
            {
                using (UnitOfWork patientDetails = new UnitOfWork())
                {
                    tbl_PatientOperation patientOperation = patientDetails.tbl_PatientOperationRepository.Get().Where(x => x.OpDate != null).OrderBy(x => x.OpDate).FirstOrDefault();
                    if (patientOperation.OpDate != null && patientOperation.OpDate != null) fromDate = Convert.ToDateTime(patientOperation.OpDate);
                }
            }
            ReportParameter reportSiteId = new ReportParameter("pSiteId", siteId);
            ReportParameter reportSurgeonId = new ReportParameter("pSurgeonId", surgeonId);
            ReportParameter reportFromDate = new ReportParameter("pOpDateFrom", selectedFromDate.ToShortDateString());
            ReportParameter reportToDate = new ReportParameter("pOpDateTo", selectedToDate.ToShortDateString());
            ReportParameter reportBenchmark = new ReportParameter("ReportCriteria", reportCriteria);
            ReportParameter reportPatientGroup = new ReportParameter("pRunForLegacyOnly", patientGroup);
            ReportParameter formattedFromDate = new ReportParameter("pStrFromDate", fromDate.ToString("dd/MM/yyyy"));
            ReportParameter formattedToDate = new ReportParameter("pStrToDate", toDate.ToString("dd/MM/yyyy"));
            SurgeonReportView.Reset();
            LoadReportDefinition(SurgeonReportView, "SurgeonReport");
            SurgeonReportView.LocalReport.DataSources.Clear();
            SurgeonReportView.LocalReport.DataSources.Add(new ReportDataSource("dsSentinel", odsSurgeonReport1));
            SurgeonReportView.LocalReport.DataSources.Add(new ReportDataSource("dsDiaxCnt", odsSurgeonReport2));
            SurgeonReportView.LocalReport.DataSources.Add(new ReportDataSource("dsDiaxCnt2", odsSurgeonReport10));
            SurgeonReportView.LocalReport.DataSources.Add(new ReportDataSource("dsDiaxCnt3", odsSurgeonReport11));
            SurgeonReportView.LocalReport.DataSources.Add(new ReportDataSource("dsPatCnt", odsSurgeonReport3));
            SurgeonReportView.LocalReport.DataSources.Add(new ReportDataSource("dsOpTypeAndCnt", odsSurgeonReport4));
            SurgeonReportView.LocalReport.DataSources.Add(new ReportDataSource("dsSlfReportedWt", odsSurgeonReport5));
            SurgeonReportView.LocalReport.DataSources.Add(new ReportDataSource("dsFollowUps", odsSurgeonReport6));
            SurgeonReportView.LocalReport.DataSources.Add(new ReportDataSource("dsSEReason", odsSurgeonReport7));
            SurgeonReportView.LocalReport.DataSources.Add(new ReportDataSource("dsSlipReasons", odsSurgeonReport9));
            SurgeonReportView.LocalReport.DataSources.Add(new ReportDataSource("dsReasonsPort", odsSurgeonReport8));
            SurgeonReportView.LocalReport.SetParameters(new ReportParameter[] { reportSiteId, reportSurgeonId, reportFromDate, reportToDate, reportBenchmark, reportPatientGroup, formattedFromDate, formattedToDate });
            SurgeonReportView.LocalReport.DisplayName = "Surgeon Report" + DateTime.Now.ToString();
            SurgeonReportView.LocalReport.Refresh();
        }
    }
}