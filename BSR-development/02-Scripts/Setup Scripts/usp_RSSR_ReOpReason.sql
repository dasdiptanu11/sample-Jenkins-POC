
/****** Object:  StoredProcedure [dbo].[usp_RSSR_ReOpReason]    Script Date: 12/17/2014 10:38:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_RSSR_ReOpReason]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_RSSR_ReOpReason]
GO


/****** Object:  StoredProcedure [dbo].[usp_RSSR_ReOpReason]    Script Date: 12/17/2014 10:38:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*Generates count of Patients for each type of operation and SE reason */
CREATE PROCEDURE [dbo].[usp_RSSR_ReOpReason]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date
AS

BEGIN		
  		
	exec [usp_SurgeonRpt_Reasons] @pSiteId, @pSurgeonId, @pOpDateFrom, @pOpDateTo,0, 0


END



GO


