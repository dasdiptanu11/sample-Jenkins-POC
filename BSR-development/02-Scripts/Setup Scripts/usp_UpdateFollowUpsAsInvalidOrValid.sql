
GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateFollowUpsAsInvalidOrValid]    Script Date: 02/15/2016 11:44:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_UpdateFollowUpsAsInvalidOrValid]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_UpdateFollowUpsAsInvalidOrValid]
GO


GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateFollowUpsAsInvalidOrValid]    Script Date: 02/15/2016 11:44:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_UpdateFollowUpsAsInvalidOrValid]
AS
BEGIN

   
	/*CAUTION: Do not change the sequence*/


	/*SQL 1: Delete pending follow ups for dead*/ 
	
	/*Delete Complications first and then delete Followups */	
	Delete from tbl_PatientComplications where fuid in (select  fuid from dbo.tbl_followUp 
	where  FUVal not in (1,2) -- are not completed
		   and patientID in 
		   ( 
				SELECT patid --patients who have deceased
				from dbo.tbl_Patient p 
				where coalesce(p.HStatId, 0) = 1
			));  
	/*Delete Followups */		
	Delete from dbo.tbl_followUp 
	where  FUVal not in (1,2) -- are not completed
		   and patientID in 
		   ( 
				SELECT patid --patients who have deceased
				from dbo.tbl_Patient p 
				where coalesce(p.HStatId, 0) = 1
			);  


	/*SQL 2: Delete all follow ups for fully opted off*/ 
	/*Delete Complications first and then delete Followups */	
	Delete from tbl_PatientComplications where fuid in (select  fuid from dbo.tbl_followUp 
	where  patientID in 
	( 	    
		SELECT patid --patients who have fully opted off
		from dbo.tbl_Patient p 
		where coalesce(p.OptOffStatId, 0) = 1
	)); 
	/*Delete Followups */
	Delete from dbo.tbl_followUp 
	where  patientID in 
	( 	    
		SELECT patid --patients who have fully opted off
		from dbo.tbl_Patient p 
		where coalesce(p.OptOffStatId, 0) = 1
	);  



	/*SQL 3: Validate follow ups where last operation was not reversal*/
	With LstOpDtls(PatId, LstOpId,LstOpStat, LstOptype) 
	as 
	(
	  /*Getting last operation details*/
	  select po.PatientId, po.OpId, po.OpStat, case when po.OpStat = 0 then po.OpType else po.OpRevType end  
	  from tbl_PatientOperation po 
		   inner join (select po1.patientId patientId, MAX(po1.opDate) opDate from tbl_PatientOperation po1 group by po1.PatientId) LstOp 
		   on LstOp.patientId = po.PatientId and LstOp.opDate = po.OpDate
	),
	ValidFU(FUID) as
	(
	  Select FUID 
	  from tbl_FollowUp fu /*Find follow ups for primary that have been stopped but last op now is not reversal*/
		   inner join tbl_PatientOperation po on po.OpId = fu.OperationId and po.OpStat = 0
		   inner join tbl_Patient p on p.PatId = po.PatientId and p.OptOffStatId in (0,2)
		   inner join LstOpDtls on LstOpDtls.PatId = fu.PatientId and LstOpDtls.LstOpStat = 1 and  LstOpDtls.LstOptype <> 11
	  where 
	  --Only future follow Ups get activated
	  FUDate >= GETDATE() 
	  --Follow Ups for abondoned primary are still to be ignored 
	  and coalesce(ProcAban , 0) <> 1 
	  --NOTE: This is to avoid getting invalid FU updated - make sure this harded value matches SQL 6
	  and BatchUpdateReason NOT IN ('MULTIPLE 30 DAY FU' , '2 FU NOT DONE - LTFU') 
	  --Activate only inactive FU 
	  and fuval = 3
	)     
	Update tbl_FollowUp set  FUVal = 4, batchUpdatereason = 'LST OP NOT REVERSAL NOW', LastUpdatedBy = 'CIDMU_SP', LastUpdatedDateTime = GETDATE()         
	where FUId in (select ValidFU.FUID from ValidFU );
		 
 	

	/*SQL 4: InValidate follow ups where last operation was reversal*/
	With LstOpDtls(PatId, LstOpId,LstOpStat, LstOptype) 
	as 
	(
	  /*Getting last operation details*/
	  select po.PatientId, po.OpId, po.OpStat, case when po.OpStat = 0 then po.OpType else po.OpRevType end  
	  from tbl_PatientOperation po 
		   inner join (select po1.patientId patientId, MAX(po1.opDate) opDate from tbl_PatientOperation po1 group by po1.PatientId) LstOp 
		   on LstOp.patientId = po.PatientId and LstOp.opDate = po.OpDate
	),
	InValidFU(FUID) as
	(
	  Select FUID 
	  from tbl_FollowUp fu /*Find follow ups for primary that have been stopped but last op now is not reversal*/
		   inner join tbl_PatientOperation po on po.OpId = fu.OperationId and po.OpStat = 0
		   inner join LstOpDtls on LstOpDtls.PatId = fu.PatientId and LstOpDtls.LstOpStat = 1 and  LstOpDtls.LstOptype = 11
	  where FUVal not in (2,3) 
	)  
	/* Surgical Reversal - Updating 30day followup with FUVAL = 5 with Annual Followups FUVal=3 */               
	Update tbl_FollowUp set  FUVal = case when FUPeriodId > 0 then 3 else 5 end , batchUpdatereason = 'LST OP REVERSAL', LastUpdatedBy = 'CIDMU_SP', LastUpdatedDateTime = GETDATE()         
	where FUId in (select InValidFU.FUID from InValidFU ); --and FUPeriodId =0;
	


	/*SQL 5: InValidate follow ups for procedure abandoned*/ 	
	Update tbl_followUp SET FUVal = 3, batchUpdatereason = 'PROC ABAN', LastUpdatedBy = 'CIDMU_SP', LastUpdatedDateTime = GETDATE()  
	where  FUVal not in (2, 3) 
		   and OperationId in (Select OpID from tbl_PatientOperation where coalesce(ProcAban , 0) = 1) ;


    /* 15-02-2016 - This code is no longer required as the user can update the data in the application itself  */
	/*SQL 6: Change multiple follow ups - keep only the last validated*/ 	
	/*In case of multiple pending “30 day” follow ups for the same patient the latest follow up is the only follow up recorded as due. */   	
	/*
	With 
	--Patients with multiple FU
	tbl_PatWithMulFU(PatWithMulFU) as
		(select patientID from tbl_FollowUp where FUVal in (0,1) group by  patientID having COUNT(*) > 1),
	--Latest FU for FUPeriodId =0  
	tbl_LastFollowUp(PatID, LatestFuDate) as
	(select tbl_FollowUp.PatientId, MAX(FUDate) from tbl_FollowUp inner join 
	 tbl_PatientOperation on OpId = OperationId 
	 where coalesce(FUVal, 0) in (0, 1) and FUPeriodId = 0
	 and tbl_FollowUp.PatientId in (SELECT PatWithMulFU from tbl_PatWithMulFU) 
	 group by tbl_FollowUp.PatientId ),
	--Identifying Invalid FUs 	
	tbl_InvalidFollowUp(PatID, FUID) as
	(select f.PatientId, FUID from tbl_LastFollowUp 
	 inner join tbl_FollowUp f on PatID = PatientId and LatestFuDate > FUDATE 
	 inner join tbl_PatientOperation o on o.OpId = OperationId where coalesce(FUVal, 0) in (0, 1) and FUPeriodId = 0)
	--Updating all 0 FUPeriodID FUs   
	update tbl_FollowUp set FUVal = 2, SEId1 = 1, ReasonOther ='Not specified', batchUpdatereason = 'MULTIPLE 30 DAY FU', 
						LastUpdatedBy = 'CIDMU_SP', LastUpdatedDateTime = GETDATE() 
	   where FUId in (select FUID  from tbl_InvalidFollowUp);	
	*/       

	/*SQL 7: Inserting complication*/
	insert into tbl_PatientComplications(FuId, ComplicationId )
	select FUId, com.id from tbl_FollowUp inner join tlkp_Complications com on  com.Description = 'Other' 
	where FUVal = 3 and SEId1 = 1 and ReasonOther ='Not specified' and (cast(FUId as CHAR(6)) + 'n' + cast(com.id as CHAR(2)))  not in 
	(select (cast(pComp.FUId as CHAR(6)) + 'n' + cast(pComp.ComplicationId as CHAR(2)))  from tbl_PatientComplications pComp)
	END


   /*SQL 8: Marking NOT DUE followups as due when current date becomes equal to or greater than today's date */   
     update tbl_FollowUp set FUVal = 0, batchUpdatereason = 'FU DUE', LastUpdatedBy = 'CIDMU_SP', LastUpdatedDateTime = GETDATE() 
            where GETDATE() >= FUDate and coalesce(FUVal,0) = 4;
            
            
	/* 15-02-2016*/
	/*SQL 9:  Reinstate valid Annual FU's to FUVAL = 0 from the original operation  */
	With
	SurgicalReversalDtls  as (select po1.patientid,po1.opid,po1.opdate from tbl_patientoperation po1
	inner join tbl_patientoperation po2 on po2.opid != po1.opid 
	and po2.oprevtype=11
	and po1.opdate > po2.opdate
	and po1.patientid = po2.patientid) 
 
	update f  set fuval=0 
	from tbl_followup f
	inner join SurgicalReversalDtls srdt on srdt.patientid = f.patientid
	and f.fuperiodid >0
	and f.fudate > srdt.opdate
  


GO


