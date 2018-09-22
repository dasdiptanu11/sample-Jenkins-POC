using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Net.Mail;

namespace BSR.Shared
{
    static public class MailUtility
    {
        static public bool SendEmail(string emailTo, string emailFrom, string subject, string body)
        {
            bool MailSent = false;
            try
            {
                string smtpAddress = "smtp.monash.edu.au";
                bool enableSSL = false;

                using (MailMessage mail = new MailMessage())
                {
                    mail.From = new MailAddress(emailFrom);
                    mail.To.Add(emailTo);
                    //mail.Bcc.Add("cidmu.services@monash.edu");
                    mail.Subject = subject;
                    mail.Body = body;
                    mail.IsBodyHtml = true;

                    // Can set to false, if you are sending pure text.
                    //mail.Attachments.Add(new Attachment("C:\\SomeFile.txt"));
                    //mail.Attachments.Add(new Attachment("C:\\SomeZip.zip"));

                    using (SmtpClient smtp = new SmtpClient(smtpAddress))
                    {                      
                        smtp.EnableSsl = enableSSL;
                        smtp.Send(mail);
                    }
                }
                MailSent = true;
            }
            catch (Exception ex)
            {
                logError(ex.Message);
            }

            return MailSent;
        }

        static public void logError(string errMsg)
        {

        }
    }
}
