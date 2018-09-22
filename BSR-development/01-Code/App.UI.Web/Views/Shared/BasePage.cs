using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.Security;
using Telerik.Web.UI;
using System.Reflection;
using System.IO;
using App.Business;
using System.Text;
using log4net;
using Microsoft.Reporting.WebForms;

namespace App.UI.Web.Views.Shared
{
    public abstract class BasePage : Page
    {
        /// <summary>
        /// Logger for Logging purpose
        /// </summary>
        protected static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        // Helper instance
        private Helper _helper;

        /// <summary>
        /// Helper class instance
        /// </summary>
        protected Helper Helper
        {
            get { return _helper; }
            set { _helper = value; }
        }

        /// <summary>
        /// Helper method - before page initialization
        /// </summary>
        /// <param name="e">Event Arguments</param>
        protected override void OnPreInit(EventArgs e)
        {
            Helper = new Helper();

            base.OnPreInit(e);
        }

        /// <summary>
        /// Get the config setting value from the config file
        /// </summary>
        /// <param name="key">Config key name for which value is needed</param>
        /// <returns>Config setting value</returns>
        protected String GetApplicationConfigValue(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }


        /// <summary>
        /// Populate the Data to the control
        /// </summary>
        /// <param name="controlMapping">Dictionary for control and it's value mapping</param>
        public void PopulateControl(Dictionary<System.Web.UI.Control, Object> controlMapping)
        {
            if (controlMapping != null)
            {
                if (controlMapping.Count() > 0)
                {
                    foreach (var key in controlMapping.Keys)
                    {
                        System.Web.UI.Control control = key;
                        // get the data
                        Object dataValue = controlMapping[key];

                        if (controlMapping[key] != null)
                        {
                            // if we have corresponding not null data 
                            if (control.GetType() == typeof(TextBox))
                            {
                                ((TextBox)control).Text = dataValue.ToString();
                            }
                            if (control.GetType() == typeof(CheckBox))
                            {
                                ((CheckBox)control).Checked = dataValue.ToString() == "True" ? true : false;

                            }
                            else if (control.GetType() == typeof(CheckBoxList))
                            {
                                ((CheckBoxList)control).SelectedValue = dataValue.ToString();
                            }
                            else if ((control.GetType() == typeof(RadMaskedTextBox)))
                            {
                                ((RadMaskedTextBox)control).Text = dataValue.ToString();
                            }
                            else if (control.GetType() == typeof(Label))
                            {
                                ((Label)control).Text = dataValue.ToString();
                            }
                            else if (control.GetType() == typeof(RadTextBox))
                            {
                                ((RadTextBox)control).Text = dataValue.ToString();
                            }
                            else if (control.GetType() == typeof(RadNumericTextBox))
                            {
                                ((RadNumericTextBox)control).Text = dataValue.ToString();
                            }
                            else if (control.GetType() == typeof(DropDownList))
                            {
                                ((DropDownList)control).SelectedValue = dataValue.ToString();
                            }
                            else if (control.GetType() == typeof(RadComboBox))
                            {
                                ((RadComboBox)control).SelectedValue = dataValue.ToString();
                            }
                            else if (control.GetType() == typeof(RadSlider))
                            {
                                ((RadSlider)control).Value = Decimal.Parse(dataValue.ToString());
                            }
                            else if (control.GetType() == typeof(RadDatePicker))
                            {
                                ((RadDatePicker)control).SelectedDate = Convert.ToDateTime(dataValue);
                            }
                            else if (control.GetType() == typeof(RadioButtonList))
                            {
                                ((RadioButtonList)control).Items.FindByValue(dataValue.ToString()).Selected = true;
                            }
                            else if (control.GetType() == typeof(LinkButton))
                            {
                                ((LinkButton)control).Text = dataValue.ToString();
                            }
                            else if (control.GetType() == typeof(HyperLink))
                            {
                                ((HyperLink)control).Text = dataValue.ToString();
                            }

                        }
                        if (controlMapping[key] == null)
                        {
                            if (control.GetType() == typeof(TextBox))
                            {
                                ((TextBox)control).Text = string.Empty;
                            }
                            if (control.GetType() == typeof(CheckBox))
                            {
                                ((CheckBox)control).Checked = false;
                            }
                            else if ((control.GetType() == typeof(RadMaskedTextBox)))
                            {
                                ((RadMaskedTextBox)control).Text = string.Empty;
                            }
                            else if (control.GetType() == typeof(Label))
                            {
                                ((Label)control).Text = string.Empty;
                            }
                            else if (control.GetType() == typeof(RadTextBox))
                            {
                                ((RadTextBox)control).Text = string.Empty;
                            }
                            else if (control.GetType() == typeof(RadNumericTextBox))
                            {
                                ((RadNumericTextBox)control).Text = string.Empty;
                            }
                            else if (control.GetType() == typeof(DropDownList))
                            {
                                ((DropDownList)control).SelectedValue = string.Empty;
                            }
                            else if (control.GetType() == typeof(RadComboBox))
                            {
                                ((RadComboBox)control).SelectedValue = string.Empty;
                            }
                            else if (control.GetType() == typeof(RadSlider))
                            {
                                ((RadSlider)control).Value = 0;
                            }
                            else if (control.GetType() == typeof(RadDatePicker))
                            {
                                ((RadDatePicker)control).SelectedDate = null;
                            }
                            else if (control.GetType() == typeof(RadioButtonList))
                            {
                                ((RadioButtonList)control).ClearSelection();
                            }
                            else if (control.GetType() == typeof(LinkButton))
                            {
                                ((LinkButton)control).Text = string.Empty;
                            }
                            else if (control.GetType() == typeof(HyperLink))
                            {
                                ((HyperLink)control).Text = string.Empty;
                            }
                        }
                    }

                }
            }
        }

