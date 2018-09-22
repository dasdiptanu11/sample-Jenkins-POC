using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using App.Business;
using App.UI.Web.Views.Shared;
using Telerik.Web.UI;
using System.Configuration;

namespace App.UI.Web.Views.Forms
{
    public partial class MissingDataWorkList : BasePage
    {
        // Flag to determine if export action has to been taken to export the data in pdf file
        private bool _isPdfExport = false;

        // Flag to determine if export action has been taken
        bool _isExport = false;

        #region PageAndLookupLoad
        /// <summary>
        /// Initializing controls on the page, with default values
        /// </summary>
        /// <param name="sender">Missing Data Work List page as sender</param>
        /// <param name="e">Event arguments</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            TurnTextBoxAutoCompleteOff();
            SurgeonAndSite.SetCountryForSites(true, 1);
            if (!IsPostBack)
            {
                SurgeonAndSite.AddEmptyItemInSurgeonList = false;
                SurgeonAndSite.AddEmptyItemInSiteList = false;
                OperationDateFrom.MaxDate = DateTime.Today;
                OperationDateTo.MaxDate = DateTime.Today;
                LoadLookup();
            }
        }

        // Loading Dropdown values/options from the database
        private void LoadLookup()
        {
            using (UnitOfWork loopupRepository = new UnitOfWork())
            {
                Helper.BindCollectionToControl(Country, loopupRepository.Get_tlkp_Country(false), "Id", "Description");
                Helper.BindCollectionToControl(OperationStatus, loopupRepository.Get_tlkp_OperationStatus(true), "Id", "Description");

                SessionData sessionData = GetDefaultSessionData();
                Country.SelectedValue = (sessionData.MissingDataWorkListCountryId == null || sessionData.MissingDataWorkListCountryId == 0)
                    ? Constants.COUNTRY_CODE_FOR_AUSTRALIA.ToString() : sessionData.MissingDataWorkListCountryId.ToString();


                if (sessionData.MissingDataWorkListSurgeonId != null && sessionData.MissingDataWorkListSurgeonId != 0)
                {
                    SurgeonAndSite.SetDefaultTextForGivenSurgeonID(sessionData.MissingDataWorkListSurgeonId);
                }

                if (sessionData.MissingDataWorkListSiteId != null && sessionData.MissingDataWorkListSiteId != 0)
                {
                    SurgeonAndSite.SetDefaultTextForGivenSiteID(sessionData.MissingDataWorkListSiteId);
                }

                if (sessionData.MissingDataWorkListPageSize != null && sessionData.MissingDataWorkListPageSize != 0)
                {
                    MissingDataWorkListGrid.PageSize = sessionData.MissingDataWorkListPageSize;
                }

                sessionData.IsSurgeonDashboardToReturn = false;
                SaveSessionData(sessionData);

                OperationStatus.DataBind();
                Country.DataBind();
            }
        }
        #endregion PageAndLookupLoad

        #region ButtonClicks
        /// <summary>
        /// Clearing filter applied on the Missing Data Worklist grid
        /// </summary>
        /// <param name="sender">Clear Filter button as sender</param>
        /// <param name="e">Event argument</param>
        protected void ClearFilter(object sender, EventArgs e)
        {
            SessionData sessionData = new SessionData();
            SaveSessionData(sessionData);
            MissingDataWorkListGrid.CurrentPageIndex = 0;
            ListItem selectedCountry = Country.Items.FindByValue(Constants.COUNTRY_CODE_FOR_AUSTRALIA.ToString());
            SurgeonAndSite.SetDefaultTextForGivenSiteIndex(-1);
            OperationDateFrom.SelectedDate = null;
            OperationDateTo.SelectedDate = null;
            ErrorMessage.Text = string.Empty;
            Country.SelectedValue = Constants.COUNTRY_CODE_FOR_AUSTRALIA.ToString();
            Country.Items.FindByValue(Constants.COUNTRY_CODE_FOR_AUSTRALIA.ToString()).Selected = true;
            OperationStatus.SelectedIndex = -1;
            Country.DataBind();
            MissingDataWorkListGrid.Rebind();
        }

