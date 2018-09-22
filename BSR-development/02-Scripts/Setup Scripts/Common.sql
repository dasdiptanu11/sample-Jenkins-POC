GO
PRINT 'Running Scripts'

--GO
--PRINT 'Executing CreateSchema.sql'
:r CreateSchema.sql 

--GO
PRINT 'Executing PopulateInitData.sql'
:r PopulateInitData.sql


--GO
PRINT 'Executing Function_FollowUpWorkList.sql'
:r Function_FollowUpWorkList.sql


--GO
PRINT 'Executing Audit tables for BSR.sql'
:r Audit_Tables_For_BSR.sql

--GO
PRINT 'Executing usp_UpdateFollowUpsAsInvalidOrValid.sql'
:r usp_UpdateFollowUpsAsInvalidOrValid.sql

PRINT 'Executing usp_UpdateFollowUpsAsInvalidOrValid.sql'
:r usp_UpdatePatientOptoffSts.sql


--GO
PRINT 'Executing Function_MergePatientList.sql'
:r Function_MergePatientList.sql

--GO
PRINT 'Executing usp_ValidateFollowUpsForPatID.sql'
:r usp_ValidateFollowUpsForPatID.sql

--GO
PRINT 'Executing Function_MissingDataWorkList.sql'
:r Function_MissingDataWorkList.sql

--Go
Print 'Common between revision and surgeon report' 
:r usp_SurgeonRpt_Reasons.sql
:r usp_SurgeonRpt_ReasonsForSlip.sql
:r usp_SurgeonRpt_ReasonsForPort.sql

--GO
PRINT 'Executing sp_Report_RevionSurgerySummary.sql'
:r usp_Report_RevisionSurgerySummaryReport.sql
:r usp_RSSR_ReOpReason.sql
:r usp_RSSR_ReasonsForPort_ReOP.sql
:r usp_RSSR_ReasonsForSlip_ReOP.sql

PRINT 'For Surgeon Report'
:r usp_SurgeonReport_SentinelEveCnt.sql
:r usp_SurgeonRpt_DiaxCnt.sql
:r usp_SurgeonRpt_DiaxCnt2.sql
:r usp_SurgeonRpt_DiaxCnt3.sql
:r usp_SurgeonRpt_FollowUpCnt.sql
:r usp_SurgeonRpt_OpProcAndOpCnt.sql
:r usp_SurgeonRpt_PatCnt.sql
:r usp_SurgeonRpt_SelfReportedWtCnt.sql
:r usp_SurgeonRpt_SentinelEveReason.sql
:r usp_SurgeonRpt_ReasonsForPort_SE.sql
:r usp_SurgeonRpt_ReasonsForSlip_SE.sql


PRINT 'For Benchmarking Report'
:r usp_BenchMarkingReport.sql
:r usp_BenchMarkingComparison.sql

PRINT 'For Consent Report'
:r usp_ConsentReport.sql


--GO
PRINT 'Executing Function_MatchingPatientPair.sql'
:r Function_MatchingPatientPair.sql

--GO
PRINT 'Executing Function_MergePatientList.sql'
:r Function_MergePatientList.sql

--GO
PRINT 'Executing usp_CreateFollowUpsAlerts.sql'
:r usp_CreateFollowUpsAlerts.sql

--GO
PRINT 'Executing usp_CreateFollowUps'
:r usp_CreateFollowUps.sql

PRINT 'Reached here'



