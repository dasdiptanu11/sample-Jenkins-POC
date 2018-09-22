DROP FUNCTION [dbo].[ufn_Patient_CallWorkList]
GO

CREATE PROCEDURE [dbo].[usp_Patient_CallWorkList]
(
	@countryId INT,
	@stateId INT
)
AS
BEGIN
	SELECT patient.PatId "PatientId", followup.FUId "FollowUpId", patient.LastName "FamilyName", patient.FName "GivenName",
		patient.HomePh "HomePhone", patient.MobPh "Mobile", patient.DOB "BirthDate", patient.Pcode "PostCode", patient.OptOffStatId "OptOffStatusId",
		patient.PriSiteId "SiteId", pSite.SiteName "Site", patient.PriSurgId "SurgeonId", sUser.FName + ' ' + sUser.LastName "Surgeon",
		operation.OpDate "OperationDate", COALESCE(operation.OpType,Operation.OpRevType) "ProcedureId", oProcedure.Description "Procedure", 
		followup.FUPeriodId "FollowUpPeriodId", fPeriod.Description "FollowUpPeriod", followup.FUDate "FollowUpDueDate", fCall.Id "FollowUpCallId", fCall.CallOne "CallOneId",
		cOneResult.Description "CallOneResult", fCall.CallTwo "CallTwoId", cTwoResult.Description "CallTwoResult", fCall.CallThree "CallThreeId",
		cThreeResult.Description "CallThreeResult", fCall.CallFour "CallFourId", cFourResult.Description "CallFourResult", fCall.CallFive "CallFiveId",
		cFiveResult.Description "CallFiveResult", fCall.LastUpdatedBy "LastUpdateBy", fCall.LastUpdatedDateTime "LastUpdateDateTime", fCall.AssignedTo "AssignedTo",
		followup.Othinfo "FollowUpInfo", patient.StateId "StateId", lState.Description "StateName"
	FROM tbl_FollowUp followup
		INNER JOIN tbl_Patient patient ON patient.PatId = followup.PatientId
		INNER JOIN tbl_Site pSite ON pSite.SiteId = patient.PriSiteId
		INNER JOIN tbl_User sUser ON sUser.UserId = patient.PriSurgId
		FULL OUTER JOIN tlkp_State lState ON lState.Id = patient.StateId
		INNER JOIN tbl_PatientOperation operation ON operation.OpId = followup.OperationId
		INNER JOIN tlkp_Procedure oProcedure ON oProcedure.Id = COALESCE(operation.OpType,Operation.OpRevType)
		INNER JOIN tlkp_FollowUpPeriod fPeriod ON fPeriod.Id = followup.FUPeriodId
		FULL OUTER JOIN tbl_FollowUpCall fCall ON fCall.FollowUpId = followUP.FUId
		FULL OUTER JOIN tlkp_FollowUpCallResult cOneResult ON cOneResult.Id = fCall.CallOne
		FULL OUTER JOIN tlkp_FollowUpCallResult cTwoResult ON cTwoResult.Id = fCall.CallTwo
		FULL OUTER JOIN tlkp_FollowUpCallResult cThreeResult ON cThreeResult.Id = fCall.CallThree
		FULL OUTER JOIN tlkp_FollowUpCallResult cFourResult ON cFourResult.Id = fCall.CallFour
		FULL OUTER JOIN tlkp_FollowUpCallResult cFiveResult ON cFiveResult.Id = fCall.CallFive
	WHERE (followup.FUVal = 0 OR followup.FUVal = 1)
		AND patient.HStatId <> 1
		AND (patient.OptOffStatId NOT IN (1, 2, 3))
		AND (followup.BSR_to_Follow_Up = 1
				OR patient.PriSurgId IN (SELECT UserId FROM tbl_user WHERE FName = 'BSR' AND LastName = 'CALL'))
		AND patient.CountryId = CASE WHEN @countryId <> -1 THEN @countryId ELSE patient.CountryId END
		AND COALESCE(patient.StateId, '') = CASE WHEN @stateId <> -1 THEN @stateId ELSE COALESCE(patient.StateId, '') END
		AND (patient.DOB IS NULL OR CAST(DATEDIFF(YEAR, patient.DOB, GETDATE()) AS INT) > 18)
	order by
		CallFive desc, CallFour desc, CallThree desc, CallTwo desc, CallOne desc, FUDate desc, FUId desc, PatId desc
END

