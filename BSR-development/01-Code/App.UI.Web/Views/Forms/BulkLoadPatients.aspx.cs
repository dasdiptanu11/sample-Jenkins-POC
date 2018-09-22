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

namespace App.UI.Web.Views.Forms
{
    public partial class BulkLoadPatients : BasePage
    {
        //Gender Ids List
        private IEnumerable<int> _genderIds;

        // Title Ids list
        private IEnumerable<int> _titleIds;

        // IndigenousStatus list
        private IEnumerable<int> _indigenousStatus;

        // IndigenousStatus NZ list
        private IEnumerable<int> _indigenousStatusNZ;

        // site ids list
        private IEnumerable<int> _siteIds;

        // state ids list
        private IEnumerable<int> _stateIds;

        //surgeon ids list
        private IEnumerable<int> _surgeonIds;

        // Opt off status list
        private IEnumerable<int> _offStatIds;

        // invalid data table
        private DataTable _invalidTable;

        // processed record count
        private int _countRecord = 0;

        //existing record count
        private int _countExistingRecord = 0;

        /// <summary>
        /// Handle page level events
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
        /// Upload and validate file
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
                    _genderIds = GetGenderIds();
                    _titleIds = GetTitleIds();
                    _indigenousStatus = GetAboriginalstatus();
                    _siteIds = GetSiteIds();
                    _stateIds = GetStateId();
                    _offStatIds = GetOffStatIds();
                    _indigenousStatusNZ = GetIndigenousStatusNZ();
                    _surgeonIds = GetSurgeonIds();
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
                        Session["patientTable"] = validatedTable;
                        BulkLoadGrid.DataSource = (DataTable)Session["patientTable"];
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
                            ExistingRecord.Text = "The below is a list of patients which are potential duplicates.";
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