        /// <summary>
        /// Disable controls on base page except Next and Back button
        /// </summary>
        /// <param name="parent">Container for the controls which needs to be enabled or disabled</param>
        protected void EnableControls(System.Web.UI.Control parent, bool state)
        {
            foreach (System.Web.UI.Control control in parent.Controls)
            {
                if (control is DropDownList)
                {
                    ((DropDownList)(control)).Enabled = state;
                }
                else if (control is TextBox)
                {
                    ((TextBox)control).Enabled = state;
                }
                else if (control is Button)
                {
                    Button button = control as Button;

                    // Don't disable next and back buttons
                    if (button.ID != null && !button.ID.Equals("btnUnValidate")
                        && !button.ID.Equals("btnSave") && !button.ID.Equals("btnSaveDraft") && !button.ID.Equals("btnReset"))
                    {
                        ((Button)control).Enabled = state;
                    }
                }
                else if (control is RadioButton)
                {
                    ((RadioButton)control).Enabled = state;
                }
                else if (control is RadioButtonList)
                {
                    ((RadioButtonList)control).Enabled = state;
                }
                else if (control is ImageButton)
                {
                    ((ImageButton)control).Enabled = state;
                }
                else if (control is CheckBox)
                {
                    ((CheckBox)control).Enabled = state;
                }
                else if (control is CheckBoxList)
                {
                    ((CheckBoxList)control).Enabled = state;
                }
                else if (control is DropDownList)
                {
                    ((DropDownList)control).Enabled = state;
                }
                else if (control is RadNumericTextBox)
                {
                    ((RadNumericTextBox)control).Enabled = state;
                    if (state == false)
                    {
                        ((RadNumericTextBox)control).ForeColor = System.Drawing.ColorTranslator.FromHtml("#969696");
                    }
                    else
                    {
                        ((RadNumericTextBox)control).ForeColor = System.Drawing.Color.Black;
                    }
                }
                else if (control is RadDatePicker)
                {
                    ((RadDatePicker)control).Enabled = state;
                }
                else if (control is RadMaskedTextBox)
                {
                    ((RadMaskedTextBox)control).Enabled = state;
                }
                else if (control is RadTextBox)
                {
                    ((RadTextBox)control).Enabled = state;
                }
                else if (control is RadComboBox)
                {
                    ((RadComboBox)control).Enabled = state;
                }
                else if (control is RadButton)
                {
                    RadButton button = control as RadButton;
                    if (button.ButtonType == RadButtonType.ToggleButton && button.ToggleType == ButtonToggleType.CheckBox)
                    {
                        ((RadButton)control).Enabled = state;
                    }
                }

                EnableControls(control, state);
            }
        }

        #region SessionData
        /// <summary>
        /// Gets Session Data instance
        /// </summary>
        /// <returns>Return Session Data instance</returns>
        public SessionData GetSessionData()
        {
            SessionData sessionData = null;
            Object sessionObject = Session[Constants.SESSION_DATA_KEY];

            if (sessionObject != null)
            {
                sessionData = (SessionData)sessionObject;
            }
            else
            {
                if (IsSurgeon || IsDataCollector)
                {
                    Response.Redirect(Constants.URL_SUCCESSFUL_LOGIN_FOR_SURGEON_N_DATACOLLECTORS);
                }
                else
                {
                    Response.Redirect(Properties.Resource2.PatientSearchPath);
                }

                return new SessionData();
            }

            return sessionData;
        }

