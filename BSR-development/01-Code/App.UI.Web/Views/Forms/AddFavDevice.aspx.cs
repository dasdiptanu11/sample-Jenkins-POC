using App.Business;
using App.UI.Web.Views.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace App.UI.Web.Views.Forms
{
    public partial class AddFavDevice : BasePage
    {
        //check if User is admin or not
        List<Int32> _selectedSiteIds = new List<int>();
        List<Int32> _selectedPrimaryProcIds = new List<int>();
        List<Int32> _selectedSecondaryProcIds = new List<int>();
        Boolean _isAdmin = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMIN));
        Boolean _isAdminCentral = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_ADMINCENTRAL));
        Boolean _isSurgeon = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_SURGEON));
        Boolean _isDataCollector = (Roles.IsUserInRole(BusinessConstants.ROLE_NAME_DATACOLLECTOR));
        Boolean _isEdit = false;
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Request.QueryString["isAdd"] != null)
            {
                SessionData sessionData = GetSessionData();
                sessionData.FavDeviceId = 0;
            }
            else
                _isEdit = true;
            if (!IsPostBack)
            {
                SessionData sessionData = GetSessionData();
                if (sessionData.FavDeviceId == 0)
                {
                    if (_isEdit == false)
                    {
                        if (_isAdmin || _isAdminCentral)
                        {
                            LoadLookUpCountry();
                        }
                        else
                        {
                            divsiteList.Visible = true;
                            LoadLookUpCountry();
                            LoadLookUpSurgeon(-1);
                            LoadSites(Convert.ToInt32(Surgeon_DropDown.SelectedValue));
                        }
                    }
                }
                else
                {
                    //Setting the respective fields
                    InitData();
                    FavouriteDeviceAccordion.SelectedIndex = 2;
                    Country_DropDown.Enabled = false;
                    Surgeon_DropDown.Enabled = false;
                    siteCheckBoxList.Enabled = false;
                    typeOfPrimProcsCheckList.Enabled = false;
                    typeOfRevProcsCheckList.Enabled = false;
                    Save_DevicePane.Text = "Update";
                }
            }
        }
        /// <summary>
        /// Loads device details while editing 
        /// </summary>
        private void InitData()
        {
            SessionData sessionData = GetSessionData();
            using (UnitOfWork favDevice = new UnitOfWork())
            {
                tbl_UserFavouriteDeviceDetails favDeviceDetails = favDevice.tbl_UserFavouriteDeviceDetailsRepository.Get(x => x.FavDevId == sessionData.FavDeviceId).FirstOrDefault();

                if (favDeviceDetails != null)
                {
                    Dictionary<System.Web.UI.Control, Object> controlMapping = new Dictionary<System.Web.UI.Control, Object>();
                    //popuate "Surgeon and Sites" accordion data
                    LoadLookUpCountry();

                    controlMapping.Add(Country_DropDown, favDeviceDetails.CountryId);
                    LoadLookUpSurgeon(Convert.ToInt32(Country_DropDown.SelectedValue));

                    controlMapping.Add(Surgeon_DropDown, favDeviceDetails.SurgId);
                    LoadSites((int)favDeviceDetails.SurgId);

                    controlMapping.Add(siteCheckBoxList, favDeviceDetails.SiteId);
                    LoadTypesOfProcedures();

                    if (favDeviceDetails.OpStatus == 0)
                        controlMapping.Add(typeOfPrimProcsCheckList, favDeviceDetails.OpType);
                    else
                        controlMapping.Add(typeOfRevProcsCheckList, favDeviceDetails.OpRevType);
                    LoadDeviceType();

                    controlMapping.Add(DeviceType, favDeviceDetails.DevType);
                    LoadBrandFromDevice(favDeviceDetails.DevType.ToString());

                    controlMapping.Add(BrandName, favDeviceDetails.DevBrand);
                    LoadDescriptionAndManufacturerFromBrand(favDeviceDetails.DevBrand.ToString());

                    controlMapping.Add(Description, favDeviceDetails.DevId);
                    LoadModelFromDescription(favDeviceDetails.DevId.ToString());

                    controlMapping.Add(Model, favDeviceDetails.DevId);
                    controlMapping.Add(Manufacturer, favDeviceDetails.DevManuf);
                    if (favDeviceDetails.DevType == 0 || favDeviceDetails.DevType == 1)
                    {
                        OptionPanel.Visible = true;
                        Buttress.ClearSelection();
                        ButtressTypeDropDown.Items.Clear();
                        ButtressPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                        ButtressTypePanel.Style.Add(HtmlTextWriterStyle.Display, "none");

                        PrimaryPortPanel.Style.Add(HtmlTextWriterStyle.Display, "block");

                        Helper.BindCollectionToControl(PortFixMethod, favDevice.Get_tlkp_PortFixationMethod_NoId(true), "Id", "Description");
                        PortFixPanel.Style.Add(HtmlTextWriterStyle.Display, "block");

                        controlMapping.Add(ChkPrimPortRet, favDeviceDetails.PriPortRet == true ? true : false);
                        controlMapping.Add(PortFixMethod, favDeviceDetails.DevPortMethId);
                        //Child Device Details
                        tbl_UserFavouriteDeviceDetails dataItemsPF = favDevice.tbl_UserFavouriteDeviceDetailsRepository.Get(x => x.ParentFavDevId == sessionData.FavDeviceId).FirstOrDefault();
                        if (dataItemsPF != null)
                        {
                            List<LookupItem> items = null;
                            AccessPortPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                            //PortFix Brand Name
                            items = favDevice.GetBrandNamesWithOther(true, "2");
                            items.RemoveAll(x => x.Id == "-1");
                            Helper.BindCollectionToControl(PortFixBrandName, items, "Id", "Description");
                            items.Clear();
                            //PortFixDescription and PortFix Manufacturer
                            items = favDevice.GetDeviceDescriptionWithOther(true, dataItemsPF.DevBrand.ToString());
                            items.RemoveAll(x => x.Id == "-1");
                            Helper.BindCollectionToControl(PortFixDescription, items, "Id", "Description");
                            Helper.BindCollectionToControl(PortFixManufacturer, favDevice.GetManufacturersWithOther(true, dataItemsPF.DevBrand.ToString(), false), "Id", "Description");
                            items.Clear();
                            //PortFix Model
                            items = favDevice.GetModelWithOther(true, dataItemsPF.DevId.ToString(), false);
                            items.RemoveAll(x => x.Id == "-1");
                            Helper.BindCollectionToControl(PortFixModel, items, "Id", "Description");
                            //Init
                            controlMapping.Add(PortFixBrandName, dataItemsPF.DevBrand);
                            controlMapping.Add(PortFixDescription, dataItemsPF.DevId);
                            controlMapping.Add(PortFixModel, dataItemsPF.DevId);
                            controlMapping.Add(PortFixManufacturer, dataItemsPF.DevManuf);
                        }
                        else
                            AccessPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    }
                    else if (favDeviceDetails.DevType == 3)
                    {
                        OptionPanel.Visible = true;
                        ChkPrimPortRet.Checked = false;
                        PortFixMethod.Items.Clear();
                        PrimaryPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                        PortFixPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                        PortFixBrandName.Items.Clear();
                        PortFixDescription.Items.Clear();
                        PortFixModel.Items.Clear();
                        PortFixManufacturer.Items.Clear();
                        AccessPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                        Helper.BindCollectionToControl(Buttress, favDevice.GetYesNo(false), "Id", "Description");
                        ButtressPanel.Style.Add(HtmlTextWriterStyle.Display, "block");

                        controlMapping.Add(Buttress, favDeviceDetails.ButtressID);
                        if (favDeviceDetails.ButtressID == 1)
                        {
                            List<LookupItem> items = favDevice.Get_tlkp_ButtressType(true);
                            items.RemoveAll(x => x.Id == "9");
                            Helper.BindCollectionToControl(ButtressTypeDropDown, items, "Id", "Description");
                            ButtressTypePanel.Style.Add(HtmlTextWriterStyle.Display, "block");

                            controlMapping.Add(ButtressTypeDropDown, favDeviceDetails.ButtTypeID);
                        }
                        else
                        {
                            ButtressTypeDropDown.Items.Clear();
                            ButtressTypePanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                        }
                    }
                    else
                    {
                        OptionPanel.Visible = false;
                        ChkPrimPortRet.Checked = false;
                        PortFixMethod.Items.Clear();
                        PrimaryPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                        PortFixPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                        PortFixBrandName.Items.Clear();
                        PortFixDescription.Items.Clear();
                        PortFixModel.Items.Clear();
                        PortFixManufacturer.Items.Clear();
                        AccessPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                        Buttress.ClearSelection();
                        ButtressTypeDropDown.Items.Clear();
                        ButtressPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                        ButtressTypePanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    }
                    PopulateControl(controlMapping);
                }
            }
        }

        #region Load Lookups
        /// <summary>
        /// Loads Country Dropdown options
        /// </summary>
        /// <returns></returns>
        protected bool LoadLookUpCountry()
        {
            SessionData sessionData = GetSessionData();
            using (UnitOfWork favDeviceDetails = new UnitOfWork())
            {
                if (!IsPostBack && (_isSurgeon || _isDataCollector))
                {
                    string userName = Session["username"].ToString();
                    Helper.BindCollectionToControl(Country_DropDown, favDeviceDetails.Get_Country(userName), "Id", "Description");
                }
                else
                {
                    Helper.BindCollectionToControl(Country_DropDown, favDeviceDetails.Get_tlkp_Country(false), "Id", "Description");
                    if (!IsPostBack && _isEdit == false)
                    {
                        Country_DropDown.SelectedIndex = 0;
                    }
                    //Surgeon Population
                    int siteCountryId = Convert.ToInt32(Country_DropDown.SelectedValue);
                    LoadLookUpSurgeon(siteCountryId);
                    if (!IsPostBack)
                    {
                        // Site Population
                        LoadSites(Convert.ToInt32(Surgeon_DropDown.SelectedValue));
                    }
                }
            }
            return true;
        }
        /// <summary>
        /// Loads Surgeon Dropdown options
        /// </summary>
        /// <param name="siteCountryId"> Country Id of selected country</param>
        /// <returns></returns>
        protected bool LoadLookUpSurgeon(int siteCountryId)
        {
            SurgeonDropDowntable.Visible = true;
            SessionData sessionData = GetSessionData();
            using (UnitOfWork favDeviceDetails = new UnitOfWork())
            {
                if (_isSurgeon || _isDataCollector)
                {
                    string userName = Session["username"].ToString();
                    Helper.BindCollectionToControl(Surgeon_DropDown, favDeviceDetails.Get_SurgeonForCountry(siteCountryId, false, userName), "Id", "Description");
                }
                else
                {
                    Helper.BindCollectionToControl(Surgeon_DropDown, favDeviceDetails.Get_SurgeonForCountry(siteCountryId, false, ""), "Id", "Description");
                    if (_isEdit == false && Surgeon_DropDown.Items.Count > 0)
                    {
                        Surgeon_DropDown.SelectedIndex = 0;
                    }

                }
            }
            return true;
        }
        /// <summary>
        /// Loads Site CheckList options
        /// </summary>
        /// <param name="SurgID"> Surgron dropdown selection</param>
        /// <returns></returns>
        protected bool LoadSites(int SurgID)
        {
            divsiteList.Visible = true;
            if (_isAdmin || _isAdminCentral)
            {
                int countryId = Convert.ToInt32(Country_DropDown.SelectedValue);
                using (UnitOfWork favDeviceDetails = new UnitOfWork())
                {
                    string userName = favDeviceDetails.Get_Surgeon_UserName(SurgID);
                    Helper.BindCollectionToControl(siteCheckBoxList, favDeviceDetails.Get_Site_Name(userName, countryId, false, false), "Id", "Description");
                    if (siteCheckBoxList.Items.Count > 9)
                    {
                        if ((siteCheckBoxList.Items.Count % 9) > 0)
                            siteCheckBoxList.RepeatColumns = (siteCheckBoxList.Items.Count / 9) + 1;
                        else
                            siteCheckBoxList.RepeatColumns = (siteCheckBoxList.Items.Count / 9);
                    }
                    else
                        siteCheckBoxList.RepeatColumns = 1;
                }
            }
            else
            {
                using (UnitOfWork favDeviceDetails = new UnitOfWork())
                {
                    string userName = Session["username"].ToString();
                    Helper.BindCollectionToControl(siteCheckBoxList, favDeviceDetails.Get_Site_Name(userName, -1, false, false), "Id", "Description");
                    if (siteCheckBoxList.Items.Count > 9)
                    {
                        if ((siteCheckBoxList.Items.Count % 9) > 0)
                            siteCheckBoxList.RepeatColumns = (siteCheckBoxList.Items.Count / 9) + 1;
                        else
                            siteCheckBoxList.RepeatColumns = (siteCheckBoxList.Items.Count / 9);
                    }
                    else
                        siteCheckBoxList.RepeatColumns = 1;
                }
            }
            return true;
        }
        /// <summary>
        /// Loads Primary and Secondary Procedure CheckList options
        /// </summary>
        /// <returns></returns>
        protected bool LoadTypesOfProcedures()
        {
            using (UnitOfWork favDeviceDetails = new UnitOfWork())
            {
                //Type Of Procedure
                divTypeOfProcs.Visible = true;
                Helper.BindCollectionToControl(typeOfPrimProcsCheckList, favDeviceDetails.Get_ProceduresList(), "Id", "Description");
                Helper.BindCollectionToControl(typeOfRevProcsCheckList, favDeviceDetails.Get_ProceduresList(), "Id", "Description");
            }
            return true;
        }
        /// <summary>
        /// Loads Device Type
        /// </summary>
        /// <param></param>
        private void LoadDeviceType()
        {
            using (UnitOfWork favDeviceDetails = new UnitOfWork())
            {
                divDevice.Visible = true;
                List<LookupItem> items = favDeviceDetails.Get_tlkp_DeviceType(true);
                items.RemoveAll(x => x.Id == "2" || x.Id == "6");
                Helper.BindCollectionToControl(DeviceType, items, "Id", "Description");
                ////Clear rest selections
                if (Request.QueryString["isAdd"] != null)
                {
                    BrandName.Items.Clear();
                    Description.Items.Clear();
                    Model.Items.Clear();
                    Manufacturer.Items.Clear();
                    Buttress.Items.Clear();
                    ButtressTypeDropDown.Items.Clear();
                    ChkPrimPortRet.Checked = false;
                    PortFixMethod.Items.Clear();
                    OptionPanel.Visible = false;
                }
                else
                {
                    Helper.BindCollectionToControl(Buttress, favDeviceDetails.GetYesNo(false), "Id", "Description");
                    List<LookupItem> item = favDeviceDetails.Get_tlkp_ButtressType(true);
                    items.RemoveAll(x => x.Id == "9");
                    Helper.BindCollectionToControl(ButtressTypeDropDown, item, "Id", "Description");
                    Helper.BindCollectionToControl(PortFixMethod, favDeviceDetails.Get_tlkp_PortFixationMethod_NoId(true), "Id", "Description");
                }
            }
        }
        /// <summary>
        /// Loads brand depending on Device Type Selection
        /// </summary>
        /// <param name="selectedValue">Selected Devie type Id</param>
        private void LoadBrandFromDevice(string selectedValue)
        {
            using (UnitOfWork favDeviceDetails = new UnitOfWork())
            {
                List<LookupItem> items = favDeviceDetails.GetBrandNamesWithOther(true, selectedValue);
                items.RemoveAll(x => x.Id == "-1");
                Helper.BindCollectionToControl(BrandName, items, "Id", "Description");
                BrandName.Enabled = true;
                if (BrandName.Items.Count == 2)
                {
                    BrandName.Items[1].Selected = true;
                }
            }
        }
        /// <summary>
        /// Loads Description And Manufacturer options depending on Brand Selection
        /// </summary>
        /// <param name="BrandId">selected Brand id</param>
        private void LoadDescriptionAndManufacturerFromBrand(string BrandId)
        {
            using (UnitOfWork favDeviceDetails = new UnitOfWork())
            {
                List<LookupItem> items = favDeviceDetails.GetDeviceDescriptionWithOther(true, BrandId);
                items.RemoveAll(x => x.Id == "-1");
                Helper.BindCollectionToControl(Description, items, "Id", "Description");
                if (Description.Items.Count == 2)
                {
                    Description.Items[1].Selected = true;
                    LoadModelFromDescription(Description.SelectedValue);
                }

                Helper.BindCollectionToControl(Manufacturer, favDeviceDetails.GetManufacturersWithOther(true, BrandId, false), "Id", "Description");
                if (Manufacturer.Items.Count == 2)
                {
                    Manufacturer.Items[1].Selected = true;
                }
            }
        }
        /// <summary>
        /// Loads Model depending on Description Selection
        /// </summary>
        /// <param name="Desc">Selected Device Description</param>
        private void LoadModelFromDescription(String Desc)
        {
            using (UnitOfWork favDeviceDetails = new UnitOfWork())
            {
                List<LookupItem> items = favDeviceDetails.GetModelWithOther(true, Desc, false);
                items.RemoveAll(x => x.Id == "-1");
                Helper.BindCollectionToControl(Model, items, "Id", "Description");
                if (Model.Items.Count == 2)
                {
                    Model.Items[1].Selected = true;
                }
            }
        }

        #endregion
        #region selected Index change methods
        /// <summary>
        /// changing display on SelectedIndexChanged event of Country 
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void Country_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_isDataCollector || _isSurgeon)
            {

            }
            else
            {
                //Clear all sections
                Surgeon_DropDown.Items.Clear();
                divsiteList.Visible = false;
                divTypeOfProcs.Visible = false;
                divDevice.Visible = false;
                //Surgeon Re-Population
                int siteCountryId = Convert.ToInt32(Country_DropDown.SelectedValue);
                LoadLookUpSurgeon(siteCountryId);
                if (Surgeon_DropDown.Items.Count > 0)
                {
                    LoadSites(Convert.ToInt32(Surgeon_DropDown.SelectedValue));
                }
            }

        }
        /// <summary>
        /// changing display on SelectedIndexChanged event of Surgeon 
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void Surgeon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_isSurgeon)
            {

            }
            else if (_isDataCollector)
            {
                divTypeOfProcs.Visible = false;
                divDevice.Visible = false;
            }
            else
            {
                divsiteList.Visible = false;
                divTypeOfProcs.Visible = false;
                divDevice.Visible = false;
                if (IsPostBack)
                {
                    siteCheckBoxList.Items.Clear();
                }
                //Load Sites
                LoadSites(Convert.ToInt32(Surgeon_DropDown.SelectedValue));
                if (siteCheckBoxList.Items.Count < 1)
                {
                    divTypeOfProcs.Visible = false;
                    divDevice.Visible = false;
                }
            }
        }
        /// <summary>
        /// Loads Brand from Device Selection
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void DeviceType_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            BrandName.Items.Clear();
            Description.Items.Clear();
            Model.Items.Clear();
            Manufacturer.Items.Clear();
            ChkPrimPortRet.Checked = false;

            PortFixMethod.Items.Clear();
            PortFixBrandName.Items.Clear();
            PortFixDescription.Items.Clear();
            PortFixModel.Items.Clear();
            PortFixManufacturer.Items.Clear();

            if (DeviceType.SelectedValue != "0" && DeviceType.SelectedValue != "1" && DeviceType.SelectedValue != "3")
                OptionPanel.Visible = false;

            LoadBrandFromDevice(DeviceType.SelectedValue);
            using (UnitOfWork favDeviceDetails = new UnitOfWork())
            {
                if (DeviceType.SelectedValue == "0" || DeviceType.SelectedValue == "1")
                {
                    OptionPanel.Visible = true;
                    Buttress.ClearSelection();
                    ButtressTypeDropDown.Items.Clear();
                    ButtressPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    ButtressTypePanel.Style.Add(HtmlTextWriterStyle.Display, "none");

                    PrimaryPortPanel.Style.Add(HtmlTextWriterStyle.Display, "block");

                    Helper.BindCollectionToControl(PortFixMethod, favDeviceDetails.Get_tlkp_PortFixationMethod_NoId(true), "Id", "Description");
                    PortFixPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                    AccessPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
                else if (DeviceType.SelectedValue == "3")
                {
                    OptionPanel.Visible = true;
                    ChkPrimPortRet.Checked = false;
                    PortFixMethod.Items.Clear();
                    PrimaryPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    PortFixPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    AccessPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    Helper.BindCollectionToControl(Buttress, favDeviceDetails.GetYesNo(false), "Id", "Description");
                    ButtressPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                    ButtressTypePanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
                else
                {
                    OptionPanel.Visible = false;
                    ChkPrimPortRet.Checked = false;
                    PortFixMethod.Items.Clear();
                    PrimaryPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    PortFixPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    AccessPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    Buttress.ClearSelection();
                    ButtressTypeDropDown.Items.Clear();
                    ButtressPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                    ButtressTypePanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
                if (BrandName.SelectedValue != "")
                {
                    LoadDescriptionAndManufacturerFromBrand(BrandName.SelectedValue);
                }
            }

        }
        /// <summary>
        /// Loads Description and Manufacturer Options from BrandName selection
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void BrandName_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            Description.Items.Clear();
            Model.Items.Clear();
            Manufacturer.Items.Clear();
            if (DeviceType.SelectedValue != "0" && DeviceType.SelectedValue != "1" && DeviceType.SelectedValue != "3")
                OptionPanel.Visible = false;
            LoadDescriptionAndManufacturerFromBrand(BrandName.SelectedValue);
        }
        /// <summary>
        /// Loads Model Options from Description
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void Description_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            Model.Items.Clear();
            if (DeviceType.SelectedValue != "0" && DeviceType.SelectedValue != "1" && DeviceType.SelectedValue != "3")
                OptionPanel.Visible = false;
            LoadModelFromDescription(Description.SelectedValue);
        }
        /// <summary>
        /// it enables Buttress Type depending on Buttress selection
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void Buttress_SelectedIndexChanged(object sender, EventArgs e)
        {
            using (UnitOfWork favDeviceDetails = new UnitOfWork())
            {
                if (Buttress.SelectedValue == "1")
                {
                    List<LookupItem> items = favDeviceDetails.GetButtressTypeWithOther(true, null);
                    items.RemoveAll(x => x.Id == "9");
                    Helper.BindCollectionToControl(ButtressTypeDropDown, items, "Id", "Description");
                    ButtressTypePanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                }
                else
                {
                    ButtressTypeDropDown.Items.Clear();
                    ButtressTypePanel.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
            }
        }
        /// <summary>
        /// changing display on SelectedIndexChanged event of PortFixMethod 
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void PortFixMethod_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            PortFixBrandName.Items.Clear();
            PortFixDescription.Items.Clear();
            PortFixModel.Items.Clear();
            PortFixManufacturer.Items.Clear();
            AccessPortPanel.Style.Add(HtmlTextWriterStyle.Display, "none");
            if (PortFixMethod.SelectedValue == "1" || PortFixMethod.SelectedValue == "0")
            {
                AccessPortPanel.Style.Add(HtmlTextWriterStyle.Display, "block");
                using (UnitOfWork favDeviceDetails = new UnitOfWork())
                {
                    List<LookupItem> items = favDeviceDetails.GetBrandNamesWithOther(true, "2");
                    items.RemoveAll(x => x.Id == "-1");
                    Helper.BindCollectionToControl(PortFixBrandName, items, "Id", "Description");
                }
            }
        }
        /// <summary>
        /// changing display on SelectedIndexChanged event of PortFix Brand Name
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void PortFixBrandName_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            PortFixDescription.Items.Clear();
            PortFixModel.Items.Clear();
            PortFixManufacturer.Items.Clear();
            string Id = PortFixBrandName.SelectedValue;
            using (UnitOfWork favDeviceDetails = new UnitOfWork())
            {
                List<LookupItem> items = favDeviceDetails.GetDeviceDescriptionWithOther(true, Id);
                items.RemoveAll(x => x.Id == "-1");
                Helper.BindCollectionToControl(PortFixDescription, items, "Id", "Description");
                if (PortFixDescription.Items.Count == 2)
                {
                    PortFixDescription.Items[1].Selected = true;
                    items = favDeviceDetails.GetModelWithOther(true, PortFixDescription.SelectedValue, false);
                    items.RemoveAll(x => x.Id == "-1");
                    Helper.BindCollectionToControl(PortFixModel, items, "Id", "Description");
                    if (PortFixModel.Items.Count == 2)
                    {
                        PortFixModel.Items[1].Selected = true;
                    }
                }
                Helper.BindCollectionToControl(PortFixManufacturer, favDeviceDetails.GetManufacturersWithOther(true, Id, false), "Id", "Description");
                if (PortFixManufacturer.Items.Count == 2)
                {
                    PortFixManufacturer.Items[1].Selected = true;
                }
            }
        }
        /// <summary>
        /// changing display on SelectedIndexChanged event of PortFix Description
        /// </summary>
        /// <param name="sender">object point to the control</param>
        /// <param name="e">provides data on event change</param>
        protected void PortFixDescription_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            PortFixModel.Items.Clear();
            string Desc = PortFixDescription.SelectedValue;
            using (UnitOfWork favDeviceDetails = new UnitOfWork())
            {
                List<LookupItem> items = favDeviceDetails.GetModelWithOther(true, Desc, false);
                items.RemoveAll(x => x.Id == "-1");
                Helper.BindCollectionToControl(PortFixModel, items, "Id", "Description");
                if (PortFixModel.Items.Count == 2)
                {
                    PortFixModel.Items[1].Selected = true;
                }
            }
        }
        #endregion
        #region Custom Validation methods
        /// <summary>
        /// Accordion server validation
        /// </summary>
        /// <param name="source">Favourite Device Accordian</param>
        /// <param name="args">Validate upon args</param>
        protected void FavDeviceAccordian_ServerValidate(object source, ServerValidateEventArgs args)
        {
        }
        #endregion
        #region Button Click
        /// <summary>
        /// saving data of Surgeon Pane and open next pane
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Save_SurgeonAndSitePane_OnClick(object sender, EventArgs e)
        {
            if (_isEdit == false)
            {
                if (_selectedSiteIds.Count > 0)
                    _selectedSiteIds.Clear();
                bool isSiteSelected = false;
                foreach (ListItem item in siteCheckBoxList.Items)
                {
                    if (item.Selected != true)
                    { }
                    else
                    {
                        isSiteSelected = true;
                        _selectedSiteIds.Add(Convert.ToInt32(item.Value));
                    }
                }
                if (isSiteSelected == false)
                {
                    cvFavDeviceAccordian.IsValid = false;
                    cvFavDeviceAccordian.ErrorMessage = "Site in 'Surgeon & Sites' Pane is a required field";
                }
                else
                {
                    cvFavDeviceAccordian.IsValid = true;
                    LoadTypesOfProcedures();
                    FavouriteDeviceAccordion.SelectedIndex += 1;
                }
                Session["selectedSiteIds"] = _selectedSiteIds;
            }
        }
        /// <summary>
        /// Cancel of Surgeon Pane
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Cancel_SurgeonAndSitePane_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("~/Views/Forms/DeviceFavourite.aspx");
        }
        /// <summary>
        /// saving data of Types Of Procedure Pane and open next pane
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Save_TypeOfProcsPane_OnClick(object sender, EventArgs e)
        {
            if (_isEdit == false)
            {
                if (_selectedPrimaryProcIds.Count > 0)
                    _selectedPrimaryProcIds.Clear();
                if (_selectedSecondaryProcIds.Count > 0)
                    _selectedSecondaryProcIds.Clear();
                bool isPrimaryProcSelected = false;
                bool isRevProcSelected = false;
                foreach (ListItem item in typeOfPrimProcsCheckList.Items)
                {
                    if (item.Selected != true)
                    { }
                    else
                    {
                        isPrimaryProcSelected = true;
                        _selectedPrimaryProcIds.Add(Convert.ToInt32(item.Value));
                    }
                }
                foreach (ListItem item in typeOfRevProcsCheckList.Items)
                {
                    if (item.Selected != true)
                    { }
                    else
                    {
                        isRevProcSelected = true;
                        _selectedSecondaryProcIds.Add(Convert.ToInt32(item.Value));
                    }
                }
                if (isPrimaryProcSelected || isRevProcSelected)
                {
                    cvFavDeviceAccordian.IsValid = true;
                    LoadDeviceType();
                    FavouriteDeviceAccordion.SelectedIndex += 1;
                }
                else
                {
                    cvFavDeviceAccordian.IsValid = false;
                    cvFavDeviceAccordian.ErrorMessage = "Primary and/or Secondary Procedure in 'Types of Procedures' Pane is a required field";
                }
                Session["selectedPrimaryProcIds"] = _selectedPrimaryProcIds;
                Session["selectedSecondaryProcIds"] = _selectedSecondaryProcIds;
            }
        }
        /// <summary>
        /// Cancel of Types Of Procedure Pane
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Cancel_TypeOfProcsPane_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("~/Views/Forms/DeviceFavourite.aspx");
        }
        /// <summary>
        /// calls method to save data in DataBase
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <summary>
        protected void Save_Device_OnClick(object sender, EventArgs e)
        {
            List<string> em = new List<string>();
            string ErrorMessage = string.Empty;

            if (!_isEdit)
            {
                if (Session["selectedSiteIds"] != null)
                    _selectedSiteIds = (List<int>)Session["selectedSiteIds"];
                if (_selectedSiteIds.Count == 0)
                {
                    em.Add("Site in 'Surgeon & Sites' Pane is a required field");
                }
                if (_selectedSiteIds.Count == 0)
                {
                    em.Add("Site in 'Surgeon & Sites' Pane is a required field");
                }

                if (Session["selectedPrimaryProcIds"] != null)
                    _selectedPrimaryProcIds = (List<int>)Session["selectedPrimaryProcIds"];
                if (Session["selectedSecondaryProcIds"] != null)
                    _selectedSecondaryProcIds = (List<int>)Session["selectedSecondaryProcIds"];
                if (_selectedPrimaryProcIds.Count == 0 && _selectedSecondaryProcIds.Count == 0)
                {
                    em.Add("Primary and/or Secondary Procedure in 'Types of Procedures' Pane is a required field");
                }
            }
            if (DeviceType.SelectedValue == "")
            {
                em.Add("Device Type in 'Device' Pane is a required field");
            }
            if (BrandName.SelectedValue == "")
            {
                em.Add("Brand in 'Device' Pane is a required field");
            }
            if (Description.SelectedValue == "")
            {
                em.Add("Description in 'Device' Pane is a required field");
            }
            if (Model.SelectedValue == "")
            {
                em.Add("Model in 'Device' Pane is a required field");
            }
            if (Manufacturer.SelectedValue == "")
            {
                em.Add("Manufacturer in 'Device' Pane is a required field");
            }
            if (DeviceType.SelectedValue == "3")
            {
                if (Buttress.SelectedValue == "")
                {
                    em.Add("Buttress in 'Device' Pane is a required field");
                }
                else
                {
                    if (Buttress.SelectedValue == "1" && ButtressTypeDropDown.SelectedValue == "")
                    {
                        em.Add("Buttress Type in 'Device' Pane is a required field");
                    }
                }
            }
            if (PortFixMethod.SelectedValue == "0" || PortFixMethod.SelectedValue == "1")
            {
                if (PortFixBrandName.SelectedValue == "")
                {
                    em.Add("Port Fixation Brand Name in 'Device' Pane is a required field");
                }
                if (PortFixDescription.SelectedValue == "")
                {
                    em.Add("Port Fixation Description in 'Device' Pane is a required field");
                }
                if (PortFixModel.SelectedValue == "")
                {
                    em.Add("Port Fixation Model in 'Device' Pane is a required field");
                }
                if (PortFixManufacturer.SelectedValue == "")
                {
                    em.Add("Port Fixation Manufacturer in 'Device' Pane is a required field");
                }
            }
            for (int i = 0; i < em.Count; i++)
            {
                ErrorMessage += (em[i] + "<br/>");
            }
            if (ErrorMessage.Length > 0)
            {
                cvFavDeviceAccordian.IsValid = false;
                cvFavDeviceAccordian.ErrorMessage = ErrorMessage;
            }
            if (Page.IsValid)
            {
                bool itemSaved = SaveItems();
            }
        }
        /// <summary>Cancel of Types Of Device Pane
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Cancel_DevicePane_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("~/Views/Forms/DeviceFavourite.aspx");
        }
        #endregion
        #region Save Data
        /// <summary>
        /// Runs loop-logic for multiple DB entry in one run
        /// </summary>
        /// <returns></returns>
        protected bool SaveItems()
        {
            bool formSaved = false;
            if (Session["selectedSiteIds"] != null)
                _selectedSiteIds = (List<int>)Session["selectedSiteIds"];
            if (Session["selectedPrimaryProcIds"] != null)
                _selectedPrimaryProcIds = (List<int>)Session["selectedPrimaryProcIds"];
            if (Session["selectedSecondaryProcIds"] != null)
                _selectedSecondaryProcIds = (List<int>)Session["selectedSecondaryProcIds"];
            if (_isEdit != true)
            {
                //New DB entry
                for (int i = 0; i < _selectedSiteIds.Count; i++)
                {
                    if (_selectedPrimaryProcIds.Count > 0)
                    {
                        for (int j = 0; j < _selectedPrimaryProcIds.Count; j++)
                        {
                            formSaved = SaveDataItem(false, _selectedSiteIds[i], _selectedPrimaryProcIds[j], true);
                        }
                    }
                    if (_selectedSecondaryProcIds.Count > 0)
                    {
                        for (int j = 0; j < _selectedSecondaryProcIds.Count; j++)
                        {
                            formSaved = SaveDataItem(true, _selectedSiteIds[i], _selectedSecondaryProcIds[j], true);
                        }
                    }
                }
            }
            else
            {
                formSaved = SaveDataItem(false, 0, 0, false);
            }
            if (formSaved)
                Response.Redirect("~/Views/Forms/DeviceFavourite.aspx");

            Session.Remove("_selectedSiteIds");
            Session.Remove("_selectedPrimaryProcIds");
            Session.Remove("_selectedSecondaryProcIds");

            return formSaved;
        }
        /// <summary>
        /// save each datarow in DB
        /// </summary>
        /// <returns></returns>
        protected bool SaveDataItem(Boolean isOpRev, int SiteId, int ProcId, Boolean isNew)
        {
            bool returnValue;
            using (UnitOfWork favDeviceDetails = new UnitOfWork())
            {
                try
                {
                    SessionData sessionData = GetSessionData();
                    tbl_UserFavouriteDeviceDetails dataItems = null;
                    if (!isNew)
                    {
                        dataItems = favDeviceDetails.tbl_UserFavouriteDeviceDetailsRepository.Get(x => x.FavDevId == sessionData.FavDeviceId).FirstOrDefault();
                    }
                    else
                    {
                        dataItems = new tbl_UserFavouriteDeviceDetails();
                        dataItems.SurgId = Helper.ToNullable<System.Int32>(Surgeon_DropDown.SelectedValue);
                        dataItems.CountryId = Helper.ToNullable<System.Int32>(Country_DropDown.SelectedValue);
                        dataItems.SiteId = SiteId;
                        if (isOpRev == false)
                        {
                            dataItems.OpStatus = 0;
                            dataItems.OpType = ProcId;
                        }
                        else
                        {
                            dataItems.OpStatus = 1;
                            dataItems.OpRevType = ProcId;
                        }
                        dataItems.CreatedBy = Session["Username"].ToString();
                        dataItems.CreatedDateTime = DateTime.Now;
                    }
                    dataItems.DevId = Helper.ToNullable<System.Int32>(Description.SelectedValue);
                    dataItems.DevType = Helper.ToNullable<System.Int32>(DeviceType.SelectedValue);
                    dataItems.DevBrand = Helper.ToNullable<System.Int32>(BrandName.SelectedValue);
                    dataItems.DevManuf = Helper.ToNullable<System.Int32>(Manufacturer.SelectedValue);
                    dataItems.PriPortRet = ChkPrimPortRet.Checked;
                    dataItems.DevPortMethId = Helper.ToNullable<System.Int32>(PortFixMethod.SelectedValue);
                    if (DeviceType.SelectedValue == "3")
                    {
                        dataItems.ButtressID = Convert.ToInt32(Buttress.SelectedValue);
                        if (Buttress.SelectedValue == "1")
                        {
                            dataItems.ButtTypeID = Helper.ToNullable<System.Int32>(ButtressTypeDropDown.SelectedValue);
                        }
                        else
                        {
                            if (dataItems.ButtressID != 0)
                                dataItems.ButtressID = 0;
                            if (dataItems.ButtTypeID != null)
                                dataItems.ButtTypeID = null;
                        }
                    }
                    else
                    {
                        dataItems.ButtressID = 0;
                        dataItems.ButtTypeID = null;
                    }
                    dataItems.LastUpdatedBy = Session["Username"].ToString();
                    dataItems.LastUpdatedDateTime = DateTime.Now;

                    if (isNew)
                    {
                        favDeviceDetails.tbl_UserFavouriteDeviceDetailsRepository.Insert(dataItems);
                    }
                    else
                    {
                        favDeviceDetails.tbl_UserFavouriteDeviceDetailsRepository.Update(dataItems);
                    }
                    favDeviceDetails.Save();
                    sessionData.FavDeviceId = dataItems.FavDevId;
                    SaveSessionData(sessionData);
                    if ((DeviceType.SelectedValue == "0" || DeviceType.SelectedValue == "1") && PortFixMethod.SelectedValue == "1")
                    {
                        if (dataItems.OpStatus == 0)
                        {
                            SaveChildDevice(false, (int)dataItems.SiteId, (int)dataItems.OpType);
                        }
                        else
                        {
                            SaveChildDevice(true, (int)dataItems.SiteId, (int)dataItems.OpRevType);
                        }
                    }
                    else
                    {
                        CheckIfChildExistsAndDelete();
                    }
                    returnValue = true;
                }
                catch (Exception ex)
                {
                    DisplayCustomMessageInValidationSummary(ex.Message, "DeviceDataValidationGroup");
                    returnValue = false;
                }
                return returnValue;

            }
        }
        /// <summary>
        /// saving child devices data related to Favourite Device Id
        /// </summary>
        /// <returns>child device flag</returns>
        protected bool SaveChildDevice(Boolean isOpRev, int SiteId, int ProcId)
        {
            bool returnValue;
            Boolean isNew = false;
            using (UnitOfWork favChildDeviceDetails = new UnitOfWork())
            {
                try
                {
                    SessionData sessionData = GetSessionData();
                    tbl_UserFavouriteDeviceDetails dataItems = null;
                    dataItems = favChildDeviceDetails.tbl_UserFavouriteDeviceDetailsRepository.Get(x => x.ParentFavDevId == sessionData.FavDeviceId).FirstOrDefault();
                    if (dataItems == null)
                    {
                        dataItems = new tbl_UserFavouriteDeviceDetails();
                        isNew = true;
                    }

                    dataItems.ParentFavDevId = sessionData.FavDeviceId;
                    dataItems.SurgId = Helper.ToNullable<System.Int32>(Surgeon_DropDown.SelectedValue);
                    dataItems.CountryId = Helper.ToNullable<System.Int32>(Country_DropDown.SelectedValue);
                    dataItems.SiteId = SiteId;
                    if (isOpRev == false)
                    {
                        dataItems.OpStatus = 0;
                        dataItems.OpType = ProcId;
                    }
                    else
                    {
                        dataItems.OpStatus = 1;
                        dataItems.OpRevType = ProcId;
                    }
                    dataItems.CreatedBy = Session["Username"].ToString();
                    dataItems.CreatedDateTime = DateTime.Now;

                    dataItems.DevId = Helper.ToNullable<System.Int32>(PortFixDescription.SelectedValue);
                    //Defaulting to Port fixation
                    dataItems.DevType = Helper.ToNullable<System.Int32>(PortFixMethod.SelectedValue);
                    dataItems.DevBrand = Helper.ToNullable<System.Int32>(PortFixBrandName.SelectedValue);
                    dataItems.DevManuf = Helper.ToNullable<System.Int32>(PortFixManufacturer.SelectedValue);

                    dataItems.LastUpdatedBy = Session["Username"].ToString();
                    dataItems.LastUpdatedDateTime = DateTime.Now;

                    if (isNew)
                    {
                        favChildDeviceDetails.tbl_UserFavouriteDeviceDetailsRepository.Insert(dataItems);
                    }
                    else
                    {
                        favChildDeviceDetails.tbl_UserFavouriteDeviceDetailsRepository.Update(dataItems);
                    }
                    favChildDeviceDetails.Save();
                    returnValue = true;
                }
                catch (Exception ex)
                {
                    DisplayCustomMessageInValidationSummary(ex.Message, "DeviceDataValidationGroup");
                    returnValue = false;
                }
            }
            return returnValue;
        }
        /// <summary>
        /// checks if child exist or not
        /// </summary>
        /// <returns>if child Exists and Delete</returns>
        protected bool CheckIfChildExistsAndDelete()
        {
            Boolean returnValue = false;
            try
            {
                using (UnitOfWork favChildDeviceDetails = new UnitOfWork())
                {
                    SessionData sessionData = GetSessionData();
                    tbl_UserFavouriteDeviceDetails dataItem = favChildDeviceDetails.tbl_UserFavouriteDeviceDetailsRepository.Get(x => x.ParentFavDevId == sessionData.FavDeviceId).FirstOrDefault();
                    if (dataItem != null)
                    {
                        favChildDeviceDetails.tbl_UserFavouriteDeviceDetailsRepository.Delete(dataItem);
                        favChildDeviceDetails.Save();
                    }
                }
                returnValue = true;
            }
            catch (Exception ex)
            {
                DisplayCustomMessageInValidationSummary(ex.Message, "SurgeryDataValidationGroup");
                returnValue = false;
            }
            return returnValue;
        }
        #endregion
    }
}