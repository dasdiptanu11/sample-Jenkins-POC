using App.Business;
using App.UI.Web.Views.Shared;
using System;
using System.ComponentModel;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace App.UI.Web.Views.Forms {
    public partial class PatientCallScreen : BasePage {
        /// <summary>
        /// Initializes page controls
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">Event Arguments</param>
        protected void Page_Load(object sender, EventArgs e) {
            if (!IsPostBack) {
                LoadLookupControls();
                LoadFilteredData();
            }
        }

        #region Page Search

        /// <summary>
        /// Selection Change event handler for Country Radio buttons
        /// </summary>
        /// <param name="sender">Sender of the event</param>
        /// <param name="e">Event Arguments</param>
        protected void CountrySelectionChanged(object sender, EventArgs e) {
            if (CountrySelectionList.SelectedValue == Constants.COUNTRY_CODE_FOR_NEWZEALAND.ToString()) {
                StateSelectionList.Enabled = false;
            } else {
                StateSelectionList.Enabled = true;
            }
        }

        // Loading Lookup selection values from database
        private void LoadLookupControls() {
            using (UnitOfWork lookupRepository = new UnitOfWork()) {
                // Loading Lookup values in the selection controls on the UI
                Helper.BindCollectionToControl(CountrySelectionList, lookupRepository.Get_tlkp_Country(false), "Id", "Description");
                var listStates = lookupRepository.Get_tlkp_State(false);
                // Adding All options in state selection options
                listStates.Insert(0, new LookupItem() { Id = "-1", Description = "All" });
                Helper.BindCollectionToControl(StateSelectionList, listStates, "Id", "Description");

                int countryId = Constants.COUNTRY_CODE_FOR_AUSTRALIA;
                int stateId = -1;
                SessionData sessionData = GetDefaultSessionData();
                if (sessionData != null) {
                    countryId = sessionData.PatientCallScreenSelectedCountry;
                    stateId = sessionData.PatientCallScreenSelectedStateId;

                    // Resetting it to false so that it won't be redirected on this page, once it is redirected back
                    sessionData.IsRedirectedFromCallScreen = false;
                    SaveSessionData(sessionData);
                }

                // Selecting Default values for the selection controls
                CountrySelectionList.SelectedValue = countryId.ToString();
                StateSelectionList.SelectedValue = stateId.ToString();
            }
        }

        // Loading default fitered data as per the previous state
        private void LoadFilteredData() {
            SessionData sessionData = GetDefaultSessionData();
            if (sessionData != null) {
                string patientIdFilterValue = sessionData.PatientCallScreenPatientId == 0 ? string.Empty : sessionData.PatientCallScreenPatientId.ToString();
                if (!string.IsNullOrEmpty(patientIdFilterValue)) {
                    GridColumn editPatientColumn = CallScreenWorkListGrid.MasterTableView.GetColumnSafe("EditPatient");
                    editPatientColumn.CurrentFilterValue = patientIdFilterValue;
                }

                string familyNameFilterValue = sessionData.PatientCallScreenFamilyName;
                if (!string.IsNullOrEmpty(familyNameFilterValue)) {
                    GridColumn familyNameColumn = CallScreenWorkListGrid.MasterTableView.GetColumnSafe("FamilyName");
                    familyNameColumn.CurrentFilterValue = familyNameFilterValue;
                }

                string givenNameFilterValue = sessionData.PatientCallScreenGivenName;
                if (!string.IsNullOrEmpty(givenNameFilterValue)) {
                    GridColumn givenNameColumn = CallScreenWorkListGrid.MasterTableView.GetColumnSafe("GivenName");
                    givenNameColumn.CurrentFilterValue = givenNameFilterValue;
                }

                string phoneFilterValue = sessionData.PatientCallScreenPhone;
                if (!string.IsNullOrEmpty(phoneFilterValue)) {
                    GridColumn mobileColumn = CallScreenWorkListGrid.MasterTableView.GetColumnSafe("Phone");
                    mobileColumn.CurrentFilterValue = phoneFilterValue;
                }

                string noteFilterValue = sessionData.PatientCallScreenNote;
                if (!string.IsNullOrEmpty(noteFilterValue)) {
                    GridColumn followUpNoteColumn = CallScreenWorkListGrid.MasterTableView.GetColumnSafe("FollowUpNotes");
                    followUpNoteColumn.CurrentFilterValue = noteFilterValue;
                }

                string filterQuery = GetDataFilterQuery(patientIdFilterValue, familyNameFilterValue, givenNameFilterValue, phoneFilterValue, noteFilterValue);
                if (!string.IsNullOrEmpty(filterQuery)) {
                    CallScreenWorkListGrid.MasterTableView.FilterExpression = filterQuery;
                }
            }
        }

        /// <summary>
        /// Search Button click event handler
        /// </summary>
        /// <param name="sender">Sender of the event</param>
        /// <param name="e">Event Arguments</param>
        protected void SearchButtonClicked(object sender, EventArgs e) {
            CallScreenWorkListGrid.Rebind();
        }

        /// <summary>
        /// Clear button click event handler
        /// </summary>
        /// <param name="sender">Sender of the Event</param>
        /// <param name="e">Event Argument</param>
        protected void ClearButtonClicked(object sender, EventArgs e) {
            // Selecting Default values for the selection controls
            CountrySelectionList.SelectedValue = Constants.COUNTRY_CODE_FOR_AUSTRALIA.ToString();
            StateSelectionList.SelectedIndex = 0;
            CallScreenWorkListGrid.Rebind();
        }
        #endregion

        /// <summary>
        /// Responsible to load data in the Call worklist grid
        /// </summary>
        /// <param name="sender">Sender of the event</param>
        /// <param name="e">Grid Need Data Source event handler</param>
        protected void CallScreenWorkListGrid_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e) {
            int countryId = string.IsNullOrEmpty(CountrySelectionList.SelectedValue) ? 1 : Convert.ToInt16(CountrySelectionList.SelectedValue);
            int stateId = string.IsNullOrEmpty(StateSelectionList.SelectedValue.Trim()) ? -1 : Convert.ToInt16(StateSelectionList.SelectedValue);
            int userId = GetLoggedInUserId(User.Identity.Name);

            CallScreenWorkListGrid.ExportSettings.FileName = "PatientCallWorkList" + DateTime.Now.Ticks.ToString();
            using (UnitOfWork followUpRepository = new UnitOfWork()) {
                CallScreenWorkListGrid.DataSource = new BindingList<PatientCallListItem>(followUpRepository.FollowUpRepository.GetPatientCallWorkList(countryId, stateId, userId).ToList());
            }
        }

        /// <summary>
        /// Item Command event handler for the Call Worklist Grid
        /// </summary>
        /// <param name="sender">Sender of th Grid</param>
        /// <param name="e">Grid Command event argument</param>
        protected void CallScreenWorkListGrid_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e) {
            try {
                if (e.CommandName.Equals("EditPatient", StringComparison.OrdinalIgnoreCase) ||
                    e.CommandName.Equals("EditFollowup", StringComparison.OrdinalIgnoreCase)) {
                    // Saving Patient, Followup, Site and Filter related details in Session Data to persist
                    SessionData sessionData = GetSessionData();
                    sessionData.ResetPatientData();
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.FollowUpId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FollowUpId"]);
                    sessionData.SiteId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["SiteId"]);
                    sessionData.IsRedirectedFromCallScreen = true;
                    sessionData.PatientCallScreenSelectedCountry = Convert.ToInt16(CountrySelectionList.SelectedValue);
                    sessionData.PatientCallScreenSelectedStateId = Convert.ToInt16(StateSelectionList.SelectedValue);
                    SaveSessionData(sessionData);

                    switch (e.CommandName) {
                        case "EditPatient":
                            Response.Redirect(Properties.Resource2.PatientDemographicScreen, false);
                            break;

                        case "EditFollowup":
                            Response.Redirect(Properties.Resource2.FollowUp + "?LoadFUP=" + sessionData.FollowUpId, false);
                            break;

                        default:
                            break;
                    }
                }

                if (e.CommandName == RadGrid.FilterCommandName) {
                    e.Canceled = true;

                    TextBox patientIdFilter = (e.Item as GridFilteringItem)["EditPatient"].Controls[0] as TextBox;
                    TextBox familyNameFilter = (e.Item as GridFilteringItem)["FamilyName"].Controls[0] as TextBox;
                    TextBox givenNameFilter = (e.Item as GridFilteringItem)["GivenName"].Controls[0] as TextBox;
                    TextBox phoneFilter = (e.Item as GridFilteringItem)["Phone"].Controls[0] as TextBox;
                    TextBox noteFilter = (e.Item as GridFilteringItem)["FollowUpNotes"].Controls[0] as TextBox;

                    string patientIdFilterValue = patientIdFilter.Text;
                    string familyNameFilterValue = familyNameFilter.Text;
                    string givenNameFilterValue = givenNameFilter.Text;
                    string phoneFilterValue = phoneFilter.Text;
                    string noteFilterValue = noteFilter.Text;

                    // Getting data filter query
                    string filterQuery = GetDataFilterQuery(patientIdFilterValue, familyNameFilterValue, givenNameFilterValue, phoneFilterValue, noteFilterValue);
                    CallScreenWorkListGrid.MasterTableView.FilterExpression = filterQuery;
                    CallScreenWorkListGrid.Rebind();
                }
            } catch (Exception ex) {
                throw;
            }
        }

        /// <summary>
        /// Data Bound event handler of the Call Worklist grid
        /// </summary>
        /// <param name="sender">Sender of the event</param>
        /// <param name="e">Grid Item event argument</param>
        protected void CallScreenWorkListGrid_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e) {
            if (e.Item is GridDataItem) {
                GridDataItem row = e.Item as GridDataItem;

                bool isClickable = true;
                bool isVisible = true;
                bool isAssigned = false;

                using (RadButton callButton = (e.Item as GridDataItem).FindControl("AssignCall") as RadButton) {
                    int assignedTo = int.Parse(row["AssignedTo"].Text);
                    int userId = GetLoggedInUserId(User.Identity.Name);

                    ////Get the icon for the button
                    if (assignedTo == -1) {
                        callButton.SetSelectedToggleStateByText("Assignable");
                    } else if (assignedTo == userId) {
                        callButton.SetSelectedToggleStateByText("AssignedToMe");
                        isAssigned = true;
                    } else if (assignedTo != userId) {
                        isClickable = false;
                        isVisible = false;
                    }
                    callButton.Enabled = isClickable;
                    callButton.Visible = isVisible;
                    (e.Item as GridDataItem).FindControl("AssignedToOther").Visible = !isVisible;

                }

                for (int loopcount = 1; loopcount <= 5; loopcount++) {
                    SetCallIcons(row, loopcount, isAssigned);
                }

                string followUpPeriod = row["FollowUpPeriod"] == null ? string.Empty : row["FollowUpPeriod"].Text;
                if (!followUpPeriod.Equals("periop", StringComparison.OrdinalIgnoreCase)) {
                    //Get the date for the current row
                    //string stringOperationDate = row["OperationDate"] == null ? string.Empty : row["OperationDate"].Text;

                    string stringOperationDate = row["OperationDate"].Text;


                    if (!string.IsNullOrEmpty(stringOperationDate)) {

                        //Convert the operation date to a datetime for easier manipulation
                        DateTime operationDate = DateTime.MinValue;

                        if (DateTime.TryParseExact(stringOperationDate,"dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out operationDate)) {
                            //Check to make sure that the followup is a yearly one
                            if (followUpPeriod.ToLowerInvariant().EndsWith("yr")) {

                                //Convert the followup to an integer, then calculate the window months based on it
                                int followUpYear = int.Parse(followUpPeriod.ToLowerInvariant().Replace("yr", string.Empty));
                                int minMonth = (12 * (followUpYear - 1)) + 3;
                                int maxMonth = (12 * followUpYear) + 3;

                                //Set the colours for the background
                                Color OutColour = Color.FromArgb(254, 193, 15);
                                Color InColour = Color.FromArgb(148, 202, 83);

                                //Check where todays date sits in relation to the window
                                bool afterMin = DateTime.Compare(DateTime.Now, operationDate.AddMonths(minMonth)) >= 0;
                                bool beforeMax = DateTime.Compare(DateTime.Now, operationDate.AddMonths(maxMonth)) <= 0;

                                //Set the colour based on where the date sits in the window
                                if (afterMin && beforeMax) {
                                    //Inside the window
                                    row["FollowUpDetails"].BackColor = InColour;
                                } else {
                                    //outside the window
                                    row["FollowUpDetails"].BackColor = OutColour;
                                }
                            }
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Getting Image path as per the Call Status of the Followup Call
        /// </summary>
        /// <param name="value">Followup Call Result Id</param>
        /// <param name="isClickable">Flag indicating whether an item is clickable</param>
        /// <returns>Returns Image URL as per the Call Status value passed in parameter</returns>
        /// <summary>
        public string GetImageUrl(string value, out bool isClickable, out bool isVisible) {
            string imageUrl = string.Empty;

            isClickable = false;
            isVisible = true;

            switch (value) {
                case "-1":
                    //New call
                    imageUrl = "~/Images/ico-phone.gif";
                    isClickable = true;
                    break;
                case "1":
                    //No Answer
                    imageUrl = "~/Images/ico-no_answer.gif";
                    break;
                case "2":
                    //Call back requested
                    imageUrl = "~/Images/ico-call_back.gif";
                    break;
                case "3":
                    //Wrong Number
                    imageUrl = "~/Images/ico-wrong_number.gif";
                    break;
                case "4":
                    //This is for call having been answered
                    imageUrl = "~/Images/ico-answered.gif";
                    break;
                case "-99":
                    //This call is assigned to someone else
                    imageUrl = "~/Images/ico-assigned.gif";
                    break;
                case "-100":
                    //This call is assigned to someone else
                    imageUrl = "";
                    break;
                default:
                    //Unknown value, so don't display anything
                    imageUrl = "";
                    isVisible = false;
                    break;
            }

            return imageUrl;
        }

#region Call Assignment
       
        protected void AssignClicked(Object sender, CommandEventArgs e) {
            bool isEnabled = true;
            int userId = GetLoggedInUserId(User.Identity.Name);

            RadButton assignButton = (RadButton)sender;
            GridDataItem gridRow = (GridDataItem)assignButton.NamingContainer;

            TableCell assignedToGridCell = gridRow["AssignedTo"];
            TableCell followUpCell = gridRow["FollowUpId"];
            TableCell followUpCallCell = gridRow["FollowUpCallDetailsId"];

            int FollowUpId = Convert.ToInt32(followUpCell.Text);
            int CallId = Convert.ToInt32(followUpCallCell.Text);
            
            int assignedTo = int.Parse(assignedToGridCell.Text);

            if (assignedTo == -1) {
                assignButton.SetSelectedToggleStateByText("AssignedToMe");
                assignedTo = AssignCallToUser(FollowUpId,CallId , userId, gridRow);
                assignedToGridCell.Text = assignedTo.ToString();
                followUpCallCell = gridRow["FollowUpCallDetailsId"];
            } else if (assignedTo == userId) {
                assignButton.SetSelectedToggleStateByText("Assignable");
                assignedTo = AssignCallToUser(FollowUpId, CallId, userId, gridRow);
                assignedToGridCell.Text = assignedTo.ToString();
            } else if (assignedTo != userId) {
                assignButton.SetSelectedToggleStateByText("AssignedToOther");
                isEnabled = false;
            }
            assignButton.Enabled = isEnabled;

            for (int loopcount = 1; loopcount <= 5; loopcount++) {
                SetCallIcons(gridRow, loopcount, (assignedTo == userId));
            }
        }

        /// <summary>
        /// Set the assignment of a call to either: Unassigned or currentuser, unless it is assigned to another user already
        /// </summary>
        /// <param name="followUpId"></param>
        /// <param name="followUpCallId"></param>
        /// <param name="userId"></param>
        /// <param name="gridRow"></param>
        /// <returns>The id of the user the call is assigned to</returns>
        private int AssignCallToUser(int followUpId, int followUpCallId, int userId, GridDataItem gridRow) {
            using (UnitOfWork followUpRepository = new UnitOfWork()) {
                bool isNewFollowUpCall = false;
                tbl_FollowUpCall followUpCall = null;

                if (followUpId != 0) {
                    //Retieve the followup call details based on the id
                    followUpCall = followUpRepository.tbl_FollowUpCallRepository.Get(x => x.FollowUpId == followUpId).FirstOrDefault();
                }

                //If there is no information create a new follow up
                if (followUpCall == null) {
                    isNewFollowUpCall = true;
                    followUpCall = new tbl_FollowUpCall();
                } else {
                    //Immediately check to see if the call is assigned to someone else. If it is return that user id
                    if (followUpCall.AssignedTo != null && followUpCall.AssignedTo != -1 && followUpCall.AssignedTo != userId) {
                        return (int)followUpCall.AssignedTo;
                    }
                }

                followUpCall.FollowUpId = followUpId;

                //If the user is already assigned, then flip it
                if (followUpCall.AssignedTo == userId) {
                    followUpCall.AssignedTo = -1;
                } else {
                    followUpCall.AssignedTo = userId;
                }

                followUpCall.LastUpdatedBy = UserName;
                followUpCall.LastUpdatedDateTime = System.DateTime.Now;

                if (isNewFollowUpCall) {
                    followUpRepository.tbl_FollowUpCallRepository.Insert(followUpCall);
                } else {
                    followUpRepository.tbl_FollowUpCallRepository.Update(followUpCall);
                }

                followUpRepository.Save();

                //If the followup call is new, then we need to assign the id to the grid
                if (isNewFollowUpCall) {
                    followUpCall = followUpRepository.tbl_FollowUpCallRepository.Get(x => x.FollowUpId == followUpId).FirstOrDefault();
                    gridRow["FollowUpCallDetailsId"].Text = followUpCall.Id.ToString();
                }

                return (int)followUpCall.AssignedTo;
            }
        }

#endregion

        /// <summary>
        /// FollowUp Call button clicked
        /// </summary>
        /// <param name="sender">Sender of the event</param>
        /// <param name="e">Event Arguments</param>
        protected void EditCall(object sender, CommandEventArgs e) {

            RadButton callButton = (RadButton)sender;
            string callCommand = callButton.CommandName;

            GridDataItem gridRow = (GridDataItem)callButton.NamingContainer;

            int userId = GetLoggedInUserId(User.Identity.Name);
            TableCell assignedToGridCell = gridRow["AssignedTo"];
            TableCell patientCell = gridRow["PatientId"];
            TableCell followUpCell = gridRow["FollowUpId"];
            TableCell followUpCallCell = gridRow["FollowUpCallDetailsId"];
            int assignedTo = int.Parse(assignedToGridCell.Text);

            //If it is assigned to the current user, hit the dialog right away
            if (assignedTo == userId) {
                // Saving Call related details in Session
                TableCell callResultCell = gridRow[callCommand + callButton.CommandArgument];
                string callResult = callResultCell.Text;

                SessionData sessionData = GetSessionData();
                sessionData.IsRedirectedFromCallScreen = true;
                sessionData.PatientCallScreenSelectedCountry = Convert.ToInt32(CountrySelectionList.SelectedValue);
                sessionData.PatientCallScreenSelectedStateId = Convert.ToInt32(StateSelectionList.SelectedValue);
                sessionData.PatientId = Convert.ToInt32(patientCell.Text);
                sessionData.FollowUpId = Convert.ToInt32(followUpCell.Text);
                sessionData.PatientFollowUpCallId = Convert.ToInt32(followUpCallCell.Text);
                sessionData.PatientFollowUpCall = callCommand + callButton.CommandArgument;
                sessionData.CallResultId = Convert.ToInt32(callResult);
                SaveSessionData(sessionData);

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "myScript", "genericPopup('popupCallDetails.aspx','500','350','Register Call')", true);
            }

        }

        // Setting Call details on the grid Call buttons
        private void SetCallIcons(GridDataItem row, int CallNumber, bool isAssigned) {
            //Get the last entered call for this followup
            int lastConfirmedCall = string.IsNullOrEmpty(row["LastConfirmedCall"].Text) || row["LastConfirmedCall"].Text.Equals("&nbsp;",StringComparison.InvariantCultureIgnoreCase) ? 0 : int.Parse(row["LastConfirmedCall"].Text);
            bool isClickable = false;
            bool isVisible = true;

            //Identify the control to edit
            RadButton callButton = row.FindControl("FollowUpCall" + CallNumber) as RadButton;

            var callResult = row["Call" + CallNumber] == null ? string.Empty : row["Call" + CallNumber].Text;

            //Get the image for the button
            if (CallNumber == lastConfirmedCall + 1) {
                callButton.Image.ImageUrl = GetImageUrl("-1", out isClickable, out isVisible);
                isVisible = isAssigned;
            } else {
                callButton.Image.ImageUrl = GetImageUrl(callResult, out isClickable, out isVisible);
            }

            //Check to see if this is the confirmed last call
            if (lastConfirmedCall == CallNumber) {
                isClickable = isAssigned;
            }

            callButton.Enabled = isClickable;
            callButton.Visible = isVisible;

            //Change the cursor based on whether you can click it or not
            if (isClickable) {
                callButton.Style.Add(HtmlTextWriterStyle.Cursor, "pointer");
            } else {
                callButton.Style.Add(HtmlTextWriterStyle.Cursor, "default");
            }
        }

        #region Filter

        // creating Data Filter Query for Patient Call Worklist
        private string GetDataFilterQuery(string patientIdFilterValue, string familyNameFilterValue, string givenNameFilterValue, string phoneFilterValue, string noteFilterValue) {
            string filterQuery = string.Empty;
            if (!string.IsNullOrEmpty(patientIdFilterValue)) {
                filterQuery += "([PatientId] = " + patientIdFilterValue + ")";
            }

            if (!string.IsNullOrEmpty(familyNameFilterValue)) {
                filterQuery += string.IsNullOrEmpty(filterQuery) ? string.Empty : " AND ";
                filterQuery += "([FamilyName] LIKE \'%" + familyNameFilterValue + "%\')";
            }

            if (!string.IsNullOrEmpty(givenNameFilterValue)) {
                filterQuery += string.IsNullOrEmpty(filterQuery) ? string.Empty : " AND ";
                filterQuery += "([GivenName] LIKE \'%" + givenNameFilterValue + "%\')";
            }

            if (!string.IsNullOrEmpty(phoneFilterValue)) {
                filterQuery += string.IsNullOrEmpty(filterQuery) ? string.Empty : " AND ";
                filterQuery += "(([HomePhone] LIKE \'%" + phoneFilterValue + "%\') OR ([Mobile] LIKE \'%" + phoneFilterValue + "%\'))";
            }

            if (!string.IsNullOrEmpty(noteFilterValue)) {
                filterQuery += string.IsNullOrEmpty(filterQuery) ? string.Empty : " AND ";
                filterQuery += "([FollowUpNotes] LIKE \'%" + noteFilterValue + "%\')";
            }

            SaveFilterData(patientIdFilterValue, familyNameFilterValue, givenNameFilterValue, phoneFilterValue, noteFilterValue);
            return filterQuery;
        }

        // Saving Filter values in session data to persist the values
        private void SaveFilterData(string patientIdFilterValue, string familyNameFilterValue, string givenNameFilterValue, string phoneFilterValue, string noteFilterValue) {
            SessionData sessionData = GetSessionData();
            sessionData.PatientCallScreenPatientId = String.IsNullOrEmpty(patientIdFilterValue) ? 0 : Convert.ToInt32(patientIdFilterValue);
            sessionData.PatientCallScreenFamilyName = familyNameFilterValue;
            sessionData.PatientCallScreenGivenName = givenNameFilterValue;
            sessionData.PatientCallScreenPhone = phoneFilterValue;
            sessionData.PatientCallScreenNote = noteFilterValue;

            SaveSessionData(sessionData);
        }
        #endregion
    }
}