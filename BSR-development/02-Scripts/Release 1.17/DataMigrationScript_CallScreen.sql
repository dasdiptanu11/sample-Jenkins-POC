BEGIN TRAN

INSERT INTO tbl_FollowUpCall (FollowUpId, CallOne, CallTwo, CallThree, CallFour, CallFive, AssignedTo, LastUpdatedBy, LastUpdatedDateTime)
	SELECT followup.FUId,
		CASE 
			WHEN followup.FUVal IN (2, 5) THEN
				CASE 
					WHEN followup.AttmptCallId = 1 THEN
						CASE 
							WHEN followup.LTFU = 0 THEN
								4
							WHEN followup.LTFU = 1 THEN
								3
						END
					WHEN followup.AttmptCallId = 2 THEN
						1
					WHEN followup.AttmptCallId = 3 THEN
						1
					WHEN followup.AttmptCallId = 4 THEN
						1
					WHEN followup.AttmptCallId = 5 THEN
						1
				END
			WHEN followup.FUVal = 1 THEN
				1
			END,


		CASE 
			WHEN followup.FUVal IN (2, 5) THEN
				CASE 
					WHEN followup.AttmptCallId = 1 THEN
						NULL
					WHEN followup.AttmptCallId = 2 THEN
						CASE 
							WHEN followup.LTFU = 0 THEN
								4
							WHEN followup.LTFU = 1 THEN
								3
						END
					WHEN followup.AttmptCallId = 3 THEN
						1
					WHEN followup.AttmptCallId = 4 THEN
						1
					WHEN followup.AttmptCallId = 5 THEN
						1
				END
			WHEN followup.FUVal = 1 THEN
				CASE
					WHEN followup.AttmptCallId IN (1) THEN
						NULL
					ELSE
						1
				END
			END,


		CASE 
			WHEN followup.FUVal IN (2, 5) THEN
				CASE 
					WHEN followup.AttmptCallId = 1 THEN
						NULL
					WHEN followup.AttmptCallId = 2 THEN
						NULL
					WHEN followup.AttmptCallId = 3 THEN
						CASE 
							WHEN followup.LTFU = 0 THEN
								4
							WHEN followup.LTFU = 1 THEN
								3
						END
					WHEN followup.AttmptCallId = 4 THEN
						1
					WHEN followup.AttmptCallId = 5 THEN
						1
				END
			WHEN followup.FUVal = 1 THEN
				CASE
					WHEN followup.AttmptCallId IN (1, 2) THEN
						NULL
					ELSE
						1
				END
			END,


		CASE 
			WHEN followup.FUVal IN (2, 5) THEN
				CASE 
					WHEN followup.AttmptCallId = 1 THEN
						NULL
					WHEN followup.AttmptCallId = 2 THEN
						NULL
					WHEN followup.AttmptCallId = 3 THEN
						NULL
					WHEN followup.AttmptCallId = 4 THEN
						CASE 
							WHEN followup.LTFU = 0 THEN
								4
							WHEN followup.LTFU = 1 THEN
								3
						END
					WHEN followup.AttmptCallId = 5 THEN
						1
				END
			WHEN followup.FUVal = 1 THEN
				CASE
					WHEN followup.AttmptCallId IN (1, 2, 3) THEN
						NULL
					ELSE
						1
				END
			END,

			CASE 
			WHEN followup.FUVal IN (2, 5) THEN
				CASE 
					WHEN followup.AttmptCallId = 1 THEN
						NULL
					WHEN followup.AttmptCallId = 2 THEN
						NULL
					WHEN followup.AttmptCallId = 3 THEN
						NULL
					WHEN followup.AttmptCallId = 4 THEN
						NULL
					WHEN followup.AttmptCallId = 5 THEN
						CASE 
							WHEN followup.LTFU = 0 THEN
								4
							WHEN followup.LTFU = 1 THEN
								3
						END
				END
			WHEN followup.FUVal = 1 THEN
				4
			END,
			-1,
			'Migration',
			GETDATE()

		
	FROM tbl_Followup followup
	WHERE followup.FUVal IN (1, 2, 5)
		AND AttmptCallId IS NOT NULL
		AND followup.FUId NOT IN (SELECT FollowUpId FROM tbl_FollowUpCall)



COMMIT