        /// <summary>
        /// Gets or Creates a Session Data instance
        /// </summary>
        /// <returns>Returns Session data instance</returns>
        protected SessionData GetDefaultSessionData()
        {
            SessionData sessionData = null;
            Object sessionObject = Session[Constants.SESSION_DATA_KEY];

            if (sessionObject != null)
            {
                sessionData = (SessionData)sessionObject;
            }
            else
            {
                return new SessionData();
            }

            return sessionData;
        }
        #endregion

        /// <summary>
        /// Saving Session Data instance in session variable
        /// </summary>
        /// <param name="sessionData"></param>
        protected void SaveSessionData(SessionData sessionData)
        {
            Session[Constants.SESSION_DATA_KEY] = sessionData;
        }

        /// <summary>
        /// Gets User Name
        /// </summary>
        protected string UserName
        {
            get { return User.Identity.Name; }
        }

        /// <summary>
        /// Gets a flag which indicates whether user is administrator or not
        /// </summary>
        protected bool IsAdministrator
        {
            get
            {
                using (UnitOfWork userRepository = new UnitOfWork())
                {
                    return userRepository.MembershipRepository.IsAdministrator(UserName);
                }
            }
        }

        /// <summary>
        /// Gets a flag which indicates whether user is centralized administrator or not
        /// </summary>
        protected bool IsAdminCentral
        {
            get
            {
                using (UnitOfWork userRepository = new UnitOfWork())
                {
                    return userRepository.MembershipRepository.IsAdminCentral(UserName);
                }
            }
        }

        /// <summary>
        /// Gets a flag which indicates whether user is a Data Collector or not
        /// </summary>
        protected bool IsDataCollector
        {
            get
            {
                using (UnitOfWork userRepository = new UnitOfWork())
                {
                    return userRepository.MembershipRepository.IsDataCollector(UserName);
                }
            }
        }

        /// <summary>
        /// Gets a flag which indicates whether user is a Follow Up Staff or not
        /// </summary>
        protected bool IsFollowUpStaff
        {
            get
            {
                using (UnitOfWork userRepository = new UnitOfWork())
                {
                    return userRepository.MembershipRepository.IsFollowUpStaff(UserName);
                }
            }
        }

        /// <summary>
        /// Gets a flag which indicates whether user is Surgeon or not
        /// </summary>
        protected bool IsSurgeon
        {
            get
            {
                using (UnitOfWork userRepository = new UnitOfWork())
                {
                    return userRepository.MembershipRepository.IsSurgeon(UserName);
                }
            }
        }

        /// <summary>
        /// Gets User Id for the User Name
        /// </summary>
        /// <param name="Username">User Name for whome User Id is needed</param>
        /// <returns>Returns User Id for a user</returns>
        public string GetUserId(String Username)
        {
            {
                using (UnitOfWork userRepository = new UnitOfWork())
                {
                    return userRepository.MembershipRepository.GetUserId(Username);
                }
            }
        }

        /// <summary>
        /// Display message in validation summary control
        /// </summary>
        /// <param name="message">message to be displayed to the user</param>
        protected void ShowMessageInValidationSummary(string message)
        {
            CustomValidator customValidator = new CustomValidator();
            customValidator.IsValid = false;
            customValidator.ErrorMessage = message;
            this.Page.Validators.Add(customValidator);
        }

        /// <summary>
        /// Convert a Datetime into Local timezone
        /// </summary>
        /// <param name="dateTime">Datetime object which needs to be Converted in Local time zone</param>
        /// <returns>Local timezone DataTime</returns>
        protected DateTime? GetLocalDateTime(DateTime? dateTime)
        {
            return dateTime.HasValue ? dateTime.Value.AddMinutes(-TimezoneOffset) : (DateTime?)null;
        }

        // Gets Timezone Offset value
        private int TimezoneOffset
        {
            get
            {
                SessionData sessionData = null;

                if (Session[Constants.SESSION_DATA_KEY] != null)
                {
                    sessionData = (SessionData)Session[Constants.SESSION_DATA_KEY];
                    return sessionData.ClientTimezoneOffset;
                }

                return 0;
            }
        }

        /// <summary>
        /// Restricting Grid options
        /// </summary>
        /// <param name="grid">Grid on which some restriction needs to be added</param>
        protected void RestrictRadGridFilterOptions(RadGrid grid)
        {
            GridFilterMenu menu = grid.FilterMenu;
            int index = 0;
            while (index < menu.Items.Count)
            {
                if (menu.Items[index].Text == "NoFilter" || menu.Items[index].Text == "Contains" ||
                    menu.Items[index].Text == "StartsWith" || menu.Items[index].Text == "EqualTo" || menu.Items[index].Text == "NotEqualTo")
                {
                    index++;
                }
                else
                {
                    menu.Items.RemoveAt(index);
                }
            }
        }

