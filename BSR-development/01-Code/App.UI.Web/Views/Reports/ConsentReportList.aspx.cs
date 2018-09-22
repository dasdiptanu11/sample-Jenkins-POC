using App.Business;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.UI.Web.Views.Shared;
using Microsoft.Reporting.WebForms;
using Telerik.Web.UI;


namespace App.UI.Web.Views.Reports
{
    public partial class ConsentReportList : BasePage
    {
        /// <summary>
        /// Loads Consent List Report page
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                LoadLookup();
                string pageName = "Consent Report List";
                RunReport.Attributes.Add("onclick", "return ConfirmDownload(" + ((System.Web.UI.Control)(this.RunReport)).ClientID + ",'" + pageName + "')");
            }
        }
        /// <summary>
        /// Loads Consent List Report page and bind web controls
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
            DateTime fromDate = Convert.ToDateTime("01/01/1940");
            DateTime toDate = Convert.ToDateTime("01/01/1940");
            string patientGroup = PatientGroupReport.SelectedItem.Value == null || PatientGroupReport.SelectedItem.Value == "" || PatientGroupReport.SelectedItem.Text == "All" ? "2" : PatientGroupReport.SelectedItem.Value;

            ReportParameter reportSiteId = new ReportParameter("pSiteId", siteId);
            ReportParameter reportSurgeonId = new ReportParameter("pSurgeonId", surgeonId);
            ReportParameter reportFromDate = new ReportParameter("pOptOffdateFrom", fromDate.ToShortDateString());
            ReportParameter reportToDate = new ReportParameter("pOptOffdateto", toDate.ToShortDateString());
            ReportParameter reportPatientGroup = new ReportParameter("pRunForLegacyOnly", patientGroup);
            ReportParameter reportBenchmark = new ReportParameter("ReportCriteria", reportCriteria);

            ReportView.Reset();
            LoadReportDefinition(ReportView, "ConsentReportList");
            ReportView.LocalReport.DataSources.Clear();
            ReportView.LocalReport.DataSources.Add(new ReportDataSource("DSConsentReportList", odsCLReport));
            ReportView.LocalReport.SetParameters(new ReportParameter[] { reportSiteId, reportSurgeonId, reportFromDate, reportToDate, reportPatientGroup, reportBenchmark });
            ReportView.LocalReport.DisplayName = "Consent List" + DateTime.Now.ToString();
            ReportView.LocalReport.Refresh();
        }
    }
}