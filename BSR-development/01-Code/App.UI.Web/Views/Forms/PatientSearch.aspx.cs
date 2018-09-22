using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.Business;
using App.UI.Web.Views.Shared;
using Telerik.Web.UI;

namespace App.UI.Web.Views.Forms
{
    public partial class PatientSearch : BasePage
    {
        // Flag to determine whether User has taken action Data Export
        bool _isExport = false;

        // Flag to determine whether User has taken Action for Data Export in PDF File Format
        bool _isPdfExport = false;

        /// <summary>
        /// Initializes page controls
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">event arguments</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            TurnTextBoxAutoCompleteOff();
            Country.Attributes.Add("onchange", "ShowHideMedicareAndDVA()");
            if (!IsPostBack)
            {
                LoadLookup();
                ReloadForm();
            }
        }

        // Reload Patient Search form, Clearing data for next search option
        private void ReloadForm()
        {
            SessionData sessionData = GetDefaultSessionData();
            if (sessionData == null)
            {
                Clear();
            }
            else
            {
                FamilyName.Text = sessionData.AdminFamilyName;
                GivenName.Text = sessionData.AdminGivenName;
                UrnNumber.Text = sessionData.AdminURN;
                UrnNumber.Text = sessionData.AdminURN;
                MedicareNumber.Text = sessionData.AdminMedicare;
                NhiNumber.Text = sessionData.AdminNHI;
                DvaNumber.Text = sessionData.AdminDVA;
                BirthDate.SelectedDate = sessionData.AdminDateOfBirth;
                Country.SelectedValue = sessionData.AdminCountry;
                if (FamilyName.Text != string.Empty || GivenName.Text != string.Empty || UrnNumber.Text != string.Empty)
                { Search(); }
            }
        }

        // Loading Lookup values from database
        private void LoadLookup()
        {
            using (UnitOfWork lookupRepository = new UnitOfWork())
            {
                Helper.BindCollectionToControl(Country, lookupRepository.Get_tlkp_Country(false), "Id", "Description");
                SetCountryToDefault();
                BirthDate.MaxDate = System.DateTime.Now;
            }
        }

        /// <summary>
        /// Setting Country value to Australia by default
        /// </summary>
        public void SetCountryToDefault()
        {
            Country.SelectedValue = Constants.COUNTRY_CODE_FOR_AUSTRALIA.ToString();
            ShowAndHideLabelsAccordingToCountry();
        }

        /// <summary>
        /// Toggelling visibility for controls dependent on the country selection
        /// </summary>
        public void ShowAndHideLabelsAccordingToCountry()
        {
            if (Country.SelectedValue.Equals(Constants.COUNTRY_CODE_FOR_AUSTRALIA.ToString(), StringComparison.OrdinalIgnoreCase))
            {
                PatientNHIPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                MedicarePanel.Style.Add(HtmlTextWriterStyle.Display, "block");
            }
            else
            {
                PatientNHIPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                MedicarePanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            }
        }

        /// <summary>
        /// Search Clicked
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">event arguments</param>
        protected void SearchClicked(object sender, EventArgs e)
        {
            Search();
        }

        // Search and populate list of the patients as per the search criteria of the user
        private void Search()
        {
            int selectedItems = 0;
            PatientSearchErrorMessages.Items.Clear();

            selectedItems = !String.IsNullOrEmpty(GivenName.Text) ? selectedItems + 1 : selectedItems;
            selectedItems = !String.IsNullOrEmpty(FamilyName.Text) ? selectedItems + 1 : selectedItems;
            selectedItems = BirthDate.SelectedDate != null ? selectedItems + 1 : selectedItems;

            // If user has selected any search criteria than rebind the grid with list of patients for the search criteria
            if (!String.IsNullOrEmpty(MedicareNumber.Text) || !String.IsNullOrEmpty(DvaNumber.Text) ||
                !String.IsNullOrEmpty(NhiNumber.Text) || !String.IsNullOrEmpty(UrnNumber.Text) ||
                !(String.IsNullOrEmpty(PatientId.Text)) || selectedItems >= 2)
            {
                PatientListGrid.Rebind();
            }
            else
            {
                PatientSearchErrorMessages.Items.Add("Please enter at least one 'Exact Match' condition or two from 'Like Match' conditions to begin search");
            }

            ShowAndHideLabelsAccordingToCountry();
            //Setting into session to retreive search parameters for Admin
            SessionData sessionData = GetDefaultSessionData();
            sessionData.AdminFamilyName = FamilyName.Text;
            sessionData.AdminGivenName = GivenName.Text;
            sessionData.AdminURN = UrnNumber.Text;
            sessionData.AdminMedicare = MedicareNumber.Text;
            sessionData.AdminNHI = NhiNumber.Text;
            sessionData.AdminDVA = DvaNumber.Text;
            sessionData.AdminDateOfBirth = BirthDate.SelectedDate;
            sessionData.AdminCountry = Country.SelectedValue;
        }

