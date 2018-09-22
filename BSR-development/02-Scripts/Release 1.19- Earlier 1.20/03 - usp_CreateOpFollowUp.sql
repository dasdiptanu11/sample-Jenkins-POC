IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_CreateOpFollowUp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
DROP PROCEDURE [dbo].[usp_CreateOpFollowUp]
END
GO

/****** Object:  StoredProcedure [dbo].[usp_CreateOpFollowUp]    Script Date: 15-11-2017 03:36:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_CreateOpFollowUp] 
	@pOpId int = -1,
	@Patient int = -1
AS

BEGIN	
	insert into tbl_FollowUp (PatientId, OperationId, FUPeriodId, CreatedBy, CreatedDateTime, FUDate, FUVal)
	select 
		p.PatId PatientId, 
		po.OpId OperationId, 
		fp.Id FUPeriodId, 
		'TEST' CreatedBy , 
		GETDATE() CreatedDateTime,
		DATEADD(yy, fp.Id , po.OpDate) as FUDate,
		case 
			when FUDate<= GETDATE()and f.FUVal<>3 then 0 
		    when FUDate<= GETDATE()and f.FUVal= 3 then 3 
		    when FUDate<= GETDATE()and f.FUVal= 5 then 5 
		    else 4 
		end as FUVal
	from 
		tbl_Patient p
		cross apply tlkp_FollowUpPeriod fp
		inner join  tbl_PatientOperation po on p.PatId = po.PatientId
		left join tbl_FollowUp f on p.PatId = f.PatientId and f.FUPeriodId = fp.Id and po.OpId=f.OperationId
	where
		f.FUId is null
		and (@Patient = -1 or (@Patient <> -1 and p.PatId = @Patient))
		and (@pOpId = -1 or (@pOpId <> -1 and po.OpId = @pOpId))
		and isnull(po.ProcAban,0) = 0
		and isnull(p.HStatId,0) = 0
		and isnull(p.OptOffStatId, 0) in (0,2)
		and DATEDIFF(DAY, po.OpDate , GETDATE() ) >= 20
		and po.opstat is not null
		and (po.OpStat = 0
			or  fp.Id < 1
        ) 
		
	exec [usp_UpdateFollowUpsAsInvalidOrValid] @pOpId;	
	 
	insert into tbl_MonitorFollowUp([RunDateTime])  select GETDATE();
END

GO


