
GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonReport_SentinelEveCnt]    Script Date: 01/25/2016 14:21:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SurgeonReport_SentinelEveCnt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SurgeonReport_SentinelEveCnt]
GO


GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonReport_SentinelEveCnt]    Script Date: 01/25/2016 14:21:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








/*Gets percent of surgeons patients that have specific event reason */
/*setting @pRunForLegacyOnly = 1  will run only for LegacyPatients only
		  @pRunForLegacyOnly = 0  will run only for non - LegacyPatients only 
		  @pRunForLegacyOnly = 2 will not consider isLegacyPatient field - runs for both   */
CREATE PROCEDURE [dbo].[usp_SurgeonReport_SentinelEveCnt]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date, 
	@pRunForLegacyOnly int
AS
BEGIN		


	declare @DftDate as datetime
	set @DftDate = '01/01/1940';
	
	--Gets the eligible patients from registery - even if they don't have operation 
	With tbl_Pat_Ops_Fu_dtls(PatId, HospID, PriSurgId, SEId1, SEId2, SEId3, HealthID, DeathRelSurg, OpId, FUPeriodId, FUVal, FUId) as 
	(select p.PatId , o1.Hosp , p.PriSurgId , fu.SEId1, fu.SEId2, fu.SEId3, HStatId , p.DeathRelSurgId, o1.OpId, FUPeriodId, FUVal, FUId 
		 from 	tbl_Patient p 
				inner join tbl_PatientOperation o1 on o1.PatientId  = p.PatId 
				inner join tbl_FollowUp fu on fu.OperationId  = o1.OpId and coalesce(fu.FUVal,-1) in (0,1,2,3)  	
		 where 		 
		    coalesce(p.OptOffStatId, 0) in (0,2,4) 
			--and o1.OpStat = 0
			--and o1.OpVal=2 //Statement of work -  whether operation is submitted or not (ie OpVal does NOT need to equal 2)
			and CONVERT(datetime, OpDate, 103) >= case when @pOpDateFrom <> @DftDate then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, OpDate, 103) end
			and CONVERT(datetime, OpDate, 103) <= case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, OpDate, 103) end
			and coalesce(o1.Hosp, '') = case when @pSiteId > 0 then @pSiteId else o1.Hosp end
			and coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(p.Legacy, 0)  end) 		
		) ,	
	
	--Count of all Surgeons patients - with or without SE
	 tbl_ProcedureCntForSur(No_OF_Sur_Procedures) as 	
	(select coalesce(COUNT(distinct OpId),0) No_OF_Sur_Procedures 
	        from tbl_Pat_Ops_Fu_dtls
			where ISNULL(FUVal,0)=2 and FUPeriodID=0 and PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else PriSurgId end) ,
		
	--Count of total patients in registry (Registry shrinks to what is selected for opDates & Hosp	
	tbl_TotProcedures (Tot_Procedures) as 
	(select coalesce(COUNT(distinct OpId),0)	
	        from tbl_Pat_Ops_Fu_dtls 
	        where ISNULL(FUVal,0)=2 and FUPeriodID=0),		
		
	--Old: Gets count of patients for the surgeon and each SE
	--New: Gets count of "followups" for surgeon and each SE 
	tbl_SE_ForSur(SEID, SurPat_With_SEID) as
	(
		select 1 SEID1, coalesce(COUNT (distinct FUId),0) 
				from tbl_Pat_Ops_Fu_dtls
	 			where coalesce(SEId1, 0)> 0 and PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else PriSurgId end and FUPeriodId = 0
	 				  		
		union 
		select 2 SEID2, coalesce(COUNT (distinct FUId),0) 
				from tbl_Pat_Ops_Fu_dtls
	 			where coalesce(SEId2, 0)> 0 and PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else PriSurgId end and FUPeriodId = 0	
		union 
		select 3 SEID3, coalesce(COUNT (distinct FUId),0) 
				from tbl_Pat_Ops_Fu_dtls
	 			where coalesce(SEId3, 0)> 0 and PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else PriSurgId end and FUPeriodId = 0
	),
		
	--Old: Gets count of patients for reg and each SE	
	--New: Gets count of "followups" for reg and each SE 
	tbl_SE(SEID, TotPat_With_SEID) as
	(
		select 1 SEID1, coalesce(COUNT (distinct FUId),0) 
				from tbl_Pat_Ops_Fu_dtls
	 			where coalesce(SEId1, 0)> 0 and FUPeriodId = 0 			
		union 
		select 2 SEID2, coalesce(COUNT (distinct FUId),0) 
				from tbl_Pat_Ops_Fu_dtls
	 			where coalesce(SEId2, 0)> 0 and FUPeriodId = 0 			
		union 
		select 3 SEID3, coalesce(COUNT (distinct FUId),0) 
				from tbl_Pat_Ops_Fu_dtls
	 			where coalesce(SEId3, 0)> 0 and FUPeriodId = 0 
	),	
	/*Changed for ticket #951243 - after discussing with Nino - remove all conditions - take only table Patient and Surgeon*/
	--Count of patients of a surgeon that died 
	tbl_Dead_ForSur(SurPat_With_HthID) as
	(select isNull(count(p.PatId), 0) from tbl_Patient p 
		   inner join tbl_PatientOperation o1 on o1.PatientId  = p.PatId
     where PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else PriSurgId end
	       and coalesce(p.OptOffStatId, 0) in (0,2,4) 
		   and coalesce(HStatId, 0) = 1 
		   and coalesce(DeathRelSurgId, 0) > 0
		   and coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(p.Legacy, 0)  end)
		   and CONVERT(datetime, OpDate, 103) >= (case when @pOpDateFrom <> @DftDate then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, OpDate, 103) end)
		   and CONVERT(datetime, OpDate, 103) <= (case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, OpDate, 103) end)),
	
	tbl_Tot_Procedures_For_Sur_Health(Sur_TotProcedures_For_Counting_HthID) as
	(select isNull(count(OpId), 0) from tbl_Pat_Ops_Fu_dtls 
     where PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else PriSurgId end),		   	
	
	--Count of patients that died across registry
	tbl_TotDead(TotPat_With_HthID) as
	(select isNull(COUNT(PatID), 0)  
	  from  tbl_Patient p
	  inner join tbl_PatientOperation o1 on o1.PatientId  = p.PatId
	  where coalesce(p.HStatId, 0) = 1 
		    and coalesce(p.DeathRelSurgId, 0) > 0	
		    and coalesce(p.OptOffStatId, 0) in (0,2,4)
		    and coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(p.Legacy, 0)  end)
		    and CONVERT(datetime, OpDate, 103) >= case when @pOpDateFrom <> @DftDate then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, OpDate, 103) end
		    and CONVERT(datetime, OpDate, 103) <= case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, OpDate, 103) end),
	tbl_Tot_Procedures_For_Reg_Health(Reg_Procedures_For_Counting_HthID) as
	(select isNull(count(OpId), 0) from tbl_Pat_Ops_Fu_dtls) 
			
