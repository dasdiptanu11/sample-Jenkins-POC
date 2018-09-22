

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_ReasonsForSlip_SE]    Script Date: 02/13/2015 11:42:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SurgeonRpt_ReasonsForSlip_SE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SurgeonRpt_ReasonsForSlip_SE]
GO


/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_ReasonsForSlip_SE]    Script Date: 02/13/2015 11:42:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*Generates count of Patients for each type of operation and SE reason */
CREATE PROCEDURE [dbo].[usp_SurgeonRpt_ReasonsForSlip_SE]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date,
	@pRunForLegacyOnly int
	
AS
BEGIN		
  		
	exec [usp_SurgeonRpt_ReasonsForSlip] @pSiteId, @pSurgeonId, @pOpDateFrom, @pOpDateTo, 1, @pRunForLegacyOnly


END










GO


