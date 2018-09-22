

/****** Object:  StoredProcedure [dbo].[usp_RSSR_ReasonsForPort_ReOP]    Script Date: 12/17/2014 10:37:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_RSSR_ReasonsForPort_ReOP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_RSSR_ReasonsForPort_ReOP]
GO


/****** Object:  StoredProcedure [dbo].[usp_RSSR_ReasonsForPort_ReOP]    Script Date: 12/17/2014 10:37:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*Generates count of Patients for each type of operation and SE reason */
CREATE PROCEDURE [dbo].[usp_RSSR_ReasonsForPort_ReOP]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date
AS
BEGIN		
  		
	exec [usp_SurgeonRpt_ReasonsForPort] @pSiteId, @pSurgeonId, @pOpDateFrom, @pOpDateTo, 0, 0


END










GO


