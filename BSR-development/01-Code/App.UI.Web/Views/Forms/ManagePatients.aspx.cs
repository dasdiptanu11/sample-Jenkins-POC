using App.Business;
using App.UI.Web.Views.Shared;
using System;
using System.Collections.Generic;

namespace App.UI.Web.Views.Forms
{
    public partial class ManagePatients : BasePage
    {
        /// <summary>
        /// Gets or Sets Page Index in View State
        /// </summary>
        public int PageIndex
        {
            get { return ViewState["pageIndex"] != null ? (int)ViewState["pageIndex"] : 1; }
            set { ViewState["pageIndex"] = value; }
        }

        /// <summary>
        /// Gets or sets Total Records in View State
        /// </summary>
        public int TotalRecords
        {
            get { return ViewState["totalRecords"] != null ? (int)ViewState["totalRecords"] : 0; }
            set { ViewState["totalRecords"] = value; }
        }

        /// <summary>
        /// Loading Patients data in Patient Merge Grid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void PatientMergeGrid_NeedDataSource(object sender, Telerik.Web.UI.RadListViewNeedDataSourceEventArgs e)
        {
            if (TotalRecords < PageIndex) { PageIndex = 1; }
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                var matchedPatientsPairs = patientRepository.PatientRepository.GetFirstMatchingPatientPair(PageIndex);
                MergePatientErrorMessages.Items.Clear();
                if (matchedPatientsPairs != null)
                {
                    ButtonsPanel.Visible = true;
                    MergePatientErrorMessages.Items.Add("Patients can not be merged due to below reasons:");
                    bool Patient1HasPrimary = (new List<PatientOperationListItem>(patientRepository.OperationRepository.GetPrimaryOperationDetailsForPatientID(matchedPatientsPairs.PatientId1))).Count != 0;
                    bool Patient2HasPrimary = (new List<PatientOperationListItem>(patientRepository.OperationRepository.GetPrimaryOperationDetailsForPatientID(matchedPatientsPairs.PatientId2))).Count != 0;

                    bool Patient1IsOptedOff = patientRepository.tbl_PatientRepository.GetByID(matchedPatientsPairs.PatientId1).OptOffStatId == 1 || patientRepository.tbl_PatientRepository.GetByID(matchedPatientsPairs.PatientId1).OptOffStatId == 2;
                    bool Patient2IsOptedOff = patientRepository.tbl_PatientRepository.GetByID(matchedPatientsPairs.PatientId2).OptOffStatId == 1 || patientRepository.tbl_PatientRepository.GetByID(matchedPatientsPairs.PatientId2).OptOffStatId == 2;

                    if (Patient1HasPrimary && Patient2HasPrimary)
                        MergePatientErrorMessages.Items.Add("Both patients have primary operations");

                    if (Patient1IsOptedOff || Patient2IsOptedOff)
                        MergePatientErrorMessages.Items.Add("Either Original or Matched user is opted off");

                    if (patientRepository.OperationRepository.IsRevisionOperationOnSameDate(matchedPatientsPairs.PatientId1, matchedPatientsPairs.PatientId2))
                        MergePatientErrorMessages.Items.Add("Operation is on the same date (not both primary)");

                    if (patientRepository.OperationRepository.IsPrimaryOptAndRevOptMatch(matchedPatientsPairs.PatientId1, matchedPatientsPairs.PatientId2))
                        MergePatientErrorMessages.Items.Add("Match Patient's primary operation date is after Revision operation date of original patient");

                    if (patientRepository.OperationRepository.IsPrimaryOptAfterRevOpt(matchedPatientsPairs.PatientId1, matchedPatientsPairs.PatientId2))
                        MergePatientErrorMessages.Items.Add("Original Patient's Primary Operation is after Revision operation date of Match patient.");

                    if (matchedPatientsPairs.PriSite1 == matchedPatientsPairs.PriSite2 )
                        if(patientRepository.OperationRepository.IsURNDifferentWithSameHospital(matchedPatientsPairs.PatientId1, matchedPatientsPairs.PatientId2, matchedPatientsPairs.PriSite2))
                        MergePatientErrorMessages.Items.Add("Same hospital but different URN has been observed");

                    if (MergePatientErrorMessages.Items.Count > 1)
                    {
                        MergePatientButton.Enabled = false;
                    }
                    else
                    {
                        MergePatientErrorMessages.Items.Clear();
                        MergePatientButton.Enabled = true;
                    }
                    var list = new List<MatchedPatientPairsListItem> { matchedPatientsPairs };
                    PatientMergeGrid.DataSource = list;
                    TotalPatientRecords.Text = matchedPatientsPairs.NoOfMatchingPatients1.ToString();
                    TotalRecords = matchedPatientsPairs.NoOfMatchingPatients1;
                    NextAndPreviousButtonsVisibility();
                }
                else
                {
                    ButtonsPanel.Visible = false;
                    TotalPatientRecords.Text = "0";
                    MergePatientErrorMessages.Items.Clear();
                    TotalRecords = 0;
                }
            }
        }

        #region "Merging patients"
        /// <summary>
        /// Gets Operation Type Id from the type of operation
        /// </summary>
        /// <param name="operationType">Operation Type</param>
        /// <returns>Returns Operation Type Id</returns>
        public int GetOpertionTypeId(object operationType)
        {
            int operationTypeID = -1;
            if (operationType == null)
            {
                operationTypeID = -1;
            }
            else if (operationType.ToString().ToUpper() == Constants.OPERATION_TYPE_PRIMARY.ToUpper())
            {
                operationTypeID = Constants.OPERATION_TYPEID_PRIMARY;
            }
            else
            {
                operationTypeID = Constants.OPTYPEID_REVISION;
            }

            return operationTypeID;
        }

