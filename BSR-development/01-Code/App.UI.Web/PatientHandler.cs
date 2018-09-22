using App.Business;
using App.UI.Web.Views.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace App.UI.Web
{
    public class PatientHandler
    {
        /// <summary>
        /// Inserts/Updates the URN list for the patient
        /// </summary>
        /// <param name="patientId">Identifier of the patient</param>
        /// <param name="HospitalId">Ientifier of the hosital</param>
        /// <param name="URN">The reference number for the patient at the hospital</param>
        public static void UpdatePatientURN(int patientId, int HospitalId, string URN, bool deleteIfNull = true)
        {
            using (UnitOfWork CurrentUnitofWork = new UnitOfWork())
            {
                tbl_URN patientUrnDetails = CurrentUnitofWork.tbl_URNRepository.Get(x => (x.PatientID == patientId) && (x.HospitalID == HospitalId)).DefaultIfEmpty<tbl_URN>().First();

                if (string.IsNullOrEmpty(URN))
                {
                    if (patientUrnDetails != null && deleteIfNull)
                    {
                        CurrentUnitofWork.tbl_URNRepository.Delete(patientUrnDetails);
                    }
                }
                else
                {
                    bool isNew = false;

                    if (patientUrnDetails == null || patientUrnDetails.PatientID == 0)
                    {
                        patientUrnDetails = new tbl_URN();
                        isNew = true;
                    }

                    patientUrnDetails.With(x =>
                    {
                        x.URNo = URN;
                        x.HospitalID = HospitalId;
                        x.PatientID = patientId;
                    });

                    if (isNew)
                    {
                        CurrentUnitofWork.tbl_URNRepository.Insert(patientUrnDetails);
                    }
                    else
                    {
                        CurrentUnitofWork.tbl_URNRepository.Update(patientUrnDetails);
                    }
                }
                CurrentUnitofWork.Save();
            }
        }

        /// <summary>
        /// Calcualting Body Mass Index for the patient
        /// </summary>
        /// <param name="patientWeight">Patient Weight</param>
        /// <param name="patientHeight">Patient Height</param>
        /// <returns>Returns BMI value for the patient</returns>
        public static decimal CalculateBMI(decimal? patientWeight, decimal? patientHeight)
        {
            decimal height = patientHeight == null ? 0 : (decimal)patientHeight;
            decimal weight = patientWeight == null ? 0 : (decimal)patientWeight;
            if (height == 0) { return 0; } else { return Math.Round((weight / (height * height)), 1); }
        }

        // Calculte Age for the Patient and show it in the string (on the Operation day)
        public static string CalculateAge(DateTime? operationDate, int patientId)
        {
            if (operationDate == null) { return string.Empty; }

            using (UnitOfWork patientRepository = new UnitOfWork())
            {

                tbl_Patient patient = patientRepository.tbl_PatientRepository.GetByID(patientId);
                if (patient.DOB != null)
                {
                    DateTime dateOfOperation = Convert.ToDateTime(operationDate.Value);

                    DateTime birthDate = Convert.ToDateTime(patient.DOB);
                    int year = 0, month = 0;
                    //Year calculations
                    if (dateOfOperation.Month > birthDate.Month)
                    {
                        year = dateOfOperation.Year - birthDate.Year;
                    }
                    else
                    {
                        if (dateOfOperation.Month == birthDate.Month)
                        {
                            if (dateOfOperation.Day < birthDate.Day)
                            {
                                year = dateOfOperation.Year - birthDate.Year - 1;
                            }
                            else
                            {
                                year = dateOfOperation.Year - birthDate.Year;
                            }
                        }
                        else
                        {
                            year = dateOfOperation.Year - birthDate.Year - 1;
                        }
                    }

                    //Month calculations
                    if (birthDate.Day <= dateOfOperation.Day)
                    {
                        if (dateOfOperation.Month < birthDate.Month)
                        {
                            month = 12 - birthDate.Month + dateOfOperation.Month;
                        }
                        else
                        {
                            month = dateOfOperation.Month - birthDate.Month;
                        }
                    }
                    else
                    {
                        if (dateOfOperation.Month == birthDate.Month)
                        {
                            month = 11;
                        }
                        else
                        {
                            if (dateOfOperation.Month < birthDate.Month)
                            {
                                month = 12 - birthDate.Month + dateOfOperation.Month - 1;
                            }
                            else
                            {
                                month = dateOfOperation.Month - birthDate.Month - 1;
                            }
                        }
                    }

                    string st = string.Format("{0}Y {1}M", year, month);
                    return st;
                }
            }

            return string.Empty;
        }

        public static tbl_Patient SavePatientDetails(tbl_Patient RawPatientData, string URN = "")
        {
            bool isNew = false;
            bool PatientNowDeceased = false;

            using (UnitOfWork CurrentUnitOfWork = new UnitOfWork())
            {
                tbl_Patient patient = new tbl_Patient();

                if (RawPatientData.PatId == 0)
                {
                    isNew = true;
                    patient.CreatedBy = RawPatientData.CreatedBy;
                    patient.CreatedDateTime = System.DateTime.Now;
                }
                else
                {
                    patient = CurrentUnitOfWork.PatientRepository.GetByID(RawPatientData.PatId);
                }

                //Modified from Dead to alive
                if (patient.HStatId == 1 && RawPatientData.HStatId == 0)
                {
                    PatientNowDeceased = true;
                }

                bool DOBChanged = (patient.DOB != RawPatientData.DOB);

                patient.LastUpdatedBy = RawPatientData.LastUpdatedBy;
                patient.LastUpdatedDateTime = System.DateTime.Now;

                patient.FName = RawPatientData.FName;
                patient.LastName = RawPatientData.LastName;
                patient.TitleId = RawPatientData.TitleId;
                patient.DOB = RawPatientData.DOB;
                patient.DOBNotKnown = RawPatientData.DOBNotKnown;
                patient.GenderId = RawPatientData.GenderId;
                patient.IHI = RawPatientData.IHI;
                patient.Addr = RawPatientData.Addr;
                patient.AddrNotKnown = RawPatientData.AddrNotKnown;
                patient.Sub = RawPatientData.Sub;
                patient.Pcode = RawPatientData.Pcode;
                patient.NoPcode = RawPatientData.NoPcode;
                patient.CountryId = RawPatientData.CountryId;
                patient.HomePh = RawPatientData.HomePh;
                patient.MobPh = RawPatientData.MobPh;
                patient.NoHomePh = RawPatientData.NoHomePh;
                patient.NoMobPh = RawPatientData.NoMobPh;

                patient.HStatId = RawPatientData.HStatId;
                patient.CauseOfDeath = RawPatientData.CauseOfDeath;
                patient.DateDeath = RawPatientData.DateDeath;
                patient.DateDeathNotKnown = RawPatientData.DateDeathNotKnown;

                patient.PriSurgId = RawPatientData.PriSurgId;
                patient.PriSiteId = RawPatientData.PriSiteId;
                patient.Undel = RawPatientData.Undel;

                // filling Patient object values as per the country selected
                if (patient.CountryId == Constants.COUNTRY_CODE_FOR_NEWZEALAND)
                {
                    // If country selected is New Zealand
                    patient.IndiStatusId = RawPatientData.IndiStatusId;
                    patient.NhiNo = RawPatientData.NhiNo;
                    patient.NoNhiNo = RawPatientData.NoNhiNo;
                    patient.AborStatusId = null;
                    patient.McareNo = null;
                    patient.NoMcareNo = null;
                    patient.StateId = null;
                    patient.DvaNo = null;
                    patient.NoDvaNo = null;
                }
                else
                {
                    // If Country selected is Australia
                    patient.AborStatusId = RawPatientData.AborStatusId;
                    patient.McareNo = RawPatientData.McareNo;
                    patient.NoMcareNo = RawPatientData.NoMcareNo;
                    patient.StateId = RawPatientData.StateId;
                    patient.DvaNo = RawPatientData.DvaNo;
                    patient.NoDvaNo = RawPatientData.NoDvaNo;
                    patient.IndiStatusId = null;
                    patient.NhiNo = null;
                    patient.NoNhiNo = null;
                }

                if (RawPatientData.DateESSent != null)
                {
                    patient.DateESSent = RawPatientData.DateESSent;
                }

                if (RawPatientData.HStatId == 0)
                {
                    patient.DeathRelSurgId = null;
                }
                else
                {
                    patient.DeathRelSurgId = RawPatientData.DeathRelSurgId;
                }

                //Consent status: Optoff cannot be set from save - it will update only from PatientOptOffButton
                if (RawPatientData.OptOffStatId != 1 || RawPatientData.OptOffStatId != 2)
                {
                    patient.OptOffDate = null;
                    patient.OptOffStatId = RawPatientData.OptOffStatId;
                }

                if (isNew)
                {
                    CurrentUnitOfWork.tbl_PatientRepository.Insert(patient);
                }
                else
                {
                    CurrentUnitOfWork.tbl_PatientRepository.Update(patient);
                }

                CurrentUnitOfWork.Save();

                //This will create/update followups based on the consent change
                OperationHandler.ConsentedPatientFollowupUpdate(patient.PatId);

                if (PatientNowDeceased)
                {
                    CurrentUnitOfWork.PatientRepository.UpdatePatientFollowups(patient.PatId, "Patient updated from deceased to alive");
                }

                //Update the URN of the patient
                PatientHandler.UpdatePatientURN(patient.PatId, (int)patient.PriSiteId, URN);

                /*Recalculate Age*/
                if (DOBChanged)
                {
                    List<tbl_PatientOperation> patientOperations = CurrentUnitOfWork.tbl_PatientOperationRepository.Get(x => x.PatientId == patient.PatId).ToList<tbl_PatientOperation>();
                    if (patientOperations != null && patientOperations.Count > 0)
                    {
                        foreach (tbl_PatientOperation operation in patientOperations)
                        {
                            operation.OpAge = CalculateAge(operation.OpDate, patient.PatId);
                            CurrentUnitOfWork.tbl_PatientOperationRepository.Update(operation);
                        }
                        CurrentUnitOfWork.Save();
                    }
                }
                return patient;
            }
        }

        public static void MovePatientOperations(int SourcePatientID, int DestinationPatientID)
        {

            using (UnitOfWork CurrentUnitOfWork = new UnitOfWork())
            {
                //PatID to be updated in all Operations belonging to Secondary Patient
                IEnumerable<tbl_PatientOperation> operationsToBeUpdated = CurrentUnitOfWork.tbl_PatientOperationRepository.Get(x => x.PatientId == SourcePatientID);

                //Update PatientId for all operationsForSecondaryPatientToBeUpdated from secondaryPatientId to primaryPatientId - excluding Primary if changed
                foreach (tbl_PatientOperation CurrentOperation in operationsToBeUpdated)
                {
                    CurrentOperation.PatientId = DestinationPatientID;
                    CurrentUnitOfWork.tbl_PatientOperationRepository.Update(CurrentOperation);
                }

                //Update in urnForSecondaryPatient
                IEnumerable<tbl_URN> UpdateURNs = CurrentUnitOfWork.tbl_URNRepository.Get(x => x.PatientID == SourcePatientID);
                foreach (tbl_URN recordURN in UpdateURNs)
                {
                    recordURN.PatientID = DestinationPatientID;
                    CurrentUnitOfWork.tbl_URNRepository.Update(recordURN);
                }

                //Update in fupForSecondaryPatient            
                IEnumerable<tbl_FollowUp> UpdateFollowups = CurrentUnitOfWork.tbl_FollowUpRepository.Get(x => x.PatientId == SourcePatientID);
                foreach (tbl_FollowUp recordFUP in UpdateFollowups)
                {
                    recordFUP.PatientId = DestinationPatientID;
                    CurrentUnitOfWork.tbl_FollowUpRepository.Update(recordFUP);
                }

                //Remove the Source Patient Details
                CurrentUnitOfWork.tbl_PatientRepository.Delete(SourcePatientID);
                CurrentUnitOfWork.Save();
            }
        }
    }
}