        /// <summary>
        /// Clear Search option clicked
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">event argument</param>
        protected void ClearClicked(object sender, EventArgs e)
        {
            Clear();
        }

        // Clearing the search criteria controls and search criteria from session data
        private void Clear()
        {
            PatientId.Text = string.Empty;
            GivenName.Text = string.Empty;
            UrnNumber.Text = string.Empty;
            FamilyName.Text = string.Empty;
            BirthDate.Clear();
            MedicareNumber.Text = string.Empty;
            DvaNumber.Text = string.Empty;
            NhiNumber.Text = string.Empty;
            PatientListPanel.Visible = false;
            SetCountryToDefault();
            //Clearing search parameters for Admin
            SessionData sessionData = GetDefaultSessionData();
            sessionData.AdminFamilyName = string.Empty;
            sessionData.AdminGivenName = string.Empty;
            sessionData.AdminURN = string.Empty;
            sessionData.AdminMedicare = string.Empty;
            sessionData.AdminNHI = string.Empty;
            sessionData.AdminDVA = string.Empty;
            sessionData.AdminDateOfBirth = null;
            sessionData.AdminCountry = string.Empty;
        }

        #region Grid Patient List
        /// <summary>
        /// Load Patients data as per the search criteria in the Patient Grid
        /// </summary>
        protected void PatientGrid_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
        {
            PatientListGrid.ExportSettings.FileName = "PatientDetails" + DateTime.Now.ToString();
            LoadGrid();
        }

        // Fetch list of patients from database satisfying search criteria and show list of patients
        private void LoadGrid()
        {
            int country = Convert.ToInt32(Country.SelectedItem.Value);

            //Parameters for exact match
            string patientUrnNumber = UrnNumber.Text;
            string medicareNumber = MedicareNumber.Text;
            string patientDvaNumber = DvaNumber.Text;
            string patientNhiNumber = NhiNumber.Text;
            string patientId = PatientId.Text;

            //Parameters for like match
            string givenName = GivenName.Text;
            string familyName = FamilyName.Text;
            DateTime? birthDateFromCriteria = null;
            DateTime? birthDateToCriteria = null;

            IEnumerable<PatientSearchListItem> PatientList = null;

            if (BirthDate.SelectedDate != null)
            {
                DateTime birthDate = (DateTime)BirthDate.SelectedDate;
                birthDateFromCriteria = birthDate.AddYears(-1);
                birthDateToCriteria = birthDate.AddYears(1);
            }

            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                if (!string.IsNullOrEmpty(patientUrnNumber) || !string.IsNullOrEmpty(medicareNumber) ||
                    !string.IsNullOrEmpty(patientDvaNumber) || !string.IsNullOrEmpty(patientNhiNumber) ||
                    !string.IsNullOrEmpty(patientId))
                {
                    PatientList = patientRepository.PatientRepository.GetPatientListWithExactDetails(
                        UserName,
                        country,
                        patientUrnNumber,
                        medicareNumber,
                        patientDvaNumber,
                        patientNhiNumber,
                        patientId);
                }

                if ((PatientList == null || PatientList.Count() < 1) &&
                    (!string.IsNullOrEmpty(givenName) || !string.IsNullOrEmpty(familyName) || 
                    BirthDate.SelectedDate != null))
                {
                    PatientList = patientRepository.PatientRepository.GetPatientListForGivenDetails(
                        UserName,
                        country,
                        givenName,
                        familyName,
                        birthDateFromCriteria,
                        birthDateToCriteria);
                }
            }

            // Patients data list found with the search term provided, bind the patient list to the patient grid
            if (PatientList != null) { PatientListGrid.DataSource = PatientList; }

            // Hiding columns from the patient grid as per the country selection of the search term
            if (country == Constants.COUNTRY_CODE_FOR_AUSTRALIA)
            {
                PatientListGrid.MasterTableView.GetColumn("MedicareNo").Visible = true;
                PatientListGrid.MasterTableView.GetColumn("DVA").Visible = true;
                PatientListGrid.MasterTableView.GetColumn("NHINo").Visible = false;
            }
            else
            {
                PatientListGrid.MasterTableView.GetColumn("MedicareNo").Visible = false;
                PatientListGrid.MasterTableView.GetColumn("DVA").Visible = false;
                PatientListGrid.MasterTableView.GetColumn("NHINo").Visible = true;
            }

