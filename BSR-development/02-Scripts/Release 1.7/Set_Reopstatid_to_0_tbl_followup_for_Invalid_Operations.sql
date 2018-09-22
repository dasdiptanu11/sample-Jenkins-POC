 
		UPDATE tbl_FollowUp 
		SET ReOpStatId = null,
			LastUpdatedBy = 'cidmu'
		WHERE FUId IN (
		select distinct fuid 
		from tbl_PatientOperation operation 
		inner join tbl_FollowUp x 		  
		on 
		  DATEDIFF(day, operation.OpDate, x.FUDate )>= 0  --x.FUDate >= operation.OpDate 
		  and DATEADD(Year, -1,x.fudate) < operation.opdate
		  and x.OperationId <> OpID 
		  and x.FUVal = 2 
		  and x.FUPeriodId > 0 
		  and (x.ReOpStatId =1)
			  
		inner join tbl_Patient p on p.PatId = x.PatientId 
		inner join tbl_User u1 on u1.UserId = p.PriSurgId 
		inner join aspnet_Users u2 on u1.UId = u2.UserId 

		where  x.LastUpdatedDateTime >= '2016-01-22' 
		and OpStat = 1)