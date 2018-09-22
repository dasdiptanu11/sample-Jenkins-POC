

/****** Object:  StoredProcedure [dbo].[usp_Report_RevisionSurgerySummaryReport]    Script Date: 09/29/2015 09:24:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Report_RevisionSurgerySummaryReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Report_RevisionSurgerySummaryReport]
GO


/****** Object:  StoredProcedure [dbo].[usp_Report_RevisionSurgerySummaryReport]    Script Date: 09/29/2015 09:24:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--select * from tlkp_Procedure 

--exec [usp_Report_RevisionSurgerySummaryReport] -1, 0, '01/01/1940', '01/01/1940'

CREATE PROCEDURE [dbo].[usp_Report_RevisionSurgerySummaryReport]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date
AS

BEGIN

	declare @DftDate as datetime
	set @DftDate = '01/01/1940';

SELECT  * FROM 
(

	SELECT 
		p1.Description Primary_Procedure ,
		coalesce(nPrimaryCount_, 0) 'n_Primary',
		coalesce(Max(Gastric_banding), 0) 'Gastric_Banding', 
		coalesce(Max(Gastroplasty), 0) 'Gastroplasty', 
		coalesce(Max([R-Y_Gastric_Bypass]),0) 'RY_Gastric_Bypass', 
		coalesce(Max(Single_anastomosis_gastric_bypass),0) 'Single_Anastomosis_Gastric_Bypass', 
		coalesce(Max(Sleeve_gastrectomy),0) 'Sleeve_Gastrectomy', 
		coalesce(Max(Bilio_Pancreatic_Bypass),0) 'Bilio_Pancreatic_Bypass_Duodenal_Switch',
		coalesce(Max(Gastric_Imbrication),0) 'Gastric_Imbrication', 
		coalesce(Max(Gastric_Imbrication_Plus_Band),0) 'Gastric_Imbrication_Plus_Gastric_Band', 
		coalesce(Max(Port_Revision),0) 'Port_Revision', 
		coalesce(Max(Surgical_Reversal),0) 'Surgical_Reversal', 
		coalesce(Max(Not_Stated),0) 'Not_Stated_Or_Inadequately_Described',
		coalesce(Max(Other),0) 'Other'		
	--Gets all procedure descriptions
	FROM tlkp_Procedure p1
	--Gets all Primary operation details
	left outer join 
	(
		select OpType PriType_, COUNT(PatientId) nPrimaryCount_ 
		from tbl_PatientOperation po inner join tbl_Patient p on  po.PatientId = p.PatId  
		where coalesce(opVal, 0) = 2 and OpStat = 0 and coalesce(p.OptOffStatId, 0) in (0,2,4) 
		and p.PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else p.PriSurgId end
		and CONVERT(datetime, OpDate, 103) >= case when @pOpDateFrom <> @DftDate then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, OpDate, 103) end
		and CONVERT(datetime, OpDate, 103) <= case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, OpDate, 103) end
		and po.Hosp = case when @pSiteId > 0 then @pSiteId else po.Hosp end
		group by OpType
	) tPrim_ops on PriType_ =  p1.Id 
	--Gets all revision op details "horizontally" - Gets count of each operation type and pivots it around Primary Op Type
	left outer join   
	(
		SELECT  PriOperation, 
		CASE WHEN RevOperation  = 1 THEN RevOperationsDone END AS Gastric_banding,       
		CASE WHEN RevOperation  = 2 THEN RevOperationsDone END AS Gastroplasty,       
		CASE WHEN RevOperation  = 3 THEN RevOperationsDone END AS [R-Y_Gastric_Bypass],     
		CASE WHEN RevOperation  = 4 THEN RevOperationsDone END AS Single_anastomosis_gastric_bypass,     
		CASE WHEN RevOperation  = 5 THEN RevOperationsDone END AS Sleeve_gastrectomy,     
		CASE WHEN RevOperation  = 6 THEN RevOperationsDone END AS Bilio_Pancreatic_Bypass,     
		CASE WHEN RevOperation  = 7 THEN RevOperationsDone END AS Gastric_Imbrication,     
		CASE WHEN RevOperation  = 8 THEN RevOperationsDone END AS Gastric_Imbrication_Plus_Band,     
		CASE WHEN RevOperation  = 9 THEN RevOperationsDone END AS Other,     
		CASE WHEN RevOperation  = 10 THEN RevOperationsDone END AS Port_Revision,     
		CASE WHEN RevOperation  = 11 THEN RevOperationsDone END AS Surgical_Reversal,     
		CASE WHEN RevOperation  = 12 THEN RevOperationsDone END AS Not_Stated 
		from 
			(
				select poPri.OpType PriOperation, poRev.OpRevType RevOperation, COUNT(*) RevOperationsDone
				from tbl_PatientOperation poPri 
				inner join tbl_PatientOperation poRev 
				on poPri.PatientId = poRev.PatientId  and poPri.OpStat =0  and poRev.OpStat =1 
				inner join tbl_Patient p on  poPri.PatientId = p.PatId 
				where 
				coalesce(p.OptOffStatId, 0) in (0,2,4) 
				and poPri.OpVal =2
				and poRev.OpVal =2
				and p.PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else p.PriSurgId end
				and CONVERT(datetime, poPri.OpDate, 103) >= case when @pOpDateFrom <> @DftDate 
							then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, poPri.OpDate, 103) end
				and CONVERT(datetime, poPri.OpDate, 103) <= case when @pOpDateTo <> @DftDate 
							then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, poPri.OpDate, 103) end
				and poPri.Hosp  = case when @pSiteId > 0 then @pSiteId else poPri.Hosp end
				/*Bind revision as well - INC000001031820 request fix*/				
				and CONVERT(datetime, poRev.OpDate, 103) >= case when @pOpDateFrom <> @DftDate 
							then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, poRev.OpDate, 103) end
				and CONVERT(datetime, poRev.OpDate, 103) <= case when @pOpDateTo <> @DftDate 
							then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, poRev.OpDate, 103) end
				and poRev.Hosp  = case when @pSiteId > 0 then @pSiteId else poRev.Hosp end				
				group by poPri.OpType, poRev.OpRevType
			) table_1
	) tRev_ops on PriOperation = PriType_	
	where p1.Id not in (10, 11)
	group by p1.Id, p1.Description ,nPrimaryCount_	
	
)

Summary_report

END






GO


