/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_ReasonsForPort_SE]    Script Date: 13-11-2017 03:31:50 PM ******/
DROP PROCEDURE [dbo].[usp_SurgeonRpt_ReasonsForPort_SE]
GO
/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_ReasonsForPort_SE]    Script Date: 13-11-2017 03:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Generates count of Patients for each type of operation and SE reason */
CREATE PROCEDURE [dbo].[usp_SurgeonRpt_ReasonsForPort_SE]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date, 
	@pRunForLegacyOnly int
AS
BEGIN		
  		
	exec [usp_SurgeonRpt_ReasonsForPort] @pSiteId, @pSurgeonId, @pOpDateFrom, @pOpDateTo, 1, @pRunForLegacyOnly


END

GO
