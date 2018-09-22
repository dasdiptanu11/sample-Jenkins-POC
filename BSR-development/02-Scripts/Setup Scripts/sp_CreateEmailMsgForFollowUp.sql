
/****** Object:  StoredProcedure [dbo].[CreateEmailForFollowUp]    Script Date: 09/18/2014 11:17:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateEmailForFollowUp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreateEmailForFollowUp]
GO


/****** Object:  StoredProcedure [dbo].[CreateEmailForFollowUp]    Script Date: 09/18/2014 11:17:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CreateEmailForFollowUp]
AS

Begin 

	Declare @Result int
	Set @Result = -1
	Declare @Surg NVarchar(50), @SurgName NVarchar(150),  @message NVarchar(150), @SurgEmail NVarchar(150)
	Declare @patientListForFollowUp NVarchar(150) , @MessageDetails NVarchar(1500)
	Declare @FUId int, @OpID int

	DECLARE _Surgeon CURSOR FOR 
    select distinct u.UserId Surg
		from tbl_FollowUp fu
		inner join  tbl_PatientOperation po on fu.PatientId = po.PatientId and fu.OperationId = po.OpId   
		inner join  tbl_User u on po.Surg = u.UserId
		where coalesce(FUVal, '') <> 2 and (EmailSentToSurg is null or EmailSentToSurg <> 1)
		
		open _Surgeon
						
		FETCH NEXT FROM _Surgeon 
		INTO @Surg
		
		
		WHILE (@@FETCH_STATUS =0) 
		BEGIN    
		
		set @patientListForFollowUp = 'Follow up(s) due for: '
		set @MessageDetails = ''
		
		
		print @patientListForFollowUp
		
			DECLARE _MsgForSurg CURSOR FOR 			
			select fu.FUId,
			    (p.FName + ' ' + p.LastName + '(Op ID:' + cast(po.OpId as NVarchar(5)) + ') - ' + fu1.Description + ', ')
				, u.FName + ' ' + u.LastName , aum.Email, po.OpID 
				from tbl_FollowUp fu
				inner join  tlkp_FollowUpPeriod fu1 on fu1.Id = fu.FUPeriodId 
				inner join  tbl_PatientOperation po on fu.PatientId = po.PatientId and fu.OperationId = po.OpId   
				inner join tbl_Patient p on p.PatId = po.PatientId
				inner join  tbl_Site ts on ts.SiteId  = po.Hosp 
				inner join  tbl_User u on p.PriSurgId = u.UserId
				inner join  aspnet_Membership aum on u.UId = aum.UserId
				where coalesce(FUVal, '') <> 2 and u.UserId = @Surg
				and (EmailSentToSurg is null or EmailSentToSurg <> 1)
				order by aum.Email		
			
	
			Open _MsgForSurg		
			FETCH NEXT FROM _MsgForSurg 
			INTO @FUId, @message, @SurgName, @SurgEmail, @OpID
			
					
				WHILE (@@FETCH_STATUS =0) 
				BEGIN 
				
					
				set @MessageDetails = @MessageDetails + @message
			  
				insert into dbo.TempFollowUp2([FUId], [OpId], [SurgeonEmail] , [CurrentDate] )
				values (@FUId, @OpID, @SurgEmail, GETDATE())
			    	    
		  		FETCH NEXT FROM _MsgForSurg 
				INTO @FUId, @message, @SurgName, @SurgEmail, @OpID
			
				END			    
				
		    CLOSE _MsgForSurg
		  
		  --print 'End for Doctor ' + @Surg
		 
		  --print '@MessageDetails - ' + @MessageDetails
		 if (@MessageDetails != '') 
		 Begin 
				set @patientListForFollowUp = @patientListForFollowUp + @MessageDetails
		    	insert into dbo.TempFollowUp ([Message], [SurgeonName], [SurgeonEmail], [CurrentDate] )
				values (@patientListForFollowUp, @SurgName, @SurgEmail, GETDATE())		    
				--print 'Inserted rec for Doctor ' + @Surg + '- ' + @patientListForFollowUp
		 end 
		    
		    DEALLOCATE _MsgForSurg
		    
		    FETCH NEXT FROM _Surgeon 
		    INTO @Surg
		    
		
		END		
		CLOSE _Surgeon		
		DEALLOCATE _Surgeon
		set @Result = 0
END





GO


