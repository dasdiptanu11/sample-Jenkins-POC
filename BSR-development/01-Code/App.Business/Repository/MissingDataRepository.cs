using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Security;
using App.Business;
using System.Data.Entity;
using System.Linq.Expressions;
using System.Data.Objects.SqlClient;

namespace App.Business
{
    public class MissingDataRepository : GenericRepository<tbl_Patient>
    {
        private BusinessEntities context;

        public MissingDataRepository(BusinessEntities context)
            : base(context)
        {
            this.context = context;
        }

        public IEnumerable<MissingDataListItem> GetMissingDataWorkList(int pSurgeonId, int pSiteId, DateTime? pOpDateFrom, DateTime? pOpDateTo)
        {
          
            IEnumerable<MissingDataListItem> MissingDataDetails = null;
            MissingDataDetails = (from mdl in context.ufn_Missing_DataList(pSurgeonId, pSiteId, pOpDateFrom, pOpDateTo)
                                                    select new MissingDataListItem()
                                                    {
                                                        PatientId = mdl.Patient_ID ,
                                                        FamilyName = mdl.Patient_LastName ,
                                                        GivenName = mdl.Patient_FName ,
                                                        Gender = mdl.Patient_Gender ,
                                                        OperationDate = mdl.Operation_Date ,
                                                        Surgeon = mdl.Surgeon ,
                                                        Day30FU = mdl.Day_30 ,
                                                        Yr1FU = mdl.Year_1, 
                                                        Yr2FU = mdl.Year_2, 
                                                        Yr3FU = mdl.Year_3, 
                                                        Yr4FU = mdl.Year_4, 
                                                        Yr5FU = mdl.Year_5, 
                                                        Yr6FU = mdl.Year_6, 
                                                        Yr7FU = mdl.Year_7, 
                                                        Yr8FU = mdl.Year_8,
                                                        Yr9FU = mdl.Year_9,
                                                        Yr10FU = mdl.Year_10,
                                                        OpFormCompleted = mdl.Op_Form_Status 
                                                    }).ToList<MissingDataListItem>();
            return MissingDataDetails;
        }


    }
}

