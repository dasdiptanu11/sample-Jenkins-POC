
GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_DiaxCnt]    Script Date: 06/02/2016 11:49:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SurgeonRpt_DiaxCnt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SurgeonRpt_DiaxCnt]
GO


GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_DiaxCnt]    Script Date: 06/02/2016 11:49:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--exec usp_SurgeonRpt_DiaxCnt -1, -1, '01/01/1940' ,  '01/01/1940', 2

/*Gives No of patients undertaking treatment for each type of diabetes across thier 10 year follow Ups*/
/*setting @pRunForLegacyOnly = 1  will run only for LegacyPatients only
		  @pRunForLegacyOnly = 0  will run only for non - LegacyPatients only 
		  @pRunForLegacyOnly = 2 will not consider isLegacyPatient field - runs for both   */
CREATE PROCEDURE [dbo].[usp_SurgeonRpt_DiaxCnt]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date, 
	@pRunForLegacyOnly int
AS

BEGIN

	   	Declare @DftDate as datetime
		set @DftDate = '01/01/1940';
		SET NOCOUNT ON;
		

        Declare @tableB table
		(
		    PatID int, 
		    opID int ,
		    BL_Diab_stsID INT ,	
			BL_Diab_Treat INT, 
			Yr1_Diab_stsID INT ,	
			Yr1_Diab_Treat INT , 
			Yr2_Diab_stsID INT ,
			Yr2_Diab_Treat INT , 				
			Yr3_Diab_stsID INT , 
			Yr3_Diab_Treat INT , 
			Yr4_Diab_stsID INT ,	
			Yr4_Diab_Treat INT , 
			Yr5_Diab_stsID INT ,	
			Yr5_Diab_Treat INT , 
			Yr6_Diab_stsID INT ,	
			Yr6_Diab_Treat INT , 
			Yr7_Diab_stsID INT ,	
			Yr7_Diab_Treat INT , 
			Yr8_Diab_stsID INT ,	
			Yr8_Diab_Treat INT , 																		
			Yr9_Diab_stsID INT ,	
			Yr9_Diab_Treat INT , 																		
			Yr10_Diab_stsID INT ,	
			Yr10_Diab_Treat INT  																					
		) 	
		
        insert @tableB
		SELECT po.PatientId  patid , po.OpId OpiD , po.DiabStat BL_Diab_stsID,  po.DiabRx BL_Diab_Treat , 
		       fu1.DiabStatId  Yr1_Diab_stsID, fu1.DiabRxId  Yr1_Diab_Treat,
		       fu2.DiabStatId [Yr2_Diab_stsID] ,  fu2.DiabRxId  [Yr2_Diab_Treat],
		       fu3.DiabStatId  [Yr3_Diab_stsID],  fu3.DiabRxId  [Yr3_Diab_Treat],
		       fu4.DiabStatId  [Yr4_Diab_stsID],  fu4.DiabRxId  [Yr4_Diab_Treat],
		       fu5.DiabStatId  [Yr5_Diab_stsID],  fu5.DiabRxId  [Yr5_Diab_Treat],
		       fu6.DiabStatId  [Yr6_Diab_stsID],  fu6.DiabRxId  [Yr6_Diab_Treat],
		       fu7.DiabStatId  [Yr7_Diab_stsID],  fu7.DiabRxId  [Yr7_Diab_Treat],
		       fu8.DiabStatId [Yr8_Diab_stsID],  fu8.DiabRxId  [Yr8_Diab_Treat],
		       fu9.DiabStatId [Yr9_Diab_stsID],  fu9.DiabRxId  [Yr9_Diab_Treat],
		       fu10.DiabStatId [Yr10_Diab_stsID],  fu10.DiabRxId  [Yr10_Diab_Treat]
		      
		FROM tbl_Patient p inner join tbl_PatientOperation po  on po.PatientId = p.PatId 
		left outer join tbl_FollowUp fu1 on fu1.OperationId = po.OpId and fu1.FUPeriodId = 1 and fu1.FUVal = 2 
		left outer join tbl_FollowUp fu2 on fu2.OperationId = po.OpId and fu2.FUPeriodId = 2 and fu2.FUVal = 2
		left outer join tbl_FollowUp fu3 on fu3.OperationId = po.OpId and fu3.FUPeriodId = 3 and fu3.FUVal = 2
		left outer join tbl_FollowUp fu4 on fu4.OperationId = po.OpId and fu4.FUPeriodId = 4 and fu4.FUVal = 2
		left outer join tbl_FollowUp fu5 on fu5.OperationId = po.OpId and fu5.FUPeriodId = 5 and fu5.FUVal = 2
		left outer join tbl_FollowUp fu6 on fu6.OperationId = po.OpId and fu6.FUPeriodId = 6 and fu6.FUVal = 2
		left outer join tbl_FollowUp fu7 on fu7.OperationId = po.OpId and fu7.FUPeriodId = 7 and fu7.FUVal = 2
		left outer join tbl_FollowUp fu8 on fu8.OperationId = po.OpId and fu8.FUPeriodId = 8 and fu8.FUVal = 2
		left outer join tbl_FollowUp fu9 on fu9.OperationId = po.OpId and fu9.FUPeriodId = 9 and fu9.FUVal = 2
		left outer join tbl_FollowUp fu10 on fu10.OperationId = po.OpId and fu10.FUPeriodId = 10 and fu10.FUVal = 2
		WHERE  coalesce(Legacy, 0) = 0 and OpStat  = 0			  
			  and  coalesce(p.OptOffStatId, 0)in (0,2,4)
			  and po.DiabStat = 1
	          and CONVERT(datetime, OpDate, 103) <= case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, OpDate, 103) end
	          and Hosp = case when @pSiteId > 0 then @pSiteId else Hosp end 
	          and p.PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else p.PriSurgId end ;	
		--order by po.PatientId , po.OpId


        --select * from @tableB ;
        
             
        ;
        With denominator(Description, deno_bl, deno1, deno2, deno3, deno4, deno5, deno6, deno7, deno8, deno9, deno10 )
        as(        
        select 'Denominator', 
        SUM(case when BL_Diab_stsID is not null  then 1 else 0 end) Year_BL,
        SUM(case when Yr1_Diab_stsID is not null  then 1 else 0 end) Year_1,
        SUM(case when Yr2_Diab_stsID is not null then 1 else 0 end) Year_2,
        SUM(case when Yr3_Diab_stsID is not null then 1 else 0 end) Year_3, 
        SUM(case when Yr4_Diab_stsID is not null then 1 else 0 end) Year_4,
        SUM(case when Yr5_Diab_stsID is not null then 1 else 0 end) Year_5,
        SUM(case when Yr6_Diab_stsID is not null then 1 else 0 end) Year_6,
        SUM(case when Yr7_Diab_stsID is not null then 1 else 0 end) Year_7, 
        SUM(case when Yr8_Diab_stsID is not null then 1 else 0 end) Year_8,
        SUM(case when Yr9_Diab_stsID is not null then 1 else 0 end) Year_9,
        SUM(case when Yr10_Diab_stsID is not null then 1 else 0 end) Year_10 from @tableB),
        rpt_(id_, Description_, year_BL, Year_1, Year_2,Year_3, Year_4, Year_5, Year_6, Year_7, Year_8, Year_9, Year_10) as 
        (
        SELECT 0, 'Surgery Alone', null,
        SUM(case when coalesce(Yr1_Diab_stsID, 99) = 0 then 1 else 0 end) Year_1,
        SUM(case when coalesce(Yr2_Diab_stsID, 99) = 0 then 1 else 0 end) Year_2,
        SUM(case when coalesce(Yr3_Diab_stsID, 99) = 0 then 1 else 0 end) Year_3, 
        SUM(case when coalesce(Yr4_Diab_stsID, 99) = 0 then 1 else 0 end) Year_4,
        SUM(case when coalesce(Yr5_Diab_stsID, 99) = 0 then 1 else 0 end) Year_5,
        SUM(case when coalesce(Yr6_Diab_stsID, 99) = 0 then 1 else 0 end) Year_6,
        SUM(case when coalesce(Yr7_Diab_stsID, 99) = 0 then 1 else 0 end) Year_7, 
        SUM(case when coalesce(Yr8_Diab_stsID, 99) = 0 then 1 else 0 end) Year_8,
        SUM(case when coalesce(Yr9_Diab_stsID, 99) = 0 then 1 else 0 end) Year_9,
        SUM(case when coalesce(Yr10_Diab_stsID, 99) = 0 then 1 else 0 end) Year_10 from @tableB
		union all
		SELECT dt.Id , dt.Description,
		 SUM(case when coalesce(BL_Diab_stsID, 99) = 1 and dt.Id = coalesce(BL_Diab_Treat , 99) then 1 else 0 end) Year_BL,
		 SUM(case when coalesce(Yr1_Diab_stsID, 99) = 1 and dt.Id = coalesce(Yr1_Diab_Treat , 99) then 1 else 0 end) Year_1,
         SUM(case when coalesce(Yr2_Diab_stsID, 99) = 1 and dt.Id = coalesce(Yr2_Diab_Treat , 99) then 1 else 0 end) Year_2,
         SUM(case when coalesce(Yr3_Diab_stsID, 99) = 1 and dt.Id = coalesce(Yr3_Diab_Treat , 99) then 1 else 0 end) Year_3, 
         SUM(case when coalesce(Yr4_Diab_stsID, 99) = 1 and dt.Id = coalesce(Yr4_Diab_Treat , 99) then 1 else 0 end) Year_4,
         SUM(case when coalesce(Yr5_Diab_stsID, 99) = 1 and dt.Id = coalesce(Yr5_Diab_Treat , 99) then 1 else 0 end) Year_5,
         SUM(case when coalesce(Yr6_Diab_stsID, 99) = 1 and dt.Id = coalesce(Yr6_Diab_Treat , 99) then 1 else 0 end) Year_6,
         SUM(case when coalesce(Yr7_Diab_stsID, 99) = 1 and dt.Id = coalesce(Yr7_Diab_Treat , 99) then 1 else 0 end) Year_7, 
         SUM(case when coalesce(Yr8_Diab_stsID, 99) = 1 and dt.Id = coalesce(Yr8_Diab_Treat , 99) then 1 else 0 end) Year_8,
         SUM(case when coalesce(Yr9_Diab_stsID, 99) = 1 and dt.Id = coalesce(Yr9_Diab_Treat , 99) then 1 else 0 end) Year_9,
         SUM(case when coalesce(Yr10_Diab_stsID, 99) = 1 and dt.Id = coalesce(Yr10_Diab_Treat , 99) then 1 else 0 end) Year_10		
		from tlkp_DiabetesTreatment dt inner join @tableB on 'a' = 'a'
		where dt.Id <> 5
		group by dt.Id , dt.Description   
		union all
		SELECT dt.Id , dt.Description,
		 SUM(case when coalesce(BL_Diab_stsID, 98) = 99 or dt.Id = coalesce(BL_Diab_Treat , 99) then 1.00 else 0 end) Year_BL,
		 SUM(case when coalesce(Yr1_Diab_stsID, 98) = 99 or dt.Id = coalesce(Yr1_Diab_Treat , 99) then 1.00 else 0 end) Year_1,
         SUM(case when coalesce(Yr2_Diab_stsID, 98) = 99 or dt.Id = coalesce(Yr2_Diab_Treat , 99) then 1.00 else 0 end) Year_2,
         SUM(case when coalesce(Yr3_Diab_stsID, 98) = 99 or dt.Id = coalesce(Yr3_Diab_Treat , 99) then 1.00 else 0 end) Year_3, 
         SUM(case when coalesce(Yr4_Diab_stsID, 98) = 99 or dt.Id = coalesce(Yr4_Diab_Treat , 99) then 1.00 else 0 end) Year_4,
         SUM(case when coalesce(Yr5_Diab_stsID, 98) = 99 or dt.Id = coalesce(Yr5_Diab_Treat , 99) then 1.00 else 0 end) Year_5,
         SUM(case when coalesce(Yr6_Diab_stsID, 98) = 99 or dt.Id = coalesce(Yr6_Diab_Treat , 99) then 1.00 else 0 end) Year_6,
         SUM(case when coalesce(Yr7_Diab_stsID, 98) = 99 or dt.Id = coalesce(Yr7_Diab_Treat , 99) then 1.00 else 0 end) Year_7, 
         SUM(case when coalesce(Yr8_Diab_stsID, 98) = 99 or dt.Id = coalesce(Yr8_Diab_Treat , 99) then 1.00 else 0 end) Year_8,
         SUM(case when coalesce(Yr9_Diab_stsID, 98) = 99 or dt.Id = coalesce(Yr9_Diab_Treat , 99) then 1.00 else 0 end) Year_9,
         SUM(case when coalesce(Yr10_Diab_stsID, 99) = 99 or dt.Id = coalesce(Yr10_Diab_Treat , 99) then 1.00 else 0 end) Year_10		
		from tlkp_DiabetesTreatment dt inner join @tableB on 'a' = 'a'
		where dt.Id = 5
		group by dt.Id , dt.Description            

		)        
		SELECT  * FROM 
		(   
		   SELECT '' Treatment , 
		          'Baseline Treatment of the patients who identify as having diabetes (%) ' + NCHAR(0x00b2)  BaseLine, 
		          '1 Yr' Year_1 , '2 Yrs' Year_2, '3 Yrs' Year_3 , '4 Yrs' Year_4, '5 Yrs' Year_5 , 
		          '6 Yrs' Year_6 , '7 Yrs' Year_7 , '8 Yrs' Year_8 , '9 Yrs' Year_9, '10 Yrs' Year_10		          
		Union all 
        SELECT '' Treatment , 
          'n = ' + CAST(deno_bl as varchar(10)) BaseLine, 
          'n = ' + cast(deno1 as varchar(10)), 'n = ' + cast(deno2 as varchar(20))  Year_2, 
          'n = ' + cast(deno3 as varchar(20)) Year_3, 'n = ' + cast(deno4  as varchar(20)) Year_4, 
          'n = ' + cast(deno5 as varchar(20)) Year_5, 'n = ' + cast(deno6 as varchar(20)) Year_6, 
          'n = ' + cast(deno7 as varchar(20)) Year_7, 'n = ' + cast(deno8  as varchar(20)) Year_8, 
          'n = ' + cast(deno9 as varchar(20)) Year_9 ,'n = ' + cast(deno10 as varchar(20)) Year_10 from  denominator
	   Union all 	
		Select Description_ Treatment,			
			cast(cast(case when deno_bl = 0 or Year_BL = 0 then null else Year_BL/deno_bl * 100 end as decimal(10, 1)) as varchar(20)) BaseLine, 
			cast(cast(case when deno1 = 0 or Year_1 = 0 then null else Year_1/deno1 * 100 end as decimal(10, 1)) as varchar(20)) Year_1,  
			cast(cast(case when deno2 = 0 or Year_2 = 0 then null else Year_2/deno2 * 100 end as decimal(10, 1)) as varchar(20)) Year_2,  
			cast(cast(case when deno3 = 0 or Year_3 = 0 then null else Year_3/deno3 * 100 end as decimal(10, 1)) as varchar(20)) Year_3,  
			cast(cast(case when deno4 = 0 or Year_4 = 0 then null else Year_4/deno4 * 100 end as decimal(10, 1)) as varchar(20)) Year_4,  
			cast(cast(case when deno5 = 0 or Year_5 = 0 then null else Year_5/deno5 * 100 end as decimal(10, 1)) as varchar(20)) Year_5,  
			cast(cast(case when deno6 = 0 or Year_6 = 0 then null else Year_6/deno6 * 100 end as decimal(10, 1))  as varchar(20))Year_6,  
			cast(cast(case when deno7 = 0 or Year_7 = 0 then null else Year_7/deno7 * 100 end as decimal(10, 1)) as varchar(20)) Year_7,  
			cast(cast(case when deno8 = 0 or Year_8 = 0 then null else Year_8/deno8 * 100 end as decimal(10, 1)) as varchar(20)) Year_8,  
			cast(cast(case when deno9 = 0 or Year_9 = 0 then null else Year_9/deno9 * 100 end  as decimal(10, 1))  as varchar(20))Year_9,
			cast(cast(case when deno10 = 0 or Year_10 = 0 then null else Year_10/deno10 * 100 end  as decimal(10, 1)) as varchar(20)) Year_10  
			from  rpt_
			inner join denominator on 'a' = 'a'
			
			--ORDER BY diabTreatID
		)
		SurgeonRpt_DiaxCnt

END











GO


