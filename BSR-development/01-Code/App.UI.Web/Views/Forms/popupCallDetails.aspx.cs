using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.Business;
using App.UI.Web.Views.Shared;

namespace App.UI.Web.Views.Forms {
    public partial class popupCallDetails : BasePage {
        /// <summary>
        /// Initializes page controls
        /// </summary>
        /// <param name="sender">sender of the event</param>
        /// <param name="e">Event Arguments</param>
        protected void Page_Load(object sender, EventArgs e) {
            if (!IsPostBack) {
                LoadLookupControls();
                LoadFollowUpDetails();
            }
        }

        // Loading Lookup selection values from database
        private void LoadLookupControls() {
            using (UnitOfWork lookupRepository = new UnitOfWork()) {
                Helper.BindCollectionToControl(CallResultSelection, lookupRepository.Get_tlkp_FollowUpCallResult(false).Where<LookupItem>(x => !x.Id.Equals("4")), "Id", "Description");
            }
        }

        // Loading selected Followup Call related details
        private void LoadFollowUpDetails() {
            SessionData sessionData = GetSessionData();
            int followUpId = sessionData.FollowUpId;
            int followUpCallId = sessionData.PatientFollowUpCallId;
            string followUpCall = sessionData.PatientFollowUpCall;
            int callResult = sessionData.CallResultId;

            FollowUpId.Value = followUpId.ToString();
            FollowUpCallId.Value = followUpCallId.ToString();
            FollowUpCallDetails.Value = followUpCall;

            if (callResult != -1 && callResult != 0 && callResult != 5) {
                CallResultSelection.SelectedValue = callResult.ToString();
                ClearButton.Visible = true;
            }
        }

        /// <summary>
        /// Save Button click event handler
        /// </summary>
        /// <param name="sender">Sender of the Click Event</param>
        /// <param name="e">Event Arguments</param>
        protected void SaveButton_Click(object sender, EventArgs e) {
            if (Page.IsValid) {
                using (UnitOfWork followupRepository = new UnitOfWork()) {
                    bool isCallDetailsAvailable = true;
                    bool isFollowUpCallAvailable = true;
                    bool isLastCallNotAnswered = false;
                    SessionData sessionData = GetSessionData();
                    int followUpId = sessionData.FollowUpId;
                    int followUpCallId = sessionData.PatientFollowUpCallId;
                    string followUpCallDetails = sessionData.PatientFollowUpCall;

                    tbl_FollowUpCall followUpCall = null;
                    if (followUpCallId != 0) {
                        followUpCall = followupRepository.tbl_FollowUpCallRepository.Get(x => x.Id == followUpCallId).FirstOrDefault();
                    }

                    if (followUpCall == null) {
                        isFollowUpCallAvailable = false;
                        followUpCall = new tbl_FollowUpCall();
                    }

                    followUpCall.FollowUpId = followUpId;
                    switch (followUpCallDetails.ToLower()) {
                        case "call1":
                            followUpCall.CallOne = Convert.ToInt32(CallResultSelection.SelectedValue);
                            break;

                        case "call2":
                            followUpCall.CallTwo = Convert.ToInt32(CallResultSelection.SelectedValue);
                            break;

                        case "call3":
                            followUpCall.CallThree = Convert.ToInt32(CallResultSelection.SelectedValue);
                            break;

                        case "call4":
                            followUpCall.CallFour = Convert.ToInt32(CallResultSelection.SelectedValue);
                            break;

                        case "call5":
                            followUpCall.CallFive = Convert.ToInt32(CallResultSelection.SelectedValue);
                            if (followUpCall.CallFive == 1) {
                                isLastCallNotAnswered = true;
                            }
                            break;

                        default:
                            isCallDetailsAvailable = false;
                            break;
                    }

                    if (isCallDetailsAvailable) {
                        followUpCall.LastUpdatedBy = UserName;
                        followUpCall.LastUpdatedDateTime = DateTime.Now;

                        // Resetting AssignedTo column as this call has been recorded
                        followUpCall.AssignedTo = -1;

                        if (isFollowUpCallAvailable) {
                            followupRepository.tbl_FollowUpCallRepository.Update(followUpCall);
                        } else {
                            followupRepository.tbl_FollowUpCallRepository.Insert(followUpCall);
                        }

                        followupRepository.Save();

                        string note = FollowUpNote.Text;
                        tbl_FollowUp followUp = followupRepository.FollowUpRepository.GetByID(followUpId);
                        if (followUp != null && !string.IsNullOrEmpty(note)) {
                            followUp.Othinfo = note;

                            followupRepository.FollowUpRepository.Update(followUp);
                            followupRepository.Save();
                        }
                    }

                    if (isLastCallNotAnswered) {
                        sessionData.IsFollowupAllCallAttempted = true;
                        SaveSessionData(sessionData);

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "myScript", "CloseWindow('FollowUp.aspx?LoadFUP=" + sessionData.FollowUpId + "');", true);
                    } else {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "myScript", "CloseWindow('refresh');", true);
                    }
                }
            }
        }

        /// <summary>
        /// Clear Button click event handler
        /// </summary>
        /// <param name="sender">Sender of the Click Event</param>
        /// <param name="e">Event Arguments</param>
        protected void ClearButton_Click(object sender, EventArgs e) {
            using (UnitOfWork followupRepository = new UnitOfWork()) {
                SessionData sessionData = GetSessionData();
                int followUpId = sessionData.FollowUpId;
                int followUpCallId = sessionData.PatientFollowUpCallId;
                string followUpCallDetails = sessionData.PatientFollowUpCall;

                tbl_FollowUpCall followUpCall = null;
                if (followUpCallId != 0) {
                    followUpCall = followupRepository.tbl_FollowUpCallRepository.Get(x => x.Id == followUpCallId).FirstOrDefault();
                }

                if (followUpCall == null) {
                    // FollowUp Call Details is not available to update
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "myScript", "CloseWindow('refresh');", true);
                }

                followUpCall.FollowUpId = followUpId;
                switch (followUpCallDetails.ToLower()) {
                    case "call1":
                        followUpCall.CallOne = 0;
                        break;

                    case "call2":
                        followUpCall.CallTwo = 0;
                        break;

                    case "call3":
                        followUpCall.CallThree = 0;
                        break;

                    case "call4":
                        followUpCall.CallFour = 0;
                        break;

                    case "call5":
                        followUpCall.CallFive = 0;
                        break;
                }

                followUpCall.LastUpdatedBy = UserName;
                followUpCall.LastUpdatedDateTime = DateTime.Now;

                // Resetting AssignedTo column as this call has been recorded
                followUpCall.AssignedTo = -1;

                followupRepository.tbl_FollowUpCallRepository.Update(followUpCall);
                followupRepository.Save();

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "myScript", "CloseWindow('refresh');", true);
            }
        }
    }
}