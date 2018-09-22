
GO

/****** Object:  StoredProcedure [dbo].[usp_CreateFollowUps]    Script Date: 12/04/2015 15:53:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CreateFollowUps]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CreateFollowUps]
GO


GO

/****** Object:  StoredProcedure [dbo].[usp_CreateFollowUps]    Script Date: 12/04/2015 15:53:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_CreateFollowUps]
AS

BEGIN

	exec [usp_UpdatePatientOptoffSts];	


	insert into tbl_FollowUp(PatientId,OperationId,FUPeriodId, CreatedBy, CreatedDateTime, FUDate, FUVal)

	--DateAdd is modified Previous DATEADD(day, (fu1.Id *365), po.OpDate) as FUDate
	select p.PatId PatientId, po.OpId OperationId, fu1.Id FUPeriodId,  'CIDMU_SP' CreatedBy , GETDATE() CreatedDateTime, 	 		
		DATEADD(yy, fu1.Id , po.OpDate) as FUDate , case when FUDate<= GETDATE() then 0 else 4 end as FUVal 
	from tbl_Patient p
	inner join  tbl_PatientOperation po on p.PatId = po.PatientId
	left outer join  tlkp_FollowUpPeriod fu1 on 'a' = 'a' 
	left outer join tbl_FollowUp fu on po.PatientId = fu.PatientId and po.OpId = fu.OperationId and fu1.Id = fu.FUPeriodId 	            		
	
	where 	
	fu.FUId is null 
	and DATEDIFF(DAY, po.OpDate , GETDATE() ) >= 20 and 			 
	coalesce(p.HStatId, 0) = 0	  --Operation should have been done for follow up, patient should be alive			
	and (po.OpStat = 0			  -- should be primary or 								 
		or  fu1.Id < 1                     --For revision
		) 
	and coalesce(po.ProcAban,0) = 0  --Process should not have been abondoned
	and coalesce(p.OptOffStatId, 0) in (0,2);
		
		
	exec [usp_UpdateFollowUpsAsInvalidOrValid];	
	 
	insert into tbl_MonitorFollowUp([RunDateTime])  select GETDATE();

END





GO


