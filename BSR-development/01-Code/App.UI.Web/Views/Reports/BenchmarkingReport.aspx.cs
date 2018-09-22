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
    public partial class BenchmarkingReport : BasePage
    {
        /// <summary>
        /// Loads EWL Benchmarking (Graph) screen
        /// </summary>
        /// <param name="sender">it contains refrence to the control that raised the event</param>
        /// <param name="e">it contains event data</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            string pageName = "Benchmarking Report";
            if (!Page.IsPostBack)
            {
                LoadLookup();
                RunReport.Attributes.Add("onclick", "return ConfirmDownload(" + ((System.Web.UI.Control)(this.RunReport)).ClientID + ",'" + pageName + "')");
            }
        }
        /// <summary>
        /// Loads EWL Benchmarking (Graph) screen and bind web controls
        /// </summary>
        /// <returns></returns>
        protected bool LoadLookup()
        {
            using (UnitOfWork reportingDetails = new UnitOfWork())
            {
                Helper.BindCollectionToControl(SiteA, reportingDetails.Get_HospitalList(UserName, -1, false, true), "Id", "Description");
                Helper.BindCollectionToControl(SurgeonA, reportingDetails.Get_tlkp_aspnet_user_Surgeon(false, true), "Id", "Description");
                Helper.BindCollectionToControl(OperationTypeA, reportingDetails.GetPrimaryProcedureWithAll(false), "Id", "Description");
                Helper.BindCollectionToControl(StateA, reportingDetails.Get_tlkp_State(true), "Id", "Description");
                Helper.BindCollectionToControl(CountryA, reportingDetails.Get_tlkp_Country(true), "Id", "Description");
                Helper.BindCollectionToControl(SiteB, reportingDetails.Get_HospitalList(UserName, -1, false, true), "Id", "Description");
                Helper.BindCollectionToControl(SurgeonB, reportingDetails.Get_tlkp_aspnet_user_Surgeon(false, true), "Id", "Description");
                Helper.BindCollectionToControl(OperationTypeB, reportingDetails.GetPrimaryProcedureWithAll(false), "Id", "Description");
                Helper.BindCollectionToControl(StateB, reportingDetails.Get_tlkp_State(true), "Id", "Description");
                Helper.BindCollectionToControl(CountryB, reportingDetails.Get_tlkp_Country(true), "Id", "Description");
                Helper.BindCollectionToControl(PatientGroupA, reportingDetails.Get_tlkp_PatientGroup(true), "Id", "Description");
                Helper.BindCollectionToControl(PatientGroupB, reportingDetails.Get_tlkp_PatientGroup(true), "Id", "Description");
                SiteA.DataBind();
                SurgeonA.DataBind();
                SiteB.DataBind();
                SurgeonB.DataBind();
                StateA.Items[0].Text = "All";
                CountryA.Items[0].Text = "All";
                StateB.Items[0].Text = "All";
                CountryB.Items[0].Text = "All";
                PatientGroupA.Items[0].Text = "All";
                PatientGroupB.Items[0].Text = "All";
            }
            return true;
        }
        /// <summary>
        /// Generates Report on the basis of Search Criteria 1 or 2
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RunReport_Click(object sender, EventArgs e)
        {
            string title = "EWL Benchmarking (Graph)\nCriteria 1 ( " + GetTitleA() + ")\nvs\nCriteria 2 (" + GetTitleB() + ")";
            string siteIdA = SiteA.SelectedItem.Value == null || SiteA.SelectedItem.Value == "" || SiteA.SelectedItem.Text == "All" ? "0" : SiteA.SelectedItem.Value;
            string stateIdA = StateA.SelectedItem.Value == null || StateA.SelectedItem.Value == "" || StateA.SelectedItem.Text == "All" ? "0" : StateA.SelectedItem.Value;
            string countryIdA = CountryA.SelectedItem.Value == null || CountryA.SelectedItem.Value == "" || CountryA.SelectedItem.Text == "All" ? "0" : CountryA.SelectedItem.Value;
            string surgeonIdA = SurgeonA.SelectedItem.Value == null || SurgeonA.SelectedItem.Value == "" || SurgeonA.SelectedItem.Text == "All" ? "0" : SurgeonA.SelectedItem.Value;
            string operationTypeA = OperationTypeA.SelectedItem.Value == null || OperationTypeA.SelectedItem.Value == "" || OperationTypeA.SelectedItem.Text == "All" ? "0" : OperationTypeA.SelectedItem.Value;
            string patientGroupA = "0";// PatientGroupA.SelectedItem.Value == null || PatientGroupA.SelectedItem.Value == "" || PatientGroupA.SelectedItem.Text == "All" ? "2" : PatientGroupA.SelectedItem.Value;
            //
            ReportParameter reportSiteIdA = new ReportParameter("pSiteId_A", siteIdA);
            ReportParameter reportStateIdA = new ReportParameter("pStateId_A", stateIdA);
            ReportParameter reportCountryIdA = new ReportParameter("pCountryId_A", countryIdA);
            ReportParameter reportSurgeonIdA = new ReportParameter("pSurgeonId_A", surgeonIdA);
            ReportParameter reportOperationTypeA = new ReportParameter("pOpTypeID_A", operationTypeA);
            ReportParameter reportPatientGroupA = new ReportParameter("pRunForLegacyOnly_A", patientGroupA);
            //
            string siteIdB = SiteB.SelectedItem.Value == null || SiteB.SelectedItem.Value == "" || SiteB.SelectedItem.Text == "All" ? "0" : SiteB.SelectedItem.Value;
            string stateIdB = StateB.SelectedItem.Value == null || StateB.SelectedItem.Value == "" || StateB.SelectedItem.Text == "All" ? "0" : StateB.SelectedItem.Value;
            string countryIdB = CountryB.SelectedItem.Value == null || CountryB.SelectedItem.Value == "" || CountryB.SelectedItem.Text == "All" ? "0" : CountryB.SelectedItem.Value;
            string surgeonIdB = SurgeonB.SelectedItem.Value == null || SurgeonB.SelectedItem.Value == "" || SurgeonB.SelectedItem.Text == "All" ? "0" : SurgeonB.SelectedItem.Value;
            string operationTypeB = OperationTypeB.SelectedItem.Value == null || OperationTypeB.SelectedItem.Value == "" || OperationTypeB.SelectedItem.Text == "All" ? "0" : OperationTypeB.SelectedItem.Value;
            string patientGroupB = "0";// PatientGroupB.SelectedItem.Value == null || PatientGroupB.SelectedItem.Value == "" || PatientGroupB.SelectedItem.Text == "All" ? "2" : PatientGroupB.SelectedItem.Value;
            //
            ReportParameter reportSiteIdB = new ReportParameter("pSiteId_B", siteIdB);
            ReportParameter reportStateIdB = new ReportParameter("pStateId_B", stateIdB);
            ReportParameter reportCountryIdB = new ReportParameter("pCountryId_B", countryIdB);
            ReportParameter reportSurgeonIdB = new ReportParameter("pSurgeonId_B", surgeonIdB);
            ReportParameter reportOperationTypeIdB = new ReportParameter("pOpTypeID_B", operationTypeB);
            ReportParameter reportPatientGroupIdB = new ReportParameter("pRunForLegacyOnly_B", patientGroupB);

            BenchmarkReport.Reset();
            LoadReportDefinition(BenchmarkReport, "BenchmarkingReport");
            BenchmarkReport.LocalReport.DataSources.Clear();
            //BenchmarkReport.LocalReport.DisplayName = Title;
            BenchmarkReport.LocalReport.DataSources.Add(new ReportDataSource("dsBenchMarking", odsCLReport));
            BenchmarkReport.LocalReport.SetParameters(new ReportParameter("ReportName", title));
            BenchmarkReport.LocalReport.SetParameters(new ReportParameter[] { reportSiteIdA, reportSurgeonIdA, reportOperationTypeA, reportStateIdA, reportCountryIdA, reportSiteIdB, reportSurgeonIdB, reportOperationTypeIdB, reportStateIdB, reportCountryIdB, reportPatientGroupA, reportPatientGroupIdB });
            BenchmarkReport.LocalReport.DisplayName = "Benchmarking Report" + DateTime.Now.ToString();
            BenchmarkReport.LocalReport.Refresh();

        }
        //Get the title for search criteria B or 2
        private string GetTitleB()
        {
            string titleSiteB = SiteB.SelectedItem.Value == null || SiteB.SelectedItem.Value == "" ? "All" : SiteB.SelectedItem.Text;
            string titleStateB = StateB.SelectedItem.Value == null || StateB.SelectedItem.Value == "" ? "All" : StateB.SelectedItem.Text;
            string titleCountryB = CountryB.SelectedItem.Value == null || CountryB.SelectedItem.Value == "" ? "All" : CountryB.SelectedItem.Text;
            string titleSurgeonB = SurgeonB.SelectedItem.Value == null || SurgeonB.SelectedItem.Value == "" ? "All" : SurgeonB.SelectedItem.Text;
            string operationTypeB = OperationTypeB.SelectedItem.Value == null || OperationTypeB.SelectedItem.Value == "" ? "All" : OperationTypeB.SelectedItem.Text;
            string patientGroupB = "Primary Patients"; //PatientGroupB.SelectedItem.Value == null || PatientGroupB.SelectedItem.Value == "" ? "All" : PatientGroupB.SelectedItem.Text;
            return "Site: " + titleSiteB + ", State: " + titleStateB + ", Country: " + titleCountryB + ", Surgeon: " + titleSurgeonB + ", Operation Type: " + operationTypeB + ", Patient Group: " + patientGroupB;
        }
        //Get the titles for search criteria A or 1
        private string GetTitleA()
        {
            string titleSiteA = SiteA.SelectedItem.Value == null || SiteA.SelectedItem.Value == "" ? "All" : SiteA.SelectedItem.Text;
            string titleStateA = StateA.SelectedItem.Value == null || StateA.SelectedItem.Value == "" ? "All" : StateA.SelectedItem.Text;
            string Country_A = CountryA.SelectedItem.Value == null || CountryA.SelectedItem.Value == "" ? "All" : CountryA.SelectedItem.Text;
            string titleSurgeonA = SurgeonA.SelectedItem.Value == null || SurgeonA.SelectedItem.Value == "" ? "All" : SurgeonA.SelectedItem.Text;
            string operationTypeA = OperationTypeA.SelectedItem.Value == null || OperationTypeA.SelectedItem.Value == "" ? "All" : OperationTypeA.SelectedItem.Text;
            string patientGroupA = "Primary Patients";// PatientGroupA.SelectedItem.Value == null || PatientGroupA.SelectedItem.Value == "" ? "All" : PatientGroupA.SelectedItem.Text;
            return "Site: " + titleSiteA + ", State: " + titleStateA + ", Country: " + Country_A + ", Surgeon: " + titleSurgeonA + ", Operation Type: " + operationTypeA + ", Patient Group: " + patientGroupA;
        }
    }
}