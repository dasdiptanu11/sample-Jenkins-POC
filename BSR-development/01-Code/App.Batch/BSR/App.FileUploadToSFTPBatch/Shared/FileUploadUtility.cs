using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.IO;
using System.Configuration;
using WinSCP;


namespace BSR.Shared
{
    public class FileUploadUtility
    {
        public static bool UploadToSFTP()
        {

            bool retVal = false;
            string fileExtn = ConfigurationManager.AppSettings["xlFileExtn"];
            string xlFileName = "BSR_FU_Sent_" + "_" + DateTime.Now.ToShortDateString().Replace("/", "") + fileExtn;
            string filePath = ConfigurationManager.AppSettings["localXLFilePath"] + xlFileName;

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
    }
}
