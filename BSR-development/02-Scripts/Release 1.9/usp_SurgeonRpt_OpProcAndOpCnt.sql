
GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_OpProcAndOpCnt]    Script Date: 06/02/2016 11:53:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SurgeonRpt_OpProcAndOpCnt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SurgeonRpt_OpProcAndOpCnt]
GO


GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_OpProcAndOpCnt]    Script Date: 06/02/2016 11:53:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--exec usp_SurgeonRpt_OpProcAndOpCnt -1, -1, '01/01/1940', '01/01/1940', '2'
/*Gives count of primary operations done for each type of bariatic procedure */
/*setting @pRunForLegacyOnly = 1  will run only for LegacyPatients only
		  @pRunForLegacyOnly = 0  will run only for non - LegacyPatients only 
		  @pRunForLegacyOnly = 2 will not consider isLegacyPatient field - runs for both   */

CREATE PROCEDURE [dbo].[usp_SurgeonRpt_OpProcAndOpCnt]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date,
	@pRunForLegacyOnly int
AS

BEGIN

  declare @DftDate as datetime
  set @DftDate = '01/01/1940';
	
SELECT  * FROM 
(

	SELECT CASE p.Description 
		   WHEN 'Gastric banding' THEN 'Gastric Banding'
		   WHEN 'R-Y gastric bypass' THEN 'R-Y Gastric Bypass'
		   WHEN 'Single anastomosis gastric bypass' THEN 'Single Anastomosis Gastric Bypass'
		   WHEN 'Sleeve gastrectomy' THEN 'Sleeve Gastrectomy'
		   WHEN 'Bilio pancreatic bypass/duodenal switch' THEN 'Bilio Pancreatic Bypass/Duodenal Switch'
		   WHEN 'Gastric imbrication' THEN 'Gastric Imbrication'
		   WHEN 'Gastric imbrication, plus gastric band (iBand)' THEN 'Gastric Imbrication, Plus Gastric Band (iBand)'
		   WHEN 'Port revision' THEN 'Port Revision'
		   WHEN 'Surgical reversal' THEN 'Surgical Reversal'	   
		   ELSE p.Description
		   END  Primary_Procedure ,
	
	coalesce(COUNT(distinct op.OpId),0) NoOfOperation 
	from tlkp_Procedure p inner join tbl_PatientOperation op on 
	p.Id = case when OpStat =0 then op.OpType else op.OpRevType  end 
	inner join tbl_Patient pat on pat.PatId = op.PatientId 
	
	where coalesce(pat.OptOffStatId, 0) in (0,2,4) 
	and op.OpVal =2
	and pat.PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else pat.PriSurgId   end
	and CONVERT(datetime, op.OpDate, 103) >= case when @pOpDateFrom <> @DftDate 
				then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, op.OpDate, 103) end
	and CONVERT(datetime, op.OpDate, 103) <= case when @pOpDateTo <> @DftDate 
				then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, op.OpDate, 103) end
	and op.Hosp  = case when @pSiteId > 0 then @pSiteId else op.Hosp end
	and coalesce(pat.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(pat.Legacy, 0) end)
	group by p.Id, p.Description
	
)

SurgeonRpt_OpProcAndOpCnt

END




GO