        /// <summary>
        /// Applying filter on the data shown on Missing Worklist grid
        /// </summary>
        /// <param name="sender">Search button as sender</param>
        /// <param name="e">Event Arguments</param>
        protected void ApplyFilter(object sender, EventArgs e)
        {
            ErrorMessage.Text = string.Empty;
            if (SurgeonAndSite.GetSelectedItemFromSiteList() != null || SurgeonAndSite.GetSelectedItemFromSurgeonList() != null
                || OperationDateFrom.SelectedDate != null || OperationDateTo.SelectedDate != null)
            {
                int siteID = SurgeonAndSite.GetSelectedIdFromSiteList() == 0 ? -1 : SurgeonAndSite.GetSelectedIdFromSiteList();
                int countryID = Convert.ToInt16(Country.SelectedItem.Value);
                int surgeonId = -1;

                Boolean isAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN));
                Boolean isAdminCentral = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
                Boolean isSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));
                Boolean isDataCollector = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_DATACOLLECTOR));
                if (isAdmin || isAdminCentral || isDataCollector)
                {
                    surgeonId = SurgeonAndSite.GetSelectedIdFromSurgeonList();
                }
                else if (isSurgeon)
                {
                    //If surgeon Logged in
                    surgeonId = GetLoggedInUserId(User.Identity.Name);
                }

                SessionData sessionData = GetDefaultSessionData();
                sessionData.MissingDataWorkListPageSize = MissingDataWorkListGrid.PageSize;
                sessionData.MissingDataWorkListCountryId = countryID;
                sessionData.MissingDataWorkListSiteId = siteID;
                sessionData.MissingDataWorkListSurgeonId = surgeonId;
                sessionData.IsSurgeonDashboardToReturn = false;
                SaveSessionData(sessionData);

                MissingDataWorkListGrid.CurrentPageIndex = 0;
                MissingDataWorkListGrid.Rebind();
            }
            else
            {
                ErrorMessage.Text = "Please enter at least one condition to search";
            }
        }

        #endregion ButtonClicks

        #region LoadingGrid
        /// <summary>
        /// Getting data for the Missing worklist grid
        /// </summary>
        /// <param name="sender">Missing Data Work List as sender</param>
        /// <param name="e">Grid Need Data Source event argument</param>
        protected void MissingDataWorkListGrid_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            int pageSize = MissingDataWorkListGrid.PageSize;
            Boolean isAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN));
            Boolean isAdminCentral = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
            Boolean isSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));
            Boolean isDataCollector = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_DATACOLLECTOR));
            //No surgeon exists with this Id
            int surgeonId = -99;

            if (isAdmin || isAdminCentral || isDataCollector)
            {
                if (SurgeonAndSite.GetSelectedIdFromSurgeonList() == -1 || SurgeonAndSite.GetSelectedIdFromSurgeonList() == 0)
                {
                    //Use the AdminId
                    surgeonId = GetLoggedInUserId(User.Identity.Name);
                }
                else
                {
                    //If Admin selects a surgeon from dropdown list - get the surgeonid
                    surgeonId = SurgeonAndSite.GetSelectedIdFromSurgeonList();
                }
            }
            else if (isSurgeon)
            {
                //If surgeon Logged in
                surgeonId = GetLoggedInUserId(User.Identity.Name);
            }

            int siteID = SurgeonAndSite.GetSelectedIdFromSiteList() == 0 ? -1 : SurgeonAndSite.GetSelectedIdFromSiteList();
            int countryID = Convert.ToInt16(Country.SelectedItem.Value);
            int operationStatusId = OperationStatus.SelectedItem.Value == null || OperationStatus.SelectedItem.Value == string.Empty
                                        ? -1 : Convert.ToInt16(OperationStatus.SelectedItem.Value);

            SessionData sessionData = GetDefaultSessionData();
            countryID = (sessionData.MissingDataWorkListCountryId == null || sessionData.MissingDataWorkListCountryId == 0)
                ? countryID : sessionData.MissingDataWorkListCountryId;
            siteID = (sessionData.MissingDataWorkListSiteId == null || sessionData.MissingDataWorkListSiteId == 0)
                ? siteID : sessionData.MissingDataWorkListSiteId;
            surgeonId = (sessionData.MissingDataWorkListSurgeonId == null || sessionData.MissingDataWorkListSurgeonId == 0)
                ? surgeonId : sessionData.MissingDataWorkListSurgeonId;
            pageSize = (sessionData.MissingDataWorkListPageSize == null || sessionData.MissingDataWorkListPageSize == 0)
                ? pageSize : sessionData.MissingDataWorkListPageSize;

            MissingDataWorkListGrid.ExportSettings.FileName = "MissingDataList" + DateTime.Now.ToString();
            using (UnitOfWork followUpRepository = new UnitOfWork())
            {
                MissingDataWorkListGrid.DataSource = followUpRepository.FollowUpRepository.GetMissingDataWorkList(
                                                                            countryID,
                                                                            surgeonId,
                                                                            siteID,
                                                                            OperationDateFrom.SelectedDate,
                                                                            OperationDateTo.SelectedDate,
                                                                            operationStatusId,
                                                                            (isAdminCentral || isAdmin));
            }
        }

        /// <summary>
        /// Event handler for the Page Size selection changed in Missing Data worklist grid
        /// </summary>
        /// <param name="source">Missing Data Work List grid as source</param>
        /// <param name="e">Grid Command event argument</param>
        protected void MissingDataWorkListGrid_PageSizeChanged(object source, GridPageSizeChangedEventArgs e)
        {
            SessionData sessionData = GetDefaultSessionData();
            sessionData.MissingDataWorkListPageSize = e.NewPageSize;
            sessionData.IsSurgeonDashboardToReturn = false;
            SaveSessionData(sessionData);
        }
        
        #endregion LoadingGrid

        #region GridCommands
        /// <summary>
        /// Managing columns display in the Missing Data worklist grid
        /// </summary>
        /// <param name="sender">Missing Data Work List grid as sender</param>
        /// <param name="e">Grid Command event argument</param>
        protected void MissingDataWorkListGrid_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            _isPdfExport = false;
            RadGrid missingDataWorkListGrid = (RadGrid)sender;
            SessionData sessionData = GetSessionData();
            switch (e.CommandName)
            {
                case RadGrid.ExportToExcelCommandName:
                    _isExport = true;
                    missingDataWorkListGrid.ExportSettings.OpenInNewWindow = true;
                    missingDataWorkListGrid.ExportSettings.ExportOnlyData = true;
                    missingDataWorkListGrid.ExportSettings.IgnorePaging = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("PatientId").HeaderStyle.Width = Unit.Pixel(80);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("FamilyName").HeaderStyle.Width = Unit.Pixel(90);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("GivenName").HeaderStyle.Width = Unit.Pixel(90);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Site").HeaderStyle.Width = Unit.Pixel(100);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Surgeon").HeaderStyle.Width = Unit.Pixel(100);

                    MissingDataWorkListGrid.MasterTableView.GetColumn("Day30FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr1FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr2FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr3FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr4FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr5FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr6FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr7FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr8FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr9FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr10FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("SiteId").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgOpFormCompleted_").Visible = false;

                    MissingDataWorkListGrid.MasterTableView.GetColumn("OpFormCompleted").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Day30FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr1FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr2FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr3FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr4FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr5FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr6FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr7FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr8FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr9FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr10FU").Display = true;

                    MissingDataWorkListGrid.MasterTableView.GetColumn("OpFormCompleted").HeaderStyle.Width = Unit.Pixel(80);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Day30FU").HeaderStyle.Width = Unit.Pixel(80);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr1FU").HeaderStyle.Width = Unit.Pixel(80);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr2FU").HeaderStyle.Width = Unit.Pixel(80);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr3FU").HeaderStyle.Width = Unit.Pixel(80);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr4FU").HeaderStyle.Width = Unit.Pixel(80);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr5FU").HeaderStyle.Width = Unit.Pixel(80);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr6FU").HeaderStyle.Width = Unit.Pixel(80);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr7FU").HeaderStyle.Width = Unit.Pixel(80);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr8FU").HeaderStyle.Width = Unit.Pixel(80);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr9FU").HeaderStyle.Width = Unit.Pixel(80);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr10FU").HeaderStyle.Width = Unit.Pixel(80);
                    break;

                case RadGrid.ExportToPdfCommandName:
                    MissingDataWorkListGrid.MasterTableView.AllowFilteringByColumn = true;
                    if (!MissingDataWorkListGrid.ExportSettings.IgnorePaging)
                    {
                        MissingDataWorkListGrid.Rebind();
                    }

                    _isPdfExport = true;
                    MissingDataWorkListGrid.MasterTableView.Style["font-size"] = "8pt";
                    MissingDataWorkListGrid.MasterTableView.GetColumn("PatientId").HeaderStyle.Width = Unit.Pixel(30);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("UR_No").HeaderStyle.Width = Unit.Pixel(40);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("FamilyName").HeaderStyle.Width = Unit.Pixel(70);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("GivenName").HeaderStyle.Width = Unit.Pixel(70);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Site").HeaderStyle.Width = Unit.Pixel(70);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Surgeon").HeaderStyle.Width = Unit.Pixel(70);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("OperationDate").HeaderStyle.Width = Unit.Pixel(50);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Gender").HeaderStyle.Width = Unit.Pixel(50);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Day30FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr1FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr2FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr3FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr4FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr5FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr6FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr7FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr8FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr9FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgYr10FU_").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("SiteId").Visible = false;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("imgOpFormCompleted_").Visible = false;

                    MissingDataWorkListGrid.MasterTableView.GetColumn("OpFormCompleted").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Day30FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr1FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr2FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr3FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr4FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr5FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr6FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr7FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr8FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr9FU").Display = true;
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr10FU").Display = true;

                    MissingDataWorkListGrid.MasterTableView.GetColumn("OpFormCompleted").HeaderStyle.Width = Unit.Pixel(40);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Day30FU").HeaderStyle.Width = Unit.Pixel(40);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr1FU").HeaderStyle.Width = Unit.Pixel(40);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr2FU").HeaderStyle.Width = Unit.Pixel(40);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr3FU").HeaderStyle.Width = Unit.Pixel(40);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr4FU").HeaderStyle.Width = Unit.Pixel(40);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr5FU").HeaderStyle.Width = Unit.Pixel(40);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr6FU").HeaderStyle.Width = Unit.Pixel(40);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr7FU").HeaderStyle.Width = Unit.Pixel(40);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr8FU").HeaderStyle.Width = Unit.Pixel(40);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr9FU").HeaderStyle.Width = Unit.Pixel(40);
                    MissingDataWorkListGrid.MasterTableView.GetColumn("Yr10FU").HeaderStyle.Width = Unit.Pixel(40);
                    break;

                case "OpForm":
                    sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationId"]);
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.SiteId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["SiteId"]);
                    SaveSessionData(sessionData);
                    Response.Redirect(Properties.Resource2.OperationDetailsPath + "?LoadOperationDetails=1", false);
                    break;

                case "Day30FU":
                    sessionData.ResetPatientData();
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationId"]);
                    sessionData.FollowUpPeriodId = 0;
                    SaveSessionData(sessionData);
                    Response.Redirect(Properties.Resource.FollowUpPagePath + "?LoadFUP=1", false);
                    break;

                case "Yr1FU":
                    sessionData.ResetPatientData();
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationId"]);
                    sessionData.FollowUpPeriodId = 1;
                    SaveSessionData(sessionData);
                    Response.Redirect(Properties.Resource.FollowUpPagePath + "?LoadFUP=1", false);
                    break;

                case "Yr2FU":
                    sessionData.ResetPatientData();
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationId"]);
                    sessionData.FollowUpPeriodId = 2;
                    SaveSessionData(sessionData);
                    Response.Redirect(Properties.Resource.FollowUpPagePath + "?LoadFUP=1", false);
                    break;

                case "Yr3FU":
                    sessionData.ResetPatientData();
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationId"]);
                    sessionData.FollowUpPeriodId = 3;
                    SaveSessionData(sessionData);
                    Response.Redirect(Properties.Resource.FollowUpPagePath + "?LoadFUP=1", false);
                    break;

                case "Yr4FU":
                    sessionData.ResetPatientData();
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationId"]);
                    sessionData.FollowUpPeriodId = 4;
                    SaveSessionData(sessionData);
                    Response.Redirect(Properties.Resource.FollowUpPagePath + "?LoadFUP=1", false);
                    break;

                case "Yr5FU":
                    sessionData.ResetPatientData();
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationId"]);
                    sessionData.FollowUpPeriodId = 5;
                    SaveSessionData(sessionData);
                    Response.Redirect(Properties.Resource.FollowUpPagePath + "?LoadFUP=1", false);
                    break;

                case "Yr6FU":
                    sessionData.ResetPatientData();
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationId"]);
                    sessionData.FollowUpPeriodId = 6;
                    SaveSessionData(sessionData);
                    Response.Redirect(Properties.Resource.FollowUpPagePath + "?LoadFUP=1", false);
                    break;

                case "Yr7FU":
                    sessionData.ResetPatientData();
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationId"]);
                    sessionData.FollowUpPeriodId = 7;
                    SaveSessionData(sessionData);
                    Response.Redirect(Properties.Resource.FollowUpPagePath + "?LoadFUP=1", false);
                    break;

                case "Yr8FU":
                    sessionData.ResetPatientData();
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationId"]);
                    sessionData.FollowUpPeriodId = 8;
                    SaveSessionData(sessionData);
                    Response.Redirect(Properties.Resource.FollowUpPagePath + "?LoadFUP=1", false);
                    break;

                case "Yr9FU":
                    sessionData.ResetPatientData();
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationId"]);
                    sessionData.FollowUpPeriodId = 9;
                    SaveSessionData(sessionData);
                    Response.Redirect(Properties.Resource.FollowUpPagePath + "?LoadFUP=1", false);
                    break;

                case "Yr10FU":
                    sessionData.ResetPatientData();
                    sessionData.PatientId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientId"]);
                    sessionData.PatientOperationId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["OperationId"]);
                    sessionData.FollowUpPeriodId = 10;
                    SaveSessionData(sessionData);
                    Response.Redirect(Properties.Resource.FollowUpPagePath + "?LoadFUP=1", false);
                    break;

                default:
                    break;
            }

        }
        #endregion GridCommands

        #region AttachingImageWithFUAndOpStatus
        /// <summary>
        /// Processing data on the Missing Worklist grid to decide which button and link has to be shown
        /// </summary>
        /// <param name="sender">Missing Data Work List grid as sender</param>
        /// <param name="e">Grid Item event argument</param>
        protected void MissingDataWorkListGrid_ItemDataBound(object sender, GridItemEventArgs e)
        {
            bool clickable = false;
            if (e.Item is GridDataItem)
            {
                GridDataItem row = e.Item as GridDataItem;
                if (row["Day30FU"] != null && row["Day30FU"].Text != string.Empty)
                {
                    ImageButton imageButton = (e.Item as GridDataItem).FindControl("imgDay30FU") as ImageButton;
                    imageButton.ImageUrl = GetImageUrl(row["Day30FU"].Text, ref clickable);
                    imageButton.CommandName = "Day30FU";
                    imageButton.Enabled = clickable;
                    if (!clickable) imageButton.Style.Add(HtmlTextWriterStyle.Cursor, "default");
                }

                if (row["Yr1FU"] != null && row["Yr1FU"].Text != string.Empty)
                {
                    ImageButton imageButton = (e.Item as GridDataItem).FindControl("imgYr1FU") as ImageButton;
                    imageButton.ImageUrl = GetImageUrl(row["Yr1FU"].Text, ref clickable);
                    imageButton.Enabled = clickable;
                    if (!clickable) imageButton.Style.Add(HtmlTextWriterStyle.Cursor, "default");
                }

                if (row["Yr2FU"] != null && row["Yr2FU"].Text != string.Empty)
                {
                    ImageButton imageButton = (e.Item as GridDataItem).FindControl("imgYr2FU") as ImageButton;
                    imageButton.ImageUrl = GetImageUrl(row["Yr2FU"].Text, ref clickable);
                    imageButton.Enabled = clickable;
                    if (!clickable) imageButton.Style.Add(HtmlTextWriterStyle.Cursor, "default");
                }

                if (row["Yr3FU"] != null && row["Yr3FU"].Text != string.Empty)
                {
                    ImageButton imageButton = (e.Item as GridDataItem).FindControl("imgYr3FU") as ImageButton;
                    imageButton.ImageUrl = GetImageUrl(row["Yr3FU"].Text, ref clickable);
                    imageButton.Enabled = clickable;
                    if (!clickable) imageButton.Style.Add(HtmlTextWriterStyle.Cursor, "default");
                }

                if (row["Yr4FU"] != null && row["Yr4FU"].Text != string.Empty)
                {
                    ImageButton imageButton = (e.Item as GridDataItem).FindControl("imgYr4FU") as ImageButton;
                    imageButton.ImageUrl = GetImageUrl(row["Yr4FU"].Text, ref clickable);
                    imageButton.Enabled = clickable;
                    if (!clickable) imageButton.Style.Add(HtmlTextWriterStyle.Cursor, "default");
                }

                if (row["Yr5FU"] != null && row["Yr5FU"].Text != string.Empty)
                {
                    ImageButton imageButton = (e.Item as GridDataItem).FindControl("imgYr5FU") as ImageButton;
                    imageButton.ImageUrl = GetImageUrl(row["Yr5FU"].Text, ref clickable);
                    imageButton.Enabled = clickable;
                    if (!clickable) imageButton.Style.Add(HtmlTextWriterStyle.Cursor, "default");
                }

                if (row["Yr6FU"] != null && row["Yr6FU"].Text != string.Empty)
                {
                    ImageButton imageButton = (e.Item as GridDataItem).FindControl("imgYr6FU") as ImageButton;
                    imageButton.ImageUrl = GetImageUrl(row["Yr6FU"].Text, ref clickable);
                    imageButton.Enabled = clickable;
                    if (!clickable) imageButton.Style.Add(HtmlTextWriterStyle.Cursor, "default");
                }

                if (row["Yr7FU"] != null && row["Yr7FU"].Text != string.Empty)
                {
                    ImageButton imageButton = (e.Item as GridDataItem).FindControl("imgYr7FU") as ImageButton;
                    imageButton.ImageUrl = GetImageUrl(row["Yr7FU"].Text, ref clickable);
                    imageButton.Enabled = clickable;
                    if (!clickable) imageButton.Style.Add(HtmlTextWriterStyle.Cursor, "default");
                }

                if (row["Yr8FU"] != null && row["Yr8FU"].Text != string.Empty)
                {
                    ImageButton imageButton = (e.Item as GridDataItem).FindControl("imgYr8FU") as ImageButton;
                    imageButton.ImageUrl = GetImageUrl(row["Yr8FU"].Text, ref clickable);
                    imageButton.Enabled = clickable;
                    if (!clickable) imageButton.Style.Add(HtmlTextWriterStyle.Cursor, "default");
                }

                if (row["Yr9FU"] != null && row["Yr9FU"].Text != string.Empty)
                {
                    ImageButton imageButton = (e.Item as GridDataItem).FindControl("imgYr9FU") as ImageButton;
                    imageButton.ImageUrl = GetImageUrl(row["Yr9FU"].Text, ref clickable);
                    imageButton.Enabled = clickable;
                    if (!clickable) imageButton.Style.Add(HtmlTextWriterStyle.Cursor, "default");
                }

                if (row["Yr10FU"] != null && row["Yr10FU"].Text != string.Empty)
                {
                    ImageButton imageButton = (e.Item as GridDataItem).FindControl("imgYr10FU") as ImageButton;
                    imageButton.ImageUrl = GetImageUrl(row["Yr10FU"].Text, ref clickable);
                    imageButton.Enabled = clickable;
                    if (!clickable) imageButton.Style.Add(HtmlTextWriterStyle.Cursor, "default");
                }

                if (row["OpFormCompleted"] != null && row["OpFormCompleted"].Text != string.Empty)
                {
                    ImageButton imageButton = (e.Item as GridDataItem).FindControl("imgOpFormCompleted") as ImageButton;
                    imageButton.ImageUrl = GetImageUrl(row["OpFormCompleted"].Text, ref clickable);
                    imageButton.Enabled = clickable;
                    if (!clickable) imageButton.Style.Add(HtmlTextWriterStyle.Cursor, "default");
                }
            }
        }

        /// <summary>
        /// Getting Image path as per the status value
        /// </summary>
        /// <param name="value">Status Value</param>
        /// <param name="isClickable">Flag indicating whether an item is clickable</param>
        /// <returns>Returns Image URL as per the status value passed in parameter</returns>
        /// <summary>
        public string GetImageUrl(string value, ref bool isClickable)
        {
            string imageUrl = string.Empty;
            switch (value)
            {
                case "Incomplete":
                    imageUrl = "~/Images/Incomplete.png";
                    isClickable = true;
                    break;

                case "z_Complete":
                    imageUrl = "~/Images/Complete.png";
                    isClickable = false;
                    break;

                case "Completed":
                    imageUrl = "~/Images/Complete.png";
                    isClickable = false;
                    break;

                case "Not Due":
                    imageUrl = "~/Images/NotDue.png";
                    isClickable = false;
                    break;

                case "Not Applicable":
                    imageUrl = "~/Images/NotApplicable.png";
                    isClickable = false;
                    break;

                case "Incomplete - WIP":
                    imageUrl = "~/Images/Incomplete.png";
                    isClickable = true;
                    break;
            }

            return imageUrl;
        }
        #endregion AttachingImageWithFUAndOpStatus

        #region XLAndPDFExporting
        /// <summary>
        /// Formatting grid cell for excel file format export
        /// </summary>
        /// <param name="sender">Missin Data grid as sender</param>
        /// <param name="e">Excel Export Cell Formatting event argument</param>
        protected void MissingDataWorkListGrid_ExcelExportCellFormatting(object sender, Telerik.Web.UI.ExcelExportCellFormattingEventArgs e)
        {
            GridCommandItem commandItem = (GridCommandItem)MissingDataWorkListGrid.MasterTableView.GetItems(GridItemType.CommandItem)[0];
            foreach (TableCell cell in commandItem.Cells)
            {
                cell.Text = string.Empty;
            }

            GridHeaderItem headerItem = (GridHeaderItem)MissingDataWorkListGrid.MasterTableView.GetItems(GridItemType.Header)[0];
            foreach (TableCell cell in headerItem.Cells)
            {
                cell.Style["border"] = "thin solid black";
                cell.Style["background-color"] = "#cccccc";
            }

            if (MissingDataWorkListGrid.MasterTableView.GetItems(GridItemType.FilteringItem).Count() > 0)
            {
                GridFilteringItem filterItem = (GridFilteringItem)MissingDataWorkListGrid.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
                foreach (TableCell cell in filterItem.Cells)
                {
                    cell.Text = string.Empty;
                }

                GridDataItem item = e.Cell.Parent as GridDataItem;
                item.Style["border"] = "thin solid black";
                item.Style["text-align"] = "left";
            }
        }

        /// <summary>
        /// Formatting the header for the PDF file to be exported
        /// </summary>
        /// <param name="sender">Missing Data Work List grid as sender</param>
        /// <param name="e">PDF Exporting event argument</param>
        protected void MissingDataWorkListGrid_PdfExporting(object sender, Telerik.Web.UI.GridPdfExportingArgs e)
        {
            string headerContent = string.Empty;
            headerContent = @"<div><img alt='' src='~/Images/monash_logo.png' style='width:60px;height:60px;vertical-align:middle;' />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style=' font-size:18px;padding-left:250px; font-weight:bolder;'> Missing Data Work List</span></div>";
            e.RawHTML = headerContent + e.RawHTML;

        }

        /// <summary>
        /// Formatting cells while initilizing columns data to be shown
        /// </summary>
        /// <param name="sender">Missing Data Work List grid as sender</param>
        /// <param name="e">Grid Item event argument</param>
        protected void MissingDataWorkListGrid_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridHeaderItem && _isPdfExport)
            {
                foreach (TableCell cell in e.Item.Cells)
                {
                    cell.Style["border"] = "thin solid black";
                    cell.Style["background-color"] = "#cccccc";
                }
            }

            if (e.Item is GridDataItem && _isPdfExport)
            {
                foreach (TableCell cell in e.Item.Cells)
                    cell.Style["border"] = "thin solid black";
            }

            if (e.Item is GridFilteringItem && _isPdfExport)
            {
                GridFilteringItem filterItem = (GridFilteringItem)MissingDataWorkListGrid.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
                foreach (TableCell cell in filterItem.Cells)
                {
                    cell.Text = string.Empty;
                }
            }

            if (e.Item is GridCommandItem)
            {
                var exportToExcelButton = (e.Item as GridCommandItem).FindControl("ExportToExcelButton") as Button;
                var exportToPdfButton = (e.Item as GridCommandItem).FindControl("ExportToPdfButton") as Button;
                if (exportToPdfButton != null) { ScriptManager.GetCurrent(Page).RegisterPostBackControl(exportToExcelButton); }
                if (exportToExcelButton != null) { ScriptManager.GetCurrent(Page).RegisterPostBackControl(exportToPdfButton); }
                string ExcelButtonID = ((Button)(e.Item as GridCommandItem).FindControl("ExportToExcelButton")).ClientID.ToString();
                string PdfButtonID = ((Button)(e.Item as GridCommandItem).FindControl("ExportToPdfButton")).ClientID.ToString();
                string PageName = "Missing Data List";
                ((Button)(e.Item as GridCommandItem).FindControl("ExportToExcelButton")).Attributes.Add("onclick", "return ConfirmDownload(" + ExcelButtonID + ",'" + PageName + "')");
                ((Button)(e.Item as GridCommandItem).FindControl("ExportToPdfButton")).Attributes.Add("onclick", "return ConfirmDownload(" + PdfButtonID + ",'" + PageName + "')");
            }
        }
        #endregion XLAndPDFExporting
    }
}