        //get IndigenousStatus for NZ
        private IEnumerable<int> GetIndigenousStatusNZ()
        {
            IEnumerable<int> ids;
            using (UnitOfWork patientRepo = new UnitOfWork())
            {
                ids = (from status in patientRepo.tlkp_IndigenousStatusRepository.Get()
                       select status.Id);
            }
            return ids;
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
            Dictionary<string, List<int>> fileURNNumbers = new Dictionary<string, List<int>>();
            _invalidTable = csvDataTable.Clone();
            int primarySiteId = -1;
            string stateId = string.Empty;
            string id = string.Empty;
            string countryId = string.Empty;
            // Loop over all the rows in the datatable
            foreach (DataRow row in csvDataTable.Rows)
            {
                bool inValidated = false;
                bool isDvaNo = true;
                bool isMcare = true;
                bool isPhoneNo = true;
                bool isMobileNo = true;
                bool isPcode = true;
                bool isNhiNo = true;
                bool isDateOfBirth = true;
                bool isDeathDate = true;
                bool isDead = false;
                bool isAddressKnown = false;
                string addressNotKnown = string.Empty;
                string OptOffStatusId = string.Empty;

                if (!string.IsNullOrWhiteSpace(row["CountryId"].ToString()))
                {
                    countryId = row["CountryId"].ToString();
                }
                if (!string.IsNullOrWhiteSpace(row["AddrNotKnown"].ToString()))
                {
                    addressNotKnown = row["AddrNotKnown"].ToString();
                }

                foreach (DataColumn column in csvDataTable.Columns)
                {
                    switch (column.ColumnName.ToLower())
                    {
                        case "lastname":
                            id = row["LastName"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                if (IsNumeric(id))
                                {
                                    inValidated = true;
                                    row["LastName"] = "Name not valid";
                                }
                            }
                            else
                            {
                                inValidated = true;
                                row["LastName"] = "Must be filled";
                            }
                            break;

                        case "fname":
                            id = row["FName"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                if (IsNumeric(id))
                                {
                                    inValidated = true;
                                    row["FName"] = "Name not valid";
                                }
                            }
                            else
                            {
                                inValidated = true;
                                row["FName"] = "Must be filled";
                            }
                            break;

                        case "titleid":
                            id = row[column].ToString();
                            if (!(string.IsNullOrWhiteSpace(id)))
                            {
                                if (!(TitleIdValidation(id)))
                                {
                                    inValidated = true;
                                    row["TitleId"] = "Id is not valid";
                                }
                            }
                            break;

                        case "dob":
                            id = row["DOB"].ToString();
                            if (!(string.IsNullOrWhiteSpace(id)))
                            {
                                if (ValidateDate(id))
                                {
                                    if (CalculateAge((id)) < 18)
                                    {
                                        inValidated = true;
                                        row["DOB"] = "Patient is less than 18 years";
                                    }
                                }
                                else
                                {
                                    inValidated = true;
                                    row[column] = "Date format is not correct e.g 12-Oct-1994";
                                }
                            }
                            else
                            {
                                isDateOfBirth = false;
                            }
                            break;

                        case "dobnotknown":
                            id = row["DOBNotKnown"].ToString();
                            if (!isDateOfBirth)
                            {
                                if (!(id == "1" || string.Equals(id, "True", StringComparison.OrdinalIgnoreCase)))
                                {
                                    inValidated = true;
                                    row["DOBNotKnown"] = "Value should be 1 or true";
                                }
                            }
                            if (isDateOfBirth)
                            {
                                if (!(id == "0" || id == ""))
                                {
                                    inValidated = true;
                                    row["DOBNotKnown"] = "Value should be 0 or blank";
                                }
                            }
                            break;

                        case "genderid":
                            id = row["GenderId"].ToString();
                            if (!(string.IsNullOrWhiteSpace(id)))
                            {
                                if (!(GenderIdValidation(id)))
                                {
                                    inValidated = true;
                                    row["GenderId"] = "Id is not valid";
                                }
                            }
                            else
                            {
                                inValidated = true;
                                row["GenderId"] = "Must be filled";
                            }
                            break;

                        case "mcareno":
                            id = row["McareNo"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                if (IsNumeric(id))
                                {
                                    if (!IsExponentialFormat(id))
                                    {
                                        if (!(id.Length == 11))
                                        {
                                            inValidated = true;
                                            row["McareNo"] = "Medicare Number should be of 11 digits";
                                        }
                                    }
                                    else
                                    {
                                        inValidated = true;
                                        row["McareNo"] = "McareNo in .csv should not be in exponential format e.g. 1.2E+11";
                                    }
                                }
                                else
                                {
                                    inValidated = true;
                                    row["McareNo"] = "Number not valid";
                                }
                            }
                            else
                            {
                                isMcare = false;
                            }
                            break;

                        case "nomcareno":
                            id = row["NoMcareNo"].ToString();
                            if (isMcare)
                            {
                                if (!(string.IsNullOrEmpty(id) || string.IsNullOrWhiteSpace(id) || id == "0" || string.Equals(id, "false", StringComparison.OrdinalIgnoreCase)))
                                {
                                    inValidated = true;
                                    row["NoMcareNo"] = "Value should be 0 or blank";
                                }
                            }
                            else
                            {
                                if (!(string.Equals(id, "True", StringComparison.OrdinalIgnoreCase) || id == "1"))
                                {
                                    inValidated = true;
                                    row["NoMcareNo"] = "Value should be 1 or true";
                                }
                            }
                            break;

                        case "dvano":
                            id = row["DvaNo"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                if (!(IsExponentialFormat(id)))
                                {
                                    if ((id.Length > 9))
                                    {
                                        inValidated = true;
                                        row["DvaNo"] = "DvaNo should not be greater then 9 digits";
                                    }
                                }
                                else
                                {
                                    inValidated = true;
                                    row["DvaNo"] = "DvaNo in .csv file should not be in exponential format e.g. 1.2E+11";
                                }
                            }
                            else
                                isDvaNo = false;
                            break;

                        case "nodvano":
                            id = row["NoDvaNo"].ToString();
                            if (isDvaNo)
                            {
                                if (!(id == "0" || id == ""))
                                {
                                    inValidated = true;
                                    row["NoDvaNo"] = "Value should be 0 or blank";
                                }
                            }
                            else
                            {
                                if (!(string.Equals(id, "True", StringComparison.OrdinalIgnoreCase) || id == "1"))
                                {
                                    inValidated = true;
                                    row["NoDvaNo"] = "Value should be 1 or true";
                                }
                            }
                            break;

                        case "ihi":
                            id = row["IHI"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                inValidated = true;
                                row["IHI"] = "Number should be null or empty";
                            }
                            break;

                        case "aborstatusid":
                            id = row["AborStatusId"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                if (!(ValidateIndigenousStatus(id)))
                                {
                                    inValidated = true;
                                    row["AborStatusId"] = "Id is not valid";
                                }
                            }
                            else
                            {
                                inValidated = true;
                                row["AborStatusId"] = "Must be filled";
                            }
                            break;

                        case "indistatusid":
                            if (countryId == "2")
                            {
                                id = row["IndiStatusId"].ToString();
                                if (!string.IsNullOrWhiteSpace(id))
                                {
                                    if (!(ValidateIndigenousStatusNZ(id)))
                                    {
                                        inValidated = true;
                                        row["IndiStatusId"] = "Id is not valid";
                                    }
                                }
                                else
                                {
                                    inValidated = true;
                                    row["IndiStatusId"] = "Must be filled";
                                }
                            }
                            break;

                        case "prisiteid":
                            id = row["PriSiteId"].ToString();
                            if (!(string.IsNullOrWhiteSpace(id)))
                            {
                                if (!(CheckSiteIdValidation(id)))
                                {
                                    inValidated = true;
                                    row["PriSiteId"] = "Id is not valid";
                                }
                                else
                                {
                                    primarySiteId = Convert.ToInt32(id);
                                }
                            }
                            else
                            {
                                inValidated = true;
                                row["PriSiteId"] = "Must be filled";
                            }
                            break;

                        case "prisurgid":
                            id = row["PriSurgId"].ToString();
                            if (!(string.IsNullOrWhiteSpace(id)))
                            {
                                if (SurgeonIdValidation(id))
                                {
                                    if (!(SurgeonSiteValidation(id, primarySiteId)))
                                    {
                                        inValidated = true;
                                        row["PriSurgId"] = "Surgeon ID is not a valid combination with Site ID.";
                                    }
                                }
                                else
                                {
                                    inValidated = true;
                                    row["PriSurgId"] = "Id is not valid";
                                }
                            }
                            else
                            {
                                inValidated = true;
                                row["PriSurgId"] = "Must be filled";
                            }
                            break;

                        case "addrnotknown":
                            if (!(addressNotKnown == "0" || addressNotKnown == "1" || string.IsNullOrEmpty(addressNotKnown)))
                            {
                                inValidated = true;
                                row["AddrNotKnown"] = "AddrNotKnown is not valid";
                            }
                            break;

                        case "addr":
                            id = row["Addr"].ToString();
                            if (addressNotKnown == "1")
                            {
                                isAddressKnown = true;
                            }
                            if (addressNotKnown == "0" || addressNotKnown == "")
                            {
                                if (string.IsNullOrWhiteSpace(id))
                                {
                                    inValidated = true;
                                    row["Addr"] = "Must be filled";
                                }
                            }
                            else if (!string.IsNullOrWhiteSpace(id))
                            {
                                inValidated = true;
                                row["Addr"] = "AddrNotKnown is true, Addr should be blank";
                            }
                            break;

                        case "sub":
                            //id = row["Sub"].ToString();
                            //if (string.IsNullOrWhiteSpace(id))
                            //{
                            //    inValidated = true;
                            //   row["Sub"] = "Must be filled";
                            //}
                            break;

                        case "stateid":
                            id = row["StateId"].ToString();
                            if (!(string.IsNullOrWhiteSpace(id)))
                            {
                                if (!(StateIdValidation(id)))
                                {
                                    inValidated = true;
                                    row["StateId"] = "Id is not valid";
                                }
                                else
                                    stateId = id;
                            }
                            else if (string.IsNullOrEmpty(id))
                            {
                                inValidated = false;
                            }
                            else
                            {
                                inValidated = true;
                                row["StateId"] = "Must be filled";
                            }
                            break;

                        case "pcode":

                            id = row["Pcode"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                if (!(StateIdPcodeValidation(id, stateId)))
                                {
                                    inValidated = true;
                                    row["Pcode"] = "Pcode is not valid";
                                }
                            }
                            else
                            {
                                isPcode = false;
                            }
                            break;

                        case "nopcode":
                            id = row["NoPcode"].ToString();
                            if (!isPcode)
                            {
                                if (!(id == "1" || string.Equals(id, "True", StringComparison.OrdinalIgnoreCase)))
                                {
                                    inValidated = true;
                                    row["NoPcode"] = "Value should be 1 or true";
                                }
                            }
                            if (isPcode)
                            {
                                if (!(id == "0" || string.IsNullOrWhiteSpace(id)))
                                {
                                    inValidated = true;
                                    row["NoPcode"] = "Value should be 0 or blank";
                                }
                            }
                            break;

                        case "nhino":
                            id = row["NhiNo"].ToString();
                            if (countryId == "2")
                            {

                                if (!string.IsNullOrWhiteSpace(id))
                                {

                                    if (!(IsExponentialFormat(id)))
                                    {
                                        if (id.Length > 10)
                                        {
                                            inValidated = true;
                                            row["NhiNo"] = "NHI number should not excced 10 characters";
                                        }
                                    }
                                    else
                                    {
                                        inValidated = true;
                                        row["NhiNo"] = "NhiNo in .csv file should not be in exponential format e.g. 1.2E+11";
                                    }
                                }
                                else
                                    isNhiNo = false;
                            }
                            else if (!string.IsNullOrWhiteSpace(id))
                            {
                                inValidated = true;
                                row["NhiNo"] = "NHI number only applicable for country NZ";
                            }
                            break;

                        case "nonhino":
                            id = row["NoNhiNo"].ToString();
                            if (countryId == "1")
                            {
                                if (!(id == "1"))
                                {
                                    inValidated = true;
                                    row["NoNhiNo"] = "Value should be 1 or true";
                                }
                            }
                            else if (countryId == "2")
                            {
                                if (!isNhiNo)
                                {
                                    if (!(id == "1" || string.Equals(id, "True", StringComparison.OrdinalIgnoreCase)))
                                    {
                                        inValidated = true;
                                        row["NoNhiNo"] = "Value should be 1 or true";
                                    }
                                }
                                if (isNhiNo)
                                {
                                    if (!(id == "0" || id == ""))
                                    {
                                        inValidated = true;
                                        row["NoNhiNo"] = "Value should be 0 or blank";
                                    }
                                }
                            }
                            else if (!string.IsNullOrWhiteSpace(id))
                            {
                                inValidated = true;
                                row["NoNhiNo"] = "NoNhiNo number only applicable for country NZ";
                            }
                            break;

                        case "countryid":
                            if (!string.IsNullOrWhiteSpace(countryId))
                            {
                                if (!(countryId == "1" || countryId == "2"))
                                {
                                    inValidated = true;
                                    row["CountryId"] = "Value should be 1 or 2";
                                }
                            }
                            else
                            {
                                inValidated = true;
                                row["CountryId"] = "Must be filled";
                            }
                            break;

                        case "homeph":
                            id = row["HomePh"].ToString();
                            if (!(string.IsNullOrWhiteSpace(id)))
                            {
                                if (IsNumeric(id))
                                {
                                    if (!IsExponentialFormat(id))
                                    {

                                        if (!(id.Length >= 9 && id.Length < 16))
                                        {
                                            inValidated = true;
                                            row["HomePh"] = "Number should at least 9 digits and less than 16 digits";
                                        }
                                    }
                                    else
                                    {
                                        row["HomePh"] = "HomePh in .csv file should not be in exponential format e.g. 1.2E+11";
                                    }
                                }
                                else
                                {
                                    inValidated = true;
                                    row["HomePh"] = "Number not valid";
                                }
                            }
                            else
                                isPhoneNo = false;
                            break;

                        case "mobph":
                            id = row["MobPh"].ToString();
                            if (!(string.IsNullOrWhiteSpace(id)))
                            {

                                if (IsNumeric(id))
                                {
                                    if (!IsExponentialFormat(id))
                                    {
                                        if (!(id.Length >= 9 && id.Length < 16))
                                        {
                                            inValidated = true;
                                            row["MobPh"] = "Number should at least 9 digits and less than 16 digits";
                                        }
                                    }
                                    else
                                    {
                                        row["MobPh"] = "MobPh in .csv file should not be in exponential format e.g. 1.2E+11";
                                    }
                                }
                                else
                                {
                                    inValidated = true;
                                    row["MobPh"] = "Number not valid";
                                }
                            }
                            else
                                isMobileNo = false;
                            break;

                        case "nohomeph":
                            id = row["NoHomePh"].ToString();
                            if (!isPhoneNo)
                            {
                                if (!(id == "1" || string.Equals(id, "True", StringComparison.OrdinalIgnoreCase)))
                                {
                                    inValidated = true;
                                    row["NoHomePh"] = "Value should be 1 or true";
                                }
                            }
                            if (isPhoneNo)
                            {
                                if (!(id == "0" || id == ""))
                                {
                                    inValidated = true;
                                    row["NoHomePh"] = "Value should be 0 or blank";
                                }
                            }
                            break;

                        case "nomobph":
                            id = row["NoMobPh"].ToString();
                            if (!isMobileNo)
                            {
                                if (!(id == "1" || string.Equals(id, "True", StringComparison.OrdinalIgnoreCase)))
                                {
                                    inValidated = true;
                                    row["NoMobPh"] = "Value should be 1 or true";
                                }
                            }
                            if (isMobileNo)
                            {
                                if (!(id == "0" || id == ""))
                                {
                                    inValidated = true;
                                    row["NoMobPh"] = "Value should be 0 or blank";
                                }
                            }
                            break;

                        case "hstatid":
                            id = row["HStatId"].ToString();
                            if (!(id == "0" || id == "1"))
                            {
                                inValidated = true;
                                row["HStatId"] = "Id is not valid";
                            }
                            if (id == "1")
                                isDead = true;
                            break;

                        case "optoffstatid":
                            id = row["OptOffStatId"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                if (!ValidateOffStatus(id))
                                {
                                    inValidated = true;
                                    row["OptOffStatId"] = "Id is not valid";
                                }
                                else
                                {
                                    OptOffStatusId = id;
                                }
                            }
                            else
                            {
                                inValidated = true;
                                row["OptOffStatId"] = "Must be filled";
                            }
                            break;

                        case "optoffdate":
                            id = row["OptOffDate"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                if (!(ValidateDate(id)))
                                {
                                    inValidated = true;
                                    row["OptOffDate"] = "Date format is not correct e.g 12-Oct-1994";
                                }
                                else if (IsOptOffDateInvalid(id))
                                {
                                    inValidated = true;
                                    row["OptOffDate"] = "Opt Off Date must be '>01-Jan-2012' and 'less than Current Date'";
                                }
                            }
                            else
                            {
                                if (OptOffStatusId.Equals("1", StringComparison.OrdinalIgnoreCase))
                                {
                                    inValidated = true;
                                    row["OptOffDate"] = "Opt off date should not be blanked as Opt Off Status is set to Fully Opted Off";
                                }
                            }
                            break;

                        case "urno":
                            id = row["URNo"].ToString();
                            if (string.IsNullOrWhiteSpace(id))
                            {
                                inValidated = true;
                                row["URNo"] = "Must be filled";
                            }
                            else
                            {
                                if (IsExponentialFormat(id))
                                {
                                    inValidated = true;
                                    row["URNo"] = "URNo in .csv file should not be in exponential format e.g. 1.2E+11";
                                }
                                else
                                {
                                    if (IsDuplicateURNPresent(id, primarySiteId))
                                    {
                                        inValidated = true;
                                        row["URNo"] = "URNo already exists in the system";
                                    }
                                    else
                                    {
                                        //Check if the the id exists in the file
                                        if (fileURNNumbers.ContainsKey(id))
                                        {
                                            //Check if the site exists 
                                            if (fileURNNumbers[id].Contains(primarySiteId))
                                            {
                                                inValidated = true;
                                                row["URNo"] = "Multiple records have same URN Number for the same site";
                                            }
                                            else
                                            {
                                                fileURNNumbers[id].Add(primarySiteId);
                                            }
                                        }
                                        else
                                        {
                                            fileURNNumbers.Add(id, new List<int>() { primarySiteId });
                                        }
                                    }
                                }
                            }
                            break;

                        case "hospitalid":
                            id = row["HospitalID"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                if (IsNumeric(id))
                                {
                                    if (!(primarySiteId == Convert.ToInt32(id)))
                                    {
                                        inValidated = true;
                                        row["HospitalID"] = "Site ID and Hospital ID must be same";
                                    }
                                }
                                else
                                {
                                    inValidated = true;
                                    row["HospitalID"] = "Only numbers allowed";
                                }
                            }
                            break;

                        case "datedeath":
                            id = row["DateDeath"].ToString();
                            if (isDead)
                            {
                                if (!string.IsNullOrWhiteSpace(id))
                                {
                                    if (!(ValidateDate(id)))
                                    {
                                        inValidated = true;
                                        row["DateDeath"] = "Date format is not correct e.g 12-Oct-1994";
                                    }
                                    else if (IsDateDeathGreater(id))
                                    {
                                        inValidated = true;
                                        row["DateDeath"] = "Death Date should not be greater then Todays Date";
                                    }
                                }
                                else
                                    isDeathDate = false;
                            }
                            break;

                        case "datedeathnotknown":
                            id = row["DateDeathNotKnown"].ToString();
                            if (!isDeathDate)
                            {
                                if (!(id == "1" || string.Equals(id, "True", StringComparison.OrdinalIgnoreCase)))
                                {
                                    inValidated = true;
                                    row["DateDeathNotKnown"] = "Value should be 1 or true";
                                }
                            }
                            if (isDeathDate)
                            {
                                if (!(id == "0" || id == ""))
                                {
                                    inValidated = true;
                                    row["DateDeathNotKnown"] = "Value should be 0 or blank";
                                }
                            }
                            break;

                        case "deathrelsurgid":
                            id = row["DeathRelSurgId"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                if (!(id == "0" || id == "1"))
                                {
                                    inValidated = true;
                                    row["DeathRelSurgId"] = "Value should be 0 or 1";
                                }
                            }
                            break;

                        case "undel":
                            id = row["Undel"].ToString();
                            if (!string.IsNullOrWhiteSpace(id))
                            {
                                if (!(id == "0" || id == "1"))
                                {
                                    inValidated = true;
                                    row["Undel"] = "Value should be 0 or 1";
                                }
                            }
                            break;
                    }
                }

                //Adds invalid rows
                if (inValidated)
                {
                    _invalidTable.Rows.Add(row.ItemArray);
                }

            } // End Loop 
            return _invalidTable;
        }

