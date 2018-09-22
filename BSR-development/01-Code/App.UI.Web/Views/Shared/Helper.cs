using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using System.ComponentModel;
using System.Web.UI;
using Telerik.Web.UI;

namespace App.Business
{
    public class Helper : System.Web.UI.Page
    {
        /// <summary>
        /// Binds the collection to control.
        /// </summary>
        /// <param name="control">List controls in which options has to be added</param>
        /// <param name="collection">List of options</param>
        /// <param name="dataValueField">Field for data value</param>
        /// <param name="dataTextField">Field for the text value</param>
        public void BindCollectionToControl(ListControl control, Object collection, string dataValueField, string dataTextField)
        {
            if (collection != null)
            {
                control.DataSource = collection;
                control.DataTextField = dataTextField;
                control.DataValueField = dataValueField;
                control.DataBind();
            }
        }

        /// <summary>
        /// Binds the collection to control.
        /// </summary>
        /// <param name="control">Control item container in which options has to be added</param>
        /// <param name="collection">List of options</param>
        /// <param name="dataValueField">Field for data value</param>
        /// <param name="dataTextField">Field for the text value</param>
        public void BindCollectionToControl(ControlItemContainer control, Object collection, string dataValueField, string dataTextField)
        {
            if (collection != null)
            {
                control.DataSource = collection;
                control.DataTextField = dataTextField;
                control.DataValueField = dataValueField;
                control.DataBind();
            }
        }

        /// <summary>
        /// Binds the collection to control.
        /// </summary>
        /// <param name="control">Auto Complete control in which options needs to be added</param>
        /// <param name="collection">List of options/values</param>
        /// <param name="dataValueField">Field for data value</param>
        /// <param name="dataTextField">Field for the text value</param>
        public void BindCollectionToControl(RadAutoCompleteBox control, Object collection, string dataValueField, string dataTextField)
        {
            if (collection != null)
            {
                control.DataSource = collection;
                control.DataTextField = dataTextField;
                control.DataValueField = dataValueField;
                control.DataBind();
            }
        }

        /// <summary>
        /// Convert To Nullable Type
        /// </summary>
        /// <typeparam name="type">Generic type</typeparam>
        /// <param name="stringType"></param>
        /// <returns>Returns Nullable type object</returns>
        public Nullable<type> ToNullable<type>(string stringType) where type : struct
        {
            Nullable<type> result = new Nullable<type>();
            try
            {
                if (!string.IsNullOrEmpty(stringType) && stringType.Trim().Length > 0)
                {
                    TypeConverter conv = TypeDescriptor.GetConverter(typeof(type));
                    result = (type)conv.ConvertFrom(stringType);
                }
            }
            catch { throw; }
            return result;
        }


        /// <summary>
        /// Convert String to Nullable
        /// </summary>
        /// <param name="stringValue">string value to be converted as nullable value</param>
        /// <returns>return string or null as per the passed parameter value</returns>
        public String ToNullable(string stringValue)
        {
            if (!string.IsNullOrEmpty(stringValue) && stringValue.Trim().Length > 0)
            {
                return stringValue;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Turning Auto Complete off in the Auto Complete textbox
        /// </summary>
        public void TurnTextBoxAutoCompleteOff()
        {
            List<System.Web.UI.Control> allControls = GetListOfControlsFromContainer(Page);
            foreach (System.Web.UI.Control control in allControls)
            {
                TextBox textboxControl = control as TextBox;
                if (textboxControl != null)
                {
                    textboxControl.Attributes.Add("autocomplete", "off");
                }
            }
        }

        /// <summary>
        /// Get the list of Control from the container
        /// </summary>
        /// <param name="root">container from which controls needs to be listed</param>
        /// <returns>List of controls of the container</returns>
        public List<System.Web.UI.Control> GetListOfControlsFromContainer(System.Web.UI.Control root)
        {
            List<System.Web.UI.Control> listControl = new List<System.Web.UI.Control>();
            listControl.Add(root);
            if (root.HasControls())
            {
                foreach (System.Web.UI.Control control in root.Controls)
                {
                    listControl.AddRange(GetListOfControlsFromContainer(control));
                }
            }

            return listControl.ToList();
        }
    }
}