            PatientListPanel.Visible = true;
        }

        /// <summary>
        /// Handling Patient Grid commands
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">event argument</param>
        protected void PatientGrid_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridEditableItem editedItem = e.Item as GridEditableItem;
            RadGrid patientGrid = (RadGrid)sender;
            try
            {
                SessionData sessionData = GetSessionData();
                switch (e.CommandName)
                {
                    case "EditPatient":
                        sessionData.ResetPatientData();
                        sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                        sessionData.PatientURNNumber = Convert.ToString(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["URN"]);
                        sessionData.SiteId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["SiteId"]);
                        sessionData.PatientURId = Convert.ToString(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["URId"]);
                        SaveSessionData(sessionData);
                        Response.Redirect(Properties.Resource2.PatientHomePath, false);
                        break;

                    case "RowClick":
                        break;

                    case "ExportToPdf":
                        _isExport = true;
                        _isPdfExport = true;
                        patientGrid.ExportSettings.OpenInNewWindow = true;
                        patientGrid.ExportSettings.ExportOnlyData = true;
                        patientGrid.ExportSettings.IgnorePaging = true;
                        patientGrid.MasterTableView.GetColumn("EditPatient").Visible = false;
                        patientGrid.MasterTableView.GetColumn("PatientId").Visible = true;
                        if (Country.SelectedItem.Value == Constants.COUNTRY_CODE_FOR_AUSTRALIA.ToString())
                        {
                            PatientListGrid.MasterTableView.GetColumn("MedicareNo").Visible = true;
                            PatientListGrid.MasterTableView.GetColumn("DVA").Visible = true;
                            PatientListGrid.MasterTableView.GetColumn("NHINo").Visible = false;
                        }
                        else
                        {
                            PatientListGrid.MasterTableView.GetColumn("MedicareNo").Visible = false;
                            PatientListGrid.MasterTableView.GetColumn("DVA").Visible = false;
                            PatientListGrid.MasterTableView.GetColumn("NHINo").Visible = true;
                        }

                        PatientListGrid.MasterTableView.GetColumn("PatientId").HeaderStyle.Width = Unit.Pixel(40);
                        PatientListGrid.MasterTableView.GetColumn("URN").HeaderStyle.Width = Unit.Pixel(40);
                        PatientListGrid.MasterTableView.GetColumn("FamilyName").HeaderStyle.Width = Unit.Pixel(80);
                        PatientListGrid.MasterTableView.GetColumn("GivenName").HeaderStyle.Width = Unit.Pixel(80);
                        PatientListGrid.MasterTableView.GetColumn("Site").HeaderStyle.Width = Unit.Pixel(80);
                        PatientListGrid.MasterTableView.GetColumn("Country").HeaderStyle.Width = Unit.Pixel(70);
                        PatientListGrid.MasterTableView.GetColumn("DOB").HeaderStyle.Width = Unit.Pixel(80);
                        break;

                    case "ExportToExcel":
                        _isExport = true;
                        patientGrid.ExportSettings.OpenInNewWindow = true;
                        patientGrid.ExportSettings.ExportOnlyData = true;
                        patientGrid.ExportSettings.IgnorePaging = true;
                        // Hide/show collumns when exporting
                        patientGrid.MasterTableView.GetColumn("EditPatient").Visible = false;
                        patientGrid.MasterTableView.GetColumn("PatientId").Visible = true;
                        if (Country.SelectedItem.Value.Equals(Constants.COUNTRY_CODE_FOR_AUSTRALIA.ToString(), StringComparison.OrdinalIgnoreCase))
                        {
                            PatientListGrid.MasterTableView.GetColumn("MedicareNo").Visible = true;
                            PatientListGrid.MasterTableView.GetColumn("DVA").Visible = true;
                            PatientListGrid.MasterTableView.GetColumn("NHINo").Visible = false;
                        }
                        else
                        {
                            PatientListGrid.MasterTableView.GetColumn("MedicareNo").Visible = false;
                            PatientListGrid.MasterTableView.GetColumn("DVA").Visible = false;
                            PatientListGrid.MasterTableView.GetColumn("NHINo").Visible = true;
                        }
                        break;

                    default:
                        break;
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// Adding Filtering in the Patient Grid
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">event argument</param>
        protected void PatientGrid_PreRender(object sender, EventArgs e)
        {
            for (int ColumnCount = 0; ColumnCount < PatientListGrid.Columns.Count; ColumnCount++)
            {
                PatientListGrid.Columns[ColumnCount].CurrentFilterFunction = Telerik.Web.UI.GridKnownFunction.StartsWith;
            }
        }

        /// <summary>
        /// processing column data to display desired result in grid
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">Grid Item Event Argument</param>
        protected void PatientGrid_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataItem = e.Item as GridDataItem;
                if (_isExport)
                {
                    if (dataItem["DOB"].Text != "&nbsp;")
                    {
                        DateTime patientDateOfBirth = Convert.ToDateTime(dataItem["DOB"].Text.ToString());
                        dataItem["DOB"].Text = patientDateOfBirth.ToShortDateString();
                    }
                }
            }
        }

        /// <summary>
        /// Formatting Grid cells
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">Grid Item event argument</param>
        protected void PatientGrid_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridHeaderItem && _isPdfExport)
            {
                foreach (TableCell cell in e.Item.Cells)
                {
                    cell.Style["border"] = "thin solid black";
                    cell.Style["background-color"] = "#cccccc";
                }
            }

            if (e.Item is GridFilteringItem && _isPdfExport)
            {
                GridFilteringItem filterItem = (GridFilteringItem)PatientListGrid.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
                foreach (TableCell cell in filterItem.Cells)
                {
                    cell.Text = string.Empty;
                }
            }

            if (e.Item is GridDataItem && _isPdfExport)
            {
                foreach (TableCell cell in e.Item.Cells)
                {
                    cell.Style["border"] = "thin solid black";
                }
            }

            if (e.Item is GridCommandItem)
            {
                var exportToExcelButton = (e.Item as GridCommandItem).FindControl("ExportToExcelButton") as Button;
                var exportToPdfButton = (e.Item as GridCommandItem).FindControl("ExportToPdfButton") as Button;
                if (exportToPdfButton != null) { ScriptManager.GetCurrent(Page).RegisterPostBackControl(exportToExcelButton); }
                if (exportToExcelButton != null) { ScriptManager.GetCurrent(Page).RegisterPostBackControl(exportToPdfButton); }
                string excelButtonID = ((Button)(e.Item as GridCommandItem).FindControl("ExportToExcelButton")).ClientID.ToString();
                string pdfButtonID = ((Button)(e.Item as GridCommandItem).FindControl("ExportToPdfButton")).ClientID.ToString();
                string pageName = "Patient List";
                ((Button)(e.Item as GridCommandItem).FindControl("ExportToExcelButton")).Attributes.Add("onclick", "return ConfirmDownload(" + excelButtonID + ",'" + pageName + "')");
                ((Button)(e.Item as GridCommandItem).FindControl("ExportToPdfButton")).Attributes.Add("onclick", "return ConfirmDownload(" + pdfButtonID + ",'" + pageName + "')");
            }

            if (e.Item is GridDataItem)
            {
                LinkButton editLink = (LinkButton)e.Item.FindControl("EditPatientLinkButton");
                if (e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatusId"] != null)
                {
                    int OptOffStat = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatusId"]);
                    if (OptOffStat == 1)
                    {
                        editLink.Enabled = false;
                    }
                }
            }
        }

        /// <summary>
        /// Formatting cells for export data in excel file format
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">Excel Export Cell Formatting event argument</param>
        protected void PatientGrid_ExcelExportCellFormatting(object sender, ExcelExportCellFormattingEventArgs e)
        {
            GridHeaderItem headerItem = (GridHeaderItem)PatientListGrid.MasterTableView.GetItems(GridItemType.Header)[0];
            foreach (TableCell cell in headerItem.Cells)
            {
                cell.Style["border"] = "thin solid black";
                cell.Style["background-color"] = "#cccccc";
            }

            GridDataItem item = e.Cell.Parent as GridDataItem;
            foreach (TableCell cell in item.Cells)
            {
                cell.Style["border"] = "thin solid black";
                cell.Style["text-align"] = "left";
            }
        }

        /// <summary>
        /// Redirecting to Add Patient screen
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">event argument</param>
        protected void AddPatientClicked(object sender, EventArgs e)
        {
            SessionData sessionData = GetDefaultSessionData();
            sessionData.PatientURNNumber = UrnNumber.Text;
            sessionData.PatientFamilyName = FamilyName.Text;
            sessionData.PatientGivenName = GivenName.Text;
            sessionData.PatientMedicare = MedicareNumber.Text;
            sessionData.PatientDVN = DvaNumber.Text;
            sessionData.PatientNHI = NhiNumber.Text;
            sessionData.PatientCountry = Country.SelectedValue;
            sessionData.PatientDateOfBirth = BirthDate.SelectedDate;
            sessionData.PatientId = 0;
            sessionData.PatientSiteId = 0;
            SaveSessionData(sessionData);
            Response.Redirect(Properties.Resource.PatientPagePath, false);
        }
        #endregion
    }
}