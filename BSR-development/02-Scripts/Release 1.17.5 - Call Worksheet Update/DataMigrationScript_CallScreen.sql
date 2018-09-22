BEGIN TRANSACTION
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'DBO'   AND TABLE_NAME='tbl_FollowUpCall') 
   truncate table tbl_followupcall;
go

INSERT INTO tbl_FollowUpCall (FollowUpId, CallOne, CallTwo, CallThree, CallFour, CallFive, AssignedTo, LastUpdatedBy, LastUpdatedDateTime)
	SELECT followup.FUId,
		CASE 
			WHEN followup.FUVal IN (2, 5) THEN
				CASE 
					WHEN followup.AttmptCallId = 1 THEN
						4 - followup.LTFU
					WHEN followup.AttmptCallId >= 2 THEN
						1
				END
			WHEN followup.FUVal = 1 THEN
				1
			END,


		CASE 
			WHEN followup.FUVal IN (2, 5) THEN
				CASE 
					WHEN followup.AttmptCallId = 1 then
						0
					WHEN followup.AttmptCallId = 2 THEN
						4 - followup.LTFU
					WHEN followup.AttmptCallId >= 3 THEN
						1
				END
			WHEN followup.FUVal = 1 THEN
				CASE
					WHEN followup.AttmptCallId = 1 THEN
						0
					ELSE
						1
				END
			END,


		CASE 
			WHEN followup.FUVal IN (2, 5) THEN
				CASE 
					WHEN followup.AttmptCallId <= 2 THEN
						0
					WHEN followup.AttmptCallId = 3 THEN
						4 - followup.LTFU
					WHEN followup.AttmptCallId >= 4 THEN
						1
				END
			WHEN followup.FUVal = 1 THEN
				CASE
					WHEN followup.AttmptCallId <= 2 THEN
						0
					ELSE
						1
				END
			END,


		CASE 
			WHEN followup.FUVal IN (2, 5) THEN
				CASE 
					WHEN followup.AttmptCallId <= 3 THEN
						0
					WHEN followup.AttmptCallId = 4 THEN
						4 - followup.LTFU
					WHEN followup.AttmptCallId = 5 THEN
						1
				END
			WHEN followup.FUVal = 1 THEN
				CASE
					WHEN followup.AttmptCallId <=3 THEN
						0
					ELSE
						1
				END
			END,

			CASE 
			WHEN followup.FUVal IN (2, 5) THEN
				CASE 
					WHEN followup.AttmptCallId <= 4 THEN
						0
					WHEN followup.AttmptCallId = 5 THEN
						4 - followup.LTFU
				END
			WHEN followup.FUVal = 1 THEN
				case 
					WHEN followup.AttmptCallId <=4 THEN
						0
					ELSE
						-100
				end
			END,
			-1,
			'Migration',
			GETDATE()
		
	FROM tbl_Followup followup
	WHERE followup.FUVal IN (1, 2, 5)
		AND AttmptCallId IS NOT NULL
		AND followup.FUId NOT IN (SELECT FollowUpId FROM tbl_FollowUpCall)

COMMIT
