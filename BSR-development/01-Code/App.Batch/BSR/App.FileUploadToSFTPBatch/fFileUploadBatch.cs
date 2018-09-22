using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using BSR.Shared;

namespace BSR
{
    public partial class fFileUploadBatch : Form
    {
        public fFileUploadBatch()
        {
            InitializeComponent();
        }
        public bool uploadFileToSFTP()
        {
            bool retVal = false;
            retVal = FileUploadUtility.UploadToSFTP();
            return retVal;
        }
    }
}
