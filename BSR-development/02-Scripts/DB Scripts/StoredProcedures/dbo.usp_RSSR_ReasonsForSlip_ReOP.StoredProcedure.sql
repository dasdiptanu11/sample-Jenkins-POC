/****** Object:  StoredProcedure [dbo].[usp_RSSR_ReasonsForSlip_ReOP]    Script Date: 13-11-2017 03:31:50 PM ******/
DROP PROCEDURE [dbo].[usp_RSSR_ReasonsForSlip_ReOP]
GO
/****** Object:  StoredProcedure [dbo].[usp_RSSR_ReasonsForSlip_ReOP]    Script Date: 13-11-2017 03:31:50 PM ******/
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