SELECT  * FROM 
(
	/*Displays SE event; % of patients for a surgeon with that SE (% for registry with that SE)*/	
	select SE.Description SentinalEvent, 
	 (case when No_OF_Sur_Procedures = 0 then '0' else (cast(cast((SurPat_With_SEID  * 100.00)/No_OF_Sur_Procedures as decimal(5,2)) as VARCHAR(20))) end ) + '% (' +
	 (case when Tot_Procedures = 0 then '0' else (cast(cast((TotPat_With_SEID  * 100.00)/Tot_Procedures as decimal(5,2)) as VARCHAR(20))) end ) + '%)' as SE_Cnt
	from tlkp_SentinelEvent SE
	inner join tbl_SE_ForSur SurSE on SurSE.SEID = Se.Id 
	inner join tbl_SE TotSE on TotSE.SEID = Se.Id 
	inner join tbl_TotProcedures on 'a' = 'a' 
	inner join tbl_ProcedureCntForSur on 'a' = 'a' 
	union 
	/*Union is to combine mortality rate - of patients for a surgeon (% for registry) */
	select 'Death Related to Bariatric Surgery' SentinalEvent, 
	case when Sur_TotProcedures_For_Counting_HthID > 0 then cast(cast((SurPat_With_HthID  * 100.00)/ Sur_TotProcedures_For_Counting_HthID as decimal(5,2)) as VARCHAR(20)) + 
	'%(' +  cast(cast((TotPat_With_HthID  * 100.00)/Reg_Procedures_For_Counting_HthID as decimal(5,2)) as VARCHAR(20)) + '%)' else '0' end as SE_Cnt  
	from tbl_Dead_ForSur  
		inner join tbl_Tot_Procedures_For_Sur_Health on 'a' = 'a'
		inner join tbl_TotDead on 'a' = 'a' 
		inner join tbl_Tot_Procedures_For_Reg_Health on 'a' = 'a' 
) SurgeonReport_SentinelEveCnt

	RETURN 
END

















GO


