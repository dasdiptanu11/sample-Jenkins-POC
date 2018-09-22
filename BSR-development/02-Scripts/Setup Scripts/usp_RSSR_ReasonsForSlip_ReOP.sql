/****** Object:  StoredProcedure [dbo].[usp_RSSR_ReasonsForSlip_ReOP]    Script Date: 12/17/2014 10:37:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_RSSR_ReasonsForSlip_ReOP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_RSSR_ReasonsForSlip_ReOP]
GO


/****** Object:  StoredProcedure [dbo].[usp_RSSR_ReasonsForSlip_ReOP]    Script Date: 12/17/2014 10:37:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*Generates count of Patients for each type of operation and SE reason */
CREATE PROCEDURE [dbo].[usp_RSSR_ReasonsForSlip_ReOP]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date
AS
BEGIN		
  		
	exec [usp_SurgeonRpt_ReasonsForSlip] @pSiteId, @pSurgeonId, @pOpDateFrom, @pOpDateTo, 0, 0


END










GO


