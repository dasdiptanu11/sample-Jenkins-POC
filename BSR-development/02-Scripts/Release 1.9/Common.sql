GO
PRINT 'Running Scripts'

--GO
PRINT 'Executing ufn_FollowUp_WorkList.sql'
:r ufn_FollowUp_WorkList.sql


--GO
PRINT 'Executing usp_CreateFollowUps.sql'
:r usp_CreateFollowUps.sql


--GO
PRINT 'Executing usp_CreateOpFollowUp.sql'
:r usp_CreateOpFollowUp.sql

--GO
PRINT 'Executing usp_SurgeonReport_SentinelEveCnt.sql'
:r usp_SurgeonReport_SentinelEveCnt.sql

PRINT 'Executing usp_SurgeonRpt_DiaxCnt.sql'
:r usp_SurgeonRpt_DiaxCnt.sql


--GO
PRINT 'Executing usp_SurgeonRpt_DiaxCnt2.sql'
:r usp_SurgeonRpt_DiaxCnt2.sql

--GO
PRINT 'Executing usp_SurgeonRpt_FollowUpCnt.sql'
:r usp_SurgeonRpt_FollowUpCnt.sql

--GO
PRINT 'Executing usp_SurgeonRpt_OpProcAndOpCnt.sql'
:r usp_SurgeonRpt_OpProcAndOpCnt.sql

--Go
Print 'Executing usp_SurgeonRpt_PatCnt.sql' 
:r usp_SurgeonRpt_PatCnt.sql


--GO
PRINT 'Executing usp_SurgeonRpt_Reasons.sql'
:r usp_SurgeonRpt_Reasons.sql


PRINT 'Executing usp_SurgeonRpt_ReasonsForPort.sql'
:r usp_SurgeonRpt_ReasonsForPort.sql


PRINT 'Executing usp_SurgeonRpt_ReasonsForSlip.sql'
:r usp_SurgeonRpt_ReasonsForSlip.sql

PRINT 'Executing usp_SurgeonRpt_ReOpReason.sql'
:r usp_SurgeonRpt_ReOpReason.sql

PRINT 'Executing usp_SurgeonRpt_SelfReportedWtCnt.sql'
:r usp_SurgeonRpt_SelfReportedWtCnt.sql

PRINT 'Executing usp_UpdateFollowUpsAsInvalidOrValid.sql'
:r usp_UpdateFollowUpsAsInvalidOrValid.sql

PRINT 'Executing usp_UpdatePatientOptoffSts.sql'
:r usp_UpdatePatientOptoffSts.sql



PRINT 'Reached here'



