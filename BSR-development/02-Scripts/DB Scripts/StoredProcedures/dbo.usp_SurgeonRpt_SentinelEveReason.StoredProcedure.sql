/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_SentinelEveReason]    Script Date: 13-11-2017 03:31:50 PM ******/
DROP PROCEDURE [dbo].[usp_SurgeonRpt_SentinelEveReason]
GO
/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_SentinelEveReason]    Script Date: 13-11-2017 03:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Generates count of Patients for each type of operation and SE reason */
CREATE PROCEDURE [dbo].[usp_SurgeonRpt_SentinelEveReason]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date,
	@pRunForLegacyOnly int
AS
BEGIN		
  		
	exec [usp_SurgeonRpt_Reasons] @pSiteId, @pSurgeonId, @pOpDateFrom, @pOpDateTo, 1, @pRunForLegacyOnly


END

GO
