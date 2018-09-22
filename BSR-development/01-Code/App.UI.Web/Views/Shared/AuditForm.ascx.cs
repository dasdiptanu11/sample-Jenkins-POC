using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App.UI.Web.Views.Forms {
    public partial class AuditForm : System.Web.UI.UserControl {
        /// <summary>
        /// Gets or sets Audit controls visibility
        /// </summary>
        public bool ShowAuditForm {
            get { return FormContainer.Visible; }
            set { FormContainer.Visible = value; }
        }

        /// <summary>
        /// Sets Modified by - Which is being displayed in the Audit form
        /// </summary>
        public string ModifiedBy {
            private get { return SubmittedBy.Text; }
            set { SubmittedBy.Text = value; }
        }

        /// <summary>
        /// Sets Modified Datetime - Which is being displayed in the Audit form
        /// </summary>
        public DateTime? ModifiedDateTime {
            set { SubmittedDate.Text = string.Format("{0:dd/MM/yyyy HH:mm}", value); }
        }

        public void ReloadData() {
            SubmittedDate.Text = SubmittedDate.Text;
            SubmittedBy.Text = ModifiedBy;
        }

        protected void Page_Load(object sender, EventArgs e) {
            ReloadData();
        }


        public UpdatePanelUpdateMode UpdateMode {
            get {
                return AuditUpdatePanel.UpdateMode;
            }
            set {
                AuditUpdatePanel.UpdateMode = value;
            }
        }

        public void Update() {
            AuditUpdatePanel.Update();
        }

    }
}