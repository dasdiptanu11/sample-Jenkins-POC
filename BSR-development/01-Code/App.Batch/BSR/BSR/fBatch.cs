using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Net;
using System.Net.Mail;
using BSR.Shared;
using App.Business;


namespace BSR
{
    public partial class fBatch : Form
    {
        public fBatch()
        {
            InitializeComponent();
        }

        public bool GenerateFollowUpMails()
        {

            bool FollowUpMailsGenerated = false;
            try
            {
                string emailFrom = Constants.EMAIL_FROM_ADD;
                string subject = "Bariatric Surgery Registry (BSR): Follow up Alert " + DateTime.Now;
                string body = "No follow ups due";

                IEnumerable<FollowUpEmailDetails> PendingFollowUpList = null;
                using (UnitOfWork b1 = new UnitOfWork())
                {
                    PendingFollowUpList = b1.FollowUpRepository.GetPendingFollowUpDetails().OrderBy(x => x.SurgeonName);
                }

                
                if (PendingFollowUpList.Count() > 0 )
                {
                    XL_Utility.createXL(PendingFollowUpList); /* Creating XL */

                    IEnumerable<string> SurgeonList = PendingFollowUpList.Select(x => x.SurgeonName).Distinct();
                    foreach (string Surgeon in SurgeonList)
                    {
                        body = "";
                        IEnumerable<FollowUpEmailDetails> FollowUpsForSurgeon = PendingFollowUpList.Where(x => x.SurgeonName == Surgeon);
                        bool EmailSent = false;
                        bool tempEmailSent = false;
                        /*EMAIL Request from Dianne, to disabled the email functionality*/
                        body = "*****           This is an TEST MAIL - PLEASE IGNORE automatic email, please do not reply directly to this email.         *****";
                        //body = body + "<br/><br/>" + "Dear " + Surgeon + "<br/><br/>" + "The Bariatric Surgery Registry would like to inform you that the following patients are due for follow up." + "<br/><br/>" + "Follow up(s) due for:<br/>";
                        
                        //foreach (FollowUpEmailDetails PendingFollowUp in FollowUpsForSurgeon)
                        //{                            
                        //    body = body + "<br/>" + PendingFollowUp.PatientTitle + " " + PendingFollowUp.PatientFirstName + " " + PendingFollowUp.PatientLastName +" ("+ PendingFollowUp.URNo+") " + PendingFollowUp.FUPeriodDescrition;
                        //}
                        //body = body + "<br/><br/><br/>" + "Please go to https://bsr.registry.org.au/ and log in. You can search the above patient(s) using their UR number and fill in the necessary information.";
                        //body = body + "<br/><br/><br/>" + "NOTE: If your patient has had a subsequent bariatric procedure within 90 days then disregard this email.<br/>";
                        //body = body + "If there is a data collector at the public hospital(s) at which you work, " + 
                        //           " we will send an email to that data collector reminding them of the need to provide the follow up for any public patient listed above." +
                        //           "<br/>If, however, you have seen this public patient in your own rooms, please supply the follow up details through the BSR-i.";

                        //body = body + "<br/><br/><br/>Please contact Bariatric Surgery Registry (BSR) Administrator at <b>med-bsr@monash.edu</b> should you require further assistance.";
                        //body = body + "<br/><br/><br/>Best regards,<br/>Bariatric Surgery Registry (BSR)";


                        //EmailSent = MailUtility.SendEmail(FollowUpsForSurgeon.FirstOrDefault().SurgeonEmailAddress, emailFrom, subject, body);
                        EmailSent = MailUtility.SendEmail("cidmu.services@monash.edu", emailFrom, subject, body);
                       
                        //EmailSent = MailUtility.SendEmail("jigyasa.sharma@monash.edu", emailFrom, subject, body);
                        if (EmailSent)
                        {

                            using (UnitOfWork b1 = new UnitOfWork())
                            {
                                foreach (FollowUpEmailDetails FollowUpMailsent in FollowUpsForSurgeon)
                                {
                                    tbl_FollowUp followUpRec = b1.FollowUpRepository.Get(x => x.FUId == FollowUpMailsent.FUId).FirstOrDefault();
                                    followUpRec.EmailSentToSurg = 1;
                                    followUpRec.LastUpdatedBy = Constants.BATCH_USER;
                                    followUpRec.LastUpdatedDateTime = System.DateTime.Now;
                                    b1.tbl_FollowUpRepository.Update(followUpRec);
                                }
                                b1.Save();
                            }                            
                        }

                        using (UnitOfWork b1 = new UnitOfWork())
                        {

                            tbl_HistoryEmail emailHistory = new tbl_HistoryEmail();
                            emailHistory.EmailFrom = emailFrom;
                            emailHistory.EmailTo = FollowUpsForSurgeon.FirstOrDefault().SurgeonEmailAddress;
                            emailHistory.EmailCC = "";
                            emailHistory.EmailBcc = "";
                            emailHistory.Subject = subject;
                            emailHistory.Body = body;
                            emailHistory.TimeStamp = DateTime.Today;
                            emailHistory.Status = EmailSent == true ? "Email Sent" : "Email Not Sent";
                            b1.tbl_HistoryEmailRepository.Insert(emailHistory);
                            b1.Save();
                        }

                        //Cidmu email
                        try
                        {
                            tempEmailSent = MailUtility.SendEmail("cdms.services@monash.edu", emailFrom, subject, body);
                        }
                        catch (Exception ex)
                        {
                            LogErrors.logError(ex.Message);
                        }
                    }
                    FollowUpMailsGenerated = true;
                }
            }
            catch (Exception ex)
            {
                LogErrors.logError(ex.Message);
            }

            return FollowUpMailsGenerated;

        }



    }
}
