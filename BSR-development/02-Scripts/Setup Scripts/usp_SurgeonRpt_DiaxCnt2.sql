
/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_DiaxCnt2]    Script Date: 09/21/2015 14:02:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SurgeonRpt_DiaxCnt2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SurgeonRpt_DiaxCnt2]
GO


/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_DiaxCnt2]    Script Date: 09/21/2015 14:02:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--exec usp_SurgeonRpt_DiaxCnt2 -1, -1, '01/01/1940' ,  '01/01/1940', 2

/*Gives No of patients undertaking treatment for each type of diabetes across thier 10 year follow Ups*/
/*setting @pRunForLegacyOnly = 1  will run only for LegacyPatients only
		  @pRunForLegacyOnly = 0  will run only for non - LegacyPatients only 
		  @pRunForLegacyOnly = 2 will not consider isLegacyPatient field - runs for both   */
CREATE PROCEDURE [dbo].[usp_SurgeonRpt_DiaxCnt2]
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
	
	Declare @tb_followUp table
	(    
		FUPeriodId INT,
		DiabRxId INT,
		OperationId INT, 
		DiabStatId INT 		
	)
	
	 	
	Declare @tableB table
	(
		diabTreatID INT,	
		diabTreat Varchar(100), 
		DTY0 int, 
		DTY1 int, 
		DTY2 int, 
		DTY3 int, 
		DTY4 int, 
		DTY5 int, 
		DTY6 int, 
		DTY7 int, 
		DTY8 int, 
		DTY9 int,
		DTY10 int
	) ;
		
	--begin try	
	
		INSERT @tbl_eligibleOps
		SELECT po.PatientId , po.OpId ,po.DiabStat, po.DiabRx  
		FROM tbl_Patient p inner join tbl_PatientOperation po  on po.PatientId = p.PatId 
		WHERE coalesce(Legacy, 0) = 0 
              and OpStat  = 0
              and p.OptOffStatId in (0, 2,4)
              	  --and CONVERT(datetime, OpDate, 103) >= case when @pOpDateFrom <> @DftDate then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, OpDate, 103) end
			  and CONVERT(datetime, OpDate, 103) <= case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, OpDate, 103) end
			  and Hosp = case when @pSiteId > 0 then @pSiteId else Hosp end 
			  and p.PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else p.PriSurgId end ;	
	

		INSERT @tb_followUp 
		SELECT fu.FUPeriodId FUPeriod, fu.DiabRxId diabTreat , fu.OperationId opID, fu.DiabStatId  
		FROM tbl_FollowUp fu inner join @tbl_eligibleOps on fu.OperationId = opID 
		WHERE fu.FUVal = 2;
		
					
		WITH t1 (OperationId, FuPeriodIDForDiab) as 
		  (SELECT  OperationId , MIN(FUPeriodId) 
		   FROM @tb_followUp 
		   WHERE DiabStatId = 1 and 
				 OperationId not in (SELECT Opid FROM @tbl_eligibleOps WHERE coalesce(diabStsBaseLine, 0) = 1)
		   GROUP BY OperationId),
		    t2(OperationId,FuPeriodIDForDiab, DiabTreatID) as
		   (SELECT t1.OperationId, t1.FuPeriodIDForDiab, f2.DiabRxId 
			FROM t1 inner join @tb_followUp f2 on t1.OperationId = f2.OperationId and t1.FuPeriodIDForDiab = f2.FUPeriodId 
		   union all
		   SELECT opID, 0 , diabTreatBaseLine 
			FROM @tbl_eligibleOps 
			WHERE coalesce(diabStsBaseLine, 0) = 1   
		  )
		INSERT @tableB
		SELECT dt.Id, dt.Description DiabTreat, 
			   sum(case when FuPeriodIDForDiab = 0 then 1 else 0 end ),
			   sum(case when FuPeriodIDForDiab = 1 then 1 else 0 end ),
			   sum(case when FuPeriodIDForDiab = 2 then 1 else 0 end ),
			   sum(case when FuPeriodIDForDiab = 3 then 1 else 0 end ),
			   sum(case when FuPeriodIDForDiab = 4 then 1 else 0 end ),
			   sum(case when FuPeriodIDForDiab = 5 then 1 else 0 end ),
			   sum(case when FuPeriodIDForDiab = 6 then 1 else 0 end ),
			   sum(case when FuPeriodIDForDiab = 7 then 1 else 0 end ),
			   sum(case when FuPeriodIDForDiab = 8 then 1 else 0 end ),
			   sum(case when FuPeriodIDForDiab = 9 then 1 else 0 end ),
			   sum(case when FuPeriodIDForDiab = 10 then 1 else 0 end )  
		FROM tlkp_DiabetesTreatment dt  inner join t2 on dt.Id = t2.DiabTreatID 
		GROUP BY dt.Id, dt.Description ;		  
		  
	   WITH T1(PPDNy0, PPDNy1,PPDNy2, PPDNy3, PPDNy4, PPDNy5, PPDNy6, PPDNy7, PPDNy8, PPDNy9, PPDNy10) as
		(SELECT SUM(DTY0) * 1.00,SUM(DTY1) * 1.00, SUM(DTY2) * 1.00, SUM(DTY3) * 1.00, SUM(DTY4) * 1.00, 
				SUM(DTY5) * 1.00, SUM(DTY6) * 1.00, SUM(DTY7) * 1.00, SUM(DTY8) * 1.00, SUM(DTY9)  * 1.00, SUM(DTY10)  * 1.00
		 FROM @tableB)   
			SELECT  * FROM 
			(    
			    SELECT '' Treatment , 
		          '' BaseLine, 
		          'Yr 1' Year_1 , 'Yr 2' Year_2, 'Yr 3' Year_3 , 'Yr 4' Year_4, 'Yr 5' Year_5 , 
		          'Yr 6' Year_6 , 'Yr 7' Year_7 , 'Yr 8' Year_8 , 'Yr 9' Year_9, 'Yr 10' Year_10		          
				Union all     
				SELECT '' Treatment , 
					  '0' BaseLine, 
					  'n = ' + cast(FLOOR(PPDNy1) as varchar(20)) Year_1, 'n = ' + cast(FLOOR(PPDNy2) as varchar(20))  Year_2, 
					  'n = ' + cast(FLOOR(PPDNy3) as varchar(20)) Year_3, 'n = ' + cast(FLOOR(PPDNy4)  as varchar(20)) Year_4, 
					  'n = ' + cast(FLOOR(PPDNy5) as varchar(20)) Year_5, 'n = ' + cast(FLOOR(PPDNy6) as varchar(20)) Year_6, 
					  'n = ' + cast(FLOOR(PPDNy7) as varchar(20)) Year_7, 'n = ' + cast(FLOOR(PPDNy8)  as varchar(20)) Year_8, 
					  'n = ' + cast(FLOOR(PPDNy9) as varchar(20)) Year_9 ,'n = ' + cast( FLOOR(PPDNy10) as varchar(20)) Year_10
				FROM T1
				Union ALL			         
				SELECT DiabTreat Treatment,
					cast(cast(case when PPDNy0 = 0 OR DTY0 = 0 then null else DTY0/PPDNy0 * 100 end as decimal(10, 1)) as varchar(20)) BaseLine, 
					cast(cast(case when PPDNy1 = 0 OR DTY1 = 0  then null else DTY1/PPDNy1 * 100 end as decimal(10, 1)) as varchar(20)) Year1,  
					cast(cast(case when PPDNy2 = 0 OR DTY2 = 0 then null else DTY2/PPDNy2 * 100 end as decimal(10, 1)) as varchar(20)) Year2,  
					cast(cast(case when PPDNy3 = 0 OR DTY3 = 0 then null else DTY3/PPDNy3 * 100 end as decimal(10, 1)) as varchar(20)) Year3,  
					cast(cast(case when PPDNy4 = 0 OR DTY4 = 0 then null else DTY4/PPDNy4 * 100 end as decimal(10, 1)) as varchar(20)) Year4,  
					cast(cast(case when PPDNy5 = 0 OR DTY5 = 0 then null else DTY5/PPDNy5 * 100 end as decimal(10, 1)) as varchar(20)) Year5,  
					cast(cast(case when PPDNy6 = 0 OR DTY6 = 0 then null else DTY6/PPDNy6 * 100 end as decimal(10, 1)) as varchar(20)) Year6,  
					cast(cast(case when PPDNy7 = 0 OR DTY7 = 0 then null else DTY7/PPDNy7 * 100 end as decimal(10, 1)) as varchar(20)) Year7,  
					cast(cast(case when PPDNy8 = 0 OR DTY8 = 0 then null else DTY8/PPDNy8 * 100 end as decimal(10, 1)) as varchar(20)) Year8,  
					cast(cast(case when PPDNy9 = 0 OR DTY9 = 0 then null else DTY9/PPDNy9 * 100 end  as decimal(10, 1)) as varchar(20)) Year9,
					cast(cast(case when PPDNy10 = 0 OR DTY10 = 0 then null else DTY10/PPDNy10 * 100 end  as decimal(10, 1)) as varchar(20)) Year10
				FROM @tableB inner join T1 on 'a'='a' 
				--ORDER BY diabTreatID	
 )
	SurgeonRpt_DiaxCnt

END











GO