        /// <summary>
        /// Modules by 11 validation
        /// </summary>
        /// <param name="number">Number to be validated</param>
        /// <returns>Return boolean flag which indicates the status of validation</returns>
        protected Boolean ValidateNumberMod11(int number)
        {
            string stringNumber = number.ToString();
            int validateSum = 0;
            for (int i = 0; i < stringNumber.Length; i++)
            {
                validateSum = validateSum + Convert.ToInt32(stringNumber.Substring(i, 1)) * (stringNumber.Length - i);
            }

            if (validateSum % 11 == 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// Displaying Popup windows
        /// </summary>
        /// <param name="radWindow">Popup windows instance</param>
        protected void ShowWindow(RadWindow radWindow)
        {
            ((App.UI.Web.Views.Shared.SiteMaster)Master).WindowManager.Windows.Clear();
            ((App.UI.Web.Views.Shared.SiteMaster)Master).WindowManager.Windows.Add(radWindow);
        }

        /// <summary>
        /// Adding a Custom Validator dynamically
        /// </summary>
        /// <param name="message">Message to be displayed if validation fails</param>
        /// <param name="validationGroup">Validation group for the validator</param>
        protected void DisplayCustomMessageInValidationSummary(string message, string validationGroup = null)
        {
            if (this.Master != null)
            {
                ContentPlaceHolder contentPlaceHolder = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                CustomValidator customValidatorControl = new CustomValidator();
                customValidatorControl.IsValid = false;
                customValidatorControl.ErrorMessage = message;
                customValidatorControl.Text = "*";
                customValidatorControl.ValidationGroup = validationGroup;
                customValidatorControl.Visible = false;
                contentPlaceHolder.Controls.Add(customValidatorControl);
            }
        }

        /// <summary>
        /// Gets current logged in user Id
        /// </summary>
        /// <param name="userName">User Name for the current user Name</param>
        /// <returns>Returns current user logged in id</returns>
        protected int GetLoggedInUserId(string userName)
        {
            aspnet_Users user = null;
            int userId = 0;
            using (UnitOfWork userRepository = new UnitOfWork())
            {
                user = userRepository.aspnet_UsersRepository.Get(y => y.UserName == userName).FirstOrDefault();

                if (user != null)
                {
                    tbl_User tUser = userRepository.tbl_UserRepository.Get(x => x.UId == user.UserId).FirstOrDefault();
                    if (tUser != null)
                    {
                        userId = tUser.UserId;
                    }
                }
            }
            return userId;
        }

        #region Report
        /// <summary>
        /// Loading Report Rdlc dynamically
        /// </summary>
        /// <param name="reportViewer">Report Viewer control</param>
        /// <param name="rdlcFileName">Rdlc file name</param>
        protected void LoadReportDefinition(ReportViewer reportViewer, string rdlcFileName)
        {
            Assembly assembly = Assembly.Load("App.UI.Web, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null");
            Stream streamInstance = assembly.GetManifestResourceStream(string.Format("App.UI.Web.Views.Reports.{0}.rdlc", rdlcFileName));
            reportViewer.LocalReport.LoadReportDefinition(streamInstance);
        }
        #endregion

        #region Security
        /// <summary>
        /// Turning Auto complete for all the textbox control to false
        /// </summary>
        public void TurnTextBoxAutoCompleteOff()
        {
            List<System.Web.UI.Control> allControls = ListControlToArray(Page);
            foreach (System.Web.UI.Control control in allControls)
            {
                TextBox textBox = control as TextBox;
                if (textBox != null)
                {
                    textBox.Attributes.Add("autocomplete", "off");
                }
            }
        }

        /// <summary>
        /// Gets rhe list of controls from the parent container
        /// </summary>
        /// <param name="root">parent Container control</param>
        /// <returns>Returns list of controls in the parent control</returns>
        public static List<System.Web.UI.Control> ListControlToArray(System.Web.UI.Control root)
        {
            List<System.Web.UI.Control> listControls = new List<System.Web.UI.Control>();
            listControls.Add(root);
            if (root.HasControls())
            {
                foreach (System.Web.UI.Control control in root.Controls)
                {
                    listControls.AddRange(ListControlToArray(control));
                }
            }
            return listControls.ToList();
        }

        /// <summary>
        /// Getting Audit history for the User
        /// </summary>
        /// <param name="status">Status value</param>
        protected void ExtractAudit(String status)
        {
            using (UnitOfWork auditRepository = new UnitOfWork())
            {
                tbl_HistoryExtract dataItems = new tbl_HistoryExtract();
                dataItems.Username = UserName;
                dataItems.AttemptDateTime = System.DateTime.Now;
                dataItems.DataExtract = status;

                auditRepository.tbl_HistoryExtractRepository.Insert(dataItems);
                auditRepository.Save();
            }

        }
        #endregion
    }
}
