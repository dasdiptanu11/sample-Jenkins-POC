
GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_PatCnt]    Script Date: 01/29/2016 12:23:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SurgeonRpt_PatCnt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SurgeonRpt_PatCnt]
GO


GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_PatCnt]    Script Date: 01/29/2016 12:23:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--exec usp_SurgeonRpt_PatCnt 0,0,'01/01/1940','01/01/1940', 2
/*This gives count of patients for surgeon that have Renal transplant, liver transplant, daibetes etc*/
/*setting @pRunForLegacyOnly = 1  will run only for LegacyPatients only
		  @pRunForLegacyOnly = 0  will run only for non - LegacyPatients only 
		  @pRunForLegacyOnly = 2 will not consider isLegacyPatient field - runs for both   */
CREATE PROCEDURE [dbo].[usp_SurgeonRpt_PatCnt]
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
 SET DATEFORMAT dmy;
	
	/*Fetches details of all patients in registry according to selection criteria specified*/	
	With T_OperationNPatDtls(OperationProc, OperationType, OperationID, PatientID, DiabetesStatus, DiabRx, SurgeonID, RenalTx, LiverTx, FUVAL ) as
	(select op.OpType, OpStat, op.OPId, p.PatId, op.DiabStat , op.DiabRx, p.PriSurgId , coalesce(op.RenalTx, 0) , 
	coalesce(op.LiverTx, 0), fu.FUVal 
	from tbl_PatientOperation op 
	     inner join tbl_Patient p on p.PatId = op.PatientId 
	     left outer join tbl_followup fu on fu.OperationId = op.OpId
	where coalesce(p.OptOffStatId, 0) in (0,2,4) 
	--and op.OpVal = 2	
	and CONVERT(datetime, op.OpDate, 103) >= case when @pOpDateFrom <> @DftDate 
				then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, op.OpDate, 103) end
	and CONVERT(datetime, op.OpDate, 103) <= case when @pOpDateTo <> @DftDate 
				then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, op.OpDate, 103) end
	and op.Hosp  = case when @pSiteId > 0 then @pSiteId else op.Hosp end 
	and coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(p.Legacy, 0) end)), 
	
	/*Gets no of patients that have renal transplant from fetched details*/
	TotPatWithRenalTx(TotRenalPatients) as
	(SELECT count(distinct PatientID)  
	 from T_OperationNPatDtls 
	 where RenalTx = 1), 
	
	/*Gets no of patients that have renal transplant from fetched details for particular surgeon*/
	SurPatWithRenalTx(SurRenalPatients) as 
	(SELECT count(distinct PatientID) 
	 from T_OperationNPatDtls 
	 where RenalTx = 1 
	       and SurgeonID = case when @pSurgeonId > 0 then @pSurgeonId else SurgeonID  end 
	 ), 
	
	/*Gets no of patients that have liver transplant from fetched details*/
	TotPatWithLiverTx(TotLiverPatients) as
	(SELECT count(distinct PatientID) 
	 from T_OperationNPatDtls 
	 where LiverTx = 1), 
	
	/*Gets no of patients that have liver transplant from fetched details for given surgeon*/
	SurPatWithLiverTx(SurLiverPatients) as
	(SELECT coalesce(count(distinct PatientID),0) 
	 from T_OperationNPatDtls 
	 where LiverTx = 1 
	       and SurgeonID = case when @pSurgeonId > 0 then @pSurgeonId else SurgeonID  end ),
	
	/*Count of total patients with primary */
	TotPat(TotPatCnt) as
	(SELECT count(distinct PatientID) TotPatInReg 
	 from T_OperationNPatDtls ),
	
	/*Count of total patients with primary for given surgeon */	
	PatForSurg(SurPatCnt) as
	(SELECT count(distinct PatientID) PatForSurgeon 
	 from T_OperationNPatDtls 
	 where SurgeonID = case when @pSurgeonId > 0 then @pSurgeonId else SurgeonID  end),
	 
	 /*Count of total procedures for Surgeon */
	 ProcedureCountForSurg(SurProcCnt) as
	 (SELECT count(distinct OperationID) ProcCntForSurgeon 
	 from T_OperationNPatDtls 
	 where SurgeonID = case when @pSurgeonId > 0 then @pSurgeonId else SurgeonID  end),
	 
	 /*Count of total patients with primary */
	TotProcedures(TotProcCnt) as
	(SELECT count(distinct OperationID) TotProcInReg 
	 from T_OperationNPatDtls ),
	 
	 /*Count of total patients with primary LTFU Phoned */
	TotPatLTFUPhoned(TotPatCntLTFUPhoned) as
	(SELECT count(distinct PatientID) TotPatInRegLTFUPhoned 
	 from T_OperationNPatDtls where FUVAL in (2,3)),
	
	/*Count of total patients with primary for given surgeon LTFU Phoned */	
	PatForSurgLTFUPhoned(SurPatCntLTFUPhoned) as
	(SELECT count(distinct PatientID) PatForSurgeonLTFUPhoned 
	 from T_OperationNPatDtls 
	 where FUVAL in (2,3) and SurgeonID = case when @pSurgeonId > 0 then @pSurgeonId else SurgeonID  end),
	 
	 
	
	/*Count of total patients with primary but having diabetes*/		
	TotPatWithDia(TotPatWithDiaCnt) as
	(SELECT count(distinct PatientID) TotPatInRegWithDiabetes 
	 from T_OperationNPatDtls where DiabetesStatus =1) ,
	
	/*Count of total patients with primary but having diabetes for given surgeon */		
	PatForSurgWithDia(PatForSurgWithDiaCnt) as
	(SELECT count(distinct PatientID) PatsWithDiabetesForSurgeon 
	 from T_OperationNPatDtls 
	 where SurgeonID = case when @pSurgeonId > 0 then @pSurgeonId else SurgeonID  end and DiabetesStatus =1) ,
	
		
	/*LTFU patients for given criteria - removed all conditionsd - INC000001026752*/
			
	LTFU_Patient_Cnt_For_Surg(LTFU_Patients_Perc_Sur) as
	(SELECT  case 
	         when 
	          (select COUNT(p.PatId) from tbl_Patient p) > 0 then 
	                 ((select COUNT(p.PatId) from tbl_Patient p where OptOffStatId = 4 
	                               and p.PriSurgId  = case when @pSurgeonId > 0 then @pSurgeonId else PriSurgId  end 
	                               and coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(p.Legacy, 0) end)) * 100.00
	                         / (select COUNT(p.PatId) from tbl_Patient p where coalesce(p.OptOffStatId, 0) in (0,2,4) ))  
	         else 0 end ) ,

    LTFU_Patient_Cnt_For_Reg(LTFU_Patients_Perc_Reg) as
	(SELECT  case 
	         when 
	          (select COUNT(p.PatId) from tbl_Patient p) > 0 then 
	           (select COUNT(p.PatId) from tbl_Patient p where OptOffStatId = 4 and coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(p.Legacy, 0) end)) * 100.00
	           /(select COUNT(p.PatId) from tbl_Patient p where coalesce(p.OptOffStatId, 0) in (0,2,4) ) 
	         else 0 end),
	 
	
	/*LTFU patients for given criteria*/		
	LTFU_Patients_For_Attm(SurgeonID, AttemptedCalls, NoOfPatients) as
	(SELECT SurgeonID ,coalesce(f.AttmptCallId, 0), COUNT(distinct f.PatientId) 
	 from tbl_FollowUp f 
	 inner join T_OperationNPatDtls o on f.OperationId = o.OperationID 
	 where coalesce(f.FUVal,0) in (2,3)	and LTFU = 1        
	 group by SurgeonID,coalesce(f.AttmptCallId, 0)) ,
	  
	
	 /*LTFU patients for given criteria and given surgeon that were called */		
	 LTFUPatCalled_Sur(NoOfLTFUPatCalled_Sur) as
	(SELECT SUM(NoOfPatients) from LTFU_Patients_For_Attm 
	 where AttemptedCalls> 0 and SurgeonID = case when @pSurgeonId > 0 then @pSurgeonId else SurgeonID  end ),
	  
	 
	 /*LTFU patients for given criteria in Registry that were called */		
	 LTFUPatCalledInReg(NoOfLTFUPatCalled_Reg) as
	(SELECT SUM(NoOfPatients) from LTFU_Patients_For_Attm where AttemptedCalls> 0 )
	
	select * from 
	(
		select coalesce(TotPatCnt, 0) TotPatCnt , coalesce(TotPatWithDiaCnt,0) TotPatWithDiaCnt, 
		coalesce(SurPatCnt,0) SurPatCnt , coalesce(PatForSurgWithDiaCnt,0) PatForSurgWithDiaCnt ,
		cast(cast(coalesce(SurRenalPatients,0)*100.00/(case when coalesce(SurProcCnt ,1) = 0 then 1 else coalesce(SurProcCnt ,1) end) as decimal(5,1)) as varchar(20))+ '% (' +
		cast(cast(coalesce(TotRenalPatients,0)*100.00/(case when coalesce(TotProcCnt ,1) = 0 then 1 else coalesce(TotProcCnt ,1) end) as decimal(5,1)) as varchar(20)) + '%)' RenalPatientsPercent,
		cast(cast(coalesce(SurLiverPatients,0)*100.00/(case when coalesce(SurProcCnt ,1) = 0 then 1 else coalesce(SurProcCnt ,1) end) as decimal(5,1)) as varchar(20))+ '% (' +
		cast(cast(coalesce(TotLiverPatients,0)*100.00/(case when coalesce(TotProcCnt ,1) = 0 then 1 else coalesce(TotProcCnt ,1) end) as decimal(5,1)) as varchar(20)) + '%)' LiverPatientsPercent,
		cast(cast(LTFU_Patients_Perc_Sur as decimal(5,1)) as varchar(20))+ '% (' +		
		cast(cast(LTFU_Patients_Perc_Reg as decimal(5,1)) as varchar(20)) + '%)' SurgeonPatients, 
		cast(cast(coalesce(NoOfLTFUPatCalled_Sur,0)*100.00/(case when coalesce(SurPatCntLTFUPhoned ,1) = 0 then 1 else coalesce(SurPatCntLTFUPhoned ,1) end) as decimal(5,1)) as varchar(20))+ '% (' +
	    cast(cast(coalesce(NoOfLTFUPatCalled_Reg,0)*100.00/(case when coalesce(TotPatCntLTFUPhoned ,1) =0 then 1 else coalesce(TotPatCntLTFUPhoned ,1) end) as decimal(5,1)) as varchar(20)) + '%)' SurgeonPatientCalled	 
			
		from 
		 TotPatWithRenalTx, SurPatWithRenalTx, TotPatWithLiverTx, 
		SurPatWithLiverTx, TotPat, TotPatWithDia, PatForSurg, PatForSurgWithDia,LTFU_Patient_Cnt_For_Surg,LTFU_Patient_Cnt_For_Reg, 
		LTFUPatCalled_Sur, LTFUPatCalledInReg,TotPatLTFUPhoned, PatForSurgLTFUPhoned, ProcedureCountForSurg, TotProcedures
	) SurgeonRpt_PatCnt
	RETURN 
END








GO


