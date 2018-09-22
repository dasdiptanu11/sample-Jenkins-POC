

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_DiaxCnt3]    Script Date: 09/21/2015 14:02:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SurgeonRpt_DiaxCnt3]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SurgeonRpt_DiaxCnt3]
GO


/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_DiaxCnt3]    Script Date: 09/21/2015 14:02:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--exec usp_SurgeonRpt_DiaxCnt3 -1, -1, '01/01/1940', '01/01/1940', 0

CREATE PROCEDURE [dbo].[usp_SurgeonRpt_DiaxCnt3]
@pSiteId int,
@pSurgeonId int,
@pOpDateFrom date,
@pOpDateTo date, 
@pRunForLegacyOnly int
AS

BEGIN

	declare @DftDate as datetime
	set @DftDate = '01/01/1940';
	SET NOCOUNT ON;

	Declare @tbl_eligibleOps table
	(
		patID INT,
		opID INT,
		diabStsBaseLine INT,
		diabTreatBaseLine INT 		
	)
	
	/*Only patients with diabetes @ baseline are eligible*/
	INSERT @tbl_eligibleOps
	SELECT po.PatientId , po.OpId , isNull(po.DiabStat, 0), po.DiabRx  
	FROM tbl_Patient p inner join tbl_PatientOperation po  on po.PatientId = p.PatId 
	WHERE isNull(Legacy, 0) = 0 and OpStat  = 0			  
		  and isNull(p.OptOffStatId, 0)in (0,2,4)		  
		  --and CONVERT(datetime, OpDate, 103) >= case when @pOpDateFrom <> @DftDate then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, OpDate, 103) end
		  and CONVERT(datetime, OpDate, 103) <= case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, OpDate, 103) end
		  and Hosp = case when @pSiteId > 0 then @pSiteId else Hosp end 
		  and p.PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else p.PriSurgId end 
		  ;	

	


	WITH T1 (ppdb, ppundb,  ppndb, pp) as 
	(SELECT SUM(case when isNull(diabStsBaseLine, 0) = 1 then 1 else 0 end ) ppdb, 
	        SUM(case when isNull(diabStsBaseLine, 0) = 99 then 1 else 0 end) ppundb, 
	        SUM(case when isNull(diabStsBaseLine, 0) = 0 then 1 else 0 end) ppundb, 
	       (count(*) * 1.00)  pp  FROM @tbl_eligibleOps
	),
	T2(opid) as
	(
		select distinct fu.OperationId from tbl_FollowUp fu 
		inner join @tbl_eligibleOps on opID = fu.OperationId 
		where isNull(diabStsBaseLine, 0) = 0 and FUPeriodId > 0 and FUVal = 2 
		and isNull(fu.DiabStatId, 0) = 1),
	T3(PPDNy)    as
	(
	  select COUNT(*) from T2
	)  	
	select * from 
	(        
	  select top 1 'The percentage of primary patients in BSR who were identified as having diabetes at baseline was ' + 
       CAST(cast((ppdb/pp * 100) as decimal(10, 1))as varchar(20)) + '%. ' + 
       CAST(cast((ppundb/pp * 100) as decimal(10, 1))as varchar(20)) 
       + '% of primary patient''s diabetes'' status was not stated or inadequately described. '   Description1, 
        'There were ' + CAST(PPDNy as varchar(10)) 
       + ' primary patients who developed diabetes after undergoing their primary procedure which is ' + 
       CAST(cast((PPDNy/(ppndb * 1.00) * 100) as decimal(10,2)) as varchar(25)) + '%'  Description2       
        from T1 inner join T3 on 'a' = 'a'	
) usp_
END 

GO


