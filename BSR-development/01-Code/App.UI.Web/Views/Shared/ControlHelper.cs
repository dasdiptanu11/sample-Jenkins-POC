using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls;
using System.Web.UI;
using Telerik.Web.UI;
using System.Reflection;
using System.IO;
using App.Business;
using System.Text;
using log4net;

namespace App.UI.Web.Views.Shared
{
    public static class ControlHelper
    {
        /// <summary>
        /// Populate the Data to the control
        /// </summary>
        /// <param name="controlMapping">Dictionary for control and it's value mapping</param>
        public static void PopulateControl(Dictionary<System.Web.UI.Control, Object> controlMapping)
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

        #region SessionData
        /// <summary>
        /// Gets Session Data instance
        /// </summary>
        /// <returns>Return Session Data instance</returns>
        public static SessionData GetSessionData()
        {
            SessionData sessionData = null;
            Object sessionObject = HttpContext.Current.Session[Constants.SESSION_DATA_KEY];

            if (sessionObject != null)
            {
                sessionData = (SessionData)sessionObject;
            }

            return sessionData;
        }

        /// <summary>
        /// Saving Session Data instance in session variable
        /// </summary>
        /// <param name="sessionData"></param>
        public static void SaveSessionData(SessionData sessionData)
        {
            HttpContext.Current.Session[Constants.SESSION_DATA_KEY] = sessionData;
        }
        #endregion
    }
}