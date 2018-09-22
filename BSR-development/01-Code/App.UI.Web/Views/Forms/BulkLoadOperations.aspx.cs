using App.Business;
using App.UI.Web.Views.Shared;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App.UI.Web.Views.Forms
{
    public partial class BulkLoadOperations : BasePage
    {
        //Patient Ids list
        private IEnumerable<int> _patientIds;

        // site ids list
        private IEnumerable<int> _siteIds;

        //surgeon ids list
        private IEnumerable<int> _surgeonIds;

        //Mapped Proc ids list
        private IEnumerable<int> _mappedProcIds;

        // invalid data table
        private DataTable _invalidTable;

        // processed record count
        private int _countRecord = 0;

        //existing record count
        private int _countExistingRecord = 0;

        /// <summary>
        /// This method is to handle page level events
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!(IsPostBack))
            {
                ExistingRecordGrid.Visible = false;
                BulkLoadGrid.Visible = false;
            }
        }

        /// <summary>
        /// Method created to upload and validate file
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void BulkUpload_Click(object sender, EventArgs e)
        {
            int rowNumber = 1;
            DataTable csvData;
            if (ValidateCSVFile())
            {
                string filePath = Server.MapPath("~/") + Path.GetFileName(UploadFile.PostedFile.FileName);
                try
                {
                    UploadFile.SaveAs(filePath);
                    _patientIds = GetPatientIds();
                    _siteIds = GetSiteIds();
                    _surgeonIds = GetSurgeonIds();
                    _mappedProcIds = GetMappedProcIds();
                    //read and validate csv file
                    csvData = GetData(filePath);
                    // Add a rowNumber 
                    csvData.Columns.Add("Row No", typeof(int)).SetOrdinal(0);
                    foreach (DataRow row in csvData.Rows)
                    {
                        row["Row No"] = rowNumber;
                        rowNumber++;
                    }
                    DataTable validatedTable = ValidateRows(csvData);

                    if (validatedTable.Rows.Count > 0)
                    {
                        Session["opTable"] = validatedTable;
                        BulkLoadGrid.DataSource = (DataTable)Session["opTable"];
                        BulkLoadGrid.DataBind();
                        BulkLoadGrid.Visible = true;
                        InvalidCsv.Visible = true;
                        ExistingRecordGrid.Visible = false;
                        ExistingRecord.Visible = false;
                        LoadedRecord.Visible = false;
                        ErrorMessage.Visible = false;
                        InvalidCsv.Text = "The .csv file has not been processed. Please correct the below rows in the .csv file so that they meet the appropriate validation rules and then upload again." + "<br />";
                    }
                    else
                    {
                        DataTable exitingRecord = UploadRecords(csvData);
                        if (exitingRecord.Rows.Count > 0)
                        {
                            Session["existingTable"] = exitingRecord;
                            ExistingRecordGrid.DataSource = (DataTable)Session["existingTable"];
                            ExistingRecordGrid.DataBind();
                            BulkLoadGrid.Visible = false;
                            ExistingRecord.Visible = true;
                            ExistingRecordGrid.Visible = true;
                            InvalidCsv.Visible = false;
                            LoadedRecord.Visible = false;
                            ErrorMessage.Visible = false;
                            ExistingRecord.Text = "Below operations are already exists";
                        }
                        if (_countRecord > 0)
                        {
                            LoadedRecord.Visible = true;
                            BulkLoadGrid.Visible = false;

                            InvalidCsv.Visible = false;
                            ErrorMessage.Visible = false;
                            LoadedRecord.Text = "The records from the .csv file have been uploaded successfully.";
                            if (_countExistingRecord > 0)
                            {
                                ExistingRecordGrid.Visible = true;
                                ExistingRecord.Visible = true;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    DisplayCustomMessage(ex.Message.ToString());
                }
                finally
                {
                    //delete uploaded file
                    if (File.Exists(filePath))
                    {
                        File.Delete(filePath);
                    }
                }
            }
        }

        //validate csv file
        private bool ValidateCSVFile()
        {
            bool isFileValid = true;
            ErrorMessage.Visible = true;
            int fileSize = Convert.ToInt32(ConfigurationManager.AppSettings[Constants.APP_CONFIG_KEY_MAX_BULK_LOAD_FILE_SIZE]);
            if (UploadFile.HasFile)
            {
                //check file extension
                string extension = System.IO.Path.GetExtension(UploadFile.PostedFile.FileName);
                if (!(string.Equals(extension, ".csv", StringComparison.OrdinalIgnoreCase)))
                {
                    ErrorMessage.Text = "The file type is invalid, please upload a .csv file.";
                    HideControls();
                    isFileValid = false;
                }
                //check file size
                else if (!(UploadFile.PostedFile.ContentLength < fileSize))
                {
                    isFileValid = false;
                    ErrorMessage.Text = "The file uploaded exceeds 10MB, the maximum file size set by the site administrators. Please upload a smaller file or contact the system administrators to increase the file size.";
                    HideControls();
                }
            }
            else
            {
                isFileValid = false;
                ErrorMessage.Text = "Please upload file to proceed.";
                HideControls();
            }
            return isFileValid;
        }

        //gets data into table from csv file
        private DataTable GetData(string fileContent)
        {
            //read csv file
            DataTable dataTable = new DataTable();
            using (StreamReader reader = new StreamReader(fileContent))
            {
                string[] headers = reader.ReadLine().Split(',');
                foreach (string header in headers)
                {
                    dataTable.Columns.Add(header);
                }
                while (!reader.EndOfStream)
                {
                    string[] csvRow = reader.ReadLine().Split(',');
                    DataRow dataRow = dataTable.NewRow();
                    for (int i = 0; i < headers.Length; i++)
                    {
                        dataRow[i] = csvRow[i];
                    }
                    dataTable.Rows.Add(dataRow);
                }
            }
            return dataTable;
        }

        //validate fields of csv
        private DataTable ValidateRows(DataTable csvDataTable)
        {
            _invalidTable = csvDataTable.Clone();
            string id = string.Empty;
            string hospitalId = string.Empty;
            // Loop over all the rows in the datatable
            foreach (DataRow row in csvDataTable.Rows)
            {
                bool isInvalid = false;
                string opDate = null;
                string adDate = null;
                string DisDate = null;
                string hospId = row["Hosp"].ToString();
                foreach (DataColumn column in csvDataTable.Columns)
                {
                    switch (column.ColumnName.ToLower())
                    {
                        case "patientid":
                            id = row["PatientID"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                if (IsNumeric(id))
                                {
                                    if (!(PatientIdValidation(id)))
                                    {
                                        isInvalid = true;
                                        row["PatientID"] = "Patient ID is not valid";
                                    }
                                }
                            }
                            else
                            {
                                isInvalid = true;
                                row["PatientID"] = "Must be filled";
                            }
                            break;

                        case "hosp":
                            id = row["Hosp"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                if (IsNumeric(id))
                                {
                                    if (!(SiteIdValidation(id)))
                                    {
                                        isInvalid = true;
                                        row["Hosp"] = "Hospital ID is not valid";
                                    }
                                }
                                else
                                {
                                    isInvalid = true;
                                    row["Hosp"] = "Only numbers allowed";
                                }
                            }
                            else
                            {
                                isInvalid = true;
                                row["Hosp"] = "Must be filled";
                            }
                            break;

                        case "surg":
                            id = row["Surg"].ToString();
                            if (!(string.IsNullOrWhiteSpace(id)))
                            {
                                if (IsNumeric(id))
                                {
                                    if ((SurgeonIdValidation(id)))
                                    {
                                        if (IsNumeric(hospId))
                                        {
                                            if (!(SurgeonSiteIdValidation(id, Convert.ToInt32(hospId))))
                                            {
                                                isInvalid = true;
                                                row["Surg"] = "Surgeon ID is not a valid combination with Site ID";
                                            }
                                        }
                                    }
                                    else
                                    {
                                        isInvalid = true;
                                        row["Surg"] = "Surgeon ID is not valid";
                                    }
                                }
                            }
                            else
                            {
                                isInvalid = true;
                                row["Surg"] = "Must be filled";
                            }
                            break;

                        case "opdate":
                            id = row["OpDate"].ToString();
                            if (!(string.IsNullOrWhiteSpace(id)) && id != "NULL")
                            {
                                if (!(ValidateDate(id)))
                                {
                                    isInvalid = true;
                                    row["OpDate"] = "Date format is not correct e.g 12-OCT-1994 or 12-10-1994";
                                }
                                else if (IsNumeric(hospId))
                                {
                                    if (IsOperationDateInvalid(id, hospId))
                                    {
                                        isInvalid = true;
                                        row["OpDate"] = "Operation Date should be greater than Ethics date of Hospital and less than Todays Date";
                                    }
                                    else
                                        opDate = row["OpDate"].ToString();
                                }
                            }
                            else
                            {
                                isInvalid = true;
                                row["OpDate"] = "Must be filled";
                            }
                            break;

                        case "mappedprocid":
                            id = row["MappedProcID"].ToString();
                            if (IsNumeric(id))
                            {
                                if (!(MappedProcIdValidation(id)))
                                {
                                    isInvalid = true;
                                    row["MappedProcID"] = "Mapped Proc ID is not valid";
                                }
                            }
                            else
                            {
                                isInvalid = true;
                                row["MappedProcID"] = "Must be Numeric";
                            }
                            break;

                        case "datein":
                            id = row["DateIn"].ToString();
                            if (!string.IsNullOrWhiteSpace(id) && id != "NULL")
                            {
                                if (ValidateDate(id))
                                {
                                    if (IsDateValid(id))
                                        adDate = row["DateIn"].ToString();
                                    else
                                    {
                                        isInvalid = true;
                                        row["DateIn"] = "Admission Date should not be greater than Todays Date";
                                    }
                                }
                                else
                                {
                                    isInvalid = true;
                                    row["DateIn"] = "Date format is not correct e.g 12-OCT-1994 or 12-10-1994";
                                }
                            }
                            break;

                        case "dateout":
                            id = row["DateOut"].ToString();
                            if (!string.IsNullOrWhiteSpace(id) && id != "NULL")
                            {
                                if (ValidateDate(id))
                                {
                                    if (IsDateValid(id, "DateOut"))
                                        DisDate = row["DateOut"].ToString();
                                    else
                                    {
                                        isInvalid = true;
                                        row["DateOut"] = "Discharge Date should be less than or equal to Todays Date";
                                    }
                                }
                                else
                                {
                                    isInvalid = true;
                                    row["DateOut"] = "Date format is not correct e.g 12-OCT-1994 or 12-10-1994";
                                }
                            }
                            break;
                    }
                }
                if (!string.IsNullOrWhiteSpace(opDate) && opDate != "NULL")
                {
                    if (!(OperationDateValidation(opDate, adDate, DisDate)))
                    {
                        isInvalid = true;
                        row["OpDate"] = "Operation date should be in between Admission Date and Discharge Date";
                    }
                    if (IsNumeric(row["PatientID"].ToString()))
                    {
                        if (IsOptDateBeforePrimaryOpt(opDate, row["PatientID"].ToString()))
                        {
                            isInvalid = true;
                            row["OpDate"] = "Operation date should be greater than Primary Operation Date";
                        }
                    }
                }

                //Adds invalid row in invalid row's data table
                if (isInvalid)
                    _invalidTable.Rows.Add(row.ItemArray);
            } // End Loop 
            return _invalidTable;
        }

        //get Patient Id list
        private IEnumerable<int> GetPatientIds()
        {
            IEnumerable<int> Ids;
            using (UnitOfWork patientRepo = new UnitOfWork())
            {
                Ids = (from patient in patientRepo.tbl_PatientRepository.Get()
                       select patient.PatId);
            }
            return Ids;
        }

        //get site ids / Hospital Id list
        private IEnumerable<int> GetSiteIds()
        {
            IEnumerable<int> ids;
            using (UnitOfWork patientRepo = new UnitOfWork())
            {
                ids = (from status in patientRepo.tbl_SiteRepository.Get()
                       select status.SiteId);
            }
            return ids;
        }

        //get surgeon Ids
        private IEnumerable<int> GetSurgeonIds()
        {
            IEnumerable<int> ids;
            using (UnitOfWork patientRepo = new UnitOfWork())
            {
                ids = (from status in patientRepo.tbl_UserRepository.Get()
                       select status.UserId);
            }
            return ids;
        }

        //get surgeon Ids
        private IEnumerable<int> GetMappedProcIds()
        {
            IEnumerable<int> ids;
            using (UnitOfWork patientRepo = new UnitOfWork())
            {
                ids = (from procedure in patientRepo.tlkp_ProcedureRepository.Get()
                       select procedure.Id);
            }
            return ids;
        }

        //PatientID field validation
        private bool PatientIdValidation(string patientId)
        {
            if (IsNumeric(patientId))
            {
                int checkId = Convert.ToInt32(patientId);
                return _patientIds.Contains(checkId);
            }
            else
                return false;
        }

        //surgeon id field validation
        private bool SurgeonIdValidation(string surgeonId)
        {
            bool isValid = false;
            if (IsNumeric(surgeonId))
            {
                int checkId = Convert.ToInt32(surgeonId);
                if (_surgeonIds.Contains(checkId))
                    isValid = true;
            }
            return isValid;
        }

        private bool SurgeonSiteIdValidation(string surgeonId, int siteId)
        {
            bool isValid = false;
            using (UnitOfWork memberDetails = new UnitOfWork())
            {
                object guid = memberDetails.tbl_UserRepository.Get().Where(x => x.UserId == Convert.ToInt32(surgeonId)).Select(y => y.UId).FirstOrDefault();
                MembershipUser memberUser = Membership.GetUser(guid);
                if (memberUser != null)
                {
                    int[] sitIdList = memberDetails.MembershipRepository.GetSiteIdsForUser(memberUser.UserName);
                    if (sitIdList.Length > 0)
                    {
                        if (sitIdList.Contains(siteId))
                            isValid = true;
                    }
                }
            }
            return isValid;
        }

        //Site id/ Hospital ID field validation
        private bool SiteIdValidation(string siteId)
        {
            if (IsNumeric(siteId))
            {
                int checkId = Convert.ToInt32(siteId);
                return _siteIds.Contains(checkId);
            }
            else
                return false;
        }

        private bool MappedProcIdValidation(string mappedProcId)
        {
            if (IsNumeric(mappedProcId))
            {
                int checkId = Convert.ToInt32(mappedProcId);
                return _mappedProcIds.Contains(checkId);
            }
            else
                return false;
        }

        // validate Opt Date 
        private bool IsOperationDateInvalid(string date, string hospitalId)
        {
            bool IsValid = true;
            DateTime? EAD;
            DateTime OptDate;
            if (!string.IsNullOrWhiteSpace(date) && date != "NULL")
            {
                OptDate = FormatDate(date);
                if (OptDate.Date < DateTime.Today.Date)
                {
                    using (UnitOfWork siteRepository = new UnitOfWork())
                    {
                        EAD = siteRepository.tbl_SiteRepository.Get()
                            .Where(x => x.SiteId.Equals(Convert.ToInt32(hospitalId))).Select(y => y.EAD).FirstOrDefault();
                    }
                    if (OptDate > EAD)
                        IsValid = false;
                }
            }
            return IsValid;
        }

        //Date field validation
        private bool ValidateDate(string date)
        {
            DateTime parsed;
            bool isValid = DateTime.TryParseExact(date, "dd-MMM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed);
            if (!isValid)
            {
                bool isValidNew = DateTime.TryParseExact(date, "dd-MM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed);
                return isValidNew;
            }
            return isValid;
        }

        //Function is to check if date is greater than todays date
        private bool IsDateValid(string date, string dateType = null)
        {
            DateTime dt;
            if (DateTime.TryParseExact(date, "dd-MMM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
            {
                if (dateType == "DateOut")
                {
                    if (dt.Date <= DateTime.Today.Date)
                        return true;
                    else
                        return false;
                }
                else
                {
                    if (dt.Date < DateTime.Today.Date)
                        return true;
                    else
                        return false;
                }
            }
            else if (DateTime.TryParseExact(date, "dd-MM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
            {
                if (dateType == "DateOut")
                {
                    if (dt.Date <= DateTime.Today.Date)
                        return true;
                    else
                        return false;
                }
                else
                {
                    if (dt.Date < DateTime.Today.Date)
                        return true;
                    else
                        return false;
                }
            }
            else
                return false;
        }

        //This function will format the date from string depending upon format (dd-MM-yyyy or dd-MMM-yyyy)
        private DateTime FormatDate(string date)
        {
            DateTime dt = System.DateTime.Now;
            DateTime parsed;
            bool isValid = DateTime.TryParseExact(date, "dd-MMM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed);
            if (!isValid)
            {
                bool isValidNew = DateTime.TryParseExact(date, "dd-MM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed);
                if (isValidNew)
                    dt = DateTime.ParseExact(date, "dd-MM-yyyy", System.Globalization.CultureInfo.InvariantCulture);
            }
            else
                dt = DateTime.ParseExact(date, "dd-MMM-yyyy", System.Globalization.CultureInfo.InvariantCulture);
            return dt;
        }

        // Method will validate Operation date for all scenario also validate based on Admission date and discharge date
        private bool OperationDateValidation(string opDate, string AdmissionDate, string DischargeDate)
        {
            DateTime InDate;
            DateTime OptDate;
            DateTime OutDate;
            bool isValid = false;
            if ((string.IsNullOrWhiteSpace(AdmissionDate) || AdmissionDate == "NULL") && (string.IsNullOrWhiteSpace(DischargeDate) || DischargeDate == "NULL"))
                isValid = true;
            else
            {
                if ((!string.IsNullOrWhiteSpace(AdmissionDate) && AdmissionDate != "NULL") && (!string.IsNullOrWhiteSpace(DischargeDate) && DischargeDate != "NULL"))
                {
                    InDate = FormatDate(AdmissionDate);
                    OutDate = FormatDate(DischargeDate);
                    OptDate = FormatDate(opDate);
                    if (InDate.Date <= OptDate.Date && OutDate.Date >= OptDate.Date)
                        isValid = true;
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(DischargeDate) || DischargeDate == "NULL")
                    {
                        if (!string.IsNullOrWhiteSpace(AdmissionDate) && AdmissionDate != "NULL")
                        {
                            InDate = FormatDate(AdmissionDate);
                            OptDate = FormatDate(opDate);
                            if (InDate.Date <= OptDate.Date)
                                isValid = true;
                        }
                    }
                    if (string.IsNullOrWhiteSpace(AdmissionDate) || AdmissionDate == "NULL")
                    {
                        if (!string.IsNullOrWhiteSpace(DischargeDate) && DischargeDate != "NULL")
                        {
                            OutDate = FormatDate(DischargeDate);
                            OptDate = FormatDate(opDate);
                            if (OutDate.Date >= OptDate.Date)
                                isValid = true;
                        }
                    }
                }
            }
            return isValid;
        }

        /// <summary>
        /// This method will return true (invalid) if given operation date is before Primary date.
        /// </summary>
        /// <param name="opDate">Operation date</param>
        /// <param name="patientID">Patient ID</param>
        /// <returns></returns>
        private bool IsOptDateBeforePrimaryOpt(string opDate, string patientID)
        {
            DateTime operationDate;
            DateTime? primaryOpDate;
            bool isInvalid = false;
            operationDate = Convert.ToDateTime(opDate);
            int result;
            using (UnitOfWork operationRepository = new UnitOfWork())
            {
                primaryOpDate = operationRepository.tbl_PatientOperationRepository.Get().Where(x => x.PatientId == Convert.ToInt32(patientID)).Select(y => y.OpDate).FirstOrDefault();
            }
            if (primaryOpDate != null)
            {
                result = DateTime.Compare(operationDate, (DateTime)primaryOpDate);
                if (result < 0)
                    isInvalid = true;
            }
            else
                isInvalid = false;
            return isInvalid;
        }

        //upload records
        private DataTable UploadRecords(DataTable fileData)
        {
            int patientId;
            string opId;
            DateTime operationDate;
            int? mappedProcId;
            DateTime? dateAdmitted;
            DateTime? dateDischarged;
            fileData.Columns.Add("OperationID", typeof(string)).SetOrdinal(1);
            DataTable matchedTable = new DataTable();
            matchedTable = fileData.Clone();

            foreach (DataRow row in fileData.Rows)
            {
                patientId = Convert.ToInt32(row["PatientID"].ToString());
                operationDate = Convert.ToDateTime(row["OpDate"].ToString());
                string checkMappedProcId = row["MappedProcID"].ToString();
                if (checkMappedProcId == "")
                    mappedProcId = null;
                else
                    mappedProcId = Convert.ToInt32(row["MappedProcID"].ToString());

                string checkDateAdmitted = row["DateIn"].ToString();
                if (checkDateAdmitted == "" || checkDateAdmitted == "NULL")
                    dateAdmitted = null;
                else
                    dateAdmitted = Convert.ToDateTime(row["DateIn"].ToString());

                string checkDateDischarged = row["DateOut"].ToString();
                if (checkDateDischarged == "" || checkDateDischarged == "NULL")
                    dateDischarged = null;
                else
                    dateDischarged = Convert.ToDateTime(row["DateOut"].ToString());

                CheckRecords(patientId, operationDate, mappedProcId, out opId);
                if (!(string.IsNullOrWhiteSpace(opId)))
                {
                    row["OperationID"] = opId;
                    matchedTable.Rows.Add(row.ItemArray);
                    _countExistingRecord++;
                }
                else
                {
                    if (LoadData(row))
                        _countRecord++;
                }
            }
            return matchedTable;
        }

        //check patient is already in DB or not
        private string CheckRecords(int patientID, DateTime operationDate, int? mappedProcId, out string opId)
        {
            using (UnitOfWork operationRepository = new UnitOfWork())
            {
                opId = operationRepository.tbl_PatientOperationRepository.Get()
                    .Where(x => x.PatientId.Equals(patientID) && x.OpDate.Equals(operationDate) && ((x.OpType == mappedProcId || x.OpRevType == mappedProcId) == false ? x.OpTypeBulkLoad == mappedProcId : (x.OpType == mappedProcId || x.OpRevType == mappedProcId)))
                    .Select(y => y.OpId).FirstOrDefault().ToString();
            }
            if (opId == "0")
                return opId = null;
            else
                return opId;
        }

        //add operation details to database
        private bool LoadData(DataRow row)
        {
            bool isSuccessful = false;
            try
            {
                using (UnitOfWork operationRepository = new UnitOfWork())
                {
                    tbl_PatientOperation patientOp = new tbl_PatientOperation();
                    //get the row data in variables
                    string patientId = row["PatientID"].ToString();
                    string hospitalId = row["Hosp"].ToString();
                    string surgeonId = row["Surg"].ToString();
                    string operationDate = row["OpDate"].ToString();
                    string mappedProcId = row["MappedProcID"].ToString();
                    string dateAdmitted = row["DateIn"].ToString();
                    string dateDischarged = row["DateOut"].ToString();

                    //assign row data to fields in patient operation repository
                    patientOp.PatientId = Convert.ToInt32(patientId);
                    patientOp.Hosp = Convert.ToInt32(hospitalId);
                    patientOp.Surg = Convert.ToInt32(surgeonId);
                    patientOp.OpDate = Convert.ToDateTime(operationDate);
                    patientOp.ProcAban = false;
                    patientOp.OpAge = PatientHandler.CalculateAge(Convert.ToDateTime(operationDate), Convert.ToInt32(patientId));
                    if (dateAdmitted != "NULL")
                        patientOp.AdmissionDate = Convert.ToDateTime(dateAdmitted);
                    else
                        patientOp.AdmissionDate = null;
                    if (dateDischarged != "NULL")
                        patientOp.DischargeDate = Convert.ToDateTime(dateDischarged);
                    else
                        patientOp.DischargeDate = null;

                    if (!(string.IsNullOrWhiteSpace(mappedProcId)))
                        patientOp.OpTypeBulkLoad = Convert.ToInt32(mappedProcId);
                    else
                        patientOp.OpTypeBulkLoad = null;

                    patientOp.OpVal = 1;
                    patientOp.OpStat = null;
                    patientOp.RenalTx = 0;
                    patientOp.LiverTx = 0;
                    patientOp.CreatedBy = "ICD10-Bulk";
                    patientOp.CreatedDateTime = System.DateTime.Now;
                    patientOp.LastUpdatedBy = "ICD10-Bulk";
                    patientOp.LastUpdatedDateTime = System.DateTime.Now;
                    patientOp = OperationHandler.SaveOperation(patientOp, "", false);

                    SessionData sessionData = new SessionData();
                    sessionData.PatientOperationId = patientOp.OpId;
                    isSuccessful = true;
                }
            }
            catch (Exception ex)
            {
                DisplayCustomMessage(ex.Message.ToString());
            }
            finally
            {
                Session.Remove("opTable");
                Session.Remove("existingTable");
            }
            return isSuccessful;
        }

        //check field is null or not
        private bool? CheckNull(string field)
        {
            if (field == "0" || string.Equals(field, "false", StringComparison.OrdinalIgnoreCase))
                return false;
            else if (field == "1" || string.Equals(field, "True", StringComparison.OrdinalIgnoreCase))
                return true;
            else
                return null;
        }

        //check is valid string or not
        private bool IsNumeric(string field)
        {
            return Regex.IsMatch(field, @"^\d+(?:\.\d+[eE][\+-]\d+)?$");
        }

        //Hide controls
        private void HideControls()
        {
            ExistingRecordGrid.Visible = false;
            BulkLoadGrid.Visible = false;
            InvalidCsv.Visible = false;
            ExistingRecord.Visible = false;
            LoadedRecord.Visible = false;
        }

        //show exception as custom error message
        private void DisplayCustomMessage(string exception)
        {
            ErrorMessage.Visible = true;
            ErrorMessage.Text = "Error message: " + exception + " <br />" + "An unknown error has occurred please try again or contact your system administrator.";
            BulkLoadGrid.Visible = false;
            InvalidCsv.Visible = false;
            ExistingRecord.Visible = false;
            LoadedRecord.Visible = false;
            ExistingRecordGrid.Visible = false;
        }

        // Check if URN Number already present
        private bool IsDuplicateURNPresent(string urnNumber, int HospitalId)
        {
            bool isDuplicateURN = false;
            using (UnitOfWork patientRepository = new UnitOfWork())
            {
                var urnDetails = patientRepository.tbl_URNRepository.Get().Where(t => (t.URNo == urnNumber && t.HospitalID == HospitalId)).FirstOrDefault();
                if (urnDetails != null)
                    isDuplicateURN = true;
            }
            return isDuplicateURN;
        }

        /// <summary>
        /// Allows Indexing and paging in BulkLoadGrid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void BulkLoadGrid_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            BulkLoadGrid.DataSource = (DataTable)Session["opTable"];
        }

        /// <summary>
        /// Allows Indexing and paging in ExistingRecordGrid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ExistingRecordGrid_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            ExistingRecordGrid.DataSource = (DataTable)Session["existingTable"];
        }
    }
}