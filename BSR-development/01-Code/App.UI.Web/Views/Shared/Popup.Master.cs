using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using App.UI.Web.Views.Shared;

namespace App.UI.Web.Views.Shared
{
    public partial class Popup : System.Web.UI.MasterPage
    {
        /// <summary>
        /// Adjusting timezone offset whenever timezone option selection has changed
        /// </summary>
        /// <param name="sender">Timezone control as sender</param>
        /// <param name="e">Event Arguments</param>
        protected void TimezoneOffsetPopupControl_ValueChanged(object sender, EventArgs e)
        {
            int timezoneOffset = 0;
            string offset = TimezoneOffsetPopupControl.Value;
            SessionData sessionData = null;

            if (Session[Constants.SESSION_DATA_KEY] != null)
            {
                sessionData = (SessionData)Session[Constants.SESSION_DATA_KEY];
            }
            else
            {
                sessionData = new SessionData();
                sessionData.ClientTimezoneOffset = 0;
                Session[Constants.SESSION_DATA_KEY] = sessionData;
            }

            if (offset != null)
            {
                try
                {
                    timezoneOffset = Int32.Parse(offset);
                    sessionData.ClientTimezoneOffset = timezoneOffset;
                    Session[Constants.SESSION_DATA_KEY] = sessionData;
                }
                catch (Exception ex)
                {

                }
            }
        }
    }
}
