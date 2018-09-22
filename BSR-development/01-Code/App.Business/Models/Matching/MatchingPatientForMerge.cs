using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business {
    /// <summary>
    /// Matching Patient Merge
    /// </summary>
    class MatchingPatientForMerge {
        public MatchedPatientPairsListItem matchingPatients;
        public List<PatientDifferenceDetails> matchingPatientsDifferencesList = null;
        private int _noOfDifference;
        /// <summary>
        /// checks the count of differences
        /// </summary>
        /// <returns></returns>
        public int GetNumberOfDifferences() {
            return _noOfDifference;
        }
        /// <summary>
        /// Matching Patient For Merge contructor
        /// </summary>
        public MatchingPatientForMerge() {
            matchingPatients = new MatchedPatientPairsListItem();
            matchingPatientsDifferencesList = new List<PatientDifferenceDetails>();
            _noOfDifference = 0;
        }
        /// <summary>
        /// Adds differences
        /// </summary>
        /// <param name="differenceType">difference type</param>
        /// <param name="differenceValForPatient1">difference value for patient 1</param>
        /// <param name="differenceValForPatient2">difference value for patient 1</param>
        /// <returns>flag  for count of differences</returns>
        public bool AddDifference(String differenceType, String differenceValForPatient1, String differenceValForPatient2) {
            bool isDifferenceAdded = false;
            try {
                PatientDifferenceDetails patientDifference = new PatientDifferenceDetails();
                patientDifference.DetailType = differenceType;
                patientDifference.DetailValForPat1 = differenceValForPatient1;
                patientDifference.DetailValForPat2 = differenceValForPatient2;
                matchingPatientsDifferencesList.Add(patientDifference);
                _noOfDifference++;
                isDifferenceAdded = true;
            } catch (Exception ex) {
                throw ex;
            }
            return isDifferenceAdded = true;
        }
    }
}
