
/****** Object:  StoredProcedure [dbo].[usp_ValidateFollowUpsForPatID]    Script Date: 04/20/2015 10:55:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ValidateFollowUpsForPatID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ValidateFollowUpsForPatID]
GO


/****** Object:  StoredProcedure [dbo].[usp_ValidateFollowUpsForPatID]    Script Date: 04/20/2015 10:55:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_ValidateFollowUpsForPatID]
@pPatID int,
@pReason char(100)
AS
BEGIN


     /*Marking followups as due */   
     update tbl_FollowUp set FUVal = 4, batchUpdatereason = @pReason, 
                             LastUpdatedBy = 'CIDMU_SP', LastUpdatedDateTime = GETDATE()   
            where coalesce(FUVal,0) = 3 and PatientId = @pPatID and FUPeriodId >= 
            (select min(FUPeriodId) from tbl_FollowUp  where PatientId = @pPatID 
             and DATEDIFF(DAY,FUDATE , GETDATE()) > 0 and DATEDIFF(DAY,FUDATE , GETDATE())  < 365);
    
    
END



GO


