using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App.UI.Web.Views.Shared {
    public partial class ContentHeader : BaseUserControl {
        /// <summary>
        /// Gets or sets the Title of the Page
        /// </summary>
        public string Title {
            get { return PageHeader.InnerText; }
            set { PageHeader.InnerText = value; }
        }

        public UpdatePanelUpdateMode UpdateMode {
            get {
                return ContentHeaderUpdatePanel.UpdateMode;
            }
            set {
                ContentHeaderUpdatePanel.UpdateMode = value;
            }
        }

        public void Update() {
            ContentHeaderUpdatePanel.Update();
        }
    }
}