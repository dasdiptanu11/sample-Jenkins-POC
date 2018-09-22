using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace BSR
{
    static class BSRBatch
    {
        /// The main entry point for the application.
        [STAThread]
        static void Main()
        {

            fBatch lofBatch = new fBatch();
            Application.EnableVisualStyles();            
            lofBatch.GenerateFollowUpMails();
        }
    }
}
