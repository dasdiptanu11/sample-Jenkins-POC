using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using App.UI.Web.Views.Shared;
using App.Business;
using CDMSValidationLogic;
using Telerik.Web.UI;

namespace App.UI.Web.Views.Forms
{
    public partial class ShowURN : BasePage
    {
        /// <summary>
        /// Page Load event handler for the page
        /// </summary>
        /// <param name="sender">Popup Show URN page as sender</param>
        /// <param name="e">Event Argument</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                WarningMessage.Text = string.Empty;
            }
        }

        /// <summary>
        /// Load data for the Patient URN grid
        /// </summary>
        /// <param name="sender">URN list grid as sender</param>
        /// <param name="e">Grid Need Data Source event argument</param>
        protected void PatientURNGrid_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            SessionData sessionData = GetSessionData();
            int patientId = sessionData.PatientId;

            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                IEnumerable<PatientURN> patientUrnList = patientRepository.PatientRepository.GetURN(patientId);
                PatientURNGrid.DataSource = patientUrnList;
            }
        }

        /// <summary>
        /// Delete Patient URN
        /// </summary>
        /// <param name="patientURNId">URN to be deleted</param>
        protected void DeletePatientURN(int patientURNId)
        {
            try
            {
                using (UnitOfWork urnRepository = new UnitOfWork())
                {
                    tbl_URN urnDetails = urnRepository.tbl_URNRepository.Get(x => x.URId == patientURNId).SingleOrDefault();
                    if (urnDetails != null)
                    {
                        tbl_Patient patient = urnRepository.tbl_PatientRepository.Get(x => x.PatId == urnDetails.PatientID).SingleOrDefault();
                        if (patient != null)
                        {
                            if (patient.PriSiteId != urnDetails.HospitalID)
                            {
                                if (urnRepository.PatientRepository.IsOperationExists(urnDetails.PatientID, urnDetails.URNo, urnDetails.HospitalID))
                                {
                                    WarningMessage.Text = "Operation(s) are associated with this URN, please delete them before you delete the URN.";
                                }
                                else
                                {
                                    urnRepository.tbl_URNRepository.Delete(urnDetails);
                                    urnRepository.Save();
                                }
                            }
                            else
                            {
                                WarningMessage.Text = "This is a primary site URN, Please modify the primary site of this patient to delete this URN";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "PatientDataValidationGroup");
            }
        }

        /// <summary>
        /// Handling grid commands - Delete URN
        /// </summary>
        /// <param name="sender">Patient URN List as sender</param>
        /// <param name="e">Grid Command event argument</param>
        protected void PatientURNGrid_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridEditableItem editedItem = e.Item as GridEditableItem;
            RadGrid patientUrnGrid = (RadGrid)sender;
            try
            {
                switch (e.CommandName)
                {
                    case "Delete":
                        if (e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["URId"] != null)
                        {
                            DeletePatientURN(Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["URId"].ToString()));
                            BindURNGrid();
                        }
                        break;
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// Load Patient URN grid with the data
        /// </summary>
        protected void BindURNGrid()
        {
            SessionData sessionData = GetSessionData();
            int patientId = sessionData.PatientId;
            if (patientId != 0 && patientId != -1)
            {
                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    IEnumerable<PatientURN> patientUrnList = patientRepository.PatientRepository.GetURN(patientId);
                    PatientURNGrid.DataSource = patientUrnList;
                    PatientURNGrid.DataBind();

                    if (patientUrnList.Count() == 0)
                    {
                        PatientURNGrid.Style.Add(HtmlTextWriterStyle.Display, "none");
                        URNNotFound.Style.Add(HtmlTextWriterStyle.Display, "block");
                    }
                    else
                    {
                        PatientURNGrid.Style.Add(HtmlTextWriterStyle.Display, "block");
                        URNNotFound.Style.Add(HtmlTextWriterStyle.Display, "none");
                    }
                }
            }
            else
            {
                PatientURNGrid.DataSource = null;
                PatientURNGrid.DataBind();
                PatientURNGrid.Style.Add(HtmlTextWriterStyle.Display, "none");
                URNNotFound.Style.Add(HtmlTextWriterStyle.Display, "block");
            }
        }
    }
}
