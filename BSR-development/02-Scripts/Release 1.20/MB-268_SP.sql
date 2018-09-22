
/****** Object:  StoredProcedure [dbo].[usp_CreateFollowUps]    Script Date: 14-06-2018 02:20:15 PM ******/
IF EXISTS ( SELECT * FROM sysobjects  WHERE  id = object_id(N'[dbo].[usp_CreateFollowUps]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE [dbo].[usp_CreateFollowUps]
END
GO

/****** Object:  StoredProcedure [dbo].[usp_CreateFollowUps]    Script Date: 14-06-2018 02:20:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_CreateFollowUps]
AS

BEGIN

	exec [usp_UpdatePatientOptoffSts];	

 --   Update fu
 --   set fu.LastUpdatedBy = 'CIDMU_SP', fu.LastUpdatedDateTime = GETDATE(), batchUpdatereason = 'ABCD TEST',
 --       fu.FUVal     = case when fu.FUDate<= GETDATE()and fu.FUVal<>3 and  then 0 
	--				   when fu.FUDate<= GETDATE()and fu.FUVal= 3 then 3 
	--				   when fu.FUDate<= GETDATE()and fu.FUVal= 5 then 5 
	--				   else 4 end 
 --   from tbl_FollowUp fu
 --   inner join  tbl_patient p on p.PatId = fu.PatientId
	--inner join  tbl_PatientOperation po on fu.PatientId = po.PatientId and po.OpId = fu.OperationId
	--inner join  tlkp_FollowUpPeriod fu1 on 'a' = 'a' and fu1.Id = fu.FUPeriodId 
	            		
	
	--where 	
	----fu.FUId is null and (Required for new)
	--DATEDIFF(DAY, po.OpDate , GETDATE() ) >= 20 and 			 
	--coalesce(p.HStatId, 0) = 0	  --Operation should have been done for follow up, patient should be alive			
	--and (po.OpStat = 0			  -- should be primary or 								 
	--	or  fu1.Id < 1                     --For revision
	--	) 
	--and coalesce(po.ProcAban,0) = 0  --Process should not have been abondoned
	--and coalesce(p.OptOffStatId, 0) in (0,2);
		
	/*Removed to call a different job that will process all records without condition.
	Existing will still be called from within the application*/
	--exec [usp_UpdateFollowUpsAsInvalidOrValid];	
	exec [usp_UpdateFollowUpsAsInvalidOrValid_NightlyJob]
	 
	--insert into tbl_MonitorFollowUp([RunDateTime])  select GETDATE();

END

GO

---------=====================================================[dbo].[usp_CreateOpFollowUp] ======================================================----------------------------------------------------------

/****** Object:  StoredProcedure [dbo].[usp_CreateOpFollowUp]    Script Date: 14-06-2018 02:22:08 PM ******/
IF EXISTS ( SELECT * FROM sysobjects  WHERE  id = object_id(N'[dbo].[usp_CreateOpFollowUp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE [dbo].[usp_CreateOpFollowUp]
END
GO

/****** Object:  StoredProcedure [dbo].[usp_CreateOpFollowUp]    Script Date: 14-06-2018 02:22:08 PM ******/
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
		and ((po.opstat is null AND po.opTypeBulkLoad IS NOT NULL) OR po.opstat is not null)
		and (po.OpStat = 0
			or  fp.Id < 1
        ) 
	
	IF(	@pOpId <> -1 )
	BEGIN
	exec [usp_UpdateFollowUpsAsInvalidOrValid] @pOpId;	
	END
	 
	insert into tbl_MonitorFollowUp([RunDateTime])  select GETDATE();
END


GO



