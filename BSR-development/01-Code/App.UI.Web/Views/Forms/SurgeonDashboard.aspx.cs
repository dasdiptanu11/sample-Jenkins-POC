using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.UI.Web.Views.Shared;
using Telerik.Web.UI;
using App.Business;
using eis = Telerik.Web.UI.ExportInfrastructure;

namespace App.UI.Web.Views.Forms
{
    public partial class SurgeonHome : BasePage
    {
        /// <summary>
        /// Initialize controls on the page and also load initial data for the controls
        /// </summary>
        /// <param name="sender">Surgeon Dashboard page as sender</param>
        /// <param name="e">event arguments</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLookup();
                RecreateForm();
                TotalOptOffPanel.Visible = false;
            }

            TurnTextBoxAutoCompleteOff();
            if (IsPostBack)
            {
                /* If search is not pressed - recreate labels & followUp radio buttons; 
                 * reCreate not required on search since "search click" does it automatically*/
                if (string.IsNullOrEmpty(Request.Form[SearchButton.UniqueID]))
                {
                    CreateRadioButton();
                    CreateLabels();
                }
            }
        }

        #region "Clearing fields and setting visiblity of labels/buttons"
        /// <summary>
        /// Clearing controls and session data
        /// </summary>
        protected void Clear()
        {
            SessionData sessionData = new SessionData();
            SaveSessionData(sessionData);
            PatientSiteId.SelectedIndex = 0;
            PatientURN.Text = string.Empty;
            GivenName.Text = string.Empty;
            FamilyName.Text = string.Empty;
            ShowAndHideButtonsForNewSearch();
            PrimaryOperationDetailsLabel.Text = string.Empty;
            ErrorFollowUpLabel.Text = string.Empty;
            ErrorRevisionOperationLabel.Text = string.Empty;
            ErrorPrimaryOperationLabel.Text = string.Empty;
        }

        /// <summary>
        /// Clearing search related controls before new search session
        /// </summary>
        protected void ClearBeforeSearch()
        {
            PatientSearch.Visible = false;
            AddPatientButton.Visible = false;
            PatientsExistPanel.Visible = false;
            PrimaryOperationDetailsLabel.Text = string.Empty;
            ErrorFollowUpLabel.Text = string.Empty;
            ErrorRevisionOperationLabel.Text = string.Empty;
            ErrorPrimaryOperationLabel.Text = string.Empty;
            TotalOptOffPanel.Visible = false;
        }

        /// <summary>
        /// Show and hide buttons for search new search session
        /// </summary>
        public void ShowAndHideButtonsForNewSearch()
        {
            PatientSearch.Visible = false;
            AddPatientButton.Visible = false;
            PatientsExistPanel.Visible = false;
            PatientListPanel.Visible = false;
            PatientURN.Focus();
        }

        /// <summary>
        /// Show and hide buttons for Patient not found
        /// </summary>
        public void ShowAndHideButtonsForPatientNotFound()
        {
            PatientSearch.Text = "No matching patient record found";
            PatientSearch.CssClass = "failureNotification";
            PatientSearch.Visible = true;
            AddPatientButton.Visible = true;
            PatientsExistPanel.Visible = false;
            PatientListPanel.Visible = false;
            AddPatientButton.Focus();
        }

        /// <summary>
        /// Show and hide buttons for patient found
        /// </summary>
        public void ShowAndHideButtonsForPatientFound()
        {
            PatientSearch.Text = "Matching patient record found";
            PatientSearch.CssClass = "successNotification";
            PatientSearch.Visible = true;
            AddPatientButton.Visible = false;
            PatientListPanel.Visible = true;
            PatientSearchErrorMessages.Items.Clear();
        }

        #endregion "Clearing fields and setting visiblity of labels/buttons"

        /// <summary>
        /// Load lookup controls options from database
        /// </summary>
        public void LoadLookup()
        {
            using (UnitOfWork lookupRepository = new UnitOfWork())
            {
                string userName = UserName;
                PatientSiteId.Items.Clear();
                Helper.BindCollectionToControl(PatientSiteId, lookupRepository.Get_HospitalList(userName, -1, false, false), "Id", "Description");
                PatientSiteId.DataBind();
            }
        }

        /// <summary>
        /// Setting Value for Site drop down control
        /// </summary>
        /// <param name="siteID">Selected Site Id</param>
        public void SetTextForGivenSiteID(int? siteID)
        {
            if (siteID > 0)
            {
                ListItem listItem = PatientSiteId.Items.FindByValue(siteID.ToString());
                if (listItem != null)
                {
                    PatientSiteId.SelectedValue = listItem.Value;
                }
            }
        }

        /// <summary>
        /// Get URN number of the Patient
        /// </summary>
        /// <param name="patientID">Patient Id</param>
        /// <param name="siteID">Site Id</param>
        /// <returns>returns Patient URN number</returns>
        public string GetURN(int patientID, int siteID)
        {
            string patientUrn = string.Empty;
            using (UnitOfWork patientURNRepository = new UnitOfWork())
            {
                tbl_URN patientURNNumberRecord = patientURNRepository.tbl_URNRepository.Get(x => x.PatientID == patientID && x.HospitalID == siteID).FirstOrDefault();
                if (patientURNNumberRecord != null)
                {
                    patientUrn = patientURNNumberRecord.URNo;
                }
            }
            return patientUrn;
        }

        /// <summary>
        /// Recreate form for new Search Session
        /// </summary>
        public void RecreateForm()
        {
            SessionData sessionData = GetDefaultSessionData();
            int patientId = -1;
            int siteID = -1;
            if (sessionData == null)
            {
                Clear();
            }
            else
            {
                patientId = sessionData.PatientId;
                siteID = sessionData.SiteId;
                PatientURN.Text = sessionData.PatientURN;
                FamilyName.Text = sessionData.PatientFamilyName;
                GivenName.Text = sessionData.PatientGivenName;
                if (patientId < 1)
                {
                    Clear();
                }
                else
                {
                    SetTextForGivenSiteID(siteID);
                    if (patientId > 0)
                    {
                        PatientDetailsGrid.Rebind();
                        PatientsExistPanel.Visible = false;
                        //  PatientFound(patientId);
                    }
                    else
                    {
                        ShowAndHideButtonsForPatientNotFound();
                    }
                }
            }
        }

        /// <summary>
        /// Load Patients data as per the search criteria in the Patient Grid
        /// </summary>
        protected void PatientGrid_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
        {
            LoadGrid();
        }

        // Fetch list of patients from database satisfying search criteria and show list of patients
        private void LoadGrid()
        {
            //Parameters for exact match
            string patientUrnNumber = PatientURN.Text;
            int patientSiteID = Convert.ToInt32(PatientSiteId.SelectedItem.Value);

            //Parameters for like match
            string givenName = GivenName.Text;
            string familyName = FamilyName.Text;

            int count = 0;
            IEnumerable<PatientSearchListItem> PatientList = null;
            SessionData sessionData = GetSessionData();

            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                int surgeonId = -1;

                if (IsSurgeon)
                {
                    surgeonId = Convert.ToInt32(patientRepository.OperationRepository.GetSurgeonId(UserName));
                }

                if (!string.IsNullOrEmpty(patientUrnNumber))
                {
                    PatientList = patientRepository.PatientRepository.GetPatientsListWithExactDetails(UserName, patientSiteID, patientUrnNumber, surgeonId);
                }

                if ((PatientList == null || PatientList.Count() < 1) &&
                    (!string.IsNullOrEmpty(givenName) || !string.IsNullOrEmpty(familyName)))
                {
                    PatientList = patientRepository.PatientRepository.GetPatientsListForGivenDetails(UserName, givenName, familyName, surgeonId, patientSiteID);
                }
            }

            // Patients data list found with the search term provided, bind the patient list to the patient grid
            if (PatientList != null)
            {
                count = PatientList.Count();
                if (count > 0)
                {
                    PatientDetailsGrid.DataSource = PatientList;
                    sessionData.PatientURN = PatientURN.Text;
                    sessionData.PatientURNNumber = PatientURN.Text;
                    sessionData.SiteId = Convert.ToInt32(PatientSiteId.SelectedItem.Value);
                    sessionData.PatientFamilyName = FamilyName.Text;
                    sessionData.PatientGivenName = GivenName.Text;
                    ShowAndHideButtonsForPatientFound();
                }
                else
                {
                    PatientDetailsGrid.DataSource = "";
                    sessionData = new SessionData();
                    ShowAndHideButtonsForPatientNotFound();
                }
            }
            else
            {
                sessionData = new SessionData();
                ShowAndHideButtonsForPatientNotFound();
            }
            SaveSessionData(sessionData);
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
                        sessionData = GetDefaultSessionData();
                        sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                        sessionData.PatientURN = PatientURN.Text;
                        sessionData.SiteId = Convert.ToInt32(PatientSiteId.SelectedItem.Value);
                        sessionData.PatientSiteId = -1;
                        sessionData.PatientFamilyName = FamilyName.Text;
                        sessionData.PatientGivenName = GivenName.Text;
                        SaveSessionData(sessionData);
                        Response.Redirect(Properties.Resource.PatientPagePath, false);
                        break;

                    case "ShowPatient":
                        PatientsExistPanel.Visible = true;
                        sessionData = GetDefaultSessionData();
                        sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                        sessionData.PatientURN = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["URN"].ToString();
                        sessionData.PatientURNNumber = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["URN"].ToString();
                        sessionData.SiteId = Convert.ToInt32(PatientSiteId.SelectedItem.Value);
                        sessionData.PatientSiteId = -1;
                        sessionData.PatientFamilyName = FamilyName.Text;
                        sessionData.PatientGivenName = GivenName.Text;
                        SaveSessionData(sessionData);
                        sessionData = GetSessionData();
                        sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                        sessionData.PatientURN = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["URN"].ToString();
                        sessionData.PatientURNNumber = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["URN"].ToString();
                        sessionData.SiteId = Convert.ToInt32(PatientSiteId.SelectedItem.Value);
                        sessionData.PatientSiteId = -1;
                        sessionData.PatientFamilyName = FamilyName.Text;
                        sessionData.PatientGivenName = GivenName.Text;
                        SaveSessionData(sessionData);
                        PatientFound(Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]));
                        break;

                    case "RowClick":
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
            for (int ColumnCount = 0; ColumnCount < PatientDetailsGrid.Columns.Count; ColumnCount++)
            {
                PatientDetailsGrid.Columns[ColumnCount].CurrentFilterFunction = Telerik.Web.UI.GridKnownFunction.StartsWith;
            }
        }

        /// <summary>
        /// Formatting Grid cells
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">Grid Item event argument</param>
        protected void PatientGrid_ItemCreated(object sender, GridItemEventArgs e)
        {
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
        /// Search Patient URN details
        /// </summary>
        /// <param name="sender">Search button as sender</param>
        /// <param name="e">Event arguments</param>
        protected void SearchClicked(object sender, EventArgs e)
        {
            SessionData sessionData = GetSessionData();
            int hospitalID = Convert.ToInt32(PatientSiteId.SelectedItem.Value);
            int selectedItems = 0;
            ClearBeforeSearch();

            selectedItems = !String.IsNullOrEmpty(GivenName.Text) ? selectedItems + 1 : selectedItems;
            selectedItems = !String.IsNullOrEmpty(FamilyName.Text) ? selectedItems + 1 : selectedItems;

            if ((PatientSiteId.SelectedItem.Text != "" && !string.IsNullOrEmpty(PatientURN.Text)) || (selectedItems >= 1))
            {
                PatientSearchErrorMessages.Items.Clear();
                PatientDetailsGrid.Rebind();
            }
            else
            {
                PatientSearchErrorMessages.Items.Add("Please enter 'Exact Match' conditions or one from 'Like Match' conditions to begin search");
            }
        }

        /// <summary>
        /// Getting Patient details when patient URN number is found
        /// </summary>
        /// <param name="patientId">Patient Id</param>
        protected void PatientFound(int patientId)
        {
            tbl_Patient patient;
            int? patientOptOffStatus = null;
            IEnumerable<tbl_PatientOperation> patientOperations;
            tbl_PatientOperation patientPrimaryOperation;
            IEnumerable<tbl_PatientOperation> patientRevisionOperations;

            PrimaryOperationDetailsLabel.Text = string.Empty;
            string gender = string.Empty;
            ShowAndHideButtonsForPatientFound();

            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                //Getting patient details
                patient = patientRepository.tbl_PatientRepository.Get(x => x.PatId == patientId, null, "tlkp_Gender").FirstOrDefault();
                patientOptOffStatus = patientRepository.tbl_PatientRepository.Get(x => x.PatId == patientId).Select(y => y.OptOffStatId).FirstOrDefault();
            }

            //If patient details found
            if (patient != null)
            {
                //Setting details in patient ribbon
                gender = (patient).GenderId == null ? string.Empty : patient.tlkp_Gender.Description;

                if (patientOptOffStatus != 1)
                {
                    //Getting patient operations
                    using (UnitOfWork patientOperationRepository = new UnitOfWork())
                    {
                        patientOperations = null;
                        patientOperations = patientOperationRepository
                            .tbl_PatientOperationRepository.Get(x => x.PatientId == patientId && (x.ProcAban == null || x.ProcAban == false));
                    }

                    //If patient has recorded operations
                    if (patientOperations != null)
                    {
                        //Getting primary operations
                        patientPrimaryOperation = null;
                        patientPrimaryOperation = patientOperations.Where(x => x.OpStat == 0).FirstOrDefault();
                        //Getting revisions 
                        patientRevisionOperations = null;
                        patientRevisionOperations = patientOperations.Where(x => x.OpStat != 0).OrderByDescending(x => x.OpDate);
                        if (patientPrimaryOperation != null)
                        {
                            AddPrimaryOperationButton.Visible = false;
                            HelpImage3.Visible = false;
                            PrimaryOperationDetailsLabel.Text = string.Format("{0:dd/MM/yyyy}", patientPrimaryOperation.OpDate);
                            AddRevisionOperationButton.Focus();
                        }
                        else
                        {
                            //Primary is null but revision is present
                            if (patientRevisionOperations != null && patientRevisionOperations.Count() > 0)
                            { AddPrimaryOperationButton.Visible = false; HelpImage3.Visible = false; }
                            else
                            { AddPrimaryOperationButton.Visible = true; HelpImage3.Visible = true; }
                            PrimaryOperationDetailsLabel.Text = "None Recorded";
                            AddPatientButton.Focus();
                        }

                        //FollowUps needed only if operation(s) exist(s)
                        if (patientOperations.Count() > 0)
                        {
                            RevisionOperationGrid.DataSource = null;
                            RevisionOperationGrid.DataBind();
                            RevisionOperationGrid.DataSource = patientRevisionOperations;
                            RevisionOperationGrid.DataBind();
                            FollowupGrid.Rebind();
                            CreateRadioButton();
                            CreateLabels();
                        }
                        else
                        {
                            AddFollowupButton.Visible = false;
                            HelpImage5.Visible = false;
                            Label labelRevision = new Label();
                            labelRevision.Text = "None Recorded";
                            RevisionOperationPanel.Controls.Add(labelRevision);
                        }
                    }
                    //If total opt off
                    TotalOptOffPanel.Visible = false;
                }
                else
                {
                    //If total opt off
                    PatientsExistPanel.Visible = false;
                    TotalOptOffPanel.Visible = true;
                }
            }
        }

        #region "Button clicks"
        /// <summary>
        /// Clearing controls for new search session
        /// </summary>
        /// <param name="sender">Clear button as sender</param>
        /// <param name="e">Event argument</param>
        protected void ClearClicked(object sender, EventArgs e)
        {
            Clear();
        }

        /// <summary>
        /// Redirecting to add patient page
        /// </summary>
        /// <param name="sender">Add Patient button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void AddPatientClicked(object sender, EventArgs e)
        {
            SessionData sessionData = GetDefaultSessionData();
            sessionData.PatientURN = PatientURN.Text;
            sessionData.PatientURNNumber = PatientURN.Text;
            sessionData.PatientId = 0;
            sessionData.PatientGivenName = GivenName.Text;
            sessionData.PatientFamilyName = FamilyName.Text;
            sessionData.SiteId = Convert.ToInt32(PatientSiteId.SelectedItem.Value);
            sessionData.PatientSiteId = Convert.ToInt32(PatientSiteId.SelectedItem.Value);
            SaveSessionData(sessionData);
            Response.Redirect(Properties.Resource.PatientPagePath, false);
        }

        /// <summary>
        /// Redirecting to Add Operation page
        /// </summary>
        /// <param name="sender">Add Primary Operation button as sender</param>
        /// <param name="e">Event Arguments</param>
        protected void AddPrimaryOperationClicked(object sender, EventArgs e)
        {
            SessionData sessionData = GetDefaultSessionData();
            sessionData.OperationType = Constants.ADD_PRIMARY;
            sessionData.PatientURN = PatientURN.Text;
            sessionData.SiteId = Convert.ToInt32(PatientSiteId.SelectedItem.Value);
            sessionData.PatientGivenName = GivenName.Text;
            sessionData.PatientFamilyName = FamilyName.Text;
            SaveSessionData(sessionData);
            Response.Redirect(Properties.Resource2.OperationDetailsPath, false);
        }

        /// <summary>
        /// Redirecting to Add Operation Page
        /// </summary>
        /// <param name="sender">Add Operation button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void AddRevisionOperationClicked(object sender, EventArgs e)
        {
            SessionData sessionData = GetDefaultSessionData();
            sessionData.OperationType = Constants.ADD_REVISION;
            sessionData.PatientURN = PatientURN.Text;
            sessionData.SiteId = Convert.ToInt32(PatientSiteId.SelectedItem.Value);
            sessionData.PatientGivenName = GivenName.Text;
            sessionData.PatientFamilyName = FamilyName.Text;
            SaveSessionData(sessionData);
            Response.Redirect(Properties.Resource2.OperationDetailsPath, false);
        }

        /// <summary>
        /// Redirecting to add Follow up screen
        /// </summary>
        /// <param name="sender">Followup button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void AddFollowupClicked(object sender, EventArgs e)
        {
            int radioButtonSelected = -1;
            SessionData sessionData = GetSessionData();
            foreach (Control radioButton in FollowupPanel.Controls)
            {
                //radioButton.GetType 
                if (radioButton.ToString() != "System.Web.UI.LiteralControl")
                {
                    RadioButton checkedradioButton = (RadioButton)radioButton;
                    if (checkedradioButton != null)
                    {
                        if (checkedradioButton.Checked == true)
                        {
                            int positionofDash = -1;
                            radioButtonSelected = 1;
                            positionofDash = checkedradioButton.ID.ToString().IndexOf("-");
                            sessionData.PatientOperationId = Convert.ToInt32(checkedradioButton.ID.ToString().Substring(0, positionofDash));
                            sessionData.FollowUpPeriodId = Convert.ToInt32(checkedradioButton.ID.ToString().Substring(positionofDash + 1));
                            sessionData.IsSurgeonDashboardToReturn = true;

                            SaveSessionData(sessionData);
                        }
                    }
                }
            }

            if (radioButtonSelected == 1)
            {
                Response.Redirect(Properties.Resource.FollowUpPagePath + "?LoadFUP=1", false);
            }
            else
            {
                ErrorFollowUpLabel.Text = "Select follow Up to proceed";
            }
        }
        #endregion "Button clicks"

        /// <summary>
        /// Creating Dynamic Radio button for Operation Follow ups
        /// </summary>
        public void CreateRadioButton()
        {
            AddFollowupButton.Visible = false;
            HelpImage5.Visible = false;
            //Don't redo if panel not visible at all
            if (FollowupPanel.Visible == true)
            {
                //Removing controls from FollowUp
                foreach (Control radioButton in FollowupPanel.Controls)
                {
                    FollowupPanel.Controls.Remove(radioButton);
                }

                if (FollowupGrid.MasterTableView.Items.Count > 0)
                {
                    foreach (GridDataItem followUp in FollowupGrid.MasterTableView.Items)
                    {
                        String operationDate = string.Format("{0:dd/MM/yyyy}", followUp["OperationDate"].Text);
                        String operationType = followUp["OperationType"].Text;
                        String operationID = followUp["OperationID"].Text;
                        String followUpID = followUp["FollowUpID"].Text;

                        ListItem item = new ListItem(operationDate + " - " + operationType, operationID + "-" + followUpID);
                        RadioButton button = new RadioButton();
                        button.ID = item.Value;
                        button.GroupName = "FollowUp";
                        button.Text = item.Text;
                        button.Checked = false;
                        button.AutoPostBack = false;
                        button.DataBind();
                        button.EnableViewState = true;
                        FollowupPanel.Controls.Add(button);
                        FollowupPanel.Controls.Add(new LiteralControl("<br />"));
                        AddFollowupButton.Visible = true;
                        HelpImage5.Visible = true;
                    }
                }
                else
                {
                    Label revisionLabel = new Label();
                    revisionLabel.Text = "None Due";
                    FollowupPanel.Controls.Add(revisionLabel);
                    AddFollowupButton.Visible = false;
                    HelpImage5.Visible = false;
                }
            }
        }

        /// <summary>
        /// Creating Dynamic Lables for Operation Follow ups
        /// </summary>
        public void CreateLabels()
        {
            //Don't redo if panel not visible at all
            if (RevisionOperationPanel.Visible == true)
            {
                //Removing controls from pnlRevisionOperation
                RevisionOperationPanel.Controls.Clear();

                if (RevisionOperationGrid.MasterTableView.Items.Count > 0)
                {
                    foreach (GridDataItem revisionOperation in RevisionOperationGrid.MasterTableView.Items)
                    {
                        Label labelRevision = new Label();
                        String OperationDate = string.Format("{0:dd/MM/yyyy}", revisionOperation["OpDate"].Text);
                        labelRevision.Text = OperationDate;
                        RevisionOperationPanel.Controls.Add(labelRevision);
                        RevisionOperationPanel.Controls.Add(new LiteralControl("<br />"));
                    }
                }
                else
                {
                    Label labelRevision = new Label();
                    labelRevision.Text = "None Recorded";
                    RevisionOperationPanel.Controls.Add(labelRevision);
                }
            }
        }

        /// <summary>
        /// Load Data for the Followup Grid
        /// </summary>
        /// <param name="sender">Followup grid as sender</param>
        /// <param name="e">Grid Need Data Source Event rgument</param>
        protected void FollowupGrid_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            SessionData sessionData = GetSessionData();
            int patientId = sessionData.PatientId;
            using (UnitOfWork operationRepository = new UnitOfWork())
            {
                int SurgeonId = IsSurgeon ? Convert.ToInt32(operationRepository.OperationRepository.GetSurgeonId(UserName)) : -1;
                FollowupGrid.DataSource = operationRepository.FollowUpRepository.GetPatientFollowUpDetails(UserName, SurgeonId, sessionData.SiteId, null, null, -1, patientId);
            }
        }

        /// <summary>
        /// Load data for Revision Operation grid
        /// </summary>
        /// <param name="sender">Opration grid as sender</param>
        /// <param name="e">Grid Need Data Source event argument</param>
        protected void RevisionOperationGrid_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            SessionData sessionData = GetSessionData();
            int patientId = sessionData.PatientId;
            using (UnitOfWork patientOperationRepository = new UnitOfWork())
            {
                FollowupGrid.DataSource = patientOperationRepository
                    .tbl_PatientOperationRepository
                    .Get(x => x.PatientId == patientId && (x.ProcAban == null || x.ProcAban == false) && x.OpStat != 0).OrderByDescending(x => x.OpDate);
            }
        }
    }
}