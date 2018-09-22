using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using Excel = Microsoft.Office.Interop.Excel;
using App.Business;
using WinSCP;
using System.IO;
using System.Configuration;



namespace BSR.Shared
{
    public class XL_Utility
    {

        public static bool createXL(IEnumerable<FollowUpEmailDetails> PendingFollowUpList)
        {
            bool retVal = false;
            Excel.Application xlApp = new Excel.Application();           
            
            string fileExtn = ConfigurationManager.AppSettings["xlFileExtn"];
            string xlFileName = "BSR_FU_Sent_" + "_" + DateTime.Now.ToShortDateString().Replace("/", "") + fileExtn;
            string filePath = ConfigurationManager.AppSettings["localXLFilePath"] + xlFileName;
            if (xlApp == null)
            {
                throw new ApplicationException("EXCEL could not be started. Check that your office installation and project references are correct.");
            }
            else
            {
                xlApp.Visible = true;

                Excel.Workbook xlWorkBook = xlApp.Workbooks.Add(Excel.XlWBATemplate.xlWBATWorksheet);
                Excel.Worksheet xlWorkSheet = (Excel.Worksheet)xlWorkBook.Worksheets[1];
                try
                {
                    if (xlWorkSheet == null)
                    {
                        throw new ApplicationException("Worksheet could not be created. Check that your office installation and project references are correct.");
                    }

                    //Header
                    xlWorkSheet.Cells[1, 1] = "OpID";
                    xlWorkSheet.Cells[1, 2] = "PatID";
                    xlWorkSheet.Cells[1, 3] = "Surgeon";
                    xlWorkSheet.Cells[1, 4] = "Surgeon Email";
                    xlWorkSheet.Cells[1, 5] = "Title";
                    xlWorkSheet.Cells[1, 6] = "First Name";
                    xlWorkSheet.Cells[1, 7] = "Last Name";
                    xlWorkSheet.Cells[1, 8] = "UR";
                    xlWorkSheet.Cells[1, 9] = "Hospital";
                    xlWorkSheet.Cells[1, 10] = "Hospital State";
                    xlWorkSheet.Cells[1, 11] = "OpDate";
                    xlWorkSheet.Cells[1, 12] = "OpType";
                    xlWorkSheet.Cells[1, 13] = "RevOpType";
                    xlWorkSheet.Cells[1, 14] = "FollowUpPeriodID";
                    xlWorkSheet.Cells[1, 15] = "DOB";
                    xlWorkSheet.Cells[1, 16] = "Gender";


                    int iXLRow = 2;
                    foreach (FollowUpEmailDetails fu in PendingFollowUpList)
                    {
                        xlWorkSheet.Cells[iXLRow, 1] = fu.OpId.ToString();
                        xlWorkSheet.Cells[iXLRow, 2] = fu.PatID;
                        xlWorkSheet.Cells[iXLRow, 3] = fu.SurgeonName.ToString();
                        xlWorkSheet.Cells[iXLRow, 4] = fu.SurgeonEmailAddress.ToString();                        
                        xlWorkSheet.Cells[iXLRow, 5] = fu.PatientTitle.ToString();
                        xlWorkSheet.Cells[iXLRow, 6] = fu.PatientFirstName.ToString();
                        xlWorkSheet.Cells[iXLRow, 7] = fu.PatientLastName.ToString();
                        xlWorkSheet.Cells[iXLRow, 8] = fu.URNo.ToString();
                        ////xlWorkSheet.Cells[iXLRow, 6] = fu.URNo;
                        xlWorkSheet.Cells[iXLRow, 9] = fu.FUPeriodDescrition.Remove(fu.FUPeriodDescrition.IndexOf("-"));
                        xlWorkSheet.Cells[iXLRow, 10] = fu.State;
                        xlWorkSheet.Cells[iXLRow, 11] = fu.OpDate ;
                        xlWorkSheet.Cells[iXLRow, 12] = fu.opType == null ? "" : fu.opType;
                        xlWorkSheet.Cells[iXLRow, 13] = fu.RevOpType == null ? "" : fu.RevOpType;
                        xlWorkSheet.Cells[iXLRow, 14] = fu.FUPeriodDescrition.Remove(0, fu.FUPeriodDescrition.IndexOf("-") - 1).Replace ("-","");
                        xlWorkSheet.Cells[iXLRow, 15] = fu.DOB;
                        xlWorkSheet.Cells[iXLRow, 16] = fu.Gender == null ? "" : fu.Gender.ToString();

                        iXLRow++;
                    }

                    xlWorkBook.SaveAs(filePath, Excel.XlFileFormat.xlWorkbookNormal);
                    //xlWorkBook.SaveAs("C:\\Projects\\test.xlxs");
                    //retVal = UploadToSFTP(filePath);
                    retVal = true;
                }

                catch (Exception ex)
                {
                    LogErrors.logError(ex.Message);
                }
                finally
                {
                    xlWorkBook.Close(true);
                    xlApp.Quit();
                    releaseObject(xlWorkSheet);
                    releaseObject(xlWorkBook);
                    releaseObject(xlApp);
                }
            }


            return retVal;
        }




        public static bool UploadToSFTP(string filePath)
        {

            bool retVal = false;

            string sftpFilePath = ConfigurationManager.AppSettings["sftpFilePath"];            

            try
            {
                SessionOptions sessionOptions = new SessionOptions
                {
                    Protocol = Protocol.Sftp,
                    HostName = ConfigurationManager.AppSettings["sftpHostName"],    //"130.194.20.62", //hostname e.g. IP: 192.54.23.32, or mysftpsite.com
                    UserName = ConfigurationManager.AppSettings["sftpUserName"],
                    Password = ConfigurationManager.AppSettings["sftpPassword"],
                    PortNumber = 22,
                    SshHostKeyFingerprint = ConfigurationManager.AppSettings["SshHostKeyFingerprint"]
                };
                using (Session session = new Session())
                {
                    
                    session.Open(sessionOptions); //Attempts to connect to your sFtp site
                    
                    //Get Ftp File
                    TransferOptions transferOptions = new TransferOptions();
                    transferOptions.TransferMode = TransferMode.Binary; //The Transfer Mode - <em style="font-size: 9pt;">Automatic, Binary, or Ascii  
                    transferOptions.FilePermissions = null; //Permissions applied to remote files; null for default permissions.  Can set user, Group, or other Read/Write/Execute permissions. 
                    transferOptions.PreserveTimestamp = false; //Set last write time of destination file to that of source file - basically change the timestamp to match destination and source files.   
                    transferOptions.ResumeSupport.State = TransferResumeSupportState.Off;

                    
                    TransferOperationResult transferResult;
                    transferResult = session.PutFiles(filePath, sftpFilePath, false, transferOptions); //the parameter list is: local Path, Remote Path, Delete source file?, transfer Options  
                    //Throw on any error 
                    transferResult.Check();
                    //Log information and break out if necessary  
                }

                retVal = true;
            }
            catch (Exception ex)
            {
                LogErrors.logError(ex.Message);
            }
            return retVal;

        }

        private static void releaseObject(object obj)
        {
            try
            {
                System.Runtime.InteropServices.Marshal.ReleaseComObject(obj);
                obj = null;
            }
            catch (Exception ex)
            {
                obj = null;
                //MessageBox.Show("Exception Occured while releasing object " + ex.ToString());
            }
            finally
            {
                GC.Collect();
            }
        }

    }


}