        /// <summary>
        /// Change Operation Type from Primary Operation to Revision Operation
        /// </summary>
        /// <param name="operation"></param>
        public void ChangePrimaryToRevision(ref tbl_PatientOperation operation)
        {
            try
            {
                //Changing revision status
                operation.OpStat = Constants.OPTYPEID_REVISION;
                //Assigning PrimaryType value to revision type field
                operation.OpRevType = operation.OpType;
                //Added to transfer the other
                operation.OthRevType = operation.OthPriType;
                //Removing Primary values
                operation.OpType = null;
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "PatientMergeValidationGroup");
            }
        }
        #endregion "Merging patients"

        /// <summary>
        /// Merge Button clicked
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void MergePatientClicked(object sender, EventArgs e)
        {
            try
            {

                int DestinationPatientID = (int)PatientMergeGrid.DataKeyValues[0]["PatientId1"];
                int SourcePatientID = (int)PatientMergeGrid.DataKeyValues[0]["PatientId2"];

                //Move the Operations, FollowUps and URNs of the Matched Patient
                PatientHandler.MovePatientOperations(SourcePatientID, DestinationPatientID);

                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    //Retrieve the Destination (Master) Patient details
                    tbl_Patient primaryPatientDemo = patientRepository.tbl_PatientRepository.GetByID(DestinationPatientID);

                    if (GetOperationsCount(DestinationPatientID, true) > 0)
                    {
                        //If patient has primary
                        primaryPatientDemo.Legacy = 0;
                    }
                    else if (GetOperationsCount(DestinationPatientID, false) > 0)
                    {
                        //If patient has revision
                        primaryPatientDemo.Legacy = 1;
                    }
                    else
                    {
                        primaryPatientDemo.Legacy = null;
                    }

                    patientRepository.tbl_PatientRepository.Update(primaryPatientDemo);
                    patientRepository.Save();

                    //Decrease totalRecords by 1 as after merging total number of matching patients pairs decrease by one
                    TotalRecords = TotalRecords - 1;
                    PatientMergeGrid.Rebind();
                }
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "PatientMergeValidationGroup");
            }
        }

        // Get all operations list for a patient
        private int GetOperationsCount(int patientId, bool isPrimary)
        {
            int count = 0;
            using (UnitOfWork operationRepository = new UnitOfWork())
            {
                IEnumerable<PatientOperationListItem> patientOperationsList = operationRepository.OperationRepository.GetOperationDetailsForPatientID(patientId, string.Empty);
                if (isPrimary)
                {
                    foreach (PatientOperationListItem patientOperation in patientOperationsList)
                    {
                        if (patientOperation.OperationStat == 0) { count++; }
                    }
                }
                else
                {
                    foreach (PatientOperationListItem patientOperation in patientOperationsList)
                    {
                        if (patientOperation.OperationStat == 1) { count++; }
                    }
                }
            }

            return count;
        }

        /// <summary>
        /// Ignore Patient Clicked
        /// </summary>
        /// <param name="sender">Ignore Patient button as sender</param>
        /// <param name="e">Event Arguments</param>
        protected void IgnorePatientClicked(object sender, EventArgs e)
        {
            int primaryPatientId = (int)PatientMergeGrid.DataKeyValues[0]["PatientId1"];
            int secondaryPatientId = (int)PatientMergeGrid.DataKeyValues[0]["PatientId2"];

            tbl_IgnorePatients ignorePatient = new tbl_IgnorePatients();

            if (primaryPatientId < secondaryPatientId)
            {
                ignorePatient.PatID1 = primaryPatientId;
                ignorePatient.PatID2 = secondaryPatientId;
            }
            else
            {
                ignorePatient.PatID1 = secondaryPatientId;
                ignorePatient.PatID2 = primaryPatientId;
            }

            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                patientRepository.tbl_IgnorePatientsRepository.Insert(ignorePatient);
                patientRepository.Save();
            }

            if (PageIndex == TotalRecords && PageIndex != 0) { PageIndex = PageIndex - 1; }
            PatientMergeGrid.Rebind();
        }

        /// <summary>
        /// Getting Previous Page Records 
        /// </summary>
        /// <param name="sender">Previous Records button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void PreviousRecordsClicked(object sender, EventArgs e)
        {
            if (PageIndex > 1) { PageIndex = PageIndex - 1; }
            PatientMergeGrid.Rebind();
        }

        /// <summary>
        /// Getting Next Page Records
        /// </summary>
        /// <param name="sender">Next Records button as sender</param>
        /// <param name="e">Event argument</param>
        protected void NextRecordsClicked(object sender, EventArgs e)
        {
            if (PageIndex < TotalRecords) { PageIndex = PageIndex + 1; }
            PatientMergeGrid.Rebind();
        }

        // Set Visibility for the next records and previous records button
        private void NextAndPreviousButtonsVisibility()
        {
            if (TotalRecords <= 1)
            {
                NextRecordsButton.Visible = false;
                PreviousRecordsButon.Visible = false;
            }
            else
            {
                if (PageIndex == 1)
                {
                    NextRecordsButton.Visible = true;
                    PreviousRecordsButon.Visible = false;
                }
                else if (PageIndex == TotalRecords)
                {
                    NextRecordsButton.Visible = false;
                    PreviousRecordsButon.Visible = true;
                }
                else
                {
                    PreviousRecordsButon.Visible = true;
                    NextRecordsButton.Visible = true;
                }
            }
        }
    }
}