PRINT 'Deleting FollowUpCall Constraints'
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_FollowUpCall_tbl_FollowUp_FollowUpId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_FollowUpCall] DROP CONSTRAINT [FK_tbl_FollowUpCall_tbl_FollowUp_FollowUpId]
;


PRINT 'Deleting FollowUpCall table'
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_FollowUpCall]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_FollowUpCall]
;

PRINT 'Creating FollowUpCall table'
CREATE TABLE tbl_FollowUpCall
(
	[Id] [INT] IDENTITY(1,1) NOT NULL,
	[FollowUpId] [INT],
	[CallOne] [INT],
	[CallTwo] [INT],
	[CallThree] [INT],
	[CallFour] [INT],
	[CallFive] [INT],
	[AssignedTo] [INT],
	[LastUpdatedBy] [NVARCHAR](100),
	[LastUpdatedDateTime] [DATETIME]
)


PRINT 'Creating FollowUpCall Constraints'
ALTER TABLE [dbo].[tbl_FollowUpCall] ADD CONSTRAINT [PK_tbl_FollowUpCall] 
	PRIMARY KEY CLUSTERED ([Id])
;


ALTER TABLE [dbo].[tbl_FollowUpCall] ADD CONSTRAINT [FK_tbl_FollowUpCall_tbl_FollowUp_FollowUpId] 
	FOREIGN KEY ([FollowUpId]) REFERENCES [dbo].[tbl_FollowUp] ([FUId])
;


-----------------------------------------------------------------------------------------------------

PRINT 'Deleting FollowUpCallResult Lookup table'
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_FollowUpCallResult]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_FollowUpCallResult]
;


PRINT 'Creating FollowUpCallResult Lookup table'
CREATE TABLE [dbo].[tlkp_FollowUpCallResult] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

--------------------------------------------------------------------------------------------------------------

PRINT 'Creating FollowUpCallResult Lookup table records'
INSERT INTO [dbo].[tlkp_FollowUpCallResult] ([Id], [Description]) VALUES(1, 'Not Answered')
INSERT INTO [dbo].[tlkp_FollowUpCallResult] ([Id], [Description]) VALUES(2, 'Ask to Callback')
INSERT INTO [dbo].[tlkp_FollowUpCallResult] ([Id], [Description]) VALUES(3, 'Wrong Number')
INSERT INTO [dbo].[tlkp_FollowUpCallResult] ([Id], [Description]) VALUES(4, 'Answered')

---------------------------------------------------------------------------------------------------------------

GO

PRINT 'Creating function for fetching records to Call Worklist Screen
'
/****** Object:  UserDefinedFunction [dbo].[ufn_Patient_CallWorkList] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_Patient_CallWorkList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ufn_Patient_CallWorkList]
GO


GO

/****** Object:  UserDefinedFunction [dbo].[ufn_Patient_CallWorkList] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

	CREATE FUNCTION [dbo].[ufn_Patient_CallWorkList]
	(
		@countryId INT,
		@stateId INT
	)
	RETURNS
	@CallWorkList TABLE
	(
		PatientId INT NOT NULL,
		FollowUpId INT NOT NULL,
		FamilyName VARCHAR(50),
		GivenName VARCHAR(50),
		HomePhone VARCHAR(20),
		Mobile VARCHAR(20),
		BirthDate DATETIME,
		PostCode VARCHAR(10),
		OptOffStatusId INT,
		SiteId INT,
		[Site] VARCHAR(50),
		SurgeonId INT,
		Surgeon VARCHAR(50),
		OperationDate DATETIME,
		ProcedureId INT,
		[Procedure] VARCHAR(50),
		FollowUpPeriodId INT,
		FollowUpPeriod VARCHAR(10),
		FollowUpDueDate DATETIME,
		FollowUpCallId INT,
		CallOneId INT,
		CallOneResult NVARCHAR(20),
		CallTwoId INT,
		CallTwoResult NVARCHAR(20),
		CallThreeId INT,
		CallThreeResult NVARCHAR(20),
		CallFourId INT,
		CallFourResult NVARCHAR(20),
		CallFiveId INT,
		CallFiveResult NVARCHAR(20),
		LastUpdateBy NVARCHAR(100),
		LastUpdateDateTime DATETIME,
		AssignedTo INT,
		FollowUpInfo NVARCHAR(500),
		StateId INT,
		StateName NVARCHAR(50)
	)
	AS
	BEGIN
		INSERT INTO @CallWorkList
		SELECT patient.PatId, followup.FUId, patient.LastName, patient.FName,
			patient.HomePh, patient.MobPh, patient.DOB, patient.Pcode , patient.OptOffStatId,
			patient.PriSiteId, pSite.SiteName, patient.PriSurgId, sUser.FName + ' ' + sUser.LastName,
			operation.OpDate, COALESCE(operation.OpType,Operation.OpRevType), oProcedure.Description, 
			followup.FUPeriodId, fPeriod.Description, followup.FUDate, fCall.Id, fCall.CallOne,
			cOneResult.Description, fCall.CallTwo, cTwoResult.Description, fCall.CallThree,
			cThreeResult.Description, fCall.CallFour, cFourResult.Description, fCall.CallFive,
			cFiveResult.Description, fCall.LastUpdatedBy, fCall.LastUpdatedDateTime, fCall.AssignedTo,
			followup.Othinfo, patient.StateId, lState.Description
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
	RETURN
	END

GO