        // check death date is greater then current date
        private bool IsDateDeathGreater(string date)
        {
            DateTime deathDate = DateTime.ParseExact(date, "dd-MMM-yyyy",
                                             System.Globalization.CultureInfo.InvariantCulture);
            if (deathDate > DateTime.Today)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        // validate Opt Off Date 
        private bool IsOptOffDateInvalid(string date)
        {
            DateTime minimumAllowedOptOffDate = new DateTime(2012, 1, 1);
            DateTime OptOffDate = DateTime.ParseExact(date, "dd-MMM-yyyy",
                                             System.Globalization.CultureInfo.InvariantCulture);

            if (OptOffDate < minimumAllowedOptOffDate || OptOffDate > DateTime.Today)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        //get gender ids list
        private IEnumerable<int> GetGenderIds()
        {
            IEnumerable<int> Ids;
            using (UnitOfWork patientRepo = new UnitOfWork())
            {
                Ids = (from gender in patientRepo.tlkp_GenderRepository.Get()
                       select gender.Id);
            }
            return Ids;
        }

        //get title ids list
        private IEnumerable<int> GetTitleIds()
        {
            IEnumerable<int> ids;
            using (UnitOfWork patientRepo = new UnitOfWork())
            {
                ids = (from title in patientRepo.tlkp_TitleRepository.Get()
                       select title.Id);
            }
            return ids;
        }

        //get Aboriginalstatus list
        private IEnumerable<int> GetAboriginalstatus()
        {
            IEnumerable<int> ids;
            using (UnitOfWork patientRepo = new UnitOfWork())
            {
                ids = (from status in patientRepo.tlkp_AboriginalStatusRepository.Get()
                       select status.Id);
            }
            return ids;
        }

        //get site ids list
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

        //get state ids list
        private IEnumerable<int> GetStateId()
        {
            IEnumerable<int> ids;
            using (UnitOfWork patientRepo = new UnitOfWork())
            {
                ids = (from status in patientRepo.tlkp_StateRepository.Get()
                       select status.Id);
            }
            return ids;
        }

        //get GetOffStatIds
        private IEnumerable<int> GetOffStatIds()
        {
            IEnumerable<int> ids;
            using (UnitOfWork repository = new UnitOfWork())
            {
                ids = (from status in repository.tlkp_OptOffStatusRepository.Get()
                       select status.Id);
            }
            return ids;
        }

        //gender field  validation
        private bool GenderIdValidation(string genderId)
        {
            if (IsNumeric(genderId))
            {
                int checkId = Convert.ToInt32(genderId);
                return _genderIds.Contains(checkId);
            }
            else
                return false;
        }

        //title field  validation
        private bool TitleIdValidation(string titleId)
        {
            if (IsNumeric(titleId))
            {
                int checkId = Convert.ToInt32(titleId);
                return _titleIds.Contains(checkId);
            }
            else
                return false;
        }

        //DOB field validation
        private bool ValidateDate(string dateOfBirth)
        {
            DateTime parsed;

            bool isValid = DateTime.TryParseExact(dateOfBirth, "dd-MMM-yyyy",
                                                CultureInfo.InvariantCulture,
                                                DateTimeStyles.None,
                                                out parsed);
            return isValid;
        }

        //IndigenousStatus field validation
        private bool ValidateIndigenousStatus(string aborStatusId)
        {
            if (IsNumeric(aborStatusId))
            {
                int checkId = Convert.ToInt32(aborStatusId);
                return _indigenousStatus.Contains(checkId);
            }
            else
                return false;
        }

        //IndigenousStatus field validation
        private bool ValidateIndigenousStatusNZ(string Id)
        {
            if (IsNumeric(Id))
            {
                int checkId = Convert.ToInt32(Id);
                return _indigenousStatusNZ.Contains(checkId);
            }
            else
                return false;
        }

        //validate offstatus
        private bool ValidateOffStatus(string offStatusId)
        {
            if (IsNumeric(offStatusId))
            {
                int checkId = Convert.ToInt32(offStatusId);
                return _offStatIds.Contains(checkId);
            }
            else
                return false;
        }

        //site id field validation
        private bool CheckSiteIdValidation(string siteId)
        {
            if (IsNumeric(siteId))
            {
                int checkId = Convert.ToInt32(siteId);
                return _siteIds.Contains(checkId);
            }
            else
                return false;
        }

        //surgeon  id field validation
        private bool SurgeonIdValidation(string surgeonId)
        {
            if (IsNumeric(surgeonId))
            {
                int checkId = Convert.ToInt32(surgeonId);
                return _surgeonIds.Contains(checkId);
            }
            else
                return false;
        }

        //calculate age
        private int CalculateAge(string id)
        {
            DateTime dateOfBirth = Convert.ToDateTime(id);
            DateTime currentDate = DateTime.Now;
            int age = currentDate.Year - dateOfBirth.Year;
            if (currentDate.Date < dateOfBirth.AddYears(age))
                age--;
            return age;
        }

        //surgeon and site validation
        private bool SurgeonSiteValidation(string surgeonId, int siteId)
        {
            if (IsNumeric(surgeonId))
            {
                int userId = Convert.ToInt32(surgeonId);
                bool isId;
                IEnumerable<int> surgeonIds;
                using (UnitOfWork userDetails = new UnitOfWork())
                {
                    surgeonIds = (from lookup in userDetails.vw_aspnet_UsersRepository.Get(orderBy: x => x.OrderBy(q => q.UserId))
                                  join u in userDetails.tbl_UserRepository.Get() on lookup.UserId equals u.UId
                                  join t in userDetails.tlkp_TitleRepository.Get() on u.TitleId equals t.Id
                                  join uir in userDetails.vw_aspnet_UsersInRolesRepository.Get() on lookup.UserId equals uir.UserId
                                  join surgeon in userDetails.vw_aspnet_RolesRepository.Get() on uir.RoleId equals surgeon.RoleId
                                  join uir2 in userDetails.vw_aspnet_UsersInRolesRepository.Get() on lookup.UserId equals uir2.UserId
                                  join hosp in userDetails.vw_aspnet_RolesRepository.Get() on uir2.RoleId equals hosp.RoleId
                                  join ts in userDetails.tbl_SiteRepository.Get() on hosp.RoleName equals ts.SiteRoleName
                                  where surgeon.RoleName == "SURGEON" && ts.SiteId == siteId && u.AccountStatusActive == 1
                                  select u.UserId);
                }
                return isId = surgeonIds.Contains(userId);
            }
            else
                return false;
        }

        //state id field validtion
        private bool StateIdValidation(string id)
        {
            if (IsNumeric(id))
            {
                int checkId = Convert.ToInt32(id);
                return _stateIds.Contains(checkId);
            }
            else
                return false;
        }

        //Postcode validation 
        private bool StateIdPcodeValidation(string postCode, string stateId)
        {
            int code = Convert.ToInt32(postCode);
            switch (stateId)
            {
                case "1":
                    if (postCode.Substring(0, 1) == "1" || postCode.Substring(0, 1) == "2")
                    {
                        if (!(code >= 2600 && code <= 2612 || code >= 2614 && code <= 2617 || code >= 2900 && code <= 2906 || code >= 2911 && code <= 2914))
                            return true;
                    }
                    break;

                case "2":
                    if (postCode.Substring(0, 1) == "3" || (postCode.Substring(0, 1) == "8" && postCode != "8888"))

                        return true;
                    break;

                case "3":
                    if (postCode.Substring(0, 1) == "4" || (postCode.Substring(0, 1) == "9" && postCode != "9999"))
                        return true;
                    break;

                case "4":
                    if (postCode.Substring(0, 1) == "5")
                        return true;
                    break;

                case "5":
                    if (postCode.Substring(0, 1) == "6")
                        return true;
                    break;

                case "6":
                    if (postCode.Substring(0, 1) == "7")
                        return true;
                    break;

                case "7":
                    if (postCode.Substring(0, 2) == "08")
                        return true;
                    break;

                case "8":
                    if (postCode.Substring(0, 2) == "02")
                        return true;
                    else if (code >= 2600 && code <= 2612 || code >= 2614 && code <= 2617 || code >= 2900 && code <= 2906 || code >= 2911 && code <= 2914)
                        return true;
                    break;
            }
            return false;
        }

        //check string is exponential
        private bool IsExponentialFormat(string field)
        {
            double number;
            return (field.Contains("E") || field.Contains("e")) && double.TryParse(field, out number);
        }

        //upload record
        private DataTable UploadRecords(DataTable fileData)
        {
            string lastName = string.Empty;
            string firstName = string.Empty;
            string patientId;
            DateTime? dateOfBirth;
            fileData.Columns.Add("Patient ID", typeof(string)).SetOrdinal(1);
            DataTable matchedTable = new DataTable();
            matchedTable = fileData.Clone();

            foreach (DataRow row in fileData.Rows)
            {
                lastName = row["LastName"].ToString();
                firstName = row["FName"].ToString();
                string checkDOB = row["DOB"].ToString();
                if (checkDOB == "")
                {
                    dateOfBirth = null;
                }
                else
                {
                    dateOfBirth = Convert.ToDateTime(row["DOB"].ToString());
                }

                CheckRecords(lastName, firstName, dateOfBirth, out patientId);
                if (!(string.IsNullOrWhiteSpace(patientId)))
                {
                    row["Patient ID"] = patientId;
                    matchedTable.Rows.Add(row.ItemArray);
                    _countExistingRecord++;
                }

                if (SaveData(row))
                {
                    _countRecord++;
                }
            }
            return matchedTable;
        }

        //check patient is already in DB or not
        private string CheckRecords(string lastName, string firstName, DateTime? dateOfBirth, out string patientId)
        {

            //using (UnitOfWork patientRepository = new UnitOfWork()) {
            //    patientId = patientRepository.tbl_PatientRepository.Get()
            //        .Where(x => x.LastName.Equals(lastName.Trim(), StringComparison.OrdinalIgnoreCase)
            //            && x.FName.Equals(firstName.Trim(), StringComparison.OrdinalIgnoreCase)
            //            && x.DOB == dateOfBirth
            //            ).Select(y => y.PatId).FirstOrDefault().ToString();
            //}

            //if (patientId == "0")
            //    return patientId = null;
            //else
            //    return patientId;

            //Returns null patient id as requested: SC-10
            return patientId = null;
        }

        //add patient to database
        private bool SaveData(DataRow row)
        {
            bool isSuccessful = false;
            try
            {
                using (UnitOfWork patientRepository = new UnitOfWork())
                {
                    tbl_Patient patient = new tbl_Patient();

                    string deathRelSurgId = row["DeathRelSurgId"].ToString();
                    string titleId = row["TitleId"].ToString();
                    string checkDOB = row["DOB"].ToString();

                    if (!(string.IsNullOrWhiteSpace(titleId)))
                    {
                        patient.TitleId = Helper.ToNullable<Int32>(titleId);
                    }
                    else
                        patient.TitleId = null;

                    if (string.IsNullOrWhiteSpace(checkDOB))
                    {
                        patient.DOB = null;
                    }
                    else
                    {
                        patient.DOB = Convert.ToDateTime(checkDOB);
                    }

                    patient.CreatedBy = "ICD10-Bulk";
                    patient.CreatedDateTime = System.DateTime.Now;
                    patient.LastUpdatedBy = "ICD10-Bulk";
                    patient.LastUpdatedDateTime = System.DateTime.Now;

                    patient.LastName = row["LastName"].ToString().Trim().ToUpperInvariant();
                    patient.FName = row["FName"].ToString().Trim().ToUpperInvariant();

                    patient.DOBNotKnown = ConvertToBoolean(row["DOBNotKnown"].ToString()) ?? false;
                    patient.GenderId = Helper.ToNullable<Int32>(row["GenderId"].ToString());
                    patient.IHI = Helper.ToNullable(Helper.ToNullable(row["IHI"].ToString()));
                    patient.Addr = Helper.ToNullable(row["Addr"].ToString().Trim());
                    patient.AddrNotKnown = ConvertToBoolean(row["AddrNotKnown"].ToString()) ?? false;
                    patient.Sub = Helper.ToNullable(row["Sub"].ToString().Trim());
                    patient.Pcode = Helper.ToNullable(row["Pcode"].ToString().Trim());
                    patient.NoPcode = ConvertToBoolean(row["NoPcode"].ToString()) ?? false;
                    patient.CountryId = Helper.ToNullable<Int32>(row["CountryId"].ToString());
                    patient.HomePh = Helper.ToNullable(row["HomePh"].ToString().Trim());
                    patient.MobPh = Helper.ToNullable(row["MobPh"].ToString().Trim());
                    patient.NoHomePh = ConvertToBoolean(row["NoHomePh"].ToString()) ?? false;
                    patient.NoMobPh = ConvertToBoolean(row["NoMobPh"].ToString()) ?? false;
                    patient.HStatId = Helper.ToNullable<Int32>(row["HStatId"].ToString());
                    patient.PriSurgId = Helper.ToNullable<Int32>(row["PriSurgId"].ToString());
                    patient.PriSiteId = Helper.ToNullable<Int32>(row["PriSiteId"].ToString());
                    patient.Undel = ConvertToBoolean(row["Undel"].ToString()) ?? false;
                    patient.CauseOfDeath = Helper.ToNullable(row["CauseOfDeath"].ToString().Trim());
                    patient.OptOffStatId = Helper.ToNullable<Int32>(row["OptOffStatId"].ToString());

                    patient.NhiNo = Helper.ToNullable(row["NhiNo"].ToString().Trim());
                    patient.NoNhiNo = ConvertToBoolean(row["NoNhiNo"].ToString()) ?? false;
                    patient.AborStatusId = Helper.ToNullable<Int32>(row["AborStatusId"].ToString());
                    patient.McareNo = Helper.ToNullable(row["McareNo"].ToString().Trim());
                    patient.NoMcareNo = ConvertToBoolean(row["NoMcareNo"].ToString()) ?? false;
                    patient.DvaNo = Helper.ToNullable(row["DvaNo"].ToString());
                    patient.NoDvaNo = ConvertToBoolean(row["NoDvaNo"].ToString()) ?? false;
                    patient.DateDeathNotKnown = ConvertToBoolean(row["DateDeathNotKnown"].ToString()) ?? false;

                    if (string.IsNullOrWhiteSpace(deathRelSurgId))
                    {
                        patient.DeathRelSurgId = null;
                    }
                    else
                    {
                        patient.DeathRelSurgId = Helper.ToNullable<Int32>(deathRelSurgId);
                    }

                    if (!string.IsNullOrWhiteSpace(row["DateDeath"].ToString()))
                    {
                        patient.DateDeath = Convert.ToDateTime(Helper.ToNullable(row["DateDeath"].ToString()));
                    }
                    else
                    {
                        patient.DateDeath = null;
                    }

                    if (!string.IsNullOrWhiteSpace(row["OptOffDate"].ToString()))
                    {
                        patient.OptOffDate = Convert.ToDateTime(Helper.ToNullable(row["OptOffDate"].ToString()));
                    }
                    else
                    {
                        patient.OptOffDate = null;
                    }

                    if (patient.CountryId == 2)
                    {
                        patient.IndiStatusId = Helper.ToNullable<Int32>(row["IndiStatusId"].ToString());
                    }
                    else
                    {
                        patient.IndiStatusId = null;
                    }

                    if (string.IsNullOrWhiteSpace(row["StateId"].ToString()))
                    {
                        patient.StateId = null;
                    }
                    else
                    {
                        patient.StateId = Helper.ToNullable<Int32>(row["StateId"].ToString());
                    }

                    patient = PatientHandler.SavePatientDetails(patient, Helper.ToNullable(row["URNo"].ToString().Trim()));
                    isSuccessful = true;
                }
            }
            catch (Exception ex)
            {
                DisplayCustomMessage(ex.Message.ToString());
            }
            finally
            {
                Session.Remove("patientTable");
                Session.Remove("existingTable");
            }
            return isSuccessful;
        }

        /// <summary>
        /// Converts 0/1, or string true/false to bool
        /// </summary>
        /// <param name="field"></param>
        /// <returns>Boolean value if it can be converted. Null if it is null</returns>
        private bool? ConvertToBoolean(string field)
        {
            if (field == "0" || string.Equals(field, "false", StringComparison.OrdinalIgnoreCase))
            {
                return false;
            }
            else if (field == "1" || string.Equals(field, "True", StringComparison.OrdinalIgnoreCase))
            {
                return true;
            }
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
            //bool isDuplicateURN = false;
            //using (UnitOfWork patientRepository = new UnitOfWork()) {
            //    var urnDetails = patientRepository.tbl_URNRepository.Get().Where(t => (t.URNo == urnNumber && t.HospitalID == HospitalId)).FirstOrDefault();
            //    if (urnDetails != null) {
            //        isDuplicateURN = true;
            //    }
            //}

            //return isDuplicateURN;

            //Code commented out by request: SC-10
            return false;
        }

        /// <summary>
        /// Allows Indexing and paging in BulkLoadGrid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void BulkLoadGrid_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            BulkLoadGrid.DataSource = (DataTable)Session["patientTable"];
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