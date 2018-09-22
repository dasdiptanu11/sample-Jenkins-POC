
GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_ReOpReason]    Script Date: 06/02/2016 13:51:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SurgeonRpt_ReOpReason]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SurgeonRpt_ReOpReason]
GO


GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_ReOpReason]    Script Date: 06/02/2016 13:51:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*Generates count of Patients for each type of operation and SE reason */
CREATE PROCEDURE [dbo].[usp_SurgeonRpt_ReOpReason]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date,
	@pRunForLegacyOnly int
AS

BEGIN		
  		
	exec [usp_SurgeonRpt_Reasons] @pSiteId, @pSurgeonId, @pOpDateFrom, @pOpDateTo,0, @pRunForLegacyOnly


END





GO


