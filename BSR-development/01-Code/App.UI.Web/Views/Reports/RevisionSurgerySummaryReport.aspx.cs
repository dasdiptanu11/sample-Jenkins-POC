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
    public partial class RevisionSurgerySummaryReport : BasePage
    {
        /// <summary>
        /// Loads Revision Surgery Summary Report page
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            string pageName = "Revision Surgery Summary Report";
            if (!Page.IsPostBack)
            {
                LoadLookup();
                RunReport.Attributes.Add("onclick", "return ConfirmDownload(" + ((System.Web.UI.Control)(this.RunReport)).ClientID + ",'" + pageName + "')");
            }
        }
        /// <summary>
        /// Loads Revision Surgery Summary Report page and bind web controls
        /// </summary>
        /// <returns></returns>
        protected bool LoadLookup()
        {
            using (UnitOfWork reportDetails = new UnitOfWork())
            {
                Helper.BindCollectionToControl(Site, reportDetails.Get_HospitalList(UserName, -1, false, true), "Id", "Description");
                Helper.BindCollectionToControl(Surgeon, reportDetails.Get_tlkp_aspnet_user_Surgeon(false, true), "Id", "Description");
                Site.DataBind();
                Surgeon.DataBind();
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
            reportCriteria = reportCriteria + "Site: " + Site.SelectedItem.Text.ToString() + ", ";
            reportCriteria = reportCriteria + "Surgeon: " + Surgeon.SelectedItem.Text.ToString();
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
            ReportParameter reportPatientGroup = new ReportParameter("pRunForLegacyOnly", "0");
            ReportParameter reportBenchmark = new ReportParameter("ReportCriteria", reportCriteria);
            ReportParameter formattedFromDate = new ReportParameter("pStrFromDate", fromDate.ToString("dd-MM-yyyy"));
            ReportParameter formattedToDate = new ReportParameter("pStrToDate", toDate.ToString("dd-MM-yyyy"));

            ReportView.Reset();

            LoadReportDefinition(ReportView, "RSSReport");
            ReportView.LocalReport.DataSources.Clear();
            ReportView.LocalReport.DataSources.Add(new ReportDataSource("dsReports", odsRSSR));
            ReportView.LocalReport.DataSources.Add(new ReportDataSource("dsReOpReasons", odsRSSR2));
            //ReportView.LocalReport.DataSources.Add(new ReportDataSource("dsSlip", odsRSSR3));
            //ReportView.LocalReport.DataSources.Add(new ReportDataSource("dsPort", odsRSSR4));

            ReportView.LocalReport.DataSources.Add(new ReportDataSource("dsSlip", odsRSSR4));
            ReportView.LocalReport.DataSources.Add(new ReportDataSource("dsPort", odsRSSR3));



            ReportView.LocalReport.SetParameters(new ReportParameter[] { reportSiteId, reportSurgeonId, reportFromDate, reportToDate, reportPatientGroup, reportBenchmark, formattedFromDate, formattedToDate });
            ReportView.LocalReport.DisplayName = "RSS Report" + DateTime.Now.ToString();
            ReportView.LocalReport.Refresh();
            //ReportView.Visible = true;





        }
    }
}