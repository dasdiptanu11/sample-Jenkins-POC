GO
PRINT 'Running Scripts'

--GO
PRINT 'Executing ufn_FollowUp_WorkList.sql'
:r ufn_FollowUp_WorkList.sql


--GO
PRINT 'Executing usp_CreateOpFollowUp.sql'
:r usp_CreateOpFollowUp.sql


--GO
PRINT 'Executing usp_UpdateFollowUpsAsInvalidOrValid.sql'
:r usp_UpdateFollowUpsAsInvalidOrValid.sql


PRINT 'Reached here'



